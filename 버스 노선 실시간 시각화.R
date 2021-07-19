# 임성민 - 20182890

# 대전시 버스
# http://openapitraffic.daejeon.go.kr/api/rest/busRouteInfo/


library(XML)
library(ggmap)

busRtNm <- "802"

#버스 경로 802
API_key <- "vECpSk4BAhmevihpl9z1qQLcOHjj3Fe7IA8JylhaqCJNmjhj67LXat168VW4uFvqHfZ2YdiWhoVQM5l6x3veqg%3D%3D"
url <- paste("http://openapitraffic.daejeon.go.kr/api/rest/busRouteInfo/getRouteInfoAll?serviceKey=", API_key, "&reqPage=1", sep="")
url

xmefile <- xmlParse(url)
xmefile
xmlRoot(xmefile)

df <- xmlToDataFrame(getNodeSet(xmefile, "//itemList"))
df
head(df)

#버스 경로 802
df_busRoute <- subset(df, ROUTE_NO==busRtNm)
df_busRoute

df_busRoute$ROUTE_CD



#버스 정류장 좌표 이름 
API_key2 <- "vECpSk4BAhmevihpl9z1qQLcOHjj3Fe7IA8JylhaqCJNmjhj67LXat168VW4uFvqHfZ2YdiWhoVQM5l6x3veqg%3D%3D"
url2 <- paste("http://openapitraffic.daejeon.go.kr/api/rest/busRouteInfo/getStaionByRoute?busRouteId=30300093&serviceKey=", API_key, "&reqPage=1", sep="")
url2

xmefile2 <- xmlParse(url2)
xmefile2
xmlRoot(xmefile2)

df2 <- xmlToDataFrame(getNodeSet(xmefile2, "//itemList"))
df2
head(df2)


# 버스 실시간 위치 좌표
API_key1 <- "vECpSk4BAhmevihpl9z1qQLcOHjj3Fe7IA8JylhaqCJNmjhj67LXat168VW4uFvqHfZ2YdiWhoVQM5l6x3veqg%3D%3D"
url1 <- paste("http://openapitraffic.daejeon.go.kr/api/rest/busposinfo/getBusPosByRtid?busRouteId=30300093&serviceKey=", API_key, "&reqPage=1", sep="")
url1

xmefile1 <- xmlParse(url1)
xmefile1
xmlRoot(xmefile1)

df1 <- xmlToDataFrame(getNodeSet(xmefile1, "//itemList"))
df1
head(df1)


gpsX <- as.numeric(as.character(df1$GPS_LONG))
gpsY <- as.numeric(as.character(df1$GPS_LATI))
gc <- data.frame(lon=gpsX, lat=gpsY)
gc


#버스 정류장 명
busname <- data.frame(df2$BUSSTOP_NM, df2$GPS_LATI,df2$GPS_LONG)

#버스 위치 
dushere<-data.frame(df1$PLATE_NO ,df1$GPS_LATI ,df1$GPS_LONG ) 

dushere$df1.GPS_LONG <- as.numeric(as.character(dushere$df1.GPS_LONG))
dushere$df1.GPS_LATI <- as.numeric(as.character(dushere$df1.GPS_LATI))

busname$df2.GPS_LONG <- as.numeric(as.character(busname$df2.GPS_LONG))
busname$df2.GPS_LATI <- as.numeric(as.character(busname$df2.GPS_LATI))


register_google(key = 'AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc')

cen <- c(mean(gc$lon), mean(gc$lat))
map <- get_googlemap(center=cen, maptype="roadmap",zoom=12, marker=gc)


ggmap(map) + 
    geom_point(data=busname, aes(x=df2.GPS_LONG, y=df2.GPS_LATI),color = 'red',size = 3,alpha = 0.7) +
    geom_point(data=dushere, aes(x=df1.GPS_LONG, y=df1.GPS_LATI),color = 'orange',size = 10,alpha = 0.7)+
    geom_path(data=busname, aes(x=df2.GPS_LONG, y=df2.GPS_LATI),color = 'blue', size=0.5)

busnameee <- busname$df2.BUSSTOP_NM
bushereEEEEE <-dushere$df1.PLATE_NO


ggmap(map) + 
  geom_point(data=busname, aes(x=df2.GPS_LONG, y=df2.GPS_LATI),color = 'red',size = 3,alpha = 0.7) +
  geom_point(data=dushere,  aes(x=df1.GPS_LONG, y=df1.GPS_LATI),color = 'orange',size = 10,alpha = 0.7)+
  geom_text(aes(label = busname),size = 2.5,alpha = 0.5)+
  geom_text(aes(label = dushere),color = 'blue',size = 6)+
  geom_path(data=busname, aes(x=df2.GPS_LONG, y=df2.GPS_LATI),color = 'blue', size=0.5)







