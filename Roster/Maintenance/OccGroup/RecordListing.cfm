<!--- Create Criteria string for query from data entered thru search form --->

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Occupational group">

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

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<cfoutput>

<script LANGUAGE = "JavaScript">

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=650, height=470, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=650, height=470, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td style="height:100%">

<cf_divscroll>

<table width="97%" align="center" class="navigation_table formpadding">

	<tr class="fixrow labelmedium2 line">
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

<cfoutput query="SearchResult">

	<cfif Status neq "1">
	<tr style="background-color:##FBE0D9" class="navigation_row labelmedium2 line">
	<cfelse>
	<tr class="navigation_row labelmedium2 line">
	</cfif> 
	<td width="5%" align="center">
		  <cf_img icon="select" navigation="Yes" onclick="recordedit('#OccupationalGroup#')">
	</td>		
	<td>#OccupationalGroup#</td>
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
		<td align="right">#titles#</td>
		<td><cfif Status neq "1">No<cfelse>Yes</cfif>&nbsp;</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfloop>

	</cfif>
	
</cfoutput>

</table>

</cf_divscroll>

</td>
</tr>
</table>

