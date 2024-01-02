$BOOTMODE || abort "! Recovery is not supported"

ui_print "- Reset sensitive props"
# Android 11.0 or newer
if [[ "$(getprop ro.build.version.sdk)" -lt 30 ]]; then
    ui_print ""
    ui_print "Requires Android 11+"
    ui_print ""
abort
fi

v=26300
if [ "$MAGISK_VER_CODE" -lt "$v" ]; then
  ui_print "*********************************************************"
  ui_print "! Magisk version is too old!"
  ui_print "! Please update Magisk to latest version"
  abort    "*********************************************************"
fi

chmod 755 "$MODPATH/service.sh" "$MODPATH/post-fs-data.sh" "$MODPATH/resetprop"

# Fix init.rc/ART and Recovery/Magisk detections
ui_print "Fixing init.rc/ART and Recovery/Magisk detections..."
mv /system/addon.d /system/aaddon.d
mv /sdcard/TWRP /sdcard/TTWRP
mv /vendor/bin/install-recovery.sh /vendor/bin/iinstall-recovery.sh
mv /system/bin/install-recovery.sh /system/bin/iinstall-recovery.sh
ui_print "Please uninstall this module before dirty-flashing/updating the ROM."