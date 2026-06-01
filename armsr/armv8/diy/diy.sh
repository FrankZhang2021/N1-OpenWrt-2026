#!/bin/bash

# Adjust source code
patch -p1 -f < $(dirname "$0")/luci.patch


# Adjust packages

# mosdns v5 on snapshots/openwrt-25.12 requires newer golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 26.x --depth=1 feeds/packages/lang/golang

# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/v2dat
rm -rf feeds/packages/net/mosdns

# 移除本地 package 中可能残留的主题和设置插件
rm -rf package/luci-theme-argon
rm -rf package/luci-app-argon-config
rm -rf package/mosdns
rm -rf package/v2ray-geodata
rm -rf package/v2dat

# Clone packages
git clone https://github.com/Openwrt-Passwall/openwrt-passwall --depth=1 clone/passwall
git clone https://github.com/sbwml/luci-app-mosdns -b v5 --depth=1 clone/mosdns
git clone https://github.com/sbwml/v2ray-geodata --depth=1 clone/v2ray-geodata
git clone https://github.com/xiaorouji/openwrt-passwall-packages --depth=1 clone/passwall-packages
git clone https://github.com/jerrykuku/luci-theme-argon --depth=1 package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config --depth=1 package/luci-app-argon-config

cp -rf clone/passwall/luci-app-passwall feeds/luci/applications/
cp -rf clone/mosdns/luci-app-mosdns feeds/luci/applications/
cp -rf clone/v2ray-geodata feeds/packages/net/
cp -rf clone/passwall-packages/v2dat feeds/packages/net/
cp -rf clone/mosdns/mosdns feeds/packages/net/

sed -i '/luci-app-attendedsysupgrade/d' feeds/luci/collections/luci/Makefile

# Clean packages
rm -rf clone
