init_zram_mounts() {
  if [ "$1" == "install" ]; then
    local ZRAMGIT=https://github.com/StuartIanNaylor/zram-config
    TMP="$(mktemp -d /tmp/.XXXXXXXXXX)"

    /usr/bin/git clone ${ZRAMGIT} ${TMP}
    cd ${TMP}
    /bin/sh ./install.sh
    /usr/bin/install -m 644 ${BASEDIR}/includes/ztab /etc/ztab
    service zram-config start
    rm -rf "$TMP"
  else
    service zram-config stop
    /usr/local/share/zram-config/uninstall.sh
    rm -f /etc/ztab
  fi
}

Xcheck_zram_mounts() {
  local FILE=/etc/ztab
  local i=0

  if ! [ -f ${FILE} ]; then
    echo "ZRAM not installed - test successful."
    return 0
  fi

  while read -r line; do
    case "${line}" in
      "#"*) continue ;;
      "")   continue ;;
      *)    set -- $\{line\}
            TYPE=$1
            if [ "${TYPE}" == "swap" ]; then
	      if $\(/sbin/swapon | /bin/grep -q zram\); then
                echo "$(basename "$0") error: swap not on zram"
                return 1
              fi
            else
              if [ "$(df $5 | awk '/overlay/ { print $1 }')" != "overlay${i}" ]; then
                echo "$(basename "$0") error: overlay${i} not found"
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

