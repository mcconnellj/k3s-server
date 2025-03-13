// Env vars
// ----------------------------------

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP Region"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "GCP Zone"
}

variable "app_name" {
  type        = string
  default     = "app name"
  description = "Application name"
}

variable "project_name" {
  type        = string
  default     = "k3s-server"
  description = "GCP Project name"
}

variable "bucket_name" {
  type        = string
  default     = "k3s-bucket"
  description = "Bucket name"
}

// Compute
// ----------------------------------

// The instance for K3S
resource "google_compute_instance" "k3s" {
  name         = "k3s-vm-1"
  machine_type = "e2-small" # This instance will have 2 Gb of RAM
  zone         = var.zone

  tags = ["web"]

  // Set the boot disk and the image (10 Gb)
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

    // Configuration to be a Spot Instance, to reduce costs
  scheduling {
    preemptible                 = false
    automatic_restart           = true
    provisioning_model          = "SPOT"
    instance_termination_action = "STOP"
  }

  // attach a disk for K3S
  attached_disk {
    source      = google_compute_disk.k3s_disk.id
    device_name = "k3s-disk"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  labels = {
    env       = var.env
    region    = var.region
    app       = var.app_name
    sensitive = "false"
  }

  metadata_startup_script   = file("scripts/k3s-startup.sh")
  allow_stopping_for_update = true
}

// Firewall
// ----------------------------------
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [
      "80", "443", // http/https
      "30080"      // ports opened to access the API via NodePort
    ]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

// Storage
// ----------------------------------

// The disk attached to the instance (15 Gb)
resource "google_compute_disk" "k3s_disk" {
  name = "k3s-disk"
  size = 15
  type = "pd-standard"
  zone = var.zone
}

// The bucket where you can store other data
resource "google_storage_bucket" "k3s-storage" {
  name     = var.bucket_name
  location = var.region

  labels = {
    env       = var.env
    region    = var.region
    app       = var.app_name
    sensitive = "false"
  }
}

// Registry
// ----------------------------------

// The Artifact Registry repository for our app
resource "google_artifact_registry_repository" "app-repo" {
  location      = "us-central1"
  repository_id = "app-repo"
  description   = "App Docker repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

// Provider
// ----------------------------------

// Connect to the GCP project
provider "google" {
  credentials = file("<gcp-creds.json")
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}

terraform {
  # Use a shared bucket (wich allows collaborative work)
  backend "gcs" {
    bucket      = "k3s-shared-bucket"
    prefix      = "k3s-infra"
  }

  // Set versions
  required_version = ">=1.8.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.0.0"
    }
  }
}
