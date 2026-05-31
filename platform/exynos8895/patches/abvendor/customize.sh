SKIPUNZIP=1

LOG "- Deleting old vendor blobs"
EVAL "rm -r \"$WORK_DIR/vendor\" &"
EVAL "rm -f \"$WORK_DIR/configs/file_context-vendor\""
EVAL "rm -f \"$WORK_DIR/configs/fs_config-vendor\""

LOG "- Adding new vendor blobs"
EVAL "rsync -a --mkpath --delete \"$MODPATH/vendor\" \"$WORK_DIR\"" || exit 1
EVAL "cp -a \"$MODPATH/file_context-vendor\" \"$WORK_DIR/configs/file_context-vendor\"" || exit 1
EVAL "cp -a \"$MODPATH/fs_config-vendor\" \"$WORK_DIR/configs/fs_config-vendor\"" || exit 1

LOG "- Creating vendor symlinks"
while read -r a placeholder f; do
  a=${a#\'}
  a=${a%\'}

  EVAL "ln -sf \"$f\" \"$WORK_DIR/vendor/bin/$a\""
  SET_METADATA "vendor" "bin/$a" 0 2000 755 "u:object_r:vendor_file:s0" > /dev/null
done < "$MODPATH/symlink_list.txt"

ARCHS="lib lib64"
for a in $ARCHS; do
  EVAL "ln -sf \"/vendor/$a/egl/libGLES_mali.so\" \"$WORK_DIR/vendor/$a/hw/vulkan.mali.so\""
  EVAL "ln -sf \"/vendor/$a/egl/libGLES_mali.so\" \"$WORK_DIR/vendor/$a/libOpenCL.so\""
  EVAL "ln -sf \"/vendor/$a/egl/libGLES_mali.so\" \"$WORK_DIR/vendor/$a/libOpenCL.so.1\""
  EVAL "ln -sf \"/vendor/$a/egl/libGLES_mali.so\" \"$WORK_DIR/vendor/$a/libOpenCL.so.1.1\""
  SET_METADATA "vendor" "$a/hw/vulkan.mali.so" 0 0 644 "u:object_r:same_process_hal_file:s0" > /dev/null
  SET_METADATA "vendor" "$a/libOpenCL.so" 0 0 644 "u:object_r:same_process_hal_file:s0" > /dev/null
  SET_METADATA "vendor" "$a/libOpenCL.so.1" 0 0 644 "u:object_r:same_process_hal_file:s0" > /dev/null
  SET_METADATA "vendor" "$a/libOpenCL.so.1.1" 0 0 644 "u:object_r:same_process_hal_file:s0" > /dev/null
done

SET_PROP "vendor" "ro.boot.dynamic_partitions" --delete
LOG "- Adding \"ro.board.first_api_level\" prop with \"24\" in /vendor/build.prop"
EVAL "sed -i \"/ro.product.first_api_level/a ro.board.first_api_level=24\" \"$WORK_DIR/vendor/build.prop\""
SET_PROP "vendor" "ro.product.first_api_level" "$TARGET_PRODUCT_SHIPPING_API_LEVEL"
LOG "- Adding \"dalvik.vm.dex2oat64.enabled\" prop with \"true\" in /vendor/build.prop"
EVAL "sed -i \"/ro.zygote=zygote64_32/i dalvik.vm.dex2oat64.enabled=true\" \"$WORK_DIR/vendor/build.prop\""
LOG "- Adding \"ro.incremental.enable\" prop with \"yes\" in /vendor/build.prop"
EVAL "sed -i \"/aaudio.mmap_policy/i ro.incremental.enable=yes\" \"$WORK_DIR/vendor/build.prop\""
SET_PROP "vendor" "ro.board.platform" "exynos8895"
SET_PROP "vendor" "ro.product.board" "universal8895"
SET_PROP "vendor" "ro.hardware.keystore" "mdfpp"
SET_PROP "vendor" "ro.hardware.keystore_desede" --delete
SET_PROP "vendor" "ro.security.keystore.keytype" "sak"
SET_PROP_IF_DIFF "vendor" "ro.vendor.nfc.feature.chipname" "SLSI"
SET_PROP_IF_DIFF "vendor" "ro.vendor.nfc.support.ese" "false"
SET_PROP "vendor" "ro.zygote.disable_gl_preload" "true"
