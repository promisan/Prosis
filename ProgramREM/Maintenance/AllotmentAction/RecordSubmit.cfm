
<cfquery name="qUpdate" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_AllotmentAction
	SET Description = '#Form.Description#',
		EntityClass = '#Form.EntityClass#'
	WHERE Code 		= '#Form.Code#' 	
</cfquery>


<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
