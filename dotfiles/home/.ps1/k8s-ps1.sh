#!/bin/bash

function user_color {
  p_user="$HOSTNAME"

  is_root=$(whoami)
  if [[ "${is_root}" == "root" ]]; then
    export usercolor="${bold}${fg_red}"
  else
    export usercolor="${bold}${fg_yellow}"
  fi
}

function k8s_user_color {
  # Set default (dummy) KUBECONFIG
  if [[ -z $KUBECONFIG ]]; then
    # export KUBECONFIG="${HOME}/.kube/config"
    k8s_usercolor=""
    p_k8suser=""
    p_namespace=""
  fi

  # kubeconfig per session
  if [[ ! ${KUBECONFIG} =~ /tmp/kubectx.* ]]; then
    kubeconfig_tmpfile="$(mktemp -t "kubectx.XXXXXX")"

    if [[ -f ${KUBECONFIG} ]]; then
      cp ${KUBECONFIG} ${kubeconfig_tmpfile}
      export KUBECONFIG=${kubeconfig_tmpfile}
    fi
  fi

  # Unset KUBECONFIG if no contexts
  if [[ -z $(yq e '.contexts //""' $KUBECONFIG) ]]; then
    cp $KUBECONFIG ~/.kube/config
    unset KUBECONFIG
  fi

  if [[ -n $KUBECONFIG  && -f $KUBECONFIG ]]; then
    default_kubectx=$(yq e '.contexts[0].name' $KUBECONFIG | sed 's/null//')
    export selected_kubectx=${KUBECTX:-$default_kubectx}

    # Noted. $KUBECTX is from kubectx
    # edit current context from $KUBECTX
    # yq e -i '.current-context=strenv(selected_kubectx)' $KUBECONFIG

    ps1_namespace=$(yq e '.contexts[]?|select(.name==env(selected_kubectx)).context.namespace' $KUBECONFIG | sed 's/null/default/')
    p_namespace=$(echo " ($ps1_namespace)")

    # TODO Bug
    export p_k8suser=$(yq e '.contexts[]?|select(.name==env(selected_kubectx)).context.cluster' $KUBECONFIG)
    export p_k8suser=${p_k8suser:-$USER}

    is_k8s_prod=$(yq e '.preferences.production' $KUBECONFIG)
    [[ $is_k8s_prod == "true" ]] && export k8s_usercolor=${bold}${fg_red} || export k8s_usercolor=${bold}${fg_yellow}
  fi

  if [[ -n "$k8s_usercolor" ]]; then
    export usercolor=${k8s_usercolor}
    export p_user="${p_k8suser}"
  fi
}


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
# PS1
PLAIN_PS1='\n\[$bracketcolor\][\[$usercolor\]${p_user}\[$fg_green\]$p_namespace \[$cwdcolor\]\W\[$bracketcolor\]] \[${fg_cyan}\]${g_group_open}\[${fg_green}\]${g_branch_icon}\[${fg_cyan}\]${g_branch}\[${fg_green}\]${g_upstream}\[${fg_yellow}\]${g_ahead_icon}\[${fg_cyan}\]${g_ahead}\[${fg_yellow}\]${g_behind_icon}\[${fg_cyan}\]${g_behind}\[${fg_red}\]${g_change}\[${fg_yellow}\]${g_untrack}\[${fg_cyan}\]${g_group_close}\[${reset}\]\[$fg_white\]\$\[$resetcolor\] '

MODERN_PS1='\n \[$bracketcolor\][\[$usercolor\]${p_user}\[$fg_green\]$p_namespace \[$cwdcolor\]\W\[$bracketcolor\]] \[${fg_cyan}\]${g_group_open}\[${fg_green}\]${g_branch_icon}\[${fg_cyan}\]${g_branch}\[${fg_green}\]${g_upstream}\[${fg_yellow}\]${g_ahead_icon}\[${fg_cyan}\]${g_ahead}\[${fg_yellow}\]${g_behind_icon}\[${fg_cyan}\]${g_behind}\[${fg_red}\]${g_change}\[${fg_yellow}\]${g_untrack}\[${fg_cyan}\]${g_group_close}\[${reset}\]\n\[$fg_white\] $\[$resetcolor\] '





