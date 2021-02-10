
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfquery name="PA" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_LeaveType
	WHERE  ActionCode IN (SELECT ActionCode FROM Ref_Action) 
</cfquery>

<cfoutput query="get">

<cfform method="POST"
  name="formleave">
  
<table width="95%" align="center" class="formpadding formspacing">
	
	<tr><td height="5"></td></tr>	
	
	<TR>
	    <td width="170" class="labelmedium2"><cf_UIToolTip tooltip="Enable Leave workflow">PA Leave Workflow:</b></cf_UIToolTip></td>
								 
	    <TD width="75%" class="labelmedium2">
		
		    <cf_securediv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=EntLve" 
			  id="wfPersonLeave">
		
			</td>
    </tr>
		
	<tr>
	   <td class="labelmedium2">Personnel Action enabled leave:</td>
	   <td>
	   <table>
	   <cfloop query="PA">
	   <tr><td class="labelmedium">#Description#</td></tr>
	   </cfloop>
	   </table>
	   </td>
	
	</tr>
	
	<TR>
    <td class="labelmedium2">Leave Balance Auto calculate:</b></td>
    <TD>	
	<table>
		<tr>
		<td><input type="radio" class="radiol" name="BatchLeaveBalance" <cfif BatchLeaveBalance eq "0">checked</cfif> value="0"></td><td style="padding-left:4px" class="labelmedium">Disabled</td>
		<td style="padding-left:4px" ><input class="radiol" type="radio" name="BatchLeaveBalance" <cfif BatchLeaveBalance eq "1">checked</cfif> value="1"></td><td style="padding-left:4px" class="labelmedium">Enabled</td>	
		</tr>
	</table>
    </td>
    </tr>
	
	
	<TR>
    <td class="labelmedium2">Disable Timesheet:</b></td>
    <TD>	
	<table><tr>
	<td ><input type="radio" class="radiol" name="DisableTimesheet" <cfif DisableTimesheet eq "0">checked</cfif> value="0"></td><td style="padding-left:4px" class="labelmedium">No,enabled</td>
	<td style="padding-left:4px" ><input class="radiol" type="radio" name="DisableTimesheet" <cfif DisableTimesheet eq "1">checked</cfif> value="1"></td><td style="padding-left:4px"  class="labelmedium">Disabled</td>	
	</tr>
	</table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium2">Payroll Overtime:</b></td>
    <TD>	
	<table><tr>
	<td ><input type="radio" class="radiol" name="OvertimePayroll" <cfif OvertimePayroll eq "0">checked</cfif> value="0"></td><td style="padding-left:4px" class="labelmedium">Disabled</td>
	<td style="padding-left:4px" ><input class="radiol" type="radio" name="OvertimePayroll" <cfif OvertimePayroll eq "1">checked</cfif> value="1"></td><td style="padding-left:4px"  class="labelmedium">Enabled</td>	
	</tr>
	</table>
    </td>
    </tr>
	
	<tr> <td colspan="2" class="line"> </td> </tr>
		
	<tr><td colspan="2" align="center">
	<input type="button" 
	       class="button10g"
		   value="Update"
	       name="Update" 
		   onclick="ptoken.navigate('ParameterEditLeaveSubmit.cfm?mission=#url.mission#','contentbox1','','','POST','formleave')">
	</td></tr>	
	
	<tr><td height="5"></td></tr>
	
	</table>

</cfform>	
</cfoutput>	