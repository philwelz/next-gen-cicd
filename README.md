# Elevate Your Builds: Next-Gen CI/CD with Azure Container Apps and KEDA

[![Build & Publish to Registry](https://github.com/philwelz/next-gen-cicd/actions/workflows/release.yaml/badge.svg)](https://github.com/philwelz/next-gen-cicd/actions/workflows/release.yaml)

## General

Virtual machines are still the most common way to build and deploy applications via CI/CD. This session explores a new approach: KEDA, a cloud-native autoscaler that will drive the on-demand scaling of containerized build agents running on Azure Container Apps. By leveraging both technologies, we can build highly scalable, cost-efficient and sustainable CI/CD pipelines.

## Meetup Details

- Click [here](https://www.meetup.com/de-DE/berlin-microsoft-azure-meetup/events/297657359/) to view the meetup details

## Slides

- Find the slides [here](https://www.slideshare.net/slideshows/elevate-your-builds-nextgen-cicd-with-azure-container-apps-and-keda/265974064)

## Demo

### Prerequisites

- Install Terraform or OpenTofu
- Inject your GitHub PAT as Terraform variable `gh_token`
- Update the following variables in `vars.tf` to match your needs:
  - `repo_owner`
  - `repo_scope`
  - `repo_name_app`
  - `repo_name_job`
  - `image_tag`
- Adopt the following locals in `main.tf` to match your needs:
  - `prefix`
  - `location`
  - `runnerImage`

### Create runner image

- Initialize your GitHub repo by adding the Workflows `release.yaml` & `docker-build.yaml` to the path `.github/workflows/`
- Commit & push `Dockerfile` and `entrypoint.sh` to your repo and let the workflow build & release the image

### Created resources

- Run Terraform locally or via worklfow to create needed resources

```bash
# Initialize Terraform
terraform init
# Run Teerraform plan to see what will be created
terraform plan
# Execute Terraform apply to create resources
terraform apply -auto-approve
```

#### Demo Workflow

- Add this demo workflow to your repo and run the workflow:

```yaml
name: Octo Organization CI

on:
  workflow_dispatch:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: [self-hosted]

    steps:
      - uses: actions/checkout@v4

      - name: Display summary
        run: |
          echo "### Next-Gen CICD! :rocket:" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "Hello from Container App" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "- $HOSTNAME" >> $GITHUB_STEP_SUMMARY
```

## Logs

### ENV

```bash
# App Env
az containerapp env logs show \
  --name gh-runner-env-app \
  --resource-group gh-runner-rg \
  | jq

# Job Env
az containerapp env logs show \
  --name gh-runner-env-job \
  --resource-group gh-runner-rg \
  | jq
```

### App Logs

```bash
az containerapp logs show \
  --name gh-runner-app \
  --resource-group gh-runner-rg \
  --type system \
  | jq


az containerapp logs show \
  --name gh-runner-app \
  --resource-group gh-runner-rg \
  --type console \
  | jq
```

### Kusto

```kusto
# KEDA logs
ContainerAppSystemLogs_CL
| where EventSource_s == "KEDA"
| project TimeGenerated, EventSource_s ,Reason_s, Log_s, JobName_s, EnvironmentName_s
| order by TimeGenerated asc


# KEDA logs
ContainerAppSystemLogs_CL
| where EventSource_s == "ContainerAppController"
| project TimeGenerated, EventSource_s ,Reason_s, Log_s, JobName_s, EnvironmentName_s
| order by TimeGenerated asc
```

## Useful Links

- [GitHub - Autoscaling with self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/autoscaling-with-self-hosted-runners#using-ephemeral-runners-for-autoscaling)
- [Tutorial: Deploy self-hosted CI/CD runners and agents with Azure Container Apps jobs](https://learn.microsoft.com/en-us/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-github-actions)
- [Keda GitHub runner scaler](https://keda.sh/docs/2.13/scalers/github-runner/)
- [Docker Github Actions Runner](https://github.com/myoung34/docker-github-actions-runner)
