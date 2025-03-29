install.packages("remotes")
remotes::install_github("jhelvy/cbcTools")
library(cbcTools)

profiles <- cbc_profiles(
  type = c("burger_classic", "burger_premium", "bundle_classic", "bundle_premium"),
  brand = c("mcdonalds", "burger_king", "max_burger", "wendys"),
  # gram = seq(180, 420, 45),
  # kcal = seq(400, 1100, 115),
  price = seq(12, 40, 1)
)

restricted_profiles <- cbc_restrict(
  profiles,
  (type == "burger_classic" & price >= 20) |
    (type == "burger_premium" & (price <= 20 | price >= 29)) |
    (type == "bundle_classic" & (price <= 22 | price >= 30)) |
    (type == "bundle_premium" & price <= 26)
  
  # (type == "burger_classic" & gram >= 220) |
  #   (type == "burger_premium" & (gram <= 200 | gram >= 400)) |
  #   (type == "bundle_classic" & (gram <= 300 | gram >= 450)) |
  #   (type == "bundle_premium" & gram <= 350),
  
  # (type == "burger_classic" & kcal >= 600) |
  #   (type == "burger_premium" & (kcal <= 500 | kcal >= 800)) |
  #   (type == "bundle_classic" & (kcal <= 700 | kcal >= 1000)) |
  #   (type == "bundle_premium" & kcal <= 800)
)

dim(restricted_profiles)

design_dopt <- cbc_design(
  profiles = restricted_profiles,
  n_resp = 200,
  n_alts = 3,
  n_q = 6,
  n_blocks = 3,
  method = 'dopt',
  no_choice = TRUE
)

design_dopt$type[design_dopt$type_burger_classic == 1] <- "burger_classic"
design_dopt$type[design_dopt$type_burger_premium == 1] <- "burger_premium"
design_dopt$type[design_dopt$type_bundle_classic == 1] <- "bundle_classic"
design_dopt$type[design_dopt$type_bundle_premium == 1] <- "bundle_premium"

design_dopt$kcal <- NA

for (i in 1:nrow(design_dopt)) {
  if (is.na(design_dopt$type[i])) {
    next 
  } else if (design_dopt$type[i] == "burger_classic") {
    design_dopt$kcal[i] <- sample(600:1100, 1)
  } else if (design_dopt$type[i] == "burger_premium") {
    design_dopt$kcal[i] <- sample(c(400:500, 800:1100), 1)
  } else if (design_dopt$type[i] == "bundle_classic") {
    design_dopt$kcal[i] <- sample(c(400:700, 1000:1100), 1)
  } else if (design_dopt$type[i] == "bundle_premium") {
    design_dopt$kcal[i] <- sample(400:800, 1)
  }
}

design_dopt$gram <- NA

for (i in 1:nrow(design_dopt)) {
  if (is.na(design_dopt$type[i])) {
    next 
  } else if (design_dopt$type[i] == "burger_classic") {
    design_dopt$gram[i] <- sample(220:420, 1)
  } else if (design_dopt$type[i] == "burger_premium") {
    design_dopt$gram[i] <- sample(c(180:200, 400:420), 1)
  } else if (design_dopt$type[i] == "bundle_classic") {
    design_dopt$gram[i] <- sample(c(180:300, 400:420), 1)
  } else if (design_dopt$type[i] == "bundle_premium") {
    design_dopt$gram[i] <- sample(180:350, 1)
  }
}

design_dopt$type <- NULL


sim_choices <- cbc_choices(
  design = design_dopt,
  obsID  = "obsID",
  priors = list(
    price = -0.5
  )
)




write.csv(design_dopt, "data/DCE_design.csv")
write.csv(sim_choices, "data/sim_choices_DCE.csv")
