import sys
# run command in modelsim such as test, compile, simulate and so on
import os
from os import system as S

keys = {}
keys["compile"] = "vlog "
# keys["test"] = " "
# keys["simulate"] = " "

if __name__ == "__main__":
  if len(sys.argv) == 1:
    cmd = input("here are the available commands, choose one to key in:\n\ncompile: vlog\n\ntest:\n\nsimulate:\n\n").lower()
    filename = input("\ninput the filename as well:\n")
    ins = keys[cmd] + filename
  else:
    # command + filename
    ins = keys[sys.argv[1].lower()] + sys.argv[2]

  print("execute: %s" % (ins) ,end="\n\n")

  S(ins)


