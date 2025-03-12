# AWS Cloud Shell tools


## Software tools

**Pre installed**

- `tmux`
- `kubectl`
- `git`
- `jq`
- `aws`
- `python`
---

**Additional installed tools**

- `bash`
- `yq`
- `helm`
- `kustomize`
- `fzf`
- `fluxcd`

---
## Installation

```sh
## - Get cloudshell-tools installation scripts.
git clone https://github.com/true-cloud-platform/aws-cloudshell-tools.git .cloudshell-tools

## - Install tools
.cloudshell-tools/install.sh

## - Restart cloudshell
exit

```

---
## Usage

### Aliases command

- `ks` Select K8S cluster.
- `ns` select namespace.
- `k` for `kubectl`

---