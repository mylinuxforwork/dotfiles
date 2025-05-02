#!/usr/bin/env python
import sys
import os
import pathlib
import subprocess

homeFolder = os.path.expanduser('~')
myFile = homeFolder + "/.config/ohmyposh/EDM115-newline.omp.json"
with open(myFile, 'r+') as f:
    content = f.read().replace('{[', '{{')
    f.seek(0)
    f.write(content)
    f.truncate()

with open(myFile, 'r+') as f:
    content = f.read().replace(']}', '}}')
    f.seek(0)
    f.write(content)
    f.truncate()

# subprocess.run(homeFolder + '/.config/matugen/scripts/kitty.sh')