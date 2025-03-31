**Dataset Contributors:**

Creators: Kaye, A., McLeod, A., Griffin, C., Gillette, E., Kales M., Sandhu H.

Date of Issue: 2025-03-31

Data Source: Honor, R.D., M. Marcellus, and R.I. Colautti. 2022. Data for the article "Direct and indirect fitness effects of competition limit evolution of allelopathy in an invading plant", Dryad, Dataset

**Data file list:**

*Cluster_tree.R*

*CorrelationMatrix.R*

*DataSynthesis.csv*

*Data_manipulation.R*

*DecisionTree.R*

*Final_Markdown.Rmd*

*PCA.R*

*SuccessfulTree.Rmd*

*normalized_bolt_data.csv*

*normalized_data.csv*

*raw_bolt_data.csv*

*raw_data.csv*

**Variables**

- Tag: Unique barcode for each individual plant. The section before the "|" indicates the petri dish the plant germinated on, after the "|" indicates the genetic family of the plant, after the second "|", reflects whether the parent family was grown in a common garden in Vancouver (V), at Queen's University (Q), or came from a seed from the original population (N). After the last "|" is a unique identifier for the plant.

The following five variables are just the different components of “Tag” expanded into their own columns: 

  - petri_dish: The petri dish on which the plant seed germinated

  - population: Genetic population of the plant

  - family: Genetic family of the plant

  - common_garden: where the parent plant was grown (V = Vancouver, Q = Queen’s, N = natural population)

  - ID: Unique identifier for the plant

- ChlorA: Chlorophyll A concentration (micrograms/ml)

- ChlorB: Chlorophyll B concentration (micrograms/ml)

- gluc_Conc: Glucosinolate concentration (mg/ml)

- flav_Conc: Flavonoid concentration (mg/ml)

- GM_Leaf_Len: leaf length (mm)

- GM_Leaf_Wid: leaf width (mm)

- GM_TotalLeaf_Area: summation of leaf area (mm^2)

- GM_NumberOfLeaves: Number of true leaves on the plant at a specific time

- Larg_Leaf_Len_Bolt: length of the largest leaf (cm) at “bolt” growth stage. A "d" indicates that the plant has died.

- Larg_Leaf_Wid_Bolt: width of the largest leaf (cm) at “bolt” growth stage

- GM_StemHeight_Bolt: stem height of the bolt (cm) at “bolt” growth stage

- GM_Leaf_Number_Bolt: number of leaves on the plant at “bolt” growth stage

- RGR1 - RGR4: Calculated by comparing the log rosette size from two different time periods. Rosette size was measured every two weeks over a two-day period. The first census was on May 27-28, and the fourth was six weeks after. Relative growth rate 1 was calculated by comparing census 1 (May 27-28) and census 2 (June 11-12). 

**Data Manipulation**

Run DataSynthesis.r as provided by Colautti et al. (2023), which produces DataSynthesis.csv

- Use Regex to separate out the Tag column into its various components (petri dish, population, family, common garden, and ID)

- Filter out maple observation, observations for which the Tag data is incomplete, and unneeded columns (keep the ones listed above)

- Create a column called “mortality”, and assign a 1 or 0 based on the data from one of the “bolt” columns

- Subset a dataframe called bolt data, for which there are numerical observations in the “bolt” columns

- Impute the missing data in the numerical columns by replacing NA with the mean of the column

- Write two csv files called raw_data.csv and raw_bolt_data.csv

- Check both datasets for normality in numeric variables via histogram and qq plots with ggplot

- Log transform when applicable, and convert to z-scores

- Write two csv files called normalized_data.csv and normalized_bolt_data.csv

**Correlation Matrix**

Run CorrelationMatrix.R :

- Selects only numeric variable columns (greenhouse measurements) to create a correlation matrix.

**Principal Component Analysis PCA**

Run the PCA.R file:

- Pulls the .csv files created in the Data Manipulation step from GitHub 

- Removes columns not relevant for a PCA (e.g. categorical variables, unique identifiers, etc.) 

- Creates a scree plot to evaluate the components. 

- Combines the PCA scores with the original data frame to create a new dataframe for plotting in ggplot. 

- Creates bi-variate plots comparing the PC components; the data points are colour-coded by genetic population and have different shapes corresponding to their respective “common_garden” categories. 

- Two PCAs are run, once on the normalized_data.csv and another on the normalized_bolt_data.csv. 

**Decision Trees**

Run the DecisionTree.R file: 

- Removes unneeded columns, use only columns with numerical data

- Keeps only rows where common garden is Q, N, or V

- Sets up a data frame to remove bolt data

- Creates a matrix to check covariance

- Separate into testing and training datasets (50:50 split)

- Makes a tree using the tree() function from the tree library; prune the nodes for 8 tips using the “best=” parameter
  
- Makes a second decision tree following the steps noted by downsampling the Queen’s University (Q) samples in the common_garden vector to account for fewer Vancouver samples. 

  - Set seed (100) for reproducibility

- Makes a third  decision tree with only plants that survive (mortality column == 1), with no downsampling

- Makes a final decision tree with only plants that survive (mortality column == 1) with downsampling of the Queen’s University (Q) samples in the  common_garden vector:

  - Set set (100) for reproducibility

For all trees, this code will create a confusion matrix: 

  - Sets up confusion matrix type=class

  - Display as a table of observed vs predicted

  - Calculates the misclassification rate and checks that missclass and correct class values combine to equal 1

**Distance Matrix and Cluster Trees**

Run the Cluster_tree.R file:

- Loads the normalized_data.csv from GitHub 

- Creates a new list object with unique names using the Tag column 

- Assigns new row names using the new unique names list object 

- Creates a distance matrix using euclidean distance using all the samples 

- Creates a cluster tree using ggplot and colours each branch by its genetic population (there are lines of regex to turn the unique identifier row name into just the population) 

- Regex is also used to extract just the common garden from the unique row names to colour-code the branches in a second cluster tree

- Lastly, the data is subsetted into population-level data (summarizes the mean values for all the parameters for each genetic population) 

- Melts the second distance (euclidean) matrix into a molten data frame and visualizes the matrix using geom_tile() in ggplot

- Creates a cluster tree at the population-level to show if the distinct genetic populations show clustering based on plant growth/success traits. 
