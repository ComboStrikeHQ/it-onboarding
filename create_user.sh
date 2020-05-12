#!/bin/bash

# Admin credentials to enable FileVault for a new user
# Initially can be hardcoded when we agree on using some standard ones for admin user
read -p $'give your admin name (for example: CSadmin):\n' ADMINNAME
read -sp $'Pass:\n' ADMINPASS

read -p $'\nFirst Name for created user:\n' FIRST
read -p $'\nFamily Name for created user:\n' FAMILY

USERNAME=$(echo "$FIRST$FAMILY" | awk '{print tolower($0)}')
FULLNAME="$FIRST $FAMILY"
PASSWORD="combostrike"

# ====

if [[ $UID -ne 0 ]]; then echo "Please run $0 as root." && exit 1; fi

# Find out the next available user ID
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))

# Create the user account
dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/bash
dscl . -create /Users/$USERNAME RealName "$FULLNAME"
dscl . -create /Users/$USERNAME UniqueID "$USERID"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME

dscl . -passwd /Users/$USERNAME $PASSWORD


# Create the home directory
createhomedir -c -u $USERNAME > /dev/null

echo "Created user #$USERID: $USERNAME ($FULLNAME)"

# Set Secure Token for newly created account
# This one will be needed for FaulVault activation
sysadminctl -adminUser $ADMINNAME -adminPassword $ADMINPASS -secureTokenOn $USERNAME -password $PASSWORD

# Enable FileVault
fdesetup enable -user $ADMINNAME -usertoadd $USERID
