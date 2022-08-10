# Precompiled vignettes that depend on API key -------------------------------
# If vignette contains images, must manually move image files
# from cbioportalR/ to cbioportalR/vignettes/ after knit
#
# Source: https://ropensci.org/blog/2019/12/08/precompute-vignettes/

library(knitr)
knit("vignettes/overview-of-workflow.Rmd.orig", "vignettes/overview-of-workflow.Rmd")
