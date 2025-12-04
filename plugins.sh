############################################
#          PLUGIN INSTALLERS
############################################

############################################
#              JAVA PLUGIN
############################################
plugin_java() {
    if command -v java >/dev/null 2>&1 && command -v javac >/dev/null 2>&1; then
        echo "✔ Java (JRE + JDK) already installed."
        return
    fi

    echo "⬇ Installing OpenJDK 21..."

    case "$PKG" in
        apt)
            sudo apt update
            sudo apt install -y openjdk-21-jdk openjdk-21-jre
            ;;
        dnf|yum)
            sudo "$PKG" install -y java-21-openjdk java-21-openjdk-devel
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
    esac

    echo "✔ Java installed:"
    java -version
}

############################################
#              VSCode PLUGIN
############################################
plugin_vscode() {
    if command -v code >/dev/null 2>&1; then
        echo "✔ VSCode already installed."
        return
    fi

    case "$PKG" in
        apt)
            echo "⬇ Installing VSCode..."
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
            sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
            rm microsoft.gpg

            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" \
| sudo tee /etc/apt/sources.list.d/vscode.list

            sudo apt update
            sudo apt install -y code
            ;;
        dnf|yum)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
> /etc/yum.repos.d/vscode.repo'

            sudo "$PKG" install -y code
            ;;
        pacman)
            sudo pacman -Sy --noconfirm code ;;
        zypper)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
            sudo zypper refresh
            sudo zypper install -y code ;;
        apk)
            echo "❌ VSCode is not supported on Alpine." ;;
    esac
}

############################################
#              SDKMAN
############################################
install_sdkman() {
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "⬇ Installing SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
    fi

    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

############################################
#              GRADLE PLUGIN
############################################
plugin_gradle() {
    if command -v gradle >/dev/null 2>&1; then
        echo "✔ Gradle already installed."
        return
    fi

    echo "⬇ Installing Gradle via SDKMAN..."
    install_sdkman
    sdk install gradle
}

############################################
#          SPRING BOOT CLI PLUGIN
############################################
plugin_springboot() {
    if command -v spring >/dev/null 2>&1; then
        echo "✔ Spring Boot CLI already installed."
        return
    fi

    echo "⬇ Installing Spring Boot CLI via SDKMAN..."
    install_sdkman
    sdk install springboot
}