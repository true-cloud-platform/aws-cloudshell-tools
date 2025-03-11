#!/bin/bash


## - Function select eks-cluster
select_eks_cluster() {
  # Define the list of clusters (MOCK)
  # clusters=("prod-cluster" "dev-cluster" "test-cluster" "staging-cluster" "analytics-cluster")

  # Get list of clusters from AWS CLI
  clusters=$(
    aws eks list-clusters --query "clusters" --output json | jq -r '.[]'
  )

  # Use fzf for cluster selection
  local selected_cluster=$(printf "%s\n" "${clusters[@]}" | fzf --prompt="Choose your cluster > " --header="Available Clusters:" --height=10 --border)

  # return
  echo $selected_cluster
}


## - Function update-kubeconfig
update_kubeconfig() {
  # Get the selected cluster
  local selected_cluster=$(select_eks_cluster)

  kubeconfig_file="$(mktemp -t "${selected_cluster}.yaml")"

  # Update kubeconfig
  aws eks update-kubeconfig --name $selected_cluster --kubeconfig $kubeconfig_file

  if [[ $? -eq 0 ]]; then
    echo "Kubeconfig updated successfully"
    export KUBECONFIG=$kubeconfig_file
  else
    echo "Error updating kubeconfig"
    exit 1
  fi
}


## - Main scripts




