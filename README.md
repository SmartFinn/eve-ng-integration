# UNetLab-X-Integration

This repo contains the equivalent of [Windows integration pack](http://www.unetlab.com/download/UNetLab-Win-Client-Pack.exe) for Ubuntu/Debian and other Linux distos.


## Installation

If you have **Ubuntu**, **Debian**, **Linux Mint** and other Debian-based distros you may simply download and install the latest .deb package at [https://github.com/SmartFinn/unetlab-x-integration/releases](https://github.com/SmartFinn/unetlab-x-integration/releases).

Alternatively, you can install it from terminal with the following command:

```
wget -qO- https://raw.github.com/SmartFinn/unetlab-x-integration/master/install.sh | sh
```

This method works on other Linux distros too. Currently supported installation on **Arch Linux**, **Manjaro**, **Fedora** and more...

If your Linux distribution is not supported yet, don't give up, try [Manual install](#manual-install) or create [new issue](https://github.com/SmartFinn/unetlab-x-integration/issues).

#### Manual install

1. Clone this repo

  ```
  git clone https://github.com/SmartFinn/unetlab-x-integration.git
  ```
  or download and extract the tarball
  ```
  wget -O unetlab-x-integration.tar.gz https://github.com/SmartFinn/unetlab-x-integration/tarball/master
  tar -xzvf unetlab-x-integration.tar.gz
  ```

2. Run `make install` as root

  ```
  cd unetlab-x-integration/
  sudo make install
  ```

3. Install dependencies

  * `python` >= 2.7 _(required)_
  * `telnet` _(required)_
  * `wireshark` _(recommended)_
  * `ssh-askpass` _(recommended)_
  * `vinagre` _(recommended)_
  * `docker-engine` _(optional)_

4. Enjoy!

## Have a trouble?

If you have any issues or problems please post it on the issues tab.

English, Russian and Ukrainian are welcomed.
