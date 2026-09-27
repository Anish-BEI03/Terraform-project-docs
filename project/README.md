# Requirments to need hosting static website on aws using terraform

    1. AWS Account
    2. Terraform installed
    3. AWS CLI configured

# terraform file configuration required

1.  provider configuration: specify the cloud provider and region.
2.  Bucket creation: create an s3 bucket for hosting static website
3.  Public access settings: Block public access to the bucket/ configure public access to allow public read access to objects/ block public access.
4.  Bucket policy: attach a bucket policy to allow public read access to objects.
5.  Website files upload: upload the website files to the bucket.
6.  website endpoint: output the website URL of static website.
7.  Output: output the website URL.
8.  Cleanup: destroy the resources to clean up.

# terraform commands required

      1. terraform init: initialize the terraform working directory.
      2. terraform plan: create an execution plan.
      3. terraform apply: apply the changes to create the resources.
      4. terraform output: output the website URL.
      5. terraform destroy: destroy the resources to clean up.

# Amazon S3 website endpoint URL:

      (Destroyed / Cleaned Up)
      Format: http://anish-bucket-portfolio-[random_id].s3-website-[region].amazonaws.com
