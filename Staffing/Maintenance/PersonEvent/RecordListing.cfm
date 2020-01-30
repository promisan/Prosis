<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" 	 
	  layout="webapp" 
	  menuAccess="Yes" 
	  html="No"
	  systemfunctionid="#url.idmenu#">


<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PersonEvent
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=700, height=700, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=700, height=700, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="97%" align="center" class="navigation_table">

<thead>
<tr class="labelmedium line">
    <td></td>
    <td>Id</td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Trigger"></td>
	<td><cf_tl id="Workflow"></td>
	<td><cf_tl id="Officer"></td>
    <td><cf_tl id="Entered"></td>
</tr>
</thead>

<tbody>

<cfoutput query="SearchResult">

    <tr class="navigation_row line labelmedium"> 
	<td height="20" width="5%" align="center" style="padding-top:3px;">
		<cf_img icon="select" navigation="Yes" onclick="recordedit('#Code#')">
	</td>		
	<td>#Code#</td>		
	<td>#Description#</td>
	
		<cfquery name="Trigger"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT    T.Description
			FROM      Ref_PersonEventTrigger R INNER JOIN
			          Ref_EventTrigger T ON R.EventTrigger = T.Code
			WHERE     R.EventCode = '#code#'		   
		</cfquery>
	
	<td><table><cfloop query="Trigger"><tr class="labelmedium"><td>#Description#</td></tr></cfloop></table></td>	
	<td>#EntityClass#</td>
	<td>#OfficerFirstName# #OfficerLastName#</td>
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
</cfoutput>

</tbody>

</table>

</cf_divscroll>