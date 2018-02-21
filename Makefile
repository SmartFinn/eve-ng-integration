all:

install:
	mkdir -p "$(DESTDIR)/usr/bin"
	install -m 755 bin/eve-ng-integration $(DESTDIR)/usr/bin/
	install -m 755 bin/eni-rdp-wrapper $(DESTDIR)/usr/bin/
	mkdir -p "$(DESTDIR)/usr/share/applications"
	install -m 644 data/eve-ng-integration.desktop $(DESTDIR)/usr/share/applications/
	install -m 644 data/eni-rdp-wrapper.desktop $(DESTDIR)/usr/share/applications/
	mkdir -p "$(DESTDIR)/usr/share/mime/packages"
	install -m 644 data/eni-rdp-wrapper.xml $(DESTDIR)/usr/share/mime/packages/

# skip post-install goal when packaging
	$(if $(DESTDIR),,$(MAKE) post-install)

post-install:
	# build cache database of MIME types handled by desktop files
	update-desktop-database -q || true
	# build the Shared MIME-Info database cache
	update-mime-database -n /usr/share/mime || true

uninstall:
	-rm -f $(DESTDIR)/usr/bin/eve-ng-integration
	-rm -f $(DESTDIR)/usr/bin/eni-rdp-wrapper
	-rm -f $(DESTDIR)/usr/share/applications/eve-ng-integration.desktop
	-rm -f $(DESTDIR)/usr/share/applications/eni-rdp-wrapper.desktop
	-rm -f $(DESTDIR)/usr/share/mime/packages/eni-rdp-wrapper.xml

defaults:
	# setup as default handler for the next URL schemes (don't run it as root)
	mkdir -p $(HOME)/.local/share/applications/
	xdg-mime default eve-ng-integration.desktop x-scheme-handler/capture
	xdg-mime default eve-ng-integration.desktop x-scheme-handler/telnet
	xdg-mime default eve-ng-integration.desktop x-scheme-handler/docker
	xdg-mime default eve-ng-integration.desktop x-scheme-handler/vnc
	xdg-mime default eni-rdp-wrapper.desktop application/x-rdp

check_release:
ifndef TAG
	$(error TAG is not defined. Pass via "make release TAG=v0.1.2")
endif

release: check_release
	git tag -f $(TAG)
	git push origin master
	git push origin --tags

.PHONY: all install post-install uninstall defaults check_release release
