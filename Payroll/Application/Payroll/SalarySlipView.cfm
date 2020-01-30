
<cfoutput>

<cfparam name="url.settlementphase" 	default="Final">
<cfparam name="url.documentCurrency" 	default="0">

<cf_screentop height="100%" layout="webapp" label="Payroll Slip" banner="gray" user="Yes" option="Statement of Earnings and Deductions" >
	
	<table width="100%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td width="100%" height="100%" align="center">
		<iframe src="SalarySlipPrint.cfm?settlementid=#url.settlementid#&settlementphase=#url.settlementphase#&documentCurrency=#url.documentCurrency#" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	
	</table>

<cf_screenbottom layout="webapp">

</cfoutput>