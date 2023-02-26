import os
import subprocess

os.chdir("/home/raabe")
# os.system("ls")

# process = subprocess.run(["ls", "-al"], stdout=subprocess.PIPE, universal_newlines=True)
process = subprocess.run(["ls", "-al"], stdout=subprocess.PIPE)
# print(process.stdout)

