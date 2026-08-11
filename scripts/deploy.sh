#!/bin/bash

set -u

# ==========================================
# Kubernetes Complete Deployment Script
# ==========================================

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo " Kubernetes Project Deployment"
echo "=========================================="
echo ""
echo "Project: $PROJECT_ROOT"
echo ""

# ------------------------------------------
# Check kubectl
# ------------------------------------------

if ! command -v kubectl >/dev/null 2>&1; then
    echo "❌ kubectl is not installed."
    exit 1
fi

echo "✅ kubectl found"
echo ""

# ------------------------------------------
# Check Kubernetes cluster
# ------------------------------------------

echo "Checking Kubernetes cluster..."

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "❌ Kubernetes cluster is not reachable."
    exit 1
fi

echo "✅ Kubernetes cluster is reachable"
echo ""

# ------------------------------------------
# Apply folders in order
# ------------------------------------------

for folder in "$PROJECT_ROOT"/[0-9][0-9]-*/; do

    # Folder doesn't exist
    [ -d "$folder" ] || continue

    folder_name=$(basename "$folder")

    echo ""
    echo "------------------------------------------"
    echo "📁 Applying: $folder_name"
    echo "------------------------------------------"

    # Check YAML files
    yaml_files=()

    while IFS= read -r -d '' file; do
        yaml_files+=("$file")
    done < <(find "$folder" -maxdepth 1 -type f \( -name "*.yaml" -o -name "*.yml" \) -print0 | sort -z)

    # No YAML files
    if [ ${#yaml_files[@]} -eq 0 ]; then
        echo "⚠️  No YAML files found."
        continue
    fi

    # Apply each YAML
    folder_failed=false

    for file in "${yaml_files[@]}"; do

        file_name=$(basename "$file")

        echo ""
        echo "  Applying: $file_name"

        if kubectl apply -f "$file"; then
            echo "  ✅ $file_name applied successfully"
        else
            echo "  ❌ $file_name failed"
            folder_failed=true
        fi

    done

    # Folder result
    if [ "$folder_failed" = true ]; then
        echo ""
        echo "❌ $folder_name completed with errors."
    else
        echo ""
        echo "✅ $folder_name applied successfully."
    fi

done

# ------------------------------------------
# Final status
# ------------------------------------------

echo ""
echo "=========================================="
echo " Deployment Finished"
echo "=========================================="
echo ""

echo "📌 Nodes:"
kubectl get nodes

echo ""
echo "📌 Pods:"
kubectl get pods -A

echo ""
echo "📌 Services:"
kubectl get svc -A

echo ""
echo "=========================================="
echo " ✅ All folders have been processed."
echo "=========================================="