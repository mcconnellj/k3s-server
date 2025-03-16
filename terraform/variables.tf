# vars.tf
variable "ssh_user" {
  type        = string
  description = "SSH user for K3s nodes (default is ubuntu)"
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to the SSH private key for accessing nodes"
  default     = "~/.ssh/id_rsa"
}

variable "k3s_token" {
  type        = string
  description = "K3s cluster join token"
  sensitive   = true
}

variable "etcd_url" {
  type        = string
  description = "The URL of the etcd server for K3s"
  default     = "https://10.0.0.1:6443"
}

# Git and Helm variables
variable "git_repo_url" {
  type        = string
  description = "URL for the Git repo used in ArgoCD"
}

variable "git_branch" {
  type        = string
  description = "Branch of the Git repo"
  default     = "main"
}

variable "helm_chart_repo" {
  type        = string
  description = "The URL of the Helm chart repository"
}

variable "helm_chart_name" {
  type        = string
  description = "The name of the Helm chart"
}

variable "helm_chart_version" {
  type        = string
  description = "The version of the Helm chart"
  default     = "latest"
}
