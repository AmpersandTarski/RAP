# Set variables to be used in the scripts in other demos
# to use from differnt .ps1 file
# . ./Variables.ps1

# General
$Region='westeurope'  # region to deploy
$RG='ampersand-rap-rg'  # resource group name
$Sub='116deae5-2095-4a53-be28-e4b5b445ad78'  # subscription id

# Kubernetes Cluster configuration
$AKSCluster='ampersand-rap-aks' # cluster name
$NodePoolName='ampersand'
$nodes='1'
$VMsize='Standard_B2s'

# Get your tenant's name
# Start-Process "https://portal.azure.com/#settings/directory" # Get domain name
$TenantName='ordinaweb.onmicrosoft.com'

# MariaDB
$MariaDbName='rap4-db'