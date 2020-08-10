## Follow the instructions of the first boot and create user account (you can use generic password, as user will be required to change it after restart)
## Login into created user account
- create environment variable with firmware password
```bash
export FIRMWARE_PASSWORD='<password>'
```
- install xcode command line with
```bash
xcode-select --install
```
- Then run setup script with:
```bash
/bin/sh set-up.sh
```
- Set Chrome policy enrolment
    - In admin console go to Devices
    - Click Chrome management and then Managed browsers
    - At the bottom click "+" to generate enrolment token
    - Click "Download file (MAC & LINUX)
    - create directory `sudo mkdir -p /Library/Google/Chrome`
    - move freshly downloaded file there `sudo mv ~/Downloads/CloudManagementEnrollmentToken /Library/Google/Chrome/`
    - restart Chrome and check if it works, there should be a new laptop in management console
    - for more info or troubleshooting [Google's guide](https://support.google.com/chrome/a/answer/9301891?hl=en)
- Reboot the machine and you'll see new user will be prompted to  change password
## List of features in set-up.sh
- WIP

