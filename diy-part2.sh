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

#-------------#
### 删除frp ###
rm -rf feeds/luci/applications/luci-app-frpc
rm -rf feeds/luci/applications/luci-app-frps

# 从 coolsnowwolf 仓库中获取 luci-app-frpc 和 luci-app-frps 应用
git clone --depth 1 https://github.com/coolsnowwolf/luci.git /tmp/luci

# 复制 luci-app-frpc 和 luci-app-frps 应用到 feeds/luci/applications/
cp -rf /tmp/luci/applications/luci-app-frpc feeds/luci/applications/
cp -rf /tmp/luci/applications/luci-app-frps feeds/luci/applications/

# 删除临时目录
rm -rf /tmp/luci
#-------------#

# Modify default hosename
sed -i 's/ImmortalWrt/SUPERouter/g' package/base-files/files/bin/config_generate
# Password
# sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/$1$S2TRFyMU$E8fE0RRKR0jNadn3YLrSQ0:18690:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

