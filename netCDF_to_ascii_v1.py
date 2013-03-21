# ---------------------------------------------------------------------------
# netCDF_to_ascii_v1.py
# Created on: 2012-06-05 15:17:26.00000
#   (generated by ArcGIS/ModelBuilder)
# Description: 
# ---------------------------------------------------------------------------

# Import arcpy module
import arcpy


# Local variables:
wna30sec_1961-1990_biomes_DRAFT_v1_nc = "C:\\Users\\cbwilsey\\Documents\\PostDoc\\VegProjections\\wna30sec_1961-1990_biomes_DRAFT_v1.nc"
biome = "biome"
biome_albers = "C:\\Users\\cbwilsey\\Documents\\PostDoc\\ArcGISworkspace\\biome_albers"
biome_albers_TXT = "C:\\Users\\cbwilsey\\Documents\\PostDoc\\ArcGISworkspace\\biome_albers.TXT"

# Process: Make NetCDF Raster Layer
arcpy.MakeNetCDFRasterLayer_md(wna30sec_1961-1990_biomes_DRAFT_v1_nc, "biome", "lon", "lat", biome, "", "", "BY_VALUE")

# Process: Project Raster
arcpy.ProjectRaster_management(biome, biome_albers, "PROJCS['USA_Contiguous_Albers_Equal_Area_Conic_USGS_version',GEOGCS['GCS_North_American_1983',DATUM['D_North_American_1983',SPHEROID['GRS_1980',6378137.0,298.257222101]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Albers'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',-96.0],PARAMETER['Standard_Parallel_1',29.5],PARAMETER['Standard_Parallel_2',45.5],PARAMETER['Latitude_Of_Origin',23.0],UNIT['Meter',1.0]]", "NEAREST", "", "", "", "")

# Process: Raster to ASCII
arcpy.RasterToASCII_conversion(biome_albers, biome_albers_TXT)

