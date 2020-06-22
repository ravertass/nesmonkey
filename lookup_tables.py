#!/usr/bin/env python3


"""Generate lookup tables (e.g. boomerang velocities) for monkey.nes."""


import collections
import enum
import math
import sys


Vector = collections.namedtuple("Vector", ["x", "y"])


TEST_VECTORS = [
    Vector(0, 10),
    Vector(1, 1),
    Vector(1, 2),
    Vector(10, 10),
    Vector(10, 15),
    Vector(10, 25),
    Vector(-10, 10),
    Vector(10, -10),
    Vector(-10, -10),
    # Vector(64, 0),
    # Vector(64, 8),
    # Vector(64, 16),
    # Vector(64, 24),
    # Vector(64, 32),
    # Vector(64, 40),
    # Vector(64, 48),
    # Vector(64, 56),
    # Vector(64, 64),
    # Vector(56, 64),
    # Vector(48, 64),
    # Vector(40, 64),
    # Vector(32, 64),
    # Vector(24, 64),
    # Vector(16, 64),
    # Vector(8, 64),
    # Vector(0, 64),
]


class Octant(enum.Enum):
    RRD = 1
    RDD = 2
    LDD = 3
    LLD = 4
    LLU = 5
    LUU = 6
    RUU = 7
    RRU = 8


def _hex(num):
    hexed = str(hex(num))[2:]
    if len(hexed) == 1:
        hexed = f"0{hexed}"
    return hexed


def _is_negative(num):
    # AND #%10000000
    return num < 0


def _octant(vec):
    ax = abs(vec.x)
    ay = abs(vec.y)

    if _is_negative(vec.y):
        if _is_negative(vec.x):
            if ax > ay:
                return Octant.LLU
            else:
                return Octant.LUU
        else:
            if ax > ay:
                return Octant.RRU
            else:
                return Octant.RUU
    else:
        if _is_negative(vec.x):
            if ax > ay:
                return Octant.LLD
            else:
                return Octant.LDD
        else:
            if ax > ay:
                return Octant.RRD
            else:
                return Octant.RDD


LOWER_LIMIT = 1
UPPER_LIMIT = 6
XES = range(1, UPPER_LIMIT + 1)
XES_PLUS = range(1, UPPER_LIMIT + 2)

def _minimize(vec):
    vec = Vector(abs(vec.x), abs(vec.y))

    while vec.x > LOWER_LIMIT and vec.y > LOWER_LIMIT:
        vec = Vector(vec.x >> 1, vec.y >> 1)

    if (vec.x > UPPER_LIMIT):
        vec = Vector(1, 0)

    if (vec.y > UPPER_LIMIT):
        vec = Vector(0, 1)

    return vec


def _calc_angle(vector):
    return math.degrees(math.atan2(vector.y, vector.x))


NUM_PER_OCT = 4
DEGREES = [x * 45/NUM_PER_OCT for x in range(0, NUM_PER_OCT)]
SPEEDS = range(1, 9)


def _velocity_vector(degrees, speed):
    x = round(math.cos(math.radians(degrees)) * speed)
    y = round(math.sin(math.radians(degrees)) * speed)
    return Vector(x, y)


def _speeds_lookup_table(deg):
    lookup = {}
    for speed in SPEEDS:
        lookup[speed] = vec = _velocity_vector(deg, speed)
    return lookup


def _triangles_lookup_table():
    lookup = {}

    y = 1
    for x in XES:
        vector = Vector(x, y)
        angle = _calc_angle(vector)
        lookup[vector] = _speeds_lookup_table(angle)

    inf_vec = Vector(1, 0)
    angle = _calc_angle(inf_vec)
    lookup[Vector(7, 1)] = _speeds_lookup_table(angle)

    return lookup


def _angles_lookup_table():
    lookup = {}
    for deg in DEGREES:
        lookup[deg] = _speeds_lookup_table(deg)
    return lookup


def _set_signs(vector, octant):
    x = vector.x if octant in [Octant.RUU, Octant.RRU, Octant.RRD, Octant.RDD] else -vector.x
    y = vector.y if octant in [Octant.RRD, Octant.RDD, Octant.LDD, Octant.LLD] else -vector.x
    return Vector(x, y)


def _test_print():
    triangles_lookup = _triangles_lookup_table()
    for vector in TEST_VECTORS:
        for speed in SPEEDS:
            octant = _octant(vector)
            min_vector = _minimize(vector)
            lookup_vector = (
                min_vector
                if octant in [Octant.RRU, Octant.RRD, Octant.LLU, Octant.LLD]
                else Vector(min_vector.y, min_vector.x)
            )
            speed_lookup = triangles_lookup[lookup_vector]

            movement_vector = speed_lookup[speed]
            final_vector = _set_signs(movement_vector, octant)

            print(
                f"({vector.x}, {vector.y}), speed {speed} ->"
                f"({final_vector.x}, {final_vector.y});"
            )


def _iprint(line):
    print(f"    {line}")


def _beq_speed(x, speed):
    _iprint(f"CMP #${_hex(speed)}")
    _iprint(f"BEQ .XEq{x}SpeedEq{speed}")


def _set_velocity(x, speed):
    print(f".XEq{x}SpeedEq{speed}")
    speed_lookup_table = _triangles_lookup_table()[Vector(x, 1)]
    movement_vec = speed_lookup_table[speed]
    _iprint(f"LDX #${_hex(movement_vec.x)}")
    _iprint(f"LDY #${_hex(movement_vec.y)}")
    _iprint(f"RTS")


def _speed_table(x):
    print("")
    print(f".XEquals{x}:")
    _iprint(f"TXA")
    for speed in SPEEDS:
        _beq_speed(x, speed)
    for speed in SPEEDS:
        _set_velocity(x, speed)


def _jsr_x(x):
    _iprint(f"CMP #${_hex(x)}")
    _iprint(f"BNE .XNotEquals{x}")
    _iprint(f"JSR .XEquals{x}")
    _iprint("RTS")
    print(f".XNotEquals{x}:")


def _print_asm_header():
    print(""";;;;;;;; Game logic - Follow lookup table ;;;;;;;;
;; Generated file with subroutine for calculating the a follow movement vector.

; SUBROUTINE
; Calculates movement vector for following based on a minimized, positive difference vector.
; Input:
;     A: x in the minimized, positive difference vector.
;     X: Entity's speed.
; Output:
;     X: Positive X speed.
;     Y: Positive Y speed.""")


def _print_asm_lookup_table():
    _print_asm_header()
    print(f"FollowMovementLookup:")
    for x in XES_PLUS:
        _jsr_x(x)
    _iprint("RTS")
    for x in XES_PLUS:
        _speed_table(x)


def _print_lookup_table():
    triangles_lookup = _triangles_lookup_table()
    for vector, speed_lookup in triangles_lookup.items():
        print(f"input ({vector.x}, {vector.y})")
        print("  " +
              ", ".join(f"s{speed}: ({vec.x}; {vec.y})" for speed, vec in speed_lookup.items()))


def _main():
    # _test_print()
    # _print_lookup_table()
    _print_asm_lookup_table()


if __name__ == "__main__":
    _main()
