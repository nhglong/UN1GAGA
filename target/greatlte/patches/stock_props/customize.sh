TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

OLD_FINGERPRINT="$(GET_PROP "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/build.prop" "ro.system.build.fingerprint")"
NEW_FINGERPRINT="samsung/greatltexx/greatlte:9/PPR1.180610.011/N950FXXUGDZC3:user/release-keys"

sed -i "s|$OLD_FINGERPRINT|$NEW_FINGERPRINT|g" "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/build.prop"

SET_PROP "product" "ro.product.product.name" "greatltexx"
SET_PROP "product" "ro.dalvik.vm.enable_uffd_gc" "false"
SET_PROP "system" "ro.build.flavor" "greatltexx-user"

unset TARGET_FIRMWARE_PATH OLD_FINGERPRINT NEW_FINGERPRINT
