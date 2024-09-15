variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "region" {
  description = "Cluster region"
  type        = string
}

variable "project" {
  description = "Cluster project"
  type        = string
}

variable "network" {
  description = "Nodes network (name or link)"
  type        = string
}

variable "subnetwork" {
  description = "Nodes subnet (name or link)"
  type        = string
}

variable "ip_range_pods" {
  description = "Pods secondary range"

  type = string
}

variable "ip_range_services" {
  description = "Secondary range for services"
  type        = string
}

variable "master_range" {
  description = "IP range for GKE control plane /28"
  type        = string
}

variable "metering_dataset_id" {
  description = "BQ dataset id for metering"
  type        = string
}

variable "max_cpu" {
  type        = number
  description = "Maximum number of CPUs (for cluster autoscaler)"
  default     = 32
}

variable "max_memory" {
  type        = number
  description = "Maximum cluster memory GB (for cluster autoscaler)"
  default     = 128
}

variable "max_nvidia_v100" {
  type        = number
  description = "Maximum no. of V100 GPUs (for cluster autoscaler)"
  default     = 1
}

variable "max_nvidia_k80" {
  type        = number
  description = "Maximum no. of K80 GPUs (for cluster autoscaler)"
  default     = 1
}

variable "max_nvidia_p100" {
  type        = number
  description = "Maximum no. of P100 GPUs (for cluster autoscaler)"
  default     = 1
}
