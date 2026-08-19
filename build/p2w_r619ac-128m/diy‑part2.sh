#!/bin/bash
set -e
cd ${GITHUB_WORKSPACE}/openwrt

# 1、关闭ath10k debug配置项
./scripts/config --set-val CONFIG_ATH10K_DEBUG n
./scripts/config --set-val CONFIG_ATH10K_DEBUGFS n
echo "✅ diy-part2.sh: 已关闭ath10k debug调试模块"

# 2、直接修改源码mac80211/ath10k Makefile，彻底移除debug.o编译，根治list_count_nodes报错
ATH10K_MK=./package/kernel/mac80211/ath10k/Makefile
if [ -f "${ATH10K_MK}" ];then
    sed -i '/ath10k\/debug.o/d' "${ATH10K_MK}"
    echo "✅ 已从源码Makefile移除ath10k/debug.o编译目标"
else
    echo "⚠️ WARN: ath10k Makefile不存在，跳过debug.o移除"
fi
