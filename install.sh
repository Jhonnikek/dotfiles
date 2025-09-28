#!/bin/bash
set -e

# Colors for terminal output
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_CYAN='\033[0;36m'
C_RESET='\033[0m'

# --- HELPER FUNCTIONS ---
msg() {
    echo -e "${C_CYAN}[INFO]${C_RESET} $1"
}

success() {
    echo -e "${C_GREEN}[SUCCESS]${C_RESET} $1"
}

warn() {
    echo -e "${C_YELLOW}[WARNING]${C_RESET} $1"
}

error() {
    echo -e "${C_RED}[ERROR]${C_RESET} $1" >&2
    exit 1
}

# --- PACKAGE LISTS ---
PACMAN_PACKAGES=(
    nvidia nvidia-prime nvidia-utils lib32-nvidia-utils vulkan-tools
    ly power-profiles-daemon
    alacritty btop fastfetch bat lsd fzf nvim pacman-contrib
    rofi-wayland dolphin ark gwenview okular
    mangohud ufw steam flatpak less git openssh ttf-fira-sans ttf-fira-code ttf-firacode-nerd
)

AUR_PACKAGES=(
    visual-studio-code-bin
    # --- ASUS-specific tools ---
    # If you don't have an ASUS laptop, comment or remove the following two lines
    asusctl
    supergfxctl
)

FLATPAK_PACKAGES=(
    net.lutris.Lris
    com.heroicgameslauncher.hgl
    com.github.Matoking.protontricks
    app.zen_browser.zen
)

SERVICES_TO_ENABLE=(
    power-profiles-daemon.service
    ly.service
    ufw.service
)

# --- START OF SCRIPT ---
clear
msg "Starting Arch Linux configuration script."
msg "Your sudo password will be requested for system-level operations."
echo

# Keep sudo session alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

warn "This script will perform the following actions:"
echo "  - Create symbolic links for your dotfiles, backing up existing files."
echo "  - Update the system and enable the [multilib] repository."
echo "  - Install packages from pacman, AUR, and Flatpak."
echo "  - Enable system services like ufw."
echo
read -p "Are you sure you want to continue? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[yY]$ ]]; then
    error "Installation cancelled by user."
fi

# --- 1. SYSTEM PREPARATION ---
msg "Preparing the system..."
msg "Updating system with pacman..."
sudo pacman -Syu --noconfirm

msg "Enabling [multilib] repository for Steam and 32-bit drivers..."
if ! grep -q "^\s*\[multilib\]" /etc/pacman.conf; then
    sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
    msg "Multilib repository enabled. Syncing pacman databases..."
    sudo pacman -Sy --noconfirm
else
    msg "Multilib repository is already enabled."
fi

msg "Installing dependencies for building AUR packages (git, base-devel)..."
sudo pacman -S --needed --noconfirm git base-devel

success "completed."

# --- 2. USER-LEVEL SYMBOLIC LINKS ---
msg "Creating user-level symbolic links..."

# Define paths
SOURCE_CONFIG_DIR="$(pwd)/config"
DEST_CONFIG_DIR="$HOME/.config"
SOURCE_BASHRC="$(pwd)/config/bash/main"
DEST_BASHRC="$HOME/.bashrc"
SOURCE_WALLPAPERS_DIR="$(pwd)/wallpapers"
DEST_PICTURES_DIR="$HOME/Pictures"

if [ ! -d "$SOURCE_CONFIG_DIR" ]; then
    error "The 'config' directory was not found. Please run the script from your dotfiles repository root."
fi

mkdir -p "$DEST_CONFIG_DIR"
mkdir -p "$DEST_PICTURES_DIR"

# --- Handle ~/.bashrc ---
msg "Processing ~/.bashrc link..."
if [ -e "$DEST_BASHRC" ] || [ -L "$DEST_BASHRC" ]; then
    warn "Existing ~/.bashrc found. Backing it up to ${DEST_BASHRC}.bak"
    mv "$DEST_BASHRC" "${DEST_BASHRC}.bak"
fi
ln -s "$SOURCE_BASHRC" "$DEST_BASHRC"
success "Symbolic link created: $DEST_BASHRC -> $SOURCE_BASHRC"

# --- Handle wallpapers ---
if [ -d "$SOURCE_WALLPAPERS_DIR" ]; then
    DEST_WALLPAPERS_LINK="${DEST_PICTURES_DIR}/wallpapers"
    msg "Processing wallpapers link..."
    if [ -e "$DEST_WALLPAPERS_LINK" ] || [ -L "$DEST_WALLPAPERS_LINK" ]; then
        warn "Existing item at '$DEST_WALLPAPERS_LINK'. Backing it up to ${DEST_WALLPAPERS_LINK}.bak"
        mv "$DEST_WALLPAPERS_LINK" "${DEST_WALLPAPERS_LINK}.bak"
    fi
    ln -s "$SOURCE_WALLPAPERS_DIR" "$DEST_WALLPAPERS_LINK"
    success "Symbolic link created: $DEST_WALLPAPERS_LINK -> $SOURCE_WALLPAPERS_DIR"
else
    warn "Wallpapers directory not found at '$SOURCE_WALLPAPERS_DIR'. Skipping."
fi

# --- Handle other configs in ~/.config ---
msg "Processing other configurations in ~/.config..."
for item in "$SOURCE_CONFIG_DIR"/*; do
    config_name=$(basename "$item")
    
    # Skip directories handled separately 
    if [[ "$config_name" == "ly" ]]; then
        msg "Skipping 'config/$config_name' directory for now (handled as system-wide)."
        continue
    fi
    
    source_path="$item"
    dest_path="$DEST_CONFIG_DIR/$config_name"

    if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
        warn "Existing item found at '$dest_path'. Moving it to '${dest_path}.bak'."
        mv "$dest_path" "${dest_path}.bak"
    fi

    ln -s "$source_path" "$dest_path"
    msg "Symbolic link created: $dest_path -> $source_path"
done
success "completed."

# --- 3. SYSTEM-WIDE SYMBOLIC LINKS ---
msg "Creating system-wide symbolic links (requires sudo)..."

# --- Handle ly configuration ---
SOURCE_LY_CONFIG="$(pwd)/config/ly/config.ini"
DEST_LY_CONFIG="/etc/ly/config.ini"

if [ -f "$SOURCE_LY_CONFIG" ]; then
    msg "Processing /etc/ly/config.ini link..."
    sudo mkdir -p "$(dirname "$DEST_LY_CONFIG")"

    if [ -e "$DEST_LY_CONFIG" ] || [ -L "$DEST_LY_CONFIG" ]; then
        warn "Existing ly config found. Backing it up to ${DEST_LY_CONFIG}.bak"
        sudo mv "$DEST_LY_CONFIG" "${DEST_LY_CONFIG}.bak"
    fi

    sudo ln -s "$SOURCE_LY_CONFIG" "$DEST_LY_CONFIG"
    success "Symbolic link created: $DEST_LY_CONFIG -> $SOURCE_LY_CONFIG"
else
    warn "Ly configuration file not found at '$SOURCE_LY_CONFIG'. Skipping."
fi
success "completed."

# --- 4. INSTALL YAY (AUR HELPER) ---
msg "Installing the AUR helper 'yay'..."
if command -v yay &> /dev/null; then
    msg "'yay' is already installed. Skipping."
else
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (
        cd /tmp/yay
        makepkg -si --noconfirm
    )
    rm -rf /tmp/yay
    msg "'yay' installed successfully."
fi
success " completed."

# --- 5. PACKAGE INSTALLATION ---
msg "Installing all defined packages..."

msg "Installing packages from official repositories with pacman..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

msg "Installing packages from AUR with yay..."
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

msg "Installing applications from Flathub with Flatpak..."
flatpak install -y --noninteractive flathub "${FLATPAK_PACKAGES[@]}"

success "completed."

# --- 6. SERVICE CONFIGURATION ---
msg "Enabling system services..."

OTHER_FIREWALL_ACTIVE=false
if systemctl is-active --quiet firewalld; then
    warn "firewalld está activo. Se omitirá la activación del servicio ufw."
    OTHER_FIREWALL_ACTIVE=true
elif systemctl is-active --quiet nftables; then
    warn "nftables está activo. Se omitirá la activación del servicio ufw."
    OTHER_FIREWALL_ACTIVE=true
fi

for service in "${SERVICES_TO_ENABLE[@]}"; do
    if [[ "$service" == "ufw.service" && "$OTHER_FIREWALL_ACTIVE" == true ]]; then
        continue 
    fi

    msg "Enabling service: $service"
    sudo systemctl enable "$service"
done

success "completed."

# --- FINALIZATION ---
echo
success "All done! The script has finished installation and configuration."
warn "It is highly recommended to reboot your system for all changes to take effect."
read -p "Do you want to reboot now? (y/N): " REBOOT_CONFIRM
if [[ "$REBOOT_CONFIRM" =~ ^[yY]$ ]]; then
    msg "Rebooting system in 5 seconds..."
    sleep 5
    reboot
fi

exit 0