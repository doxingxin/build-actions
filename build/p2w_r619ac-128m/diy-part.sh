#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好

# ========== 竞斗云2.0 WiFi caldata DTS修复补丁 ==========
cd ${GITHUB_WORKSPACE}/openwrt
PATCH_DIR=${GITHUB_WORKSPACE}/patches/target/ipq40xx
if [ -d "${PATCH_DIR}" ]; then
    echo "开始应用p2w_r619ac无线修复补丁"
    for patch in ${PATCH_DIR}/*.patch; do
        echo "应用补丁：$patch"
        patch -p1 < "${patch}"
    done
    echo "补丁应用完成"
fi
# ========================================================

# ==============移除ipq40xx内核MMC冲突内置补丁==============
rm -f ${HOME_PATH}/target/linux/ipq40xx/patches-5.15/401-mmc-sdhci-msm-comment-unused-sdhci_msm_set_clock.patch

# 修复LEDE mac80211 ath10k list_count_nodes 编译报错
DEBUG_C="${HOME_PATH}/package/kernel/mac80211/backports-6.6.15/drivers/net/wireless/ath/ath10k/debug.c"
if [ -f "${DEBUG_C}" ]; then
    sed -i 's/list_count_nodes/list_lru_count_node/g' "${DEBUG_C}"
    echo "【修复完成】替换ath10未定义链表函数"
fi
# ======================================================================

# 后台IP设置
export Ipv4_ipaddr="192.168.2.3"
export Netmask_netm="255.255.255.0"
export Op_name="OpenWrt-Xing"

# 内核和系统分区大小
export Kernel_partition_size="0"
export Rootfs_partition_size="0"

# 默认主题
export Mandatory_theme="argon"
export Default_theme="argon"

# 旁路由选项
export Gateway_Settings="0"
export DNS_Settings="0"
export Broadcast_Ipv4="0"
export Disable_DHCP="0"
export Disable_Bridge="0"
export Create_Ipv6_Lan="0"

# IPV6、IPV4
export Enable_IPV6_function="1"
export Enable_IPV4_function="1"

# OpenClash
export OpenClash_branch="0"

# 个性签名
export Customized_Information="$(TZ=UTC-8 date "+%Y.%m.%d")"

# 更换内核
export Replace_Kernel="5.15"

# 免密登录
export Password_free_login="1"

# AdGuardHome
export AdGuardHome_Core="0"

# NTFS挂载
export Automatic_Mount_Settings="0"

# 关闭samba
export Disable_autosamba="1"

# 其他开关
export Ttyd_account_free_login="0"
export Delete_unnecessary_items="1"
export Disable_53_redirection="0"
export Cancel_running="1"

# 晶晨设置（竞斗云无需，保留不影响）
export amlogic_model="s905d"
export amlogic_kernel="6.1.120_6.12.15"
export auto_kernel="true"
export rootfs_size="512/2560"
export kernel_usage="stable"

# 修改插件中文名称
grep -rl '"终端"' . | xargs -r sed -i 's?"终端"?"TTYD"?g'
grep -rl '"TTYD 终端"' . | xargs -r sed -i 's?"TTYD 终端"?"TTYD"?g'
grep -rl '"网络存储"' . | xargs -r sed -i 's?"网络存储"?"NAS"?g'
grep -rl '"实时流量监测"' . | xargs -r sed -i 's?"实时流量监测"?"流量"?g'
grep -rl '"KMS 服务器"' . | xargs -r sed -i 's?"KMS 服务器"?"KMS激活"?g'
grep -rl '"USB 打印服务器"' . | xargs -r sed -i 's?"USB 打印服务器"?"打印服务"?g'
grep -rl '"Web 管理"' . | xargs -r sed -i 's?"Web 管理"?"Web管理"?g'
grep -rl '"管理权"' . | xargs -r sed -i 's?"管理权"?"改密码"?g'
grep -rl '"带宽监控"' . | xargs -r sed -i 's?"带宽监控"?"监控"?g'

# 编译后清理固件
cat >"$CLEAR_PATH" <<-EOF
packages
*.manifest
*.buildinfo
*.json
openwrt-p2w_r619ac-generic-kernel.bin
openwrt-p2w_r619ac-generic.manifest
openwrt-p2w_r619ac-generic-squashfs-rootfs.img.gz
EOF

cat >>$DELETE <<-EOF
EOF
