from PIL import Image
import numpy as np
import cv2
from skimage.restoration import denoise_wavelet
from skimage.exposure import rescale_intensity
from osgeo import gdal

# Increase the maximum allowed image pixels to handle large images
Image.MAX_IMAGE_PIXELS = None

# Load the TIFF image using PIL without loading it into memory
image_path = '../dataset/ch2_ohr_ncp_20211222T2023166276_d_img_d32.tif'
output_path = 'clahe_enhanced_image_wavelet_4.tif'

# Open the source dataset using GDAL to extract projection (if needed)
src_dataset = gdal.Open(image_path)

# Load the image using PIL
image = Image.open(image_path)

# Convert image to grayscale
image = image.convert('L')

# Get image dimensions
width, height = image.size

# Define chunk size (adjust based on available memory)
chunk_size = 1024  # This value can be modified as needed

# Step 1: Logarithmic Transformation (to enhance image contrast and reduce noise)
def logarithmic_transform(image_chunk):
    # Add a small value to avoid log(0)
    image_chunk = np.clip(image_chunk, 1, None)
    c = 255 / np.log(1 + np.max(image_chunk))
    return c * np.log(1 + image_chunk.astype(np.float64))

# Create an empty array for the final image
final_image = np.zeros((height, width), dtype=np.float32)

# Process the image in chunks
for y in range(0, height, chunk_size):
    for x in range(0, width, chunk_size):
        # Define the box for the current chunk
        box = (x, y, min(x + chunk_size, width), min(y + chunk_size, height))
        # Load the chunk
        chunk = np.array(image.crop(box))

        # Step 1: Apply Logarithmic transform
        log_transformed_chunk = logarithmic_transform(chunk)

        # Step 2: Apply Gaussian filter to reduce high-frequency noise
        gaussian_filtered_chunk = cv2.GaussianBlur(log_transformed_chunk, (1,1), 0)

        # Step 3: Apply Wavelet Denoising to further remove noise
        wavelet_denoised_chunk = denoise_wavelet(
            gaussian_filtered_chunk,
            mode='soft',
            wavelet_levels=3,
            method='BayesShrink',
            rescale_sigma=True
        )

        # Step 4: Handle potential NaN values
        wavelet_denoised_chunk = np.nan_to_num(wavelet_denoised_chunk)

        # Rescale the image intensity to [0, 255]
        final_chunk_rescaled = rescale_intensity(
            wavelet_denoised_chunk,
            in_range=(np.nanmin(wavelet_denoised_chunk), np.nanmax(wavelet_denoised_chunk)),
            out_range=(0, 255)
        ).astype(np.uint8)

        # Place the processed chunk back into the final image array
        final_image[y:y + final_chunk_rescaled.shape[0], x:x + final_chunk_rescaled.shape[1]] = final_chunk_rescaled

# Apply CLAHE on the final processed image
clahe = cv2.createCLAHE(clipLimit=1.0, tileGridSize=(5, 5))
clahe_applied_image = clahe.apply(final_image.astype(np.uint8))

# Save the CLAHE enhanced image using GDAL
driver = gdal.GetDriverByName("GTiff")
output_image_ds = driver.Create(
    output_path,
    width,
    height,
    1,
    gdal.GDT_Byte,
    options=['BIGTIFF=YES']
)
output_image_ds.GetRasterBand(1).WriteArray(clahe_applied_image)

# Set the projection from the source dataset if needed
projection = src_dataset.GetProjection()
if projection:
    output_image_ds.SetProjection(projection)

# Flush cache and close the dataset
output_image_ds.FlushCache()
output_image_ds = None

print(f"CLAHE enhanced image saved to {output_path}")

