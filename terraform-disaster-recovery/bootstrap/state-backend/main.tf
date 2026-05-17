resource "aws_s3_bucket" "state_backend"{
    bucket = var.state_bucket_name
    lifecycle {
        prevent_destroy = true
    }

    tags = {
        Name = "${var.project_name}-state-backend"
        Project = var.project_name
        Environment = var.environment
        ManagedBy = "Terraform" 
    }

}

resource "aws_s3_bucket_versioning" "versioning" {
        bucket = aws_s3_bucket.state_backend.id
        versioning_configuration {
            status = var.enable_versioning ? "Enabled" : "Suspended"
        }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.state_backend.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}


resource "aws_dynamodb_table" "state_lock" {
    name  = var.dynamodb_table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    point_in_time_recovery {
        enabled = true
    }

}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
    bucket = aws_s3_bucket.state_backend.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket  = aws_s3_bucket.state_backend.id 


    policy = jsonencode( 
        {
            Version = "2012-10-17" ,
            Statement = [
                {
                    Sid = "RequiredTLS" ,
                    Effect = "Deny" , 
                    Principal = "*" ,
                    Action = "s3:*" ,
                    Resource = [
                        "${aws_s3_bucket.state_backend.arn}/*",
                        aws_s3_bucket.state_backend.arn
                    ]

                    Condition = {
                        Bool = {
                            "aws:SecureTransport" = "false"
                        }
                    }
                }
            ]
        }
    )
}
