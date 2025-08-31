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
<cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput query="get">

<cfform method="POST"  name="parametermodules" action="ParameterSubmitModules.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#">

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<tr><td height="12"></td></tr>
		
		<tr class="line"><td height="4" colspan="2" style="font-size:26px;height:42px" class="labellarge">Project and Program</b></td></tr>
										
		<!--- Field: Prosis Applicantion Root Path--->
	    <TR class="LabelMedium">
	    	<td>Project/Program Entry Mode:</b></td>
	    	<TD colspan="3">
			   <table>
			   <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" class="radiol" name="EnableEntry" value="0" <cfif EnableEntry eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Only for Program Manager</td>
				<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableEntry" value="1" <cfif EnableEntry eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Program Manager and Officer</td>
				</tr>
				</table>
			</TD>				
		</TR>	
			
		<tr class="labelit"><td></td></td><td colspan="3" style="padding-left:20px; color:gray;">Disables entry of new program/project for the role of Program Officer.</td></tr>
		
		<TR class="LabelMedium">
	    <td >GANTT support:</td>
	    <TD colspan="3">
		   <table>
			   <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" class="radiol" name="EnableGANTT" value="0" <cfif EnableGANTT eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Disabled</td>
				<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableGANTT" value="1" <cfif EnableGANTT eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Enabled</td>
				</tr>
			</table>
	    </TD>
		</TR>	
		
		<tr class="Labelit"><td></td></td><td colspan="3" style="padding-left:20px; color:gray;">Disables Project activity planning and GANTT charts.</td></tr>
		
				
		<tr><td height="4" colspan="2" style="padding-left:10px;font-size:20px;height:42px" class="labelmedium">Program Coding conventions</b></td></tr>
		
	    <TR class="LabelMedium">
	    <td style="padding-left:20px">Label Hierarchy Level 0:</b></td>
	    <TD>
			<cfinput class="regularxl" type="Text" name="TextLevel0" value="#TextLevel0#" message="Please enter a name for level 0 entries" required="Yes" size="20" maxlength="20">
	    </TD>
		
	    <TR class="LabelMedium">
	    <td style="padding-left:20px">Label Hierarchy Level 1:</b></td>
	    <td>
			<cfinput class="regularxl" type="Text" name="TextLevel1" value="#TextLevel1#" message="Please enter a name for level 2 entries" required="Yes" size="20" maxlength="20">
	    </td>		
		</tr>
		
		<TR class="LabelMedium">
		<td style="padding-left:20px">Label Hierarchy Level 2:</b></td>
	    <td>
			<cfinput class="regularxl" type="Text" name="TextLevel2" value="#TextLevel2#" message="Please enter a name for level 1 entries" required="Yes" size="20" maxlength="20">
	    </td>
		</tr>	
			
	    <TR class="LabelMedium">
	    <td style="padding-left:20px">Level 1 project entry:</b></td>
	    <td colspan="3">
			<table>
			   <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" class="radiol" name="EnableProjectLevel1" value="1" <cfif EnableProjectLevel1 eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Yes</td>
				<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableProjectLevel1" value="0" <cfif EnableProjectLevel1 eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No</td>
			   </tr>
			</table>   				
	    </td>
		</tr>	
		<tr class="Labelit" style="color:gray"><td></td></td><td colspan="3">Disables registration of projects on level 1</td></tr>
		
		<tr class="line"><td height="4" colspan="2" style="font-size:26px;height:42px" class="labellarge">Donor</b></td></tr>
		
	    <TR class="Labelmedium">
	    <td style="height:30px;padding-left:10px" width="25%">Donor administration:</td>
	    <TD colspan="3">
		   <table>
			   <tr class="Labelmedium">
			   <td style="padding-left:0px"><input type="radio" class="radiol" name="EnableDonor" value="0" onClick="menutab('tmenu4','0')" <cfif EnableDonor eq "0">checked</cfif>></td>
			   <td style="padding-left:4px">Disabled</td>
  			   <td style="padding-left:4px"><input type="radio" class="radiol" name="EnableDonor" value="1" onClick="menutab('tmenu4','1')"  onClick="donor('1')" <cfif EnableDonor eq "1">checked</cfif>></td>
			   <td style="padding-left:4px">Enabled with integrated allotment</td>
			   <td style="padding-left:4px"><input type="radio" class="radiol" name="EnableDonor" value="2" onClick="menutab('tmenu4','1')"  onClick="donor('1')" <cfif EnableDonor eq "2">checked</cfif>></td>
			   <td style="padding-left:4px">Enabled (limited)</td>
			   </tr>
			</table>	
	    </TD>
		</TR>	
		
		<!--- Field: Contribution auto number--->
	    <TR class="LabelMedium">
	    <td style="height:30px;padding-left:10px">Contribution auto number:</td>
	    <TD colspan="3">
		    <table>
			   <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" class="radiol" name="ContributionAutoNumber" value="0" <cfif ContributionAutoNumber eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Disabled</td>
				<td style="padding-left:4px"><input type="radio" class="radiol" name="ContributionAutoNumber" value="1" <cfif ContributionAutoNumber eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Enabled</td>
				</tr>
			</table>	
	    </TD>
		</TR>			
		<tr><td height="3"></td></tr>
		
		<!--- Field: Contribution prefix--->
	    <TR class="LabelMedium">
	    <td style="height:30px;padding-left:10px">Contribution prefix:</td>
	    <TD colspan="3">
			<cfinput class="regularxl" type="Text" name="ContributionPrefix" value="#ContributionPrefix#" message="Please enter a valid contribution prefix" required="Yes" size="5" maxlength="4">
	    </TD>
		</TR>			
		<tr><td height="3"></td></tr>
		
		<!--- Field: Budget Contribution serial no --->
	    <TR class="LabelMedium">
	    <td style="height:30px;padding-left:10px">Contribution serial no:</td>
	    <TD colspan="3">
			<cfinput class="regularxl" type="Text" name="ContributionSerialNo" value="#ContributionSerialNo#" validate="integer" message="Please enter valida integer serial number" required="Yes" size="5" maxlength="10" style="text-align:right; padding-right:3px;">
	    </TD>
		</TR>			
		<tr><td height="10"></td></tr>
				
		<tr class="line"><td height="4" colspan="2" style="font-size:26px;height:42px" class="labellarge">Budget Preparation</b></td></tr>
		
	    <TR class="LabelMedium">
	    <td style="height:30px;padding-left:10px" width="15%">Budget Preparation and Allotment:</td>
	    <td colspan="3">
			<table>
			   <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" class="radiol" name="EnableBudget" value="0" onClick="menutab('tmenu5','0')" <cfif EnableBudget eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Disabled</td>
				<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableBudget" value="1" onClick="menutab('tmenu5','1')" <cfif EnableBudget eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Enabled for currency #BudgetCurrency#</td>
				</tr>
			</table>
	    </TD>
		</TR>				
						
		<tr><td height="3"></td></tr>
		
		<tr class="line"><td height="4" colspan="2" style="font-size:26px;height:42px" class="labelmedium">Indicators</td></tr>
		
	    <TR class="LabelMedium">
	    <td style="height:30px;padding-left:10px">Indicator (BSC) management:</td>
	    <TD colspan="3">
			<table>
			   <tr class="LabelMedium">
			    <td style="padding-left:0px"><input type="radio" class="radiol" name="EnableIndicator" value="0" onClick="menutab('tmenu6','0')" <cfif EnableIndicator eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Disabled</td>
	    		<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableIndicator" value="1" onClick="menutab('tmenu6','1')" <cfif EnableIndicator eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Enabled</td>
			   </tr>
			</table>   
				
	    </TD>
		</TR>		
		<tr><td></td><td class="Labelit" colspan="3" style="padding-left:20px; color:gray;">Enable the option to register, administer and monitor program indicators and measurement.</td></tr>
				  	
		
		<tr><td height="10"></td></tr>	
	
		<tr class="line"><td colspan="4"></td></tr>	
						
		<tr><td height="40" colspan="4" align="center">	
			<input style="width:120px;height:23" type="Submit" name="Save" value="Update" class="button10g">
		</td></tr>

	</table>

</cfform>	
</cfoutput>	