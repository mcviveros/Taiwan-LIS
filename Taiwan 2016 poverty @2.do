/*******************************************************************************
Project:  Estimate relative poverty (LIS) & $1.9 day poverty (WB) - Taiwan 2016
Author:   Martha Viveros
Date:     11/20/2019
*******************************************************************************/

/*******************************************************************************
                I -  Relative Poverty 50% (LIS methodology)
*******************************************************************************/
* Call data Taiwan 2016
use dhi hifactor hpub_i hpub_u hpub_a hiprivate hxitsc hpopwgt nhhmem grossnet using $tw16h, clear 

* Clean missings
gen miss_comp = 0 
quietly replace miss_comp=1 if dhi==. | hifactor==. | hi33==. | hpub_i==. | hpub_u==. | hpub_a==. | hiprivate==. | hxitsc==. 
quietly drop if miss_comp==1 
sum dhi [w=hpopwgt], de 

* Equivalent income
gen     edhi_b = dhi
replace edhi_b = 0 if dhi<0 
replace edhi_b = (edhi_b/(nhhmem^0.5)) 

* Define relative poverty line (40%, 50% & 60% of the mean income)
qui sum edhi_b [w=hpopwgt*nhhmem], de 
gen povline40 = r(p50)*0.4 
gen povline50 = r(p50)*0.5
gen povline60 = r(p50)*0.6

* Flag poor
quietly gen byte poor40=(edhi_b<povline40) 
quietly gen byte poor50=(edhi_b<povline50) 
quietly gen byte poor60=(edhi_b<povline60) 

* Estimate relative poverty
sum poor40 [w=hpopwgt*nhhmem]   // 0.0528647
sum poor50 [w=hpopwgt*nhhmem]   // 0.099576
sum poor60 [w=hpopwgt*nhhmem]   // 0.1595432

* Inequality
ineqdec0 edhi_b [w=hpopwgt*nhhmem] 


	
/*******************************************************************************
                 II-     WB Methodology - $1.9 a day 2011 PPP
*******************************************************************************/
*Genenerate per capita dhi 
  drop if dhi<0
  gen pcdhi = dhi/nhhmem
  sum pcdhi [w=hpopwgt*nhhmem], de

* CPIs Taiwan from WEO  
local cpi_81 = 57.39
local cpi_86 = 60.197
local cpi_91 = 69.464
local cpi_95 = 80.469
local cpi_97 = 83.537
local cpi_00 = 86.095
local cpi_05 = 88.616
local cpi_07 = 91.082
local cpi_10 = 94.431
local cpi_11 = 95.722
local cpi_13 = 98.268
local cpi_16 = 100

* Poverty lines
gen lp_190_2011ppp = 1.9
gen lp_320_2011ppp = 3.2
gen lp_550_2011ppp = 5.5

* PPP & CPI factor
gen icp2011        =  15.99478497   // PPP 2011
gen cpi2011        = (`cpi_16' /  `cpi_11')

* Formula --> Welfare_ppp = welfare/cpi2011/icp2011/365  (daily income)
gen pcdhi_2011ppp     = pcdhi/cpi2011/icp2011/365
sum pcdhi_2011ppp [w=hpopwgt*nhhmem], de

gen byte poor_190ppp  =(pcdhi_2011ppp<lp_190_2011ppp)
gen byte poor_320ppp  =(pcdhi_2011ppp<lp_320_2011ppp)
gen byte poor_550ppp  =(pcdhi_2011ppp<lp_550_2011ppp)
 
sum poor_190ppp [w=hpopwgt*nhhmem]
sum poor_320ppp [w=hpopwgt*nhhmem]
sum poor_550ppp [w=hpopwgt*nhhmem]


* END OF FILE