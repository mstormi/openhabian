#!/usr/bin/env bats 

@test "installation-zram" {
  run check_zram_mounts
  [ "$status" -eq 0 ]
  [[ $output == *"success"* ]]
}
