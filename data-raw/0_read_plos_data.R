# 0_read_plos_data.R
# code to read and clean arthritis data from PLOS
# https://figshare.com/articles/dataset/Impact_of_lower_limb_osteoarthritis_on_health-related_quality_of_life_A_cross-sectional_study_to_estimate_the_expressed_loss_of_utility_in_the_Spanish_population/11713572
# December 2020

set.seed(4040) # for random sample

arthritis = read_excel('data/pone.0228398.s001.xls') %>%
  clean_names() %>%
  rename('EQ5D_VAS' = 'eva_eq', # rename for consistency with other data sets
         'EQ5D' = 'utilities') %>%
  mutate(EQ5D_VAS =EQ5D_VAS / 100) %>% # scale to [0,1]
  select(sex, age, EQ5D_VAS, EQ5D) %>%
  tidyr::drop_na() %>%
  sample_n(size=1000, replace=FALSE) # smaller sample to run examples faster

# change one level
arthritis = mutate(arthritis,
                   age = ifelse(age=='85 o mÃ¡s', '85+', age))
