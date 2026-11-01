include $(TOPDIR)/rules.mk

PKG_NAME:=extroot-sysupgrade
PKG_RELEASE:=12

include $(INCLUDE_DIR)/package.mk

define Package/extroot-sysupgrade
  PKGARCH:=all
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Safe extroot migration across sysupgrade
  DEPENDS:=+block-mount +apk-mbedtls
endef

define Package/extroot-sysupgrade/description
  Rebuilds an external overlay after sysupgrade and restores user packages
  without allowing stale package files to shadow the new firmware.
endef

define Build/Compile
endef

define Package/extroot-sysupgrade/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/uci-defaults $(1)/lib/upgrade/keep.d $(1)/usr/libexec
	$(INSTALL_BIN) ./files/extroot-sysupgrade.init $(1)/etc/init.d/extroot-sysupgrade
	$(INSTALL_BIN) ./files/extroot-post-upgrade.init $(1)/etc/init.d/extroot-post-upgrade
	$(INSTALL_BIN) ./files/95-extroot-sysupgrade $(1)/etc/uci-defaults/95-extroot-sysupgrade
	$(INSTALL_DATA) ./files/extroot-sysupgrade.sh $(1)/lib/upgrade/90-extroot-sysupgrade.sh
	echo /etc/config/ddnsto > $(1)/lib/upgrade/keep.d/ddnsto
	$(INSTALL_DATA) ./files/extroot-device.sh $(1)/usr/libexec/extroot-device.sh
	$(INSTALL_BIN) ./files/extroot-sysupgrade-run $(1)/usr/libexec/extroot-sysupgrade
endef

$(eval $(call BuildPackage,extroot-sysupgrade))
