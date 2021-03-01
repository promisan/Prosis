
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfoutput query="get">

<cfform method="POST" name="formstaffing">

<table width="95%" align="center" class="formspacing formpadding">
			   		
	<TR>
	
	<cf_UIToolTip tooltip="Enable/Disable the option to associate a position to an external reference No (i.e Umoja SAIT)">
   		<td class="labelmedium2" style="cursor: pointer;">External Position Administration:</td>
	</cf_UIToolTip>
	
    <td><input type="checkbox" class="radiol" name="EnableSourcePost" <cfif EnableSourcePost eq "1">checked</cfif> value="1"></td>
	
    </tr>	
		
	<tr><td colspan="1" style="font-size:25px;height:45px" class="labellarge">Assignment Settings</font></td>	
		<td valign="bottom" class="labelmedium2"><font face="Calibri" size="2">All assignment actions are tracked as a Personnel Action (0001 ~ 0007). The workflow depends on the setting</td>			
	</tr>
	<tr><td class="linedotted" colspan="2"></td></tr>
			
	<tr class="labelmedium2">
    	<td style="padding-left:10px;cursor: pointer;">Enable Assignment Entry:</b></td>
	    <TD>	
			<table>
				<tr>
					<td><input type="radio" class="radiol" name="AssignmentEntryDirect" <cfif AssignmentEntryDirect eq "1">checked</cfif> value="1"></td><td style="padding-left:5px" class="labelmedium2">Enable</td>
					<td><input type="radio" class="radiol" name="AssignmentEntryDirect" <cfif AssignmentEntryDirect eq "0">checked</cfif> value="0"></td><td style="padding-left:5px" class="labelmedium2">Disable, only through recruitment track</td>
				</tr>
			</table>
    	</td>
    </tr>	
	
	<tr class="labelmedium2">
    	<td style="padding-left:10px;cursor: pointer;">Highlight Expiring assigments:</b></td>
	    <TD>	
		<cfinput type="text" name="AssignmentExpiration" validate="integer" value="#AssignmentExpiration#" class="regularxxl" style="text-align:center;width:30"> days in advance
	   	</td>
    </tr>		
	
	<TR class="labelmedium2">
	<td style="padding-left:10px;cursor: pointer;cursor: pointer;">
		<cf_UIToolTip tooltip="Enable/Disable the requirement to clear assignment transactions">
		Assignment Entry and -Amendment Workflow:
		</cf_UIToolTip>
	</td>
	
	<td class="labelmedium2">
	<table>
	<tr>
	<td><input type="radio" class="radiol" name="AssignmentClear" <cfif AssignmentClear eq "0">checked</cfif> value="0"></td><td style="padding-left:5px" class="labelmedium2">N/A</td>
    <TD><input type="radio" class="radiol" name="AssignmentClear" <cfif AssignmentClear eq "1">checked</cfif> value="1"></td><td style="padding-left:5px" class="labelmedium2">Single Approval</td>
	<TD><input type="radio" class="radiol" name="AssignmentClear" <cfif AssignmentClear eq "2">checked</cfif> value="2"></td><td style="padding-left:5px" class="labelmedium2">Workflow</td>
	</tr>
	</table>
	</td>
    </tr>
	
	
	<TR class="labelmedium2">
	    <td style="padding-left:10px;cursor: pointer;" width="190"><cf_UIToolTip tooltip="Enable Transfer workflow for actions that are Personnel Actions">Transfer&nbsp;(0006)&nbsp;or&nbsp;Change&nbsp;Title&nbsp;(0007)&nbsp;Workflow:</b></cf_UIToolTip></td>
	    <TD width="75%">
		
		    <cfdiv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=Assignment" id="wfPersonAssignment">
		
			</td>
    </tr>
	
	<tr>
		<td class="labelit" colspan="2" style="padding-left:60px"><b>Attention: </b>Workflow will <b>ONLY</b> be triggered for <b>post types</b> which are workflow enabled (Post type maintenance). 
		If workflow is not enabled, the standard one step clearance applies.
		The workflow class is determed by the assignment action as it is determined by the system (0001 - 0007)</i></td>	
	</tr>
	
	<TR class="labelmedium2">
    <td style="padding-left:10px;cursor: pointer;">Assignment Location Lookup:</b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="AssignmentLocation" <cfif AssignmentLocation eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Default</td>
			<td><input type="radio" class="radiol" name="AssignmentLocation" <cfif AssignmentLocation eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Advanced (material mgts)</td>	
		</tr>
	</table>		
    </td>
    </tr>
	
	<tr><td style="font-size:25px;height:45px" class="labellarge" colspan="2">Miscellaneous Settings</td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	<TR class="labelmedium2">
	<cf_UIToolTip tooltip="Enforce Position to be associated to a grade which has been enabled in the Function Maintenance">
    <td style="padding-left:10px;cursor: pointer;">Enforce Position Grade:</b></td>
	</cf_UIToolTip>
    <TD>	
	<input class="radiol" type="checkbox" name="EnforceGrade" <cfif EnforceGrade eq "1">checked</cfif> value="1">
    </td>
    </tr>
	
	<TR class="labelmedium2">
    <td style="padding-left:10px;cursor: pointer;">Fund registration:</b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="ShowPositionFund" <cfif ShowPositionFund eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Disabled</td>
			<td><input type="radio" class="radiol" name="ShowPositionFund" <cfif ShowPositionFund eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Show all funding</td>	
			<td><input type="radio" class="radiol" name="ShowPositionFund" <cfif ShowPositionFund eq "2">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Show edition funds only</td>	
    	</tr>
	</table>		
    </td>
    </tr>
	
	
	<TR class="labelmedium2">
    <td style="padding-left:10px;cursor: pointer;">Position Period:</b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="ShowPositionPeriod" <cfif ShowPositionPeriod eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Edit</td>
			<td><input type="radio" class="radiol" name="ShowPositionPeriod" <cfif ShowPositionPeriod eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Automatic</td>	
		</tr>
	</table>		
    </td>
    </tr>
	
	<TR class="labelmedium2">
    <td style="padding-left:10px;cursor: pointer;">Entity Assignment Start and End:</b></td>
    <TD>
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="EnableMissionPeriod" <cfif EnableMissionPeriod eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Edit</td>
			<td><input type="radio" class="radiol" name="EnableMissionPeriod" <cfif EnableMissionPeriod eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Generate automatically</td>
		</tr>
	</table>		
    </td>
    </tr>
		
	<TR class="labelmedium2">
	<cf_UIToolTip tooltip="Shows additional rows in the staffing table view">
    <td style="padding-left:10px;cursor: pointer;">Staffing View Mode:</b></td>
	</cf_UIToolTip>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="StaffingViewMode" <cfif StaffingViewMode eq "Standard">checked</cfif> value="Standard"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Standard</td>
			<td><input type="radio" class="radiol" name="StaffingViewMode" <cfif StaffingViewMode eq "Extended">checked</cfif> value="Extended"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Extended (Make Temporary Posts visible)</td>
		</tr>
	</table>		
    </td>
    </tr>
	
	<TR class="labelmedium2">
	<cf_UIToolTip tooltip="Refresh mode of the staffing table view">
    <td style="padding-left:10px;cursor: pointer;">Staffing table View Load Mode:</b></td>
	</cf_UIToolTip>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="StaffingViewLoad" <cfif StaffingViewLoad eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Cache on server</td>
			<td><input type="radio" class="radiol" name="StaffingViewLoad" <cfif StaffingViewLoad eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Refresh on opening</td>
		</tr>
	</table>		
    </td>
    </tr>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" style="font-size:25px;height:45px" class="labellarge">Recruitment Integration Settings</td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	<TR class="labelmedium2">
	<cf_UIToolTip tooltip="Allow Employee record to be generated from the recruitment track once a candidate is selected (2s)">
    <td style="padding-left:10px;cursor: pointer;">Create Employee record for candidate:</b></td>
	</cf_UIToolTip>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="TrackToEmployee" <cfif TrackToEmployee eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Enabled</td>
			<td><input type="radio" class="radiol" name="TrackToEmployee" <cfif TrackToEmployee eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Disabled</td>	
		</tr>
	</table>
    </td>
    </tr>
			
	<TR class="labelmedium2">
	<cf_UIToolTip tooltip="Create Applicant records for all Employees recorded under this entity (Batch)">
    <td style="padding-left:10px;cursor: pointer;">Applicant records:</b></td>
	</cf_UIToolTip>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td><input type="radio" class="radiol" name="StaffingApplicant" <cfif StaffingApplicant eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Enabled</td>
			<td><input type="radio" class="radiol" name="StaffingApplicant" <cfif StaffingApplicant eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:5px;padding-right:10px">Disabled</td>	
		</tr>
	</table>
    </td>
    </tr>
	
	<tr><td></td>
	<td class="labelit"><font color="808080">Applicant records will be created and/or synced based on the match of the PersonNo, IndexNo <br>or match of the LastName,FirstName (first letter match is sufficient),DOB and Nationality.</td>
	</tr>
	
	<!--- disabled 
		
	<tr><td height="15"></td></tr>
	
	<tr><td colspan="2"><b>Settings to improve performance for low-bandwidth sites</td></tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	
	<TR>
    <td>Staffing Dropdown Menu:</b></td>
    <TD>
	<input type="radio" name="EnableStaffingMenu" <cfif #EnableStaffingMenu# eq "1">checked</cfif> value="1">Enabled
	<input type="radio" name="EnableStaffingMenu" <cfif #EnableStaffingMenu# eq "0">checked</cfif> value="0">Disabled
    </td>
    </tr>
	
	--->
					
	<tr><td colspan="2" align="center">
	<input type    = "button" 
	       class   = "button10g" 
		   style   = "height:25px;width:130px"
		   value   = "Update"
	       name    = "Update" 
		   onclick = "ptoken.navigate('ParameterEditStaffingSubmit.cfm?mission=#url.mission#','contentbox1','','','POST','formstaffing')">
	</td></tr>
	
	</table>
	
</cfform>	
	
</cfoutput>	

