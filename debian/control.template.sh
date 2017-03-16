#!/bin/sh

set -e

CONTROL="${BUILD_DIR:=./build}/DEBIAN/control"
VERSION=$(git describe --tags --always --long | \
	sed -e 's/^[^0-9]\+\([0-9]\+\.\)/\1/' -e 's/-g[0-9a-f]\+$//')
SIZE=$(du -bsL "${BUILD_DIR:=./build}" | cut -f 1)

if [ -f "$CONTROL" ]; then
	echo "File '$CONTROL' already exits!"
	exit 1
fi

cat <<-EOF > "$CONTROL"
Package: eve-ng-integration
Priority: optional
Section: net
Maintainer: Sergei Eremenko <finalitik@gmail.com>
Architecture: all
Version: ${VERSION}
Installed-Size: ${SIZE}
Depends: python, ssh-askpass-gnome | ssh-askpass, telnet, vinagre, wireshark, xterm | x-terminal-emulator
Suggests: docker-engine | docker.io
Replaces: unetlab-x-integration
Homepage: http://github.com/smartfinn/eve-ng-integration
Description: EVE-NG (desktop integration)
 This package provides URL handler for the following URL schemes:
  * telnet://
  * capture://
  * docker://
EOF
