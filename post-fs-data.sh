#!/system/bin/sh

MODDIR="${0%/*}"
MODNAME="${MODDIR##*/}"
MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin

if [ "$(magisk -V)" -lt 26302 ] || [ "$(/data/adb/ksud -V)" -lt 10818 ]; then
  touch "$MODDIR/disable"
fi

if [ ! -e "$MAGISKTMP/.magisk/mirror/sepolicy.rules/$MODNAME/sepolicy.rule" ] && [ ! -e "$MAGISKTMP/.magisk/sepolicy.rules/$MODNAME/sepolicy.rule" ]; then
    magiskpolicy --live --apply "$MODDIR/sepolicy.rule"
    ksud sepolicy apply "$MODDIR/sepolicy.rule"
fi

ksud sepolicy apply "$MODDIR/sepolicy.rule"

. "$MODDIR/resetprop.sh"

# these props must be set in post-fs-data
# clear out lineage and aosp words
# replace:
#    userdebug -> user
#    test-keys -> release-keys

# Fix Lineage and Debugging props
replace_value_resetprop ro.build.fingerprint userdebug user
replace_value_resetprop ro.build.fingerprint "aosp_" ""
replace_value_resetprop ro.build.fingerprint "lineage_" ""
replace_value_resetprop ro.build.fingerprint "superior_" ""
replace_value_resetprop ro.build.fingerprint test-keys release-keys
replace_value_resetprop ro.build.description userdebug user
replace_value_resetprop ro.build.description "aosp_" ""
replace_value_resetprop ro.build.description "lineage_" ""
replace_value_resetprop ro.build.description "superior_" ""
replace_value_resetprop ro.build.description test-keys release-keys
replace_value_resetprop ro.build.flavor "aosp_" ""
replace_value_resetprop ro.product.name "aosp_" ""
replace_value_resetprop ro.build.flavor "lineage_" ""
replace_value_resetprop ro.product.name "lineage_" ""
replace_value_resetprop ro.build.flavor "superior_" ""
replace_value_resetprop ro.product.name "superior_" ""
replace_value_resetprop ro.build.flavor "userdebug" ""
replace_value_resetprop ro.build.date.utc $(date +"%s")
replace_value_resetprop ro.build.version.security_patch $(date)
replace_value_resetprop ro.vendor.build.security_patch $(date)

for prefix in system vendor system_ext product oem odm vendor_dlkm odm_dlkm; do
    check_reset_prop ro.${prefix}.build.type user
    check_reset_prop ro.${prefix}.build.tags release-keys
    replace_value_resetprop ro.${prefix}.build.fingerprint userdebug user
    replace_value_resetprop ro.${prefix}.build.fingerprint "aosp_" ""
    replace_value_resetprop ro.${prefix}.build.fingerprint "lineage_" ""
    replace_value_resetprop ro.${prefix}.build.fingerprint "superior_" ""
    replace_value_resetprop ro.${prefix}.build.fingerprint test-keys release-keys
    replace_value_resetprop ro.${prefix}.build.description userdebug user
    replace_value_resetprop ro.${prefix}.build.description "aosp_" ""
    replace_value_resetprop ro.${prefix}.build.description "lineage_" ""
    replace_value_resetprop ro.${prefix}.build.description "superior_" ""
    replace_value_resetprop ro.${prefix}.build.description test-keys release-keys
    replace_value_resetprop ro.product.${prefix}.name "aosp_" ""
    replace_value_resetprop ro.product.${prefix}.name "lineage_" ""
    replace_value_resetprop ro.product.${prefix}.name "superior_" ""
    replace_value_resetprop ro.${prefix}.build.date.utc $(date +"%s")
done