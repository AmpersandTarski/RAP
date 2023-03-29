# Set variables to be used in the scripts in other demos
# to use from differnt .ps1 file
# . ./Variables.ps1

# General
$Region = 'westeurope'  # region to deploy
$RG = 'RG_ampersand_frte'  # resource group name
$RG_nodepool = 'RG_ampersand_frte_aks'
$Sub = '9d3a906e-dd9f-45e1-8bd0-76fe25fbec37'  # subscription id
$Tenant = 'ordinaweb.onmicrosoft.com'  # Ordina N.V. --> MTech (personal: ordinaweb.onmicrosoft.com)

# Azure Container Registry
$acrName = 'ampersandrapfrte'
$acrImage = 'ampersand-rap:' + (Get-Date -Format "yyyy-dd-MM")

# Kubernetes Cluster configuration
$AKSCluster = 'ampersand-rap-aks-frte' # cluster name
$AKSClusterPublicIp = ($AKSCluster + '-public-ip') # cluster name
$NodePoolName = 'ampersand'
$nodes = '2'
$VMsize = 'Standard_B2s'

# MariaDB
$MariaDbName = 'rap4-db'

# DNS domain name
$DOMAIN = 'ampersand-tarksi.com'

# deployment variables
$NAMESPACE = 'rap'
$DBNAME = 'rap-db'