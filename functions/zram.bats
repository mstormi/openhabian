#!/usr/bin/env bats 

check_zram_mounts() {
  local FILE=/etc/ztab
  local i=0
  while read -r line; do
    case "$line" in
      "#"*) continue ;;
      "")   continue ;;
      *)    set -- $line
            TYPE=$1
            if [ "${TYPE}" == "swap" ]; then
              if [ -z "`/sbin/swapon | /bin/grep zram`" ]; then
                echo "`basename $0` error: swap not on zram"
                return 1
              fi
            else
              OVERLAY=$5
              LOWER=$6
              MOUNT=`zramctl "/dev/zram${i}" | awk '/zram/ { print $NF }'`
              if [ "`df ${OVERLAY} | awk '/overlay/ { print $1 }'`" != "overlay${i}" ]; then
                echo "`basename $0` error: overlay${i} not found"
                return 1
              fi
            fi
            let i=$i+1
            ;;
    esac
  done < "$FILE"
  echo "ZRAM testing successful"
}


@test "installation-zram" {
  run check_zram_mounts
  [ "$status" -eq 0 ]
  [[ $output == *"success"* ]]
}
