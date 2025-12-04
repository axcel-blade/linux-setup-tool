#!/bin/bash

# Load Plugin File
source "$(dirname "$0")/plugins.sh"

print_title() {
    echo ""
    echo "==========================================="
    echo "        Linux Auto Installer Script"
    echo "   Auto detect distro + Plugin Installer"
    echo "==========================================="
    echo ""
}

detect_pkg_manager() {
    if command -v apt >/dev/null 2>&1; then PKG="apt"
    elif command -v dnf >/dev/null 2>&1; then PKG="dnf"
    elif command -v yum >/dev/null 2>&1; then PKG="yum"
    elif command -v pacman >/dev/null 2>&1; then PKG="pacman"
    elif command -v zypper >/dev/null 2>&1; then PKG="zypper"
    elif command -v apk >/dev/null 2>&1; then PKG="apk"
    else
        echo "❌ No supported package manager found."
        exit 1
    fi
}

is_installed() {
    command -v "$1" >/dev/null 2>&1
}

install_package() {
    case "$PKG" in
        apt) sudo apt update && sudo apt install -y "$1" ;;
        dnf) sudo dnf install -y "$1" ;;
        yum) sudo yum install -y "$1" ;;
        pacman) sudo pacman -Sy --noconfirm "$1" ;;
        zypper) sudo zypper install -y "$1" ;;
        apk) sudo apk add "$1" ;;
    esac
}

############################################
#        MAIN SCRIPT STARTS
############################################

print_title
detect_pkg_manager
echo "📦 Using package manager: $PKG"

# Load SDKMAN if installed
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

for pkg in "$@"; do
    echo ""
    echo "➡ Processing: $pkg"

    case "$pkg" in
        java|jdk|jre)
            plugin_java ;;      # <-- Java plugin
        vscode)
            plugin_vscode ;;
        gradle)
            plugin_gradle ;;
        springboot)
            plugin_springboot ;;
        *)
            if is_installed "$pkg"; then
                echo "✔ $pkg already installed."
            else
                echo "⬇ Installing $pkg..."
                install_package "$pkg"
            fi
            ;;
    esac
done

echo ""
echo "✅ All installations completed!"

exit 0