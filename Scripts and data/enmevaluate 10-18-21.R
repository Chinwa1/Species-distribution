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
bio1 <- raster("BIO1.asc")
bio4 <- raster("BIO4.asc")
bio5 <- raster("BIO5.asc")
bio6 <- raster("BIO6.asc")
bio7 <- raster("BIO7.asc")
bio12 <- raster("BIO12.asc")
bio14 <- raster("BIO14.asc")
bio15 <- raster("BIO15.asc")
bio18 <- raster("BIO18.asc")
elevation <- raster("elevation.asc")


#Do what's called "stacking" the rasters together into a single r object

env <- stack(bio1, bio4, bio5, bio6, bio7, bio12, bio14, bio15, bio18, elevation)

#Display the stacked environment layer. Make a note of the position in the list 
#of any categorical variables (do that by hand)

env

#in this example, the categorical variables are #s 9 and 10 in the list. But know your own data!

#load in your occurrence points

occ <- read.csv("occ.csv")[,-1]

#make a bias file
occur.ras <- rasterize(occ, env, 1)
plot(occur.ras)
presences <- which(values(occur.ras) == 1)
pres.locs <- coordinates(occur.ras)[presences, ]

dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occur.ras), ncol(occur.ras)), lims = c(extent(env)[1], extent(env)[2], extent(env)[3], extent(env)[4]))
dens.ras <- raster(dens, env)
dens.ras2 <- resample(dens.ras, env)

#plot(dens.ras2)
plot(dens.ras2)
writeRaster(dens.ras2, "Biasfile.asc")

#check how many potential background points you have available

length(which(!is.na(values(subset(env, 1)))))

#If this number is far in excess of 10,000, then use 10,000 background points.
#If this number is comprable to, or smaller than 10,000, then use 5,000, 1,000, 500,
#or even 100 background points. The number of available non-NA spaces should 
#be well in excess of the number of background points used.

#For the evalution below, we need to convert the bias object into another format.
#The code is set up to sample 5,000 background points. It would be better if we
#could sample 10,000 background points, but there are not enough places available.
#If we could change it to 10,000 background points we would change the ", 5000," to ",10000,"

bg <- xyFromCell(dens.ras2, sample(which(!is.na(values(subset(env, 1)))), 10000, prob=values(dens.ras2)[!is.na(values(subset(env, 1)))]))
colnames(bg) <- colnames(occ)

##run the evaluation
##This run uses the "randomkfold" method of cross-validation, with a set of background points
##sampled based on the bias file, and 10 cross-validation folds. There are two categorical 
##variables: they are numbers 9 and 10 in the list of environmental variables from the stacked 
##raster object.
##using randofold
enmeval_results <- ENMevaluate(occ, env, bg, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5), partitions = "randomkfold", partition.settings = list(kfolds = 10), algorithm = "maxnet")

##using block method
enmeval_results <- ENMevaluate(occ, env, bg, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5),partitions = "block", algorithm = "maxnet")

##when having categorical data use the following code 
enmeval_results <- ENMevaluate(occ, env, bg, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5), partitions = "randomkfold", partition.settings = list(kfolds = 10), algorithm = "maxnet", categoricals = c("biocateg1", "biocateg2"))

enmeval_results@results

write.csv(enmeval_results@results, "enmeval_results_block.csv")

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