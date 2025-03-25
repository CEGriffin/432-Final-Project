#Create cluster tree to asses whether plants
#group by common garden or population

#set working directory
getwd()
setwd("C:/Users/clari/Desktop/BIOL 432/Week10/432-Final-Project")

#load libraries
library(BiocManager)
install("Biostrings")
install("ggtree")
install("annotate")
install("ape")
install("remotes")
install("gmbecker/genbankr")
library(ggplot2)
library(reshape2)
library(viridis)

#load data
data<-read.csv("./DataSynth_expand_tag.csv")
head(data)

#See if plants cluster by common garden or genetic population or neither
#group by similarities in growth rate

#which variables to use for growth rate/survival? - only in the green house
#Relative growth rate 1-4
#chlorophyl A and B concentration
#gluc_cong, flav_conc
#gm_number of leaves_initial
#gm_leaf_len_initial
#gm_totalleaf_area

#make sure they are all the right classes
str(data)
as.factor(data$population)
as.factor(data$common_garden)
#realtive growth rates, chlorA and B, and gluc and flav data are already numeric
#number of leaves initial and leaf len initial and gm totalleaf area are already integers

#make a dataframe with only the important columns
data2<-data%>%
  select("common_garden", "RGR1", "RGR2", "RGR3", "RGR4", "ChlorA", "ChlorB",
         "gluc_Conc", "flav_Conc", "GM_NumberOfLeaves_Initial", "GM_Leaf_Len_Initial",
         "GM_TotalLeaf_Area")
head(data2)

#male a distance matrix - this is a linear matrix
distance<-dist(data2)
head(distance)
dim(distance)

#turn into a matrix- then do some more strange transformations???
dist_matr<-as.matrix(distance)
pdat<-melt(dist_matr)
head(pdat)
names(pdat)<-c("query", "subject", "distance")
dim(dist_matr)
dim(pdat)

#visualize distance matrix
ggplot(data=pdat, aes(x=query, y=subject, fill=distance)) +
  geom_tile()
2+2
