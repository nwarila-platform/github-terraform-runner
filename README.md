# nwarila-platform/github-terraform-runner

GitHub-as-code deployer for the
[nwarila-platform](https://github.com/nwarila-platform) GitHub organization.
Owns the inventory of repositories under `repos/` and delegates the actual
`terraform apply` to the
[github-terraform-framework](https://github.com/nwarila-platform/github-terraform-framework)
reusable workflow.

This repository is a *runner* under the
[NWarila/terraform-template](https://github.com/NWarila/terraform-template)
contract. It contains no Terraform module code of its own; every gate
(validation, security scan, CodeQL, scorecard, sync, release, auto-merge)
runs through reusable workflows from terraform-template, and the deploy
runs through `nwarila-platform/github-terraform-framework`'s
`reusable-terraform-deploy` workflow.

## Layout

```
repos/
  public/    YAML definitions for public repos in nwarila-platform
  private/   Empty in-repo (gitkeep only); fetched from S3 at deploy time
tests/
  fixtures/  Public-safe fixtures used by pr-validation
.github/workflows/
  pr-validation.yaml     end-to-end CI: checks out the framework at the
                         pinned SHA, overlays this runner's repos/, runs
                         `make ci` against the assembled tree
  terraform-deploy.yaml  the apply path: plans and applies on push to main,
                         with private repo definitions s3-sync'd at runtime
  ...                    universal callers (security, codeql, scorecard,
                         release-please, auto-merge, template-sync)
```

## Private repo definitions

Names of private repos are private metadata. The YAMLs that describe them
live in S3 (`s3://${AWS_S3_BUCKET}/nwarila-platform/<repo>/repos/`) and are
synced into `repos/private/` during the deploy job. Adding a new private
repo is a matter of dropping a YAML into the S3 prefix — no code change
needed in this runner.

## How a change lands

1. Edit a YAML under `repos/public/` (or upload one to S3 for private).
2. PR Validation runs end-to-end: framework + this PR's data + the
   public-safe `tests/fixtures/` private overlay → must pass contract,
   lint, security, and `terraform plan`.
3. After merge, `terraform-deploy.yaml` applies on `main`.

Renovate keeps `framework_ref` and the deploy-reusable SHA in lockstep with
the framework's `main`. Trusted-bot PRs auto-merge once required checks
pass; human PRs follow normal review.
