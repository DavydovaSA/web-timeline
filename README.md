# web-timeline  
ДПВ по R: Лабораторная по сбору данных из выдачи поисковой системы.  
  
## Цель работы  

  
## Поисковая система  

  
## Структура запросов и временной горизонт  

  
## Файлы    
 1. ```Make_Timeline.R``` содержит скрипт R для сбора данных.  
 2. ```Timeline.csv``` содержит таблицу с собранными данными. Столбцы таблицы:  
  * **Year** – год, по которому сделан запрос.  
  * **Header** - заголовок статьи.  
  * **Source** - источник новости (адрес информационного источника, который виден на странице выдачи поисковика).  
  * **URL** - полная ссылка на источник.  
  
  library('RCurl')
library('XML') 
searchURL <- "https://yandex.ru/search/?text="
searchURL.Api <- "https://yandex.ru/search/xml?query="
search.settings <- c()
file.output <- './Timeline.csv'
search.queries <- c("пони %i",
                    "эквестрия %i",
                    "дружба %i")
year.low <- 2000
year.high <- 2010
data <- data.frame()
for(year in year.low:year.high){
  print(paste("ПОИСК", year))
  for(query in search.queries){
    fileURL <- paste0(searchURL, sprintf(query, year))
    fileURL <- URLencode(fileURL)
    html <- getURL(fileURL, followLocation = T)
    doc <- htmlTreeParse(html, useInternalNodes = T)
    rootNode <- xmlRoot(doc)
    l <- xpathSApply(rootNode, '//a[contains(@class, "link link_theme_normal organic__url link_cropped_no")]',
                         xmlGetAttr, 'href')
    h <- xpathSApply(rootNode, '//a[contains(@class, "link link_theme_normal organic__url")]',
                           xmlValue)
    s <- xpathSApply(rootNode, '//div[@class="path organic__path"]',
                           xmlValue)
    data.request <- data.frame(Year = year, Header = h, Source = s, URL = l)
    data <- rbind(data, data.request)
    Sys.sleep(0.1)
  }
}
write.csv(data, file = file.output, row.names = F)
print('Конец')
