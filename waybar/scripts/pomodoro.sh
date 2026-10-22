#!/usr/bin/env bash
#
# Pomodoro timer for waybar.
#
# State file format (4 lines):
#   line 1: status  -> "stopped" | "running"
#   line 2: phase   -> "work" | "break"
#   line 3: end epoch (epoch seconds when the current phase finishes)
#   line 4: last remaining seconds when paused (for display)
#
# Args:
#   $1 = "toggle" : start if stopped, pause if running (left click)
#   $1 = "reset"  : stop and reset to the initial working phase (right click)
#
STATE_FILE="/tmp/pomodoro.state"
WORK_SECONDS=$((25 * 60))
BREAK_SECONDS=$((5 * 60))

notify() {
    notify-send -u normal "Pomodoro" "$1"
}

now() {
    date +%s
}

if [ ! -f "$STATE_FILE" ]; then
    printf 'stopped\nwork\n0\n' > "$STATE_FILE"
fi

mapfile -t _L < "$STATE_FILE"
STATUS=${_L[0]}
PHASE=${_L[1]}
ENDFROM=${_L[2]}
LAST_LEFT=${_L[3]:-0}

# Recompute remaining seconds from the end epoch while running.
if [ "$STATUS" = "running" ]; then
    NOW=$(now)
    LEFT=$(( ENDFROM - NOW ))
    if [ "$LEFT" -le 0 ]; then
        LEFT=0
    fi
else
    if [ "$PHASE" = "work" ]; then
        LEFT=$LAST_LEFT
    else
        LEFT=$BREAK_SECONDS
    fi
fi

format_time() {
    local TOTAL=$1
    printf "%02d:%02d" "$(( TOTAL / 60 ))" "$(( TOTAL % 60 ))"
}

start_phase() {
    local NEXT_PHASE=$1
    local NEXT_SECONDS
    if [ "$NEXT_PHASE" = "work" ]; then
        NEXT_SECONDS=$WORK_SECONDS
    else
        NEXT_SECONDS=$BREAK_SECONDS
    fi
    ENDFROM=$(( $(now) + NEXT_SECONDS ))
    printf 'running\n%s\n%s\n' "$NEXT_PHASE" "$ENDFROM" > "$STATE_FILE"
}

if [ "${1:-}" = "toggle" ]; then
    if [ "$STATUS" = "stopped" ]; then
        RESUME=$LEFT
        if [ "$RESUME" -le 0 ]; then
            RESUME=$WORK_SECONDS
        fi
        ENDFROM=$(( $(now) + "$RESUME" ))
        printf 'running\n%s\n%s\n%s\n' "$PHASE" "$ENDFROM" "$RESUME" > "$STATE_FILE"
        printf "%s 󰂘" "$(format_time "$RESUME")"
    elif [ "$STATUS" = "running" ]; then
        printf 'stopped\n%s\n%s\n%s\n' "$PHASE" "$LEFT" "$LEFT" > "$STATE_FILE"
        notify "Timer paused"
    fi
elif [ "${1:-}" = "reset" ]; then
    printf 'stopped\nwork\n%s\n%s\n' "$WORK_SECONDS" "$WORK_SECONDS" > "$STATE_FILE"
    notify "Timer reset"
else
    # Just display the current state.
    if [ "$STATUS" = "running" ]; then
        printf "%s 󰂘" "$(format_time "$LEFT")"
        [ "$LEFT" -le 0 ] && printf ""
    else
        if [ "$PHASE" = "work" ]; then
            printf "%s 󰂘" "$(format_time "$LEFT")"
        else
            printf "%s 󰂘" "$(format_time "$BREAK_SECONDS")"
        fi
    fi
fi

# If running and a phase just finished, advance to the next phase.
if [ "$STATUS" = "running" ] && [ "$LEFT" -le 0 ] && [ "${1:-}" != "toggle" ]; then
    if [ "$PHASE" = "work" ]; then
        start_phase "break"
        notify "Break time!"
    else
        start_phase "work"
        notify "Pomodoro complete! New session started."
    fi
fi
