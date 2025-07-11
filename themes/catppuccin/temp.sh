download_background_image() {
  local url="$1"
  curl -sL -o "background_01.png" "$url"
}
