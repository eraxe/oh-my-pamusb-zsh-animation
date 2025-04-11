#!/bin/bash

# Cyberpunk PAM USB Authentication Animation Installer
# This script installs the cyberpunk animation for PAM USB authentication

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
    mkdir -p "$HOME/.local/bin"
    print_success "Created directory: $HOME/.local/bin"
}

# Install the sudo wrapper script
install_sudo_wrapper() {
    print_status "Installing sudo wrapper script..."

    # Define the paths
    SUDO_WRAPPER="$HOME/.local/bin/sudo-wrapper.sh"
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

    # Add the new aliases
    cat >> "$ZSHRC" << EOF

# Cyberpunk PAM USB Animation - Added by installer script
alias sudo='$HOME/.local/bin/sudo-wrapper.sh'
alias sudo-original='$HOME/.local/bin/sudo-wrapper.sh --original'
alias sudo-debug='$HOME/.local/bin/sudo-wrapper.sh --sudo-debug'
# Make sure the directory is in PATH
export PATH="\$HOME/.local/bin:\$PATH"
EOF

    print_success "Updated ZSH configuration in $ZSHRC"
}

# Test the installation
test_installation() {
    print_status "Testing the installation..."

    # Source the updated zshrc
    source "$ZSHRC"

    # Check if the sudo-wrapper script exists and is executable
    if [ -x "$HOME/.local/bin/sudo-wrapper.sh" ]; then
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

# Main installation sequence
main() {
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
    echo ""
    echo -e "${BRIGHT_MAGENTA}Enjoy your cyberpunk PAM USB experience!${NC}"
    echo ""
}

# Run the main function
main