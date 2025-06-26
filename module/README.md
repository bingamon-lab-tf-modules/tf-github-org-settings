# tf-github-org

## Table of Contents

- [tf-github-org](#tf-github-org)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Documentation](#documentation)

## Overview

This module configures an existing GitHub Organization within a given GitHub Enterprise.

## Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_organization_ruleset.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/resources/organization_ruleset) | resource |
| [github_organization_settings.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/resources/organization_settings) | resource |
| [github_enterprise.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/data-sources/enterprise) | data source |
| [github_organization.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_enterprise_slug"></a> [github\_enterprise\_slug](#input\_github\_enterprise\_slug) | The slug of the GitHub Enterprise where resources will be created.<br/><br/>  This is needed by the GitHub Enterprise Terraform provider.<br/><br/>  This can be set via either;<br/><br/>  - TF\_VAR\_github\_enterprise\_slug environment variable.<br/>  - github\_enterprise\_slug variable in the terraform.tfvars file. | `string` | n/a | yes |
| <a name="input_github_organization_advanced_security_enabled_for_new_repositories"></a> [github\_organization\_advanced\_security\_enabled\_for\_new\_repositories](#input\_github\_organization\_advanced\_security\_enabled\_for\_new\_repositories) | Optional. Whether advanced security is enabled for new repositories. | `bool` | `true` | no |
| <a name="input_github_organization_billing_email"></a> [github\_organization\_billing\_email](#input\_github\_organization\_billing\_email) | Required. The billing email of the GitHub Organization where resources will be created. | `string` | n/a | yes |
| <a name="input_github_organization_blog"></a> [github\_organization\_blog](#input\_github\_organization\_blog) | Optional. The blog of the GitHub Organization where resources will be created. | `string` | `null` | no |
| <a name="input_github_organization_company"></a> [github\_organization\_company](#input\_github\_organization\_company) | Optional. The company of the GitHub Organization where resources will be created. | `string` | `null` | no |
| <a name="input_github_organization_default_repository_permission"></a> [github\_organization\_default\_repository\_permission](#input\_github\_organization\_default\_repository\_permission) | Default repository permission for the organization. Can be 'read', 'write', 'admin' or 'none'. | `string` | `"none"` | no |
| <a name="input_github_organization_dependabot_alerts_enabled_for_new_repositories"></a> [github\_organization\_dependabot\_alerts\_enabled\_for\_new\_repositories](#input\_github\_organization\_dependabot\_alerts\_enabled\_for\_new\_repositories) | Optional. Whether dependabot alerts are enabled for new repositories. | `bool` | `true` | no |
| <a name="input_github_organization_dependabot_security_updates_enabled_for_new_repositories"></a> [github\_organization\_dependabot\_security\_updates\_enabled\_for\_new\_repositories](#input\_github\_organization\_dependabot\_security\_updates\_enabled\_for\_new\_repositories) | Optional. Whether dependabot security updates are enabled for new repositories. | `bool` | `true` | no |
| <a name="input_github_organization_dependency_graph_enabled_for_new_repositories"></a> [github\_organization\_dependency\_graph\_enabled\_for\_new\_repositories](#input\_github\_organization\_dependency\_graph\_enabled\_for\_new\_repositories) | Optional. Whether dependency graph is enabled for new repositories. | `bool` | `true` | no |
| <a name="input_github_organization_description"></a> [github\_organization\_description](#input\_github\_organization\_description) | Optional. The description of the GitHub Organization where resources will be created. | `string` | `null` | no |
| <a name="input_github_organization_email"></a> [github\_organization\_email](#input\_github\_organization\_email) | Optional. The contactemail of the GitHub Organization where resources will be created. | `string` | `null` | no |
| <a name="input_github_organization_has_organization_projects"></a> [github\_organization\_has\_organization\_projects](#input\_github\_organization\_has\_organization\_projects) | Whether organization projects are enabled for the organization. | `bool` | `false` | no |
| <a name="input_github_organization_has_repository_projects"></a> [github\_organization\_has\_repository\_projects](#input\_github\_organization\_has\_repository\_projects) | Whether repository projects are enabled for the organization. | `bool` | `true` | no |
| <a name="input_github_organization_location"></a> [github\_organization\_location](#input\_github\_organization\_location) | Optional. The location of the GitHub Organization where resources will be created. | `string` | `null` | no |
| <a name="input_github_organization_members_can_create_internal_repositories"></a> [github\_organization\_members\_can\_create\_internal\_repositories](#input\_github\_organization\_members\_can\_create\_internal\_repositories) | Optional. Whether members can create internal repositories. | `bool` | `false` | no |
| <a name="input_github_organization_members_can_create_pages"></a> [github\_organization\_members\_can\_create\_pages](#input\_github\_organization\_members\_can\_create\_pages) | Optional. Whether members can create pages. | `bool` | `false` | no |
| <a name="input_github_organization_members_can_create_private_pages"></a> [github\_organization\_members\_can\_create\_private\_pages](#input\_github\_organization\_members\_can\_create\_private\_pages) | Whether members can create private pages. | `bool` | `false` | no |
| <a name="input_github_organization_members_can_create_private_repositories"></a> [github\_organization\_members\_can\_create\_private\_repositories](#input\_github\_organization\_members\_can\_create\_private\_repositories) | Optional. Whether members can create private repositories. | `bool` | `false` | no |
| <a name="input_github_organization_members_can_create_public_pages"></a> [github\_organization\_members\_can\_create\_public\_pages](#input\_github\_organization\_members\_can\_create\_public\_pages) | Whether members can create public pages. | `bool` | `false` | no |
| <a name="input_github_organization_members_can_create_public_repositories"></a> [github\_organization\_members\_can\_create\_public\_repositories](#input\_github\_organization\_members\_can\_create\_public\_repositories) | Optional. Whether members can create public repositories. | `bool` | `false` | no |
| <a name="input_github_organization_members_can_create_repositories"></a> [github\_organization\_members\_can\_create\_repositories](#input\_github\_organization\_members\_can\_create\_repositories) | Optional. Whether members can create repositories. | `bool` | `false` | no |
| <a name="input_github_organization_members_can_fork_private_repositories"></a> [github\_organization\_members\_can\_fork\_private\_repositories](#input\_github\_organization\_members\_can\_fork\_private\_repositories) | Optional. Whether members can fork private repositories. | `bool` | `false` | no |
| <a name="input_github_organization_name"></a> [github\_organization\_name](#input\_github\_organization\_name) | Required. The name of the GitHub Organization where resources will be created. | `string` | n/a | yes |
| <a name="input_github_organization_rulesets"></a> [github\_organization\_rulesets](#input\_github\_organization\_rulesets) | Optional. List of organization-level rulesets to apply to repositories within the organization. | <pre>list(object({<br/>    # Required fields<br/>    name        = string<br/>    enforcement = string # disabled, active, evaluate<br/>    target      = string # branch, tag<br/><br/>    # Rules block (required)<br/>    rules = object({<br/>      # Branch/Tag protection rules<br/>      creation                = optional(bool)<br/>      deletion                = optional(bool)<br/>      non_fast_forward        = optional(bool)<br/>      required_linear_history = optional(bool)<br/>      required_signatures     = optional(bool)<br/>      update                  = optional(bool)<br/><br/>      # Pull request rules<br/>      pull_request = optional(object({<br/>        dismiss_stale_reviews_on_push     = optional(bool)<br/>        require_code_owner_review         = optional(bool)<br/>        require_last_push_approval        = optional(bool)<br/>        required_approving_review_count   = optional(number)<br/>        required_review_thread_resolution = optional(bool)<br/>      }))<br/><br/>      # Status check rules<br/>      required_status_checks = optional(object({<br/>        strict_required_status_checks_policy = optional(bool)<br/>        required_check = optional(list(object({<br/>          context        = string<br/>          integration_id = optional(number)<br/>        })))<br/>      }))<br/><br/>      # Required workflows rules<br/>      required_workflows = optional(object({<br/>        required_workflow = list(object({<br/>          repository_id = number<br/>          path          = string<br/>          ref           = optional(string)<br/>        }))<br/>      }))<br/><br/>      # Code scanning rules<br/>      required_code_scanning = optional(object({<br/>        required_code_scanning_tool = list(object({<br/>          alerts_threshold          = string # none, errors, errors_and_warnings, all<br/>          security_alerts_threshold = string # none, critical, high_or_higher, medium_or_higher, all<br/>          tool                      = string<br/>        }))<br/>      }))<br/><br/>      # Pattern rules (Enterprise only)<br/>      branch_name_pattern = optional(object({<br/>        operator = string # starts_with, ends_with, contains, regex<br/>        pattern  = string<br/>        name     = optional(string)<br/>        negate   = optional(bool)<br/>      }))<br/><br/>      tag_name_pattern = optional(object({<br/>        operator = string # starts_with, ends_with, contains, regex<br/>        pattern  = string<br/>        name     = optional(string)<br/>        negate   = optional(bool)<br/>      }))<br/><br/>      commit_author_email_pattern = optional(object({<br/>        operator = string # starts_with, ends_with, contains, regex<br/>        pattern  = string<br/>        name     = optional(string)<br/>        negate   = optional(bool)<br/>      }))<br/><br/>      commit_message_pattern = optional(object({<br/>        operator = string # starts_with, ends_with, contains, regex<br/>        pattern  = string<br/>        name     = optional(string)<br/>        negate   = optional(bool)<br/>      }))<br/><br/>      committer_email_pattern = optional(object({<br/>        operator = string # starts_with, ends_with, contains, regex<br/>        pattern  = string<br/>        name     = optional(string)<br/>        negate   = optional(bool)<br/>      }))<br/>    })<br/><br/>    # Optional fields<br/>    bypass_actors = optional(list(object({<br/>      actor_id    = number<br/>      actor_type  = string           # RepositoryRole, Team, Integration, OrganizationAdmin<br/>      bypass_mode = optional(string) # always, pull_request<br/>    })))<br/><br/>    conditions = optional(object({<br/>      ref_name = object({<br/>        include = list(string)<br/>        exclude = list(string)<br/>      })<br/>      repository_id = optional(list(number))<br/>      repository_name = optional(object({<br/>        include = list(string)<br/>        exclude = list(string)<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_github_organization_secret_scanning_enabled_for_new_repositories"></a> [github\_organization\_secret\_scanning\_enabled\_for\_new\_repositories](#input\_github\_organization\_secret\_scanning\_enabled\_for\_new\_repositories) | Optional. Whether secret scanning is enabled for new repositories. | `bool` | `true` | no |
| <a name="input_github_organization_secret_scanning_push_protection_enabled_for_new_repositories"></a> [github\_organization\_secret\_scanning\_push\_protection\_enabled\_for\_new\_repositories](#input\_github\_organization\_secret\_scanning\_push\_protection\_enabled\_for\_new\_repositories) | Optional. Whether secret scanning push protection is enabled for new repositories. | `bool` | `true` | no |
| <a name="input_github_organization_twitter_username"></a> [github\_organization\_twitter\_username](#input\_github\_organization\_twitter\_username) | Optional. The twitter username of the GitHub Organization where resources will be created. | `string` | `null` | no |
| <a name="input_github_organization_web_commit_signoff_required"></a> [github\_organization\_web\_commit\_signoff\_required](#input\_github\_organization\_web\_commit\_signoff\_required) | Optional. Whether web commit signoff is required. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_organization_rulesets"></a> [organization\_rulesets](#output\_organization\_rulesets) | Map of all organization rulesets created by this module |
| <a name="output_organization_settings"></a> [organization\_settings](#output\_organization\_settings) | The organization settings resource |
<!-- END_TF_DOCS -->
