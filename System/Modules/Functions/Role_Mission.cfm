<cfquery name="Missions" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
    FROM 	Ref_ModuleControlRoleMission
	WHERE 	SystemFunctionId = '#URL.ID#'
	AND		Role = '#URL.role#'
	AND		Mission is not null
</cfquery>
<cfset allType = "Assign">
<cfif Missions.recordCount gt 0><cfset allType = "Remove"></cfif>

<cfoutput>

<cfif Missions.recordCount eq 0>
	<img src="#SESSION.root#/images/hierarchy_down.gif" height="12" width="12" style="cursor:pointer" alt="For all missions" border="0" onclick="javascript: showmissions('#URL.ID#','#URL.role#','#allType#')">
<cfelse>
	<img src="#SESSION.root#/images/insert5.gif" height="12" width="12" style="cursor:pointer" alt="Assigned to #Missions.recordCount# mission<cfif Missions.recordCount gt 1>s</cfif>" border="0" onclick="javascript: showmissions('#URL.ID#','#URL.role#','#allType#')">
</cfif>

</cfoutput>