## Creating admin user
- first account on the freshly installed system is admin account
- it can have a generic name like CSadmin and a password we can agree upon
## Creating employee account, a.k.a, standard account
- run script create_user.sh
```bash
sudo /bin/sh create_user.sh
```
- it will prompt for user name
  - user name is first and last name of the new employee
  - password is generic **combostrike** which will prompt users to change themselves afterwards
- also this script activates FileVault encryption for the created user
- to revert user creation (in case name is wrong for example):
```bash
dscl . -list /Users
sudo dscl . -delete /Users/<username>
```
## Login into created user account
It is considered a best practice by [Apple](https://help.apple.com/machelp/mac/10.12/index.html#/mh11389) to use a separate
standard account for daily work and use administrator account only for installations
and administration purposes. Additionally it is a good idea to hide its existence from
from a user.
- hide admin account with following lines
```bash
su CS-admin
sudo dscl . create /Users/CS-admin IsHidden 1
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool FALSE
```
- use the following for a **revert action**
```bash
su CS-admin
sudo dscl . create /Users/CS-admin IsHidden 0
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool TRUE
```