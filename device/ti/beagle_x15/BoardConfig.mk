#
# Copyright (C) 2018 Texas Instruments Incorporated - http://www.ti.com/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a15
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true

TARGET_BOOTIMAGE_FIT := true
TARGET_USES_64_BIT_BINDER := true

#Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true
BOARD_VNDK_VERSION := current

# Use mke2fs to create ext4 images
TARGET_USES_MKE2FS := true
TARGET_USES_HWC2 := true

DEVICE_MANIFEST_FILE := device/ti/beagle_x15/manifest.xml
DEVICE_MATRIX_FILE := device/ti/beagle_x15/compatibility_matrix.xml

PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

BOARD_FLASH_BLOCK_SIZE := 4096

USE_CAMERA_STUB := true

BOARD_BOOTIMAGE_PARTITION_SIZE := 20971520 # 20 MiB
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864 # 64 MiB
BOARD_USERDATAIMAGE_PARTITION_SIZE := 961658368 # ~917 MiB
BOARD_DTBOIMG_PARTITION_SIZE := 8388608 # 8 MiB

BOARD_SUPER_PARTITION_SIZE := 2684354560 # 2560 MiB
BOARD_SUPER_PARTITION_GROUPS := group_oem
# In case when A/B is enabled and we have only one group:
# size_group = (size_super - 1 MiB) / 2
BOARD_GROUP_OEM_SIZE := 1341652992 # 1279.5 MiB
BOARD_GROUP_OEM_PARTITION_LIST := system vendor
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_BOOTLOADER_BOARD_NAME := beagle_x15board
TARGET_BOARD_PLATFORM := am57x
TARGET_COPY_OUT_VENDOR := vendor

TARGET_RECOVERY_FSTAB := device/ti/beagle_x15/$(TARGET_FSTAB)
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_UI_LIB := librecovery_ui_beagle_x15
TARGET_RELEASETOOLS_EXTENSIONS := device/ti/beagle_x15

BOARD_SEPOLICY_DIRS += \
	device/ti/beagle_x15/sepolicy

ifeq ($(TARGET_PRODUCT),beagle_x15_auto)
BOARD_SEPOLICY_DIRS += \
	packages/services/Car/car_product/sepolicy
endif

BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Copy uboot prebuilts
PRODUCT_COPY_FILES += \
	device/ti/beagle_x15/bootloader/MLO:$(TARGET_OUT)/MLO \
	device/ti/beagle_x15/bootloader/u-boot.img:$(TARGET_OUT)/u-boot.img \


# Copy kernel modules (including pvrsrvkm.ko) into /vendor/lib/modules
BOARD_ALL_MODULES := $(shell find $(LOCAL_KERNEL_HOME) -type f -iname '*.ko')
BOARD_VENDOR_KERNEL_MODULES += $(BOARD_ALL_MODULES)

# Check if SGX kernel module is present in chosen kernel directory
SGX_KO := $(shell find $(LOCAL_KERNEL_HOME) -type f -name 'pvrsrvkm.ko')
ifeq ($(SGX_KO),)
  $(warning SGX module (pvrsrvkm.ko) not found, graphics will not work)
  $(warning SGX module search path is: $(LOCAL_KERNEL_HOME))
endif

BOARD_AVB_ENABLE := true

# Include *.dtb to boot.img and use Android Boot Image v2
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_MKBOOTIMG_ARGS := --header_version 2

# Pass unsigned dtbo image (generated by build/tasks/dtimages.mk) to Android
# build system for AVB signing
DTBO_UNSIGNED := dtbo-unsigned.img
# $(PRODUCT_OUT) hasn't been defined yet, so use "=" instead of ":="
# so that it is resolved later
BOARD_PREBUILT_DTBOIMAGE = $(PRODUCT_OUT)/$(DTBO_UNSIGNED)

# Board uses A/B OTA.
AB_OTA_UPDATER := true
# A/B updater updatable partitions list. Keep in sync with the partition list
# with "_a" and "_b" variants in the device. Note that the vendor can add more
# partitions to this list for the bootloader and radio.
AB_OTA_PARTITIONS += \
	boot \
	system \
	vbmeta \
	dtbo \
	vendor
