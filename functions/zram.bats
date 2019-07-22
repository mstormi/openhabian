#!/usr/bin/env bats 

load helpers
load zram

@test "destructive-zram_install" {
  run init_zram_mounts install
  [ "$status" -eq 0 ]
}

@test "destructive-zram_mounts" {
  if running_in_docker; then 
    skip "Running in Docker, can not test"
  fi
  # Need to checked after reboot
  # TODO: zramctl -> check if devices listed in ztab exist.
  run systemctl is-active --quiet zram-config.service
  [ "$status" -eq 0 ]
}