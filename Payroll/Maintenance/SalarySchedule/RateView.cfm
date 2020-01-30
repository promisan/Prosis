<cfparam name="url.idmenu" default="">

<cf_screentop html="Yes" 
			  height="100%" 
			  label="#URL.Schedule# Salary Schedule Rates" 			 
			  scroll="No" 
			  band="No" 
			  banner="gray"
			  bannerforce="Yes" 
			  option="Maintain Payroll salary scales and provisions" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  line="No"
			  jQuery="Yes"
			  systemfunctionid="#url.idmenu#">


<cfinclude template="RateViewContent.cfm">
	
<cf_screenbottom layout="webapp">
	