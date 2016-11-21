#!/bin/sh
#
# This script is meant for quick & easy install via:
#   'curl -sSL https://raw.github.com/SmartFinn/unetlab-x-integration/master/install.sh | sudo sh'
# or:
#   'wget -qO- https://raw.github.com/SmartFinn/unetlab-x-integration/master/install.sh | sudo sh'

set -e

URL="https://github.com/SmartFinn/unetlab-x-integration/tarball/master"

# add sudo if user is not root
[ "$(whoami)" = root ] || SUDO="sudo"

command_exists() { command -v "$@" > /dev/null 2>&1; }
verbose() { echo "=>" "$@"; }
die() { echo "$@" >&2; exit 1; }

is_unsupported() {
	cat <<-'EOF' >&2

		Your Linux distribution is not supported.

		Feel free to ask support for it by opening an issue at:
		  https://github.com/SmartFinn/unetlab-x-integration/issues

	EOF
	exit 1
}

do_install() {
	temp_dir=$(mktemp -d)

	verbose "Download and extract into '$temp_dir'..."
	if command_exists wget; then
		wget -qO- "$URL" | tar --strip-components=1 -C "$temp_dir" -xzf -
	else
		curl -sL "$URL" | tar --strip-components=1 -C "$temp_dir" -xzf -
	fi

	verbose "Installing..."
	eval $SUDO install -m 755 "$temp_dir"/unetlab-x-integration /usr/bin/
	eval $SUDO install -m 644 "$temp_dir"/unetlab-x-integration.desktop \
		/usr/share/applications/

	eval $SUDO update-desktop-database -q || true

	verbose "Remove '$temp_dir'..."
	if [ -d "$temp_dir" ]; then
		rm -rf "$temp_dir"
	fi

	verbose "Complete!"

	cat <<-'EOF'

		  Do not forget add the user to the wireshark group:

		    # You will need to log out and then log back in
		    # again for this change to take effect.
		    sudo usermod -a -G wireshark $USER

	EOF

	exit 0
}

# Detect Linux distribution
if [ -r /etc/os-release ]; then
	. /etc/os-release
else
	is_unsupported
fi

verbose "Detected distribution: $ID $VERSION_ID (${ID_LIKE:-"none"})"

# Check if python is installed
if command_exists python; then
	# create variable
	PYTHON=""
fi

for dist_id in $ID $ID_LIKE; do
	case "$dist_id" in
		debian|ubuntu)
			verbose "Install dependencies..."
			eval $SUDO apt-get install -y ${PYTHON="python"} \
				ssh-askpass telnet vinagre wireshark
			do_install
			;;
		arch|archlinux|manjaro)
			verbose "Install dependencies..."
			eval $SUDO pacman -S ${PYTHON="python"} \
				inetutils vinagre wireshark-qt x11-ssh-askpass
			do_install
			;;
		fedora)
			verbose "Install dependencies..."
			eval $SUDO dnf install -y ${PYTHON="python"} \
				telnet vinagre wireshark-qt x11-openssh-askpass
			do_install
			;;
		opensuse|suse)
			verbose "Install dependencies..."
			eval $SUDO zypper install -y ${PYTHON="python"} \
				openssh-askpass telnet vinagre wireshark-ui-qt
			do_install
			;;
		*)
			continue
			;;
	esac
done

is_unsupported
