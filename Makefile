BUILD_DIR := ./build

all: deb

install:
	install -m 755 -D -t $(DESTDIR)/usr/bin/ unetlab-x-integration
	install -m 644 -D -t $(DESTDIR)/usr/share/applications/ unetlab-x-integration.desktop
	# build cache database of MIME types handled by desktop files
	update-desktop-database -q || true

uninstall:
	-rm -f $(DESTDIR)/usr/bin/unetlab-x-integration
	-rm -f $(DESTDIR)/usr/share/applications/unetlab-x-integration.desktop

defaults:
	xdg-mime default unetlab-x-integration.desktop x-scheme-handler/capture
	xdg-mime default unetlab-x-integration.desktop x-scheme-handler/telnet
	xdg-mime default unetlab-x-integration.desktop x-scheme-handler/docker

prepare_deb: clean
	install -m 755 -D -t "$(BUILD_DIR)/DEBIAN/" debian/postinst
	install -m 755 -D -t "$(BUILD_DIR)/DEBIAN/" debian/postrm
	install -m 755 -D -t "$(BUILD_DIR)/usr/bin/" unetlab-x-integration
	install -m 644 -D -t "$(BUILD_DIR)/usr/share/applications/" \
		unetlab-x-integration.desktop
	# generate DEBIAN/control
	BUILD_DIR="$(BUILD_DIR)" sh debian/control.template

deb: prepare_deb
	$(eval PKG_FILENAME := $(shell awk ' \
		/^Package:/      {name=$$2} \
		/^Version:/      {vers=$$2} \
		/^Architecture:/ {arch=$$2} \
		END {print name "_" vers "_" arch}' "$(BUILD_DIR)/DEBIAN/control"))
	fakeroot dpkg-deb --build "$(BUILD_DIR)" "$(PKG_FILENAME).deb"

clean:
	-rm -rf "$(BUILD_DIR)"
	-rm -f *.deb

check_release:
ifndef TAG
	$(error TAG is not defined. Pass via "make release TAG=v0.1.2")
endif

release: check_release
	git tag $(TAG)
	git push origin master
	git push origin --tags
	$(MAKE) deb

.PHONY: all install uninstall defaults prepare_deb deb clean \
	check_release release
