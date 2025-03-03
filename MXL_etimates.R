install.packages("mlogit")
install.packages("data.table")
install.packages("dplyr")

library(mlogit)
library(data.table)
library(dplyr)

# Load the dataset
data <- fread("data/sim_choices_DCE.csv")

data[, choice := as.logical(choice)]

mlogit_data <- dfidx(
  data,
  choice = "choice",
  idx = list(
    c("respID", "qID"),  # Unique identifier: respondent + question + alternative
    "altID"                        # Alternative ID within the choice situation
  ),
  idvar = "respID",      # Panel structure (respondent ID)
  drop.index = T
)


# Check the data structure
head(mlogit_data)

# Estimate the Mixed Logit Model
mxl_model <- mlogit(
  choice ~ price + 
    gram + 
    kcal + 
    brand_mcdonalds + 
    brand_burger_king + 
    brand_max_burger + 
    brand_wendys +
    type_burger_classic + 
    type_burger_premium + 
    type_bundle_classic + 
    type_bundle_premium | 0,
  data = mlogit_data,
  rpar = c(
    price = "n", gram = "n", kcal = "n",
    brand_mcdonalds = "n", brand_burger_king = "n", brand_max_burger = "n", brand_wendys = "n"
  ),
  panel = TRUE,
  R = 100,
  halton = NA
)


# Display summary
summary(mxl_model)
