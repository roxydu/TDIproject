
# 1 mass shooting data
# http://www.shootingtracker.com/
ms13 <- read.csv("./data/ms2013.csv", header = T)
ms14 <- read.csv("./data/ms2014.csv", header = T)
ms15 <- read.csv("./data/ms2015.csv", header = T)
ms16 <- read.csv("./data/ms2016.csv", header = T)
ms17 <- read.csv("./data/ms2017.csv", header = T)

mstracking <- rbind(ms13, ms14, ms15, ms16, ms17)

mstracking$date <- as.Date((mstracking$Incident.Date), "%B %d, %Y")
mstracking <- mstracking[order(mstracking$date),]
mstracking$incidents <- NA
eventcount <- aggregate(mstracking[,c("incidents")], by=list(mstracking$date), length)
colnames(eventcount)[1] <- "date"
colnames(eventcount)[2] <- "incidents"
merged1 <- merge(mstracking,eventcount,by="date",all.x=T,all.y=T)
merged1$incidents.x <- NULL
colnames(merged1)[9] <- "incidents"

alldate <- as.data.frame(seq(min(mstracking$date), max(mstracking$date), by="days"))
colnames(alldate)[1] <- "date"

merged2 <- merge(merged1,alldate,by="date",all.x=T,all.y=T)
merged2$X..Killed <- ifelse(is.na(merged2$X..Killed), 0, merged2$X..Killed)
merged2$X..Injured <- ifelse(is.na(merged2$X..Injured), 0, merged2$X..Injured)
merged2$incidents <- ifelse(is.na(merged2$incidents), 0, merged2$incidents)

casualtycol <- aggregate(merged2[,c("X..Killed", "X..Injured")],by=list(merged2$date), FUN=sum)
colnames(casualtycol)[1] <- "date"

msdata <- merge(casualtycol, eventcount, by="date",all.x=T,all.y=T)
msdata$incidents <- ifelse(is.na(msdata$incidents), 0, msdata$incidents)
msdata$casualty <- msdata$X..Killed + msdata$X..Injured
rm(ms13, ms14, ms15, ms16, ms17, alldate, casualtycol, eventcount, merged1, merged2)

msdata$nweek = 1:nrow(msdata)%/%7 + 1
# plot(msdata$date, log(msdata$casualty))


msdataweek <- aggregate(msdata[,c("X..Killed", "X..Injured", "incidents")],by=list(msdata$nweek), FUN=sum)
colnames(msdataweek)[1] <- "nweek"

# 2 media attention to gun control
# https://dashboard.mediacloud.org/
mediaattention <- read.csv("mediacloud-sentence.csv", header = T)
mediaattention$date <- as.Date(mediaattention$date)
mediaattention$nweek = 1:nrow(mediaattention)
# plot(mediaattention)


# 3 public interests in gun control
# https://trends.google.com/trends/explore?date=2013-01-01%202017-10-28&geo=US&q=gun%20control
googlesearch <- read.csv("googlesearch.csv", header = T)
googlesearch$date <- as.Date((googlesearch$date), "%m/%d/%y")
googlesearch$nweek = 1:nrow(googlesearch)
# plot(googlesearch)


# 4 merge all data
colnames(mediaattention)[2] <- "mediasentences"
googlesearch$date <- NULL
colnames(msdataweek)[2] <- "nkilled"
colnames(msdataweek)[3] <- "ninjured"

finaldata <- merge(googlesearch, msdataweek, by="nweek",all.x=T,all.y=T)
finaldata <- merge(mediaattention, finaldata, by="nweek",all.x=T,all.y=T)
finaldata$casualty <- finaldata$ninjured + finaldata$nkilled
library(scales)
# https://stats.stackexchange.com/questions/25894/changing-the-scale-of-a-variable-to-0-100
finaldata$mediaattention <- rescale(finaldata$mediasentences, to = c(0, 100))
library(DataCombine)

finaldata <- slide(finaldata, Var = "mediaattention", slideBy = 1)
finaldata <- slide(finaldata, Var = "guncontrolsearch", slideBy = 1)

colnames(finaldata)[10] <- "l.mediaattention"
colnames(finaldata)[11] <- "l.guncontrolsearch"


# 5 plotting 
library(reshape2)
library(ggplot2)

finaldata2 <- finaldata[c("date", "nweek", "nkilled","ninjured","incidents","casualty","mediaattention",
                 "guncontrolsearch","mediasentences","l.mediaattention","l.guncontrolsearch")] # reorder columns so graph legends comes out in right order

colnames(finaldata2)[3] <- "Mass Shooting Deaths"
colnames(finaldata2)[7] <- "Media Attention (1-100)"
colnames(finaldata2)[8] <- "Google Search (1-100)"

finaldata_long <- melt(finaldata2, id="date")

plot1 <- ggplot(data=finaldata_long,
       aes(x=date, y=value, colour=variable)) +
       geom_line(data=subset(finaldata_long, 
                 variable=="Mass Shooting Deaths" | variable=="Media Attention (1-100)"| variable=="Google Search (1-100)"), size=0.6) +
       scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
       labs(title="Mass Shooting, Media Attention, and Public Interest in Gun Control",x="",y="") +
       guides(color=guide_legend("")) +
       theme(plot.title = element_text(hjust = 0.5, size=21,face="bold")) + 
       theme(legend.text=element_text(size=11)) +
       annotate("text", x = as.Date("2013-01-14"), y = 90,
                label="Sandy Hook", colour = "#0E1B9E", size = 6) +
       annotate("text", x = as.Date("2017-10-01"), y = 80,
           label="Las Vegas", colour = "#0E1B9E", size = 6) +
       annotate("text", x = as.Date("2016-06-12"), y = 85,
           label="Pulse Club", colour = "#0E1B9E", size = 6) +
       annotate("text", x = as.Date("2015-12-02"), y = 95,
           label="San Bernardino", colour = "#0E1B9E", size = 6) 


# 6 regression

lm <- lm(l.guncontrolsearch ~ mediaattention, data=finaldata)
summary(lm)

plot2 <- 
  ggplot(data = finaldata, aes(x = mediaattention, y = l.guncontrolsearch)) + 
  theme(plot.title = element_text(hjust = 0.5, size=21,face="bold")) + 
  theme(axis.title=element_text(size=13)) +
  labs(title="Does the Public Follow the Media?",x="Media Attention to Gun Control (Scaled to 1-100)",y="Google Search on Gun Control (Scaled 1-100), Lagged") +
  geom_point(aes(color = nkilled)) +
  geom_smooth(method = "lm", level=0.95) +
  guides(color=guide_legend("# of Deaths")) 

lm2 <- lm(l.guncontrolsearch ~ mediaattention + nweek + mediaattention*nweek, data=finaldata)
summary(lm2)
# media's effects on public interets wan over time!