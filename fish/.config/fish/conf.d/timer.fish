# https://adrian-philipp.com/post/cmd-duration-fish-shell
function get_time --on-event fish_postexec
    if test $CMD_DURATION
        # Show duration of the last command in seconds
        set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
        set_color blue
        echo_right [ $duration ]
        set_color normal
    end
end

# https://github.com/fish-shell/fish-shell/issues/1706#issuecomment-144033171
function echo_right
    set -l argstring "$argv"
    set -l columns (math $COLUMNS - (string length -- "$argstring"))
    for i in (seq 1 $columns)
        set argstring " "$argstring
    end
    echo "$argstring"
end
