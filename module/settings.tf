# GitHub Organization Settings Resource
resource "github_organization_settings" "this" {
  # The name of the GitHub organization
  name = var.github_organization_name

  # Billing email for the organization
  billing_email = var.github_organization_billing_email

  # Company Name for the organization
  company = var.github_organization_company

  # Blog URL for the organization
  blog = var.github_organization_blog

  # Email for the organization
  email = var.github_organization_email

  # Twitter Username for the organization
  twitter_username = var.github_organization_twitter_username

  # Location for the organization
  location = var.github_organization_location

  # Description for the organization
  description = var.github_organization_description

  # Whether or not repository projects are enabled for the organization.
  has_organization_projects = var.github_organization_has_organization_projects

  # Whether or not repository projects are enabled for the organization.
  has_repository_projects = var.github_organization_has_repository_projects

  # Default repository permission for the organization. Can be "read", "write", "admin" or "none".
  default_repository_permission = var.github_organization_default_repository_permission

  # Whether members can create repositories.
  members_can_create_repositories = var.github_organization_members_can_create_repositories

  # Whether members can create public repositories.
  members_can_create_public_repositories = var.github_organization_members_can_create_public_repositories

  # Whether members can create private repositories.
  members_can_create_private_repositories = var.github_organization_members_can_create_private_repositories

  # Whether members can create internal repositories.
  members_can_create_internal_repositories = var.github_organization_members_can_create_internal_repositories

  # Whether members can create pages.
  members_can_create_pages = var.github_organization_members_can_create_pages

  # Whether members can create public pages.
  members_can_create_public_pages = var.github_organization_members_can_create_public_pages

  # Whether members can create private pages.
  members_can_create_private_pages = var.github_organization_members_can_create_private_pages

  # Whether members can fork private repositories.
  members_can_fork_private_repositories = var.github_organization_members_can_fork_private_repositories

  # TODO: Fix this organization-level vs repository-level setting.
  # Whether commit signoff is required for the organization.
  #web_commit_signoff_required = var.github_organization_web_commit_signoff_required

  # Whether advanced security is enabled for new repositories.
  advanced_security_enabled_for_new_repositories = var.github_organization_advanced_security_enabled_for_new_repositories

  # Whether dependabot alerts are enabled for new repositories.
  dependabot_alerts_enabled_for_new_repositories = var.github_organization_dependabot_alerts_enabled_for_new_repositories

  # Whether dependabot security updates are enabled for new repositories.
  dependabot_security_updates_enabled_for_new_repositories = var.github_organization_dependabot_security_updates_enabled_for_new_repositories

  # Whether dependency graph is enabled for new repositories.
  dependency_graph_enabled_for_new_repositories = var.github_organization_dependency_graph_enabled_for_new_repositories

  # Whether secret scanning is enabled for new repositories.
  secret_scanning_enabled_for_new_repositories = var.github_organization_secret_scanning_enabled_for_new_repositories

  # Whether secret scanning push protection is enabled for new repositories.
  secret_scanning_push_protection_enabled_for_new_repositories = var.github_organization_secret_scanning_push_protection_enabled_for_new_repositories

  depends_on = [
    data.github_enterprise.this,
    data.github_organization.this
  ]
}