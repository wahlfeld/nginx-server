# devops-take-home-challenge

## Requirements

* MacOS required to run this code (or Linux, but will require some fiddling
  around)
* AWS account including CLI configured on your machine
* Terraform v0.14+

## Usage

1. Create a Terraform backend S3 bucket to store your state files
2. Copy and paste the `template` folder somewhere on your computer
3. Configure `terraform.tf` to point at the S3 bucket you just created
4. Create a file called `terraform.tfvars` as per the input descriptions in
   `inputs.tf` E.g.
```
aws_region       = "ap-southeast-2"    // Choose a region closest to your physical location
```
5. Run `terraform init && terraform apply`

### Monitoring

To view server monitoring metrics visit the `monitoring_url` output from
Terraform after deploying. 

## Install dependencies

Currently this installs more than required to run the code, however doesn't
include AWS CLI.

`make install`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create the nginx server | `string` | `"ap-southeast-2"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS EC2 instance type to run the server on | `string` | `"t3a.nano"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the deployment | `string` | `"prod"` | no |
| <a name="input_unique_id"></a> [unique\_id](#input\_unique\_id) | The ID of the deployment (used for tests) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The EC2 instance ID |
| <a name="output_monitoring_url"></a> [monitoring\_url](#output\_monitoring\_url) | URL to monitor the nginx Server |
| <a name="output_nginx_url"></a> [nginx\_url](#output\_nginx\_url) | URL to the nginx Server |
<!-- END_TF_DOCS -->
