
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ModuleControlRole 
		 WHERE SystemFunctionId = '#URL.ID#' and Role = '#URL.ID1#'
</cfquery>

<script>
	 <cfoutput>
	 try { opener.functionrefresh('#URL.ID#') } catch(e) {}
	 #ajaxLink('#SESSION.root#/System/Modules/Functions/Role.cfm?ID=#URL.ID#')#
	 </cfoutput> 
</script>	