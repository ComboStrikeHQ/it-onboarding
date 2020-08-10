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
- Reboot the machine and you'll see new user will be prompted to  change password
## List of features in set-up.sh
- WIP

