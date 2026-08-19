#!/bin/bash
cd ${GITHUB_WORKSPACE}/openwrt

echo "==== diy-part2.sh：修改.config，关闭ath10k‑ct驱动与debugfs ===="
# 彻底禁用ath10k‑ct全套
sed -i 's/CONFIG_PACKAGE_kmod-ath10k-ct=y/# CONFIG_PACKAGE_kmod-ath10k-ct is not set/g' .config
sed -i 's/CONFIG_PACKAGE_ath10k-firmware-qca9984-ct=y/# CONFIG_PACKAGE_ath10k-firmware-qca9984-ct is not set/g' .config
sed -i 's/CONFIG_PACKAGE_ath10k-ct-smallbuffers=y/# CONFIG_PACKAGE_ath10k-ct-smallbuffers is not set/g' .config

# 关闭ath10k debugfs，规避 list_count_nodes 编译报错
sed -i 's/CONFIG_ATH10K_DEBUGFS=y/# CONFIG_ATH10K_DEBUGFS is not set/g' .config
sed -i 's/CONFIG_ATH10K_DEBUG=y/# CONFIG_ATH10K_DEBUG is not set/g' .config

# 脚本config锁死，防止后续编译阶段被改动
./scripts/config --disable CONFIG_PACKAGE_kmod-ath10k-ct
./scripts/config --disable CONFIG_PACKAGE_ath10k-firmware-qca9984-ct
./scripts/config --disable CONFIG_PACKAGE_ath10k-ct-smallbuffers
./scripts/config --disable CONFIG_ATH10K_DEBUGFS
./scripts/config --disable CONFIG_ATH10K_DEBUG

echo "==== 当前ath10k相关配置 ===="
grep ath10k .config
