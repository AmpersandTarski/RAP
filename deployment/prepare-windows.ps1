# Check for prerequisites 

# run commands as admin from VS code
# start VS code as administrator
Set-ExecutionPolicy -ExecutionPolicy  Unrestricted -Scope Process

# Install-Module -Name powershell-yaml 
Import-Module powershell-yaml

# Optional Windows: have chocolatey installed (software management automation tool)
# https://chocolatey.org/install
choco -v

# GIT: 
# https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
git version  # check if installed

# Azure CLI
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli
az - v
choco install azure-cli

# KUBECTL
# https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
kubectl version --short
choco install kubernetes-cli

# HELM: 
# https://helm.sh/docs/intro/install/
helm version  # check if installed
choco install helm  # run as admin!

# OPENSSL:
choco install openssl
# create a 32-bit random string
openssl rand -base64 32  # run as admin!

# BASE64:
choco install base64  # run as admin!