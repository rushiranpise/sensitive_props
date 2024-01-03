#!/system/bin/sh

MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin
MODPATH="${0%/*}"


# Use Magisk Delta feature to dynamic patch prop

[ -d "$MAGISKTMP/.magisk/mirror/early-mount/initrc.d" ] && cp -Tf "$MODPATH/oem.rc" "$MAGISKTMP/.magisk/mirror/early-mount/initrc.d/oem.rc"

. "$MODPATH/resetprop.sh"

# Hiding SELinux | Use toybox to protect *stat* access time reading
if [[ "$(toybox cat /sys/fs/selinux/enforce)" == "0" ]]; then
    chmod 640 /sys/fs/selinux/enforce
    chmod 440 /sys/fs/selinux/policy
fi

# Reset props after boot completed to avoid breaking some weird devices/ROMs...
while [ "$(getprop sys.boot_completed)" != 1 ]; do
    sleep 1
done

# Fix Restrictions on non-SDK interface
settings delete global hidden_api_policy
settings delete global hidden_api_policy_pre_p_apps
settings delete global hidden_api_policy_p_apps

# these props should be set after boot completed to avoid breaking some device features

check_reset_prop ro.boot.vbmeta.device_state locked
check_reset_prop ro.boot.verifiedbootstate green
check_reset_prop ro.boot.flash.locked 1
check_reset_prop ro.boot.veritymode enforcing
check_reset_prop ro.boot.warranty_bit 0
check_reset_prop ro.warranty_bit 0
check_reset_prop ro.debuggable 0
check_reset_prop ro.secure 1
check_reset_prop ro.adb.secure 1
check_reset_prop ro.secureboot.devicelock 1
check_reset_prop ro.secureboot.lockstate locked
check_reset_prop ro.build.type user
check_reset_prop ro.build.keys release-keys
check_reset_prop ro.build.tags release-keys
check_reset_prop ro.vendor.boot.warranty_bit 0
check_reset_prop ro.vendor.warranty_bit 0
check_reset_prop vendor.boot.vbmeta.device_state locked
check_reset_prop vendor.boot.verifiedbootstate green
check_reset_prop sys.oem_unlock_allowed 0
check_reset_prop ro.oem_unlock_supported 0
check_reset_prop init.svc.flash_recovery stopped
check_reset_prop ro.boot.realmebootstate green
check_reset_prop ro.boot.realme.lockstate 1

# fake encryption
check_reset_prop ro.crypto.state encrypted

# Disable Lsposed logs
check_reset_prop persist.log.tag.LSPosed S
check_reset_prop persist.log.tag.LSPosed-Bridge S

# Fix Native Bridge Detection
resetprop --delete "ro.dalvik.vm.native.bridge"

# Hide that we booted from recovery when magisk is in recovery mode
contains_reset_prop ro.bootmode recovery unknown
contains_reset_prop ro.boot.bootmode recovery unknown
contains_reset_prop ro.boot.mode recovery unknown
contains_reset_prop vendor.bootmode recovery unknown
contains_reset_prop vendor.boot.bootmode recovery unknown
contains_reset_prop vendor.boot.mode recovery unknown
contains_reset_prop ro.boot.hwc CN GLOBAL
contains_reset_prop ro.boot.hwcountry China GLOBAL

resetprop --delete ro.build.selinux

for prefix in system vendor system_ext product oem odm vendor_dlkm odm_dlkm; do
    check_reset_prop ro.${prefix}.build.type user
    check_reset_prop ro.${prefix}.build.tags release-keys
done

# Don't expose the raw commandline to unprivileged processes.
chmod 0440 /proc/cmdline

# Restrict permissions to socket file to hide Magisk & co.
chmod 0440 /proc/net/unix

# Hide Magisk File
chmod 0750 /system/addon.d