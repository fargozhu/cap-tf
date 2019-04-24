resource "helm_release" "uaa-opensuse" {
  name = "uaa-opensuse"
  namespace = "uaa"
  chart = "./temp/scf-opensuse-2.15.2/helm/uaa-opensuse"
  depends_on = ["helm_release.nginx_ingress", "null_resource.cert_issuer"]

  values = [
    "${file("scf-config-values-ingress.yaml")}"
  ]
}

