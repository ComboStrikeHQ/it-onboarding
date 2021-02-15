#!/bin/sh

deployPasswordPolicy() {
    MIN_LENGTH=12
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

    echo $PASSWORD | sudo -S pwpolicy -u $LOGGEDINUSER -clearaccountpolicies
    echo $PASSWORD | sudo -S pwpolicy -u $LOGGEDINUSER -setaccountpolicies /private/var/tmp/pwpolicy.plist
    echo $PASSWORD | sudo -S pwpolicy -a $LOGGEDINUSER -u $LOGGEDINUSER -setpolicy "newPasswordRequired=1"
}
# can't indent osascript, because it yields error
getPassword() {
osascript <<-EndOfScript
text returned of (display dialog "Please type your password. Make sure it is right." default answer "")
EndOfScript
}

# FileVault encryption
encryption () {
    if ! fdesetup isactive; then
        echo $PASSWORD | sudo -S fdesetup enable -user $LOGGEDINUSER -password $PASSWORD
    fi
}

main () {
    LOGGEDINUSER="$(ls -l /dev/console | awk '{print $3}')"


    # first try
    PASSWORD="$(getPassword)"
    encryption | tee ~/Desktop/SEND_ME.txt

    # loop if password was wrong
    while (! fdesetup isactive); do
        osascript -e 'display dialog "Wrong password, please try again."'
        PASSWORD="$(getPassword)"
	encryption | tee ~/Desktop/SEND_ME.txt
    done

    # force pass change and infrom a user
    # check if pass was correct and it has to be changed
    if ((${#PASSWORD} < 12)) && (sudo -n true 2>/dev/null);
    then
    	deployPasswordPolicy
        osascript -e 'display dialog "Your password is too short. After restart you will be required to change it with minimum 12 symbols."'
    # incorrect pass
    elif (! sudo -n true 2>/dev/null);
    then
	# get the correct pass
	while (! sudo -n true 2>/dev/null); do
            osascript -e 'display dialog "Wrong password, please try again."'
            PASSWORD="$(getPassword)"
	    if ((${#PASSWORD} < 12));
	    then	
    	        deployPasswordPolicy
                osascript -e 'display dialog "Your password was too short. After restart you will be required to change it with minimum 12 symbols."'
	    else
		break
	    fi
        done
    fi

    # done, collect id and inform a user
    echo "$LOGGEDINUSER" >> ~/Desktop/SEND_ME.txt
    osascript -e 'display dialog "Done, thank you!\nPlease do not forget to send us back the file SEND_ME.txt that was saved on your desktop."'
}

main
