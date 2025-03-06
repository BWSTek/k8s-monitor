output "leantime_helm_release_name" {
  value = helm_release.leantime.name
}

output "leantime_helm_release_namespace" {
  value = helm_release.leantime.namespace
}

output "vikunja_helm_release_name" {
  value = helm_release.vikunja.name
}

output "vikunja_helm_release_namespace" {
  value = helm_release.vikunja.namespace
}

output "openproject_helm_release_name" {
  value = helm_release.openproject.name
}

output "openproject_helm_release_namespace" {
  value = helm_release.openproject.namespace
}
