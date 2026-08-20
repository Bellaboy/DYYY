#
#  DYYY
#
#  Copyright (c) 2024 huami. All rights reserved.
#  Channel: @huamidev
#  Created on: 2024/10/04
#
# 本地配置文件（可选）
-include Makefile.local

TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

#export THEOS_PACKAGE_SCHEME=roothide

# 本地默认 rootless；SCHEME=rootful / SCHEME=roothide 可切换
SCHEME ?= rootless
ifeq ($(SCHEME),roothide)
    export THEOS_PACKAGE_SCHEME = roothide
    export FINALPACKAGE = 1
else ifeq ($(SCHEME),rootful)
    unexport THEOS_PACKAGE_SCHEME
else ifeq ($(SCHEME),rootless)
    export THEOS_PACKAGE_SCHEME = rootless
    export FINALPACKAGE = 1
else
    $(error Unknown SCHEME=$(SCHEME); use rootless, rootful, or roothide)
endif

# 在GitHub Actions中运行时的特殊配置
ifeq ($(GITHUB_ACTIONS),true)
    export INSTALL = 0
    export FINALPACKAGE = 1
endif

export DEBUG = 0
INSTALL_TARGET_PROCESSES = Aweme

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DYYY
include Makefile.sources

DYYY_FILES = $(DYYY_SOURCE_FILES)
DYYY_CFLAGS = $(DYYY_COMMON_CFLAGS)
DYYY_LDFLAGS = $(DYYY_COMMON_LDFLAGS)
DYYY_FRAMEWORKS = $(DYYY_COMMON_FRAMEWORKS)
CXXFLAGS += -std=c++11
CCFLAGS += -std=c++11
DYYY_LOGOS_DEFAULT_GENERATOR = internal

export THEOS_STRICT_LOGOS=0
export ERROR_ON_WARNINGS=0
export LOGOS_DEFAULT_GENERATOR=internal

include $(THEOS_MAKE_PATH)/tweak.mk

# 清理 packages 目录
clean::
	@echo -e "\033[31m==>\033[0m Cleaning packages…"
	@rm -rf .theos packages

after-package::
	@echo -e "\033[32m==>\033[0m Packaging complete."
