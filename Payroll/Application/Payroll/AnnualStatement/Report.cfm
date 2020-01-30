<cfparam name="url.output" 				default="1">
<cfparam name="url.contributions" 		default="1">
<cfparam name="url.deductions" 		default="1">
<cfparam name="url.currency" 			default="USD">
<cfparam name="url.sign" 				default="">


<!--- pass true to generate the document --->

<cfreport template     = "Report.cfr" 
		  format       = "PDF" 
		  overwrite    = "yes" 
		  encryption   = "none">
			<cfreportparam name="personno" 			value="#url.personno#"> 
			<cfreportparam name="year" 				value="#url.year#"> 
			<cfreportparam name="mission" 			value="#url.mission#"> 
			<cfreportparam name="contributions" 	value="#url.contributions#"> 
			<cfreportparam name="deductions" 	    value="#url.deductions#"> 
			<cfreportparam name="miscellaneous" 	value="#url.miscellaneous#"> 
			<cfreportparam name="currency" 			value="#url.currency#"> 
			<cfreportparam name="sign" 				value="#url.sign#">
</cfreport>	

