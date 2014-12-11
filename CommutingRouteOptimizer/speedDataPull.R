library(RCurl)
library(RJSONIO)

#segments = fromJSON(getURL(url = 'http://www.cotrip.org/speed/getSegments.do'))
routes = fromJSON(getURL(url = 'http://www.cotrip.org/speed/getRoutes.do'))
#slowdowns = fromJSON(getURL(url = 'http://www.cotrip.org/speed/getSlowDowns.do'))


#combine them into tables and possibly just one large table... output as .csv with a time stamp

routesDF = data.frame(Description="", CalculatedDate='', Length=0, RouteName='', RouteId='', ExpectedTravelTime=0, TravelTime=0)

for(i in 1:length(routes$SpeedDetails$Route)){
  x=routes$SpeedDetails$Route[[i]]
  TravelTime = x$TravelTime
  if(length(TravelTime)==0){
    TTime=NA
    x[["TravelTime"]]=TTime
  }else{
    if(length(TravelTime)==1){
      TTime=as.numeric(TravelTime[1])
      x[["TravelTime"]]=TTime
    }else{
      TTime=as.numeric(TravelTime[1])*60+as.numeric(TravelTime[2])
      x[["TravelTime"]]=TTime
    }
  }
  
  ETravelTime = x$ExpectedTravelTime
  if(length(ETravelTime)==0){
    x$ExpectedTravelTime=NA
  }else{
    if(length(ETravelTime)==1){
      x$ExpectedTravelTime=as.numeric(ETravelTime)
    }else{
      x$ExpectedTravelTime=as.numeric(ETravelTime[1])*60+as.numeric(ETravelTime[2])
    }
  }

  routesDF = rbind(routesDF,data.frame(x[names(routesDF)]))
}
 
write.csv(routesDF, file=paste('Routes',Sys.time(), sep="_"))
