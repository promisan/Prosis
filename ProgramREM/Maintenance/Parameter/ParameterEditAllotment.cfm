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

<cfform method="POST" name="parameterbudgetallotment" action="ParameterSubmitBudgetAllotment.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#">
<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="12"></td></tr>		
	
		<script language="JavaScript">
		
		   function allot(sh,box) {
		   
			   se = document.getElementById(box)		  
			   if (sh == "1") {			   
			      ColdFusion.Layout.showTab('modules','all')
			   } else { 			      
			      ColdFusion.Layout.hideTab('modules','all')
  			   }			   
		   }
		   	
		</script>
	
				
		<tr id="targetcolor">
		<td></td>
	    <td colspan="3" class="regular">
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding formspacing">
		
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
		    <td class="labelmedium" width="25%">Default Allotment period:</b></td>
		    <TD>
				
				<select name="DefaultAllotmentPeriod" class="regularxl" message="Please select a program period" style="text-align:right;">
				<option value="">System default</option>
				<cfloop query="Period">
				<option value="#Period#" <cfif Get.DefaultAllotmentPeriod eq Period> SELECTED</cfif>>
				#Period#
				</option>
				</cfloop>
				</select>
							    
		   	
		    </TD>
			</TR>	
			
			<TR class="labelmedium">
	   		<td class="labelmedium" width="150"  style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Presentation of the alloted amounts">
			Allotment Opening View:
			</cf_UIToolTip>
			</td>
		    <TD colspan="3" class="labelmedium">
			    <table>
			    <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" name="DefaultAllotmentView" class="radiol" value="0" <cfif DefaultAllotmentView eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Program Only</td>
				<td style="padding-left:4px"><input type="radio" name="DefaultAllotmentView" class="radiol" value="1" <cfif DefaultAllotmentView eq "1">checked</cfif>></td>
				<td style="padding-left:4px">All</td>
				</tr>
			    </table>	
		    </TD>
			</TR>	
			
			<TR class="labelmedium">
	   		<td class="labelmedium" style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Define the default support cost object code, which is to be defined on the program allotment level">
			Default SUPPORT Object Code:
			</cf_UIToolTip>
			</td>
		    <TD colspan="3" class="labelmedium">
			
			<cfquery name="Object" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT   *
	            FROM     Ref_Object
				WHERE    ObjectUsage IN
	                          (SELECT   V.ObjectUsage
	                            FROM    Ref_AllotmentVersion AS V INNER JOIN
	                                    Ref_AllotmentEdition AS E ON V.Code = E.Version
	                            WHERE   E.Mission = '#url.mission#') 
				AND      SupportEnable = 0
				ORDER BY HierarchyCode
			
			</cfquery>
			
			<select name="SupportObjectCode" class="regularxl" style="text-align: right;">
				<option value="">n/a</option>				
				<cfloop query="Object">
				<option value="#Code#" <cfif get.SupportObjectCode eq Code> SELECTED</cfif>>
				#Code# #Description#
				</option>
				</cfloop>
						
			
			</TD>
			</TR>			
			
			<TR class="labelmedium">
	   		<td class="labelmedium" style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Prepare budget on the object of expenditure level">
			Allow requirements on Parent level:
			</cf_UIToolTip>
			</td>
		    <TD colspan="3" class="labelmedium">
				<table>
			    <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" name="BudgetObjectMode" class="radiol" value="Parent" <cfif BudgetObjectMode eq "Parent">checked</cfif>></td>
				<td style="padding-left:4px">Yes</td>
				<td style="padding-left:4px"><input type="radio" name="BudgetObjectMode" class="radiol" value="All" <cfif BudgetObjectMode eq "All">checked</cfif>></td>
				<td style="padding-left:4px">No, only on deepest level</td>
				</tr>
			    </table>	
				
		    </TD>
			</TR>				
		
			<TR class="labelmedium">
	   		<td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Presentation of the alloted amounts">Amount Presentation:</cf_UIToolTip></td>
		    <TD colspan="3" class="labelmedium">
				<table>
			    <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" name="BudgetAmountMode" class="radiol" value="1" <cfif BudgetAmountMode eq "1">checked</cfif>></td>
				<td style="padding-left:4px">In thousands (default)</td>
				<td style="padding-left:4px"><input type="radio" name="BudgetAmountMode" class="radiol" value="0" <cfif BudgetAmountMode eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Normal</td>
				</tr>
			    </table>	
				
		    </TD>
			</TR>		
			
			
			<TR class="labelmedium">
	   		<td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Presentation of the alloted amounts">Requirement Location:</cf_UIToolTip></td>
		    <TD colspan="3" class="labelmedium">
				<table>
			    <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" name="BudgetLocation" class="radiol" value="Payroll" <cfif BudgetLocation eq "Payroll">checked</cfif>></td>
				<td style="padding-left:4px">Payroll</td>
				<td style="padding-left:4px"><input type="radio" name="BudgetLocation" class="radiol" value="Staffing" <cfif BudgetLocation eq "Staffing">checked</cfif>></td>
				<td style="padding-left:4px">Staffing</td>
				</tr>
			    </table>	
				
		    </TD>
			</TR>	
			
			<TR class="labelmedium">
	   		<td class="labelmedium" style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Prepare budget on the object of expenditure level">
			Enforce Location:
			</cf_UIToolTip>
			</td>
		    <TD colspan="3" class="labelmedium">
				<table>
			    <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" name="BudgetRequirementLocation" class="radiol" value="1" <cfif BudgetRequirementLocation eq "1">checked</cfif>>
				<td style="padding-left:4px">Yes</td>
				<td style="padding-left:4px"><input type="radio" name="BudgetRequirementLocation" class="radiol" value="0" <cfif BudgetRequirementLocation eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No, optional</td>
				</tr>
			    </table>	
		    </TD>
			</TR>				
						
			<TR class="labelmedium">
	   		<td class="labelmedium" valign="top" style="padding-top:4px;cursor: pointer;"><cf_UIToolTip  tooltip="Mode under which requirements maybe recorded">Requirement Definition:</cf_UIToolTip></b></td>
		    <TD colspan="3" class="labelmedium">
			    <table>
			    <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" name="BudgetRequirementMode" class="radiol" value="0" <cfif BudgetRequirementMode eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Only if ceiling is not exceeded</td>
				<td style="padding-left:4px"><input type="radio" name="BudgetRequirementMode" class="radiol" value="1" <cfif BudgetRequirementMode eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Always allow to record a requirement<font color="808080"><i> (recommended)</i></font></td>
				</td>
				</tr>
			    </table>	
		    </TD>
			
			<TR class="labelmedium">
	   		<td class="labelmedium" valign="top" style="padding-top:4px;cursor: pointer;"><cf_UIToolTip  tooltip="Mode for transfer">Budget Transfer action:</cf_UIToolTip></b></td>
		    <TD colspan="3" class="labelmedium">
			    <table>
			    <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" name="BudgetTransferMode" class="radiol" value="1" <cfif BudgetTransferMode eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Within resource class</td>
				<td style="padding-left:4px"><input type="radio" name="BudgetTransferMode" class="radiol" value="2" <cfif BudgetTransferMode eq "2">checked</cfif>></td>
				<td style="padding-left:4px">Accross resource classes</td>
				</td>
				</tr>
			    </table>	
		    </TD>
			
			
			
			</TR>				
						
			<TR class="labelmedium">
	   		<td class="labelmedium" valign="top" style="padding-top:4px;cursor: pointer;">Allotment Presentation mode:</td>
		    <TD colspan="3">
			   <table cellspacing="0" cellpadding="0">
			   	<tr class="labelmedium">
			   		<td class="labelmedium">
					<input type="radio" name="BudgetClearanceMode" class="radiol" value="0" <cfif BudgetClearanceMode eq "0">checked</cfif>>					
					<td style="padding-left:4px">Present all budget lines (cleared and pending clearance)</td>
				</tr>
				<tr class="labelmedium">
					<td class="labelmedium">
					<input type="radio" name="BudgetClearanceMode" class="radiol" value="1" <cfif BudgetClearanceMode eq "1">checked</cfif>>
					</td>
					<td style="padding-left:4px">Present only cleared budget lines</td>
				</tr>
				</table>
		    </TD>
			</TR>	
			
			<TR class="labelmedium">
	   		<td class="labelmedium" valign="top" style="padding-top:4px;cursor: pointer;">Enable Requistion forecast:</td>
		    <TD colspan="3">
			   <table cellspacing="0" cellpadding="0">
			   	<tr class="labelmedium">
			   		<td class="labelmedium">
					<input type="radio" name="EnableForecast" class="radiol" value="0" <cfif EnableForecast eq "0">checked</cfif>>					
					<td style="padding-left:4px">Disable recording requisitions</td>
				</tr>
				<tr class="labelmedium">
					<td class="labelmedium">
					<input type="radio" name="EnableForecast" class="radiol" value="1" <cfif EnableForecast eq "1">checked</cfif>>
					</td>
					<td style="padding-left:4px">Allow recording requisitions from budget inquiry</td>
				</tr>
				</table>
		    </TD>
			</TR>	
			
			<cfquery name="CatList" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_ProgramCategory
				WHERE  Parent NOT IN (SELECT Code FROM Ref_ProgramCategory)
				AND    Code IN (SELECT Category
				                FROM   Ref_ParameterMissionCategory 
								WHERE Mission = '#url.mission#')
			</cfquery>	 
			
			<TR class="labelmedium">
	   		<td class="labelmedium" width="150" style="cursor: pointer;">
			Requirement Earmarking:
			</td>
		    <TD colspan="3">
				<select name="BudgetCategory" class="regularxl" style="text-align: right;">
				<option value="">n/a</option>
				<cfset cat = budgetcategory>
				<cfloop query="CatList">
				<option value="#Code#" <cfif cat eq Code> SELECTED</cfif>>
				#Description#
				</option>
				</cfloop>
					    
		   
		    </TD>
			</TR>	
				
	<tr><td height="10"></td></tr>	
	<tr><td colspan="4"  class="line"></td></tr>	
						
	<tr><td height="40" colspan="4" align="center">	
		<input type="Submit" name="Save" value="Update" class="button10g">
	</td></tr>
	
	</table>
	
	</td>
	</tr>
	

</table>	

</cfform>
</cfoutput>			