#!/bin/sh
DOWNLOAD_DIR="/tmp/podkop"
mkdir -p "$DOWNLOAD_DIR"
REPO="https://api.github.com/repos/itdoginfo/podkop/releases/tags/v0.2.5"
wget -qO- "$REPO" | grep -o 'https://[^"]*\.ipk' | while read -r url; do
	filename=$(basename "$url")
	echo "Download $filename..."
	wget -q -O "$DOWNLOAD_DIR/$filename" "$url"
done
opkg install $DOWNLOAD_DIR/podkop*.ipk
opkg install $DOWNLOAD_DIR/luci-app-podkop*.ipk
opkg install $DOWNLOAD_DIR/luci-i18n-podkop-ru*.ipk
rm -f $DOWNLOAD_DIR/podkop*.ipk $DOWNLOAD_DIR/luci-app-podkop*.ipk $DOWNLOAD_DIR/luci-i18n-podkop-ru*.ipk

uci set podkop.main.mode='vpn'
uci set podkop.main.interface="$INTERFACE_NAME"
uci set podkop.main.domain_list_enabled='1'
uci set podkop.main.domain_list='ru_inside'
uci set podkop.main.delist_domains_enabled='0'
uci add_list podkop.main.subnets='meta'
uci add_list podkop.main.subnets='twitter'
uci add_list podkop.main.subnets='discord'
uci commit podkop
echo "Service Podkop restart..."
service podkop restart