PKG_NAME    := $(shell awk '/^Package:/ {print $$2}' debian/control)
PKG_VERSION := $(shell awk '/^Version:/ {print $$2}' debian/control)
PKG_ARCH    := $(shell awk '/^Architecture:/ {print $$2}' debian/control)
DEB := $(PKG_NAME)_$(PKG_VERSION)_$(PKG_ARCH).deb

all: deb

prepare_deb: clean
	mkdir -p build/DEBIAN build/usr/bin build/usr/share/applications
	cp debian/control build/DEBIAN/control
	cp debian/postinst build/DEBIAN/postinst
	cp debian/postrm build/DEBIAN/postrm
	cp unetlab-x-integration build/usr/bin/unetlab-x-integration
	cp unetlab-x-integration.desktop \
		build/usr/share/applications/unetlab-x-integration.desktop
	chmod 755 build/DEBIAN build/usr build/usr/bin build/usr/share \
		build/usr/share/applications \
		build/usr/bin/unetlab-x-integration \
		build/DEBIAN/post*
	chmod 644 build/DEBIAN/control \
		build/usr/share/applications/unetlab-x-integration.desktop

deb: prepare_deb
	fakeroot dpkg-deb --build build $(DEB)

clean:
	-rm -rf build/
	-rm -f $(DEB)

.PHONY: all prepare_deb deb clean
