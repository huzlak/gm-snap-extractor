# gm-snap-extractor
extract k8s object from gm input snapshot

# Usage example
```
bash extract-snapshot.sh --input-file input.json --resources "/v1, Kind=Namespace;networking.gloo.solo.io/v2, Kind=RouteTable;admin.gloo.solo.io/v2, Kind=Workspace;admin.gloo.solo.io/v2, Kind=WorkspaceSettings;security.policy.gloo.solo.io/v2, Kind=JWTPolicy;networking.gloo.solo.io/v2, Kind=ExternalService;networking.gloo.solo.io/v2, Kind=VirtualGateway;/v1, Kind=Service" --old-cluster oldcluster1 --new-cluster newcluster1
```

# Limitations
- Need to be careful which objects you're applying as they might conflict with common system resources like namespaces/services etc.
- Only supports single cluster environment
