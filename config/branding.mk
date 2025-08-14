NAD_VERSION_BASE := EOL
NAD_BUILD_CODENAME := FINAL
NAD_BUILD_TYPE := FE
NAD_OTA_BRANCH := 10

# Signing
ifeq (user,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard vendor/nusantara/signing/keys/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/nusantara/signing/keys/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard vendor/nusantara/signing/keys/verity.pk8))
PRODUCT_VERITY_SIGNING_KEY := vendor/nusantara/signing/keys/verity
endif
ifneq (,$(wildcard vendor/nusantara/signing/keys/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := vendor/nusantara/signing/keys/otakey.x509.pem
endif
BUILD_TIME := $(shell date -u +%H%M)-signed
else
BUILD_TIME := $(shell date -u +%H%M)-unsigned
endif

# Set all versions
BUILD_DATE := $(shell date -u +%d%m%Y)
BUILD_DATE_TIME := $(BUILD_TIME)$(BUILD_DATE)
ROM_FINGERPRINT := Nusantara/$(NAD_VERSION_BASE)/$(PLATFORM_VERSION)/$(NAD_BUILD_TYPE)/$(BUILD_ID)/$(BUILD_DATE)/$(BUILD_TIME)

ifndef
     NAD_VERSION := Nusantara-$(NAD_VERSION_BASE)-$(NAD_BUILD_CODENAME)-$(NAD_BUILD)-$(BUILD_DATE)-$(NAD_BUILD_TYPE)-$(BUILD_TIME)
 ifeq ($(USE_GAPPS),true)
     NAD_VERSION := Nusantara-$(NAD_VERSION_BASE)-$(NAD_BUILD_CODENAME)-$(NAD_BUILD)-Gapps-$(BUILD_DATE)-$(NAD_BUILD_TYPE)-$(BUILD_TIME)
 else ifeq ($(USE_MICROG),true)
     NAD_VERSION := Nusantara-$(NAD_VERSION_BASE)-$(NAD_BUILD_CODENAME)-$(NAD_BUILD)-MicroG-$(BUILD_DATE)-$(NAD_BUILD_TYPE)-$(BUILD_TIME)
 endif
endif

NAD_PROPERTIES := \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.build.datetime=$(BUILD_DATE_TIME) \
    ro.nad.build.date=$(BUILD_DATE) \
    ro.nad.version=$(NAD_VERSION) \
    ro.nad.build.type=$(NAD_BUILD_TYPE) \
    ro.nad.build.version=$(NAD_VERSION_BASE) \
    ro.nad.build_codename=$(NAD_BUILD_CODENAME) \
    ro.nad.fingerprint=$(ROM_FINGERPRINT) \
    ro.nad.ota.version_code=$(NAD_OTA_BRANCH)

# Var definition for jenkins script
$(info) $(shell echo $(NAD_VERSION) > $(OUT_DIR)/var-file_name)
