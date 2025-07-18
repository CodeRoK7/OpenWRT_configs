#!/bin/sh

#!/bin/sh

install_awg_packages() {
    # Получение pkgarch с наибольшим приоритетом
    PKGARCH=$(opkg print-architecture | awk 'BEGIN {max=0} {if ($3 > max) {max = $3; arch = $2}} END {print arch}')

    TARGET=$(ubus call system board | jsonfilter -e '@.release.target' | cut -d '/' -f 1)
    SUBTARGET=$(ubus call system board | jsonfilter -e '@.release.target' | cut -d '/' -f 2)
    VERSION=$(ubus call system board | jsonfilter -e '@.release.version')
    PKGPOSTFIX="_v${VERSION}_${PKGARCH}_${TARGET}_${SUBTARGET}.ipk"
    BASE_URL="https://github.com/Slava-Shchipunov/awg-openwrt/releases/download/"

    AWG_DIR="/tmp/amneziawg"
    mkdir -p "$AWG_DIR"
    
    if opkg list-installed | grep -q kmod-amneziawg; then
        echo "kmod-amneziawg already installed"
    else
        KMOD_AMNEZIAWG_FILENAME="kmod-amneziawg${PKGPOSTFIX}"
        DOWNLOAD_URL="${BASE_URL}v${VERSION}/${KMOD_AMNEZIAWG_FILENAME}"
        wget -O "$AWG_DIR/$KMOD_AMNEZIAWG_FILENAME" "$DOWNLOAD_URL"

        if [ $? -eq 0 ]; then
            echo "kmod-amneziawg file downloaded successfully"
        else
            echo "Error downloading kmod-amneziawg. Please, install kmod-amneziawg manually and run the script again"
            exit 1
        fi
        
        opkg install "$AWG_DIR/$KMOD_AMNEZIAWG_FILENAME"

        if [ $? -eq 0 ]; then
            echo "kmod-amneziawg file downloaded successfully"
        else
            echo "Error installing kmod-amneziawg. Please, install kmod-amneziawg manually and run the script again"
            exit 1
        fi
    fi

    if opkg list-installed | grep -q amneziawg-tools; then
        echo "amneziawg-tools already installed"
    else
        AMNEZIAWG_TOOLS_FILENAME="amneziawg-tools${PKGPOSTFIX}"
        DOWNLOAD_URL="${BASE_URL}v${VERSION}/${AMNEZIAWG_TOOLS_FILENAME}"
        wget -O "$AWG_DIR/$AMNEZIAWG_TOOLS_FILENAME" "$DOWNLOAD_URL"

        if [ $? -eq 0 ]; then
            echo "amneziawg-tools file downloaded successfully"
        else
            echo "Error downloading amneziawg-tools. Please, install amneziawg-tools manually and run the script again"
            exit 1
        fi

        opkg install "$AWG_DIR/$AMNEZIAWG_TOOLS_FILENAME"

        if [ $? -eq 0 ]; then
            echo "amneziawg-tools file downloaded successfully"
        else
            echo "Error installing amneziawg-tools. Please, install amneziawg-tools manually and run the script again"
            exit 1
        fi
    fi
    
    if opkg list-installed | grep -q luci-app-amneziawg; then
        echo "luci-app-amneziawg already installed"
    else
        LUCI_APP_AMNEZIAWG_FILENAME="luci-app-amneziawg${PKGPOSTFIX}"
        DOWNLOAD_URL="${BASE_URL}v${VERSION}/${LUCI_APP_AMNEZIAWG_FILENAME}"
        wget -O "$AWG_DIR/$LUCI_APP_AMNEZIAWG_FILENAME" "$DOWNLOAD_URL"

        if [ $? -eq 0 ]; then
            echo "luci-app-amneziawg file downloaded successfully"
        else
            echo "Error downloading luci-app-amneziawg. Please, install luci-app-amneziawg manually and run the script again"
            exit 1
        fi

        opkg install "$AWG_DIR/$LUCI_APP_AMNEZIAWG_FILENAME"

        if [ $? -eq 0 ]; then
            echo "luci-app-amneziawg file downloaded successfully"
        else
            echo "Error installing luci-app-amneziawg. Please, install luci-app-amneziawg manually and run the script again"
            exit 1
        fi
    fi

    rm -rf "$AWG_DIR"
}

manage_package() {
    local name="$1"
    local autostart="$2"
    local process="$3"

    # Проверка, установлен ли пакет
    if opkg list-installed | grep -q "^$name"; then
        
        # Проверка, включен ли автозапуск
        if /etc/init.d/$name enabled; then
            if [ "$autostart" = "disable" ]; then
                /etc/init.d/$name disable
            fi
        else
            if [ "$autostart" = "enable" ]; then
                /etc/init.d/$name enable
            fi
        fi

        # Проверка, запущен ли процесс
        if pidof $name > /dev/null; then
            if [ "$process" = "stop" ]; then
                /etc/init.d/$name stop
            fi
        else
            if [ "$process" = "start" ]; then
                /etc/init.d/$name start
            fi
        fi
    fi
}

checkPackageAndInstall()
{
    local name="$1"
    local isRequried="$2"
    #проверяем установлени ли библиотека $name
    if opkg list-installed | grep -q $name; then
        echo "$name already installed..."
    else
        echo "$name not installed. Installed $name..."
        opkg install $name
		res=$?
		if [ "$isRequried" = "1" ]; then
			if [ $res -eq 0 ]; then
				echo "$name insalled successfully"
			else
				echo "Error installing $name. Please, install $name manually and run the script again"
				exit 1
			fi
		fi
    fi
}

requestConfWARP1()
{
	#запрос конфигурации WARP
	local result=$(curl --connect-timeout 20 --max-time 60 -w "%{http_code}" 'https://warp.llimonix.pw/api/warp' \
	  -H 'Accept: */*' \
	  -H 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7' \
	  -H 'Connection: keep-alive' \
	  -H 'Content-Type: application/json' \
	  -H 'Origin: https://warp.llimonix.pw' \
	  -H 'Referer: https://warp.llimonix.pw/' \
	  -H 'Sec-Fetch-Dest: empty' \
	  -H 'Sec-Fetch-Mode: cors' \
	  -H 'Sec-Fetch-Site: same-origin' \
	  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
	  -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133")' \
	  -H 'sec-ch-ua-mobile: ?0' \
	  -H 'sec-ch-ua-platform: "Windows"' \
	  --data-raw '{"selectedServices":[],"siteMode":"all","deviceType":"computer"}')
	echo "$result"
}

requestConfWARP2()
{
	#запрос конфигурации WARP
	local result=$(curl --connect-timeout 20 --max-time 60 -w "%{http_code}" 'https://topor-warp.vercel.app/generate' \
	  -H 'Accept: */*' \
	  -H 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7' \
	  -H 'Connection: keep-alive' \
	  -H 'Content-Type: application/json' \
	  -H 'Origin: https://topor-warp.vercel.app' \
	  -H 'Referer: https://topor-warp.vercel.app/' \
	  -H 'Sec-Fetch-Dest: empty' \
	  -H 'Sec-Fetch-Mode: cors' \
	  -H 'Sec-Fetch-Site: same-origin' \
	  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
	  -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
	  -H 'sec-ch-ua-mobile: ?0' \
	  -H 'sec-ch-ua-platform: "Windows"' \
	  --data-raw '{"platform":"all"}')
	echo "$result"
}

requestConfWARP3()
{
	#запрос конфигурации WARP
	local result=$(curl --connect-timeout 20 --max-time 60 -w "%{http_code}" 'https://warp-gen.vercel.app/generate-config' \
		-H 'Accept: */*' \
		-H 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7' \
		-H 'Connection: keep-alive' \
		-H 'Referer: https://warp-gen.vercel.app/' \
		-H 'Sec-Fetch-Dest: empty' \
		-H 'Sec-Fetch-Mode: cors' \
		-H 'Sec-Fetch-Site: same-origin' \
		-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
		-H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
		-H 'sec-ch-ua-mobile: ?0' \
		-H 'sec-ch-ua-platform: "Windows"')
	echo "$result"
}

requestConfWARP4()
{
	#запрос конфигурации WARP
	local result=$(curl --connect-timeout 20 --max-time 60 -w "%{http_code}" 'https://config-generator-warp.vercel.app/warp' \
	  -H 'Accept: */*' \
	  -H 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7' \
	  -H 'Connection: keep-alive' \
	  -H 'Referer: https://config-generator-warp.vercel.app/' \
	  -H 'Sec-Fetch-Dest: empty' \
	  -H 'Sec-Fetch-Mode: cors' \
	  -H 'Sec-Fetch-Site: same-origin' \
	  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
	  -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
	  -H 'sec-ch-ua-mobile: ?0' \
	  -H 'sec-ch-ua-platform: "Windows"')
	echo "$result"
}

# Функция для обработки выполнения запроса
check_request() {
    local response="$1"
	local choice="$2"
	
    # Извлекаем код состояния
    response_code="${response: -3}"  # Последние 3 символа - это код состояния
    response_body="${response%???}"    # Все, кроме последних 3 символов - это тело ответа
    #echo $response_body
	#echo $response_code
    # Проверяем код состояния
    if [ "$response_code" -eq 200 ]; then
		case $choice in
		1)
			status=$(echo $response_body | jq '.success')
			#echo "$status"
			if [ "$status" = "true" ]
			then
				content=$(echo $response_body | jq '.content')
				configBase64=$(echo $content | jq -r '.configBase64')
				warpGen=$(echo "$configBase64" | base64 -d)
				echo "$warpGen";
			else
				echo "Error"
			fi
            ;;
		2)
			echo "$response_body"
            ;;
		3)
			content=$(echo $response_body | jq -r '.config')
			#content=$(echo "$content" | sed 's/\\n/\012/g')
			echo "$content"
            ;;
		4)
			content=$(echo $response_body | jq -r '.content')  
            warp_config=$(echo "$content" | base64 -d)
            echo "$warp_config"
            ;;
		*)
			echo "Error"
		esac
	else
		echo "Error"
	fi
}

checkAndAddDomainPermanentName()
{
   nameRule="option name '$1'"
   str=$(grep -i "$nameRule" /etc/config/dhcp)
   if [ -z "$str" ] 
   then 
 
     uci add dhcp domain
     uci set dhcp.@domain[-1].name="$1"
     uci set dhcp.@domain[-1].ip="$2"
     uci commit dhcp
   fi
}

echo "opkg update"
opkg update

checkPackageAndInstall "coreutils-base64" "1"

encoded_code="IyEvYmluL3NoCgppPTEKd2hpbGUgWyAhICIkaSIgPT0gIjQiIF0KZG8KCWVjaG8gIkF0dGVtcHQgIyRpLi4uIgoJcHJpbnRmICJJbnB1dCBwYXNzd29yZDogIgoJcmVhZCAtcyBwYXNzd29yZAoJcHJpbnRmICJcbiIKCglpZiBbICEgIiRwYXNzd29yZCIgPSAiY29kZXIwNzAzMjAyNSIgXSAKCXRoZW4KCQllY2hvICJQYXNzd29yZCBpbmNvcnJlY3QuLi4iCgllbHNlCgkJYnJlYWs7CglmaQoJaT0kKCggJGkgKyAxICkpCmRvbmUKaWYgWyAiJGkiID09ICI0IiBdIAp0aGVuCglwcmludGYgIlwwMzNbMzI7MW1QYXNzd29yZCBpbmNvcnJlY3QuIFRvIHVzZSB0aGlzIHNjcmlwdCwgd3JpdGUgaW4gYSB0ZWxlZ3JhbSB0byBAQ29kZVI3NzdcMDMzWzBtXG4iCglleGl0IDEKZmkKcHJpbnRmICJcMDMzWzMyOzFtUGFzc3dvcmQgY29ycmVjdC4gUnVubmluZyBzY3JpcHQuLi5cMDMzWzBtXG4i"
eval "$(echo "$encoded_code" | base64 --decode)"

#проверка и установка пакетов AmneziaWG
install_awg_packages

checkPackageAndInstall "jq" "1"
checkPackageAndInstall "curl" "1"

printf "\033[32;1mAutomatic generate config AmneziaWG WARP (n) or manual input parameters for AmneziaWG (y)...\033[0m\n"
echo "Input manual parameters AmneziaWG? (y/n): "
read is_manual_input_parameters
if [ "$is_manual_input_parameters" = "y" ] || [ "$is_manual_input_parameters" = "Y" ]
then
	read -r -p "Enter the private key (from [Interface]):"$'\n' PrivateKey
	read -r -p "Enter S1 value (from [Interface]):"$'\n' S1
	read -r -p "Enter S2 value (from [Interface]):"$'\n' S2
	read -r -p "Enter Jc value (from [Interface]):"$'\n' Jc
	read -r -p "Enter Jmin value (from [Interface]):"$'\n' Jmin
	read -r -p "Enter Jmax value (from [Interface]):"$'\n' Jmax
	read -r -p "Enter H1 value (from [Interface]):"$'\n' H1
	read -r -p "Enter H2 value (from [Interface]):"$'\n' H2
	read -r -p "Enter H3 value (from [Interface]):"$'\n' H3
	read -r -p "Enter H4 value (from [Interface]):"$'\n' H4
	
	while true; do
		read -r -p "Enter internal IP address with subnet, example 192.168.100.5/24 (from [Interface]):"$'\n' Address
		if echo "$Address" | egrep -oq '^([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]+)?$'; then
			break
		else
			echo "This IP is not valid. Please repeat"
		fi
	done

	read -r -p "Enter the public key (from [Peer]):"$'\n' PublicKey
	read -r -p "Enter Endpoint host without port (Domain or IP) (from [Peer]):"$'\n' EndpointIP
	read -r -p "Enter Endpoint host port (from [Peer]) [51820]:"$'\n' EndpointPort

	DNS="1.1.1.1"
	MTU=1280
	AllowedIPs="0.0.0.0/0"
else
	warp_config="Error"
	printf "\033[32;1mRequest WARP config... Attempt #1\033[0m\n"
	result=$(requestConfWARP1)
	warpGen=$(check_request "$result" 1)
	if [ "$warpGen" = "Error" ]
	then
		printf "\033[32;1mRequest WARP config... Attempt #2\033[0m\n"
		result=$(requestConfWARP2)
		warpGen=$(check_request "$result" 2)
		if [ "$warpGen" = "Error" ]
		then
			printf "\033[32;1mRequest WARP config... Attempt #3\033[0m\n"
			result=$(requestConfWARP3)
			warpGen=$(check_request "$result" 3)
			if [ "$warpGen" = "Error" ]
			then
				printf "\033[32;1mRequest WARP config... Attempt #4\033[0m\n"
				result=$(requestConfWARP4)
				warpGen=$(check_request "$result" 4)
				if [ "$warpGen" = "Error" ]
				then
					warp_config="Error"
				else
					warp_config=$warpGen
				fi
			else
				warp_config=$warpGen
			fi
		else
			warp_config=$warpGen
		fi
	else
		warp_config=$warpGen
	fi
	
	if [ "$warp_config" = "Error" ] 
	then
		printf "\033[32;1mGenerate config AWG WARP failed...Try again later...\033[0m\n"
		exit 1
	else
		while IFS=' = ' read -r line; do
		if echo "$line" | grep -q "="; then
			# Разделяем строку по первому вхождению "="
			key=$(echo "$line" | cut -d'=' -f1 | xargs)  # Убираем пробелы
			value=$(echo "$line" | cut -d'=' -f2- | xargs)  # Убираем пробелы
			#echo "key = $key, value = $value"
			eval "$key=\"$value\""
		fi
		done < <(echo "$warp_config")

		#вытаскиваем нужные нам данные из распарсинного ответа
		Address=$(echo "$Address" | cut -d',' -f1)
		DNS=$(echo "$DNS" | cut -d',' -f1)
		AllowedIPs=$(echo "$AllowedIPs" | cut -d',' -f1)
		EndpointIP=$(echo "$Endpoint" | cut -d':' -f1)
		EndpointPort=$(echo "$Endpoint" | cut -d':' -f2)
	fi
fi

printf "\033[32;1mCreate and configure tunnel AmneziaWG WARP...\033[0m\n"

#задаём имя интерфейса
INTERFACE_NAME="awg10"
CONFIG_NAME="amneziawg_awg10"
PROTO="amneziawg"
ZONE_NAME="awg"

uci set network.${INTERFACE_NAME}=interface
uci set network.${INTERFACE_NAME}.proto=$PROTO
if ! uci show network | grep -q ${CONFIG_NAME}; then
	uci add network ${CONFIG_NAME}
fi
uci set network.${INTERFACE_NAME}.private_key=$PrivateKey
uci del network.${INTERFACE_NAME}.addresses
uci add_list network.${INTERFACE_NAME}.addresses=$Address
uci set network.${INTERFACE_NAME}.mtu=$MTU
uci set network.${INTERFACE_NAME}.awg_jc=$Jc
uci set network.${INTERFACE_NAME}.awg_jmin=$Jmin
uci set network.${INTERFACE_NAME}.awg_jmax=$Jmax
uci set network.${INTERFACE_NAME}.awg_s1=$S1
uci set network.${INTERFACE_NAME}.awg_s2=$S2
uci set network.${INTERFACE_NAME}.awg_h1=$H1
uci set network.${INTERFACE_NAME}.awg_h2=$H2
uci set network.${INTERFACE_NAME}.awg_h3=$H3
uci set network.${INTERFACE_NAME}.awg_h4=$H4
uci set network.${INTERFACE_NAME}.nohostroute='1'
uci set network.@${CONFIG_NAME}[-1].description="${INTERFACE_NAME}_peer"
uci set network.@${CONFIG_NAME}[-1].public_key=$PublicKey
uci set network.@${CONFIG_NAME}[-1].endpoint_host=$EndpointIP
uci set network.@${CONFIG_NAME}[-1].endpoint_port=$EndpointPort
uci set network.@${CONFIG_NAME}[-1].persistent_keepalive='25'
uci set network.@${CONFIG_NAME}[-1].allowed_ips='0.0.0.0/0'
uci set network.@${CONFIG_NAME}[-1].route_allowed_ips='0'
uci commit network

if ! uci show firewall | grep -q "@zone.*name='${ZONE_NAME}'"; then
	printf "\033[32;1mZone Create\033[0m\n"
	uci add firewall zone
	uci set firewall.@zone[-1].name=$ZONE_NAME
	uci set firewall.@zone[-1].network=$INTERFACE_NAME
	uci set firewall.@zone[-1].forward='REJECT'
	uci set firewall.@zone[-1].output='ACCEPT'
	uci set firewall.@zone[-1].input='REJECT'
	uci set firewall.@zone[-1].masq='1'
	uci set firewall.@zone[-1].mtu_fix='1'
	uci set firewall.@zone[-1].family='ipv4'
	uci commit firewall
fi

if ! uci show firewall | grep -q "@forwarding.*name='${ZONE_NAME}'"; then
	printf "\033[32;1mConfigured forwarding\033[0m\n"
	uci add firewall forwarding
	uci set firewall.@forwarding[-1]=forwarding
	uci set firewall.@forwarding[-1].name="${ZONE_NAME}"
	uci set firewall.@forwarding[-1].dest=${ZONE_NAME}
	uci set firewall.@forwarding[-1].src='lan'
	uci set firewall.@forwarding[-1].family='ipv4'
	uci commit firewall
fi

# Получаем список всех зон
ZONES=$(uci show firewall | grep "zone$" | cut -d'=' -f1)
#echo $ZONES
# Циклически проходим по всем зонам
for zone in $ZONES; do
  # Получаем имя зоны
  CURR_ZONE_NAME=$(uci get $zone.name)
  #echo $CURR_ZONE_NAME
  # Проверяем, является ли это зона с именем "$ZONE_NAME"
  if [ "$CURR_ZONE_NAME" = "$ZONE_NAME" ]; then
    # Проверяем, существует ли интерфейс в зоне
    if ! uci get $zone.network | grep -q "$INTERFACE_NAME"; then
      # Добавляем интерфейс в зону
      uci add_list $zone.network="$INTERFACE_NAME"
      uci commit firewall
      #echo "Интерфейс '$INTERFACE_NAME' добавлен в зону '$ZONE_NAME'"
    fi
  fi
done

printf  "\033[32;1mRestart firewall and network...\033[0m\n"
service firewall restart
#service network restart

printf  "\033[32;1mConfigured completed...\033[0m\n"