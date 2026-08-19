#!/bin/bash
set -e
cd ${GITHUB_WORKSPACE}/openwrt

# 关闭ath10k debug，解决 list_count_nodes API不匹配报错
./scripts/config --set-val CONFIG_ATH10K_DEBUG n
./scripts/config --set-val CONFIG_ATH10K_DEBUGFS n

echo "✅ diy-part2.sh: 已关闭ath10k debug调试模块"
