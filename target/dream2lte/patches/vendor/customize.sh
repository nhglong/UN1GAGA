for partition in vendor vendor_dlkm odm odm_dlkm; do
  SET_PROP "$partition" "ro.product."$partition".device" "dream2lte"
  SET_PROP "$partition" "ro.product."$partition".model" "SM-G955F"
  SET_PROP "$partition" "ro.product."$partition".name" "dream2ltexx"
  SET_PROP "$partition" "ro."$partition".build.fingerprint" "samsung/dream2ltexx/dream2lte:9/PPR1.180610.011/G955FXXUCDZC3:user/release-keys"
  SET_PROP "$partition" "ro."$partition".build.version.incremental" "G955FXXUCDZC3"
done
