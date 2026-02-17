#!/system/bin/sh

# Tunggu semua service vendor siap
sleep 40

log_print() {
    echo "[GPU_RAGE] $1"
}

# =========================
# DETECT GPU PROC
# =========================

GPU_PROC="/proc/gpufreq"
GPU_DEVFREQ="/sys/class/devfreq"

MAXFREQ=""

if [ -f $GPU_PROC/gpufreq_opp_dump ]; then
    MAXFREQ=$(cat $GPU_PROC/gpufreq_opp_dump | awk 'NR==1{print $1}')
    log_print "Detected MAX OPP: $MAXFREQ"
fi

# =========================
# FUNCTION: FORCE MAX
# =========================

force_gpu_max() {

    # MTK gpufreq force
    if [ -n "$MAXFREQ" ]; then
        echo $MAXFREQ > $GPU_PROC/gpufreq_opp_freq 2>/dev/null
    fi

    # Devfreq force
    for dev in $GPU_DEVFREQ/*; do
        if [ -f "$dev/min_freq" ] && [ -f "$dev/max_freq" ]; then
            MAX=$(cat $dev/max_freq)
            echo $MAX > $dev/min_freq 2>/dev/null
            echo performance > $dev/governor 2>/dev/null
        fi
    done

    # Disable GPU idle (GED layer)
    if [ -e /sys/module/ged/parameters/gpu_idle ]; then
        echo 0 > /sys/module/ged/parameters/gpu_idle 2>/dev/null
    fi

    if [ -e /sys/kernel/ged/hal/gpu_idle ]; then
        echo 0 > /sys/kernel/ged/hal/gpu_idle 2>/dev/null
    fi

    # Aggressive DVFS margin
    if [ -e /sys/kernel/ged/hal/dvfs_margin_value ]; then
        echo 400 > /sys/kernel/ged/hal/dvfs_margin_value 2>/dev/null
    fi

    # Force sched boost
    echo 1 > /proc/sys/kernel/sched_boost 2>/dev/null
}

# =========================
# CPU SUPPORT MAX
# =========================

for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo performance > $cpu 2>/dev/null
done

# =========================
# MAIN LOOP (ANTI OVERRIDE)
# =========================

while true
do
    force_gpu_max
    sleep 5
done
