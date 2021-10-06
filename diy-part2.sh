#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#


# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修复核心及添加温度显示
sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# Add luci-app-ssr-plus
# pushd package/lean
# git clone --depth=1 https://github.com/fw876/helloworld
# popd

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add Lienol's Packages
# git clone --depth=1 https://github.com/Lienol/openwrt-package
# rm -rf ../lean/luci-app-kodexplorer

# Add luci-app-passwall
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

# Add luci-app-vssr <M>
# git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
# git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

# Add luci-proto-minieap
# git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap

# Add ServerChan
# git clone --depth=1 https://github.com/tty228/luci-app-serverchan

# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash

# Add luci-app-onliner
# git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add luci-app-diskman
# git clone --depth=1 https://github.com/SuLingGG/luci-app-diskman
# mkdir parted
# cp luci-app-diskman/Parted.Makefile parted/Makefile

# Add luci-app-dockerman
rm -rf ../lean/luci-app-docker
# git clone --depth=1 https://github.com/lisaac/luci-app-dockerman
# git clone --depth=1 https://github.com/lisaac/luci-lib-docker

# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../lean/luci-theme-argon
rm -rf ../lean/luci-theme-bootstrap

# Add subconverter
# git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add luci-udptools
# svn co https://github.com/zcy85611/Openwrt-Package/trunk/luci-udptools
# svn co https://github.com/zcy85611/Openwrt-Package/trunk/udp2raw
# svn co https://github.com/zcy85611/Openwrt-Package/trunk/udpspeeder-tunnel

# Add OpenAppFilter
# git clone --depth 1 -b oaf-3.0.1 https://github.com/destan19/OpenAppFilter.git

# Add luci-app-oled (R2S Only)
# git clone --depth=1 https://github.com/NateLol/luci-app-oled

# Add luci-app-adguardhome
rm -rf ../lean/luci-app-adguardhome
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome

# Add luci-app-xlnetac
git clone --depth=1 https://github.com/sensec/luci-app-xlnetacc

# Add apk (Apk Packages Manager)
# svn co https://github.com/openwrt/packages/trunk/utils/apk
# popd

# 设置版本
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings

# Use Lienol's https-dns-proxy package
pushd feeds/packages/net
rm -rf https-dns-proxy
svn co https://github.com/Lienol/openwrt-packages/trunk/net/https-dns-proxy
popd

# Use snapshots' syncthing package
pushd feeds/packages/utils
rm -rf syncthing
svn co https://github.com/openwrt/packages/trunk/utils/syncthing
popd

# 优化
pushd ${GITHUB_WORKSPACE}/openwrt
cp -a ${GITHUB_WORKSPACE}/0003-upx-ucl-21.02.patch ${GITHUB_WORKSPACE}/openwrt
cat 0003-upx-ucl-21.02.patch | patch -p1 > /dev/null 2>&1
popd

# ttyd 自动登录
sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config


