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

# Do not manage the GitHub Advanced Security feature family: this org has no
# GHAS (Team plan), so the API rejects setting these even to "disabled"
# (422 "Updating Advanced Security ... not available"), and code_security also
# never reads back (provider #3501). They are off in practice and unmanageable
# here. secret_scanning + push_protection stay managed (the real paid-feature
# lockdown on private repos).
security_pin_exclude = ["advanced_security", "code_security", "secret_scanning_ai_detection", "secret_scanning_non_provider_patterns"]
