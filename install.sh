#!/bin/bash

print_title() {
    echo ""
    echo "==========================================="
    echo "   Linux Auto Installer Script"
    echo "   Auto detect distro & install software"
    echo "==========================================="
    echo ""
}

detect_pkg_manager() {
    if command -v apt >/dev/null 2>&1; then
        PKG="apt"
    elif command -v dnf >/dev/null 2>&1; then
        PKG="dnf"
    elif command -v yum >/dev/null 2>&1; then
        PKG="yum"
    elif command -v pacman >/dev/null 2>&1; then
        PKG="pacman"
    elif command -v zypper >/dev/null 2>&1; then
        PKG="zypper"
    elif command -v apk >/dev/null 2>&1; then
        PKG="apk"
    else
        echo "❌ No supported package manager found."
        exit 1
    fi
}

is_installed() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

install_package() {
    case "$PKG" in
        apt)
            sudo apt update
            sudo apt install -y "$1"
            ;;
        dnf)
            sudo dnf install -y "$1"
            ;;
        yum)
            sudo yum install -y "$1"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "$1"
            ;;
        zypper)
            sudo zypper install -y "$1"
            ;;
        apk)
            sudo apk add "$1"
            ;;
    esac
}

install_java() {
    case "$PKG" in
        apt)
            sudo apt update
            sudo apt install -y openjdk-21-jre openjdk-21-jdk || \
            sudo apt install -y openjdk-21-jdk-headless openjdk-21-jre-headless
            ;;
        dnf)
            sudo dnf install -y java-21-openjdk java-21-openjdk-devel
            ;;
        yum)
            sudo yum install -y java-21-openjdk java-21-openjdk-devel
            ;;
        pacman)
            sudo pacman -Sy --noconfirm jre-openjdk jdk-openjdk
            ;;
        zypper)
            sudo zypper install -y java-21-openjdk java-21-openjdk-devel
            ;;
        apk)
            sudo apk add openjdk21 openjdk21-jre
            ;;
        *)
            echo "❌ Unsupported package manager for Java 21 installation."
            exit 1
            ;;
    esac
}

install_vscode() {
    case "$PKG" in
        apt)
            if is_installed code; then
                echo "✔ VSCode is already installed."
                return
            fi
            echo "⬇ Installing VSCode for Debian/Ubuntu..."

            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
            sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
            rm microsoft.gpg

            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
                sudo tee /etc/apt/sources.list.d/vscode.list

            sudo apt update
            sudo apt install -y code
            ;;
        dnf|yum)
            if is_installed code; then
                echo "✔ VSCode is already installed."
                return
            fi
            echo "⬇ Installing VSCode for Fedora/CentOS..."

            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

            if [ "$PKG" = "dnf" ]; then
                sudo dnf check-update
                sudo dnf install -y code
            else
                sudo yum check-update
                sudo yum install -y code
            fi
            ;;
        pacman)
            if is_installed code; then
                echo "✔ VSCode is already installed."
                return
            fi
            echo "⬇ Installing VSCode from community repo (Arch)..."
            sudo pacman -Sy --noconfirm code
            ;;
        zypper)
            if is_installed code; then
                echo "✔ VSCode is already installed."
                return
            fi
            echo "⬇ Installing VSCode for openSUSE..."
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo zypper addrepo --gpgcheck https://packages.microsoft.com/yumrepos/vscode vscode
            sudo zypper refresh
            sudo zypper install -y code
            ;;
        apk)
            echo "❌ VSCode is not officially available on Alpine Linux via apk."
            echo "    Please install it manually or use code-server."
            ;;
        *)
            echo "❌ Unsupported package manager for VSCode installation."
            exit 1
            ;;
    esac

    if is_installed code; then
        echo "✔ VSCode installed successfully."
    else
        echo "❌ Failed to install VSCode."
    fi
}

print_title

detect_pkg_manager
echo "📦 Using package manager: $PKG"

for pkg in "$@"; do
    echo ""
    echo "➡ Checking: $pkg"

    if [[ "$pkg" == "jdk" ]] || [[ "$pkg" == "java" ]] || [[ "$pkg" == "jre" ]]; then
        if command -v java >/dev/null 2>&1 && command -v javac >/dev/null 2>&1; then
            echo "✔ Java JRE and JDK are already installed."
        else
            echo "⬇ Installing OpenJDK 21 JRE and JDK..."
            install_java
            if command -v java >/dev/null 2>&1 && command -v javac >/dev/null 2>&1; then
                echo "✔ Java installed successfully."
                java -version
            else
                echo "❌ Failed to install Java."
            fi
        fi
    elif [[ "$pkg" == "vscode" ]]; then
        install_vscode
    else
        if is_installed "$pkg"; then
            echo "✔ $pkg is already installed."
        else
            echo "⬇ Installing $pkg..."
            install_package "$pkg"
            if is_installed "$pkg"; then
                echo "✔ $pkg installed successfully."
            else
                echo "❌ Failed to install $pkg."
            fi
        fi
    fi
done

echo ""
echo "✅ All done!"