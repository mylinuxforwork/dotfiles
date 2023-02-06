#!/bin/bash

virsh --connect qemu:///system start RDPWindows
virt-viewer --connect qemu:///system RDPWindows &

