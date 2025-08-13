#!/bin/bash

###################################
###################################
##                               ##
## MacInstall                    ##
## v20250812                     ##
##                               ##
## Anthony Nelzin-Santos         ##
## https://z1nz0l1n.com          ##
##                               ##
## European Union Public Licence ##
## https://eupl.eu/1.2/en/       ##
##                               ##
###################################
###################################

###########
# General #
###########

echo "The configuration is starting…"

# Quit System Settings to prevent overwriting
osascript -e 'tell application "System Settings" to quit'

# Opening a sudo session
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Setting up the time
systemsetup -setusingnetworktime on
systemsetup -settimezone Europe/Paris
systemsetup -setnetworktimeserver pool.ntp.org

# Setting automatic reboot in case of problems or power failures
# Comment out when setting up servers
# systemsetup -setrestartfreeze on
# systemsetup -setWaitForStartupAfterPowerFailure 30

# Naming the machine
read -p "What will this computer’s name be?" COMPUTERNAME
systemsetup -setcomputername ${COMPUTERNAME:-Pippin}
systemsetup -setlocalsubnetname ${COMPUTERNAME:-Pippin}
echo "This computer will be called ${COMPUTERNAME:-Pippin}."

# Setting up sleep timers
systemsetup -setharddisksleep 10
systemsetup -setdisplaysleep 10

# Setting up screen lock (requires password)
sysadminctl -screenLock immediate -password -
systemsetup -setcomputersleep Never

##########
# Finder #
##########

echo "Setting up Finder…"

# New windows show Recents
defaults write com.apple.finder NewWindowTarget -string "PfAF"

# Default view to list
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show path and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Immediatly show the toolbar icon on hover
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Show all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Don’t confirm extension change
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Don’t show Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false
defaults read com.apple.WindowManager StandardHideDesktopIcons -bool true

# Relaunch Finder
killall Finder

##############################
## Dock and Mission Control ##
##############################

## Automatically hide the Dock
defaults write com.apple.dock autohide -boolean yes

## Hot corner > top right > Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2 && defaults write com.apple.dock wvous-tr-modifier -int 0

## Hot corner > bottom right > screen saver
defaults write com.apple.dock wvous-br-corner -int 10 && defaults write com.apple.dock wvous-br-modifier -int 0

## Touch to click
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 && defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true && defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

##############
## Terminal ##
##############

## Use Homebrew theme
defaults write com.apple.Terminal "Default Window Settings" -string "Homebrew" && defaults write com.apple.Terminal "Startup Window Settings" -string "Homebrew"

## Install Rosetta
softwareupdate --install-rosetta

##############
## Homebrew ##
##############

## Install Homebrew
cd
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> .zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

## Install apps with Cask
brew cask install audacity bbedit ffmpeg firefox tower

## Install apps with MAS
brew install mas
mas install 1365531024 # 1Blocker
mas install 1598429775 # Antidote Connector
mas install 1423210932 # Flow
mas install 1474335294 # Goodlinks
mas install 1099568401 # Home Assistant
mas install 775737590 # iA Writer
mas install 1622835804 # Kagi
mas install 409183694 # Keynote
mas install 409203825 # Numbers
mas install 409201541 # Pages
mas install 1444636541 # Photomator
mas install 6475002485 # Reeder
mas install 1606145041 # Sleeve
mas install 6471380298 # Stop the Madness Pro
mas install 899247664 # Testflight
mas install 1225570693 # Ulysses
mas install 1415257369 # Waterminder

## Open Antidote's website
open "https://antidote.app"

## Empty the Dock
defaults write com.apple.dock persistent-apps -array

## Set up the Dock
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Calendar.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/FaceTime.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/GoodLinks.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iA\ Writer.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Mail.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Messages.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Music.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Photos.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Photomator.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Reeder.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Safari.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/UlyssesMac.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/System\ Settings.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

## Relancer le Dock
killall Dock

echo "Done."
