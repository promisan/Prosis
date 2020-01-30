

<!--- record memo --->

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT  *
			FROM    OrganizationActionPerson
			WHERE   OrgUnitActionId  = '#url.id#' 
			AND     PersonNo         = '#url.personno#'
</cfquery>	

<cfoutput>
<table width="100%" class="labelmedium">
<tr><td style="padding:4px;padding-left:20px;width:100%">
	<textarea type="text" id="memo" totlength="800" name="memo_#url.personno#" onkeyup="return ismaxlength(this)"
	onchange="ptoken.navigate('#session.root#/attendance/application/Workflow/Clearance/DocumentMemoSave.cfm?personno=#url.personno#&id=#url.id#','memo_#url.personno#','','','POST','clearanceform')" 
	style="padding:4px;font-size:14px;height:70px;width:100%">#get.remarks#</textarea>
</td>
<td style="min-width:10px;width;10px" id="memo_#url.personno#"></td>
</tr>
</table>
</cfoutput>
