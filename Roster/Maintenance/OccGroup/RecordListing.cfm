<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD><TITLE>Occupational group</TITLE></HEAD>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Occupational group">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *, 
	         (SELECT count(*) FROM FunctionTitle WHERE OccupationalGroup = R.OccupationalGroup) as Titles
	FROM     #client.LanPrefix#OccGroup R
	WHERE    ParentGroup is NULL
	ORDER BY ListingOrder, OccupationalGroup
</cfquery>

<cfoutput>

<script LANGUAGE = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=550, height=470, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=550, height=470, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table formpadding">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Name</td>
		<td>Name full</td>
		<td>Order</td>
		<td>Titles</td>
		<td>Active</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">

	<cfif Status neq "1">
	<tr style="background-color:##FBE0D9" class="navigation_row">
	<cfelse>
	<tr class="navigation_row">
	</cfif> 
	<td width="5%" align="center">
		  <cf_img icon="open" navigation="Yes" onclick="recordedit('#OccupationalGroup#')">
	</td>		
	<td><a href="javascript:recordedit('#OccupationalGroup#')">#OccupationalGroup#</a></td>
	<td>#Description#</td>
	<td>#DescriptionFull#</td>
	<td>#ListingOrder#</td>
	<td>#titles#</td>
	<td><cfif Status neq "1">No<cfelse>Yes</cfif>&nbsp;</td>
	<td>#OfficerFirstName# #OfficerLastName#</td>
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
	<cfquery name="Child" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *,
			(SELECT count(*) 
			 FROM   FunctionTitle 
			 WHERE  OccupationalGroup = R.OccupationalGroup) as Titles
	FROM    #client.LanPrefix#OccGroup R
	WHERE   ParentGroup = '#OccupationalGroup#'
	</cfquery>
	
	<cfif Child.recordcount gte "1">
	
	<cfloop query="Child">
		
		<tr><td height="1" colspan="9"></td></tr>
		<cfif Status neq "1">
		<tr style="background-color:##FBE0D9" class="navigation_row">
		<cfelse>
		<tr class="navigation_row">
		</cfif> 
		<td width="5%" align="center" style="padding-top:1px;">
		 	<cf_img icon="open" onclick="recordedit('#OccupationalGroup#')">
		</td>	
			
		<td>
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td width="20">
			 <img src="#SESSION.root#/Images/join.gif" border="0" align="absmiddle">
			</td>
			<td>&nbsp;</td>
			<td><a href="javascript:recordedit('#OccupationalGroup#')">#OccupationalGroup#</a></td>
			</tr>
			</table>
		</td>
		
		<td>#Description#</td>
		<td>#DescriptionFull#</td>
		<td>#ListingOrder#</td>
		<td>#titles#</td>
		<td><cfif Status neq "1">No<cfelse>Yes</cfif>&nbsp;</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfloop>

	</cfif>
	
</cfoutput>

</tbody>

</table>


</cf_divscroll>
