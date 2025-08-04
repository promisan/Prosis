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

<!--- eventview --->

<cfparam name="url.ajaxid" default="">
<cfparam name="url.id" default="#url.ajaxid#">

<cfquery name="Get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Event E, Organization.dbo.Organization O
		WHERE  E.OrgUnit = O.OrgUnit
		AND   EventId = '#URL.id#'
</cfquery>


<cfquery name="Post" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   TransactionHeader
		WHERE  TransactionSourceId = '#url.id#'		
</cfquery>

<cfoutput>

<table width="97%" align="center" class="formpadding">
<tr><td colspan="4" class="linedotted"></td></tr>
<tr >
	<td class="labelmedium"><cf_tl id="Entity">:</td>
	<td class="labellarge"><b>#get.Mission#</td>
	<td class="labelmedium"><cf_tl id="Period">:</td>
	<td class="labellarge"><b>#get.AccountPeriod#</td>
</tr>	
<tr>
	<td class="labelmedium"><cf_tl id="Unit">:</td>
	<td class="labellarge"><b>#get.OrgUnitName#</td>
	<td class="labelmedium"><cf_tl id="Status">:</td>
	<td class="labellarge" id="status"><b>#get.ActionStatus#</td>
	
</tr>	
<tr class="linedotted">
	<td class="labelmedium"><cf_tl id="Action">:</td>
	<td class="labellarge"><b>#get.ActionCode#</td>
	<td class="labelmedium"><cf_tl id="Date">:</td>
	<td class="labellarge"><b>#dateformat(get.EventDate,client.dateformatshow)#</td>
	
</tr>	
<cfif post.recordcount eq "1">
<tr class="linedotted">
	<td class="labelmedium"><cf_tl id="Ledger">:</td>
	<td class="labellarge"><a href="javascript:ShowTransaction('#Post.Journal#','#Post.JournalSerialNo#','','tab')">#Post.Journal# #Post.JournalSerialNo#</a></td>
	<td class="labelmedium"><cf_tl id="Officer">:</td>
	<td class="labellarge">#Post.officerLastName#</td>	
</tr>	
</cfif>
<tr><td></td></tr>
<tr>
	<td class="labelmedium"><cf_tl id="Officer">:</td>
	<td class="labellarge">#get.OfficerLastName#</td>
	<td class="labelmedium"><cf_tl id="Created">:</td>
	<td class="labellarge">#dateformat(get.Created,client.dateformatshow)#</td>
</tr>	
</table>
</cfoutput>