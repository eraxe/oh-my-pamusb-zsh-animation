#!/bin/bash

# Cyberpunk PAM USB Authentication Animation Installer
# This script automatically sets up a retro/cyberpunk animation for PAM USB authentication

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

# Create the sudo wrapper script
create_sudo_wrapper() {
    print_status "Creating sudo wrapper script..."
    
    # Define the path to the script
    SUDO_WRAPPER="$HOME/.local/bin/sudo-wrapper.sh"
    
    # Create the script
    cat > "$SUDO_WRAPPER" << 'EOF'
#!/bin/bash

# Save the original sudo command
REAL_SUDO="/usr/bin/sudo"

# Cyberpunk animation frames
declare -a frames=(
    "▒▒▒▒▒▒▒▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒"
    "▒▒▒▒▒▒▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒▒"
    "▒▒▒▒▒▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒▒▒"
    "▒▒▒▒▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒▒▒▒"
    "▒▒▒▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒▒▒▒▒"
    "▒▒▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒"
    "▒▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒"
    "▓▓▓█ SCANNING █▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    "▓▓█ SCANNING █▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    "▓█ SCANNING █▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    "█ SCANNING █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    " SCANNING ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    "SCANNING ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    "CANNING ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█"
    "ANNING ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓"
    "NNING ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓"
    "NING ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓"
    "ING ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▒"
    "NG ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▒▒"
    "G ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▒▒▒"
    " ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▒▒▒▒"
    "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▒▒▒▒▒"
)

# Verification animation frames
declare -a verify_frames=(
    "[ ░░░░░░░░░░ ] 0%"
    "[ ▓░░░░░░░░░ ] 10%"
    "[ ▓▓░░░░░░░░ ] 20%"
    "[ ▓▓▓░░░░░░░ ] 30%"
    "[ ▓▓▓▓░░░░░░ ] 40%"
    "[ ▓▓▓▓▓░░░░░ ] 50%"
    "[ ▓▓▓▓▓▓░░░░ ] 60%"
    "[ ▓▓▓▓▓▓▓░░░ ] 70%"
    "[ ▓▓▓▓▓▓▓▓░░ ] 80%"
    "[ ▓▓▓▓▓▓▓▓▓░ ] 90%"
    "[ ▓▓▓▓▓▓▓▓▓▓ ] 100%"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'
BRIGHT_BLUE='\033[1;34m'
BRIGHT_MAGENTA='\033[1;35m'
BRIGHT_CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Function to show cyberpunk authenticating animation
show_animation() {
    echo -ne "\033[?25l" # Hide cursor
    
    # Header and initial message
    printf "\n${BRIGHT_CYAN}╔══════════════════════════════════════════════╗${NC}\n"
    printf "${BRIGHT_CYAN}║${BRIGHT_MAGENTA}    SECURE AUTHENTICATION SEQUENCE    ${BRIGHT_CYAN}║${NC}\n"
    printf "${BRIGHT_CYAN}╚══════════════════════════════════════════════╝${NC}\n\n"
    
    # USB detection animation
    printf "${BRIGHT_BLUE}[*]${NC} ${CYAN}Detecting USB security device...${NC}"
    for i in {1..15}; do
        printf "${BRIGHT_CYAN}.${NC}"
        sleep 0.05
    done
    printf " ${BRIGHT_GREEN}FOUND${NC}\n"
    sleep 0.2
    
    # Main scanning animation
    printf "${BRIGHT_BLUE}[*]${NC} ${CYAN}Authenticating with secure token...${NC}\n\n"
    
    for i in {1..3}; do
        for frame in "${frames[@]}"; do
            printf "\r${BRIGHT_MAGENTA}     %s${NC}" "$frame"
            sleep 0.04
        done
    done
    printf "\n\n"
    
    # Verification animation
    printf "${BRIGHT_BLUE}[*]${NC} ${CYAN}Verifying one-time pad...${NC}\n"
    for frame in "${verify_frames[@]}"; do
        printf "\r${BRIGHT_YELLOW}     %s${NC}" "$frame"
        sleep 0.08
    done
    printf "\n\n"
    
    # Success message
    printf "${BRIGHT_GREEN}[+]${NC} ${GREEN}AUTHENTICATION SUCCESSFUL!${NC}\n"
    printf "${BRIGHT_GREEN}[+]${NC} ${GREEN}ACCESS GRANTED TO SECURE SYSTEM${NC}\n\n"
    
    echo -ne "\033[?25h" # Show cursor
}

# Function to show error animation
show_error_animation() {
    echo -ne "\033[?25l" # Hide cursor
    
    # Header and initial message
    printf "\n${BRIGHT_CYAN}╔══════════════════════════════════════════════╗${NC}\n"
    printf "${BRIGHT_CYAN}║${BRIGHT_MAGENTA}    SECURE AUTHENTICATION SEQUENCE    ${BRIGHT_CYAN}║${NC}\n"
    printf "${BRIGHT_CYAN}╚══════════════════════════════════════════════╝${NC}\n\n"
    
    # USB detection animation
    printf "${BRIGHT_BLUE}[*]${NC} ${CYAN}Detecting USB security device...${NC}"
    for i in {1..15}; do
        printf "${BRIGHT_CYAN}.${NC}"
        sleep 0.05
    done
    
    if [ "$1" == "no_device" ]; then
        printf " ${BRIGHT_RED}NOT FOUND${NC}\n\n"
        printf "${BRIGHT_RED}[!]${NC} ${RED}ERROR: USB SECURITY DEVICE NOT DETECTED${NC}\n"
        printf "${BRIGHT_RED}[!]${NC} ${RED}INSERT YOUR SECURITY TOKEN AND TRY AGAIN${NC}\n\n"
        echo -ne "\033[?25h" # Show cursor
        return
    else
        printf " ${BRIGHT_GREEN}FOUND${NC}\n"
    fi
    
    # Main scanning animation
    printf "${BRIGHT_BLUE}[*]${NC} ${CYAN}Authenticating with secure token...${NC}\n\n"
    
    for i in {1..2}; do
        for frame in "${frames[@]}"; do
            printf "\r${BRIGHT_MAGENTA}     %s${NC}" "$frame"
            sleep 0.04
        done
    done
    printf "\n\n"
    
    # Verification animation
    printf "${BRIGHT_BLUE}[*]${NC} ${CYAN}Verifying one-time pad...${NC}\n"
    for i in {0..5}; do
        printf "\r${BRIGHT_YELLOW}     %s${NC}" "${verify_frames[$i]}"
        sleep 0.08
    done
    
    printf "\r${BRIGHT_RED}     [ ▓▓▓▓▓░░░░░ ] ERROR!${NC}\n\n"
    
    # Error message
    printf "${BRIGHT_RED}[!]${NC} ${RED}AUTHENTICATION FAILED: PAD VERIFICATION ERROR${NC}\n"
    printf "${BRIGHT_RED}[!]${NC} ${RED}ACCESS DENIED TO SECURE SYSTEM${NC}\n\n"
    
    echo -ne "\033[?25h" # Show cursor
}

# Check if output is a terminal and we should show animations
is_terminal() {
    [ -t 1 ]
}

# Run sudo with all arguments
if [[ "$1" == "--original" ]]; then
    shift
    $REAL_SUDO "$@"
else
    # Capture sudo output to check for errors
    if is_terminal; then
        # Run sudo with output redirected to a temp file
        temp_file=$(mktemp)
        $REAL_SUDO "$@" 2>&1 | tee "$temp_file"
        RESULT=${PIPESTATUS[0]}
        
        # Check if the output contains PAM USB messages
        if grep -q "Authentication device .* is connected" "$temp_file"; then
            # Device was detected
            if grep -q "Access denied" "$temp_file"; then
                # Show authentication failed animation
                show_error_animation
            elif grep -q "Access granted" "$temp_file"; then
                # Show authentication success animation
                show_animation
            fi
        elif grep -q "Authentication device .* is not connected" "$temp_file"; then
            # Show device not found animation
            show_error_animation "no_device"
        fi
        
        rm -f "$temp_file"
        exit $RESULT
    else
        # Not a terminal, just run sudo normally
        $REAL_SUDO "$@"
    fi
fi
EOF
    
    # Make the script executable
    chmod +x "$SUDO_WRAPPER"
    print_success "Created sudo wrapper script at $SUDO_WRAPPER"
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
    create_sudo_wrapper
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
    echo -e "3. ${CYAN}If needed, use the original sudo with:${NC} ${BRIGHT_GREEN}sudo-original${NC}"
    echo ""
    echo -e "${BRIGHT_MAGENTA}Enjoy your cyberpunk PAM USB experience!${NC}"
    echo ""
}

# Run the main function
main
