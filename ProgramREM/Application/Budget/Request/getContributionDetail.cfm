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
<table width="100%">
	
	<tr><td style="padding:<cfoutput>#pad#</cfoutput>px">
		
		<table width="100%" class="navigation_table">
		
		    <tr><td colspan="5" style="border-top:1px solid silver;border-bottom:1px solid silver" class="labelmedium"><cf_tl id="Donor contributions earmarked"></td>
			   <td class="labelit" style="border-top:1px solid silver"  align="center" colspan="4"><cfoutput>#application.baseCurrency#</cfoutput></td>
			</tr>
			
			<tr class="line labelit">
				<td align="center"><cf_tl id="S"></td>
				<td><cf_tl id="Donor"></td>
				<td><cf_tl id="Reference"></td>
				<td><cf_tl id="Tranche"></td>		
				<td style="width:10%;padding-right:4px" align="right"><cf_tl id="Amount"></td>
				<td align="right" bgcolor="DAF9FC" style="width:10%;border-top:1px solid gray"><cf_tl id="Amount"></td>
				<td style="width:10%;border-top:1px solid gray" bgcolor="DAF9FC" align="right"><cf_tl id="Adjust"></td>
				<td style="width:10%;border-top:1px solid gray" bgcolor="DAF9FC" align="right"><cf_tl id="Total"></td>
				<td style="width:10%;padding-right:3px;border-top:1px solid gray" bgcolor="DAF9FC" align="right"><cf_tl id="Used"></td>
			</tr>
			
			<cfquery name="getPrior" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     ProgramAllotmentRequestContribution
				<cfif url.requirementid neq "">
				WHERE    RequirementId = '#url.requirementid#'	
				<cfelse>
				WHERE    0 = 1
				</cfif>
			</cfquery>
			
			<cfset prior = valueList(getPrior.ContributionLineId)>
				
			<cfoutput query="Contribution">	
			
				<tr style="height:20px" class="line labelit navigation_row">
				   <td align="center" style="width:30px;padding-left:7px;padding-right:6px">
				   
				   	<cfif url.mode eq "select">
				   
				     <input type="checkbox" 
					      name="contributionlineid" 
						  id="contributionlineid"					  
						  value="'#contributionlineid#'" <cfif findNoCase(contributionlineid,prior)>checked</cfif>>
						  
					<cfelse>
					
					   <input type="checkbox" 
					      name="contributionlineid" 
						  id="contributionlineid"					  
						  value="#contributionlineid#" checked>
					
					
					</cfif>
					
						  
				   </td>
				   <td>#OrgUnitName#</font></a></td>
				   <td><a href="javascript:EditDonor('#contributionlineid#')"><font color="0080C0">#Reference#</font></td>
				   <td>#Tranche#</td>
				   <td style="border-left:1px solid silver;padding-right:5px" align="right"><cfif application.baseCurrency neq Currency>#currency# #numberformat(Amount,",.__")#</cfif></td>
				   <td style="border-left:1px solid silver;padding-right:5px" align="right">#numberformat(AmountBase,",.__")#</td>						  
				   <td style="border-left:1px solid silver;padding-right:5px" align="right">#numberformat(AmountBaseAdditional,",.__")#</td>   
				   <td style="border-left:1px solid silver;padding-right:5px" align="right">#numberformat(AmountBase+AmountBaseAdditional,",.__")#</td>
				   <td style="border-left:1px solid silver;padding-right:5px" align="right">#numberformat(Used,",.__")#</td>
			    </tr>	
				
			</cfoutput>
		
		</table>
		
		</td></tr>

					
	</table>	