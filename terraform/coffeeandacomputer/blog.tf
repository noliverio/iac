resource "aws_s3_bucket" "coffeeandacomputer_blog_bucket" {
  bucket = "blog.coffeeandacomputer.com"
  acl    = "public-read"

  website = {
    index_document = "index.html"
  }

  logging {
    target_bucket = "${aws_s3_bucket.blog_logging_bucket.id}"
    target_prefix = "coffeeandacomputer"
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

//need to keep this file in the s3 root, if i try to put it in an html folder I would need to set an html folder specific index_document.
resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${aws_s3_bucket.coffeeandacomputer_blog_bucket.id}"
  key          = "index.html"
  source       = "~/iac/blog/html/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "background_png" {
  bucket       = "${aws_s3_bucket.coffeeandacomputer_blog_bucket.id}"
  key          = "resources/paper.png"
  source       = "~/iac/blog/resources/paper.png"
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "style_css" {
  bucket       = "${aws_s3_bucket.coffeeandacomputer_blog_bucket.id}"
  key          = "css/style.css"
  source       = "~/iac/blog/css/style.css"
  content_type = "text/css"
}
