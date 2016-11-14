UNetLab-X-Integration
=====================

This repo contains the equivalent of [Windows integration pack](http://www.unetlab.com/download/UNetLab-Win-Client-Pack.exe) for Ubuntu/Debian and other.


Install
-------

#### From a deb package

If you are using **Ubuntu**, **Debian** or **Linux Mint** just download and install the latest .deb package at [https://github.com/SmartFinn/unetlab-x-integration/releases](https://github.com/SmartFinn/unetlab-x-integration/releases).

#### Manual install

1. Clone this repo

	```
	git clone https://github.com/SmartFinn/unetlab-x-integration.git
	```
	or download and extract the zip file
	```
	wget -O unetlab-x-integration.zip https://github.com/SmartFinn/unetlab-x-integration/archive/master.zip
	unzip unetlab-x-integration.zip
	```

2. Run `install` target as root

	```
	cd unetlab-x-integration/
	sudo make install
	```

3. Install dependencies

	* python >= 2.7 _(required)_
	* telnet _(required)_
	* wireshark _(recommended)_
	* ssh-askpass | ssh-askpass-gnome _(recommended)_
	* vinagre _(recommended)_
	* docker-engine _(optional)_

	Ubuntu, Debian, Linux Mint

	```
	sudo apt-get install python telnet wireshark ssh-askpass-gnome vinagre
	```

	Arch Linux, Manjaro

	```
	sudo pacman -S python inetutils wireshark-gtk x11-ssh-askpass vinagre

	# workaround "x-terminal-emulator: command not found"
	sudo ln -s /usr/bin/uxterm /usr/bin/x-terminal-emulator

	# workaround "wireshark: command not found"
	sudo ln -s /usr/bin/wireshark-gtk /usr/bin/wireshark
	```

Have a trouble?
---------------

If you have any issues or problems please post it on the issues tab.

English, Russian and Ukrainian are welcomed.
