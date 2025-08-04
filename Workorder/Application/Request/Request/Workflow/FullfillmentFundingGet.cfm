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

<cfparam name="url.fundingid" default="">

<cfquery name="Funding" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Funding
	<cfif url.fundingid neq "">
	WHERE FundingId = '#url.FundingId#'	
	<cfelse>
	WHERE 1=0
	</cfif>
</cfquery>

<cfoutput>
	<table width="95%" cellspacing="0" cellpadding="0">
		<input type="hidden" class="regularxl" name="FundingId" id="FundingId" value="#url.fundingid#">
		<tr class="labelit">
		<td style="width:35">
		<input type="input" class="regularxl" name="FundingType" id="FundingType" style="text-align:center;height:19px;width:55" value="#Funding.FundingType#" class="regular">		
		</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="Reference" id="Reference" style="text-align:center;height:19px;width:55" value="#Funding.Reference#" class="regular">		
		</td>
<!---		
		<td style="width:35">
		<input type="input" name="Period" id="Period" style="text-align:center;height:19px;width:35" value="#Funding.Period#" class="regular">		
		</td>
--->		
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="Fund" id="Fund" style="text-align:center;height:19px;width:35" value="#Funding.Fund#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="ProjectCode" id="ProjectCode" style="text-align:center;height:19px;width:35" value="#Funding.ProjectCode#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="ProgramCode" id="ProgramCode" style="text-align:center;height:19px;width:35" value="#Funding.ProgramCode#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="OrgUnitCode" id="OrgUnitCode" style="text-align:center;height:19px;width:35" value="#Funding.OrgUnitCode#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="ObjectCode" id="ObjectCode" style="text-align:center;height:19px;width:35" value="#Funding.ObjectCode#" class="regular">		
		</td>
		
		</tr>
	</table>
</cfoutput>
