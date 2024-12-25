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

######################################Load required library
library("raster")
require(utils)
# search files with .bil file extension
BIO5 <- raster("E:/Documents/30sec/Species distribution/Current bioclim/Mash east province/Current bioclim/BIO5.asc")
clim_list <- list.files("E:/Documents/30sec/Species distribution/Biclimatic variables for Zimbabwe/Current bioclimatic variables Zimbabwe",pattern=".asc$",full.names = T)

# stacking the bioclim variables to process them at one go 
clim <- raster::stack(clim_list) 
####resample raster
BIO1 <- raster("E:/Documents/30sec/Species distribution/Current bioclim/Mash east province/Current bioclim/BIO1.asc")

# define new resolution
newRaster <- raster( nrow= nrow(BIO1)/10 , ncol= ncol(BIO1)/10 )

# define the extent of the new coarser resolution raster
extent(newRaster) <- extent(BIO1)

# fill the new layer with new values
newRaster <- resample(x=BIO1,y=newRaster,method='bilinear')

# when viewing the new layer, we see that it appears coarser
plot(BIO1)
######################Reclassify raster layer as a binary layer
myLayer<- raster("E:/Documents/30sec/Species distribution/Current bioclim/Mash east province/Current bioclim/BIO1.asc")

binaryMap <-   myLayer>= 100

plot(binaryMap)
#####################Use multiple threshold to reclassify
# values smaller than 0 becomes 0; 
# values between 0 and 100 becomes 1; 
# values between 100 and 200 becomes 2;
# values larger than 200 becomes 3;

myMethod <- c(-Inf,  0, 0, # from, to, new value
              0,   100, 1,
              100, 200, 2,
              200, Inf, 3)
myLayer_classified <- reclassify(myLayer,rcl= myMethod)
plot(myLayer_classified)
##########Raster calculation##############
wet <- raster("E:/Documents/30sec/Species distribution/Current bioclim/Mash east province/Current bioclim/BIO13.asc") # precipitation of wettest month
dry <- raster("E:/Documents/30sec/Species distribution/Current bioclim/Mash east province/Current bioclim/BIO14.asc") # precipitation of driest month

# To calculate difference between these two rasters
diff <- wet - dry
names(diff) <- "diff"

# To calculate the mean between the dry and wet rasters
twoLayers <- stack(wet,dry)
meanPPT1 <- calc(twoLayers,fun=mean)
names(meanPPT1) <- "mean"

# the following code gives the same results
meanPPT2 <-  (wet + dry)/2
names(meanPPT2) <- "mean"

layers_to_plot <- stack(wet, dry, diff, meanPPT1,meanPPT2)
plot(layers_to_plot)

##########Calculation of correlation matrix
# search files with *.asc* file extension
clim_list <- list.files("E:/Documents/30sec/Species distribution/Biclimatic variables for Zimbabwe/Current bioclimatic variables Zimbabwe",pattern=".asc$",full.names = T)
# stacking the bioclim variables to process them at one go 
clim <- raster::stack(clim_list) 
# select the first 5 layers
clim_subset <- clim[[1:19]]
clim_subset <- clim[[c("Elevation","BIO1","BIO2","BIO3","BIO4","BIO5","BIO6","BIO7","BIO8","BIO9","BIO10","BIO11","BIO12","BIO13","BIO14","BIO15","BIO16","BIO17","BIO18","BIO19")]]
clim_subset1=clim[[c("BIO1","BIO2","BIO3","BIO4","BIO6","BIO13", "BIO14", "BIO15","BIO18")]]
# to run correlations between different layers
raster::pairs(clim_subset1,maxpixels=100) # the default is maxpixels=100000
####change error margin too large 
###check the parhttp://127.0.0.1:25171/graphics/9cb6ce99-e798-4482-b499-d0e0a75e8409.png
graphics.off()
par("mar")
 ###change it to 
par(mar=c(1,1,1,1))
par(mar=c(2,2,2,2))
par(mfcol=c(5,3),mai=c(0.5,0.5,0.5,0))

#Don't forget to set your working directory!

#only need to run this code the first time you install these packages on your machine/user account.

#NOTE: If you have RStudio open already and you tried this script and it didn't work:
#Close RStudio and reopen it again. and try re-installing the ENMEval package (line 12)

#You don't need rJava for this version of the script, but you must install all of the packages and run all of the code you see below with the hash (comment) symbols the first time you run it
#install.packages("devtools", dependencies = TRUE)
#library(devtools)
#install_github("jamiemkass/ENMeval")
#install.packages("MASS", dependencies = TRUE)

library(ENMeval)
library(raster)
library(MASS)
#

#You don't need to do all that stuff about putting Java in the right directory any more.
#
#
#
#

#put here the names of your environmental layers, following the pattern below:
BIO1 <- raster("BIO1.asc")
BIO2 <- raster("BIO2.asc")
BIO3 <- raster("BIO3.asc")
BIO4 <- raster("BIO4.asc")
BIO5 <- raster("BIO5.asc")
BIO6 <- raster("BIO6.asc")
BIO7 <- raster("BIO7.asc")
BIO8 <- raster("BIO8.asc")
BIO9 <- raster("BIO9.asc")
BIO10 <- raster("BIO10.asc")
BIO11 <- raster("BIO11.asc")
BIO12 <- raster("BIO12.asc")
BIO13 <- raster("BIO13.asc")
BIO14 <- raster("BIO14.asc")
BIO15 <- raster("Bio15.asc")
BIO16 <- raster("Bio16.asc")
BIO17 <- raster("BIO17.asc")
BIO18 <- raster("BIO18.asc")
biocateg1 <- raster("biocateg1.asc")
biocateg2 <- raster("biocateg2.asc")

#Do what's called "stacking" the rasters together into a single r object

env <- stack(BIO1, BIO2, BIO3, BIO4, BIO6, BIO13, BIO14, BIO15, BIO18)

#Display the stacked environment layer. Make a note of the position in the list 
#of any categorical variables (do that by hand)

env

#in this example, the categorical variables are #s 9 and 10 in the list. But know your own data!

#load in your occurrence points

occ <- read.csv("occurrence.csv")[,-1]

#############################
points(occ)

#make a bias file

occur.ras <- rasterize(occ, env, 1)
plot(occur.ras)

presences <- which(values(occur.ras) == 1)
pres.locs <- coordinates(occur.ras)[presences, ]

dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occur.ras), ncol(occur.ras)), lims = c(extent(env)[1], extent(env)[2], extent(env)[3], extent(env)[4]))
dens.ras <- raster(dens, env)
dens.ras2 <- resample(dens.ras, env)
#

writeRaster(dens.ras2, "biasfile.asc", overwrite = TRUE)

#check how many potential background points you have available

background=length(which(!is.na(values(subset(env, 1)))))
write.csv(background,"potential background points.csv")
#If this number is far in excess of 10,000, then use 10,000 background points.
#If this number is comprable to, or smaller than 10,000, then use 5,000, 1,000, 500,
#or even 100 background points. The number of available non-NA spaces should 
#be well in excess of the number of background points used.

#For the evalution below, we need to convert the bias object into another format.
#The code is set up to sample 5,000 background points. It would be better if we
#could sample 10,000 background points, but there are not enough places available.
#If we could change it to 10,000 background points we would change the ", 5000," to ",10000,"

bg <- xyFromCell(dens.ras2, sample(which(!is.na(values(subset(env, 1)))), 5000, prob=values(dens.ras2)[!is.na(values(subset(env, 1)))]))
colnames(bg) <- colnames(occ)

##run the evaluation
##This run uses the "randomkfold" method of cross-validation, with a set of background points
##sampled based on the bias file, and 10 cross-validation folds. There are two categorical 
##variables: they are numbers 9 and 10 in the list of environmental variables from the stacked 
##raster object.

enmeval_results <- ENMevaluate(occ, env, bg, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5), partitions = "randomkfold", partition.settings = list(kfolds = 10), algorithm = "maxnet", categoricals = c("biocateg1", "biocateg2"))
enmeval_results <- ENMevaluate(occ, env, bg, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5), partitions = "block", algorithm = "maxnet")
enmeval_results <- ENMevaluate(occ, env, bg, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5), partitions = "randomkfold", partition.settings = list(kfolds = 10), algorithm = "maxnet")

enmeval_results@results

write.csv(enmeval_results@results, "enmeval_results_Zimbabwe.csv")

#If you were to use the block method, you would replace:
#partitions = "randomkfold", partition.settings = list(kfolds = 10)
#with:
#partitions = "block"

#############################
##########IMPORTANT##########
#############################
#If you have fewer than 50 occurrence points, you will need to use the "jackknife" method of
#model validation instread. To do that, you would replace:
#partitions = "randomkfold", partition.settings = list(kfolds = 10)
#with:
#partitions = "jackknife"

#If there are no categorical variables in your dataset, you would get rid of:
#categoricals = c("biocateg1", "biocateg2")
#In general, be very careful that the categoricals argument points to the right variable(s).