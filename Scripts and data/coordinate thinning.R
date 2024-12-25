library(spThin)
attach(coords)
head(coords)
coordthin=thin(loc.data = coords,
               lat.col = "Latitude",long.col = "Longitude",
               spec.col = "species",thin.par = 1,reps = 100,
               locs.thinned.list.return = TRUE,
               write.files = TRUE,
               max.files = 5,out.dir = "E:/Species final",
               out.base = "coordthin",
               write.log.file = TRUE,
               log.file = "Thinned.csv")
