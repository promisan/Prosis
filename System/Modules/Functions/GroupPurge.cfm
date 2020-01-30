
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ModuleControlUserGroup
		 WHERE SystemFunctionId = '#URL.ID#' and Account = '#URL.ID1#'
</cfquery>

<cfoutput>
	<script>
	 	#ajaxLink('#SESSION.root#/System/Modules/Functions/Group.cfm?ID=#URL.ID#')#
	</script>
</cfoutput> 	