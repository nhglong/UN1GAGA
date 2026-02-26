if [[ -d "$TMP_DIR" ]]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
mkdir -p "$TMP_DIR"

KERNEL_URL="https://api.github.com/repos/samsungexynos850/atlas/releases/latest"
KERNEL_TAG="$(
    curl -sL "$KERNEL_URL" \
    | grep -m1 '"tag_name"' \
    | cut -d '"' -f4
)"

KERNEL_LINK="https://github.com/samsungexynos850/atlas/releases/download/$KERNEL_TAG"
KERNEL_ARCHIVE="$(
    curl -sL "$KERNEL_URL" \
    | grep -oE "atlas\.zip" \
    | sort -u \
    | tail -n 1
)"

LOG_STEP_IN "- Downloading kernel"
DOWNLOAD_FILE "$KERNEL_LINK/$KERNEL_ARCHIVE" "$TMP_DIR/$KERNEL_ARCHIVE"
LOG_STEP_OUT

LOG_STEP_IN "- Extracting boot.img"
EVAL "cp -a \"$WORK_DIR/kernel/boot.img\" \"$TMP_DIR/boot.img\""
MKBOOTIMG_ARGS="$(unpack_bootimg --boot_img "$TMP_DIR/boot.img" --out "$TMP_DIR/out" --format mkbootimg 2>&1)"

if [ ! -f "$TMP_DIR/out/kernel" ]; then
    ABORT "Failed to extract boot.img\n\n$MKBOOTIMG_ARGS"
fi
LOG_STEP_OUT

LOG_STEP_IN "- Repacking boot.img"
EVAL "rm -rf \"$TMP_DIR/out/dtb\""
EVAL "rm -rf \"$TMP_DIR/out/kernel\""
EVAL "unzip -o \"$TMP_DIR/$KERNEL_ARCHIVE\" \"dtb\" -d \"$TMP_DIR/out\""
EVAL "unzip -o \"$TMP_DIR/$KERNEL_ARCHIVE\" \"Image\" -d \"$TMP_DIR/out\""
EVAL "mv \"$TMP_DIR/out/Image\" \"$TMP_DIR/out/kernel\""

EVAL "mkbootimg $MKBOOTIMG_ARGS -o \"$TMP_DIR/new-boot.img\""
echo -n "SEANDROIDENFORCE" >> "$TMP_DIR/new-boot.img"
EVAL "mv -f \"$TMP_DIR/new-boot.img\" \"$WORK_DIR/kernel/boot.img\""
LOG_STEP_OUT

EVAL "rm -rf \"$TMP_DIR\""

unset MKBOOTIMG_ARGS
