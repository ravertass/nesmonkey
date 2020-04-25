#!/usr/bin/env python3


"""Generate lookup tables (e.g. boomerang velocities) for monkey.nes."""


import collections
import enum
import math
import sys


Vector = collections.namedtuple("Vector", ["x", "y"])


TEST_VECTORS = [
    Vector(64, 0),
    Vector(64, 8),
    Vector(64, 16),
    Vector(64, 24),
    Vector(64, 32),
    Vector(64, 40),
    Vector(64, 48),
    Vector(64, 56),
    Vector(64, 64),
    Vector(56, 64),
    Vector(48, 64),
    Vector(40, 64),
    Vector(32, 64),
    Vector(24, 64),
    Vector(16, 64),
    Vector(8, 64),
    Vector(0, 64),
    # Vector(-10, 10),
    # Vector(10, -10),
    # Vector(-10, -10),
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
                return Octant.LDu
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


LIMIT = 1

def _minimize(vec):
    vec = Vector(abs(vec.x), abs(vec.y))

    while vec.x > LIMIT and vec.y > LIMIT:
        vec = Vector(vec.x >> 1, vec.y >> 1)

    return vec


NUM_PER_OCT = 4
DEGREES = [x * 45/NUM_PER_OCT for x in range(0, NUM_PER_OCT)]
SPEEDS = [1, 2, 3, 4, 5, 6, 7, 8]


def _velocity_vector(degrees, speed):
    x = round(math.cos(math.radians(degrees)) * speed)
    y = round(math.sin(math.radians(degrees)) * speed)
    return Vector(x, y)


def _speeds_lookup_table(deg):
    lookup = {}
    for speed in SPEEDS:
        lookup[speed] = vec = _velocity_vector(deg, speed)
    return lookup


def _angles_lookup_table():
    lookup = {}
    for deg in DEGREES:
        lookup[deg] = _speeds_lookup_table(deg)
    return lookup


def _main():
    for vector in TEST_VECTORS:
        octant = _octant(vector)
        min_vector = _minimize(vector)
        angle = math.degrees(math.atan2(vector.x, vector.y))
        print(f"{vector} -> {octant}; {min_vector}; {angle:.2f}")

    print()
    lookup = _angles_lookup_table()
    for angle, speed_lookup in lookup.items():
        print(f"angle {angle}")
        print("  " +
              ", ".join(f"s{speed}: ({vec.x}; {vec.y})" for speed, vec in speed_lookup.items()))

    print()
    for deg in DEGREES:
        x = round((1 / math.tan(math.radians(deg)) if deg != 0 else 128) * LIMIT)
        y = (1 if deg != 0 else 0) * LIMIT
        print(f"deg: {deg:.2f}; x: {x}; y: {y}")


if __name__ == "__main__":
    _main()
