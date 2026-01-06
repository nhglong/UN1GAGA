# Copyright (c) 2025 Salvo Giangreco
# SPDX-License-Identifier: GPL-3.0-or-later

# Debloat list for Samsung Exynos 8895 devices (exynos8895)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# AR Emoji
SYSTEM_DEBLOAT+="
system/etc/permissions/com.samsung.feature.aremoji_v2.xml
system/etc/permissions/privapp-permissions-com.samsung.android.aremoji.xml
system/priv-app/AREmoji
"

# Single Take
SYSTEM_DEBLOAT+="
system/etc/default-permissions/default-permissions-com.samsung.android.singletake.service.xml
system/etc/permissions/privapp-permissions-com.samsung.android.singletake.service.xml
system/priv-app/SingleTakeService
"

# Apps debloat
SYSTEM_DEBLOAT+="
system/etc/permissions/privapp-permissions-com.samsung.android.app.earphonetypec.xml
system/app/StickerCenter
system/priv-app/AutoDoodle
system/priv-app/BixbyVisionFramework3.5
system/priv-app/EarphoneTypeC
"
