#!/bin/bash

# === Detect Package Manager ===
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

# === Check if Package is Installed ===
is_installed() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0  # installed
    fi
    return 1  # not installed
}

# === Install Package ===
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

# === Main Script ===
detect_pkg_manager
echo "📦 Using package manager: $PKG"

for pkg in "$@"; do
    echo ""
    echo "➡ Checking: $pkg"

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
done

echo ""
echo "✅ All done!"