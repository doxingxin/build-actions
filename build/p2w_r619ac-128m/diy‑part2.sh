#!/bin/bash
cd ${GITHUB_WORKSPACE}/openwrt || exit 1
echo "==== diy-part2.sh ATH10K config modify ===="
./scripts/config --set-val ATH10K_DEBUG n
./scripts/config --set-val ATH10K_DEBUGFS n
echo "==== 打印ATH10K配置 ===="
grep ATH10K .config
