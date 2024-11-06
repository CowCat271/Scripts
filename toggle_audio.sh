#!/usr/bin/env bash

# Get the list of sinks and their count
sinks=($(pactl list short sinks | awk '{print $2}'))
sink_count=${#sinks[@]}

# Check if we have exactly two sinks
if [ "$sink_count" -ne 2 ]; then
    echo "This script is designed to work with exactly two audio outputs."
    exit 1
fi

# Get the current default sink
current_sink=$(pactl info | grep 'Default Sink' | awk '{print $3}')

# Determine the next sink
if [[ "$current_sink" == "${sinks[0]}" ]]; then
    next_sink="${sinks[1]}"
else
    next_sink="${sinks[0]}"
fi

# Set the new default sink
pactl set-default-sink "$next_sink"

# Move any currently playing streams to the new default sink
for sink_input in $(pactl list sink-inputs | grep 'Sink Input #' | cut -d'#' -f2); do
    pactl move-sink-input "$sink_input" "$next_sink"
done

