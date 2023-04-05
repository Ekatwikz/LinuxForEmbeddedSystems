#pragma once

#include <errno.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
//#include <gpiod.h>

#include "tinyErrorHelpers.h"
#include "fake-gpiod.h" // tmp, delete include and file l8r?
#define GIGA 1000000000L

static int myNanoSleep (long nanoseconds);

#define LED1_NUM 22 // GPIO number for the LED
#define LED2_NUM 24 // GPIO number for the LED
#define BUTTON1_NUM 17 // GPIO number for button 1
#define BUTTON2_NUM 18 // GPIO number for button 2

#define DEBOUNCE_SECONDS 0.15 // 150ms
