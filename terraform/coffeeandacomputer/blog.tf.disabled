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

resource "aws_s3_bucket" "blog_logging_bucket" {
  bucket = "coffeeandacomputer-blog-logs"
  acl    = "log-delivery-write"
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

resource "aws_instance" "reverse_proxy" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t3.micro"

  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]

  key_name  = "${aws_key_pair.chef_key.key_name}"
  subnet_id = "${module.base_network.main_subnet}"

  tags = {
    Name = "Blog_proxy"
  }

  provisioner "file" {
    source      = "setup_files"
    destination = "/home/centos/setup"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/centos/setup/server_setup.sh",
      "sudo /home/centos/setup/server_setup.sh blog centos puppet_managed",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

resource "aws_eip" "blog_proxy_ip" {
  instance = "${aws_instance.reverse_proxy.id}"
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

output "reverse_proxy_ip" {
  value = "${aws_eip.blog_proxy_ip.public_ip}"
}
