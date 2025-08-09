# Dotfiles

my personal dotfiles for arch.

---

##  Screenshots
![App Screenshot](./assets/ss.png)
![App Screenshot](./assets/ss1.png)  

---

## Dependencies

- `cosmic`
- `alacritty`
- `fastfetch`
- `btop` 
- `ly`

```bash
sudo pacman -S cosmic alacritty btop fastfetch ly neovim
```

---

## Installation

### First clone the repo
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

### Copy the dotfiles to your config directory
```bash
cp -r dotfiles/.config/* ~/.config/
```

### Copy the LY configuration
```bash
cd  /etc/ly/config.ini
```

### Enable LY as your display manager 
```bash
systemctl disable DISPLAY_MANAGER
systemctl enable ly.service
```

