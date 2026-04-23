#!/bin/sh

#
# (c) 2022-2026 Cezary Jackiewicz <cezary@eko.one.pl>
#

_DEVICE=""
_DEFAULT_LTE_BANDS=""
_DEFAULT_5GNSA_BANDS=""
_DEFAULT_5GSA_BANDS=""

# default templates

# modem name/type
getinfo() {
	echo "Unsupported"
}

# get supported band - 4G
getsupportedbands() {
	echo "Unsupported"
}

# get supported band - 5G NSA
getsupportedbands5gnsa() {
	echo "Unsupported"
}

# get supported band - 5G SA
getsupportedbands5gsa() {
	echo "Unsupported"
}

RES="/usr/share/modemband"

# find first supported device
_DEVS=$(awk '{gsub("="," ");
if ($0 ~ /Bus.*Lev.*Prnt.*Port.*/) {T=$0}
if ($0 ~ /Vendor.*ProdID/) {idvendor[T]=$3; idproduct[T]=$5}
if ($0 ~ /Product/) {product[T]=$3}}
END {for (idx in idvendor) {printf "%s%s%s\n%s%s\n", idvendor[idx], idproduct[idx], product[idx], idvendor[idx], idproduct[idx]}}' /sys/kernel/debug/usb/devices)
for _DEV in $_DEVS; do
	if [ -e "$RES/$_DEV" ]; then
		. "$RES/$_DEV"
		break
	fi
done

BLTE="nok"
B5GNSA="nok"
B5GSA="nok"

if [ -z "$_DEVICE" ]; then
	echo "lte:${BLTE}"
	echo "5gnsa:${B5GNSA}"
	echo "5gsa:${B5GSA}"
	exit 0
fi
if [ ! -e "$_DEVICE" ]; then
	echo "lte:${BLTE}"
	echo "5gnsa:${B5GNSA}"
	echo "5gsa:${B5GSA}"
	exit 0
fi

getsupportedbands | grep -q "Unsupported" || BLTE="ok"
getsupportedbands5gnsa | grep -q "Unsupported" || B5GNSA="ok"
getsupportedbands5gsa | grep -q "Unsupported" || B5GSA="ok"

echo "lte:${BLTE}"
echo "5gnsa:${B5GNSA}"
echo "5gsa:${B5GSA}"
exit 0
