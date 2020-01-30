

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Status
			SET 	StatusDescription  = '#Form.StatusDescription#',
					Description = <cfif trim(evaluate("Form.Description_#client.languageId#")) neq "">'#evaluate("Form.Description_#client.languageId#")#'<cfelse>null</cfif>
			WHERE 	StatusClass = '#url.id1#'
			AND		Status = '#url.id2#'
	</cfquery>
	
	<cf_LanguageInput
			TableCode       		= "StatusProcurement" 
			Key1Value       		= "#url.id1#"
			Key2Value       		= "#url.id2#"
			Mode            		= "Save"
			Name1           		= "Description"	
			Operational       		= "1">

</cfif>
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  