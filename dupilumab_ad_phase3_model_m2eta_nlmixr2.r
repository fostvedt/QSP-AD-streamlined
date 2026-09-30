## ---------------------------------------------------------------------------
## dupilumab_ad_phase3_model4_m2eta_nlmixr2.R
##
## Variant of Model 4 (dupilumab_ad_phase3_model4_nlmixr2.R) that adds the
## between-subject variability on ka and Vm estimated in Model 2 of:
## Kovalenko P, et al. Base and Covariate Population Pharmacokinetic Analyses
## of Dupilumab Using Phase 3 Data. Clin Pharmacol Drug Dev.
## 2020;9(6):756-767. doi:10.1002/cpdd.780
##
## IIV sources (SD of log-parameter, reported as approximate CV):
##   - Vc, ke: Model 4 (Suppl. Table S3): 0.206, 0.293, corr -0.450
##   - ka, Vm: Model 2 (Suppl. Table S2): 0.467, 0.268
##
## This is NOT a published model. In the paper, ka and Vm were fixed after
## Model 2 and carried no IIV in Models 3/4. Model 2 also estimated IIV on
## Vc (0.199) and ke (0.327); the Model 4 values are kept here because they
## were re-estimated on the phase 3 data alongside the covariates. Model 2
## reported no correlations, so the ka and Vm etas are independent of each
## other and of the Vc/ke block. Combining variance components from separate
## fits may overstate total variability.
##
## Structure, fixed effects, covariates, residual error and assumptions
## (reference values, omitted ADA effect, ktr = 4 / MTT) are unchanged from
## dupilumab_ad_phase3_model4_nlmixr2.R.
## ---------------------------------------------------------------------------

library(nlmixr2)

dupilumab_ad_model4_m2eta <- function() {
  ini({
    # Estimated fixed effects (Model 4)
    lvc  <- log(2.74)    ; label("log Vc (L)")
    lke  <- log(0.0477)  ; label("log ke (1/day)")

    # Covariate effects (Model 4)
    vc_wt    <-  0.817   ; label("Vc ~ weight (power)")
    vc_alb   <- -0.653   ; label("Vc ~ albumin (power)")
    ke_bmi   <-  0.368   ; label("ke ~ BMI (power)")
    ke_easi  <-  0.143   ; label("ke ~ EASI (power)")
    ke_white <- -0.123   ; label("ke ~ race White (exponential)")

    # Fixed parameters (fixed in the paper)
    lkcp  <- fix(log(0.211)) ; label("log kcp (1/day)")
    lkpc  <- fix(log(0.310)) ; label("log kpc (1/day)")
    lka   <- fix(log(0.306)) ; label("log ka (1/day)")
    lmtt  <- fix(log(0.105)) ; label("log MTT (day)")
    lvm   <- fix(log(1.07))  ; label("log Vm (mg/L/day)")
    lkm   <- fix(log(0.01))  ; label("log Km (mg/L)")
    lfsc  <- fix(logit(0.642)) ; label("logit F")

    # Model 4 IIV: SDs 0.206 (Vc), 0.293 (ke), correlation -0.450
    eta.vc + eta.ke ~ c(0.042436,
                        -0.027161, 0.085849)

    # Model 2 IIV: SDs 0.467 (ka), 0.268 (Vm); fixed, not re-estimated
    eta.ka ~ fix(0.218089)
    eta.vm ~ fix(0.071824)

    prop.sd <- 0.125     ; label("Proportional residual SD")
    add.sd  <- 6.06      ; label("Additive residual SD (mg/L)")
  })
  model({
    # Reference values hardcoded so rxode2 doesn't treat them as data columns
    vc <- exp(lvc + eta.vc) * (WT / 73)^vc_wt * (ALB / 45)^vc_alb
    ke <- exp(lke + eta.ke) * (BMI / 24.9)^ke_bmi * (EASI / 29.3)^ke_easi *
          exp(ke_white * WHITE)
    kcp <- exp(lkcp)
    kpc <- exp(lkpc)
    ka  <- exp(lka + eta.ka)
    vm  <- exp(lvm + eta.vm)
    km  <- exp(lkm)
    # Monolix convention for 3 transit compartments: ktr = (n + 1) / MTT
    ktr <- 4 / exp(lmtt)

    cp <- central / vc

    d/dt(depot)      <- -ktr * depot
    d/dt(transit1)   <-  ktr * depot    - ktr * transit1
    d/dt(transit2)   <-  ktr * transit1 - ktr * transit2
    d/dt(transit3)   <-  ktr * transit2 - ka  * transit3
    d/dt(central)    <-  ka * transit3 - ke * central - kcp * central +
                         kpc * peripheral - vm * vc * cp / (km + cp)
    d/dt(peripheral) <-  kcp * central - kpc * peripheral

    f(depot) <- expit(lfsc)

    cp ~ add(add.sd) + prop(prop.sd)
  })
}
