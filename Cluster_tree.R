#Create cluster tree to asses whether plants
#group by common garden or population

#load libraries
library(ggplot2)
library(ape)
library(reshape2)
library(viridis)
library(dplyr)
library(ggtree)
library(vegan)

#load data
data<-read.csv("https://raw.githubusercontent.com/CEGriffin/432-Final-Project/main/normalized_data.csv", row.names=NULL)
head(data)

#give data row names
uniq_name<-make.names(data$Tag, unique=T)
row.names(data)<-uniq_name

#make a dataframe with only the important columns
data2<-data%>%
  select(starts_with("z_"))
head(data2)

#make a distance matrix - this is a linear matrix by sample
distance<-dist(data2, method = "euclidean")
a<-as.matrix(distance)

distMrx<-melt(a)
names(distMrx)<-c("Query","Subject","Distance")

#distance matrix by population

p<-data%>%
  group_by(population)%>%
  summarize(z_RGR1=mean(z_RGR1),z_RGR2=mean(z_RGR2), z_RGR3=mean(z_RGR3), z_RGR4=mean(z_RGR4),
            z_ChlorA=mean(z_ChlorA), z_ChlorB=mean(z_ChlorB),z_gluc_Conc=mean(z_gluc_Conc),
            z_flav_Conc=mean(z_flav_Conc), z_Leaf_Len=mean(z_Leaf_Len),z_Leaf_Wid=mean(z_Leaf_Wid),
            z_TotalLeaf_Area=mean(z_TotalLeaf_Area),z_NumberOfLeaves=mean(z_NumberOfLeaves))

p2<-p %>%
  select(-c("population"))

p2<-data.frame(p2)

row.names(p2)<-p$population

distp<-dist(p2, method = "euclidean")
a2<-as.matrix(distp)

distMrx2<-melt(a2)
names(distMrx2)<-c("Query","Subject","Distance")

#visualize distances for population-level traits

b<-ggplot(data = distMrx2, aes(x=Query, y=Subject, fill=Distance)) +
  geom_tile() +theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))+
  scale_fill_viridis(option="magma")
b

#pdf(file = "./b.pdf",  
    #width = 6, 
    #height = 6)
#b

#dev.off()

#tree building for sample-level, colour by population
tree1<-nj(distance)
str(tree1)
ggtree(tree1, layout="circular")

pop<-gsub("^[a-z]\\.","",tree1$tip.label)
pop2<-sub("\\..*","",pop)
popGroups<-split(tree1$tip.label, pop2)
popCol<-groupOTU(tree1,popGroups)

c<-ggtree(popCol,layout="circular",aes(colour=group))
c2<-ggtree(popCol,layout="rectangular",aes(colour=group))

#pdf(file = "./c.pdf",  
    #width = 6, 
    #height = 6)
#c

#dev.off()

#pdf(file = "./c2.pdf",  
    #width = 6, 
    #height = 6)
#c2

#dev.off()

#tree building for sample-level, colour by common garden
garden<-gsub(".*([QNV]).*","\\1",tree1$tip.label)
grep("b.WSSWM3.1.0....|e.JBCHY1.1.50..|e.JBCHY1.1.50...1", garden)
garden<-garden[-c(812,813,960)]

gardenGroups<-split(tree1$tip.label, garden)
gardenCol<-groupOTU(tree1,gardenGroups)

d<-ggtree(gardenCol,layout="circular",aes(colour=as.factor(group)),branch.length = "none") +guides(color = guide_legend(title = "Common Garden")) + 
  scale_color_manual(values=c("blue", "red2", "green"))

#pdf(file = "./d.pdf",  
    #width = 6, 
   # height = 6)
#d

#dev.off()

#tree building for population-level trait
tree2<-nj(distp)
str(tree2)
ggtree(tree2, layout="circular") + geom_tiplab(size=2,aes(angle=angle))