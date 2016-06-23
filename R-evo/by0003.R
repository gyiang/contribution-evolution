users_cmt_iss_comm<-read.csv('net_users.csv')


# 标准化数据
users_scale<-data.frame(scale(users_cmt_iss_comm[,2:4], center=F,scale=T))

# 加个非开发者 =》结果相关性很慢
cor(users_scale,method="spearman")
8.0

library(ggplot2)
library(reshape)
#以CMT为降序，同时画出其他变量
# data2<-cmt_atfer_code[1:100,]


# cmt
cmt_atfer_code<-users_scale[order(-users_scale[,3]),]
cmt_atfer_code$no_cmt<-1:length(users_scale[,3])
data_sample<-cmt_atfer_code[1:100,]
data_long <- melt(data_sample[,c(1,2,3,4)], id="no_cmt")
ggplot(data_long,aes(x=no_cmt,y=value,colour=variable,shape=variable))+
  geom_line()+geom_point(size=3)+ scale_shape_manual(values=seq(0,15))


# issues
cmt_atfer_code<-cmt_atfer_code[order(-cmt_atfer_code[,1]),]
cmt_atfer_code$no_issues<-1:length(cmt_atfer_code[,1])
data_sample<-cmt_atfer_code[1:100,]
data_long <- melt(data_sample[,c(1,2,3,5)], id="no_issues")
ggplot(data_long,aes(x=no_issues,y=value,colour=variable,shape=variable))+
  geom_line()+geom_point(size=3)+ scale_shape_manual(values=seq(0,15))


# comments
cmt_atfer_code<-cmt_atfer_code[order(-cmt_atfer_code[,2]),]
cmt_atfer_code$no_comments<-1:length(cmt_atfer_code[,2])
data_sample<-cmt_atfer_code[1:100,]
data_long <- melt(data_sample[,c(1,2,3,6)], id="no_comments")
ggplot(data_long,aes(x=no_comments,y=value,colour=variable,shape=variable))+
  geom_line()+geom_point(size=3)+ scale_shape_manual(values=seq(0,15))

