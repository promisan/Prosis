
<cf_ApplicantTextArea
		Table           = "FunctionOrganizationNotes" 
		Domain          = "JobProfile"
		FieldOutput     = "ProfileNotes"
		Mode            = "save"
		Log             = "Yes"
		Key01           = "FunctionId"
		Officer         = "N"
		Key01Value      = "#URL.ID#">
	
<cfoutput>

<script language="JavaScript">
    
	try {
		scope = parent.parent.document.getElementById('scope').value
		parent.parent.document.getElementById('refresh'+scope).click()
	} catch(e) {}
	
	parent.parent.ProsisUI.closeWindow('myfunction',true)
	
		  							       
</script>  
	
</cfoutput>