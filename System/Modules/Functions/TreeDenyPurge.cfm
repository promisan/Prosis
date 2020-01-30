
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ModuleControlDeny
		 WHERE SystemFunctionId = '#URL.ID#' and Mission = '#URL.ID1#'
</cfquery>

<script>
	 <cfoutput>
	 #ajaxLink('#session.root#/System/Modules/Functions/TreeDeny.cfm?ID=#URL.ID#')#
	 </cfoutput> 
</script>	