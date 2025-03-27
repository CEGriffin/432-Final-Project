#set working directory
getwd()

#load libraries
library(dplyr)
library(tidyverse)
library(tidyr)
library(ggplot2)

#load data
data<-read.csv("DataSynthesiscut.csv")

#separate out tag info into different lines

#create new columns to be turned into different aspects of the plant ID, and rename family to population, because theres another column that will actually eb the family
#remove un needed columns
data<-data%>%
  rename(population=Family)%>%
  mutate(petri_dish=Tag) %>%
  mutate(family=Tag) %>%
  mutate(common_garden=Tag)%>%
  select(-c("GM_Fecundity", "Fern", "ThripsDam", "WhiteFungDam", "BlackPathDam", "GM_Leaf_Len_Initial", "GM_NumberOfLeaves_Initial", "GM_Leaf_Number", "treatment", "GA3", "Region", "Latitude", "Longitude", "Altitude"))

#use regex to replace each plant id with only the aspect of the id needed
data$petri_dish<-sub("(\\w?).+","\\1", data$petri_dish)
data$family<-sub("\\w?\\|\\w+-([A-z0-9-]+)\\|.*", "\\1", data$family)
data$common_garden<-sub("\\w?\\|.+\\|(\\w)\\|.+", "\\1", data$common_garden)

#remove maples
data<-subset(data, population!="maple")

#Change data classes
str(data)
data$Tag<-as.factor(data$Tag)
data$petri_dish<-as.factor(data$petri_dish)
data$population<-as.factor(data$population)
data$family<-as.factor(data$family)
data$common_garden<-as.factor(data$common_garden)
data$ID<-as.factor(data$ID)
data$Sample<-as.factor(data$Sample)

#create mortality column
data<-data%>%
  mutate(mortality=Larg_Leaf_Len_Bolt)

data$mortality<-sub("\\d+","1", data$mortality)
data$mortality<-sub("Dead","0", data$mortality)

#impute missing data by replacing NA with means
data<-data%>%
  mutate(RGR1=ifelse(is.na(RGR1),mean(data$RGR1, na.rm=T),RGR1),
         RGR2=ifelse(is.na(RGR2),mean(data$RGR2, na.rm=T),RGR2),
         RGR3=ifelse(is.na(RGR3),mean(data$RGR3, na.rm=T),RGR3),
         RGR4=ifelse(is.na(RGR4),mean(data$RGR4, na.rm=T),RGR4),
         ChlorA=ifelse(is.na(ChlorA),mean(data$ChlorA, na.rm=T),ChlorA),
         ChlorB=ifelse(is.na(ChlorB),mean(data$ChlorB, na.rm=T),ChlorB),
         gluc_Conc=ifelse(is.na(gluc_Conc),mean(data$gluc_Conc, na.rm=T),gluc_Conc),
         flav_Conc=ifelse(is.na(flav_Conc),mean(data$flav_Conc, na.rm=T),flav_Conc),
         GM_Leaf_Len=ifelse(is.na(GM_Leaf_Len),mean(data$GM_Leaf_Len, na.rm=T),GM_Leaf_Len),
         GM_Leaf_Wid=ifelse(is.na(GM_Leaf_Wid),mean(data$GM_Leaf_Wid, na.rm=T),GM_Leaf_Wid),
         GM_TotalLeaf_Area =ifelse(is.na(GM_TotalLeaf_Area),mean(data$GM_TotalLeaf_Area, na.rm=T),GM_TotalLeaf_Area),
         GM_NumberOfLeaves =ifelse(is.na(GM_NumberOfLeaves),mean(data$GM_NumberOfLeaves, na.rm=T),GM_NumberOfLeaves)
)

#Check normality
long_data<-pivot_longer(data, c(8:15, 22:25), names_to="metric", values_to="values")

ggplot(long_data, aes(x=values)) +
  geom_histogram() +
  theme_classic() +
  facet_wrap(~metric, scales="free")

#transform everything to z scores
#DO YOU THINK THIS NEEDS ANY MORE DATA TRANSFORMATIONS, LIKE LOG TRANSFORMS?
#I DIDNT KNOW WHAT TO DO WITH THE COUNT DATA

data<-data%>%
  mutate(z_RGR1=(RGR1-mean(RGR1))/sd(RGR1),
         z_RGR2=(RGR2-mean(RGR2))/sd(RGR2),
         z_RGR3=(RGR3-mean(RGR3))/sd(RGR3),
         z_RGR4=(RGR4-mean(RGR4))/sd(RGR4),
         z_ChlorA=(ChlorA-mean(ChlorA))/sd(ChlorA),
         z_ChlorB=(ChlorB-mean(ChlorB))/sd(ChlorB),
         z_gluc_Conc=(gluc_Conc-mean(gluc_Conc))/sd(gluc_Conc),
         z_flav_Conc=(flav_Conc-mean(flav_Conc))/sd(flav_Conc),
         Z_Leaf_Len=(GM_Leaf_Len-mean(GM_Leaf_Len))/sd(GM_Leaf_Len),
         z_Leaf_Wid=(GM_Leaf_Wid-mean(GM_Leaf_Wid))/sd(GM_Leaf_Wid),
         z_TotalLeaf_Area=(GM_TotalLeaf_Area-mean(GM_TotalLeaf_Area))/sd(GM_TotalLeaf_Area),
         z_NumberOfLeaves=(GM_NumberOfLeaves-mean(GM_NumberOfLeaves))/sd(GM_NumberOfLeaves))

#how does it look after the transformation?
long_data<-pivot_longer(data, starts_with("z_"), names_to="metric", values_to="values")

ggplot(long_data, aes(x=values)) +
  geom_histogram() +
  theme_classic() +
  facet_wrap(~metric, scales="free")


#separate out bolt data
bolt_data<-subset(data, Larg_Leaf_Len_Bolt!="Dead")

bolt_data$Larg_Leaf_Len_Bolt<-as.numeric(bolt_data$Larg_Leaf_Len_Bolt)
bolt_data$Larg_Leaf_Wid_Bolt<-as.numeric(bolt_data$Larg_Leaf_Wid_Bolt)
bolt_data$GM_StemHeight_Bolt<-as.numeric(bolt_data$GM_StemHeight_Bolt)
bolt_data$GM_Leaf_Number_Bolt<-as.numeric(bolt_data$GM_Leaf_Number_Bolt)

head(bolt_data)
#impute NAs
bolt_data<-bolt_data%>%
  mutate(Larg_Leaf_Len_Bolt=ifelse(is.na(Larg_Leaf_Len_Bolt),mean(data$Larg_Leaf_Len_Bolt, na.rm=T),Larg_Leaf_Len_Bolt),
         Larg_Leaf_Wid_Bolt=ifelse(is.na(Larg_Leaf_Wid_Bolt),mean(data$Larg_Leaf_Wid_Bolt, na.rm=T),Larg_Leaf_Wid_Bolt),
         GM_StemHeight_Bolt=ifelse(is.na(GM_StemHeight_Bolt),mean(data$GM_StemHeight_Bolt, na.rm=T),GM_StemHeight_Bolt),
         GM_NumberOfLeaves=ifelse(is.na(GM_NumberOfLeaves),mean(data$GM_NumberOfLeaves, na.rm=T),GM_NumberOfLeaves))

#Select out needed data
data<-select(data, "Tag", "petri_dish", "population", "family", "common_garden", "ID", "gh_bench", "gh_col", "gh_row", "Row_Field", "Col_Field", starts_with("z_"), "mortality")

#bolt data check for normality - needs log transformation
long_bolt_data<-pivot_longer(bolt_data, 18:21, names_to="metric", values_to="values")

ggplot(long_bolt_data, aes(x=values)) +
  geom_histogram() +
  theme_classic() +
  facet_wrap(~metric, scales="free")

#normalize bolt data and log transform
bolt_data<-bolt_data%>%
  mutate(Larg_Leaf_Len_Bolt=log(Larg_Leaf_Len_Bolt),
         Larg_Leaf_Wid_Bolt=log(Larg_Leaf_Wid_Bolt),
         GM_StemHeight_Bolt=log(GM_StemHeight_Bolt),
         GM_Leaf_Number_Bolt=log(GM_Leaf_Number_Bolt))%>%
  mutate(z_log_len_bolt=(Larg_Leaf_Len_Bolt-mean(Larg_Leaf_Len_Bolt))/sd(Larg_Leaf_Len_Bolt),
         z_log_wid_bolt=(Larg_Leaf_Wid_Bolt-mean(Larg_Leaf_Wid_Bolt))/sd(Larg_Leaf_Wid_Bolt),
         z_log_stemheight_bolt=(GM_StemHeight_Bolt-mean(GM_StemHeight_Bolt))/sd(GM_StemHeight_Bolt),
         z_log_leafnumber_bolt=(GM_Leaf_Number_Bolt-mean(GM_Leaf_Number_Bolt))/sd(GM_Leaf_Number_Bolt)) %>%
  select("Tag", "petri_dish", "population", "family", "ID", "gh_bench", "gh_col", "gh_row", "Row_Field", "Col_Field", starts_with("z_"), "mortality")


#check to see if the log transform did anything - looks much better
long_bolt_data<-pivot_longer(bolt_data, ends_with("bolt"), names_to="metric", values_to="values")
ggplot(long_bolt_data, aes(x=values)) +
  geom_histogram() +
  theme_classic() +
  facet_wrap(~metric, scales="free")


#write files into a csv
write.csv(data, file="./normalized_data.csv", row.names=F)
write.csv(bolt_data, file="./normalized_bolt_data.csv", row.names=F)
