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
- DNS settings (optional but highly recommended, becuase it will reduce risk of DNS spoofing and eavesdropping):
    - uncomment line in dnscrypt config file `vim $(brew --prefix)/etc/dnscrypt-proxy.toml`
    - check `listen_adresses` parameter as well. It should be `listen_addresses = ['127.0.0.1:5355', '[::1]:5355']`
    - add dnsmasq dns server to Network settings `sudo networksetup -setdnsservers "Wi-Fi" 127.0.0.1`
    - start dnsmasq and dnscrypt (will automatically start on boot afterwards)
    ```bash
    sudo brew services start dnscrypt-proxy
    sudo brew services start dnsmasq
    ```
    - make sure dnscrypt is running `sudo lsof +c 15 -Pni UDP:5355`
- Reboot the machine and you'll see new user will be prompted to  change password
## List of features in set-up.sh
- WIP

