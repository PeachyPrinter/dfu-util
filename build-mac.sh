#!/bin/bash

mkdir -p output

LIBUSB_PATH=`otool -L src/dfu-util | awk '
/libusb/ { print $1 }'`

LIBUSB_NAME=`echo $LIBUSB_PATH |  perl -pe 's|^(.*?)([^/]*)$|\2|'`
LIBUSB_OTOOL=`echo @executable_path/${LIBUSB_NAME}`

./autogen.sh
./configure
make

cp src/dfu-util output/dfu-util
cp "${LIBUSB_PATH}" "output/${LIBUSB_NAME}"
chmod 755 "output/${LIBUSB_NAME}"
install_name_tool -change "${LIBUSB_PATH}" "${LIBUSB_OTOOL}" output/dfu-util

