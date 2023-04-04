
<cfparam name="url.domain" default="JobProfile">

<cf_ApplicantTextArea
		Table           = "FunctionOrganizationNotes" 
		Domain          = "#url.domain#"
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
