#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好

# 后台IP设置
export Ipv4_ipaddr="192.168.2.3"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="OpenWrt-Xing"                # 修改主机名称为OpenWrt-123(填0为不作修改)

# 内核和系统分区大小(不是每个机型都可用)
export Kernel_partition_size="0"            # 内核分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般16,数值以MB计算，填0为不作修改),如果你不懂就填0
export Rootfs_partition_size="0"            # 系统分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般300左右,数值以MB计算，填0为不作修改),如果你不懂就填0

# 默认主题设置
export Mandatory_theme="argon"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="argon"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)

# 旁路由选项
export Gateway_Settings="0"                 # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
export DNS_Settings="0"                     # 旁路由设置 DNS(填入DNS，多个DNS要用空格分开)(填0为不作修改)
export Broadcast_Ipv4="0"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
export Disable_DHCP="0"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
export Disable_Bridge="0"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
export Create_Ipv6_Lan="0"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)

# IPV6、IPV4 选择
export Enable_IPV6_function="1"             # 编译IPV6固件(1为启用命令,填0为不作修改)(如果跟Create_Ipv6_Lan一起启用命令的话,Create_Ipv6_Lan命令会自动关闭)
export Enable_IPV4_function="1"             # 编译IPV4固件(1为启用命令,填0为不作修改)(如果跟Enable_IPV6_function一起启用命令的话,此命令会自动关闭)

# 替换OpenClash的源码(默认master分支)
export OpenClash_branch="0"                 # OpenClash的源码分别有【master分支】和【dev分支】(填0为关闭,填1为使用master分支,填2为使用dev分支,填入1或2的时候固件自动增加此插件)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="0"  # 个性签名,你想写啥就写啥，(填0为不作修改)

# 更换固件内核
export Replace_Kernel="5.10"                 # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核x.x版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件和核心
export AdGuardHome_Core="0"                  # 编译固件时自动增加AdGuardHome插件和AdGuardHome插件核心,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不作修改)

# 开启NTFS格式盘挂载
export Automatic_Mount_Settings="0"          # 编译时加入开启NTFS格式盘挂载的所需依赖(1为启用命令,填0为不作修改)

# 去除网络共享(autosamba)
export Disable_autosamba="1"                 # 去掉源码默认自选的luci-app-samba或luci-app-samba4(1为启用命令,填0为不作修改)

# 其他
export Ttyd_account_free_login="0"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="1"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带此功能)(1为启用命令,填0为不作修改)
export Cancel_running="1"                    # 取消路由器每天跑分任务(个别源码本身不带此功能)(1为启用命令,填0为不作修改)

# =====================修复ath10k list_count_nodes编译报错=====================
sed -i 's/CONFIG_ATH10K_DEBUG=y/# CONFIG_ATH10K_DEBUG is not set/' .config
sed -i 's/CONFIG_ATH10K_DEBUGFS=y/# CONFIG_ATH10K_DEBUGFS is not set/' .config

# olddefconfig：仅更新依赖，不会重置手动关闭的选项，禁止make defconfig
make olddefconfig

# 打印校验，看Actions日志输出确认是否关闭成功
echo "==== ATH10K DEBUG CONFIG CHECK ===="
grep -E "ATH10K_DEBUG" .config

# 兜底方案：直接删除debug.o编译条目，无论配置如何，不去编译报错debug.c源码
if [ -f "./package/kernel/mac80211/backports-regular/Makefile" ];then
    sed -i '/ath10k\/debug.o/d' ./package/kernel/mac80211/backports-regular/Makefile
fi
# ==========================================================================

# 修改插件名字
grep -rl '"终端"' . | xargs -r sed -i 's?"终端"?"TTYD"?g'
grep -rl '"TTYD 终端"' . | xargs -r sed -i 's?"TTYD 终端"?"TTYD"?g'
grep -rl '"网络存储"' . | xargs -r sed -i 's?"网络存储"?"NAS"?g'
grep -rl '"实时流量监测"' . | xargs -r sed -i 's?"实时流量监测"?"流量"?g'
grep -rl '"KMS 服务器"' . | xargs -r sed -i 's?"KMS 服务器"?"KMS激活"?g'
grep -rl '"USB 打印服务器"' . | xargs -r sed -i 's?"USB 打印服务器"?"打印服务"?g'
grep -rl '"Web 管理"' . | xargs -r sed -i 's?"Web 管理"?"Web管理"?g'
grep -rl '"管理权"' . | xargs -r sed -i 's?"管理权"?"改密码"?g'
grep -rl '"带宽监控"' . | xargs -r sed -i 's?"带宽监控"?"监控"?g'

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
cat >"$CLEAR_PATH" <<-EOF
*.manifest
*.buildinfo
*.json
sha256sums
ImmortalWrt-p2w_r619ac-128m-generic-kernel.bin
ImmortalWrt-p2w_r619ac-128m-generic.manifest
ImmortalWrt-p2w_r619ac-128m-generic-squashfs-rootfs.img.gz
EOF

# ==============================================
# 竞斗云2.0 p2w_r619ac‑128m DTS nvmem‑caldata修复
# 修复WiFi：读不到出厂caldata，SSID无关联设备
# ==============================================
DTS_FILE="./target/linux/ipq40xx/files/arch/arm/boot/dts/qcom/p2w_r619ac-128m.dts"

if [ ! -f "${DTS_FILE}" ];then
    echo "【警告】找不到p2w_r619ac‑128m.dts 文件，跳过DTS补丁，请核对源码路径！"
else
    echo "【DTS补丁】开始修复竞斗云2.0 nvmem caldata"

    # 备份原始dts
    cp "${DTS_FILE}" "${DTS_FILE}.bak"

    # 在 qcom,ath10k-calibration-virtual 节点替换为nvmem‑cells读取flash caldata分区
    # 删除旧的硬编码 local‑mac‑address / qcom,ath10k‑calibration‑virtual
    sed -i '/qcom,ath10k-calibration-virtual/d' "${DTS_FILE}"
    sed -i '/local-mac-address/d' "${DTS_FILE}"

    # 往&wifi0节点插入nvmem引用，读取flash 0x100000偏移的caldata
    sed -i '/&wifi0 {/a \
        nvmem-cells = <&caldata_wifi0>, <&macaddr_wifi0>;\
        nvmem-cell-names = "calibration", "mac-address";' "${DTS_FILE}"

    sed -i '/&wifi1 {/a \
        nvmem-cells = <&caldata_wifi1>, <&macaddr_wifi1>;\
        nvmem-cell-names = "calibration", "mac-address";' "${DTS_FILE}"

    # 在 aliases{} 节点后面添加 nvmem‑cells 定义，读取art分区数据
    sed -i '/aliases: aliases {/a \
        art: art@100000 {\
            compatible = "qcom,msm-part";\
            reg = <0x100000 0x10000>;\
            #address-cells = <1>;\
            #size-cells = <1>;\
            status = "okay";\
\
            caldata_wifi0: caldata@0 {\
                reg = <0x0 0x1000>;\
            };\
            caldata_wifi1: caldata@1000 {\
                reg = <0x1000 0x1000>;\
            };\
            macaddr_wifi0: mac@6 {\
                reg = <0x6 0x6>;\
            };\
            macaddr_wifi1: mac@12 {\
                reg = <0xc 0x6>;\
            };\
        };' "${DTS_FILE}"

    echo "【DTS补丁】补丁执行完成，对比备份文件查看修改差异"
    diff "${DTS_FILE}.bak" "${DTS_FILE}" || true
fi
# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
cat >>$DELETE <<-EOF
EOF
