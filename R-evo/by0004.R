library(fmsb)
contri<-read.csv('repo_contributors_merge.csv')


# 选择一行
#a<-contri[which(contri$author=="Shay Banon"),]
#a<-contri[which(contri$author=="Aarni Koskela"),] 
#a<-contri[which(contri$author=="Simon Willnauer"),] 
#a<-contri[which(contri$author=="Ryan Ernst"),] 
#a<-contri[which(contri$author=="Robert Muir"),] 
#a<-contri[which(contri$author=="javanna"),] 
#a<-contri[which(contri$author=="Colin Goodheart-Smithe"),] 

#a<-a[,-1]

#maxmin <- data.frame(
#  cmt=c(max(contri$cmt),min(contri$cmt)),
#  add=c(max(contri$add),min(contri$add)),
#  del=c(max(contri$del),min(contri$del)),
#  fixes=c(max(contri$fixes),min(contri$fixes)),
#  closes=c(max(contri$closes),min(contri$closes)),
#  issues=c(max(contri$issues),min(contri$issues)),
#  pr=c(max(contri$pr),min(contri$pr)),
#  comments=c(max(contri$comments),min(contri$comments)),
#  files=c(max(contri$files),min(contri$files)))

#dat <- rbind(maxmin,a)

# radarchart(dat,axistype=0,plwd=2:5,pcol=10,title="niubility great metric")

# op <- par(mar=c(1,2,2,1),mfrow=c(5,5))

# radarchart(dat,axistype=0,plwd=2:5,pcol=10)


# 按照cmt des排序
contri<-contri[order(-contri[,2]),]
# 画板设置
op <- par(mar=c(1,2,2,1),mfrow=c(2,5))
# 循环绘制
for (i in 1:10) {
  a<-contri[i,] 
  a<-a[,-1]
  maxmin <- data.frame(
    cmt=c(max(contri$cmt),min(contri$cmt)),
    add=c(max(contri$add),min(contri$add)),
    del=c(max(contri$del),min(contri$del)),
    fixes=c(max(contri$fixes),min(contri$fixes)),
    closes=c(max(contri$closes),min(contri$closes)),
    issues=c(max(contri$issues),min(contri$issues)),
    pr=c(max(contri$pr),min(contri$pr)),
    comments=c(max(contri$comments),min(contri$comments)),  
    files=c(max(contri$files),min(contri$files)))
  
  dat <- rbind(maxmin,a)
  radarchart(dat,axistype=0,plwd=2:5,pcol=10,title=contri[i,]$author)
}
# 重置画板
par(op)
 
