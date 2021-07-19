library(XML)
library(ggmap)

busRtNm <- "314"

API_key <- "vECpSk4BAhmevihpl9z1qQLcOHjj3Fe7IA8JylhaqCJNmjhj67LXat168VW4uFvqHfZ2YdiWhoVQM5l6x3veqg%3D%3D"
#API_key <- "DEp3%2BU.....DQ%3D%3D"
url <- paste("http://ws.bus.go.kr/api/rest/busRouteInfo/getBusRouteList?ServiceKey=", API_key, "&strSrch=", busRtNm,sep="")
xmefile <- xmlParse(url)
xmlRoot(xmefile)

# p.252
df <- xmlToDataFrame(getNodeSet(xmefile, "//itemList"))
head(df)

df_busRoute <- subset(df, busRouteNm==busRtNm)
df_busRoute

df_busRoute$busRouteId

# p.253
# 노선 ID에 대한 버스 실시간 위치 정보 확인
#API_key <- "DEp3%2BU.....D%3D"
API_key <- "vECpSk4BAhmevihpl9z1qQLcOHjj3Fe7IA8JylhaqCJNmjhj67LXat168VW4uFvqHfZ2YdiWhoVQM5l6x3veqg%3D%3D"

url <- paste("http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?ServiceKey=", API_key, "&busRouteId=",
             df_busRoute$busRouteId, sep="")
xmefile <- xmlParse(url)
xmlRoot(xmefile)

# p.254
df <- xmlToDataFrame(getNodeSet(xmefile, "//itemList"))
df

gpsX <- as.numeric(as.character(df$gpsX))
gpsY <- as.numeric(as.character(df$gpsY))
gc <- data.frame(lon=gpsX, lat=gpsY)
gc

# p.257
# 구글 맵에 버스 위치 출력
register_google(key = 'AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc')


cen <- c(mean(gc$lon), mean(gc$lat))
map <- get_googlemap(center=cen, maptype="roadmap",zoom=11, marker=gc)
ggmap(map, extent="device")

