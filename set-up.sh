#!/bin/bash

# Install brew and some essentials
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew analytics off

brew cask install google-chrome
brew cask install slack

# Set office wireless network
sudo networksetup -addpreferredwirelessnetworkatindex en0 "ComboStrike" 0 WPA2 "ComboStrike<3Games\!"

# Set the screen to lock as soon as the screensaver starts
sudo defaults write com.apple.screensaver askForPassword -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show all filename extensions (so that "Evil.jpg.app" cannot masquerade easily)
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool TRUE 

# Disable crash reporter (the dialog which appears after an application crashes and
# prompts to report the problem to Apple):
sudo defaults write com.apple.CrashReporter DialogType none

# background automatic updates for enforcing critical updates
sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool TRUE
sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool TRUE
sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool TRUE
sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool TRUE
sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool TRUE
sudo /usr/bin/defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool TRUE

# Set Firmware password
# /usr/sbin/firmwarepasswd -setpasswd <password> -setmode command
# /usr/bin/expect -c "spawn /usr/sbin/firmwarepasswd -setpasswd ; expect ":" ; send "$FIRMWARE_PASSWORD\\n" ; expect ":" ; send "$FIRMWARE_PASSWORD\\n" ; interact"

# Enable application level firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Save firewall logs
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

# Stealth mode (don't respond to attempts to access computer from the network)
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Disabled 'allow signed built-in applications automatically'
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

# Disabled allow signed downloaded applications automatically
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# Restart firewall
sudo pkill -HUP socketfilterfw

# Set up password policy
sudo /bin/bash ./pass-policy.sh

# Delete pass env variable
unset $FIRMWARE_PASSWORD

# Manage host file to block malicious domains
curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" | sudo tee -a /etc/hosts

