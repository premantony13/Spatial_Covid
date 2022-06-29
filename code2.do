clear all
set more off

use D:\SpatialModel\weights_final3.dta, clear

spmat dta W m*, normalize(row)

spmat summarize W
spmat summarize W, links
spmat summarize W, links detail

import excel "D:\SpatialModel\state_final7.xlsx", sheet("Sheet1") firstrow clear

global id State_code
global t Date_code
global ylist confirm_rate
global xlist  First_dose_pre Second_dose_pre Date_code treated_started treated_since 

* Set data as panel data
sort $id $t
xtset $id $t

xtdescribe
xtsum $id $t $ylist $xlist




* Pooled OLS estimator(SLM)
reg $ylist $xlist
//estat ic -> Akaike’s information criterion (AIC) and the Bayesian information criterion (BIC)
estat ic




//Spatial-AutoRegressive model (SAR)
//SAR with random-effects
xsmle confirm_rate  First_dose_pre Second_dose_pre Date_code treated_started treated_since, wmat(W) model(sar) re vce(cluster State_code) noconstant effects nolog 
estat ic

//Spatial error model (SEM)
//SEM with random-effects
xsmle confirm_rate  First_dose_pre Second_dose_pre Date_code treated_started treated_since, emat(W) model(sem) re vce(cluster State_code) noconstant nolog
estat ic

//Spatial Durbin Model model (SDM)
//SDM with random-effects
xsmle confirm_rate First_dose_pre Second_dose_pre Date_code treated_started treated_since, wmat(W) model(sdm) re vce(cluster State_code) noconstant  effects nolog
estat ic


global id State_code
global t Date_code
global ylist deceased_rate
global xlist First_dose_pre Second_dose_pre Date_code treated_started treated_since

* Set data as panel data
sort $id $t
xtset $id $t

xtdescribe
xtsum $id $t $ylist $xlist




* Pooled OLS estimator(SLM)
reg $ylist $xlist
//estat ic -> Akaike’s information criterion (AIC) and the Bayesian information criterion (BIC)
estat ic


//Spatial-AutoRegressive model (SAR)
//SAR with random-effects
xsmle deceased_rate  First_dose_pre Second_dose_pre Date_code treated_started treated_since, wmat(W) model(sar) re vce(cluster State_cod) noconstant effects nolog
estat ic

//Spatial error model (SEM)
//SEM with random-effects
xsmle deceased_rate  First_dose_pre Second_dose_pre Date_code treated_started treated_since, emat(W) model(sem) re vce(cluster State_cod) noconstant nolog
estat ic

//Spatial Durbin Model model (SDM)
//SDM with random-effects
xsmle deceased_rate  First_dose_pre Second_dose_pre Date_code treated_started treated_since, wmat(W) model(sdm) re vce(cluster State_cod) noconstant effects nolog 
estat ic









