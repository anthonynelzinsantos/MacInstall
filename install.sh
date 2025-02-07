#!/bin/bash

###################################
###################################
##                               ##
## MacInstall                    ##
## v20250207                     ##
##                               ##
## Anthony Nelzin-Santos         ##
## https://z1nz0l1n.com          ##
##                               ##
## European Union Public Licence ##
## https://eupl.eu/1.2/en/       ##
##                               ##
###################################
###################################

echo "Configuration will start."

############################
## Opening a sudo session ##
############################
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##############
## Security ##
##############

## Naming the machine
read -p "What's this computer name?" COMPUTERNAME
scutil --set ComputerName ${COMPUTERNAME:-Pippin}
scutil --set HostName ${COMPUTERNAME:-Pippin}
scutil --set LocalHostName ${COMPUTERNAME:-Pippin}
echo "This computer will now be called ${COMPUTERNAME:-Pippin}."

## Ask for password immediately after screensaver
defaults write com.apple.screensaver askForPassword -int 1 && defaults write com.apple.screensaver askForPasswordDelay -int 0

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

############
## Finder ##
############

## Always show scroll bars
defaults write -g AppleShowScrollBars -string "Always"

## New windows show Desktop
defaults write com.apple.finder NewWindowTarget -string "PfDe" && defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/Desktop/"

## View as list
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

## Show path bar
defaults write com.apple.finder ShowPathbar -bool true

## Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

## Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

## Show expanded file panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true && defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

## Disable Time Machine popup w/ new disks
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

## Relaunch Finder
killall Finder

##############
## Terminal ##
##############

## Use Homebrew theme
defaults write com.apple.Terminal "Default Window Settings" -string "Homebrew" && defaults write com.apple.Terminal "Startup Window Settings" -string "Homebrew"

## Install command line tools
xcode-select --install

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
brew cask install audacity bbedit firefox tower

## Install apps with MAS
brew install mas
read -p "What's your Apple ID?" ID
mas signin --dialog $ID

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
