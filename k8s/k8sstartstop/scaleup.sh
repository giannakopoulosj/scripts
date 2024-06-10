#!/bin/bash

# Define resources to scale to 2 replicas
resources_to_scale_up=("elasticsearch-master")

# Get all deployments and statefulsets in the cluster
scaleUpResources=$(oc get deployments,statefulsets -n $1 -o=jsonpath='{range .items[*]}{.kind}{"\t"}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}')

while IFS=$'\t' read -r kind namespace resource; do
    # Skip if kind is "List"
    if [ "$kind" != "List" ]; then
       
        # Check if the current resource is in the list of resources to scale up
        if [[ " ${resources_to_scale_up[@]} " =~ " $resource " ]]; then
            # Set replicas to 2 for resources in the list
            oc scale "$kind" --replicas=2 -n "$namespace" "$resource"
            echo "Set $kind $resource in namespace $namespace to 2 replicas."
        else
            # Set replicas to 0 for other resources
            oc scale "$kind" --replicas=1 -n "$namespace" "$resource"
            echo "Set $kind $resource in namespace $namespace to 1 replicas."
        fi
    fi
done <<< "$scaleUpResources"
