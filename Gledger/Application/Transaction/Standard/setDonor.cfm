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
<cfquery name="Donor" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     C.Description,
		           C.Reference,
                        (SELECT   OrgUnitName
                         FROM     Organization.dbo.Organization O
                         WHERE    C.OrgUnitDonor = O.OrgUnit) AS Donor, 
				   CL.DateEffective, 
				   CL.DateExpiration
		FROM       Contribution C INNER JOIN
                   ContributionLine CL ON C.ContributionId = CL.ContributionId
		<cfif  isValid("guid", url.contributionlineid)> 
		WHERE      CL.ContributionLineId = '#url.ContributionLineId#'		
		<cfelse> 
		WHERE      1 = 0						
		</cfif>
</cfquery>		
	
<cfoutput>
 
    <cfif Donor.recordcount gte "1"> 
	
		<input type="hidden" id="contributionlineid" name="contributionlineid" value="#url.ContributionLineId#">
	
	    <table cellspacing="0" cellpadding="0">
		
			<tr class="labelmedium">
			
			<td bgcolor="DAF9FC" style="padding-right:4px;padding-left:3px;border-right:1px solid gray">#Donor.Donor#</td>											
			<td style="padding-left:3px">#Donor.Description#</td>			
			<td style="padding-left:3px">#Donor.Reference#</td>
			</tr>
		
		</table>
		
   <cfelse>
	    <table cellspacing="0" cellpadding="0">
		
			<tr class="labelmedium">
			
			<td style="padding-left:6px">
   			<input type="hidden" id="contributionlineid" name="contributionlineid" value="">   
	   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>		
			</td>
		
		</tr>
		</table>
		
   </cfif>
      
</cfoutput> 