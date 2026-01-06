for partition in vendor vendor_dlkm odm odm_dlkm; do
  SET_PROP "$partition" "ro.product."$partition".device" "dream2lte"
  SET_PROP "$partition" "ro.product."$partition".model" "SM-G955F"
  SET_PROP "$partition" "ro.product."$partition".name" "dream2ltexx"
  SET_PROP "$partition" "ro."$partition".build.fingerprint" "samsung/dream2ltexx/dream2lte:9/PPR1.180610.011/G955FXXUCDVI2:user/release-keys"
  SET_PROP "$partition" "ro."$partition".build.version.incremental" "G955FXXUCDVI2"
done

EVAL "sed -i \"s/ro.boot.dynamic_partitions=true/ro.board.first_api_level=24/g\" \"$WORK_DIR/vendor/build.prop\""
SET_PROP "vendor" "ro.product.first_api_level" "24"
