terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

variable "kubernetes_client_config" {
  type = object({
    host                   = string
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
  sensitive = true
}

provider "kubernetes" {
  host = var.kubernetes_client_config.host

  client_certificate     = var.kubernetes_client_config.client_certificate
  client_key             = var.kubernetes_client_config.client_key
  cluster_ca_certificate = var.kubernetes_client_config.cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = var.kubernetes_client_config.host
    client_certificate     = var.kubernetes_client_config.client_certificate
    client_key             = var.kubernetes_client_config.client_key
    cluster_ca_certificate = var.kubernetes_client_config.cluster_ca_certificate
  }
}

