# 画project整体的演化图

mytheme<-theme_bw()+theme(legend.position="top",
                          panel.border=element_blank(),
                          panel.grid.major=element_line(linetype="dashed"),
                          panel.grid.minor=element_blank(),
                          plot.title=element_text(size=15,family="CA"),
                          legend.text=element_text(size=9,colour="#003087"),
                          legend.key=element_blank(),
                          axis.text=element_text(size=10,colour="#003087"),
                          strip.text=element_text(size=12,colour="#EF0808"),
                          strip.background=element_blank()
)



contr_tag<-read.csv('repo_proj_tag.csv')

library(reshape2)
library(ggplot2)
library(scales)
maxmin <- data.frame(
  CLOSES = c(max(contr_tag$closes), min(contr_tag$closes)),
  CMT  = c(max(contr_tag$cmt), min(contr_tag$cmt)),
  ADD   = c(max(contr_tag$add), min(contr_tag$add)),
  DEL = c(max(contr_tag$del), min(contr_tag$del)),
  FIX = c(max(contr_tag$fixes), min(contr_tag$fixes)),
  ISSUES = c(max(contr_tag$issues), min(contr_tag$issues)),
  COMMENTS=c(max(contr_tag$comments), min(contr_tag$comments)),
  PR=c(max(contr_tag$pr), min(contr_tag$pr))
)
dat <- data.frame(
  CLOSES = contr_tag$closes,
  CMT  = contr_tag$cmt,
  ADD   = contr_tag$add,
  DEL = contr_tag$del,
  FIX = contr_tag$fixes,
  ISSUES=contr_tag$issues,
  COMMENTS=contr_tag$comments,
  PR=contr_tag$pr
)

normalised_dat <- as.data.frame(mapply(
  function(x, mm)
  {
    (x - mm[2]) / (mm[1] - mm[2])
  },
  dat,
  maxmin
))

normalised_dat$tag<-contr_tag$tag
long_dat <- melt(normalised_dat, id.vars = "tag")

p1<-ggplot(long_dat, aes(x = variable, y = value, colour = tag, group = tag,shape=tag)) +
  geom_line()+
  coord_polar(theta = "x", direction = -1) +
  scale_y_continuous(labels = percent)+
  labs(title = "Project Evolution")+theme(axis.title.x=element_blank(),axis.title.y=element_blank())+
  theme(legend.position='none')+mytheme+theme(axis.title.x=element_blank(),axis.title.y=element_blank())+
  theme(legend.position="right")+
  geom_point(size=2)+scale_shape_manual(values=seq(0,50))


# +theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))


#2=========
t_scale<-data.frame(scale(contr_tag[,3:10], center=F,scale=T))
t_scale$date<-contr_tag$date
data_long <- melt(t_scale, id="date")
p2<-ggplot(data_long,aes(x=as.Date(date),y=value,colour=variable,shape=variable))+geom_line()+
  geom_point()+scale_shape_manual(values=seq(0,15))+
  mytheme+theme(axis.title.x=element_blank(),axis.title.y=element_blank())
#theme(legend.position='none')



#3=========
library(grid)
grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 2)))
vplayout = function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(p1, vp = vplayout(1, 1))
print(p2, vp = vplayout(1, 2))


#library(gridExtra)
#grid.arrange(p1, p2,nrow=2, widths=c(4,1), heights=c(1,4))
