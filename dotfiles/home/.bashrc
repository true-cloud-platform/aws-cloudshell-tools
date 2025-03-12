#
# ~/.bashrc
#

# Source global definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      source "$rc"
    fi
  done
fi

####################################
# Custom Environment Variables
####################################

# global
EDITOR="/usr/bin/vi"

# bat
# BAT_THEME="Solarized (dark)"

# fzf
export FZF_TMUX_HEIGHT=40%
export FZF_CTRL_SPACE_COMMAND="(fd -tf -tl -td -d 1 . ~/Downloads && fd -tf -tl -td -d 1 . $pwd)"
export FZF_CTRL_SPACE_OPTS="--preview 'bat --style=numbers --color=always {}'"
export FZF_WORKSPACE_COMMAND="(echo ~/Downloads/ &&  find ~/workspace -type d -name '.git' | sed -E 's:/.git$::g' 2> /dev/null)"

source ~/.fzf/fzf-key-binding.bash

#####################################
# Custom modifications
####################################

# VI editing mode
set -o vi

# Enable tabs 2
tabs 2

# Solarized terminal color code
source ~/.ps1/color-scheme.sh

# Import prompt functions
source ~/.ps1/k8s-ps1.sh


####################################

for file in /etc/bash_completion.d/*; do
  [ -r "$file" ] && source "$file"
done

# Aws cli
complete -C '$(which aws_completer)' aws

# AWS Code commit
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

# kubectl
source <(kubectl completion bash)
alias k='kubectl'
complete -o default -F __start_kubectl k

# helm
source <(helm completion bash)

# kustomize
complete -o default -C kustomize kustomize

# flux
complete -o default -C flux flux

# sops
complete -o default -C sops sops

# eksctl
source <(eksctl completion bash)

# kubeselect kubens
# alias ks='eval $(kubeselect select)'
# alias ks='export KUBECONFIG="$(ls ~/.kube/*.yaml | fzf)"'
alias ks='update_kubeconfig'

#alias ns='kubens'
function ns {
  selected_ns=$(kubectl get ns -o name |awk -F / '{print $2}' | fzf)
  kubectl config set-context --current --namespace=$selected_ns
}

# watch
alias watch='watch '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*|screen*|tmux*)
    # PROMPT_COMMAND="user_color > /dev/null; k8s_user_color; git_branch > /dev/null;"
    PROMPT_COMMAND="user_color > /dev/null; k8s_user_color > /dev/null;"

    # Use PS1 in /opt/bash/ps1-functions.sh
    PS1=$MODERN_PS1

    ;;
  *)
    # PROMPT_COMMAND="git_branch > /dev/null;"
    setterm -cursor on
    cursor_styles="\e[?${cursor_style_full_block};"
    PS1='\n\[$bracketcolor\][\[$cwdcolor\]\W\[$bracketcolor\]] \[${fg_cyan}\]${g_group_open}\[${fg_cyan}\]${g_branch}\[${fg_cyan}\]${g_group_close}\[${reset}\]\[$fg_white\]\$\[$resetcolor\] '

    ;;
esac

export PS1