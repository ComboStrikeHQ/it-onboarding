#!/bin/bash

# Install xcode, brew and some essentials
xcode-select --install
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
brew analytics off

brew cask install google-chrome
brew cask install slack

# Set the screen to lock as soon as the screensaver starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


# Show all filename extensions (so that "Evil.jpg.app" cannot masquerade easily)
defaults write NSGlobalDomain AppleShowAllExtensions -bool TRUE 

# Disable crash reporter (the dialog which appears after an application crashes and
# prompts to report the problem to Apple):
defaults write com.apple.CrashReporter DialogType none

# background automatic updates for enforcing critical updates
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool TRUE
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool TRUE
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool TRUE
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool TRUE
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool TRUE
/usr/bin/defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool TRUE

# Set Firmware password
# /usr/sbin/firmwarepasswd -setpasswd <password>
# Are we agreeing on one standard for all machines?

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
pkill -HUP socketfilterfw


# Set password policies 10 chars min length and prompt for a new password after reboot
MIN_LENGTH=10

LOGGEDINUSER=$(ls -l /dev/console | awk '{print $3}')


echo "<dict>
 <key>policyCategoryPasswordContent</key>
   <array>
    <dict>
     <key>policyContent</key>
      <string>policyAttributePassword matches '.{$MIN_LENGTH,}+'</string>
     <key>policyIdentifier</key>
      <string>Has at least $MIN_LENGTH characters</string>
     <key>policyParameters</key>
     <dict>
      <key>minimumLength</key>
       <integer>$MIN_LENGTH</integer>
     </dict>
    </dict>
   </array>
</dict>" > /private/var/tmp/pwpolicy.plist


pwpolicy -u $LOGGEDINUSER -clearaccountpolicies
pwpolicy -u $LOGGEDINUSER -setaccountpolicies /private/var/tmp/pwpolicy.plist

pwpolicy -a CSadmin -u $LOGGEDINUSER -setpolicy "newPasswordRequired=1"
