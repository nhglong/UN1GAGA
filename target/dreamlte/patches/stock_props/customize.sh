TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

OLD_FINGERPRINT="$(GET_PROP "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/build.prop" "ro.system.build.fingerprint")"
NEW_FINGERPRINT="samsung/dreamltexx/dreamlte:9/PPR1.180610.011/G955FXXUCDZC3:user/release-keys"

sed -i "s/$OLD_FINGERPRINT/$NEW_FINGERPRINT/" "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/build.prop"

SET_PROP "product" "ro.product.product.name" "dreamltexx"
SET_PROP "product" "ro.dalvik.vm.enable_uffd_gc" "false"
SET_PROP "system" "ro.build.flavor" "dreamltexx-user"

unset TARGET_FIRMWARE_PATH OLD_FINGERPRINT NEW_FINGERPRINT
