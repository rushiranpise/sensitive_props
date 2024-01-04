MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin
MODPATH="${0%/*}"

[ -d "$MAGISKTMP/.magisk/mirror/early-mount/initrc.d" ] || exit

rm -rf "$MAGISKTMP/.magisk/mirror/early-mount/initrc.d/oem.rc"

# Restore essential files
chmod 0755 /system/addon.d
mv /system/aaddon.d /system/addon.d
mv /sdcard/TTWRP /sdcard/TWRP
mv /vendor/bin/iinstall-recovery.sh /vendor/bin/install-recovery.sh
mv /system/bin/iinstall-recovery.sh /system/bin/install-recovery.sh

resetprop -p --delete persist.log.tag.LSPosed
resetprop -p --delete persist.log.tag.LSPosed-Bridge