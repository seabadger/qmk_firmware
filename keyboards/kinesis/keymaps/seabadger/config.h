#ifndef CONFIG_USER_H
#define CONFIG_USER_H

#include "../../config.h"

// place overrides here
#define TAPPING_TERM 190 // default 200
#undef IGNORE_MOD_TAP_INTERRUPT
#define PERMISSIVE_HOLD
#endif

// caps word: https://docs.qmk.fm/#/feature_caps_word
#define BOTH_SHIFTS_TURNS_ON_CAPS_WORD
