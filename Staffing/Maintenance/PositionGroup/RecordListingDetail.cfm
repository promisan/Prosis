
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_Group
	WHERE	1=1
	<cfif url.pmission neq "">AND GroupCode in (SELECT GroupCode FROM Ref_GroupMission WHERE Mission = '#url.pmission#')</cfif>
</cfquery>

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">  
 

<tr class="labelmedium line">
    <td></td> 
    <td>Code</td>
	<td>Domain</td>
	<td>Description</td>
	<td>Show in View</td>
	<td>Enabled to</td>
	<td>Officer</td>
    <td>Entered</td>  
</tr>

<cfoutput query="SearchResult">
	
    <tr height="20" class="navigation_row line labelmedium">
		<td width="5%" align="center" style="padding-top:3px;">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#GroupCode#')">
		</td>		
		<td>#GroupCode#</td>
		<td>#GroupDomain#</td>
		<td>#Description#</td>
		<td><cfif ShowInView eq "1">Yes (#ShowInColor#)</cfif></td>
		<td style="font-size:12px">
	
		<cfquery name="Mission"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
			FROM 	Ref_GroupMission
			WHERE 	GroupCode = '#GroupCode#'	
		</cfquery>
	
		<cfset vMission = "">
		<cfloop query="Mission">
			<cfset vMission = vMission & "#mission#, ">
		</cfloop>
		<cfif len(vMission) gt 0>
			<cfset vMission = mid(vMission, 1, len(vMission) - 2)>
		</cfif>
		
		#vMission#
		
		</td>
		<td>#OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>	

