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

<!--- base requirement used to obtain data and 
for selection of the review cycle 
and layout :  program / orgunit --->

<!--- get a base file from the component for a year --->
<cfset vMission = replace(url.mission, "-", "", "ALL")>
<cfset tbl = "#session.acc#_requirement_#vMission#">

<cfinvoke component="Service.Process.Program.ProgramAllotment"  
	Method         = "RequirementAdjusted"
	Mission        = "#URL.Mission#"
	Period         = "#URL.Period#"		
	ActionStatus   = "'0','1'"
	Support		   = "Yes"
	Mode           = "table"
	Table 		   = "#tbl#">		
	
<cf_wfpending entityCode="EntProgramReview"  
      table="#SESSION.acc#wfProgramReview" mailfields="No" IncludeCompleted="No">				

<cfoutput>
	
	<cfquery name="Cycle" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ReviewCycle C
		WHERE    C.Mission = '#url.mission#'
		AND      C.Period  = '#url.period#'
		AND      Operational = 1
		AND      DateBudgetEffective  is not NULL 
		AND      DateBudgetExpiration is not NULL
		AND      EnableMultiple = 0
		ORDER BY DateEffective	
	</cfquery>
	
	<cfif Cycle.recordcount eq "0">
	
		<table width="100%"><tr><td class="labelmedium"><b><font color="FF0000">There are NO review cycles enabled for this period</font></td></tr></table>
	
	<cfelse>
		
		<table width="100%">
			<tr>			
				<td>						
							
					<cf_securediv id="divRequirementDetail_#mission#" bind="url:#session.root#/Portal/Topics/Requirement/RequirementContent.cfm?mission=#mission#&period=#url.period#&orgunit=#url.orgunit#&reviewcycle=#Cycle.CycleId#&layout=Org">
				 
				</td>
			</tr>
		</table>
	
	</cfif>

</cfoutput>