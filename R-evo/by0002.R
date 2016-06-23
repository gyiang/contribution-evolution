set1<-read.csv('users_my_set1_es.csv')       
#method可以为"spearman","pearson" and "kendall",分别对应三种相关系数的计算和检验。
cor(set1[,-1],method="spearman")
cor.test(set1$CMT,set1$IRPT,method="spearman")
cor.test(set1$CMT,set1$CCGN,method="spearman")

qqnorm(set1$CMT)

shapiro.test(log(set1$CMT+1))

qqnorm(log(set1[1:100,]$CMT+1))

library(nortest)
pearson.test(log(set1[1:100,]$CMT+1))


summary(set1[,-1])

library(ggplot2)
ggplot(set1,aes(x=log(CMT)))+
  geom_histogram(position = 'identity',alpha=0.2,aes(y = ..density..))+
  stat_density(geom = 'line', position = 'identity')+
  scale_x_discrete(breaks=(seq(0,11,1)))


#CDF 累积分布函数
ggplot(set1,aes(x=CMT))+
  stat_ecdf(geom = "step", position = "identity")

ggplot(set1,aes(x=IRPT))+
  stat_ecdf(geom = "step", position = "identity")

summary(set1$CMT)


ggplot(set1,aes(x=CCGN))+geom_histogram()
ggplot(set1,aes(x=IRPT))+geom_histogram()


ggplot(set1,aes(x=))+geom_histogram()


set2<-sort(set1[,1],decreasing = TRUE)
set_order_cmt<-set1[order(-set1[,2]),]
set_order_cmt$no<-1:length(set1[,2])
ggplot(set_order_cmt,aes(x=no,y=CMT))+geom_smooth()
ggplot(set_order_cmt,aes(x=no,y=CMT))+geom_line()+scale_x_continuous(breaks=(seq(0,600,600)))


set_order_ccgn<-set1[order(-set1[,3]),]
set_order_ccgn$no<-1:length(set1[,3])
ggplot(set_order_ccgn,aes(x=no,y=CCGN))+geom_line()

set_order_irpt<-set1[order(-set1[,4]),]
set_order_irpt$no<-1:length(set1[,4])
ggplot(set_order_irpt,aes(x=no,y=IRPT))+geom_line()


library(reshape)
set_order_cmt<-set1[order(-set1[,2]),]
set_order_cmt$no<-1:length(set1[,2])

#以CMT为降序，同时画出其他变量
set_order_cmt2<-set_order_cmt[1:30,]
set_order_cmt2$CCGN<-log(set_order_cmt2[,3])
set_order_cmt2$IRPT<-log(set_order_cmt2[,4])
test_data_long <- melt(set_order_cmt2[,-1], id="no")
ggplot(test_data_long,aes(x=no,y=value,colour=variable))+geom_line()


#量纲，级数不一致，数据标准化


test_data_long
ggplot(test_data_long)


#标准化
t_scale<-data.frame(scale(set_order_cmt2[,2:4], center=F,scale=T))
stars(t_scale[1:20,][c("CMT","CCGN","IRPT")])

library(fmsb)
maxmin <- data.frame(
  total=c(5,1),
  phys=c(15,3),
  psycho=c(3,0),
  social=c(5,1),
  env=c(5,1))
# data for radarchart function version 1 series, minimum value must be omitted from above.[radarchart功能第1版系列的数据，最小值必须从上面的省略。]
RNGkind("Mersenne-Twister")
set.seed(123)
dat <- data.frame(
  total=runif(3,1,5),
  phys=rnorm(3,10,2),
  psycho=c(0.5,NA,3),
  social=runif(3,1,5),
  env=c(5,2.5,4))
dat <- rbind(maxmin,dat)
op <- par(mar=c(1,2,2,1),mfrow=c(2,2))
radarchart(dat,axistype=1,seg=5,plty=1,title="(axis=1, 5 segments)")
radarchart(dat,axistype=2,pcol=topo.colors(3),plty=1,title="(topo.colors, axis=2)")
radarchart(dat,axistype=3,pty=32,plty=1,axislabcol="grey",na.itp=FALSE,title="(no points, axis=3, na.itp=FALSE)")
radarchart(dat,axistype=0,plwd=1:5,pcol=1,title="(use lty and lwd but b/w, axis=0)")
par(op)
