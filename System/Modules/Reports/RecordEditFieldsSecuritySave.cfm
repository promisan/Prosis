
<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ReportControl
	SET #url.field# = '#URL.value#'
	WHERE ControlId = '#URL.Id#'	
 </cfquery>
 
 <script>
	 window.status = "Saved"
 </script>