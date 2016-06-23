contri<-read.csv('repo_contributors_merge.csv')      
#method����Ϊ"spearman","pearson" and "kendall",�ֱ��Ӧ�������ϵ���ļ���ͼ��顣
cor(contri[,-1],method="pearson")
cor(contri[,-1])

d=contri[,-1]

cor.lm<-lm(d$cmt ~ .,data = d)
summary(cor.lm)

plot(cor.lm)

#�����������
anova(cor.lm)

# shapiro.test(d$cmt)



#========================================
# graph
library(ggplot2)
library(reshape)
set_order_cmt<-contri[order(-contri[,2]),]
set_order_cmt$no<-1:length(contri[,2])

#��CMTΪ����ͬʱ������������
data2<-set_order_cmt[1:100,]
data_scale<-data.frame(scale(data2[,2:10], center=F,scale=T))
data_scale$no<-1:length(data2[,2])
data_long <- melt(data_scale[,-1], id="no")



ggplot(data_long,aes(x=no,y=value,colour=variable,shape=variable))+
  geom_line()+geom_point(size=3)+ scale_shape_manual(values=seq(0,15))+scale_x_discrete(breaks=(seq(0,100,10)))


# ֻ��cmt��issues��comment

set_order_cmt<-contri[order(-contri[,2]),]
set_order_cmt$no<-1:length(contri[,2])

#��CMTΪ����ͬʱ������������
data2<-set_order_cmt[1:663,]
data_scale<-data.frame(scale(data2[c(2,7,9)], center=F,scale=T))
data_scale$no<-1:length(data2[,2])
data_long <- melt(data_scale[,-1], id="no")



ggplot(data_long,aes(x=no,y=value,colour=variable,shape=variable))+
  geom_line()+geom_point(size=3)+ scale_shape_manual(values=seq(0,15))+scale_x_discrete(breaks=(seq(0,650,10)))


# �ñ�׼��������Է���
cor(contri[,-1],method = "spearman")

# �ñ�׼��������ݽ��лع����
data2<-set_order_cmt[1:200,]
data_scale<-data.frame(scale(data2[,2:10], center=F,scale=T))
d=data_scale[,-10]
cor.lm<-lm(d$cmt ~ .,data = d)
summary(cor.lm)
plot(cor.lm)
#�����������
anova(cor.lm)


# �𲽻ع�==>Ч�����ã��õ�����Ч����commit�ı���
cor.lm.step<-step(cor.lm)
summary(cor.lm.step)


d[1,]
# �о�commit��issue��comments
lm.cic<-lm(d$cmt ~ d$issues+d$comments ,data = d)
summary(lm.cic)
plot(lm.cic)

# �о�commit��issue
lm.cic2<-lm(d$cmt ~ d$issues ,data = d)
summary(lm.cic2)
plot(lm.cic2)

# �о�commit��comments
lm.cic3<-lm(d$cmt ~ d$comments ,data = d)
summary(lm.cic3)
plot(lm.cic3)

#data2$CCGN<-log(set_order_cmt2[,3])
#data2$IRPT<-log(set_order_cmt2[,4])
