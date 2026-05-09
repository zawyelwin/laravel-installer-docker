# GitHub Actions Setup Guide

This document explains how to set up the required secrets and configure the GitHub Actions workflows.

## Required Secrets

### Docker Hub Authentication

To enable automatic pushing of Docker images to Docker Hub, you need to configure these secrets:

1. **`DOCKERHUB_USERNAME`** - Your Docker Hub username (e.g., `zylwin`)
2. **`DOCKERHUB_TOKEN`** - A Docker Hub access token

#### How to create a Docker Hub access token:

1. Log in to [Docker Hub](https://hub.docker.com)
2. Go to Account Settings → Security
3. Click "New Access Token"
4. Give it a name like "GitHub Actions"
5. Copy the token (you won't see it again!)
6. Add it to your GitHub repository secrets

#### How to add secrets to your repository:

1. Go to your GitHub repository
2. Click on **Settings** tab
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add both `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`

## Workflows Overview

### 1. Docker Build and Push (`docker-build.yml`)

**Triggers:** Push to main/master, tag push, pull requests

**What it does:**
- Builds multi-platform Docker images (linux/amd64, linux/arm64)
- Extracts the Laravel Installer version from the Makefile
- Pushes images to Docker Hub on non-PR events
- Creates tags: `latest`, version number, and git refs
- Uses GitHub Actions cache for faster builds

### 2. Lint and Validate (`lint.yml`)

**Triggers:** Push to main/master, pull requests

**What it does:**
- Runs Hadolint for Dockerfile best practices
- Runs ShellCheck for shell script validation
- Validates Dockerfile structure and entrypoint script

### 3. Security Scan (`security-scan.yml`)

**Triggers:** Push to main/master, pull requests, daily cron

**What it does:**
- Builds the Docker image
- Scans with Trivy for vulnerabilities (CRITICAL and HIGH severity)
- Uploads results to GitHub Security tab
- Runs daily to catch newly discovered vulnerabilities

### 4. Release (`release.yml`)

**Triggers:** Tag push (v*)

**What it does:**
- Creates a GitHub Release with automatic changelog
- Includes Docker image tag and usage instructions
- Extracts Laravel Installer version from Makefile

## Workflow Status Badges

Add these badges to your README.md:

```markdown
[![Docker Build](https://github.com/zawyelwin/laravel-installer-docker/actions/workflows/docker-build.yml/badge.svg)](https://github.com/zawyelwin/laravel-installer-docker/actions/workflows/docker-build.yml)
[![Lint](https://github.com/zawyelwin/laravel-installer-docker/actions/workflows/lint.yml/badge.svg)](https://github.com/zawyelwin/laravel-installer-docker/actions/workflows/lint.yml)
[![Security Scan](https://github.com/zawyelwin/laravel-installer-docker/actions/workflows/security-scan.yml/badge.svg)](https://github.com/zawyelwin/laravel-installer-docker/actions/workflows/security-scan.yml)
```

## Updating the Laravel Installer Version

When a new version of Laravel Installer is released:

1. Update the `INSTALLER_VERSION` in the `Makefile`
2. Create a git tag: `git tag -a v5.25.0 -m "Update to Laravel Installer 5.25.0"`
3. Push the tag: `git push origin v5.25.0`
4. The workflows will automatically build and push the new version

## Testing Workflows Locally

You can test workflows locally using [act](https://github.com/nektos/act):

```bash
# Install act
brew install act

# Run workflows locally
act push
act pull_request
```

## Troubleshooting

### Docker Hub authentication fails
- Verify `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets are set correctly
- Ensure the token has "Read, Write, Delete" permissions
- Check that your Docker Hub account is active

### Multi-platform builds fail
- The workflows use QEMU emulation which may be slow
- Build times are typically 5-15 minutes for multi-platform builds

### Security scan finds vulnerabilities
- Review the Trivy scan results in the GitHub Security tab
- Update base image or dependencies as needed
- Some vulnerabilities may be in upstream PHP/Alpine packages
