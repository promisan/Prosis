

<!--- cfpdf --->



<cfpdf action = "merge" 
overwrite="Yes"
destination = "H:\Prosis\Apps\Custom\_file\31_DECEMBER_2021_Infographic_DPPA.PDF">
 
    <cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPPA\31_DECEMBER_2021_Infographic_HR-Gender_Parity - DPPA.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPPA\31_DECEMBER_2021_Infographic_HR-Geographic_Rep - DPPA.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPPA\31_DECEMBER_2021_Infographic_HR-Regional_Diversity - DPPA.pdf"> 
	
</cfpdf> 

<cfpdf action = "merge" 
overwrite="Yes"
destination = "H:\Prosis\Apps\Custom\_file\31_DECEMBER_2021_Infographic_DPO.PDF">
 
    <cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPO\31_DECEMBER_2021_Infographic_HR-Gender_Parity - DPO.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPO\31_DECEMBER_2021_Infographic_HR-Geographic_Rep - DPO.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPO\31_DECEMBER_2021_Infographic_HR-Regional_Diversity - DPO.pdf"> 
	
</cfpdf> 

<cfpdf action = "merge" 
overwrite="Yes"
destination = "H:\Prosis\Apps\Custom\_file\31_DECEMBER_2021_Infographic_SS.PDF">
 
    <cfpdfparam source="H:\Prosis\Apps\Custom\_file\SS\31_DECEMBER_2021_Infographic_HR-Gender_Parity - SS.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\SS\31_DECEMBER_2021_Infographic_HR-Geographic_Rep - SS.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\SS\31_DECEMBER_2021_Infographic_HR-Regional_Diversity - SS.pdf"> 
	
</cfpdf> 



<cfpdf action = "merge" 
overwrite="Yes"
destination = "H:\Prosis\Apps\Custom\_file\31_DECEMBER_2021_Infographic_ALL.PDF">

	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPPA\31_DECEMBER_2021_Infographic_HR-Gender_Parity - DPPA.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPPA\31_DECEMBER_2021_Infographic_HR-Geographic_Rep - DPPA.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPPA\31_DECEMBER_2021_Infographic_HR-Regional_Diversity - DPPA.pdf"> 

	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPO\31_DECEMBER_2021_Infographic_HR-Gender_Parity - DPO.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPO\31_DECEMBER_2021_Infographic_HR-Geographic_Rep - DPO.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\DPO\31_DECEMBER_2021_Infographic_HR-Regional_Diversity - DPO.pdf"> 
 
    <cfpdfparam source="H:\Prosis\Apps\Custom\_file\SS\31_DECEMBER_2021_Infographic_HR-Gender_Parity - SS.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\SS\31_DECEMBER_2021_Infographic_HR-Geographic_Rep - SS.pdf"> 
	<cfpdfparam source="H:\Prosis\Apps\Custom\_file\SS\31_DECEMBER_2021_Infographic_HR-Regional_Diversity - SS.pdf"> 
	
</cfpdf> 