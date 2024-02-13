#!/bin/bash

# Stop execution if any command fails
set -e

# Rename Music directory to Github
echo "Renaming Music directory to Github..."
if [ -d "$HOME/Music" ] && [ ! -d "$HOME/Github" ]; then
    mv "$HOME/Music" "$HOME/Github"
else
    echo "Skipping rename: Github directory already exists or Music directory does not exist."
fi

# Update system
echo "Updating system..."
sudo dnf update -y

# Enable RPM Fusion Free and Nonfree Repositories
echo "Enabling RPM Fusion repositories..."
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Install applications from Fedora's main repo, including git
echo "Installing applications from Fedora repository..."
sudo dnf install keepassxc nodejs git -y

# Install OBS Studio and Steam from RPM Fusion Free
echo "Installing OBS Studio and Steam..."
sudo dnf install obs-studio steam -y

# Install Rust programming language
echo "Installing Rust and Cargo..."
sudo dnf install rust cargo -y

# Clone and install Beautiful Bash from Chris Titus
echo "Cloning and installing Beautiful Bash..."
cd "$HOME/Github" || exit
git clone https://christitus.com/beautiful-bash/ mybash
cd mybash
echo "y" | ./setup.sh

# Clone swww repository
echo "Cloning swww repository into ~/Github..."
cd "$HOME/Github" || exit
git clone https://github.com/LGFae/swww
cd swww
cargo build --release

# Add swww and swww-daemon to PATH by creating symbolic links in /usr/local/bin
echo "Adding swww and swww-daemon to PATH by creating symbolic links..."
sudo ln -sf "$HOME/Github/swww/target/release/swww" /usr/local/bin/swww
sudo ln -sf "$HOME/Github/swww/target/release/swww-daemon" /usr/local/bin/swww-daemon

# Setting up Kitty terminal emulator configuration
echo "Setting up Kitty terminal emulator configuration..."
mkdir -p ~/.config/kitty
cat << EOF > ~/.config/kitty/kitty.conf
# Font
font_family SourceCodePro
italic_font auto
bold_italic_font auto
font_size 16.0

# Theme
foreground #f8f8f2
background #000000
url_color #d65c9d

# Cursor
cursor #8fee96

term xterm-256color
background_opacity 0.70

color0  #000000
color8  #44475a

color1  #ff5555
color9  #ff5555

color2  #50fa7b
color10 #50fa7b

color3  #f1fa8c
color11 #f1fa8c

color4  #bd93f9
color12 #bd93f9

color5  #ff79c6
color13 #ff79c6

color6  #8be9fd
color14 #8be9fd

color7  #bbbbbb
color15 #ffffff
EOF
echo "Kitty configuration has been set up."

# Cleanup
echo "Cleaning up..."
sudo dnf autoremove -y

echo "Installation complete!"
