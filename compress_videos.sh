#!/bin/bash

folders=(
    "static/videos/best-of-N/bad"
    "static/videos/best-of-N/good"
    "static/videos/recon/bad"
    "static/videos/recon/good"
)

for folder in "${folders[@]}"; do
    for input in "$folder"/*.mp4; do
        [ -f "$input" ] || continue  # 跳过空文件夹

        temp="${input%.mp4}_temp.mp4"
        echo "Processing: $input"

        ffmpeg -i "$input" \
            -vcodec libx264 \
            -crf 28 \
            -preset slow \
            -vf "scale=1280:-2" \
            -movflags +faststart \
            -an \
            -y "$temp"

        if [ $? -eq 0 ]; then
            mv "$temp" "$input"
            echo "✓ Done: $input"
        else
            rm -f "$temp"
            echo "✗ Failed: $input"
        fi
    done
done

echo "All done!"