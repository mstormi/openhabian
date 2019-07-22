init_zram_mounts() {
  if [ "$1" == "install" ]; then
    # stop old installations
    cond_redirect systemctl stop zram-config.service
    
    local ZRAMGIT=https://github.com/StuartIanNaylor/zram-config
    TMP="$(mktemp -d /tmp/.XXXXXXXXXX)"

    /usr/bin/git clone ${ZRAMGIT} ${TMP}
    cd ${TMP}
    /bin/sh ./install.sh
    /usr/bin/install -m 644 ${BASEDIR}/includes/ztab /etc/ztab
    cond_redirect systemctl start zram-config.service
    rm -rf "$TMP"
  else
    cond_redirect systemctl stop zram-config.service
    /usr/local/share/zram-config/uninstall.sh
    rm -f /etc/ztab
  fi
}