
# extract_values.py

from lxml import etree

# Path to the XML file
XML_FILE = "../dataset/data/calibrated/20211222/ch2_ohr_ncp_20211222T2023166276_d_img_d32.xml"

# Define namespaces
namespaces = {
    'ns': 'http://pds.nasa.gov/pds4/pds/v1',
    'isda': 'https://isda.issdc.gov.in/pds4/isda/v1'
}

# Parse the XML file
tree = etree.parse(XML_FILE)

# Extract width and height
width = tree.xpath("//ns:Product_Observational//ns:File_Area_Observational//ns:Array_2D_Image//ns:Axis_Array[ns:axis_name='Sample']//ns:elements/text()", namespaces=namespaces)
height = tree.xpath("//ns:Product_Observational//ns:File_Area_Observational//ns:Array_2D_Image//ns:Axis_Array[ns:axis_name='Line']//ns:elements/text()", namespaces=namespaces)

# Extract GCP points (latitude, longitude)
upper_left_lat = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:Refined_Corner_Coordinates//isda:upper_left_latitude/text()", namespaces=namespaces)
upper_left_lon = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:Refined_Corner_Coordinates//isda:upper_left_longitude/text()", namespaces=namespaces)
upper_right_lat = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:upper_right_latitude/text()", namespaces=namespaces)
upper_right_lon = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:upper_right_longitude/text()", namespaces=namespaces)
lower_left_lat = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:lower_left_latitude/text()", namespaces=namespaces)
lower_left_lon = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:lower_left_longitude/text()", namespaces=namespaces)
lower_right_lat = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:lower_right_latitude/text()", namespaces=namespaces)
lower_right_lon = tree.xpath("//ns:Product_Observational//ns:Observation_Area//ns:Mission_Area//isda:Geometry_Parameters//isda:lower_right_longitude/text()", namespaces=namespaces)

# Print extracted values
print(f"Width:{width[0] if width else 'Not found'}")
print(f"Height:{height[0] if height else 'Not found'}")
print(f"Upper Left Latitude:{upper_left_lat[0] if upper_left_lat else 'Not found'}")
print(f"Upper Left Longitude:{upper_left_lon[0] if upper_left_lon else 'Not found'}")
print(f"Upper Right Latitude:{upper_right_lat[0] if upper_right_lat else 'Not found'}")
print(f"Upper Right Longitude:{upper_right_lon[0] if upper_right_lon else 'Not found'}")
print(f"Lower Left Latitude:{lower_left_lat[0] if lower_left_lat else 'Not found'}")
print(f"Lower Left Longitude:{lower_left_lon[0] if lower_left_lon else 'Not found'}")
print(f"Lower Right Latitude:{lower_right_lat[0] if lower_right_lat else 'Not found'}")
print(f"Lower Right Longitude:{lower_right_lon[0] if lower_right_lon else 'Not found'}")

