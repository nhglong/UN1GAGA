for partition in vendor vendor_dlkm odm odm_dlkm; do
  SET_PROP "$partition" "ro.product."$partition".device" "greatlte"
  SET_PROP "$partition" "ro.product."$partition".model" "SM-N950F"
  SET_PROP "$partition" "ro.product."$partition".name" "greatltexx"
  SET_PROP "$partition" "ro."$partition".build.fingerprint" "samsung/greatltexx/greatlte:9/PPR1.180610.011/N950FXXUGDZC3:user/release-keys"
  SET_PROP "$partition" "ro."$partition".build.version.incremental" "N950FXXUGDZC3"
done

SET_PROP "vendor" "ro.product.first_api_level" "25"
