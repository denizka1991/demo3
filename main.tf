# Configure the GCP Provider
provider "google" {
  credentials = "${file("./creds/key.json")}"
  region = "us-central1"
  project = "monitoringtest-239812"
}

resource "google_storage_bucket" "bucket" {
  name = "superdemo34"
  location = "EU"

}

resource "google_storage_bucket_object" "saapp" {
  name = "app.zip"
//  bucket = {
//    url = "gs://superdemo3"
//  }
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./app.zip"

}

resource "google_cloudfunctions_function" "get-data" {
  name                  = "get-data"
  description           = "My weather"
  available_memory_mb   = 256
//  source_archive_bucket = {
//    url = "gs://superdemo3"
//  }
  source_archive_bucket =  "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.saapp.name}"
  trigger_http          = true
  timeout               = 60
  runtime               = "python37"
  entry_point           = "test_jenkins"
  labels = {
    my-label = "my-label-value"
  }

}
