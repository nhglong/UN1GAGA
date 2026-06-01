LOG_STEP_IN "- Cleaning old vendor blobs"
# wlbtd
DELETE_FROM_WORK_DIR "vendor" "bin/wlbtd"
LOG_STEP_OUT

LOG_STEP_IN "- Updating audio blobs"
ARCHS="lib lib64"
for a in $ARCHS; do
    DELETE_FROM_WORK_DIR "vendor" "$a/hw/android.hardware.audio.effect@5.0-impl.so"
    DELETE_FROM_WORK_DIR "vendor" "$a/hw/android.hardware.audio@5.0-impl.so"
    DELETE_FROM_WORK_DIR "vendor" "$a/android.hardware.audio@5.0.so"
    DELETE_FROM_WORK_DIR "vendor" "$a/android.hardware.audio@5.0-util.so"
    DELETE_FROM_WORK_DIR "vendor" "$a/android.hardware.audio.common@5.0-util.so"
    DELETE_FROM_WORK_DIR "vendor" "$a/android.hardware.audio.effect@5.0.so"
    DELETE_FROM_WORK_DIR "vendor" "$a/android.hardware.audio.effect@5.0-util.so"

    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/hw/android.hardware.audio@6.0-impl.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/hw/android.hardware.audio.effect@6.0-impl.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/android.hardware.audio@6.0.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/android.hardware.audio@6.0-util.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/android.hardware.audio.common-util.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/android.hardware.audio.common@6.0-util.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/android.hardware.audio.common@6.0.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/android.hardware.audio.effect@6.0-util.so" 0 0 644 u:object_r:vendor_file:s0
    ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "$a/android.hardware.audio.effect@6.0.so" 0 0 644 u:object_r:vendor_file:s0
done
LOG_STEP_OUT

LOG_STEP_IN "- Updating vibrator blobs"
DELETE_FROM_WORK_DIR "vendor" "bin/hw/vendor.samsung.hardware.vibrator@2.2-service"
DELETE_FROM_WORK_DIR "vendor" "etc/init/vendor.samsung.hardware.vibrator@2.2-service.rc"
DELETE_FROM_WORK_DIR "vendor" "lib64/android.hardware.vibrator@1.0.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/android.hardware.vibrator@1.1.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/android.hardware.vibrator@1.2.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/android.hardware.vibrator@1.3.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.0.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.1.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.2.so"

ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "bin/hw/vendor.samsung.hardware.vibrator-service" 0 2000 755 "u:object_r:hal_vibrator_default_exec:s0"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "etc/init/vendor.samsung.hardware.vibrator-default.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "etc/vintf/manifest/vendor.samsung.hardware.vibrator-default.xml" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "lib64/vendor.samsung.hardware.vibrator-V5-ndk_platform.so" 0 0 644 "u:object_r:vendor_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Removing renderscript blobs"
DELETE_FROM_WORK_DIR "vendor" "lib/hw/android.hardware.renderscript@1.0-impl.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/hw/android.hardware.renderscript@1.0-impl.so"
LOG_STEP_OUT

LOG_STEP_IN "- Updating bluetooth audio blobs"
DELETE_FROM_WORK_DIR "vendor" "etc/a2dpsink_audio_policy_configuration.xml"
EVAL "mv \"$WORK_DIR/vendor/etc/audio_policy_configuration_sec.xml\" \"$WORK_DIR/vendor/etc/audio_policy_configuration_base.xml\""
EVAL "sed -i \"s/audio_policy_configuration_sec/audio_policy_configuration_base/g\" \"$WORK_DIR/configs/file_context-vendor\""
EVAL "sed -i \"s/audio_policy_configuration_sec/audio_policy_configuration_base/g\" \"$WORK_DIR/configs/fs_config-vendor\""
EVAL "sed -i \"s/a2dp_audio_policy_configuration/bluetooth_audio_policy_configuration/g\" \"$WORK_DIR/vendor/etc/audio_policy_configuration_base.xml\""
DELETE_FROM_WORK_DIR "vendor" "etc/a2dp_audio_policy_configuration.xml"
EVAL "sed -i \"/hearing_aid_audio_policy_configuration/d\" \"$WORK_DIR/vendor/etc/audio_policy_configuration_base.xml\""
LOG_STEP_OUT
