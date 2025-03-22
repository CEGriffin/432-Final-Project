Variables:
Tag: Unique barcode for each individual plant. The section before the "|" indicates the petri dish the plant germinated on, after the "|" indicates the genetic family of the plant, after the second "|", reflects whether the parent family was grown in a common garden in Vancouver (V), at Queen's University (Q), or came from a seed from the original population (N).After the last "|" is a unique identifier for the plant.
The next 5 variables are just the different components of “Tag” expanded into their own columns
petri_dish

Family: just the letter string plus the attached number

family2: same, but with the numbers and dashes

common_garden

ID

Treatment: The treatment of the plant "a" = alone, "m" = maple/interspecific treatment, "g" = garlic mustard/intraspecific treatment

gh_bench: greenhouse bench on which the plant was located

gh_col: greenhouse columns within the greenhouse bench on which the plant was located

gh_row: greenhouse row within the greenhouse bench on which the plant was located

sample: The specific ID of the sample- applies to the Chlorophyl, gluc, and flav data - some of the individual plants are represented twice in different samples. Sample ID includes the unique Identifier for each plant and a _1 or _2

ChlorA: Chlorophyll A concentration- Check with colautti- units, what is a pool sample, was this data transformed in any way?

ChlorB: Chlorophyll B concentration - ask colautti the same Q as above

gluc_Conc: Glucosinolate concentration - ask colautti the same Q as above

flav_Conc: Flavonoid concentration - ask colautti the same Q as above

GM_Leaf_Len_Initial: Ask colautti, I dont know why this is different from “GM_Leaf_number”
some of the GM plants were hole punched- ask colautti which ones

GM_NumberOfLeaves_Initial: variable never explained

GM_Leaf_Number: specific leaf on each individual plant, refers to the leaves measured below

GM_Leaf_Len: leaf length (mm)

GM_Leaf_Wid: size of lead (mm)- ask colautti, I assume this is supposed to be width?

GM_TotalLeaf_Area: Again never explained

GM_NumberOfLeaves: never explained

Fern:how many ferns growing in the pot

ThripsDam: thrips damage on leaf (count)

WhiteFungDam: Presence of white fungal damage on the leaf (i think this is supposed to be a count?)

BlackPathDam: black pathogen damage on leaf (count)

Region: The location of the parent population (North america or europe)

Latitude: the latitude of the parent population

Longitude: the longitude of the parent population

Altitude: the altitude of the parent population

Row_Field: Row that the plant was located in in the field

Col_Field: Column that the plant was located in in the field

Larg_Leaf_Len_Bolt: length of the largest leaf (cm). A "d" indicates that the plant has died.
ask colautti what bolt means

Larg_Leaf_Wid_Bolt: width of the largest leaf (cm)

GM_StemHeight_Bolt: stem height of the bolt (cm)

GM_Leaf_Number_Bolt: number of leaves on the plant

RGR1 - RGR4: Relative growth rates measurements, 1-4

GM_fecundity: this is not explained, ask coulautti
