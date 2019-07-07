check_zram_mounts() {
  local FILE=/etc/ztab
  local i=0

  if ! [ -f ${FILE} ]; then
    echo "ZRAM not installed - test successful."
    return 0
  fi

  while read -r line; do
    case "$line" in
      "#"*) continue ;;
      "")   continue ;;
      *)    set -- $line
            TYPE=$1
            if [ "${TYPE}" == "swap" ]; then
		    if [ -z "$(/sbin/swapon | /bin/grep zram)" ]; then
                echo "$(basename $0) error: swap not on zram"
                return 1
              fi
            else
              OVERLAY=$5
              if [ "$(df ${OVERLAY} | awk '/overlay/ { print $1 }')" != "overlay${i}" ]; then
                echo "$(basename $0) error: overlay${i} not found"
                return 1
              fi
            fi
            let i=$i+1
            ;;
    esac
  done < "$FILE"
  echo "ZRAM successfully installed."

  return 0
}

