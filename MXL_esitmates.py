import pylogit as pl
import pandas as pd
import numpy as np
from collections import OrderedDict

data = pd.read_csv('data/sim_choices_DCE.csv')
data = data.sort_values(by=["qID", "altID"])

choice_column = "choice"
alt_id_column = "altID"
obs_id_column = "qID"
ind_vars = [
    "price", "gram", "kcal",
    "type_burger_classic", "type_burger_premium", "type_bundle_classic", "type_bundle_premium",
    "brand_mcdonalds", "brand_burger_king", "brand_max_burger", "brand_wendys"
]

specification = OrderedDict({
    "price": "all_diff",  # Price differs across alternatives
    "gram": "all_diff",   # Gram differs across alternatives
    "kcal": "all_diff",   # kcal differs across alternatives
    "type_burger_classic": "all_diff",  # Type burger classic differs across alternatives
    "type_burger_premium": "all_diff",  # Type burger premium differs across alternatives
    "type_bundle_classic": "all_diff",  # Type bundle classic differs across alternatives
    "type_bundle_premium": "all_diff",  # Type bundle premium differs across alternatives
    "brand_mcdonalds": "all_diff",  # Brand mcdonalds differs across alternatives
    "brand_burger_king": "all_diff",  # Brand burger king differs across alternatives
    "brand_max_burger": "all_diff",  # Brand max burger differs across alternatives
    "brand_wendys": "all_diff"  # Brand wendys differs across alternatives
})

names = OrderedDict({
    "price": ["price", "price", "price", "price"],
    "gram": ["gram", "gram", "gram", "gram"],
    "kcal": ["kcal", "kcal", "kcal", "kcal"],
    "brand_mcdonalds": ["brand_mcdonalds", "brand_mcdonalds", "brand_mcdonalds", "brand_mcdonalds"],
    "brand_burger_king": ["brand_burger_king", "brand_burger_king", "brand_burger_king", "brand_burger_king"],
    "brand_max_burger": ["brand_max_burger", "brand_max_burger", "brand_max_burger", "brand_max_burger"],
    "brand_wendys": ["brand_wendys", "brand_wendys", "brand_wendys", "brand_wendys"],
    "type_burger_classic": ["type_burger_classic", "type_burger_classic", "type_burger_classic", "type_burger_classic"],
    "type_burger_premium": ["type_burger_premium", "type_burger_premium", "type_burger_premium", "type_burger_premium"],
    "type_bundle_classic": ["type_bundle_classic", "type_bundle_classic", "type_bundle_classic", "type_bundle_classic"],
    "type_bundle_premium": ["type_bundle_premium", "type_bundle_premium", "type_bundle_premium", "type_bundle_premium"]
})

rand_vars = {
    "price": "n",  # Random coefficient for price
    "gram": "n",   # Random coefficient for gram
    "kcal": "n",   # Random coefficient for kcal
    "brand_mcdonalds": "n",  # Random coefficient for brand_mcdonalds
    "brand_burger_king": "n",  # Random coefficient for brand_burger_king
    "brand_max_burger": "n",  # Random coefficient for brand_max_burger
    "brand_wendys": "n",  # Random coefficient for brand_wendys
    "type_burger_classic": "n",  # Random coefficient for type_burger_classic
    "type_burger_premium": "n",  # Random coefficient for type_burger_premium
    "type_bundle_classic": "n",  # Random coefficient for type_bundle_classic
    "type_bundle_premium": "n"  # Random coefficient for type_bundle_premium
}

mxl_model = pl.create_choice_model(
    data=data,
    alt_id_col=alt_id_column,
    obs_id_col=obs_id_column,
    choice_col=choice_column,
    specification=specification,
    model_type="Mixed Logit",
    names=names,
    mixing_id_col="respID",
    mixing_vars=rand_vars
)

mxl_model.fit_mle(
    init_vals=np.zeros(55),
    num_draws=500,
    seed=12345,
)

# Output the results
print(mxl_model.get_stats())
