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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML>

<HEAD>

<TITLE>Claim category</TITLE>
	
</HEAD>

<body leftmargin="2" topmargin="2" rightmargin="3">

<cfquery name="SearchResult"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ClaimCategory
	ORDER BY ListingOrder
</cfquery>

<cfset Header = "">
<cfset page="0">
<cfset add="0">
<cfinclude template="../HeaderTravelClaim.cfm"> 	

<table width="100%" align="center" cellspacing="0" cellpadding="0" >

<script language = "JavaScript">

	function reloadForm(page) {
	     window.location="RecordListing.cfm?Page=" + page; 
	}
	
	<!---
	function recordadd(grp)
	{
	          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width=500, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1)
	{
	          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width=500, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	--->

</script>	

	<tr>
	
	<td colspan="2">
	
		<table width="97%" cellspacing="0" cellpadding="1" align="center" >
		 
			<tr style="height:25px;">
			
			    <td width="4%" align="center" ></td>
			    <td align="center" >Code</td>
				<td align="left" >Description</td>
				<td align="center" >Reference</td>
				<td align="center" >TVLT</td>
				<td >Claim amount</td>
				<td align="center" >Express</td>
				<td align="center" >Request</td>
				<td align="center" >Details</td>
			
			</tr>
			
			<tr><td colspan="9" class="linedotted"></td></tr>
		
			<cfoutput query="SearchResult"> 
			     
			    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
				<td width="4%" height="20" align="center">
				    <cf_img icon="open" onclick="recordedit('#Code#')">
				</td>
				<td width="7%" align="center"><a href="javascript:recordedit('#Code#')">#Code#</a></td>
				<td width="20%">#Description#</td>
				<td align="center">#ReferenceCode#-#ReferenceNo#</td>
				<td align="center">#ReferenceTVLT#</td>
				<td width="80" align="center"><cfif #ClaimAmount# eq "0">NO</cfif></td>
				<td width="60" align="center"><cfif #DisableExpress# eq "0">YES</cfif></td>
				<td width="60" align="center"><cfif #RequireRequestLine# eq "1">YES</cfif></td>
				<td width="60" align="center"><cfif #ShowInvoices# eq "1">YES</cfif></td>
				</tr>
				<cfif #currentRow# neq "#SearchResult.recordcount#">
				<tr><td colspan="9" class="linedotted"></td></tr>
				</cfif>
					
			</cfoutput>
		
		</table>
	
		</td>
		
	</tr>

</table>

</BODY></HTML>