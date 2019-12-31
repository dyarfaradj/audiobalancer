include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AudioBalancer
AudioBalancer_FILES = Tweak.xm
AudioBalancer_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
