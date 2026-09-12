# terraform-devops-branching-demo 
a terraform based demo project for branching strategy 
# GitHub PR Validation and Approval Workflow

## Overview

This repository implements a Pull Request validation and approval workflow for changes targeting the `dev` branch.

The workflow ensures that Terraform code is properly formatted and validated, Terraform configuration is linted, secrets are protected, and a team member reviews the changes before the PR can be merged.

## Workflow

The overall PR workflow is:

```text
Developer
    |
    | Creates Feature Branch
    v
feature/* branch
    |
    | Pull Request
    v
dev branch
    |
    +-----------------------------+
    |       GitHub Actions        |
    |                             |
    |  1. Terraform Format        |
    |  2. Terraform Validation    |
    |  3. TFLint                  |
    |  4. Secret Scanning         |
    |                             |
    +-------------+---------------+
                  |
            All Checks Pass
                  |
                  v
        Team Member Approval
                  |
                  v
             Merge to dev
```

## Implemented Checks

### 1. Terraform Format Check

Terraform formatting is checked automatically using:

```bash
terraform fmt -check -recursive
```

This ensures that Terraform files follow the standard Terraform formatting conventions.

If the code is not properly formatted, the GitHub Actions check fails and the PR cannot be merged.

Developers can fix formatting locally using:

```bash
terraform fmt -recursive
```

---

### 2. Terraform Validation

Terraform configuration is validated using:

```bash
terraform init -backend=false
terraform validate
```

`terraform validate` checks whether the Terraform configuration is syntactically and structurally valid.

A validation failure causes the GitHub Actions check to fail.

---

### 3. TFLint

TFLint is used to perform additional Terraform linting and configuration checks.

The workflow:

```bash
tflint --init
tflint
```

checks the Terraform code for potential issues and follows Terraform best practices.

This provides an additional layer of code quality validation beyond `terraform validate`.

---

### 4. Secret Scanning

Secret protection is enabled using GitHub's security features.

GitHub Secret Scanning helps identify accidentally exposed sensitive information such as:

* API keys
* Access tokens
* Cloud credentials
* Passwords
* Other supported secrets

GitHub Push Protection is also used where available to prevent supported secrets from being pushed to the repository.

This helps prevent credentials and sensitive information from being committed to the codebase.

---

## Pull Request Approval

The `dev` branch is protected using GitHub branch protection/ruleset settings.

A Pull Request is required before changes can be merged into `dev`.

At least **one approval from another team member** is required.

The PR author should not be able to satisfy the review requirement by approving their own changes.

Therefore, the normal workflow is:

```text
Developer A
     |
     | Creates PR
     v
feature branch → dev
     |
     | GitHub Actions
     |
     +-- Terraform Format      ✓
     +-- Terraform Validation  ✓
     +-- TFLint                ✓
     +-- Secret Protection     ✓
     |
     v
Developer B reviews
     |
     | Approval
     v
Merge allowed
```

---

## Protected `dev` Branch

The `dev` branch is configured so that developers cannot bypass the Pull Request process.

The branch protection/ruleset requires:

* Pull Request before merging
* At least 1 approving review
* Required GitHub Actions status checks
* Protection against force pushes
* Stale approvals to be dismissed when new changes are pushed

This ensures that code cannot be directly pushed or merged into `dev` without passing the defined checks and receiving the required review.

---

## GitHub Actions

The PR workflow is triggered whenever a Pull Request targets the `dev` branch.

Example:

```yaml
on:
  pull_request:
    branches:
      - dev
```

The workflow runs automatically whenever:

* A PR is created
* New commits are pushed to the PR
* The PR is updated

The checks must pass before the PR can be merged.

---

## Current PR Gate

The current merge gate can be summarized as:

```text
                    Pull Request
                         |
                         v
              +----------------------+
              |   GitHub Actions     |
              +----------------------+
                         |
          +--------------+--------------+
          |              |              |
          v              v              v
    Terraform fmt   Terraform       TFLint
                    validate
          |              |              |
          +--------------+--------------+
                         |
                         v
                  Secret Protection
                         |
                         v
                  All Checks Pass
                         |
                         v
                  1 Team Approval
                         |
                         v
                    Merge to dev
```

## Goal

The purpose of this workflow is to provide a controlled and automated process for integrating feature-branch changes into the `dev` branch.

It combines:

* **Automation** — GitHub Actions
* **Terraform quality checks** — `fmt`, `validate`, and TFLint
* **Security** — GitHub Secret Scanning and Push Protection
* **Code review** — Minimum one team-member approval
* **Branch governance** — Protected `dev` branch

