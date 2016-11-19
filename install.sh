#!/bin/sh
#
# This script is meant for quick & easy install via:
#   'curl -sSL https://raw.github.com/SmartFinn/unetlab-x-integration/master/install.sh | sudo sh'
# or:
#   'wget -qO- https://raw.github.com/SmartFinn/unetlab-x-integration/master/install.sh | sudo sh'

set -e

URL="https://github.com/SmartFinn/unetlab-x-integration/tarball/master"

# add sudo if user is not root
[ "`whoami`" = root ] || SUDO="sudo"

command_exists() { command -v "$@" > /dev/null 2>&1; }
verbose() { echo "* $@" >&2; }
die() { echo "! $@" >&2; exit 1; }

is_unsupported() {
	cat >&2 <<-'EOF'

		Your Linux distribution is not supported.

		Feel free to ask support for it by opening an issue at:
		  https://github.com/SmartFinn/unetlab-x-integration/issues

	EOF
	exit 1
}

do_install() {
	temp_dir=$(mktemp -d)

	verbose "Download and extract into "$temp_dir"..."
	if command_exists wget; then
		wget -qO- "$URL" | tar --strip-components=1 -C "$temp_dir" -xzf -
	else
		curl -sL "$URL" | tar --strip-components=1 -C "$temp_dir" -xzf -
	fi

	verbose "Installing..."
	$SUDO install -m 755 -d /usr/bin/
	$SUDO install -m 755 -d /usr/share/applications/
	$SUDO install -m 755 "$temp_dir"/unetlab-x-integration /usr/bin/
	$SUDO install -m 644 "$temp_dir"/unetlab-x-integration.desktop \
		/usr/share/applications/

	$SUDO update-desktop-database -q || true

	verbose "Remove '$temp_dir'..."
	if [ -d "$temp_dir" ]; then
		rm -rf "$temp_dir"
	fi

	verbose "Complete!"

	cat >&2 <<-'EOF'

		  Do not forget add the user to the wireshark group:

		    # You will need to log out and then log back in
		    # again for this change to take effect.
		    sudo usermod -a -G wireshark $USER


	EOF

	exit 0
}

# Detect what version of OS they are using
if [ -r /etc/os-release ]; then
	. /etc/os-release
elif command_exists lsb_release; then
	ID=$(lsb_release -si | tr -d '[:blank:]' | tr '[:upper:]' '[:lower:]')
	VERSION_ID=$(lsb_release -sr)
else
	is_unsupported
fi

verbose "Detected distribution: $ID (${ID_LIKE:-"none"}), $VERSION_ID"

# Check if python is installed
if command_exists python; then
	PYTHON=""
fi

for dist_id in $ID $ID_LIKE; do
	case "$dist_id" in
		debian|ubuntu)
			verbose "Install dependencies..."
			$SUDO apt-get install -y ${PYTHON-"python"} \
				ssh-askpass telnet vinagre wireshark
			do_install
			;;
		arch|archlinux|manjaro)
			verbose "Install dependencies..."
			$SUDO pacman -S ${PYTHON-"python"} \
				inetutils vinagre wireshark-qt x11-ssh-askpass
			do_install
			;;
		fedora)
			verbose "Install dependencies..."
			$SUDO dnf install -y ${PYTHON-"python"} \
				telnet vinagre wireshark-qt x11-openssh-askpass
			do_install
			;;
		*)
			continue
			;;
	esac
done

is_unsupported
