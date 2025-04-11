#!/bin/bash

# Cyberpunk PAM USB Authentication Animation
# This script provides a cyberpunk animation during PAM USB authentication

# Save the original sudo command
REAL_SUDO="/usr/bin/sudo"

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

# Position and clear the line - now just returns empty since we don't center anymore
goto_center() {
    # No longer centering, just return
    return
}

# Function to show minimal loading animation
show_animation() {
    echo -ne "\033[?25l" # Hide cursor

    # Simple loading bar frames
    local load_chars=("█" "█" "█" "█" "█" "█" "█" "█" "█" "█" "█" "█" "█" "█" "█")
    local empty_chars=("▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒" "▒")
    local count=0
    local max_count=${#load_chars[@]}

    # Loop until canceled
    while true; do
        # Calculate percentage (not shown anymore)
        local percentage=$((count * 100 / max_count))

        # Print the loading bar (no borders)
        printf "\r["

        # First part of the bar (filled)
        for ((i=0; i<count; i++)); do
            if [ $i -eq $((count/2)) ]; then
                printf "${BRIGHT_CYAN}AUTHENTICATING${NC}"
            else
                printf "${BRIGHT_RED}${load_chars[$i]}${NC}"
            fi
        done

        # Second part of the bar (empty)
        for ((i=count; i<max_count; i++)); do
            printf "${BRIGHT_CYAN}${empty_chars[$i]}${NC}"
        done

        printf "]"

        # Increment
        ((count++))
        if ((count > max_count)); then
            count=0
        fi

        # Sleep for a short time
        sleep 0.05
    done
}

# Check if output is a terminal
is_terminal() {
    [ -t 1 ]
}

# Check for debug mode
debug_mode=0
sudo_args=()
for arg in "$@"; do
    if [ "$arg" = "--sudo-debug" ]; then
        debug_mode=1
    else
        sudo_args+=("$arg")
    fi
done

# Run sudo with all arguments
if [[ "$1" == "--original" ]]; then
    shift
    $REAL_SUDO "$@"
else
    # Only run animation if this is a terminal
    if is_terminal; then
        # Get the command string for display
        CMD_STR="sudo"
        for arg in "${sudo_args[@]}"; do
            if [[ "$arg" == *" "* ]]; then
                CMD_STR="$CMD_STR \"$arg\""
            else
                CMD_STR="$CMD_STR $arg"
            fi
        done

        # Save the original prompt without printing it
        original_prompt="$PS1"

        # Start animation directly (don't print anything yet)
        show_animation &
        ANIM_PID=$!

        # Trap to make sure we kill the animation if the script exits
        trap 'kill $ANIM_PID 2>/dev/null' EXIT

        # Run sudo with debug output if requested
        if [ $debug_mode -eq 1 ]; then
            # Kill the animation
            kill $ANIM_PID 2>/dev/null
            wait $ANIM_PID 2>/dev/null

            # Now print the command
            printf "\r\033[K> $CMD_STR\n"

            # Run with debug output visible
            $REAL_SUDO "${sudo_args[@]}"
            EXIT_CODE=$?

            exit $EXIT_CODE
        else
            # Create temporary files for output
            output_file=$(mktemp)
            filtered_file=$(mktemp)

            # Temporarily redirect all output to prevent PAM from showing
            exec 3>&1 4>&2
            exec 1>"$output_file" 2>&1

            # Run sudo command
            $REAL_SUDO "${sudo_args[@]}"
            EXIT_CODE=$?

            # Restore normal output
            exec 1>&3 2>&4

            # Kill the animation
            kill $ANIM_PID 2>/dev/null
            wait $ANIM_PID 2>/dev/null

            # Clear animation line and show status
            printf "\r\033[K"

            # Show status without repeating the command
            if [ $EXIT_CODE -eq 0 ]; then
                printf "${RED}[${NC} ${CYAN}AUTH ✓${NC} ${RED}]${NC}\n"
            else
                printf "${CYAN}[${NC} ${RED}AUTH ✗${NC} ${CYAN}]${NC}\n"
            fi

            # Filter out all PAM and authentication messages
            grep -v "Authentication" "$output_file" |
            grep -v "hardware database" |
            grep -v "device" |
            grep -v "one time pad" |
            grep -v "Access granted" |
            grep -v "Access denied" > "$filtered_file"

            # Display only the filtered command output
            cat "$filtered_file"

            # Clean up temporary files
            rm -f "$output_file" "$filtered_file"

            exit $EXIT_CODE
        fi
    else
        # Not a terminal, just run sudo normally
        $REAL_SUDO "${sudo_args[@]}"
    fi
fi