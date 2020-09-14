resource "azurerm_resource_group" "myakscluster" {
  name     = "myakscluster-resources"
  location = "EastUS"
}


# create the AKS Cluster
resource "azurerm_kubernetes_cluster" "myakscluster" {
  name                = "myaks-cluster"
  location            =  azurerm_resource_group.myakscluster.location
  resource_group_name =  azurerm_resource_group.myakscluster.name
  dns_prefix          = "myakscluster"
  kubernetes_version  = "1.18.6"

  default_node_pool  {
    name            = "akspool"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 50
    }
  network_profile {
    network_plugin  = "azure"
  }

  service_principal {
    client_id     = "XXXXXXXXX"
    client_secret = "XXXXXXXXX"
  }

  role_based_access_control  {
	enabled = "true"
  }
}

#resource "azurerm_public_ip" "nginx_ingress" {
#  name                = "nginx-ingress-public"
#  location            = azurerm_kubernetes_cluster.myakscluster.location
#  resource_group_name = azurerm_kubernetes_cluster.myakscluster.node_resource_group
#  allocation_method   = "Static"
#  domain_name_label   = "k8s-apache" 
#}
