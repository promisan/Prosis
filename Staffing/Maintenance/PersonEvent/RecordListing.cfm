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
<cf_screentop height="100%" 	 
	  layout="webapp" 
	  menuAccess="Yes" 
	  jquery="Yes"
	  html="No"
	  systemfunctionid="#url.idmenu#">
	  
<cf_listingscript> 

<cfset Page         = "0">
<cfset add          = "1">

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=700, height=700, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function listing(mis) {
	 _cf_loadingtexthtml='';
     ptoken.navigate('RecordListingContent.cfm?mission='+mis+'&systemfunctionid=#url.systemfunctionid#','eventbox');
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>

	<table width="95%" height="100%" align="center" class="navigation_table">
	
	<tr class="labelmedium line" style="height:40px">
	    <td style="width:100px"><cf_tl id="Mission"></td>
	    <td>
		
		<cfquery name="get" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT DISTINCT Mission
			FROM Ref_PersonEventMission
			ORDER BY Mission
		</cfquery>	
		
		<select class="regularxxl" onchange="javascript:listing(this.value)">
		  <option value=""><cf_tl id="All entities"></option>	
		  <cfoutput query="get"><option value="#Mission#">#Mission#</option></cfoutput>
		</select>	
		
		</td>	
	</tr>
	
	<tr><td colspan="2" id="eventbox" style="height:100%">
	<cfinclude template="RecordListingContent.cfm">
	</td></tr>
	
	</table>

	</cf_divscroll>

</td></tr>

</table>

