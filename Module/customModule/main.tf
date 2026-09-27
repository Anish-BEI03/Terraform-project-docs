module "dev-infra" {
  source = "./module"

  Env            = "dev"
  instance_type  = "t3.micro"
  instance_count = 1
  ami-id         = "ami-0b6d9d3d33ba97d99"
  bucket_name    = "development-anish"
  key_value      = "terra-key-ec2.pub"
}

module "stg-infra" {
  source = "./module"

  Env            = "stg"
  instance_type  = "t3.micro"
  instance_count = 1
  ami-id         = "ami-0b6d9d3d33ba97d99"
  bucket_name    = "staging-anish"
  key_value      = "terra-key-ec2.pub"

}

module "prd-infra" {
  source = "./module"

  Env            = "prd"
  instance_type  = "t3.micro"
  instance_count = 1
  ami-id         = "ami-0b6d9d3d33ba97d99"
  bucket_name    = "production-anish"
  key_value      = "terra-key-ec2.pub"

  
}