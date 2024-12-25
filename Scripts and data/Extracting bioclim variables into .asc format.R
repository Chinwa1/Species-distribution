###download weather data from worldclim 

###load the followinglibraries
library(rgeos)
library(rgdal)
library(sp)
library(raster)

################Effective method############
r=stack("C:/Users/hchin/Documents30sec\wc2.1_30s_bio")
nlayers(r)
for (i in 1:nlayers(r))
{
  BIO=r[[i]]
  writeRaster(BIO,paste("BIO",i,".tif",sep=""))
}

############################Transform the shapefile into aci 
###load the raster file in tif format
BIO1a <- raster("wc2.1_30s_bio_1.tif")
BIO2 <- raster("wc2.1_30s_bio_2.tif")
BIO3 <- raster("wc2.1_30s_bio_3.tif")
BIO4 <- raster("wc2.1_30s_bio_4.tif")
BIO5 <- raster("wc2.1_30s_bio_5.tif")
BIO6 <- raster("wc2.1_30s_bio_6.tif")
BIO7 <- raster("wc2.1_30s_bio_7.tif")
BIO8 <- raster("wc2.1_30s_bio_8.tif")
BIO9 <- raster("wc2.1_30s_bio_9.tif")
BIO10 <- raster("wc2.1_30s_bio_10.tif")
BIO11 <- raster("wc2.1_30s_bio_11.tif")
BIO12 <- raster("wc2.1_30s_bio_12.tif")
BIO13 <- raster("wc2.1_30s_bio_13.tif")
BIO14 <- raster("wc2.1_30s_bio_14.tif")
BIO15 <- raster("wc2.1_30s_bio_15.tif")
BIO16 <- raster("wc2.1_30s_bio_16.tif")
BIO17 <- raster("wc2.1_30s_bio_17.tif")
BIO18 <- raster("wc2.1_30s_bio_18.tif")
BIO19 <- raster("wc2.1_30s_bio_19.tif")

elevation=raster("wc2.1_30s_elev.tif")
#######Change the .tif format to asci
BIO1a <- writeRaster(BIO1a,"BIO1a.asc")
BIO2 <- writeRaster(BIO2,"BIO2.asc")
BIO3 <- writeRaster(BIO3,"BIO3.asc")
BIO4 <- writeRaster(BIO4,"BIO4.asc")
BIO5 <- writeRaster(BIO5,"BIO5.asc")
BIO6 <- writeRaster(BIO6,"BIO6.asc")
BIO7 <- writeRaster(BIO7,"BIO7.asc")
BIO8 <- writeRaster(BIO8,"BIO8.asc")
BIO9 <- writeRaster(BIO9,"BIO9.asc")
BIO10 <- writeRaster(BIO10,"BIO10.asc")
BIO11 <- writeRaster(BIO11,"BIO11.asc")
BIO12 <- writeRaster(BIO12,"BIO12.asc")
BIO13 <- writeRaster(BIO13,"BIO13.asc")
BIO14 <- writeRaster(BIO14,"BIO14.asc")
BIO15 <- writeRaster(BIO15,"BIO15.asc")
BIO16 <- writeRaster(BIO16,"BIO16.asc")
BIO17 <- writeRaster(BIO17,"BIO17.asc")
BIO18 <- writeRaster(BIO18,"BIO18.asc")
BIO19 <-writeRaster(BIO19,"BIO19.asc")

elevation=writeRaster(elevation,"elevation.asc")
getwd()

