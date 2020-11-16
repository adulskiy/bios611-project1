#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import descartes
import geopandas as gpd
from shapely.geometry import Point, Polygon


map = gpd.read_file('project3/goms/Gulf_of_Mexico_Shoreline.shp')




fig,ax = plt.subplots(figsize = (15,15))
map.plot(ax = ax)


# Load data set
df = pd.read_csv('derived_data/sg.csv')

# Get the data in the right format for geospatial stuff (CRS or Coordinate Reference System)
crs = {'init': 'epsg:4326'}
df.head()


# Rename latitude and longitude
df.rename(columns = {'latitude_mean':'latitude'}, inplace = True)
df.rename(columns = {'longitude_mean':'longitude'}, inplace = True)
df.head()


# Time to create points (single objects that describe the longitude and latitude of a data point)
geometry = [Point(xy) for xy in zip(df["longitude"], df["latitude"])]
geometry[:3]


geo_df = gpd.GeoDataFrame(df, # specify our data
                         crs = crs, # specify our coordinate reference system
                         geometry = geometry) # specify the geometry list we created
geo_df.head()


# From now on, GeoPandas will automatically reference the "geometry" column when we plot
# To plot, layer data onto the map from above

fig,ax = plt.subplots(figsize = (15,15))
map.plot(ax = ax, alpha = 0.4, color = "grey")
geo = geo_df.plot(ax = ax, c = df.category, cmap = 'Reds', alpha = 0.9, 
            markersize = 70, edgecolor = 'k', label = "Category")

# Save figure
plt.savefig('stormmap.png')

# Convert to .py
import os
os.system("jupyter nbconvert project3.ipynb --to .py")





