#
# Package name: shadowsocks-libev
# version: 2.4.8
# Revised for ss-plus.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocks-libev
PKG_VERSION:=2.4.8
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/shadowsocks/shadowsocks-libev.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=9a43cc6e6b61d16c157d53ab7f22a34ae61a9bc4
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_MAINTAINER:=Max Lv <max.c.lv@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/Default
  SECTION:=everun
  CATEGORY:=everun
  SUBMENU:=2. Applications
  TITLE:=Lightweight Secured Socks5 Proxy
  URL:=https://github.com/madeye/shadowsocks-libev
endef

define Package/$(PKG_NAME)
  $(call Package/$(PKG_NAME)/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpthread
endef

define Package/$(PKG_NAME)-polarssl
  $(call Package/$(PKG_NAME)/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread
endef

define Package/$(PKG_NAME)-mbedtls
  $(call Package/$(PKG_NAME)/Default)
  TITLE+= (mbedTLS)
  VARIANT:=mbedtls
  DEPENDS:=+libmbedtls +libpthread
endef

define Package/$(PKG_NAME)/description
Shadowsocks-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/$(PKG_NAME)-polarssl/description=$(Package/$(PKG_NAME)/description)
Package/$(PKG_NAME)-mbedtls/description=$(Package/$(PKG_NAME)/description)

#define Package/$(PKG_NAME)/conffiles
#/etc/shadowsocks.json
#endef

CONFIGURE_ARGS += --disable-documentation --disable-ssp

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

ifeq ($(BUILD_VARIANT),mbedtls)
	CONFIGURE_ARGS += --with-crypto-library=mbedtls
endif

define Package/$(PKG_NAME)/install
#	$(INSTALL_DIR) $(1)/etc/init.d
#	$(INSTALL_CONF) ./files/shadowsocks.json $(1)/etc
#	$(INSTALL_BIN) ./files/shadowsocks.init $(1)/etc/init.d/shadowsocks
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-{local,redir,tunnel} $(1)/usr/bin
endef

Package/$(PKG_NAME)-polarssl/install=$(Package/$(PKG_NAME)/install)
Package/$(PKG_NAME)-mbedtls/install=$(Package/$(PKG_NAME)/install)

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-polarssl))
$(eval $(call BuildPackage,$(PKG_NAME)-mbedtls))
