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
<cfquery name="get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Request
	WHERE  RequestId = '#Object.ObjectkeyValue4#'	
</cfquery>

<table cellspacing="6" cellpadding="6" width="96%" align="center" class="formpadding">

    <tr class="labelit"><td></td>
	    <td></td>
	    <td>Funding Budget Account Code</td>
		<td>Current Balance</td>
	</tr>	
	<tr><td colspan="4" class="line"></td></tr>	
	
	<tr class="labelit">
		
	<cfset link = "#SESSION.root#/Workorder/Application/Request/Request/Workflow/FullfillmentFundingGet.cfm?ts=1">	
				
	<td width="200">Select Funding for request:</td>	
	<td width="20">
	
	   <cf_selectlookup
	    box        = "funding"
		link       = "#link#"
		button     = "Yes"
		icon       = "contract.gif"
		close      = "Yes"
		class      = "funding"
		des1       = "FundingId">
		
	</td>						
	<td width="160" valign="top">
		<cfdiv id="funding">
		    <cfset url.fundingId = get.fundingid>
			<cfinclude template="FullfillmentFundingGet.cfm">
		</cfdiv>
	</td>	
	</tr>

    <input type="hidden" name="savecustom" id="savecustom" value="WorkOrder/Application/Request/Request/Workflow/FullfillmentFundingSubmit.cfm">
	
</table>	