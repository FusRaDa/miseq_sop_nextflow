library(tidyverse)

# Read the file
rarefaction_data <- read_tsv("~/Projects/miseq_sop_nextflow/results/5_analysis/otu/final.opti_mcc.groups.rarefaction")

# Inspect the data
head(rarefaction_data)

# Plot for multiple samples, including confidence intervals
# You may need to reshape your data from a wide to long format first
rarefaction_long <- rarefaction_data %>%
  pivot_longer(
    cols = -c(numsampled),
    names_to = "metric",
    values_to = "value"
  )

# Separate average and CI data for plotting
rarefaction_avg <- rarefaction_long %>% filter(!grepl("lci|hci", metric))
rarefaction_ci <- rarefaction_long %>% filter(grepl("lci", metric)) %>%
  rename(lci = value) %>%
  left_join(rarefaction_long %>% filter(grepl("hci", metric)) %>%
              rename(hci = value)
  ) %>%
  mutate(group = gsub("_lci", "", metric))

# Plot with confidence intervals
ggplot(rarefaction_avg, aes(x = numsampled, y = value, color = metric)) +
  geom_ribbon(data = rarefaction_ci, aes(x = numsampled, ymin = lci, ymax = hci, fill = group), alpha = 0.2, inherit.aes = FALSE) +
  geom_line() +
  labs(
    title = "Rarefaction Curves by Sample",
    x = "Number of Sequences Sampled",
    y = "Number of Observed OTUs"
  ) +
  theme_classic()

