# 注：这个.sh脚本可以成功编译出lede库中的frp，能把自己的frp预设编译进去 2014-08-29

#!/bin/bash
clear

### 基础部分 ###
# 使用 O2 级别的优化
sed -i 's/Os/O2/g' include/target.mk
# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a

### 必要的 Patches ###
# mount cgroupv2
# pushd feeds/packages
# wget -qO - https://github.com/openwrt/packages/commit/7a64a5f4.patch | patch -p1
# popd

### 获取额外的 LuCI 应用、主题 ###
# MOD Argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b randomPic --depth 1 https://github.com/msylgj/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

# DNSPod
git clone -b main --depth 1 https://github.com/msylgj/luci-app-tencentddns.git feeds/luci/applications/luci-app-tencentddns
ln -sf ../../../feeds/luci/applications/luci-app-tencentddns ./package/feeds/luci/luci-app-tencentddns

# -------------- #
# Add Hello World #
# 完整克隆 lua-maxminddb 仓库
git clone https://github.com/jerrykuku/lua-maxminddb.git feeds/luci/applications/lua-maxminddb
# 完整克隆 luci-app-vssr 仓库
git clone https://github.com/super27035/luci-app-vssr.git feeds/luci/applications/luci-app-vssr
# git clone https://github.com/MilesPoupart/luci-app-vssr.git feeds/luci/applications/luci-app-vssr
# -------------- #

# WeChatPush
rm -rf feeds/luci/applications/luci-app-wechatpush
git clone -b master --depth 1 https://github.com/tty228/luci-app-wechatpush.git feeds/luci/applications/luci-app-wechatpush
# geodata
rm -rf feeds/packages/net/v2ray-geodata
git clone -b master --depth 1 https://github.com/QiuSimons/openwrt-mos.git ./openwrt-mos
cp -rf ./openwrt-mos/v2ray-geodata feeds/packages/net/v2ray-geodata & rm -rf ./openwrt-mos
# 更换 Nodejs 版本
rm -rf ./feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# -------------- #
### 删除frp ###
rm -rf feeds/luci/applications/luci-app-frpc
rm -rf feeds/luci/applications/luci-app-frps

# 从 coolsnowwolf 仓库中获取 luci-app-frpc 和 luci-app-frps 应用
git clone --depth 1 https://github.com/coolsnowwolf/luci.git /tmp/luci

# 复制 luci-app-frpc 和 luci-app-frps 应用到 feeds/luci/applications/
cp -rf /tmp/luci/applications/luci-app-frpc feeds/luci/applications/
cp -rf /tmp/luci/applications/luci-app-frps feeds/luci/applications/

# 从 super27035 仓库中获取 luci-app-ssr-plus 应用
git clone --depth 1 https://github.com/super27035/small-package.git /tmp/small-package

# 复制 luci-app-ssr-plus 应用到 feeds/luci/applications/
cp -rf /tmp/small-package/luci-app-ssr-plus feeds/luci/applications/

# 删除临时目录
rm -rf /tmp/luci
rm -rf /tmp/small-package
# -------------- #

### 最后的收尾工作 ###
# Lets Fuck
if [ ! -d "package/base-files/files/usr/bin" ]; then
    mkdir package/base-files/files/usr/bin
fi
cp -f ../SCRIPTS/fuck package/base-files/files/usr/bin/fuck
# 定制化配置
sed -i "s/'%D %V %C'/'Built by SUPER($(date +%Y.%m.%d))@%D %V'/g" package/base-files/files/etc/openwrt_release
sed -i "/DISTRIB_REVISION/d" package/base-files/files/etc/openwrt_release
sed -i "/%D/a\ Built by SUPER($(date +%Y.%m.%d))" package/base-files/files/etc/banner
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

# Modify default hosename
sed -i 's/ImmortalWrt/SUPERouter/g' package/base-files/files/bin/config_generate
# Password
# sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/$1$S2TRFyMU$E8fE0RRKR0jNadn3YLrSQ0:18690:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

sed -i 's/1608/1800/g' package/emortal/cpufreq/files/cpufreq.uci
sed -i 's/2016/2208/g' package/emortal/cpufreq/files/cpufreq.uci
sed -i 's/1512/1608/g' package/emortal/cpufreq/files/cpufreq.uci
# 生成默认配置及缓存
rm -rf .config

# 清理可能因patch存在的冲突文件
find ./ -name *.orig | xargs rm -rf
find ./ -name *.rej | xargs rm -rf

exit 0

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
# echo 'src-git Small_Package https://github.com/kenzok8/small-package.git' >> feeds.conf.default
# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
