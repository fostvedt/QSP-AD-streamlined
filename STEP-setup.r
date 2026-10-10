################################
# ACoP 2026 STEP Tutorial
# Title: Hybrid Modeling
# Chairs: Min Hai, Bovornpat Suriyapakorn, Luke Fostvedt
# Instructors: Luke Fostvedt, Blerta Shtylla, Nastya Kassir, Kapil Gadkar
# Materials and code available on github
# github.com/fostvedt/STEP2026
#
# Setup script for the Miyano QSP model to run using nlmixr2
# Luke Fostvedt October 10, 2026
# Need to set up the environment usign the r-universe repo. CRAN is not updated with nlmixr2lib
# This setup is for R 4.6.1 -- requires R 4.5.3 or later
# needs more than 4 gb of RAM for setup
install.packages("nlmixr2", repos = c("https://nlmixr2.r-universe.dev", getOption("repos")))
install.packages("nlmixr2lib", repos = c("https://nlmixr2.r-universe.dev", getOption("repos")))
install.packages("tidyverse")

library(nlmixr2)
library(nlmixr2lib)
library(rxode2)
library(dplyr)
library(ggplot2)
library(tibble)
library(purrr)
library(mvtnorm)

# If the following 3 lines of code run then the session should be able to run the 
# tutorial code
mod <- readModelDb("Miyano_2022_atopicDermatitis_qsp")
mod_typ <- mod |> rxode2::zeroRe()
readModelDb("Miyano_2022_atopicDermatitis_qsp")()$population


#### packages in the posit.cloud session October 15th, 2026.

#attached base packages:
#[1] stats     graphics  grDevices utils     datasets  methods   base     
#
#other attached packages:
# [1] nlmixr2plot_5.1.0     nlmixr2extra_5.2.0    nlmixr2est_7.0.2      nlmixr2save_0.2.0    
# [5] nlmixr2data_2.0.10    lotri_1.0.5           nlmixr2_7.0.1         mvtnorm_1.3-7        
# [9] purrr_1.2.2           tibble_3.3.1          ggplot2_4.0.3         dplyr_1.2.1          
#[13] rxode2_5.1.8          nlmixr2lib_0.3.2.9000
#
#loaded via a namespace (and not attached):
# [1] utf8_1.2.6          generics_0.1.4      renv_1.2.2          lattice_0.22-9     
# [5] digest_0.6.39       magrittr_2.0.5      evaluate_1.0.5      grid_4.5.3         
# [9] RColorBrewer_1.1-3  fastmap_1.2.0       rxode2ll_2.0.18     backports_1.5.1    
#[13] scales_1.4.0        textshaping_1.0.5   cli_3.6.6           rlang_1.3.0        
#[17] symengine_0.2.13    crayon_1.5.3        withr_3.0.3         cachem_1.1.0       
#[21] tools_4.5.3         lbfgsb3c_2024-3.5   memoise_2.0.1       checkmate_2.3.4    
#[25] rxode2lincmt_0.1.0  n1qn1_6.0.1-14      forcats_1.0.1       vctrs_0.7.3        
#[29] R6_2.6.1            lifecycle_1.0.5     MASS_7.3-65         clisymbols_1.2.0   
#[33] PreciseSums_0.7     ragg_1.5.2          pkgconfig_2.0.3     rex_1.2.2          
#[37] pillar_1.11.1       gtable_0.3.6        data.table_1.18.6.1 glue_1.8.1         
#[41] Rcpp_1.1.2          systemfonts_1.3.2   xfun_0.60           tidyselect_1.2.1   
#[45] rstudioapi_0.18.0   sys_3.4.3           knitr_1.52          farver_2.1.2       
#[49] dparser_1.3.1-13    nlme_3.1-168        labeling_0.4.3      compiler_4.5.3     
#[53] S7_0.2.2      