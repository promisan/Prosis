<!--- Create Criteria string for query from data entered thru search form --->

<cfset add          = "1">
<cfset Header       = "Salary Entitlement Trigger Groups">
<cfinclude template = "../HeaderPayroll.cfm"> 
 
<cfquery name="SearchResult"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	G.*,
				(
					SELECT 	ActionDescription
					FROM   	Organization.dbo.Ref_EntityAction
					WHERE	ActionCode = G.ReviewerActionCodeOne
				) as ReviewerActionCodeOneDescription,
				(
					SELECT 	ActionDescription
					FROM   	Organization.dbo.Ref_EntityAction
					WHERE	ActionCode = G.ReviewerActionCodeTwo
				) as ReviewerActionCodeTwoDescription
		FROM 	Ref_TriggerGroup G
</cfquery>

<cfoutput>

	<script LANGUAGE = "JavaScript">
	
		function recordadd(grp) {
			
		}
		
		function recordedit(id1) {
			window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=650, height=300, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
	
	</script>	

</cfoutput>

<cf_divscroll>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium linedotted">
    <td></td>
	<td><cf_tl id="Code"></td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Reviewer Action 1"></td>
	<td><cf_tl id="Reviewer Action 2"></td>
</tr>

<cfoutput query="SearchResult">
	<tr class="labelmedium navigation_row linedotted">
		<td width="6%" align="center" style="padding-top:2px;">
			<cf_img icon="select" navigation="Yes" onclick="recordedit('#TriggerGroup#')">
		</td>	
		<td>#TriggerGroup#</td>
		<td>#Description#</td>
		<td><cfif ReviewerActionCodeOne neq ''>[#ReviewerActionCodeOne#] #ReviewerActionCodeOneDescription#</cfif></td>
		<td><cfif ReviewerActionCodeTwo neq ''>[#ReviewerActionCodeTwo#] #ReviewerActionCodeTwoDescription#</cfif></td>
	</tr>
</cfoutput>

</table>

</cf_divscroll>
