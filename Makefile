export THEOS = /home/codespace/theos
export TARGET = iphone:clang:latest:14.0
export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyAuthTweak

KeyAuthTweak_FILES = Tweak.xm KeyManager.m LoginViewController.m
KeyAuthTweak_FRAMEWORKS = UIKit Foundation
KeyAuthTweak_PRIVATE_FRAMEWORKS = IOKit
KeyAuthTweak_CFLAGS = -fobjc-arc

# Thêm static lib .a
$(TWEAK_NAME)_LDFLAGS += API/libTKAPIKey.a

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"