<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

<table width="98%" align="center" height="100%">

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

	<tr class="fixrow labelmedium2 line fixlengthlist">
	    <td></td>
	    <td><cf_tl id="Code"></td>
		<td><cf_tl id="Name"></td>
		<td><cf_tl id="Name full"></td>
		<td><cf_tl id="Order"></td>
		<td><cf_tl id="Titles"></td>
		<td><cf_tl id="Active"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>

<cfoutput query="SearchResult">

	<cfif Status neq "1">
	<tr style="background-color:##FBE0D9" class="navigation_row labelmedium2 line fixlengthlist">
	<cfelse>
	<tr class="navigation_row labelmedium2 line fixlengthlist">
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
		<tr style="background-color:##FBE0D9" class="navigation_row fixlengthlist">
		<cfelse>
		<tr class="navigation_row fixlengthlist">
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

