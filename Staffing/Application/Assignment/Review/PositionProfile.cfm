
<cfparam name="url.accessmode" default="edit">

<cfquery name="get"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.*, O.OrgunitName
	FROM   Position P, Organization.dbo.Organization O
	WHERE  P.OrgunitOperational = O.OrgUnit
	AND    Positionno = '#url.id1#'
</cfquery>

<cfoutput>


<table width="98%" align="center">
		
	<cfset buttonlayout = {label= "Print"}>	
	<tr><td align="right" colspan="2" style="padding-top:5px;"><cf_print buttonlayout="#buttonlayout#" mode="HyperLink"></td></tr>
	<tr><td style="height:24" class="labelit" width="100">Unit:</td>
		<td class="labelmedium" width="80%">#get.OrgUnitName#</td>
	</tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td style="height:24" class="labelit">Postnumber:</td>
		<td class="labelmedium">#get.SourcePostNumber#</td>
	</tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td style="height:24" class="labelit">Title:</td>
		<td class="labelmedium">#get.FunctionDescription#</td>
	</tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td style="height:24" class="labelit">Grade:</td>
		<td class="labelmedium">#get.PostGrade#</td>
	</tr>
	
	<tr><td colspan="2" id="profilecontent#url.languagecode#">	
		<cfinclude template="PositionProfileContent.cfm">
	</td>
	
	</tr>	
	
</table>



	
</cfoutput>
