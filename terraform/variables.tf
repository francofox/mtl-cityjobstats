variable "credentials" {
    description = "Credentials for GCP"
    default = "~/.pki/gcp/creds.json"
}

variable "project" {
    description = "GCP Project Id"
    default = "vdmtl-jobspostul"
}

variable "region" {
    description = "GCP Region"
    default = "us-central1"
}

variable "location" {
    description = "GCP Location"
    default = "US"
}

variable "bq_dataset_name" {
    description = "BigQuery dataset name"
    default = "vdmtl_jobs"
}

variable "gcs_bucket_name" {
    description = "GCS bucket name"
    default = "vdemtl-jobspostul"
}

variable "gcs_storage_class" {
    description = "Bucket storage class"
    default = "STANDARD"
}