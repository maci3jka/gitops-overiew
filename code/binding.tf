#resource "kubernetes_manifest" "clusterrolebinding_flux_applier_binding" {
#  manifest = {
#    "apiVersion" = "rbac.authorization.k8s.io/v1"
#    "kind" = "ClusterRoleBinding"
#    "metadata" = {
#      "name" = "flux-applier-binding"
#    }
#    "roleRef" = {
#      "apiGroup" = "rbac.authorization.k8s.io"
#      "kind" = "ClusterRole"
#      "name" = "cluster-admin"
#    }
#    "subjects" = [
#      {
#        "kind" = "ServiceAccount"
#        "name" = "flux-applier"
#        "namespace" = "default"
#      },
#    ]
#  }
#}
