output "data_bucket" {
  description = "S3 data-lake bucket name"
  value       = aws_s3_bucket.data.id
}

output "raw_prefix" {
  description = "Where the mock/raw sources land"
  value       = "s3://${aws_s3_bucket.data.id}/raw/"
}

output "curated_prefix" {
  description = "Where the Glue job writes the curated delay-risk dataset"
  value       = "s3://${aws_s3_bucket.data.id}/curated/deliveries_risk/"
}

output "glue_job_name" {
  description = "Name of the Glue ETL job"
  value       = aws_glue_job.etl.name
}

output "glue_database" {
  description = "Glue Data Catalog database backing Athena queries"
  value       = aws_glue_catalog_database.this.name
}

output "athena_workgroup" {
  description = "Athena workgroup for querying the curated data"
  value       = aws_athena_workgroup.this.name
}
