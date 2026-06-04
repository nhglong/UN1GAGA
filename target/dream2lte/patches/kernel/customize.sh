for i in "dt" "dtbo" "init_boot" "vendor_boot"; do
    LOG "- Removing $i.img"

    if [[ -f "$WORK_DIR/kernel/$i.img" ]]; then
        EVAL "rm -f \"$WORK_DIR/kernel/$i.img\""
    fi
done

LOG "- Replacing boot.img"
EVAL "cp \"$MODPATH/boot.img\" \"$WORK_DIR/kernel/boot.img\""
