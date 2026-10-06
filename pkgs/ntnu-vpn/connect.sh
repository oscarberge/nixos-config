GATEWAY="vpn.ntnu.no"

# Re-run as root if needed
if [ "$(id -u)" -ne 0 ]; then
  exec sudo "$(readlink -f "$0")" "$@"
fi

exec openconnect \
  --useragent="AnyConnect Linux" \
  --external-browser="$OPEN_URL" \
  "$GATEWAY" "$@"
