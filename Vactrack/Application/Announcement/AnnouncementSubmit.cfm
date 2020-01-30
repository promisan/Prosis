
<cf_ApplicantTextArea
		Table           = "FunctionOrganizationNotes" 
		Domain          = "JobProfile"
		FieldOutput     = "ProfileNotes"
		Mode            = "save"
		Key01           = "FunctionId"
		Officer         = "N"
		Key01Value      = "#URL.ID#">
	
<cfoutput>
<script language="JavaScript">
try{
  	opener.text('#URL.ID#')
	}
	catch(e) {}
	window.close()
</script>
</cfoutput>
