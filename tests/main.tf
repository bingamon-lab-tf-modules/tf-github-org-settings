module "test" {
  source = "../module"

  github_enterprise_slug   = "acme-corp"
  github_organization_name = "acme-engineering"

  github_organization_billing_email = "acme-engineering@acme.com"

  github_organization_description = "This is a test organization"

  github_organization_company          = "Acme Inc."
  github_organization_blog             = "https://acme.com"
  github_organization_email            = "acme-engineering@acme.com"
  github_organization_twitter_username = "acme-engineering"
  github_organization_location         = "San Francisco, CA"

  github_organization_has_organization_projects = true
  github_organization_has_repository_projects   = true

  github_organization_default_repository_permission            = "read"
  github_organization_members_can_create_repositories          = true
  github_organization_members_can_create_public_repositories   = true
  github_organization_members_can_create_private_repositories  = true
  github_organization_members_can_create_internal_repositories = true
  github_organization_members_can_create_pages                 = true
  github_organization_members_can_create_public_pages          = true
  github_organization_members_can_create_private_pages         = true
  github_organization_members_can_fork_private_repositories    = true

  github_organization_web_commit_signoff_required                                  = true
  github_organization_advanced_security_enabled_for_new_repositories               = true
  github_organization_dependabot_alerts_enabled_for_new_repositories               = true
  github_organization_dependabot_security_updates_enabled_for_new_repositories     = true
  github_organization_dependency_graph_enabled_for_new_repositories                = true
  github_organization_secret_scanning_enabled_for_new_repositories                 = true
  github_organization_secret_scanning_push_protection_enabled_for_new_repositories = true
  github_organization_rulesets                                                     = []
}
