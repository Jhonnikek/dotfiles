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
  power-profiles-daemon brightnessctl playerctl ncdu
  alacritty btop fastfetch bat lsd fzf nvim lazygit lazydocker pacman-contrib less git openssh nodejs npm postgresql docker
  hyprland hyprpaper hyprlock hypridle hyprpicker
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt6ct qt5ct 
  qt5-wayland qt6-wayland wl-clipboard kvantum-qt5 breeze-icons
  firefox rofi-wayland nautilus grim jq pavucontrol blueberry 
  mako flameshot swayosd waybar
  mangohud ufw steam lutris discord flatpak prismlauncher
  ttf-fira-sans ttf-fira-code ttf-firacode-nerd ttf-font-awesome ttf-cascadia-code-nerd
)

AUR_PACKAGES=(
  visual-studio-code-bin
  heroic-games-launcher-bin
  # If you don't have an ASUS laptop, comment or remove the following two lines
  asusctl
  supergfxctl
)

FLATPAK_PACKAGES=(
  #net.lutris.Lutris
  com.vysp3r.ProtonPlus
  #com.heroicgameslauncher.hgl
  #org.prismlauncher.PrismLauncher
  #com.visualstudio.code
)

SERVICES_TO_ENABLE=(
  power-profiles-daemon.service
  #ly.service
  ufw.service
  asusd.service
  swayosd-libinput-backend.service
  docker.service
)

clear
msg "Starting install script."
msg "Your sudo password will be requested."
echo

# Keep sudo session alive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

warn "This script will perform the following actions:"
echo "  - Create symbolic links for your dotfiles, backing up existing files."
echo "  - Enable the [multilib] repository."
echo "  - update the system, install packages optionally and enable services"
echo
read -p "Do you want to continue? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[yY]$ ]]; then
  error "Installation cancelled by user."
fi

# --- 1. SYSTEM PREPARATION ---
msg "Enabling [multilib] repository..."
if ! grep -q "^\s*\[multilib\]" /etc/pacman.conf; then
  sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
  msg "Multilib repository enabled. Syncing pacman databases..."
  sudo pacman -Sy --noconfirm
else
  msg "Multilib repository is already enabled."
fi

msg "Installing dependencies for building AUR packages..."
sudo pacman -S --needed --noconfirm git base-devel

success "System preparation completed."

# --- 2. SYMBOLIC LINKS ---
msg "Creating symbolic links..."

# Define paths
SOURCE_CONFIG_DIR="$(pwd)/config"
DEST_CONFIG_DIR="$HOME/.config"
SOURCE_BASHRC="$(pwd)/config/bash/main"
DEST_BASHRC="$HOME/.bashrc"
SOURCE_WALLPAPERS_DIR="$(pwd)/wallpapers"
DEST_PICTURES_DIR="$HOME/Pictures"
SOURCE_SCRIPTS_DIR="$(pwd)/scripts"
DEST_SCRIPTS_DIR="/bin"

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

msg "Processing other configurations in ~/.config..."
for item in "$SOURCE_CONFIG_DIR"/*; do
  config_name=$(basename "$item")

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
success "User-level symbolic links completed."

# --- 3. SYSTEM-WIDE SYMBOLIC LINKS ---
msg "Creating system-wide symbolic links (requires sudo)..."

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

if [ -d "$SOURCE_SCRIPTS_DIR" ]; then
  msg "Processing executable scripts in '$DEST_SCRIPTS_DIR'..."
  for script_path in "$SOURCE_SCRIPTS_DIR"/*; do
    if [ -f "$script_path" ]; then 
      script_name=$(basename "$script_path")
      dest_link="$DEST_SCRIPTS_DIR/$script_name"

      if [ -e "$dest_link" ] || [ -L "$dest_link" ]; then
        warn "Existing item at '$dest_link'. Backing it up to ${dest_link}.bak"
        sudo mv "$dest_link" "${dest_link}.bak"
      fi
      
      msg "Linking script: $dest_link -> $script_path"
      sudo ln -s "$script_path" "$dest_link"
    fi
  done
else
  warn "Scripts directory not found at '$SOURCE_SCRIPTS_DIR'. Skipping."
fi

success "System-wide symbolic links completed."
echo

read -p "Do you want to install packages now? (y/N): " INSTALL_PACKAGES

if [[ "$INSTALL_PACKAGES" =~ ^[yY]$ ]]; then
  
  msg "Updating system..."
  sudo pacman -Syu --noconfirm

  # --- 4. INSTALL YAY (AUR HELPER) ---
  msg "Installing the AUR helper 'yay'..."
  if command -v yay &>/dev/null; then
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
  success "AUR helper check completed."

  # --- 5. PACKAGE INSTALLATION ---
  msg "Installing all defined packages..."

  msg "Installing packages from official repositories with pacman..."
  sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

  msg "Installing packages from AUR with yay..."
  yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

  msg "Installing applications from Flathub with Flatpak..."
  flatpak install -y --noninteractive flathub "${FLATPAK_PACKAGES[@]}"

  success "Package installation completed."

  # --- 6. SERVICE CONFIGURATION ---
  msg "Enabling system services..."

  OTHER_FIREWALL_ACTIVE=false
  if systemctl is-active --quiet firewalld; then
    warn "firewalld is active. Skipping ufw service."
    OTHER_FIREWALL_ACTIVE=true
  elif systemctl is-active --quiet nftables; then
    warn "nftables is active. Skipping ufw service."
    OTHER_FIREWALL_ACTIVE=true
  fi

  for service in "${SERVICES_TO_ENABLE[@]}"; do
    if [[ "$service" == "ufw.service" && "$OTHER_FIREWALL_ACTIVE" == true ]]; then
      continue
    fi

    msg "Enabling service: $service"
    sudo systemctl enable "$service"
  done

  success "Service configuration completed."

else
  warn "Skipping package installation and service configuration."
fi

# --- FINALIZATION ---
echo
success "All done!"
warn "It's recommended to reboot the system."
read -p "Do you want to reboot now? (y/N): " REBOOT_CONFIRM
if [[ "$REBOOT_CONFIRM" =~ ^[yY]$ ]]; then
  msg "Rebooting system in 5 seconds..."
  sleep 5
  reboot
fi

exit 0