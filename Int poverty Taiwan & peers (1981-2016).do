foreach ccyy in tw81 tw86 tw91 tw95 tw97 tw00 tw05 tw07 tw10 tw13 tw16 jp08 jp10 jp13 kr06 kr08 kr10 kr12 {      
       
* Call data Taiwan       
  use dhi hifactor hpopwgt nhhmem using $`ccyy'h, clear       
  dis "***COUNTRY - `ccyy' ***"      
    
*Genenerate per capita dhi       
  drop if dhi == .      
  drop if dhi<0      
  gen pcdhi = dhi/nhhmem      
  sum pcdhi [w=hpopwgt*nhhmem], de      
      
* CPIs Taiwan from WEO        
gen cpi_tw81 = 57.39      
gen cpi_tw86 = 60.197      
gen cpi_tw91 = 69.464      
gen cpi_tw95 = 80.469      
gen cpi_tw97 = 83.537      
gen cpi_tw00 = 86.095      
gen cpi_tw05 = 88.616      
gen cpi_tw07 = 91.082      
gen cpi_tw10 = 94.431      
gen cpi_tw11 = 95.722      
gen cpi_tw13 = 98.268      
gen cpi_tw16 = 100      
 
gen cpi_jp08 =98.565 
gen cpi_jp10=96.533 
gen cpi_jp11=96.27 
gen cpi_jp13=96.546 
 
gen cpi_kr06 =80.202 
gen cpi_kr08 =86.079 
gen cpi_kr10 = 91.051 
gen cpi_kr11 =94.717 
gen cpi_kr12 =96.789 
   
* PPP & CPI factor      
gen icp2011        =  15.99478497   // PPP 2011   
local cc = substr("`ccyy'",1,2)   // country ISO    
gen cpi2011        = (cpi_`ccyy' /  cpi_`cc'11)      
      
* Poverty lines(daily)      
gen lp_190_2011ppp = 1.9      
gen lp_320_2011ppp = 3.2      
gen lp_550_2011ppp = 5.5      
      
* Formula --> Welfare_ppp = welfare/cpi2011/icp2011/365  (daily income)      
gen pcdhi_2011ppp = pcdhi/cpi2011/icp2011/365      
sum pcdhi_2011ppp [w=hpopwgt*nhhmem], de      
      
gen byte poor_190ppp  =(pcdhi_2011ppp<lp_190_2011ppp)     
gen byte poor_320ppp  =(pcdhi_2011ppp<lp_320_2011ppp)    
gen byte poor_550ppp  =(pcdhi_2011ppp<lp_550_2011ppp)   
       
dis "***Poverty - `ccyy' ***"      
sum poor_190ppp [w=hpopwgt*nhhmem]      
sum poor_320ppp [w=hpopwgt*nhhmem]      
sum poor_550ppp [w=hpopwgt*nhhmem]      
      
}     
