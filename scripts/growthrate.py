#   ____                   _   _       ____       _       
#  / ___|_ __ _____      _| |_| |__   |  _ \ __ _| |_ ___ 
# | |  _| '__/ _ \ \ /\ / / __| '_ \  | |_) / _` | __/ _ \
# | |_| | | | (_) \ V  V /| |_| | | | |  _ < (_| | ||  __/
#  \____|_|  \___/ \_/\_/  \__|_| |_| |_| \_\__,_|\__\___|
# 
# by Stephan Raabe (2023)
# ---------------------------------------------------------------
# DESC: Python script to calculate the growth rate of two numbers
# ---------------------------------------------------------------

import rich
from rich.console import Console
from rich.prompt import FloatPrompt

console = Console()
num1 = FloatPrompt.ask("Enter start value")
num2 = FloatPrompt.ask("Enter end value")

# printing the sum in float
gr = ((num2-num1)/num1)
percentage = "{:.2%}".format(gr)
console.print(percentage, style="bold")
