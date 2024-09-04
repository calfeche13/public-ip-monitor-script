# See /LICENSE for more information.
# This is free software, licensed under the GNU General Public License v2.

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Openwrt Public IP Monitor script
LUCI_DEPENDS:=+curl \
	+jq
LUCI_PKGARCH:=all

PKG_LICENSE:=AGPL-3.0
PKG_MAINTAINER:=Chosen Realm Alfeche <calfeche13>

PKG_VERSION:=v0.0.1

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
