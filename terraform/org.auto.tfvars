# =============================================================================
# nwarila-platform — organization control plane + runner-level framework overrides
# -----------------------------------------------------------------------------
# The reusable deploy workflow overlays ONLY this file into the framework
# workspace, so runner-level framework variable overrides live here alongside
# org_settings. Non-sensitive values only — the billing email is delivered via
# the ORG_BILLING_EMAIL Actions secret (TF_VAR_org_billing_email), never here.
# =============================================================================

# Organization settings. `name` is required; every other field intentionally
# falls to the framework's safe, expense-free defaults:
#   - members_can_create_* = false        (restrict member repo/page creation)
#   - has_*_projects = false              (projects off)
#   - web_commit_signoff_required = true  (require signoff)
#   - default_repository_permission = "read"
#   - security_defaults_for_new_repositories = all false (expense-free)
# First apply therefore flips the org's current permissive member-creation /
# projects / signoff settings to these safe defaults (ratified).
org_settings = {
  name = "nwarila-platform"
}

# Global CODEOWNERS default for org mode. Code owners MUST be a valid user or
# team — a bare "@nwarila-platform" (the org) is rejected by GitHub. @NWarila is
# the org admin. Per-repo `codeowners:` in a repo's YAML still overrides this.
repo_default_codeowners = "* @NWarila\n"

# Do not pin code_security: the provider never reads it back
# (integrations/terraform-provider-github#3501), so pinning it produces a
# permanent diff. It stays unmanaged here; the paid feature is off in practice.
security_pin_exclude = ["code_security"]
