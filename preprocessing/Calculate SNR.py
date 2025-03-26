import numpy as np
from osgeo import gdal

def calculate_snr(image_array):
    # Calculate the mean signal
    signal_mean = np.mean(image_array)

    # Calculate the standard deviation (noise)
    noise_std = np.std(image_array)

    # Calculate the SNR
    snr = 20 * np.log10(signal_mean / noise_std)

    return snr

def load_image_as_array(image_path):
    dataset = gdal.Open(image_path, gdal.GA_ReadOnly)
    if dataset is None:
        raise Exception(f"Could not open {image_path}")

    band = dataset.GetRasterBand(1)  # Assuming a single-band (grayscale) image
    image_array = band.ReadAsArray()

    return image_array

# Load the original image as a NumPy array using GDAL

# Load the denoised image as a NumPy array using GDAL
original_image_path4 = '../selenorefrenced_images/ch2_ohr_ncp_20211222T2023166276_d_img_d32_final.tif'
denoised_image_array4 = load_image_as_array(original_image_path4)

snr_denoised4 = calculate_snr(denoised_image_array4)
print(f"SNR of the clahe_enhanced_image_wavelet_3.tif: {snr_denoised4:.2f} dB")
