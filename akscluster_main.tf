#Add Azure Provider
provider "azurerm" {

subscription_id = "300f0cbb-9a29-423e-afb3-66eb7941fb0b"
client_id       = "1d004ebb-2482-440d-82a0-e22b3dfe8025"
client_secret   = "XsQJ9N-paM38HIYfC_6LZvB_Lp4I_ik1l-"
tenant_id       = "360286fd-ae5d-4a12-9aee-0790e0d53ca9"

    features {}
}

resource "azurerm_resource_group" "k8s" {
    name     = "AKC_RG"
    location = var.AKS_RG_location
}


resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

# azure  log analytics workspace 


resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = "k8sdns"

    linux_profile {
        admin_username = "ubuntu"
    

        ssh_key {
            key_data = "${trimspace(tls_private_key.key.public_key_openssh)} ${var.admin_username}@azure.com"
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_D2s_v3"
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    # addon is here

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    tags = {
        Environment = "Development"
    }

}
resource "tls_private_key" "key" {
    algorithm = "RSA"
}

resource "null_resource" "save-key" {
    triggers = {
        key = "${tls_private_key.key.private_key_pem}"

    }
}

#output

output "host" {
    value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"

}

output "configure" {
    value = <<configure
    Run the following commands to configure kubernetes client :
    $ terraform output kube_config > ~/.kube/aksconfig
    $ export KUBECONFIG=~/.kube/askconfig

    Test configuration using kubectl
    $ kubectl get nodes

configure


}
