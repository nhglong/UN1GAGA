for partition in vendor vendor_dlkm odm odm_dlkm; do
  SET_PROP "$partition" "ro.product."$partition".device" "dreamlte"
  SET_PROP "$partition" "ro.product."$partition".model" "SM-G950F"
  SET_PROP "$partition" "ro.product."$partition".name" "dreamltexx"
  SET_PROP "$partition" "ro."$partition".build.fingerprint" "samsung/dreamltexx/dreamlte:9/PPR1.180610.011/G955FXXUCDVI2:user/release-keys"
  SET_PROP "$partition" "ro."$partition".build.version.incremental" "G950FXXUCDVI2"
done

EVAL "sed -i \"s/ro.boot.dynamic_partitions=true/ro.board.first_api_level=24/g\" \"$WORK_DIR/vendor/build.prop\""
SET_PROP "vendor" "ro.product.first_api_level" "24"
