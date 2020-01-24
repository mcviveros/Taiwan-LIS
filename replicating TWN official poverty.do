use dhi hifactor hpopwgt nhhmem region_c using $tw16h, clear    
    
* population    
  gen u = 1   
  sum u [w=hpopwgt*nhhmem]   
   
* Genenerate annual per capita dhi              
 drop if dhi == .             
 drop if dhi<0             
 gen pcdhi = dhi/nhhmem             
 sum pcdhi [w=hpopwgt*nhhmem]            
             
* Generate monhtly pc disp. income   
   gen pcdhi_m = pcdhi/12   
   sum pcdhi_m [w=hpopwgt*nhhmem]   
   
* Define Poverty lines (Taiwan BL)   
   gen     pv2015 = 10869*0.6
   replace pv2015 = (14794*0.6) if region_c == 1  //Taipei city
   replace pv2015 = (12485*0.6) if region_c == 64 //Kaohsiung city 
   replace pv2015 = (12840*0.6) if region_c == 65 //New Taipei city 
   replace pv2015 = (11860*0.6) if region_c == 19 //Taichung city 
   replace pv2015 = (10869*0.6) if region_c == 21 //Tainan city
   replace pv2015 = (12281*0.6) if region_c == 3  //Taoyuan city 
   
   gen     pv2016 = 11448*0.6   
   replace pv2016 = (15162*0.6) if region_c == 1  //Taipei city
   replace pv2016 = (12485*0.6) if region_c == 64 //Kaohsiung city 
   replace pv2016 = (12840*0.6) if region_c == 65 //New Taipei city 
   replace pv2016 = (13084*0.6) if region_c == 19 //Taichung city 
   replace pv2016 = (11448*0.6) if region_c == 21 //Tainan city
   replace pv2016 = (13692*0.6) if region_c == 3  //Taoyuan city 
   
* Estimate poor   
   sum u [w=hpopwgt*nhhmem] if pcdhi_m < pv2015   
   sum u [w=hpopwgt*nhhmem] if pcdhi_m < pv2016  
