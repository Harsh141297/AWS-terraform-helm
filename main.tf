provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
  region = local.region
}

locals {
  name    = "sample-project"
  region  = "eu-west-1"
}

resource "null_resource" "kubectl" {
    depends_on = [module.eks]
    provisioner "local-exec" {
        command = "aws eks --region $REGION update-kubeconfig --name $CLUSER_NAME"
        environment = {
            CLUSER_NAME = local.name
            REGION = local.region
        }
    }
}