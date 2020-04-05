#!/bin/bash

##########################################################################################
##########################################################################################
##                                                                                      ##
## Paramétrage rapide d’un Mac                                                          ##
## v202004051221                                                                        ##
##                                                                                      ##
## Anthony Nelzin-Santos                                                                ##
## https://anthony.nelzin.fr                                                            ##
##                                                                                      ##
## Licence CeCILL                                                                       ##
## http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt                           ##
##                                                                                      ##
##########################################################################################
##########################################################################################

echo "La configuration de cette machine va commencer."

##################################
## Ouverture d’une session sudo ##
##################################
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############
## Démarrage ##
###############

## Désactiver le son de démarrage
nvram SystemAudioVolume="%00"

## Activer le « powerchime » façon iOS
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true && open /System/Library/CoreServices/PowerChime.app

## Paramétrer le nom de la machine
read -p "Quel est le nom de cette machine ?" COMPUTERNAME
scutil --set ComputerName ${COMPUTERNAME:-Pippin}
scutil --set HostName ${COMPUTERNAME:-Pippin}
scutil --set LocalHostName ${COMPUTERNAME:-Pippin}
echo "Cette machine s’appellera ${COMPUTERNAME:-Pippin}."

##############
## Sécurité ##
##############

## Exiger le mot de passe immédiatement après la suspension d’activité
defaults write com.apple.screensaver askForPassword -int 1 && defaults write com.apple.screensaver askForPasswordDelay -int 0

## Configurer le pare-feu
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on &&/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on && /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on && /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off && /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off && pkill -HUP socketfilterfw

## Désactiver la connexion aux portails captifs
defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

#############
## Clavier ##
#############

## Activer l’accès au clavier complet
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

## Désactiver la correction automatique et les autres assistances
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false && defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false && defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false && defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false && defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false && defaults write -g ApplePressAndHoldEnabled -bool false

############
## Souris ##
############

## Sens du défilement : (vraiment) naturel
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

## Toucher pour cliquer
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 && defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true && defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

## Configurer la meilleure couleur de contraste
defaults write NSGlobalDomain AppleHighlightColor "0.968627 0.831373 1.000000"

##########
## Dock ##
##########

## Placer le Dock dans la bonne position
defaults write com.apple.dock orientation -string "left"

## Masquer/afficher le Dock automatiquement
defaults write com.apple.dock autohide -boolean yes

## Réduire les fenêtres dans l’icône de l’application
defaults write com.apple.dock minimize-to-application -bool true

## Relancer le Dock
killall Dock

#####################
## Mission Control ##
#####################

## Ne pas réarranger automatiquement les Spaces en fonction de votre utilisation la plus récente
defaults write com.apple.dock mru-spaces -bool false

## Grouper les fenêtres par application
defaults write com.apple.dock expose-group-by-app -bool true

## Coin actif > en bas à gauche : Mission Control
defaults write com.apple.dock wvous-bl-corner -int 2 && defaults write com.apple.dock wvous-bl-modifier -int 0

## Coin actif > en haut à droite : mettre le moniteur en veille
defaults write com.apple.dock wvous-tr-corner -int 10 && defaults write com.apple.dock wvous-tr-modifier -int 0

############
## Finder ##
############

## Afficher les barres de défilement : toujours
defaults write -g AppleShowScrollBars -string "Always"

## Désactiver l’affichage du Bureau
defaults write com.apple.finder CreateDesktop -bool false

## Les nouvelles fenêtres de Finder affichent : Bureau
defaults write com.apple.finder NewWindowTarget -string "PfDe" && defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/Desktop/"

## Présentation > Par liste
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

## Présentation > Afficher la barre du chemin d’accès
defaults write com.apple.finder ShowPathbar -bool true

## Présentation > Afficher la barre d’état
defaults write com.apple.finder ShowStatusBar -bool true

## Afficher toutes les extension des fichiers
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

## Ne pas avertir avant de modifier une extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

## Afficher le panneau de sauvegarde étendu par défaut
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true && defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

## Couper le dialogue Time Machine à l’insertion d’un nouveau disque
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

## Relancer le Finder
killall Finder

##############
## Terminal ##
##############

defaults write com.apple.Terminal "Default Window Settings" -string "Homebrew" && defaults write com.apple.Terminal "Startup Window Settings" -string "Homebrew"

##############
## Homebrew ##
##############

echo "La configuration de cette machine est terminée. L’installation des applications et des utilitaires va commencer."

## Installer outils en ligne de commande
xcode-select --install

## Installer Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

## Installer Cask
brew tap caskroom/cask

## Installer applications avec Cask
brew cask install 1password alfred bbedit coconutbattery displaycal dropbox firefox iina imageoptim itunes-producer kindlegen libreoffice mactex mattermost musicbrainz-picard netnewswire sketch skitch tower xld

## Installer applications avec MAS
brew install mas
read -p "Quel est votre identifiant Apple ?" ID
mas signin --dialog $ID

mas install 1333542190 # 1 Password 7
mas install 961632517 # Be Focused Pro
mas install 1435957248 # Drafts
mas install 1464122853 # NextDNS
mas install 924891282 # Pixave
mas install 407963104 # Pixelmator
mas install 904280696 # Things
mas install 1384080005 # Tweetbot
mas install 1225570693 # Ulysses

## Installer utilitaires
brew install ffmpeg handbrake hugo imagemagick multimarkdown pandoc python3 youtube-dl
pip3 install bs4 lxml markdown numpy pillow sklearn

## Vider le Dock
defaults write com.apple.dock persistent-apps -array

## Ajouter apps au Dock
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Antidote\ 10.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/BBEdit.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Drafts.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Music.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/NetNewsWire.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Things.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Tower.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Ulysses.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

## Relancer le Dock
killall Dock

## Lancement des applications pour se connecter aux services et entrer les licences
open -a 1Password \7 && open -a BBEdit && open -a Dropbox && open -a Things && open -a Tower

echo "L’installation des applications et des utilitaires est terminée. Au travail !"
