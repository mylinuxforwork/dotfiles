#!/bin/bash

virsh --connect qemu:///system start win11
looking-glass-client &
exit
