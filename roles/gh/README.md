# gh Ansible Role

This role installs GitHub CLI (gh) on Debian-based systems (Debian, Ubuntu, Pop!_OS).

## Features

- Downloads and installs the official GitHub CLI GPG key
- Adds the GitHub CLI APT repository 
- Installs the `gh` package via apt

## Variables

- `gh_package_name`: Name of the package to install (default: "gh")
- `gh_version`: Version to install (default: "latest")

## Supported Platforms

- Debian
- Ubuntu  
- Pop!_OS