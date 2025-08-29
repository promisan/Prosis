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
<cfset link = "BroadCastRecipientLine.cfm?id=#url.id#">

<table width="98%" style="height:100%" align="center">
	
	<tr><td height="10"></td></tr>
	  
	<cfquery name="Check" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   Broadcast
		  WHERE  BroadcastId     = '#URL.Id#'   
	</cfquery>
	
	<cfif Check.broadcaststatus eq "0">
		
		<cfif check.SystemFunctionId eq "">
		
		 <tr><td class="labelmedium" style="padding-left:10px">
		 
				   <cf_selectlookup
				    class    = "User"
				    box      = "recipient"
					title    = "Add a Mail Recipient"				
					link     = "#link#"			
					dbtable  = "System.dbo.BroadcastRecipient"
					des1     = "Account">
					 
		 </td></tr>
		 
		</cfif> 
	
	</cfif>
	 
	<tr><td style="height:100%;padding-bottom:8px" valign="top">
	<cf_securediv bind="url:#link#" id="recipient" style="height:100%"> 
	</td></tr>

</table>
