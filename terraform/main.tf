terraform {
 backend "gcs" {
   project = "comp698-jah2009"
   bucket  = "comp698-final-jah2009"
   prefix  = "terraform-state"
 }
}
provider "google" {
  region = "us-central1"
}

resource "google_compute_instance_template" "instance_template_final_prod" {
  name = "instance-template-final-prod"
  machine_type = "f1-micro"
  region       = "us-central1"
  project      = "comp698-jah2009"
  tags = ["http-server"]

  // boot disk
  disk {
  source_image = "cos-cloud/cos-stable"
  auto_delete  = true
  boot         = true
  }

  // networking
  network_interface {
    network = "default"
    access_config {
  }
  }

  lifecycle {
    create_before_destroy = true
  }

   service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }

  metadata {
    gce-container-declaration = <<EOF
spec:
  containers:
    - image: 'gcr.io/comp698-jah2009/github-unhjaden-comp698-final:e8d69515386693f9d22b10c701a19991a9eaf957'
      name: service-container
      stdin: false
      tty: false
  restartPolicy: Always
EOF
  }
}

resource "google_compute_instance_template" "instance_template_final_staging" {
  name  = "instance-template-final-staging"
  machine_type = "f1-micro"
  region       = "us-central1"
  project      = "comp698-jah2009"
  tags = ["http-server"]

  // boot disk
  disk {
  source_image = "cos-cloud/cos-stable"
  auto_delete  = true
  boot         = true
  }

  // networking
  network_interface {
    network = "default"
    access_config {
  }
  }

  lifecycle {
    create_before_destroy = true
  }

   service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }

  metadata {
    gce-container-declaration = <<EOF
spec:
  containers:
    - image: 'gcr.io/comp698-jah2009/github-unhjaden-comp698-final:f42295f13e5e2cc8b4798948040e717f328ae50e'
      name: service-container
      stdin: false
      tty: false
  restartPolicy: Always
EOF
  }
}

resource "google_compute_instance_group_manager" "final-prod" {
  name        = "instance-group-manager-final-prod"
  instance_template  = "${google_compute_instance_template.instance_template_final_prod.self_link}"
  base_instance_name = "prod"
  zone               = "us-central1-f"
  target_size        = "1"
  project      = "comp698-jah2009"
}

resource "google_compute_instance_group_manager" "final-staging" {
  name        = "instance-group-manager-final-staging"
  instance_template  = "${google_compute_instance_template.instance_template_final_staging.self_link}"
  base_instance_name = "staging"
  zone               = "us-central1-f"
  target_size        = "1"
  project      = "comp698-jah2009"
}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-jah2009"
  name     = "comp698-jadens-final-bucket"
  location = "us-central1"
}