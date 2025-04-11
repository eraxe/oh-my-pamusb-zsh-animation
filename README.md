# Cyberpunk PAM USB Authentication Animation Installer

## What is this?

This project sets up a **minimal retro/cyberpunk-style animation** during PAM USB authentication on your Linux system. It wraps your `sudo` command to show a sleek animation while waiting for authentication, especially useful for USB key authentication setups.

---

## Requirements

- Linux system (tested on Arch/Manjaro/Garuda, but should work on any modern distro).
- **ZSH** shell installed and in use (optional, fallback to bash if needed).
- **Oh-My-Zsh** (optional but supported).
- Basic user privileges to create scripts and modify shell configuration files.
- A working **PAM USB** setup if you want the full intended experience (not mandatory for the animation itself).

---

## Installation and Setup

### For Arch-based distros (pacman)

1. **Ensure ZSH is installed.**

   ```bash
   sudo pacman -S zsh
   ```

2. **(Optional) Install Oh-My-Zsh**:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

### For Debian/Ubuntu-based distros (apt)

1. **Ensure ZSH is installed.**

   ```bash
   sudo apt update
   sudo apt install zsh
   ```

2. **(Optional) Install Oh-My-Zsh**:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

### For Fedora-based distros (dnf)

1. **Ensure ZSH is installed.**

   ```bash
   sudo dnf install zsh
   ```

2. **(Optional) Install Oh-My-Zsh**:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

### If you don't want to use ZSH

- The script specifically targets `.zshrc` and assumes you use ZSH.
- If you use **bash**, you can manually add the aliases to `.bashrc` instead.
- Otherwise, installing ZSH is recommended for the best experience.

### Running the installer

After ensuring your environment is ready:

```bash
bash oh-my-pamusb-zsh-animation.sh
```

### After installation

- Restart your terminal\
  **OR**
- Manually reload your config:
  ```bash
  source ~/.zshrc
  ```

---

## How it Works

- A custom `sudo-wrapper.sh` script is created under `~/.local/bin/`.
- Aliases for `sudo`, `sudo-original`, and `sudo-debug` are added to your `.zshrc`.
- When you run `sudo`, instead of normal password prompt, you get an animated cyberpunk authentication visual.
- You can still use the **original** sudo or **debug** mode if needed.

---

## Usage Examples

- Normal animated sudo:
  ```bash
  sudo ls
  ```
- Bypass animation and use system's original sudo:
  ```bash
  sudo-original ls
  ```
- Debug mode to troubleshoot issues:
  ```bash
  sudo-debug ls
  ```

---

## Important Notes

- If you already have an alias for `sudo` in `.zshrc`, it will be **commented out** automatically by the installer.
- The animation **only** shows if you're running in a **terminal** (TTY). It won't interfere with scripts or non-interactive commands.
- If PAM USB is not set up, it **still works**, but the animation is purely cosmetic.

---

## Troubleshooting

- **No animation appears**: Check if `~/.local/bin` is in your `$PATH`.
- **Command errors**: Try reloading the shell config: `source ~/.zshrc`
- **Animation messy in terminal**: Some minimal terminals might not properly render ANSI escapes.
- **Want to uninstall?**: Manually remove the lines from `.zshrc` and delete `~/.local/bin/sudo-wrapper.sh`.

---

## Final Words

> Enjoy a touch of cyberpunk every time you authenticate. Stay retro. Stay sharp.

