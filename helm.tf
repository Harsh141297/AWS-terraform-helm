resource "kubernetes_namespace" "nginx-ingress" {
  metadata {
    annotations = {
      name = "nginx-ingress"
    }

    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  chart      = "./nginx-ingress"

  values = [
    "${file("./nginx-ingress/values.yaml")}"
  ]
 
}


resource "helm_release" "project" {
  name       = "my-local-chart"
  chart      = "./project"

  values = [
    "${file("./project/values.yaml")}"
  ]
  set {
    name  = "global.mysql.endpoint"
    value = module.db.db_instance_endpoint
    type  = "string"
  }

  set {
    name  = "global.mysql.username"
    value = module.db.db_instance_username
    type  = "string"
  }
  
  # Description: The database password (this password may be old, because Terraform doesn't track it after initial creation)
  set {
    name  = "global.mysql.password"
    value = module.db.db_instance_password
    type  = "string"
  }
  set {
    name  = "global.mysql.database"
    value = module.db.db_instance_name
    type  = "string"
  }

}
