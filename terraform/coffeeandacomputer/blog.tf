resource "aws_s3_bucket" "coffeeandacomputer_blog_bucket" {
  bucket = "blog.coffeeandacomputer.com"
  acl    = "public-read"

  website = {
    index_document = "index.html"
  }

  logging {
    target_bucket = "${aws_s3_bucket.blog_logging_bucket.id}"
    target_prefix = "/coffeeandacomputer"
  }

  versioning {
    enabled = true
  }

  depends_on = ["aws_s3_bucket.blog_logging_bucket"]
}

resource "aws_s3_bucket_policy" "allow_blog_read" {
  bucket = "${aws_s3_bucket.coffeeandacomputer_blog_bucket.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17", 
  "Statement":[{ 
    "Sid":"PublicReadForGetBucketObjects", 
    "Effect":"Allow", 
    "Principal": "*", 
    "Action":["s3:GetObject"],
    "Resource":["${aws_s3_bucket.coffeeandacomputer_blog_bucket.arn}/*" ]
  } ]
} 
POLICY
}

resource "aws_s3_bucket" "blog_logging_bucket" {
  bucket = "coffeeandacomputer-blog-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${aws_s3_bucket.coffeeandacomputer_blog_bucket.id}"
  key          = "index.html"
  source       = "~/iac/blog/index.html"
  content_type = "text/html"
}
