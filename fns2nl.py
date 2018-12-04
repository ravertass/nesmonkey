#!/usr/bin/env python2

from __future__ import print_function

import collections
import sys

Symbol = collections.namedtuple("Symbol", ["name", "address"])

def main(fns_path):
    symbols = []
    with open(fns_path, "r") as fns_file:
        for line in fns_file:
            if not line or line[0] == ";":
                continue
            name = line.split()[0]
            address = line.split()[2]
            symbol = Symbol(name, address)
            symbols.append(symbol)

    for symbol in symbols:
        print("{0}#{1}#{1}".format(symbol.address, symbol.name))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: {0} file.fns".format(sys.argv[0]), file=sys.stdout)
        sys.exit(1)
    main(sys.argv[1])
