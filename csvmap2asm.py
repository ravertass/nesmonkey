#!/usr/bin/env python3


"""Convert Tiled CSV map to ASM file."""


import csv
import sys


def _read_csv(csv_path):
    with open(csv_path, "r") as csv_file:
        return list(csv.reader(csv_file))


def _hex(num):
    hexed = str(hex(num))[2:]
    if len(hexed) == 1:
        hexed = f"0{hexed}"
    return hexed


def _asm_entry(entry):
    return f"${_hex(entry)}"


def _asm_output_row(entries):
    output = "    .db "
    output += ", ".join([_asm_entry(int(entry)) for entry in entries])
    output += "\n"
    return output


def _asm_row(row):
    output = ""

    halfway_point = len(row) // 2
    first_half = row[:halfway_point]
    second_half = row[halfway_point:]

    output += _asm_output_row(first_half)
    output += _asm_output_row(second_half)
    output += "\n"

    return output


def _asm_content(content):
    output = ""
    for row in content:
        output += _asm_row(row)
    return output


def _asm_header():
    return """;;;;;;;; Background ;;;;;;;;
;; Data for the one background can be found here.
;; This file was generated.

background:
"""


def _asm_footer():
    return """; Attributes:
    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000
    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000

    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000
    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000

    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000
    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000

    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000
    .db %00000000, %00000000, %0000000, %00000000, %00000000, %00000000, %00000000, %00000000"""


def _asm(content):
    output = _asm_header()
    output += _asm_content(content)
    output += _asm_footer()
    return output


def _main(csv_path):
    content = _read_csv(csv_path)
    print(_asm(content))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} map.csv", file=sys.stderr)
        sys.exit(1)
    _main(sys.argv[1])
