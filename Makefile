BUILD_DIR := ./build

all: install

install:
	install -m 755 -d /usr/bin/
	install -m 755 -d /usr/share/applications/
	install -m 755 unetlab-x-integration /usr/bin/
	install -m 644 unetlab-x-integration.desktop /usr/share/applications/

	update-desktop-database -q || true

uninstall:
	-rm -f /usr/bin/unetlab-x-integration
	-rm -f /usr/share/applications/unetlab-x-integration.desktop

defaults:
	xdg-mime default unetlab-x-integration.desktop x-scheme-handler/capture
	xdg-mime default unetlab-x-integration.desktop x-scheme-handler/telnet
	xdg-mime default unetlab-x-integration.desktop x-scheme-handler/docker

prepare_deb: clean
	mkdir -p $(BUILD_DIR)/DEBIAN \
		$(BUILD_DIR)/usr/bin \
		$(BUILD_DIR)/usr/share/applications
	# copy files
	cp debian/postinst $(BUILD_DIR)/DEBIAN/postinst
	cp debian/postrm $(BUILD_DIR)/DEBIAN/postrm
	cp unetlab-x-integration $(BUILD_DIR)/usr/bin/unetlab-x-integration
	cp unetlab-x-integration.desktop \
		$(BUILD_DIR)/usr/share/applications/unetlab-x-integration.desktop
	# generate DEBIAN/control
	BUILD_DIR=$(BUILD_DIR) sh debian/control.template
	# fix permissions
	chmod 755 $(BUILD_DIR)/DEBIAN \
		$(BUILD_DIR)/usr \
		$(BUILD_DIR)/usr/bin \
		$(BUILD_DIR)/usr/share \
		$(BUILD_DIR)/usr/share/applications \
		$(BUILD_DIR)/usr/bin/unetlab-x-integration \
		$(BUILD_DIR)/DEBIAN/post*
	chmod 644 $(BUILD_DIR)/DEBIAN/control \
		$(BUILD_DIR)/usr/share/applications/unetlab-x-integration.desktop

deb: prepare_deb
	$(eval PKG_FILENAME := $(shell awk ' \
		/^Package:/      {name=$$2} \
		/^Version:/      {vers=$$2} \
		/^Architecture:/ {arch=$$2} \
		END {print name "_" vers "_" arch}' $(BUILD_DIR)/DEBIAN/control))
	fakeroot dpkg-deb --build build $(PKG_FILENAME).deb

clean:
	-rm -rf $(BUILD_DIR)/
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

.PHONY: all install uninstall prepare_deb deb clean check_release release
