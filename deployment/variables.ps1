# Set variables to be used in the scripts in other demos
# to use from differnt .ps1 file
# . ./Variables.ps1

# General
$Region = 'westeurope'  # region to deploy
$RG = 'RG_ampersand'  # resource group name
$RG_nodepool = 'RG_ampersand_aks'
$Sub = '87ed0a39-2947-4772-96ad-78806e5abc69'  # subscription id
$Tenant = 'ordinanlosd.onmicrosoft.com'  # Ordina N.V. --> MTech (personal: ordinaweb.onmicrosoft.com)

# Azure Container Registry
$acrName = 'ampersandrap'
$acrImage = 'ampersand-rap:' + (Get-Date -Format "yyyy-dd-MM")

# Kubernetes Cluster configuration
$AKSCluster = 'ampersand-rap-aks' # cluster name
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
$DIR_INGRESS = 'ingress'
$DIR_RESOURCES = 'resources'
$DBNAME = 'rap-db'
$MANIFEST = 'rap-manifest.yaml'