#!/usr/bin/env python3

# Based on the original from the other repo, Extended to include colour names.

import numpy as np
import imageio
from zlib import compress

# Operate in the script's location
import os

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

#palette = Image.new("RGB", (16, 16))

palette_raw = np.zeros((256,3))

modifiers = np.array([
	(0.25, 0.00),
	(0.50, 0.00),
	(0.75, 0.00),
	(1.00, 0.00),
	(0.75, 0.25),
	(0.50, 0.50),
	(0.25, 0.75),
	(0.25, 0.50),
	(0.25, 0.25),
	(0.50, 0.25),
])

hues = np.array([
	(1.00, 0.00, 0.00),
	(1.00, 0.25, 0.00),
	(1.00, 0.50, 0.00),
	(1.00, 0.75, 0.00),
	(1.00, 1.00, 0.00),
	(0.75, 1.00, 0.00),
	(0.50, 1.00, 0.00),
	(0.25, 1.00, 0.00),
	(0.00, 1.00, 0.00),
	(0.00, 1.00, 0.25),
	(0.00, 1.00, 0.50),
	(0.00, 1.00, 0.75),
	(0.00, 1.00, 1.00),
	(0.00, 0.75, 1.00),
	(0.00, 0.50, 1.00),
	(0.00, 0.25, 1.00),
	(0.00, 0.00, 1.00),
	(0.25, 0.00, 1.00),
	(0.50, 0.00, 1.00),
	(0.75, 0.00, 1.00),
	(1.00, 0.00, 1.00),
	(1.00, 0.00, 0.75),
	(1.00, 0.00, 0.50),
	(1.00, 0.00, 0.25),
])

# the arrays are as follows:
# One for each of the dominant hues in the hues array
# and then an extended one for the modifiers
hue_names = [
	"Red",
	"Red",
	"Orange",
	"Yellow",
	"Yellow",
	"Green",
	"Lime",
	"Green",
	"Green",
	"Green",
	"Cyan", # Or turqoise?
	"Cyan",
	"Blue",
	"Blue", # a lovely blue, at that
	"Blue",
	"Blue",
	"Blue",
	"Blue", # Debateable
	"Purple",
	"Purple",
	"Magenta",
	"Pink",
	"Pink",
	"Pink",
]
modifier_names = [
	"Desaturated ",
	"Light ",
	"",
	"Vibrant ",
	"Weak ",
	"Hint of ",
	"Dull ",
	"Dark ",
	"",
	"",
]

names = []

i = 0
for ihue in range(len(hues)):
	hue = hues[ihue]
	for iso in range(len(modifiers)):
		sat, off = modifiers[iso]
		palette_raw[i] = hue * sat + off
		i += 1

		name = modifier_names[iso] + hue_names[ihue]
		names.append(name)

for g in range(16):
	palette_raw[i] = g / 15
	i += 1

palette = (palette_raw * 255 + 0.5).astype(np.uint8)
print(palette)

imageio.imwrite("palette.png", palette.reshape(16,16,3))

color_list = open("colors.dat", "wb")
color_list.write(compress(bytes(palette)))
color_list.close()

names_list = open("names.txt", "w") # not much point in compressing it
names_list.write("\n".join(names))
names_list.close()