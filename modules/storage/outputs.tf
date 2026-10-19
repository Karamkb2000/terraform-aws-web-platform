output "bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.web.name
}
