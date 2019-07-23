init_zram_mounts() {
  if [ "$1" == "install" ]; then
    local ZRAMGIT=https://github.com/StuartIanNaylor/zram-config
    local BRANCH=sysv-init
    TMP="$(mktemp -d /tmp/.XXXXXXXXXX)"

    /usr/bin/git clone -b ${BRANCH} ${ZRAMGIT} ${TMP}
    cd ${TMP}
    /bin/sh ./install.sh
    /usr/bin/install -m 644 ${BASEDIR:=/opt/openhabian}/includes/ztab /etc/ztab
    service zram-config start
    rm -rf "$TMP"
  else
    service zram-config stop
    /usr/local/share/zram-config/uninstall.sh
    rm -f /etc/ztab
  fi
}


