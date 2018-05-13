
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

resource "google_compute_instance_template" "instance_template_staging" {
  name  = "instance-template-staging"
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
    - image: 'gcr.io/comp698-jah2009/github-unhjaden-my-web-server:2d9562329a267af734114f04c036f2ec9db475f1'
      name: service-container
      stdin: false
      tty: false
  restartPolicy: Always
EOF
  }
}

resource "google_compute_instance_group_manager" "staging" {
  name        = "instance-group-manager-staging"
  instance_template  = "${google_compute_instance_template.instance_template_staging.self_link}"
  base_instance_name = "tf-staging"
  zone               = "us-central1-f"
  target_size        = "1"
  project      = "comp698-jah2009"
}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-jah2009"
  name     = "comp698-jadens-auto-bucket"
  location = "us-central1"
}