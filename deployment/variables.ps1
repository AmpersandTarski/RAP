# Set variables to be used in the scripts in other demos
# to use from differnt .ps1 file
# . ./Variables.ps1

# General
$Region = 'westeurope'  # region to deploy
$RG = 'ampersand-rap-rg'  # resource group name
$Sub = '116deae5-2095-4a53-be28-e4b5b445ad78'  # subscription id

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