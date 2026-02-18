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
