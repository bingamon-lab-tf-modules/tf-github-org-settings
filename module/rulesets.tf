# Organization Rulesets
resource "github_organization_ruleset" "this" {
  for_each = {
    for ruleset in var.github_organization_rulesets :
    ruleset.name => ruleset
  }

  name        = each.value.name
  enforcement = each.value.enforcement
  target      = each.value.target

  # Rules block
  rules {
    # Basic protection rules
    creation                = try(each.value.rules.creation, null)
    deletion                = try(each.value.rules.deletion, null)
    non_fast_forward        = try(each.value.rules.non_fast_forward, null)
    required_linear_history = try(each.value.rules.required_linear_history, null)
    required_signatures     = try(each.value.rules.required_signatures, null)
    update                  = try(each.value.rules.update, null)

    # Pull request rules
    dynamic "pull_request" {
      for_each = each.value.rules.pull_request != null ? [each.value.rules.pull_request] : []
      content {
        dismiss_stale_reviews_on_push     = try(pull_request.value.dismiss_stale_reviews_on_push, null)
        require_code_owner_review         = try(pull_request.value.require_code_owner_review, null)
        require_last_push_approval        = try(pull_request.value.require_last_push_approval, null)
        required_approving_review_count   = try(pull_request.value.required_approving_review_count, null)
        required_review_thread_resolution = try(pull_request.value.required_review_thread_resolution, null)
      }
    }

    # Status check rules
    dynamic "required_status_checks" {
      for_each = each.value.rules.required_status_checks != null ? [each.value.rules.required_status_checks] : []
      content {
        strict_required_status_checks_policy = try(required_status_checks.value.strict_required_status_checks_policy, null)

        dynamic "required_check" {
          for_each = try(required_status_checks.value.required_check, [])
          content {
            context        = required_check.value.context
            integration_id = try(required_check.value.integration_id, null)
          }
        }
      }
    }

    # Required workflows rules
    dynamic "required_workflows" {
      for_each = each.value.rules.required_workflows != null ? [each.value.rules.required_workflows] : []
      content {
        dynamic "required_workflow" {
          for_each = required_workflows.value.required_workflow
          content {
            repository_id = required_workflow.value.repository_id
            path          = required_workflow.value.path
            ref           = try(required_workflow.value.ref, null)
          }
        }
      }
    }

    # Code scanning rules
    dynamic "required_code_scanning" {
      for_each = each.value.rules.required_code_scanning != null ? [each.value.rules.required_code_scanning] : []
      content {
        dynamic "required_code_scanning_tool" {
          for_each = required_code_scanning.value.required_code_scanning_tool
          content {
            alerts_threshold          = required_code_scanning_tool.value.alerts_threshold
            security_alerts_threshold = required_code_scanning_tool.value.security_alerts_threshold
            tool                      = required_code_scanning_tool.value.tool
          }
        }
      }
    }

    # Pattern rules (Enterprise only)
    dynamic "branch_name_pattern" {
      for_each = each.value.rules.branch_name_pattern != null ? [each.value.rules.branch_name_pattern] : []
      content {
        operator = branch_name_pattern.value.operator
        pattern  = branch_name_pattern.value.pattern
        name     = try(branch_name_pattern.value.name, null)
        negate   = try(branch_name_pattern.value.negate, null)
      }
    }

    dynamic "tag_name_pattern" {
      for_each = each.value.rules.tag_name_pattern != null ? [each.value.rules.tag_name_pattern] : []
      content {
        operator = tag_name_pattern.value.operator
        pattern  = tag_name_pattern.value.pattern
        name     = try(tag_name_pattern.value.name, null)
        negate   = try(tag_name_pattern.value.negate, null)
      }
    }

    dynamic "commit_author_email_pattern" {
      for_each = each.value.rules.commit_author_email_pattern != null ? [each.value.rules.commit_author_email_pattern] : []
      content {
        operator = commit_author_email_pattern.value.operator
        pattern  = commit_author_email_pattern.value.pattern
        name     = try(commit_author_email_pattern.value.name, null)
        negate   = try(commit_author_email_pattern.value.negate, null)
      }
    }

    dynamic "commit_message_pattern" {
      for_each = each.value.rules.commit_message_pattern != null ? [each.value.rules.commit_message_pattern] : []
      content {
        operator = commit_message_pattern.value.operator
        pattern  = commit_message_pattern.value.pattern
        name     = try(commit_message_pattern.value.name, null)
        negate   = try(commit_message_pattern.value.negate, null)
      }
    }

    dynamic "committer_email_pattern" {
      for_each = each.value.rules.committer_email_pattern != null ? [each.value.rules.committer_email_pattern] : []
      content {
        operator = committer_email_pattern.value.operator
        pattern  = committer_email_pattern.value.pattern
        name     = try(committer_email_pattern.value.name, null)
        negate   = try(committer_email_pattern.value.negate, null)
      }
    }
  }

  # Bypass actors
  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? each.value.bypass_actors : []
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = try(bypass_actors.value.bypass_mode, null)
    }
  }

  # Conditions
  # NOTE: One of repository_id or repository_name must be set for the rule to target any repositories
  dynamic "conditions" {
    for_each = each.value.conditions != null ? [each.value.conditions] : []
    content {
      ref_name {
        include = conditions.value.ref_name.include
        exclude = conditions.value.ref_name.exclude
      }

      repository_id = try(conditions.value.repository_id, null)

      dynamic "repository_name" {
        for_each = conditions.value.repository_name != null ? [conditions.value.repository_name] : []
        content {
          include = repository_name.value.include
          exclude = repository_name.value.exclude
        }
      }
    }
  }

  # Workaround for GitHub provider issue with OrganizationAdmin actor_id
  # The provider reads back actor_id = 0 instead of 1 for OrganizationAdmin
  # causing perpetual drift. Ignore changes to bypass_actors to prevent this.
  # Refer issue #2536 - Remove this workaround once the issue is fixed.
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      bypass_actors
    ]
  }

  depends_on = [
    github_organization_settings.this
  ]
}
