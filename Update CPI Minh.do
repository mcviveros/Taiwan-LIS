 
 
 br if code=="TWN"

forvalues xx=40(1)78 {
	replace countryname = "Taiwan, China" in 79`xx'
	replace imfcode = 528 in 79`xx'
}