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

##########
# Safari #
##########

echo "Setting up Safari…"

# Improving security with sensible defaults
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.Safari ShowOverlayStatusBar -bool true

# Disabling autofill
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillFromiCloudKeychain -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false

# Enabling the Develop menu
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Setting up website permissions
defaults write com.apple.Safari CanPromptForPushNotifications -bool false

# Setting up the Favorites page
defaults write com.apple.Safari ShowBackgroundImageInFavorites -bool false
defaults write com.apple.Safari ShowCloudTabsInFavorites -bool true
defaults write com.apple.Safari ShowFrequentlyVisitedSites -bool false
defaults write com.apple.Safari ShowHighlightsInFavorites -bool false
defaults write com.apple.Safari ShowPrivacyReportInFavorites -bool false
defaults write com.apple.Safari ShowReadingListInFavorites -bool false

######################
# Keyboard and mouse #
######################

echo "Setting up keyboard and mouse…"

# Disabling accent menu
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Speeding up key repetition
defaults write NSGlobalDomain InitialKeyRepeat -int 25
defaults write NSGlobalDomain KeyRepeat -int 5

# Enabling keyboard navigation
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Using the Globe key to open the Unicode picker
defaults write com.apple.HIToolbox AppleFnUsageType -int 2

# Disabling keyboard substitutions
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled = 0;
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled = 0;
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled = 0;

# Enabling inline prediction (i hate myself)
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled = 1;

# Setting up pointer speed
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

#################################
# Siri and Apple ‘Intelligence’ #
#################################

echo "Setting up Siri…"

# Disabling dictation
defaults write com.apple.assistant.support "Dictation Enabled" -bool false

# Disabling dictation auto-activation
defaults write com.apple.HIToolbox AppleDictationAutoEnable -bool false

# Disabling as many Siri services as possible
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.assistant.support "Siri Data Sharing Opt-In Status" -bool false
defaults write com.apple.siri.generativeassistantsettings "Assistant Enabled" -bool false

# Disabling as many Apple Intelligence services as possible
defaults write com.apple.CloudSubscriptionFeatures.optIn "158330617" -bool false # WTF, Apple?
defaults write com.apple.CloudSubscriptionFeatures.optIn "device" -bool false
defaults write com.apple.AppleIntelligenceReport "isEnabled" -bool false

############
# Terminal #
############

echo "Setting up Terminal…"

## Setting up the theme
defaults write com.apple.Terminal "Default Window Settings" -string "Clear Dark"
defaults write com.apple.Terminal "Startup Window Settings" -string "Clear Dark"

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
