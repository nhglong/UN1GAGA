#!/usr/bin/env bash
# Copyright (c) 2025 Salvo Giangreco
# SPDX-License-Identifier: GPL-3.0-or-later

# [
source "$SRC_DIR/scripts/utils/build_utils.sh" || exit 1

SOURCE_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$SOURCE_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$SOURCE_FIRMWARE")"
TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

COPY_PARTITIONS()
{
    local DIR="$1"
    local SOURCE_FOLDERS="$2"
    local src

    case "$DIR" in
        "$FW_DIR/$SOURCE_FIRMWARE_PATH")
            src="source"
            ;;
        "$FW_DIR/$TARGET_FIRMWARE_PATH")
            src="target"
            ;;
        *)
            LOGE "Invalid firmware path: $DIR"
            return 1
            ;;
    esac

    for f in $SOURCE_FOLDERS; do
        if [ -d "$DIR/$f" ]; then
            if [[ "$src" == "source" ]]; then
                LOG "- Copying /$f from source firmware"
                EVAL "rsync -a --mkpath --delete --exclude=\"*system_ext*\" \"$FW_DIR/$SOURCE_FIRMWARE_PATH/$f\" \"$WORK_DIR\"" || exit 1
                sed "/system_ext/d" "$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-$f" > "$WORK_DIR/configs/file_context-$f"
                sed "/system_ext/d" "$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-$f" > "$WORK_DIR/configs/fs_config-$f"
            elif [[ "$src" == "target" ]]; then
                LOG "- Copying /$f from target firmware"
                EVAL "rsync -a --mkpath --delete \"$FW_DIR/$TARGET_FIRMWARE_PATH/$f\" \"$WORK_DIR\"" || exit 1
                EVAL "cp -a \"$FW_DIR/$TARGET_FIRMWARE_PATH/file_context-$f\" \"$WORK_DIR/configs/file_context-$f\"" || exit 1
                EVAL "cp -a \"$FW_DIR/$TARGET_FIRMWARE_PATH/fs_config-$f\" \"$WORK_DIR/configs/fs_config-$f\"" || exit 1
            fi
        else
            [ -d "$WORK_DIR/$f" ] && rm -rf "${WORK_DIR:?}/$f"
            [ -f "$WORK_DIR/configs/file_context-$f" ] && rm -f "$WORK_DIR/configs/file_context-$f"
            [ -f "$WORK_DIR/configs/fs_config-$f" ] && rm -f "$WORK_DIR/configs/fs_config-$f"
        fi
    done
}

COPY_SOURCE_FIRMWARE()
{
    COPY_PARTITIONS "$FW_DIR/$SOURCE_FIRMWARE_PATH" "system"
    LOG_STEP_IN
    SET_PROP "system" "ro.product.device" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/odm/etc/build.prop" "ro.product.odm.device")"
    LOG_STEP_OUT

    if [ -d "$FW_DIR/$SOURCE_FIRMWARE_PATH/product" ]; then
        if $TARGET_OS_BUILD_PRODUCT_PARTITION; then
            LOG_STEP_IN "- Copying /product from source firmware"

            [ -L "$WORK_DIR/system/product" ] && rm -f "$WORK_DIR/system/product"
            [ -d "$WORK_DIR/system/system/product" ] && rm -rf "$WORK_DIR/system/system/product"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/product\" \"$WORK_DIR\"" || exit 1
            mkdir -p "$WORK_DIR/system/product"
            EVAL "ln -sf \"/product\" \"$WORK_DIR/system/system/product\"" || exit 1
            SET_METADATA "system" "product" 0 0 755 "u:object_r:system_file:s0"
            SET_METADATA "system" "system/product" 0 0 644 "u:object_r:system_file:s0"
            EVAL "cp -a \"$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-product\" \"$WORK_DIR/configs/file_context-product\"" || exit 1
            EVAL "cp -a \"$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-product\" \"$WORK_DIR/configs/fs_config-product\"" || exit 1

            LOG_STEP_OUT
        else
            LOG_STEP_IN "- Copying /system/system/product from source firmware"

            [ -d "$WORK_DIR/system/product" ] && rm -rf "$WORK_DIR/system/product"
            [ -L "$WORK_DIR/system/system/product" ] && rm -f "$WORK_DIR/system/system/product"
            [ -d "$WORK_DIR/product" ] && rm -rf "$WORK_DIR/product"
            [ -f "$WORK_DIR/configs/file_context-product" ] && rm -f "$WORK_DIR/configs/file_context-product"
            [ -f "$WORK_DIR/configs/fs_config-product" ] && rm -f "$WORK_DIR/configs/fs_config-product"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/product\" \"$WORK_DIR/system/system\"" || exit 1
            EVAL "ln -sf \"/system/product\" \"$WORK_DIR/system/product\"" || exit 1
            SET_METADATA "system" "product" 0 0 644 "u:object_r:system_file:s0"
            sed "s/^\/product/\/system\/product/g" "$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-product" >> "$WORK_DIR/configs/file_context-system"
            sed "s/^product/system\/product/g" "$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-product" >> "$WORK_DIR/configs/fs_config-system"

            LOG_STEP_OUT
        fi
        LOG_STEP_IN
        SET_PROP "product" "ro.product.product.name" "$(GET_PROP "$FW_DIR/$TARGET_FIRMWARE_PATH/product/etc/build.prop" "ro.product.product.name")"
        LOG_STEP_OUT
    elif [ -d "$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/product" ]; then
        if $TARGET_OS_BUILD_PRODUCT_PARTITION; then
            LOG_STEP_IN "- Copying /product from source firmware"

            [ -L "$WORK_DIR/system/product" ] && rm -f "$WORK_DIR/system/product"
            [ -d "$WORK_DIR/system/system/product" ] && rm -rf "$WORK_DIR/system/system/product"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/product\" \"$WORK_DIR\"" || exit 1
            mkdir -p "$WORK_DIR/system/product"
            EVAL "ln -sf \"/product\" \"$WORK_DIR/system/system/product\"" || exit 1
            SET_METADATA "system" "product" 0 0 755 "u:object_r:system_file:s0"
            SET_METADATA "system" "system/product" 0 0 644 "u:object_r:system_file:s0"
            grep -F "system/product" "$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-system" | sed "s/^\/system//" > "$WORK_DIR/configs/file_context-product"
            grep -F "system/product" "$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-system" | sed "s/^system\///" > "$WORK_DIR/configs/fs_config-product"
            sed -i "s/^product /  /g" "$WORK_DIR/configs/fs_config-product"

            LOG_STEP_OUT
        else
            LOG_STEP_IN "- Copying /system/system/product from source firmware"

            [ -d "$WORK_DIR/system/product" ] && rm -rf "$WORK_DIR/system/product"
            [ -L "$WORK_DIR/system/system/product" ] && rm -f "$WORK_DIR/system/system/product"
            [ -d "$WORK_DIR/product" ] && rm -rf "$WORK_DIR/product"
            [ -f "$WORK_DIR/configs/file_context-product" ] && rm -f "$WORK_DIR/configs/file_context-product"
            [ -f "$WORK_DIR/configs/fs_config-product" ] && rm -f "$WORK_DIR/configs/fs_config-product"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/product\" \"$WORK_DIR/system/system\"" || exit 1
            EVAL "ln -sf \"/system/product\" \"$WORK_DIR/system/product\"" || exit 1
            grep -F "product" "$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-system" >> "$WORK_DIR/configs/file_context-system"
            grep -F "product" "$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-system" >> "$WORK_DIR/configs/fs_config-system"

            LOG_STEP_OUT
        fi
        LOG_STEP_IN
        SET_PROP "product" "ro.product.product.name" "$(GET_PROP "$FW_DIR/$TARGET_FIRMWARE_PATH/product/etc/build.prop" "ro.product.product.name")"
        LOG_STEP_OUT
    fi

    if [ -d "$FW_DIR/$SOURCE_FIRMWARE_PATH/system_ext" ]; then
        if $TARGET_OS_BUILD_SYSTEM_EXT_PARTITION; then
            LOG_STEP_IN "- Copying /system_ext from source firmware"

            [ -L "$WORK_DIR/system/system_ext" ] && rm -f "$WORK_DIR/system/system_ext"
            [ -d "$WORK_DIR/system/system/system_ext" ] && rm -rf "$WORK_DIR/system/system/system_ext"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/system_ext\" \"$WORK_DIR\"" || exit 1
            mkdir -p "$WORK_DIR/system/system_ext"
            EVAL "ln -sf \"/system_ext\" \"$WORK_DIR/system/system/system_ext\"" || exit 1
            SET_METADATA "system" "system_ext" 0 0 755 "u:object_r:system_file:s0"
            SET_METADATA "system" "system/system_ext" 0 0 644 "u:object_r:system_file:s0"
            EVAL "cp -a \"$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-system_ext\" \"$WORK_DIR/configs/file_context-system_ext\"" || exit 1
            EVAL "cp -a \"$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-system_ext\" \"$WORK_DIR/configs/fs_config-system_ext\"" || exit 1

            LOG_STEP_OUT
        else
            LOG_STEP_IN "- Copying /system/system/system_ext from source firmware"

            [ -d "$WORK_DIR/system/system_ext" ] && rm -rf "$WORK_DIR/system/system_ext"
            [ -L "$WORK_DIR/system/system/system_ext" ] && rm -f "$WORK_DIR/system/system/system_ext"
            [ -d "$WORK_DIR/system_ext" ] && rm -rf "$WORK_DIR/system_ext"
            [ -f "$WORK_DIR/configs/file_context-system_ext" ] && rm -f "$WORK_DIR/configs/file_context-system_ext"
            [ -f "$WORK_DIR/configs/fs_config-system_ext" ] && rm -f "$WORK_DIR/configs/fs_config-system_ext"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/system_ext\" \"$WORK_DIR/system/system\"" || exit 1
            EVAL "ln -sf \"/system/system_ext\" \"$WORK_DIR/system/system_ext\"" || exit 1
            SET_METADATA "system" "system_ext" 0 0 644 "u:object_r:system_file:s0"
            sed "s/^\/system_ext/\/system\/system_ext/g" "$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-system_ext" >> "$WORK_DIR/configs/file_context-system"
            sed "s/^system_ext/system\/system_ext/g" "$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-system_ext" >> "$WORK_DIR/configs/fs_config-system"

            ADD_TO_WORK_DIR "b0sxxx" "system_ext" "etc/build_flags.json" 0 0 644 "u:object_r:system_file:s0" || exit 1
            DELETE_FROM_WORK_DIR "system" "system/system_ext/etc/NOTICE.xml.gz"

            LOG_STEP_OUT
        fi
    elif [ -d "$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/system_ext" ]; then
        if $TARGET_OS_BUILD_SYSTEM_EXT_PARTITION; then
            LOG_STEP_IN "- Copying /system_ext from source firmware"

            [ -L "$WORK_DIR/system/system_ext" ] && rm -f "$WORK_DIR/system/system_ext"
            [ -d "$WORK_DIR/system/system/system_ext" ] && rm -rf "$WORK_DIR/system/system/system_ext"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/system_ext\" \"$WORK_DIR\"" || exit 1
            mkdir -p "$WORK_DIR/system/system_ext"
            EVAL "ln -sf \"/system_ext\" \"$WORK_DIR/system/system/system_ext\"" || exit 1
            SET_METADATA "system" "system_ext" 0 0 755 "u:object_r:system_file:s0"
            SET_METADATA "system" "system/system_ext" 0 0 644 "u:object_r:system_file:s0"
            grep -F "system/system_ext" "$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-system" | sed "s/^\/system//" > "$WORK_DIR/configs/file_context-system_ext"
            grep -F "system/system_ext" "$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-system" | sed "s/^system\///" > "$WORK_DIR/configs/fs_config-system_ext"
            sed -i "s/^system_ext /  /g" "$WORK_DIR/configs/fs_config-system_ext"

            ADD_TO_WORK_DIR "b0qxxx" "system_ext" "etc/build_flags.json" 0 0 644 "u:object_r:system_file:s0" || exit 1
            ADD_TO_WORK_DIR "b0qxxx" "system_ext" "etc/NOTICE.xml.gz" 0 0 644 "u:object_r:system_file:s0" || exit 1

            LOG_STEP_OUT
        else
            LOG_STEP_IN "- Copying /system/system/system_ext from source firmware"

            [ -d "$WORK_DIR/system/system_ext" ] && rm -rf "$WORK_DIR/system/system_ext"
            [ -L "$WORK_DIR/system/system/system_ext" ] && rm -f "$WORK_DIR/system/system/system_ext"
            [ -d "$WORK_DIR/system_ext" ] && rm -rf "$WORK_DIR/system_ext"
            [ -f "$WORK_DIR/configs/file_context-system_ext" ] && rm -f "$WORK_DIR/configs/file_context-system_ext"
            [ -f "$WORK_DIR/configs/fs_config-system_ext" ] && rm -f "$WORK_DIR/configs/fs_config-system_ext"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/system_ext\" \"$WORK_DIR/system/system\"" || exit 1
            EVAL "ln -sf \"/system/system_ext\" \"$WORK_DIR/system/system_ext\"" || exit 1
            grep -F "system_ext" "$FW_DIR/$SOURCE_FIRMWARE_PATH/file_context-system" >> "$WORK_DIR/configs/file_context-system"
            grep -F "system_ext" "$FW_DIR/$SOURCE_FIRMWARE_PATH/fs_config-system" >> "$WORK_DIR/configs/fs_config-system"

            LOG_STEP_OUT
        fi
    fi
}

COPY_TARGET_FIRMWARE()
{
    local TARGET_FOLDERS="system_dlkm prism optics vendor odm_dlkm vendor_dlkm"
    for f in $TARGET_FOLDERS; do
        COPY_PARTITIONS "$FW_DIR/$TARGET_FIRMWARE_PATH" "$f"
        if [[ "$f" == "vendor" ]]; then
            LOG_STEP_IN
            SET_PROP "vendor" "ro.config.ringtone" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/vendor/build.prop" "ro.config.ringtone")"
            SET_PROP "vendor" "ro.config.notification_sound" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/vendor/build.prop" "ro.config.notification_sound")"
            SET_PROP "vendor" "ro.config.alarm_alert" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/vendor/build.prop" "ro.config.alarm_alert")"
            SET_PROP "vendor" "ro.config.media_sound" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/vendor/build.prop" "ro.config.media_sound")"
            SET_PROP "vendor" "ro.config.ringtone_2" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/vendor/build.prop" "ro.config.ringtone_2")"
            SET_PROP "vendor" "ro.config.notification_sound_2" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/vendor/build.prop" "ro.config.notification_sound_2")"
            LOG_STEP_OUT
        fi
    done

    if [ -d "$FW_DIR/$TARGET_FIRMWARE_PATH/odm" ]; then
        if $TARGET_OS_BUILD_ODM_PARTITION; then
            LOG_STEP_IN "- Copying /odm from target firmware"

            [ -d "$WORK_DIR/vendor/odm" ] && rm -rf "$WORK_DIR/vendor/odm"
        
            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$TARGET_FIRMWARE_PATH/odm\" \"$WORK_DIR\"" || exit 1
            EVAL "ln -sf \"/odm\" \"$WORK_DIR/vendor/odm\"" || exit 1

            SET_METADATA "vendor" "odm" 0 0 644 "u:object_r:vendor_file:s0"

            EVAL "cp -a \"$FW_DIR/$TARGET_FIRMWARE_PATH/file_context-odm\" \"$WORK_DIR/configs/file_context-odm\"" || exit 1
            EVAL "cp -a \"$FW_DIR/$TARGET_FIRMWARE_PATH/fs_config-odm\" \"$WORK_DIR/configs/fs_config-odm\"" || exit 1

            LOG_STEP_OUT
        else
            LOG_STEP_IN "- Copying /vendor/odm from target firmware"

            [ -L "$WORK_DIR/vendor/odm" ] && rm -f "$WORK_DIR/vendor/odm"
            [ -d "$WORK_DIR/odm" ] && rm -rf "$WORK_DIR/odm"
            [ -f "$WORK_DIR/configs/file_context-odm" ] && rm -f "$WORK_DIR/configs/file_context-odm"
            [ -f "$WORK_DIR/configs/fs_config-odm" ] && rm -f "$WORK_DIR/configs/fs_config-odm"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$TARGET_FIRMWARE_PATH/odm\" \"$WORK_DIR/vendor\"" || exit 1

            SET_METADATA "vendor" "odm" 0 0 755 "u:object_r:vendor_file:s0"

            sed "s/^\/odm/\/vendor\/odm/g" "$FW_DIR/$TARGET_FIRMWARE_PATH/file_context-odm" >> "$WORK_DIR/configs/file_context-vendor"
            sed "s/^odm/vendor\/odm/g" "$FW_DIR/$TARGET_FIRMWARE_PATH/fs_config-odm" >> "$WORK_DIR/configs/fs_config-vendor"

            LOG_STEP_OUT
        fi
    elif [ -d "$FW_DIR/$TARGET_FIRMWARE_PATH/vendor/odm" ]; then
        if $TARGET_OS_BUILD_ODM_PARTITION; then
            LOG_STEP_IN "- Copying /odm from target firmware"

            [ -d "$WORK_DIR/vendor/odm" ] && rm -rf "$WORK_DIR/vendor/odm"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$TARGET_FIRMWARE_PATH/vendor/odm\" \"$WORK_DIR\"" || exit 1
            EVAL "ln -sf \"/odm\" \"$WORK_DIR/vendor/odm\"" || exit 1

            SET_METADATA "vendor" "odm" 0 0 644 "u:object_r:vendor_file:s0"

            grep -F "vendor/odm" "$FW_DIR/$TARGET_FIRMWARE_PATH/file_context-vendor" | sed "s/^\/vendor//" > "$WORK_DIR/configs/file_context-odm"
            grep -F "vendor/odm" "$FW_DIR/$TARGET_FIRMWARE_PATH/fs_config-vendor" | sed "s/^vendor\///" > "$WORK_DIR/configs/fs_config-odm"
            sed -i "s/^odm /  /g" "$WORK_DIR/configs/fs_config-odm"

            LOG_STEP_OUT
        else
            LOG_STEP_IN "- Copying /vendor/odm from target firmware"

            [ -L "$WORK_DIR/vendor/odm" ] && rm -f "$WORK_DIR/vendor/odm"
            [ -f "$WORK_DIR/configs/file_context-odm" ] && rm -f "$WORK_DIR/configs/file_context-odm"
            [ -f "$WORK_DIR/configs/fs_config-odm" ] && rm -f "$WORK_DIR/configs/fs_config-odm"

            EVAL "rsync -a --mkpath --delete \"$FW_DIR/$TARGET_FIRMWARE_PATH/vendor/odm\" \"$WORK_DIR/vendor\"" || exit 1

            grep -F "odm" "$FW_DIR/$TARGET_FIRMWARE_PATH/file_context-vendor" >> "$WORK_DIR/configs/file_context-vendor"
            grep -F "odm" "$FW_DIR/$TARGET_FIRMWARE_PATH/fs_config-vendor" >> "$WORK_DIR/configs/fs_config-vendor"

            LOG_STEP_OUT
        fi
    fi
}

COPY_TARGET_KERNEL()
{
    if [ -d "$FW_DIR/$TARGET_FIRMWARE_PATH/kernel" ]; then
        LOG_STEP_IN "- Copying target firmware kernel images"
        EVAL "rsync -a --mkpath --delete \"$FW_DIR/$TARGET_FIRMWARE_PATH/kernel\" \"$WORK_DIR\"" || exit 1
        $TARGET_KEEP_ORIGINAL_SIGN || find "$WORK_DIR/kernel" -mindepth 1 -exec "$SRC_DIR/scripts/unsign_bin.sh" {} \;
        LOG_STEP_OUT
    else
        [ -d "$WORK_DIR/kernel" ] && rm -rf "$WORK_DIR/kernel"
    fi
}
# ]

mkdir -p "$WORK_DIR"
mkdir -p "$WORK_DIR/configs"
COPY_SOURCE_FIRMWARE
COPY_TARGET_FIRMWARE
COPY_TARGET_KERNEL

exit 0
