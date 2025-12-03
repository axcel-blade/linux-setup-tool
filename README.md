# Linux Auto Installer Script

A universal Bash script that automatically detects your Linux distribution and installs software packages with intelligent verification and error handling.

## Overview

This script streamlines software installation across multiple Linux distributions by automatically detecting your package manager and handling distribution-specific installation procedures. It includes smart checks to avoid reinstalling existing packages and provides clear feedback throughout the installation process.

## Supported Distributions

- **Debian/Ubuntu** - apt
- **Fedora** - dnf
- **CentOS/RHEL** - yum
- **Arch Linux** - pacman
- **openSUSE** - zypper
- **Alpine Linux** - apk

## Features

- **Auto-detection** - Automatically identifies your package manager
- **Smart verification** - Checks if software is already installed before proceeding
- **Special handlers** - Custom installation logic for complex packages (Java, VSCode, Gradle, Spring Boot)
- **SDKMAN integration** - Manages Java development tools through SDKMAN
- **Clear feedback** - Visual indicators (✔, ✘, ⬇, ➡) for installation status
- **Error handling** - Graceful failures with informative messages

## Installation

### Clone the repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### Make the script executable

```bash
chmod +x install.sh
```

## Usage

### Basic syntax

```bash
./install.sh <package1> <package2> <package3> ...
```

### Example installations

Install basic development tools:
```bash
./install.sh git curl vim wget htop
```

Install Java development environment:
```bash
./install.sh jdk gradle springboot
```

Install full development stack:
```bash
./install.sh git curl vim wget htop nodejs python3 docker jdk vscode gradle
```

## Special Package Aliases

The script recognizes special keywords for complex installations:

| Alias | Description | Installation Method |
|-------|-------------|---------------------|
| `jdk`, `java`, `jre` | OpenJDK 21 (JRE + JDK) | Distribution package manager |
| `vscode` | Visual Studio Code | Official Microsoft repositories |
| `gradle` | Gradle build tool | SDKMAN |
| `springboot` | Spring Boot CLI | SDKMAN |

## Package-Specific Notes

### Java (OpenJDK 21)

The script installs both JRE and JDK for OpenJDK 21. Package names vary by distribution:
- **Debian/Ubuntu**: `openjdk-21-jre`, `openjdk-21-jdk`
- **Fedora/CentOS**: `java-21-openjdk`, `java-21-openjdk-devel`
- **Arch**: `jre-openjdk`, `jdk-openjdk`
- **openSUSE**: `java-21-openjdk`, `java-21-openjdk-devel`
- **Alpine**: `openjdk21`, `openjdk21-jre`

### Visual Studio Code

VSCode is installed using official Microsoft repositories:
- Adds Microsoft GPG keys
- Configures distribution-specific package sources
- Installs the `code` package
- **Note**: Not officially available on Alpine Linux via apk

### SDKMAN-based Tools

Gradle and Spring Boot CLI are installed via SDKMAN:
- SDKMAN is automatically installed if not present
- Tools are managed independently of system package managers
- Provides easy version management

## Requirements

- **Root/sudo access** - Required for installing system packages
- **Internet connection** - For downloading packages and repositories
- **Supported shell** - Bash (#!/bin/bash)

## Script Workflow

1. **Display title** - Shows script information
2. **Detect package manager** - Identifies system package manager
3. **Load SDKMAN** - Sources SDKMAN if already installed
4. **Process packages** - For each requested package:
   - Check if already installed
   - Use appropriate installation method
   - Verify successful installation
   - Display status messages
5. **Complete** - Summary of results

## Exit Codes

- `0` - Success
- `1` - Error (unsupported package manager, installation failure, etc.)

## Troubleshooting

### Package manager not detected

Ensure your distribution uses one of the supported package managers. If you're using a derivative distribution, the parent's package manager should be detected.

### SDKMAN initialization fails

If SDKMAN installation completes but fails to initialize, restart your terminal and rerun the script. The script will detect the existing SDKMAN installation.

### VSCode installation fails

Check that:
- You have internet connectivity
- Microsoft repositories are accessible from your region
- Your system architecture is supported (amd64/x86_64)

### Java version conflicts

If you have multiple Java versions installed, use `update-alternatives` (Debian/Ubuntu) or `alternatives` (Fedora/CentOS) to manage the default version.

## Contributing

Contributions are welcome! Here are ways you can help:

- Add support for additional package managers
- Improve error handling and user feedback
- Add more special package handlers
- Update documentation
- Report bugs and suggest features

### Submitting changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple distributions if possible
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Author

**AXCEL BLADE**

## Acknowledgments

- SDKMAN team for the excellent SDK management tool
- Microsoft for providing official Linux repositories
- The open-source community for package management tools

## Version History

- **v1.0** - Initial release with multi-distro support, Java, VSCode, SDKMAN integration

---

**Note**: This script requires sudo privileges and will prompt for your password when installing system packages. Always review scripts before running them with elevated privileges.