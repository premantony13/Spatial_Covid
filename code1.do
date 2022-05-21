clear all
set more off

use D:\SpatialModel\weights_final3.dta, clear

spmat dta W m*, normalize(row)

spmat summarize W
spmat summarize W, links
spmat summarize W, links detail

import excel "D:\SpatialModel\state_final1.xlsx", sheet("Sheet1") firstrow clear

global id State_code
global t Date_code
global ylist confirm_rate
global xlist recovered_rate deceased_rate First_dose_pre Second_dose_pre

* Set data as panel data
sort $id $t
xtset $id $t

xtdescribe
xtsum $id $t $ylist $xlist



import excel "D:\SpatialModel\Train.xlsx", sheet("Sheet1") firstrow clear
global id State_code
global t Date_code
global ylist confirm_rate
global xlist recovered_rate deceased_rate First_dose_pre Second_dose_pre
sort $id $t
xtset $id $t

* Pooled OLS estimator(SLM)
reg $ylist $xlist
//estat ic -> Akaike’s information criterion (AIC) and the Bayesian information criterion (BIC)
estat ic


import excel "D:\SpatialModel\Test.xlsx", sheet("Sheet1") firstrow clear
global id State_code
global t Date_code
global ylist confirm_rate
global xlist recovered_rate deceased_rate First_dose_pre Second_dose_pre
sort $id $t
xtset $id $t

display e(rmse)
	
predict yhat 	

gen resid=confirm_rate-yhat
gen resid2=resid^2

sum resid2
display sqrt(  2.47e-09)

//Spatial-AutoRegressive model (SAR)
//SAR with random-effects
xsmle confirm_rate recovered_rate deceased_rate First_dose_pre Second_dose_pre, wmat(W) model(sar) re  effects nolog
estat ic

//Spatial error model (SEM)
//SEM with random-effects
xsmle confirm_rate recovered_rate deceased_rate First_dose_pre Second_dose_pre, emat(W) model(sem) re vce(cluster State_cod) nolog
estat ic

//Spatial Durbin Model model (SDM)
//SDM with random-effects
xsmle confirm_rate recovered_rate deceased_rate First_dose_pre Second_dose_pre, wmat(W) model(sdm) re vce(cluster State_cod) nolog 
estat ic


//Spatial-AutoRegressive model (SAR)
//SAR with random-effects
xsmle confirm_rate recovered_rate deceased_rate First_Dose Second_Dose, wmat(W) model(sar) re  effects nolog
estat ic

//Spatial error model (SEM)
//SEM with random-effects
xsmle confirm_rate recovered_rate  First_Dose , emat(W) model(sem) re vce(cluster State_cod) nolog
estat ic

//Spatial Durbin Model model (SDM)
//SDM with random-effects
xsmle confirm_rate recovered_rate  First_Dose , wmat(W) model(sdm) re vce(cluster State_cod) nolog
estat ic

//Generalised Spatial Random Effects model (GSPRE)
//GSPRE with random-effects
xsmle confirm_rate recovered_rate deceased_rate First_Dose Second_Dose, wmat(W) emat(W) model(gspre) re vce(cluster State_cod) nolog
estat ic














//Spatial-AutoRegressive model (SAR)
//SAR with random-effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sar) re  effects nolog
estat ic
//SAR with spatial fixed-effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sar) fe type(ind) vce(cluster State_cod) nolog
estat ic
//SAR with spatial fixed-effects [data transformed according to Lee and Yu (2010)]
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sar) fe type(ind, leeyu) vce(cluster State_cod) nolog
estat ic
//SAR with time fixed-effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sar) fe type(time) vce(cluster State_cod) nolog
estat ic
//SAR with spatial and time fixed-effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sar) fe type(both) vce(cluster State_cod) nolog
estat ic
//SAR without direct, indirect and total effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sar) noeffects vce(cluster State_cod) nolog
estat ic
//SAR Hausman test
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sar) hausman nolog


//Spatial error model (SEM)
//SEM with random-effects
xsmle confirm_rate recovered_rate deceased_rate, emat(W) model(sem) re vce(cluster State_cod) nolog
estat ic
//SEM with spatial fixed-effects
xsmle confirm_rate recovered_rate deceased_rate, emat(W) model(sem) fe type(ind) vce(cluster State_cod) nolog
estat ic
//SEM with spatial fixed-effects [data transformed according to Lee and Yu (2010)] 
xsmle confirm_rate recovered_rate deceased_rate, emat(W) model(sem) fe type(ind, leeyu) vce(cluster State_cod) nolog
estat ic
//SEM with time fixed-effects
xsmle confirm_rate recovered_rate deceased_rate, emat(W) model(sem) fe type(time) vce(cluster State_cod) nolog
estat ic
//SEM with spatial and time fixed-effects
xsmle confirm_rate recovered_rate deceased_rate, emat(W) model(sem) fe type(both) vce(cluster State_cod) nolog
estat ic
//SEM without direct, indirect and total effects
xsmle confirm_rate recovered_rate deceased_rate, emat(W) model(sem) noeffects vce(cluster State_cod) nolog
//SEM Hausman test
xsmle Cconfirm_rate recovered_rate deceased_rate, emat(W) model(sem) hausman nolog







//Spatial Durbin Model model (SDM)
//SDM with random-effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sdm) re vce(cluster State_cod) nolog
estat ic

xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sdm) re vce(cluster State_cod) nolog effects

//SDM with spatial fixed-effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sdm) fe type(ind) vce(cluster State_cod) nolog effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sdm) fe type(both) vce(cluster State_cod) nolog effects
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sdm) fe type(both) vce(cluster State_cod) nolog effects e(b) hausman
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sdm) fe type(both) vce(cluster State_cod) nolog effects dlag(3) e(b)

//SDM with spatial fixed-effects [data transformed according to Lee and Yu (2010)]
xsmle confirm_rate recovered_rate deceased_rate, wmat(W) model(sdm) fe type(ind, leeyu) vce(cluster State_cod) nolog effects
estat ic
//SDM with time fixed-effects
xsmle Confirmed Recovered Deceased, wmat(W) model(sdm) fe type(time) vce(cluster State_cod) nolog
estat ic
//SDM with spatial and time fixed-effects
xsmle Confirmed Recovered Deceased, wmat(W) model(sdm) fe type(both) vce(cluster State_cod) nolog
estat ic
//SDM without direct, indirect and total effects
xsmle Confirmed Recovered Deceased, wmat(W) model(sdm) noeffects nolog
estat ic
//testing the appropriateness of a random-effects variant using the Robust Hausman test 
//(example: if Prob>=chi2 = 0.0000 -> p-value lower than one percent -> we strongly reject the null hypothesis -> use fixed-effects)
//SDM Hausman test
xsmle Confirmed Recovered Deceased, wmat(W) model(sdm) hausman nolog


//Spatial error model (SEM)
//SEM with random-effects
xsmle Confirmed Recovered Deceased, emat(W) model(sem) re vce(cluster State_cod) nolog
estat ic
//SEM with spatial fixed-effects
xsmle Confirmed Recovered Deceased, emat(W) model(sem) fe type(ind) vce(cluster State_cod) nolog
estat ic
//SEM with spatial fixed-effects [data transformed according to Lee and Yu (2010)] 
xsmle Confirmed Recovered Deceased, emat(W) model(sem) fe type(ind, leeyu) vce(cluster State_cod) nolog
estat ic
//SEM with time fixed-effects
xsmle Confirmed Recovered Deceased, emat(W) model(sem) fe type(time) vce(cluster State_cod) nolog
estat ic
//SEM with spatial and time fixed-effects
xsmle Confirmed Recovered Deceased, emat(W) model(sem) fe type(both) vce(cluster State_cod) nolog
estat ic
//SEM without direct, indirect and total effects
xsmle Confirmed Recovered Deceased, emat(W) model(sem) noeffects vce(cluster State_cod) nolog
//SEM Hausman test
xsmle Confirmed Recovered Deceased, emat(W) model(sem) hausman nolog

//Spatial-Autoregressive with Spatially Autocorrelated Errors model (SAC) (also known as the SARAR model or Kelejian-Prucha model)
//SAC with spatial fixed-effects
xsmle Confirmed Recovered Deceased, wmat(W) emat(W) model(sac) fe type(ind) vce(cluster State_cod) nolog
estat ic
//SAC with spatial fixed-effects [data transformed according to Lee and Yu (2010)]
xsmle Confirmed Recovered Deceased, wmat(W) emat(W) model(sac) fe type(ind, leeyu) vce(cluster State_cod) nolog
estat ic
//SAC with time fixed-effects
xsmle Confirmed Recovered Deceased, wmat(W) emat(W) model(sac) fe type(time) vce(cluster State_cod) nolog
estat ic
//SAC with spatial and time fixed-effects
xsmle Confirmed Recovered Deceased, wmat(W) emat(W) model(sac) fe type(both) vce(cluster State_cod) nolog
estat ic

//Generalised Spatial Random Effects model (GSPRE)
//GSPRE with random-effects
xsmle Confirmed Recovered Deceased, wmat(W) emat(W) model(gspre) re vce(cluster State_cod) nolog
estat ic
//GSPRE without direct, indirect and total effects
xsmle Confirmed Recovered Deceased, wmat(W) emat(W) model(gspre) noeffects vce(cluster State_cod) nolog
estat ic

//Model selection:
//1) Estimate SDM
xsmle Confirmed Recovered Deceased, wmat(W) model(sdm) fe type(ind) nolog
estimates store sdm_fe
//2) Testing for SAR
test [Wx]Recovered = [Wx]Deceased = 0
//Example:
//chi2(8) = 2279.02
//Prob > chi2 = 0.0000
//-> in this case we strongly reject the null hypothesis, with a p-value lower than one percent.
//-> Use SDM
//3) Testing for SEM
testnl ([Wx]Recovered = -[Spatial]rho*[Main]Recovered) ([Wx]Deceased = -[Spatial]rho*[Main]Deceased)
//Example:
//chi2(8) = 1358.09
//Prob > chi2 = 0.0000
//-> in this case we strongly reject the null hypothesis, with a p-value lower than one percent.
//-> Use SDM
//4) SAC vs SDM
// information criteria to test the most appropriate model: AIC and BIC
//5) GSPRE vs SAC
//AIC and BIC
