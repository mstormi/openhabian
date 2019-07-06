#!/usr/bin/env bats 

load zram

@test "installation-zram" {
  run check_zram_mounts
  [ "$status" -eq 0 ]
  [[ $output == *"success"* ]]
}
