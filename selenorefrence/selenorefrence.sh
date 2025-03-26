#!/bin/bash

# Paths
INPUT_IMAGE="../clahe_enhanced_image1.tif"
TEMP_IMAGE="ch2_ohr_ncp_20211222T2023166276_d_img_d32_temp.tif"
MODIFIED_IMAGE="ch2_ohr_ncp_20211222T2023166276_d_img_d32_modified.tif"
FINAL_IMAGE="ch2_ohr_ncp_20211222T2023166276_d_img_d32_final.tif"
PYTHON_SCRIPT="extract.py"

# Run the Python script to extract values
output=$(python3 "$PYTHON_SCRIPT")

# Extract values from Python script output
IMAGE_WIDTH=$(echo "$output" | grep "Width:" | sed 's/Width://')
IMAGE_HEIGHT=$(echo "$output" | grep "Height:" | sed 's/Height://')
UPPER_LEFT_LAT=$(echo "$output" | grep "Upper Left Latitude:" | sed 's/Upper Left Latitude://')
UPPER_LEFT_LON=$(echo "$output" | grep "Upper Left Longitude:" | sed 's/Upper Left Longitude://')
UPPER_RIGHT_LAT=$(echo "$output" | grep "Upper Right Latitude:" | sed 's/Upper Right Latitude://')
UPPER_RIGHT_LON=$(echo "$output" | grep "Upper Right Longitude:" | sed 's/Upper Right Longitude://')
LOWER_LEFT_LAT=$(echo "$output" | grep "Lower Left Latitude:" | sed 's/Lower Left Latitude://')
LOWER_LEFT_LON=$(echo "$output" | grep "Lower Left Longitude:" | sed 's/Lower Left Longitude://')
LOWER_RIGHT_LAT=$(echo "$output" | grep "Lower Right Latitude:" | sed 's/Lower Right Latitude://')
LOWER_RIGHT_LON=$(echo "$output" | grep "Lower Right Longitude:" | sed 's/Lower Right Longitude://')

# Convert the latitude and longitude to GCP format
GCP1="0 0 $UPPER_LEFT_LON $UPPER_LEFT_LAT"  # Upper-left corner
GCP2="$IMAGE_WIDTH 0 $UPPER_RIGHT_LON $UPPER_RIGHT_LAT"  # Upper-right corner
GCP3="0 $IMAGE_HEIGHT $LOWER_LEFT_LON $LOWER_LEFT_LAT"  # Lower-left corner
GCP4="$IMAGE_WIDTH $IMAGE_HEIGHT $LOWER_RIGHT_LON $LOWER_RIGHT_LAT"  # Lower-right corner

# Step 1: Use gdal_translate to apply the GCPs to the image
gdal_translate -of GTiff -gcp $GCP1 -gcp $GCP2 -gcp $GCP3 -gcp $GCP4 "$INPUT_IMAGE" "$TEMP_IMAGE"

# Step 2: Use gdalwarp to transform the image with cubic resampling and TPS (Thin Plate Spline)
gdalwarp -t_srs ESRI:104903 -r cubic -tps -co COMPRESS=NONE "$TEMP_IMAGE" "$MODIFIED_IMAGE"

# Step 3: Reproject the image using gdalwarp to a stereographic projection
gdalwarp -overwrite -s_srs ESRI:104903 -t_srs ESRI:103878 -dstnodata 0 -of GTiff "$MODIFIED_IMAGE" "$FINAL_IMAGE"

echo "Processing complete. Final image saved as $FINAL_IMAGE."

