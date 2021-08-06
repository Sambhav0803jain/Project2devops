#Add Azure Provider
provider "azurerm" {

subscription_id = "300f0cbb-9a29-423e-afb3-66eb7941fb0b"
client_id       = "1d004ebb-2482-440d-82a0-e22b3dfe8025"
client_secret   = "XsQJ9N-paM38HIYfC_6LZvB_Lp4I_ik1l-"
tenant_id       = "360286fd-ae5d-4a12-9aee-0790e0d53ca9"

    features {}
}

resource "random_string" "log_analytics_suffix" {
    length = 5
    lower = true
    special = false
    number = false
}

#Create Resource Group
resource "azurerm_resource_group" "k8s" {
    name = var.resource_group_name
    location = var.location
}



#Create AKS Cluster
    resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = "vmadmin"
        
        ssh_key {
            key_data = "${trimspace(tls_private_key.key.public_key_openssh)} vmadmin@azure.com"
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = 2
        max_pods = 50
        vm_size         = "Standard_D2_v2"
    }

    service_principal {
        client_id     = "1d004ebb-2482-440d-82a0-e22b3dfe8025"
        client_secret = "XsQJ9N-paM38HIYfC_6LZvB_Lp4I_ik1l-"
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        
        }
    }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    
}
    
