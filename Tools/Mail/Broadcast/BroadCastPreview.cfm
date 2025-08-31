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
<cfquery name="BroadCast" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Broadcast
	  WHERE BroadcastId = '#URL.ID#' 	 
</cfquery>

<!--- prepares dynamic fields to be parsed --->
<cfinclude template="BroadCastContext.cfm">

<cfquery name="Recipient" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  BroadcastRecipient
	  WHERE BroadcastId = '#URL.ID#' 
	  AND   RecipientId = '#URL.recipientid#'	 
</cfquery>

<cf_screentop height="100%" scroll="No" layout="webapp" user="No" label="Mail Preview">

<cfoutput query="recipient">

<table width="95%" cellspacing="0" cellpadding="0" class="formpadding" align="center">
	<tr class="linedotted labelmedium">
		<td>
			<b>To:</b>
		</td>
		<td>#RecipientName# (<b>#eMailAddress#</b>)</td>
	</tr>
	<tr class="linedotted labelmedium">
		<td>
			<b>Subject:</b>
		</td>
		<td>
			#BroadCast.BroadCastSubject#
		</td>
	</tr>

	<tr>
		<td colspan="2" style="padding-left:10px;">
		<!--- loop through the fields  --->
		<cfset body = BroadCast.BroadcastContent>
		<cfinclude template="BroadCastParse.cfm">
		#body#
		</td>
	</tr>
</table>

<cf_screenbottom layout="webapp">

</cfoutput>