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
<cfquery name="Protocol"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Protocol
	FROM   Ref_Action R, Ref_ActionNotification P
	WHERE  R.Code = P.Code
	AND    R.Mission = '#url.mission#'										
</cfquery>	

<cfoutput>
	<cfset itm = 0>
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"> 
	<cfloop query="Protocol">
		<cfset itm = itm+1>	
		<tr>
			<td height="5%">
				<!--- <a href="javascript:void(0)" onclick="javascript:notification('#protocol#')"> --->
					<img src="#CLIENT.root#/images/Logos/WorkOrder/Planner/#protocol#.png" border=0>
				<!--- </a>--->
			</td>					
		</tr>				
		<tr>
			<td id="dNotification" height="90%" valign="top">
				<cfinclude template="#protocol#/#protocol#Listing.cfm">
			</td>	
		</tr>				
	</cfloop>	
	</table>
</cfoutput>