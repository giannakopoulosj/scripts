#!/bin/bash

# Get all deployments and statefulsets in the cluster
scaleDownResources=$(oc get deployments,statefulsets -n $1 -o=jsonpath='{range .items[*]}{.kind}{"\t"}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}')

# Loop through each resource
while IFS=$'\t' read -r kind namespace resource; do
    # Skip if kind is "List"
    if [ "$kind" != "List" ]; then
        # Set replicas to 0
        oc scale "$kind" --replicas=0 -n "$namespace" "$resource"
        echo "Set $kind $resource in namespace $namespace to 0 replicas."
    fi
done <<< "$scaleDownResources"
