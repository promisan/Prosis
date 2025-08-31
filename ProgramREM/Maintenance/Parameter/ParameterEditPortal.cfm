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
<cfajaximport tags="cfform">

<cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput query="get">

<cfform method="POST" name="parameterbudgetportal" action="ParameterSubmitBudgetPortal.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#">
<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="12"></td></tr>		
	
		<cfquery name="Period" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_Period
				WHERE Period IN (SELECT Period FROM Organization.dbo.Ref_MissionPeriod WHERE Mission = '#URL.Mission#')
				ORDER BY Period 
			</cfquery>	 
			
			 
		    <TR class="labelmedium">
		    <td width="100"><cf_tl id="Period">:</b></td>
		    <TD>
			
				<select name="BudgetPortalPeriod" class="regularxl" message="Please select a default period" required="Yes" style="text-align: right;">
				
				<cfloop query="Period">
				<option value="#Period#" <cfif Get.BudgetPortalPeriod eq Period> SELECTED</cfif>>
				#Period#
				</option>
				</cfloop>
					    
		   	</select>
		    </TD>
			</TR>
			
			<cfquery name="Edition" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_AllotmentEdition
				WHERE Mission = '#URL.Mission#'				
			</cfquery>	 
			 
		    <TR class="labelmedium">
		    <td><cf_tl id="Default Edition">:</b></td>
		    <TD>
			
				<cfselect name="BudgetPortalEdition" message="Please select a default edition." required="Yes" class="regularxl" style="text-align:right">
				
				<cfloop query="Edition">
				<option value="#EditionId#" <cfif Get.BudgetPortalEdition eq EditionId> SELECTED</cfif>>
				#Description#
				</option>
				</cfloop>
					    
		   	</cfselect>
		    </TD>
			</TR>	
						 
		    <TR class="labelmedium">
		    <td><cf_tl id="Mode">:</b></td>
		    <TD>
			
				<select name="BudgetPortalMode" class="regularxl" style="text-align: right;">
								
				<option value="0" <cfif Get.BudgetPortalMode eq "0"> SELECTED</cfif>>Standard
				<option value="1" <cfif Get.BudgetPortalMode eq "1"> SELECTED</cfif>>Extended (incl. staffing)
								
					    
		   	</select>
		    </TD>
			</TR>		
			
			<TR class="labelmedium">
		    <td><cf_tl id="Program Details">:</b></td>
		    <TD>
			
				<select name="BudgetAllotmentVerbose" class="regularxl" style="text-align: right;">
								
				<option value="1" <cfif Get.BudgetAllotmentVerbose eq "1"> SELECTED</cfif>>Verbose
				<option value="0" <cfif Get.BudgetAllotmentVerbose eq "0"> SELECTED</cfif>>Collapsed
													    
		   	</select>
		    </TD>
			</TR>																		
				
	<tr><td height="10"></td></tr>	
	
	<tr class="line"><td colspan="4"></td></tr>	
						
	<tr><td height="40" colspan="4" align="center">	
		<input type="Submit" name="Save" value="Update" class="button10g">
	</td></tr>

	</table>
</cfform>	

</cfoutput>		
