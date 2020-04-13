#!/usr/bin/env python2

from __future__ import print_function

import collections
import sys

def main(asm_path):
    symbols = {}
    with open(asm_path, "r") as asm_file:
        reading_ram = False
        counter = -1
        for line in asm_file:
            if "RAM start" in line:
                reading_ram = True
            if "RAM end" in line:
                break
            if not reading_ram:
                continue

            if ".zp" in line:
                counter = 0x00
            if ".bss" in line:
                counter = 0x200
            if ".org" in line:
                counter = int(line.strip().split(" ")[1][1:], 16)

            if not line.strip() or line[0] == ";" or line[0] == " ":
                continue

            name = line.split()[0]
            address_str = "$" + "{0:#06x}".format(counter)[2:].upper()

            if not symbols.has_key(address_str):
                symbols[address_str] = []
            symbols[address_str].append(name)

            usage_str = line.split()[2]
            if "entitySize" in usage_str:
                usage_str = usage_str.replace("entitySize", str(0x13))  # Super hacky...
                usage = eval(usage_str)
            elif usage_str[0] == "$":
                usage = int(usage_str[1:], 16)
            else:
                usage = int(usage_str)

            counter += usage

    for address, name_list in symbols.iteritems():
        all_names = ", ".join(name_list)

        print("{0}#{1}#{2}".format(address, name_list[0], all_names))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: {0} file.asm".format(sys.argv[0]), file=sys.stdout)
        sys.exit(1)
    main(sys.argv[1])
