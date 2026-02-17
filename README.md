# Redmi-10A GPU Performance Unlock

Extreme GPU Performance Unlock for Redmi 10A (Helio G25).

This module forces the PowerVR GE8320 GPU to stay at the highest available OPP (Operating Performance Point) and continuously prevents vendor power services from lowering the clock.

---

## Features

- Automatic detection of highest GPU OPP
- Force GPU min_freq = max_freq
- Force devfreq governor to performance
- Disable GPU idle (GED layer)
- Aggressive DVFS margin boost
- CPU performance assist
- Scheduler boost enabled
- Anti-override watchdog (reapply every 5 seconds)
- No thermal service interference
- No vendor file replacement
- No system property hacks
- Clean runtime-only implementation

---

## How It Works

This module operates at runtime using kernel node overrides:

- /proc/gpufreq
- /sys/class/devfreq
- /sys/kernel/ged

It continuously re-applies max frequency settings to prevent vendor PowerHAL or FPSGO from scaling the GPU down.

---

## Important Notes

- This module does NOT create new overclock frequencies.
- It locks the GPU to the highest OPP already available in your kernel.
- If your kernel maximum is 600 MHz, it will stay at 600 MHz.
- If your kernel supports 900 MHz, it will stay at 900 MHz.

---

## Compatibility

- Device: Redmi 10A
- SoC: MediaTek Helio G25
- GPU: PowerVR GE8320
- Android 13 (64-bit)
- Tested on SuperiorOS
- Compatible with Thermal Breaker Miyabi Core

---

## Warning

This module forces maximum GPU performance at all times.

Possible side effects:
- High temperature (50°C+)
- Increased battery drain
- Random reboots under extreme load
- Long-term silicon degradation

Install at your own risk.

---

## Installation

1. Flash via Magisk
2. Reboot
3. Done

---

## Uninstall

Remove module from Magisk and reboot.
No residual changes remain after reboot.

---

## License

Free to modify and redistribute with credit.
