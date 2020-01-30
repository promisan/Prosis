
<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_WarehouseBatchClass
		SET   	Description    	= '#Form.Description#',
				ListingOrder	= '#Form.ListingOrder#',
				ReportTemplate	= <cfif trim(Form.ReportTemplate) neq "">'#Form.ReportTemplate#'<cfelse>null</cfif>
		WHERE 	Code           	= '#Form.CodeOld#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
	
</cfif>	

<script language="JavaScript">
   
     parent.window.close()
	 opener.location.reload()
        
</script>  
