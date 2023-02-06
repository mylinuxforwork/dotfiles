#!/bin/bash
read -p 'Start Value: ' startval
read -p 'End Value: ' endval
let growthrate=(($endval-$startval)/$startval)
echo $growthrate

