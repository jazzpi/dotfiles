# Check for cross-compilation tools
if [ -d /usr/arm-linux-gnueabihf ]; then
    export QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
fi

if [ -d /mnt/c/WINDOWS ]; then
    export DISPLAY=host.docker.internal:0.0
    export LIBGL_ALWAYS_INDIRECT=1
fi

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi
