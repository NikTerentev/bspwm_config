if type "xrandr"; then
    monitor=$(xrandr --query | grep " primary" | cut -d" " -f1)
    MONITOR=$monitor polybar --reload example &
else
    polybar --reload example &
fi
