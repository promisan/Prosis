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
<cfparam name="mode" default="">

<cfquery name="qLines" datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT ( SELECT OrgUnitName 
	         FROM   Organization.dbo.Organization 
			 WHERE  OrgUnit = C.OrgUnitDonor) as Donor,
			 
			  (SELECT Reference
		    FROM   ContributionLine
			WHERE  ContributionLineId = CL.ParentContributionLineId) as ParentReference, 
	       CL.*, 
	       C.ActionStatus as HeaderStatus 
	FROM   ContributionLine CL, 
	       Contribution C
		   
	WHERE  CL.ContributionId = C.ContributionId
	AND    CL.ParentContributionLineId IN (SELECT ContributionLineId 
	                                       FROM   ContributionLine 
										   WHERE  ContributionId = '#url.contributionid#')
         
	ORDER BY DateReceived ASC, DateEffective ASC	
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

<cfoutput>

	<tr class="line labelit">
		<td style="padding-left:0px;padding-top:3px" colspan="3"></td>						
		<td width="190"><cf_tl id="Donor"></td>
		<td width="150"><cf_tl id="Effective"></td>		
		<td width="150"><cf_tl id="Expiration"></td>		
		<td width="15%"><cf_tl id="Reference"></td>		
		<cfif qClass.Execution eq "0">		
		<td width="15%"><cf_tl id="Parent"></td>			
		</cfif>
		<td width="100"><cf_tl id="Fund"></td>		
		<td width="60"><cf_tl id="Curr"></td>		
		<td align="right"><cf_tl id="Amount"></td>		
		<td width="1%"></td>	
		<td width="1%"></td>		
		<td width="1%"></td>										
	</tr>
			
	<cfset vTotal = 0>
	
	<cfloop query="qLines">

		<tr id="l_#ContributionLineId#" class="line navigation_row">
			<cfinclude template="ContributionSingleLine.cfm">
		</tr>
								
		<cfif mode neq "log">
			<tr>
				<td colspan="13" id="r_#ContributionLineId#" class="clsDetails"></td>
			</tr>
			<tr>
				<td colspan="13" id="e_#ContributionLineId#" class="clsEdit"></td>
			</tr>
		</cfif>
		
		<cfset vTotal = vTotal + Amount>
		
	</cfloop>
	
	<cfif mode neq "log">
		<tr>
			<td colspan="13" id="r_addrow" class="clsAdd"></td>
		</tr>
	</cfif>
	
	<tr>
		<td class="labelmedium" colspan="9" align="right" style="padding-right:10px"><cf_tl id="Total">:</td>
		<td class="labelmedium" align="right">
			<font color="0080C0">#Numberformat(vTotal,",.__")#
		</td>
		<td colspan="3"></td>
	</tr>
	
</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>	

