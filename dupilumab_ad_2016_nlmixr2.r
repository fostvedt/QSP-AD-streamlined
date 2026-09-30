# Simulate dupilumab trough concentrations from the atopic dermatitis popPK
# model (Kovalenko et al., CPT:PSP 2016; doi:10.1002/psp4.12136) and compare
# with published values.

# Model (final estimates, BLQ data included) ----------------------------------

dupilumab_pk <- function() {
  ini({
    lv2  <- log(2.74)    ; label("log V2 (L) at 75 kg")
    lke  <- log(0.0459)  ; label("log ke (1/day)")
    lk23 <- log(0.0652)  ; label("log k23 (1/day)")
    lk32 <- log(0.129)   ; label("log k32 (1/day)")
    lka  <- log(0.254)   ; label("log ka (1/day)")
    lvm  <- log(0.968)   ; label("log Vm (mg/L/day)")
    km   <- fix(0.01)    ; label("Km (mg/L)")
    lfdepot <- logit(0.607) ; label("logit SC bioavailability")
    wt_v2 <- 0.705       ; label("Weight exponent on V2")

    eta.v2 ~ 0.0225
    eta.ke ~ 0.131
    eta.ka ~ 0.251
    eta.vm ~ 0.0428

    # Interpreted as proportional SD (24.2% CV)
    prop.sd <- 0.242     ; label("Proportional residual SD")
    add.sd  <- fix(0.03) ; label("Additive residual SD (mg/L)")
  })
  model({
    v2  <- exp(lv2 + eta.v2) * (WT / 75)^wt_v2
    ke  <- exp(lke + eta.ke)
    k23 <- exp(lk23)
    k32 <- exp(lk32)
    ka  <- exp(lka + eta.ka)
    vm  <- exp(lvm + eta.vm)
    fdepot <- expit(lfdepot)

    cp <- central / v2

    d/dt(depot)      <- -ka * depot
    d/dt(central)    <-  ka * depot - ke * central - k23 * central +
                         k32 * peripheral - vm * v2 * cp / (km + cp)
    d/dt(peripheral) <-  k23 * central - k32 * peripheral

    f(depot) <- fdepot

    cp ~ add(add.sd) + prop(prop.sd) + combined2()
  })
}

#mod <- nlmixr2(dupilumab_pk)