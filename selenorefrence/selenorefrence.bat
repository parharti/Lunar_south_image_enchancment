@echo off
setlocal enabledelayedexpansion

REM Paths
set INPUT_IMAGE= REM add your own path
set TEMP_IMAGE=ch2_ohr_ncp_20211222T2023166276_d_img_d32_temp.tif
set MODIFIED_IMAGE=ch2_ohr_ncp_20211222T2023166276_d_img_d32_modified.tif
set FINAL_IMAGE=ch2_ohr_ncp_20211222T2023166276_d_img_d32_final.tif
set PYTHON_SCRIPT=extract.py

REM Run the Python script and output to a temporary file
python "%PYTHON_SCRIPT%" > output.txt

REM Read the output from the file
for /f "tokens=1,* delims=:" %%i in (output.txt) do (
    set "line=%%j"
    if "%%i"=="Width" set "IMAGE_WIDTH=!line!"
    if "%%i"=="Height" set "IMAGE_HEIGHT=!line!"
    if "%%i"=="Upper Left Latitude" set "UPPER_LEFT_LAT=!line!"
    if "%%i"=="Upper Left Longitude" set "UPPER_LEFT_LON=!line!"
    if "%%i"=="Upper Right Latitude" set "UPPER_RIGHT_LAT=!line!"
    if "%%i"=="Upper Right Longitude" set "UPPER_RIGHT_LON=!line!"
    if "%%i"=="Lower Left Latitude" set "LOWER_LEFT_LAT=!line!"
    if "%%i"=="Lower Left Longitude" set "LOWER_LEFT_LON=!line!"
    if "%%i"=="Lower Right Latitude" set "LOWER_RIGHT_LAT=!line!"
    if "%%i"=="Lower Right Longitude" set "LOWER_RIGHT_LON=!line!"
)

REM Debugging: Echo the extracted variables
echo IMAGE_WIDTH: %IMAGE_WIDTH%
echo IMAGE_HEIGHT: %IMAGE_HEIGHT%
echo UPPER_LEFT_LAT: %UPPER_LEFT_LAT%
echo UPPER_LEFT_LON: %UPPER_LEFT_LON%
echo UPPER_RIGHT_LAT: %UPPER_RIGHT_LAT%
echo UPPER_RIGHT_LON: %UPPER_RIGHT_LON%
echo LOWER_LEFT_LAT: %LOWER_LEFT_LAT%
echo LOWER_LEFT_LON: %LOWER_LEFT_LON%
echo LOWER_RIGHT_LAT: %LOWER_RIGHT_LAT%
echo LOWER_RIGHT_LON: %LOWER_RIGHT_LON%

REM Check for errors in the output
if "%IMAGE_WIDTH%"=="" echo ERROR: IMAGE_WIDTH is not set. & exit /b 1
if "%IMAGE_HEIGHT%"=="" echo ERROR: IMAGE_HEIGHT is not set. & exit /b 1
if "%UPPER_LEFT_LAT%"=="" echo ERROR: UPPER_LEFT_LAT is not set. & exit /b 1
if "%UPPER_LEFT_LON%"=="" echo ERROR: UPPER_LEFT_LON is not set. & exit /b 1
if "%UPPER_RIGHT_LAT%"=="" echo ERROR: UPPER_RIGHT_LAT is not set. & exit /b 1
if "%UPPER_RIGHT_LON%"=="" echo ERROR: UPPER_RIGHT_LON is not set. & exit /b 1
if "%LOWER_LEFT_LAT%"=="" echo ERROR: LOWER_LEFT_LAT is not set. & exit /b 1
if "%LOWER_LEFT_LON%"=="" echo ERROR: LOWER_LEFT_LON is not set. & exit /b 1
if "%LOWER_RIGHT_LAT%"=="" echo ERROR: LOWER_RIGHT_LAT is not set. & exit /b 1
if "%LOWER_RIGHT_LON%"=="" echo ERROR: LOWER_RIGHT_LON is not set. & exit /b 1

REM Convert the latitude and longitude to GCP format
set "GCP1=0 0 %UPPER_LEFT_LON% %UPPER_LEFT_LAT%"  REM Upper-left corner
set "GCP2=%IMAGE_WIDTH% 0 %UPPER_RIGHT_LON% %UPPER_RIGHT_LAT%"  REM Upper-right corner
set "GCP3=0 %IMAGE_HEIGHT% %LOWER_LEFT_LON% %LOWER_LEFT_LAT%"  REM Lower-left corner
set "GCP4=%IMAGE_WIDTH% %IMAGE_HEIGHT% %LOWER_RIGHT_LON% %LOWER_RIGHT_LAT%"  REM Lower-right corner

REM Debugging: Echo the GCPs
echo GCP1: %GCP1%
echo GCP2: %GCP2%
echo GCP3: %GCP3%
echo GCP4: %GCP4%

REM Step 1: Use gdal_translate to apply the GCPs to the image
gdal_translate -of GTiff -gcp %GCP1% -gcp %GCP2% -gcp %GCP3% -gcp %GCP4% "%INPUT_IMAGE%" "%TEMP_IMAGE%"

REM Check if TEMP_IMAGE was created successfully
if not exist "%TEMP_IMAGE%" (
    echo ERROR: Temporary image not created.
    exit /b 1
)

REM Step 2: Use gdalwarp to transform the image with cubic resampling and TPS (Thin Plate Spline)
gdalwarp -t_srs ESRI:104903 -r cubic -tps -co COMPRESS=NONE "%TEMP_IMAGE%" "%MODIFIED_IMAGE%"

REM Check if MODIFIED_IMAGE was created successfully
if not exist "%MODIFIED_IMAGE%" (
    echo ERROR: Modified image not created.
    exit /b 1
)

REM Step 3: Reproject the image using gdalwarp to a stereographic projection
gdalwarp -overwrite -s_srs ESRI:104903 -t_srs ESRI:103878 -dstnodata 0 -of GTiff "%MODIFIED_IMAGE%" "%FINAL_IMAGE%"

if exist "%FINAL_IMAGE%" (
    echo Processing complete. Final image saved as %FINAL_IMAGE%.
) else (
    echo ERROR: Final image not created.
    exit /b 1
)
