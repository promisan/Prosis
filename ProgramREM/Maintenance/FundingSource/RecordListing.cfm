<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT count(*) 
	             FROM   ProgramAllotmentdetail 
				 WHERE  Fund = R.Code) as Used	
	FROM Ref_Fund R
	ORDER BY FundingMode, ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
	 ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 540, height= 430, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
	 ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 540, height= 430, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
	
	<table width="94%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	    <td width="20"></td>
	    <td width="30"></td>
	    <td>Code</td>
		<td>Type</td>
		<td>Description</td>
		<td>Status</td>
		<td>S</td>
		<td>Curr.</td>
		<td>Fd Avail.</td>
		<td>Display</td>	
	    <td>Entered</td>  
	</tr>
	
	<cfoutput query="SearchResult" group="FundingMode">
	
	<tr><td colspan="4" class="labellarge" style="font-size:26px;height:40px">#FundingMode#</td></tr>
	
	<cfoutput>
	    
		<tr class="labelmedium2 linedotted navigation_row">
			<td>#currentrow#.</td>
			<td align="center">
			   <cf_img icon="open" onclick="recordedit('#Code#');" navigation="yes">
			</td>
			<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
			<td>#FundType#</td>
			<td>#Description#</td>
			<td><cfif used gte "1"><font color="008040">In Use</cfif></td>
			<td>#ListingOrder#</td>
			<td><cfif Currency neq "">#Currency#</cfif></td>
			<td><cfif VerifyAvailability eq "1">Yes</cfif></td>
			<td><cfif ControlView eq "1">Yes</cfif></td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfoutput>	
	
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td>
</tr>

</table>