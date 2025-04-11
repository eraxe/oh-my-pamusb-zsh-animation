#!/bin/bash

# Cyberpunk PAM USB Authentication Animation Installer
# This script installs, updates, or uninstalls the cyberpunk animation for PAM USB authentication

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'
BRIGHT_BLUE='\033[1;34m'
BRIGHT_MAGENTA='\033[1;35m'
BRIGHT_CYAN='\033[1;36m'
BRIGHT_WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# GitHub repository URL
GITHUB_REPO="https://github.com/eraxe/oh-my-pamusb-zsh-animation.git"

# Installation paths
INSTALL_DIR="$HOME/.local/bin"
SUDO_WRAPPER="$INSTALL_DIR/sudo-wrapper.sh"
ZSHRC="$HOME/.zshrc"

# Function to print cyberpunk-style header
print_header() {
    echo -e "${BRIGHT_CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BRIGHT_CYAN}║${BRIGHT_MAGENTA}  ░▒▓█ ${BRIGHT_YELLOW}CYBERPUNK PAM USB ANIMATION INSTALLER${BRIGHT_MAGENTA} █▓▒░  ${BRIGHT_CYAN}║${NC}"
    echo -e "${BRIGHT_CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Print script header
print_header

# Function to print status messages
print_status() {
    echo -e "${BRIGHT_BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${BRIGHT_GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${BRIGHT_RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${BRIGHT_YELLOW}[!]${NC} $1"
}

# Check for required commands
check_dependencies() {
    print_status "Checking dependencies..."
    local missing_deps=()

    # Check for git (required for update)
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi

    # Check for curl or wget
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        missing_deps+=("curl or wget")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_error "Please install the required dependencies and try again."
        exit 1
    else
        print_success "All required dependencies are installed."
    fi
}

# Detect shell configuration
detect_shell() {
    print_status "Detecting shell configuration..."

    # Check if ZSH is installed
    if ! command -v zsh &> /dev/null; then
        print_error "ZSH is not installed. Please install ZSH first."
        exit 1
    else
        print_success "ZSH is installed."
    fi

    # Determine ZSH configuration file
    if [ -f "$HOME/.zshrc" ]; then
        ZSHRC="$HOME/.zshrc"
        print_success "Found ZSH configuration at $ZSHRC"
    else
        print_error "Could not find .zshrc in your home directory."
        exit 1
    fi

    # Check if Oh-My-Zsh is installed
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "Oh-My-Zsh is installed."
        OHMYZSH=true
    else
        print_warning "Oh-My-Zsh is not installed. Continuing with plain ZSH setup."
        OHMYZSH=false
    fi
}

# Create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    mkdir -p "$INSTALL_DIR"
    print_success "Created directory: $INSTALL_DIR"
}

# Install the sudo wrapper script
install_sudo_wrapper() {
    print_status "Installing sudo wrapper script..."

    # Define the paths
    SOURCE_SCRIPT="$SCRIPT_DIR/oh-my-pamusb-zsh-animation.sh"

    # Check if the source script exists
    if [ ! -f "$SOURCE_SCRIPT" ]; then
        print_error "Could not find oh-my-pamusb-zsh-animation.sh in the same directory."
        exit 1
    fi

    # Copy the script to the destination
    cp "$SOURCE_SCRIPT" "$SUDO_WRAPPER"

    # Make the script executable
    chmod +x "$SUDO_WRAPPER"
    print_success "Installed sudo wrapper script at $SUDO_WRAPPER"
}

# Update ZSH configuration
update_zshrc() {
    print_status "Updating ZSH configuration..."

    # Check if the aliases already exist
    if grep -q "alias sudo=" "$ZSHRC"; then
        print_warning "Sudo alias already exists in $ZSHRC."
        # Comment out existing sudo aliases
        sed -i 's/^alias sudo=/#alias sudo=/g' "$ZSHRC"
    fi

    # Add the new aliases and mark with special comments for uninstall
    cat >> "$ZSHRC" << EOF

# BEGIN_CYBERPUNK_PAM_USB - Added by installer script
alias sudo='$SUDO_WRAPPER'
alias sudo-original='$SUDO_WRAPPER --original'
alias sudo-debug='$SUDO_WRAPPER --sudo-debug'
alias psudo='$SUDO_WRAPPER psudo'
# Make sure the directory is in PATH
export PATH="$INSTALL_DIR:\$PATH"
# END_CYBERPUNK_PAM_USB
EOF

    print_success "Updated ZSH configuration in $ZSHRC"
}

# Test the installation
test_installation() {
    print_status "Testing the installation..."

    # Source the updated zshrc
    source "$ZSHRC"

    # Check if the sudo-wrapper script exists and is executable
    if [ -x "$SUDO_WRAPPER" ]; then
        print_success "sudo-wrapper.sh is properly installed."
    else
        print_error "sudo-wrapper.sh installation failed."
        exit 1
    fi

    # Check if the alias is working
    if alias sudo 2>/dev/null | grep -q "sudo-wrapper.sh"; then
        print_success "sudo alias is properly configured."
    else
        print_warning "sudo alias configuration may have issues."
    fi

    print_success "Installation test completed. The cyberpunk PAM USB animation should work now."
}

# Uninstall function to remove all components
uninstall() {
    print_header
    print_status "Starting uninstallation process..."

    # Check if the sudo wrapper exists
    if [ -f "$SUDO_WRAPPER" ]; then
        print_status "Removing sudo wrapper script..."
        rm -f "$SUDO_WRAPPER"
        print_success "Removed: $SUDO_WRAPPER"
    else
        print_warning "sudo wrapper script not found at $SUDO_WRAPPER. Skipping."
    fi

    # Check if zshrc has our modifications
    if grep -q "BEGIN_CYBERPUNK_PAM_USB" "$ZSHRC"; then
        print_status "Removing configuration from $ZSHRC..."
        # Remove everything between and including the BEGIN and END markers
        sed -i '/# BEGIN_CYBERPUNK_PAM_USB/,/# END_CYBERPUNK_PAM_USB/d' "$ZSHRC"
        print_success "Removed configuration from $ZSHRC"
    else
        print_warning "No configuration found in $ZSHRC. Skipping."
    fi

    # Check if any backup files were created and restore them
    if [ -f "$ZSHRC.bak" ]; then
        print_status "Restoring backup configuration..."
        cp "$ZSHRC.bak" "$ZSHRC"
        print_success "Restored $ZSHRC from backup"
    fi

    print_success "Uninstallation completed!"
    echo ""
    echo -e "${BRIGHT_YELLOW}Next steps:${NC}"
    echo -e "1. ${CYAN}Restart your terminal or run:${NC} ${BRIGHT_GREEN}source $ZSHRC${NC}"
    echo ""
    echo -e "${BRIGHT_MAGENTA}Thank you for trying Cyberpunk PAM USB Animation!${NC}"
    echo ""
}

# Update function to get the latest version from GitHub
update() {
    print_header
    print_status "Starting update process..."

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    print_status "Created temporary directory: $TEMP_DIR"

    # Clone the repository
    print_status "Downloading latest version from GitHub..."
    if ! git clone "$GITHUB_REPO" "$TEMP_DIR"; then
        print_error "Failed to download the latest version from GitHub."
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Check if the required files exist in the downloaded repo
    if [ ! -f "$TEMP_DIR/install.sh" ] || [ ! -f "$TEMP_DIR/oh-my-pamusb-zsh-animation.sh" ]; then
        print_error "Downloaded repository is missing required files."
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Make the script executable
    chmod +x "$TEMP_DIR/install.sh"

    # Backup current zshrc
    cp "$ZSHRC" "$ZSHRC.update_backup"
    print_status "Backed up $ZSHRC to $ZSHRC.update_backup"

    # Uninstall current version
    print_status "Removing current installation..."
    # Check if the sudo wrapper exists
    if [ -f "$SUDO_WRAPPER" ]; then
        rm -f "$SUDO_WRAPPER"
    fi

    # Check if zshrc has our modifications
    if grep -q "BEGIN_CYBERPUNK_PAM_USB" "$ZSHRC"; then
        # Remove everything between and including the BEGIN and END markers
        sed -i '/# BEGIN_CYBERPUNK_PAM_USB/,/# END_CYBERPUNK_PAM_USB/d' "$ZSHRC"
    fi

    # Install new version
    print_status "Installing new version..."
    cp "$TEMP_DIR/oh-my-pamusb-zsh-animation.sh" "$SUDO_WRAPPER"
    chmod +x "$SUDO_WRAPPER"

    # Update zshrc with new configuration
    cat >> "$ZSHRC" << EOF

# BEGIN_CYBERPUNK_PAM_USB - Added by installer script
alias sudo='$SUDO_WRAPPER'
alias sudo-original='$SUDO_WRAPPER --original'
alias sudo-debug='$SUDO_WRAPPER --sudo-debug'
alias psudo='$SUDO_WRAPPER psudo'
# Make sure the directory is in PATH
export PATH="$INSTALL_DIR:\$PATH"
# END_CYBERPUNK_PAM_USB
EOF

    # Clean up
    rm -rf "$TEMP_DIR"

    print_success "Update completed!"
    echo ""
    echo -e "${BRIGHT_YELLOW}Next steps:${NC}"
    echo -e "1. ${CYAN}Restart your terminal or run:${NC} ${BRIGHT_GREEN}source $ZSHRC${NC}"
    echo -e "2. ${CYAN}Test the animation by running:${NC} ${BRIGHT_GREEN}sudo ls${NC}"
    echo ""
    echo -e "${BRIGHT_MAGENTA}Enjoy your updated cyberpunk PAM USB experience!${NC}"
    echo ""
}

# Display help
show_help() {
    echo ""
    echo -e "${BRIGHT_YELLOW}Cyberpunk PAM USB Animation - Help${NC}"
    echo ""
    echo -e "${CYAN}Usage:${NC}"
    echo -e "  ./install.sh [OPTION]"
    echo ""
    echo -e "${CYAN}Options:${NC}"
    echo -e "  ${GREEN}install${NC}    Install the cyberpunk PAM USB animation (default)"
    echo -e "  ${GREEN}update${NC}     Update to the latest version from GitHub"
    echo -e "  ${GREEN}uninstall${NC}  Remove the cyberpunk PAM USB animation"
    echo -e "  ${GREEN}help${NC}       Display this help message"
    echo ""
    echo -e "${BRIGHT_MAGENTA}Created by eraxe${NC}"
    echo ""
}

# Main installation sequence
main() {
    # Parse command line arguments
    case "$1" in
        "uninstall")
            uninstall
            exit 0
            ;;
        "update")
            check_dependencies
            update
            exit 0
            ;;
        "help")
            show_help
            exit 0
            ;;
        "install" | "")
            # Default action (install)
            detect_shell
            create_directories
            install_sudo_wrapper
            update_zshrc
            test_installation

            echo ""
            echo -e "${BRIGHT_CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
            echo -e "${BRIGHT_CYAN}║${BRIGHT_GREEN}                INSTALLATION COMPLETE                ${BRIGHT_CYAN}║${NC}"
            echo -e "${BRIGHT_CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
            echo ""
            echo -e "${BRIGHT_YELLOW}Next steps:${NC}"
            echo -e "1. ${CYAN}Restart your terminal or run:${NC} ${BRIGHT_GREEN}source $ZSHRC${NC}"
            echo -e "2. ${CYAN}Test the animation by running:${NC} ${BRIGHT_GREEN}sudo ls${NC}"
            echo -e "3. ${CYAN}For debugging issues, use:${NC} ${BRIGHT_GREEN}sudo-debug ls${NC}"
            echo -e "4. ${CYAN}To use original sudo without animation:${NC} ${BRIGHT_GREEN}sudo-original ls${NC}"
            echo -e "5. ${CYAN}To update to the latest version:${NC} ${BRIGHT_GREEN}./install.sh update${NC}"
            echo -e "6. ${CYAN}To uninstall:${NC} ${BRIGHT_GREEN}./install.sh uninstall${NC}"
            echo ""
            echo -e "${BRIGHT_MAGENTA}Enjoy your cyberpunk PAM USB experience!${NC}"
            echo ""
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run the main function with command line arguments
main "$@"