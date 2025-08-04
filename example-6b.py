import os
import matplotlib.pyplot as plt
from netCDF4 import Dataset as netcdf_dataset
import numpy as np
from cartopy import config
import cartopy.crs as ccrs

# https://www.metoffice.gov.uk/hadobs/hadisst/data/download.html
dataset = netcdf_dataset('HadISST1_SST_update.nc')
sst = dataset.variables['sst'][0, :, :]
sst[sst == -1000] = np.nan
lats = dataset.variables['latitude'][:]
lons = dataset.variables['longitude'][:]

plt.figure(num=None, figsize=(8, 6))

ax = plt.axes(projection=ccrs.PlateCarree())

cm = plt.contourf(lons, lats, sst, 60, transform=ccrs.PlateCarree(), cmap=plt.cm.jet)

ax.coastlines()

cbar = plt.colorbar(orientation='horizontal')
cbar.ax.set_xlabel('Sea Surface Temperature [C]')

cs = plt.contour(lons, lats, sst, [22], linewidths=0.5, transform=ccrs.PlateCarree())
ax.clabel(cs, fontsize=9, inline=1, fmt='%.1f')

plt.title("Sea Surface Temperature (November 2019)")

# save the plot
plt.tight_layout()
plt.savefig('example-6b.png', dpi=150)
