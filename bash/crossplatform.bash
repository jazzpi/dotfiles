# Check for cross-compilation tools
if ! [ -d /usr/arm-linux-gnueabihf ]; then
    return
fi

export QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
