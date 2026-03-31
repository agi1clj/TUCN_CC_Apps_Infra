# Contributing

Thanks for contributing to this lab infrastructure project.

## Development workflow

1. Fork the repository and create a feature branch.
2. Copy the example variables file:
   - `cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars`
3. Authenticate to Azure:
   - `az login --use-device-code`
   - `az account set --subscription "<your-subscription-id>"`
4. Run checks before opening a PR:
   - `cd environments/dev && tofu fmt -recursive`
   - `cd environments/dev && tofu init -reconfigure`
   - `cd environments/dev && tofu validate`

## Pull request checklist

- Keep changes focused and small.
- Update docs when behavior or setup changes.
- Never commit `terraform.tfvars`, state files, tokens, or credentials.
- Make sure the documented student workflow still works locally.
