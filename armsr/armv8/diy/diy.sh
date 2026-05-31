#!/bin/bash

# Adjust source code
patch -p1 -f < $(dirname "$0")/luci.patch

# Clone packages
git clone https://github.com/Openwrt-Passwall/openwrt-passwall --depth=1 clone/passwall

# Adjust packages
rm -rf feeds/luci/applications/luci-app-passwall
cp -rf clone/passwall/luci-app-passwall feeds/luci/applications/
sed -i '/luci-app-attendedsysupgrade/d' feeds/luci/collections/luci/Makefile

# Clean packages
rm -rf clone