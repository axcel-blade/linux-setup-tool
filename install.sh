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

# === Check if command exists ===
is_installed() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# === Install a normal package ===
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

# === Install OpenJDK 21 (JRE + JDK) ===
install_java() {
    case "$PKG" in
        apt)
            sudo apt update
            # Try openjdk-21 packages, fallback to headless if needed
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
            # Arch usually has latest openjdk as jdk-openjdk
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

# === Main script ===
detect_pkg_manager
echo "📦 Using package manager: $PKG"

for pkg in "$@"; do
    echo ""
    echo "➡ Checking: $pkg"

    # Special handling for Java install
    if [[ "$pkg" == "jdk" ]] || [[ "$pkg" == "java" ]] || [[ "$pkg" == "jre" ]]; then
        # Check if java and javac exist
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