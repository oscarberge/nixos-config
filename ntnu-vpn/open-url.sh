WAYLAND_SOCKET="wayland-1"

url="$1"
user="${SUDO_USER:?must be run via sudo}"
uid="$(id -u "$user")"

echo "Login URL: $url" >&2

runuser -u "$user" -- env \
  XDG_RUNTIME_DIR="/run/user/$uid" \
  WAYLAND_DISPLAY="$WAYLAND_SOCKET" \
  DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
  xdg-open "$url" >/dev/null 2>&1 &
