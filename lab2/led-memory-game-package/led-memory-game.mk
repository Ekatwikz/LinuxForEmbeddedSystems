################################################################################
#
# LED-Memory-Game
#
################################################################################

# https://buildroot.org/downloads/manual/manual.html#_infrastructure_for_packages_with_specific_build_systems

LED_MEMORY_GAME_VERSION = 0.0.1
LED_MEMORY_GAME_SOURCE = led-memory-game-$(LED_MEMORY_GAME_VERSION).tar.gz
LED_MEMORY_GAME_SITE = https://spages.mini.pw.edu.pl/~katwikirizee/LinES
LED_MEMORY_GAME_LICENSE = GPL-3.0+
LED_MEMORY_GAME_LICENSE_FILES = LICENSE
LED_MEMORY_GAME_DEPENDENCIES = libgpiod

define LED_MEMORY_GAME_BUILD_CMDS
    $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define LED_MEMORY_GAME_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/led-memory-game $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
