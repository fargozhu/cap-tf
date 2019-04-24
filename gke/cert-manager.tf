resource "kubernetes_namespace" "certmanager" {
  metadata {    
    name = "cert-manager"
  }

  depends_on = ["helm_release.nginx_ingress"]
}

data "helm_repository" "jetstack" {
    name = "jetstack"
    url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert-manager" {
    name = "cert-manager"
    repository = "${data.helm_repository.jetstack.metadata.0.name}"
    namespace = "${kubernetes_namespace.certmanager.metadata.0.name}"
    version = "0.7.0"
    chart = "jetstack/cert-manager"
    depends_on = ["null_resource.kubectl_runner"]
}

resource "null_resource" "kubectl_runner" {
    provisioner "local-exec" {
        command = "/bin/sh kube_label.sh"
    }
    depends_on = ["kubernetes_namespace.certmanager"]
}

resource "null_resource" "cert_issuer" {
    provisioner "local-exec" {
        command = "kubectl apply -f staging-issuer.yaml"
    }

    depends_on = ["helm_release.cert-manager"]
}