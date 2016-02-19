#!/bin/bash

mkdir -p output
if [ $? != 0 ]; then
    echo "FAILURE: Creating output dir"
    exit 101
fi

./autogen.sh
if [ $? != 0 ]; then
    echo "FAILURE: Autogen"
    exit 102
fi
./configure
if [ $? != 0 ]; then
    echo "FAILURE: Configure"
    exit 103
fi
make
if [ $? != 0 ]; then
    echo "FAILURE: make"
    exit 104
fi

LIBUSB_PATH=`otool -L src/dfu-util | awk '/libusb/ { print $1 }'`
LIBUSB_NAME=`echo $LIBUSB_PATH |  perl -pe 's|^(.*?)([^/]*)$|\2|'`
LIBUSB_OTOOL=`echo @executable_path/${LIBUSB_NAME}`

echo "LIBUSB_PATH: $LIBUSB_PATH"
echo "LIBUSB_NAME: $LIBUSB_NAME"
echo "LIBUSB_OTOOL: $LIBUSB_OTOOL"

cp src/dfu-util output/dfu-util
if [ $? != 0 ]; then
    echo "FAILURE: cp src/dfu-util output/dfu-util"
    exit 105
fi

cp "${LIBUSB_PATH}" "output/${LIBUSB_NAME}"
if [ $? != 0 ]; then
    echo "FAILURE: cp '${LIBUSB_PATH}' 'output/${LIBUSB_NAME}'"
    exit 106
fi

chmod 755 "output/${LIBUSB_NAME}"
if [ $? != 0 ]; then
    echo "FAILURE: chmod 755 '"'output/${LIBUSB_NAME}'"'"
    exit 107
fi

install_name_tool -change "${LIBUSB_PATH}" "${LIBUSB_OTOOL}" output/dfu-util
if [ $? != 0 ]; then
    echo "FAILURE: install_name_tool -change '${LIBUSB_PATH}' '${LIBUSB_OTOOL}' output/dfu-util"
    exit 108
fi

