for partition in vendor vendor_dlkm odm odm_dlkm; do
  SET_PROP "$partition" "ro.product."$partition".device" "dreamlte"
  SET_PROP "$partition" "ro.product."$partition".model" "SM-G950F"
  SET_PROP "$partition" "ro.product."$partition".name" "dreamltexx"
  SET_PROP "$partition" "ro."$partition".build.fingerprint" "samsung/dreamltexx/dreamlte:9/PPR1.180610.011/G955FXXUCDZC3:user/release-keys"
  SET_PROP "$partition" "ro."$partition".build.version.incremental" "G955FXXUCDZC3"
done
