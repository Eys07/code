#!/bin/bash

# Simple script to generate PWA icons from SVG
# You can run this manually if you have ImageMagick installed

SIZES=(72 96 128 144 152 192 384 512)

for size in "${SIZES[@]}"; do
  if command -v convert &> /dev/null; then
    convert -background none -resize ${size}x${size} icons/icon.svg icons/icon-${size}x${size}.png
    echo "Generated icon-${size}x${size}.png"
  else
    # Create a placeholder HTML file that can be used to generate icons
    echo "ImageMagick not found. Please install it or use an online SVG to PNG converter."
    exit 1
  fi
done

echo "All icons generated successfully!"
