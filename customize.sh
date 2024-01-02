$BOOTMODE || abort "! Recovery is not supported"

ui_print "- Reset sensitive props"
sh "$MODPATH/service.sh" 2>&1

# Fix init.rc/ART and Recovery/Magisk detections
ui_print "Fixing init.rc/ART and Recovery/Magisk detections..."
mv /system/addon.d /system/aaddon.d
mv /sdcard/TWRP /sdcard/TTWRP
mv /vendor/bin/install-recovery.sh /vendor/bin/iinstall-recovery.sh
mv /system/bin/install-recovery.sh /system/bin/iinstall-recovery.sh
ui_print "Please uninstall this module before dirty-flashing/updating the ROM."