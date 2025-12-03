# Linux Auto Installer Script

A universal Bash script that auto-detects your Linux distribution and installs requested software packages with verification.  
Supports installing regular packages, OpenJDK 21 (JRE + JDK), and Visual Studio Code (VSCode) with distro-specific methods.

---

## Features

- Detects package manager: apt, dnf, yum, pacman, zypper, apk  
- Checks if software is already installed before installing  
- Installs OpenJDK 21 (JRE and JDK)  
- Installs Visual Studio Code (with official Microsoft repos)  
- Supports major Linux distros: Ubuntu, Debian, Fedora, CentOS, Arch, openSUSE, Alpine  

---

## Usage

1. Clone or download this repository.

2. Make the script executable:

   chmod +x install.sh

3. Run the script with the list of packages you want to install:

   ./install.sh git curl jdk vscode

   This example will:

   - Install git and curl if missing  
   - Install OpenJDK 21 JRE and JDK (jdk alias)  
   - Install Visual Studio Code (vscode alias)

---

## Supported Package Names

| Package Name | Description                   |
|--------------|-------------------------------|
| jdk, java, jre | Installs OpenJDK 21 (JRE + JDK) |
| vscode       | Installs Visual Studio Code   |
| Any other valid package name for your distro's package manager (e.g., vim, wget, docker) |

---

## Notes

- Requires sudo privileges to install software.  
- On some distros, OpenJDK 21 might not be available in official repos yet.  
- VSCode installation adds Microsoft’s official package repositories where applicable.  
- Alpine Linux does not officially support VSCode via apk. Manual install or alternatives recommended.

---

## License

MIT License

---

## Contributing

Feel free to open issues or submit pull requests to improve the script or add support for other software!

---

## Author

AXCEL BLADE