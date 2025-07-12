#!/bin/bash

#
# This script downloads sequential audio segments for vocal and instrumental tracks
# from the LALAL.AI service and provides instructions to combine them.
# It accepts the media ID and the max number of segments as command-line arguments.
#

# --- Argument Validation ---
# Check if both media ID and max segments are provided.
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <media_id> <max_segments>"
    echo "Example: $0 eadbb83b-5821-4dc0-893a-d8f1dbbc27e8/e2c7de31-ef2c-4e41-ae1b-90cc35cffce0 19"
    exit 1
fi

# --- Configuration ---
MEDIA_ID=$1
MAX_SEGMENTS=$2
BASE_URL="https://d.lalal.ai/media/split/${MEDIA_ID}"

echo "Configuration:"
echo "Media ID: ${MEDIA_ID}"
echo "Segments to download: 0 to ${MAX_SEGMENTS}"
echo ""

# --- Create Directories ---
# Create separate directories to keep the downloaded segments organized.
echo "Creating directories 'vocals' and 'instrumentals'..."
mkdir -p vocals
mkdir -p instrumentals
echo "Directories created."
echo ""

# --- Download Vocal Segments ---
echo "--- Starting Vocal Track Download ---"
for i in $(seq -f "%03g" 0 ${MAX_SEGMENTS})
do
  URL="${BASE_URL}/vocals_playlist/segment-${i}.mp3"
  echo "Downloading vocal segment ${i} from ${URL}"
  # Use curl to download the file into the 'vocals' directory.
  # -s for silent mode, -S to show errors, -o to specify output file.
  curl -s -S -o "vocals/segment-${i}.mp3" "$URL"
done
echo "--- Vocal track download complete. ---"
echo ""


# --- Download Instrumental Segments ---
echo "--- Starting Instrumental Track Download ---"
for i in $(seq -f "%03g" 0 ${MAX_SEGMENTS})
do
  URL="${BASE_URL}/no_vocals_playlist/segment-${i}.mp3"
  echo "Downloading instrumental segment ${i} from ${URL}"
  # Use curl to download the file into the 'instrumentals' directory.
  curl -s -S -o "instrumentals/segment-${i}.mp3" "$URL"
done
echo "--- Instrumental track download complete. ---"
echo ""


# --- Combine Files ---
echo "--- All segments downloaded. ---"
echo "To combine the segments into single audio files, run the following commands:"
echo ""
echo "For the vocal track:"
echo "cat vocals/segment-*.mp3 > full_vocals.mp3"
echo ""
echo "For the instrumental track:"
echo "cat instrumentals/segment-*.mp3 > full_instrumentals.mp3"
echo ""
echo "Script finished."
