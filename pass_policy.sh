# Set password policies 10 chars min length and prompt for a new password after reboot
MIN_LENGTH=10

LOGGEDINUSER=$(ls -l /dev/console | awk '{print $3}')
PASSWORD="combostrike"

# enforce FileVault disk encryption

if ! fdesetup isactive; then
	sudo fdesetup enable -user $LOGGEDINUSER -password $PASSWORD
fi



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


sudo pwpolicy -u $LOGGEDINUSER -clearaccountpolicies
sudo pwpolicy -u $LOGGEDINUSER -setaccountpolicies /private/var/tmp/pwpolicy.plist

sudo pwpolicy -a $LOGGEDINUSER -u $LOGGEDINUSER -setpolicy "newPasswordRequired=1"
