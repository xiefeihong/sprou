#!/bin/sh

if [[ "$(uname)" == 'Linux' ]]; then
    case "$(uname -m)" in
        'i386' | 'i686')
            ARCH='32'
            ;;
          'amd64' | 'x86_64')
            ARCH='64'
            ;;
          'armv5tel')
            ARCH='arm32-v5'
            ;;
          'armv6l')
            ARCH='arm32-v6'
            grep Features /proc/cpuinfo | grep -qw 'vfp' || ARCH='arm32-v5'
            ;;
          'armv7' | 'armv7l')
            ARCH='arm32-v7a'
            grep Features /proc/cpuinfo | grep -qw 'vfp' || ARCH='arm32-v5'
            ;;
          'armv8' | 'aarch64')
            ARCH='arm64-v8a'
            ;;
          'mips')
            ARCH='mips32'
            ;;
          'mipsle')
            ARCH='mips32le'
            ;;
          'mips64')
            ARCH='mips64'
            ;;
          'mips64le')
            ARCH='mips64le'
            ;;
          'ppc64')
            ARCH='ppc64'
            ;;
          'ppc64le')
            ARCH='ppc64le'
            ;;
          'riscv64')
            ARCH='riscv64'
            ;;
          's390x')
            ARCH='s390x'
            ;;
    esac
fi
# echo "result $ARCH"
INFO_LATEST=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest)
TAG="$(echo $INFO_LATEST | sed 'y/,/\n/' | grep 'tag_name' | awk -F '"' '{print $4}')"
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download files
XRAY_FILE="Xray-linux-${ARCH}.zip"
DGST_FILE="Xray-linux-${ARCH}.zip.dgst"
echo "Downloading binary file: ${XRAY_FILE}"
wget -O ${PWD}/xray.zip https://github.com/XTLS/Xray-core/releases/download/${TAG}/${XRAY_FILE} > /dev/null 2>&1
echo "Downloading binary file: ${DGST_FILE}"
wget -O ${PWD}/xray.zip.dgst https://github.com/XTLS/Xray-core/releases/download/${TAG}/${DGST_FILE} > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${XRAY_FILE} ${DGST_FILE}" && exit 1
fi
echo "Download binary file: ${XRAY_FILE} ${DGST_FILE} completed"

# Check SHA512
LOCAL=$(openssl dgst -sha512 xray.zip | sed 's/([^)]*)//g')
STR=$(cat xray.zip.dgst | grep 'SHA512' | head -n1)

if [ "${LOCAL}" = "${STR}" ]; then
    echo " Check passed" && rm -fv xray.zip.dgst
else
    echo " Check have not passed yet " && exit 1
fi

# Prepare
echo "Prepare to use"
unzip xray.zip -d xray> /dev/null 2>&1
chmod +x xray
mv xray/xray /usr/bin/
mv xray/geosite.dat xray/geoip.dat /usr/local/share/xray/

# Clean
rm -rf xray_install.sh xray.zip xray

curl -s https://get.acme.sh | sh
ln -s $HOME/.acme.sh/acme.sh /usr/bin

echo "Done"