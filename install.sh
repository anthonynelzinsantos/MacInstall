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

# Naming the machine
read -p "What will this computer’s name be?" COMPUTERNAME
systemsetup -setcomputername ${COMPUTERNAME:-Pippin}
systemsetup -setlocalsubnetname ${COMPUTERNAME:-Pippin}
echo "This computer will be called ${COMPUTERNAME:-Pippin}."

# Setting automatic reboot in case of problems or power failures
# Comment out when setting up servers
# systemsetup -setrestartfreeze on
# systemsetup -setWaitForStartupAfterPowerFailure 30

# Setting up sleep timers
systemsetup -setharddisksleep 10
systemsetup -setdisplaysleep 10

# Setting up screen lock (requires password)
sysadminctl -screenLock immediate -password -
systemsetup -setcomputersleep Never

########
# Time #
########

echo "Setting up time…"

# Enabling network time
systemsetup -setusingnetworktime on
systemsetup -settimezone Europe/Paris
systemsetup -setnetworktimeserver pool.ntp.org

# Setting up the menubar clock
defaults write com.apple.menuextra.clock ShowDate -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool false

########
# Dock #
########

echo "Setting up the Dock…"

# Pinning to the left edge of the screen
defaults write com.apple.dock orientation -string "left"

# Hiding automatically
defaults write com.apple.dock autohide -bool true

# Setting the icon size to 36 px
defaults write com.apple.dock "tilesize" -int 36

#####################
# Window management #
#####################

echo "Setting up window management…"

# Disabling spaces automatical reordering
defaults write com.apple.dock mru-spaces -bool false

# Grouping windows by application
defaults write com.apple.dock expose-group-apps -bool true

# Spanning spaces accross displays
defaults write com.apple.spaces spans-displays -bool true

# Setting up hot corners: Desktop on top left, Mission Control on bottom left, Notification Center on top right, locked screen on bottom right
defaults write com.apple.dock wvous-tl-corner -int 4 && defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 2 && defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 12 && defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 13 && defaults write com.apple.dock wvous-br-modifier -int 0

# Adding a margin around tiled windows
defaults write com.apple.windowmanager "EnableTiledWindowMargins" -bool true

##########
# Finder #
##########

echo "Setting up Finder…"

# Opening the Recents folder with new windows
defaults write com.apple.finder NewWindowTarget -string "PfAF"

# Setting up list view as default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Showing the path and status bars
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Immediatly showing the toolbar icon on hover
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Showing all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the extension change confirmation
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disabling the Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false
defaults write com.apple.WindowManager HideDesktop -bool true
defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true

# Relaunching Finder
killall Finder

######################
# Keyboard and mouse #
######################

# Setting up the speed
defaults write NSGlobalDomain com.apple.mouse.scaling -float "0.875"
defaults write NSGlobalDomain com.apple.trackpad.scaling -float "0.875"

# Enabling touch to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Setting up click weight to firm
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 2

# Disabling forced click
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool false
# defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false would also work
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 2

# Disabling Notification center swipe gesture
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -bool false

# Enabling App Exposé
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2

# Enabling drag lock
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool true

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
