library('XML')
library('RCurl')

year <- vector(mode = 'numeric', length = 0)
header <- vector(mode = 'character', length = 0)
sources <- vector(mode = 'character', length = 0)
URL <- vector(mode = 'character', length = 0)
l2 = 0
for (i in 1:3){
  if (i==1) {fileURL = "https://nova.rambler.ru/search?query=%D0%BC%D0%B0%D0%B9%20%D0%BB%D0%B8%D1%82%D0%BB%20%D0%BF%D0%BE%D0%BD%D0%B8%20%D0%BA%20"}
  if (i==2) {fileURL = "https://nova.rambler.ru/search?query=%D0%BC%D0%B0%D0%B9%20%D0%BB%D0%B8%D1%82%D0%BB%20%D0%BF%D0%BE%D0%BD%D0%B8%20%D0%B4%D0%BE%20"}
  if (i==3) {fileURL = "https://nova.rambler.ru/search?query=%D0%BC%D0%B0%D0%B9%20%D0%BB%D0%B8%D1%82%D0%BB%20%D0%BF%D0%BE%D0%BD%D0%B8%20%D0%BF%D0%BE%D1%81%D0%BB%D0%B5%20"}
  for(j in 2009:2018){
    Sys.sleep(10)
    fileURL <- paste(fileURL,j)
    html <- getURL(fileURL)
    doc <- htmlTreeParse(html, useInternalNodes = T)
    rootNode <- xmlRoot(doc)
    h <- c(header,xpathSApply(rootNode, '//a[@class = "b-serp-item__link"]', xmlValue))
    s <- c(sources,xpathSApply(rootNode, '//article/span[2]/span', xmlValue))
    UR <- c(URL,xpathSApply(rootNode, '//h2[@class = "b-serp-item__header"]/a', xmlGetAttr,'href'))
    l <- length(h) - l2
    l2 <- length(h)
    year <- c(year,rep(j,l))
  }
}
data <- data.frame(Year = year, Header = h, Source = s, URL = UR, stringsAsFactors = F)

write.csv(data, './Timeline3.csv', row.names = F, fileEncoding = "UTF-8")
print("Timeline.csv")
