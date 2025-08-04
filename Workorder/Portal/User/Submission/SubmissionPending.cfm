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

<cfoutput>

<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'
	</cfquery>
	
<cfparam name="path" default="#SESSION.root#/Custom/Logon/#Parameter.ApplicationServer#/watermark.png">

<style>
	td.watermark {
		background-image:url('#path#');
		background-position:top center;
		background-repeat:no-repeat;
		width:100%;
		height:100%;
		background-color:transparent;
		padding-top:14px;
	}
</style>

</cfoutput>
		
<cfif url.serviceitem neq "">

	<table cellpadding="0" cellspacing="0" border="0" width="100%" height="80%">
			<tr>				
				<td class="watermark clsPrintContent" valign="top" style="padding-left:20px;padding-right:20px">								
				<cfset url.scope = "clearance">
				<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageApproval.cfm">			
				</td>
			</tr>
		</table>		

<cfelse>
			  
	  <cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  HostName = '#CGI.HTTP_HOST#'
	  </cfquery>

	  <cfoutput>
				
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="80%">
			<tr>				
				<td class="watermark"></td>
			</tr>
		</table>		
		
	  </cfoutput>

</cfif>

