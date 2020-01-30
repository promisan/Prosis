<cfoutput>

<table width="97%" cellspacing="1" cellpadding="2" align="center">
	
		<tr><td height="12"></td></tr>
		
		<!--- Field: Prosis Applicantion Root Path--->
	    <TR>
	    <td class="regular">Program Allotment:</b></td>
	    <TD class="regular" colspan="3">
			<input type="radio" name="EnableBudget" value="0" <cfif EnableBudget eq "0">checked</cfif>>Disabled
			<input type="radio" name="EnableBudget" value="1" <cfif EnableBudget eq "1">checked</cfif>>Enabled
	    </TD>
		</TR>	
		<tr><td></td></td><td colspan="3" class="header">Disables allotment module.</td></tr>
		
		 <!--- Field: Budget Clearance mode--->
	    <TR>
	    <td class="regular">Budget Clearance mode:</b></td>
	    <TD class="regular" colspan="3">
			<input type="radio" name="BudgetClearance" value="0" <cfif BudgetClearanceTriggerByPeriod eq "0">checked</cfif>>Disabled
			<input type="radio" name="BudgetClearance" value="1" <cfif BudgetClearanceTriggerByPeriod eq "1">checked</cfif>>Enabled
	    </TD>
		</TR>			
		<tr><td height="3"></td></tr>
		<tr><td></td><td colspan="3" class="header">Defines if an allotment should be identified for clearance based its <b>selected</b> period or <b>any</b> period.</td></tr>
		
			
	    <TR>
	    <td class="regular">Indicator (BSC) management:</b></td>
	    <TD class="regular" colspan="3">
	    	<input type="radio" name="EnableIndicator" value="0" onClick="show('0','targetcolor')" <cfif EnableIndicator eq "0">checked</cfif>>Disabled
    		<input type="radio" name="EnableIndicator" value="1" onClick="show('1','targetcolor')" <cfif EnableIndicator eq "1">checked</cfif>>Enabled
	    </TD>
		</TR>		
		<tr><td></td><td class="header" colspan="3">&nbsp;Enable the option to register, administer and monitor program indicators and measurement.</td></tr>
				
	    <TR>
	    <td class="regular">Project Module:</b></td>
	    <TD class="regular" colspan="3">
			<input type="radio" name="EnableGANTT" value="0" <cfif EnableGANTT eq "0">checked</cfif>>Disabled
			<input type="radio" name="EnableGANTT" value="1" <cfif EnableGANTT eq "1">checked</cfif>>Enabled
	    </TD>
		</TR>	
		<tr><td></td></td><td colspan="3" class="header">Disables Project GANTT charts.</td></tr>
								
		<!--- Field: Prosis Applicantion Root Path--->
	    <TR>
	    <td class="regular">Project/Program Entry Mode:</b></td>
	    <TD class="regular" colspan="3">
			<input type="radio" name="EnableEntry" value="0" <cfif EnableEntry eq "0">checked</cfif>>Only for Program Manager
			<input type="radio" name="EnableEntry" value="1" <cfif EnableEntry eq "1">checked</cfif>>Program Manager and Officer	    </TD>
		</TR>	
		<tr><td></td></td><td colspan="3" class="header">Disables entry of new program/project for the role of Program Officer.</td></tr>
					
		<tr><td height="4" colspan="2"></td></tr>
		<tr><td height="1" colspan="4" bgcolor="d4d4d4"></td></tr>
		
		<tr><td height="4" colspan="2"><b>Program Naming</b></td></tr>
		
		<!--- Field: Prosis Applicantion Root Path--->
	    <TR>
	    <td class="regular">&nbsp;Label Hierarchy Level 0:</b></td>
	    <TD class="regular">
			<cfinput class="regular" type="Text" name="TextLevel0" value="#TextLevel0#" message="Please enter a name for level 0 entries" required="Yes" size="20" maxlength="20">
	    </TD>
		
	    <TR>
	    <td class="regular">&nbsp;Label Hierarchy Level 1:</b></td>
	    <TD class="regular">
			<cfinput class="regular" type="Text" name="TextLevel1" value="#TextLevel1#" message="Please enter a name for level 2 entries" required="Yes" size="20" maxlength="20">
	    </TD>		
		</TR>
		
		<tr>
		<td class="regular">&nbsp;Label Hierarchy Level 2:</b></td>
	    <TD class="regular">
			<cfinput class="regular" type="Text" name="TextLevel2" value="#TextLevel2#" message="Please enter a name for level 1 entries" required="Yes" size="20" maxlength="20">
	    </TD>
		</TR>	
			
	    <TR>
	    <td class="regular">&nbsp;Level 1 project entry:</b></td>
	    <TD class="regular" colspan="3">
			<input type="radio" name="EnableProjectLevel1" value="1" <cfif EnableProjectLevel1 eq "1">checked</cfif>>Yes
			<input type="radio" name="EnableProjectLevel1" value="0" <cfif EnableProjectLevel1 eq "0">checked</cfif>>No
	    </TD>
		</TR>	
		<tr><td></td></td><td colspan="3" class="header">Disables registration of projects on level 1</td></tr>
		
		<tr><td height="10"></td></tr>	
	<tr><td height="1" colspan="4"  bgcolor="silver"></td></tr>	
						
	<tr><td height="40" colspan="4" align="center">	
		<input type="button" name="Save" value="Update" class="button10g" onclick="validate()">
	</td></tr>

	</table>
	
</cfoutput>	