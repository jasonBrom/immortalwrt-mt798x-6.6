#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${1:-.config}"

required_options=(
  "CONFIG_TARGET_mediatek=y"
  "CONFIG_TARGET_mediatek_filogic=y"
  "CONFIG_TARGET_mediatek_filogic_DEVICE_bananapi_bpi-r4=y"
  "CONFIG_PACKAGE_luci=y"
  "CONFIG_PACKAGE_luci-theme-argon=y"
  "CONFIG_PACKAGE_luci-i18n-base-zh-cn=y"
  "CONFIG_PACKAGE_kmod-hw_nat=y"
  "CONFIG_PACKAGE_kmod-nft-offload=y"
  "CONFIG_PACKAGE_kmod-mt7996e=y"
  "CONFIG_PACKAGE_kmod-mt7996-firmware=y"
  "CONFIG_PACKAGE_kmod-mt7996-233-firmware=y"
  "CONFIG_PACKAGE_mt7988-wo-firmware=y"
)

echo "Checking required config options..."

for opt in "${required_options[@]}"; do
  if ! grep -qxF "$opt" "$CONFIG_FILE"; then
    echo "ERROR: missing required option: $opt"
    echo
    echo "Nearby matches:"
    key="${opt%%=*}"
    grep -n "$key" "$CONFIG_FILE" || true
    exit 1
  fi
done

if grep -qE 'CONFIG_PACKAGE_(luci-app-mtk|luci-app-mtwifi|kmod-mt_wifi|wifi-profile)=y' "$CONFIG_FILE"; then
  echo "ERROR: mt_wifi / luci-app-mtk style packages detected."
  echo "This workflow is for MTK mac80211/mt7996 route, not old mt_wifi route."
  exit 1
fi

echo "Config check passed."
