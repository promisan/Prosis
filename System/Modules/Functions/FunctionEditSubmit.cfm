<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE   Ref_SystemModule
	SET      ModuleMemo = '#Form.FunctionEditMemo#'		
	WHERE    SystemModule = '#URL.Module#'
</cfquery>

<script>
	alert('Saved!');
</script>