#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 --input-file <file> --resources <resource1;resource2;...> --old-cluster <cluster-name> --new-cluster <cluster-name>"
    exit 1
}

# Check if the right number of arguments are provided
if [ $# -ne 8 ]; then
    usage
fi

# Parse command line arguments
while [ "$1" != "" ]; do
    case $1 in
        --input-file ) shift
                       input_file=$1
                       ;;
        --resources )  shift
                       resources=$1
                       ;;
        --old-cluster ) shift
			old_cluster=$1
			;;
        --new-cluster ) shift
			new_cluster=$1
			;;
        * )            usage
                       exit 1
    esac
    shift
done

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found!"
    exit 1
fi

# Process each resource type provided in the --resources argument
IFS=';' read -r -a resource_array <<< "$resources"
for resource in "${resource_array[@]}"; do
    cat $input_file |jq -r ".\"$resource\""|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "kube-system"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "gloo-mesh"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "gloo-mesh-addons"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "default"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "istio-system"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "istio-gateways"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "kube-public"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "kube-node-lease"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "local-path-storage"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "metallb-system"))'|
    yq 'del(.[]|select(.kind == "Namespace" and .metadata.name == "gm-iop*"))'|
    yq eval -P 'del(.[].status,.[].metadata.annotations."kubectl.kubernetes.io/last-applied-configuration",.[].metadata.annotations."cluster.solo.io/cluster",.[].metadata.creationTimestamp,.[].metadata.generation,.[].metadata.resourceVersion,.[].metadata.uid)'|
    yq '.[]|split_doc'|
    sed -e '$a---'|
    sed "s/$old_cluster/$new_cluster/g"
done
