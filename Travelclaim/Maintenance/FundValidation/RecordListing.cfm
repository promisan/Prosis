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

<cfparam name="url.addHeader" default="1">

<cf_divscroll>

<cfif url.addHeader eq 1>
	<cfset Header = "">
	<cfset add="0">
	<cfinclude template="../HeaderTravelClaim.cfm"> 
	
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
	<cfoutput>
	<script>
		function recordadd1() {
        	window.showModalDialog("RecordDialog.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:280px; dialogWidth:410px; help:no; scroll:no; center:yes; resizable:no");
			window.location.reload();
		}
		
		function recordedit1(id) {
		    window.showModalDialog("RecordDialog.cfm?idmenu=#url.idmenu#&id="+id+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:280px; dialogWidth:410px; help:no; scroll:no; center:yes; resizable:no");
			window.location.reload();
		}
		
	</script>
	</cfoutput>
	
</cfif>

<cfquery name="SearchResult"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM stFundStatus
	ORDER BY FundType,Period,DateEffective	
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center" >
	
	<tr>
	    
		<td height="20">&nbsp;&nbsp;Period</td>
		<td></td>
		<td>Effective</td>
		<td>Status</td>
		<td>PAP</td>
		<td>Remarks</td>
		</tr>
		
	<cfoutput query="SearchResult" group="FundType"> 
		
		<tr><td colspan="6" class="linedotted"></td></tr>
	    <tr>
		<td colspan="6" class="labellarge" ><i>&nbsp;&nbsp;Fundtype : #FundType#</i></td>
		</tr> 
		
	    <cfoutput group="Period">	
		
			<cfset per = "">
			
			<cfoutput>
		     
		    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffff'))#">
			
			<td align="center" class="labelmedium">&nbsp;&nbsp;&nbsp;&nbsp;
				<b>
					<a href="javascript:recordadd1()" title="Add"><cfif #Period# neq "#per#">#Period#</cfif></a>
				</b>
			</td>
			
			<td width="4%" align="center" style="padding-top:3px;">

			 <cf_img icon="open" onclick="recordedit1('#ValidationId#')">
			 
			</td>
			
			<td><a href="javascript:recordedit1('#ValidationId#')" title="Edit">#DateFormat(DateEffective)#</a></td>
			<td><cfif #Status# eq "1">Accept<cfelse><font color="FF0000">Deny</font></cfif></td>
			<td>
			<cfif #Status# eq "1">
				<cfif #DefaultAccount# eq "">Current<cfelse>#DefaultAccount#</cfif>
			<cfelse>
				N/A	
			</cfif>
			</td>
			<td width="35%">#Remarks#</td>
		</tr>
			
		<cfset per = Period>
			
		</cfoutput>
		
	</cfoutput>
			
</cfoutput>
	
</table>

</cf_divscroll>