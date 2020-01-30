
<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_TimeClass
</cfquery>
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_LeaveType
	WHERE  LeaveType = '#URL.ID1#'
</cfquery>

<table width="98%" style="height:100%" cellspacing="0" border="0" align="right" cellpadding="0" class="formpadding">
<tr><td style="height:99%">

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this leave type?")) {
		return true 
	}
	return false	
}	

function toggleme(box,action) {
	
	se = document.getElementsByName(box) 
	cnt = 0
	while (se[cnt]) {
	  se[cnt].className = action
	  cnt++
	}

}

</script>

<cf_divscroll>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog" id="dialog" style="height:90%">

<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" class="formpadding" align="center">

	<tr><td style="padding-top:4px"></td></tr>
	
    <cfoutput>
    <TR>
    <TD style="width:300px" class="labelmedium">Code:</TD>
    <TD style="width:65%">
  	   <input type="text" name="LeaveType" id="LeaveType" value="#get.LeaveType#" size="10" maxlength="4"class="regularxl">
	   <input type="hidden" name="LeaveTypeold" id="LeaveTypeold" value="#get.LeaveType#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium" valign="top" style="padding-top:4px">Description:</TD>
    <TD>
	   <cf_LanguageInput
			TableCode       		= "Ref_LeaveType" 
			Mode            		= "Edit"
			Name            		= "Description"
			Key1Value       		= "#get.LeaveType#"
			Type            		= "Input"
			Required        		= "No"
			Message         		= "Please, enter a valid description."
			MaxLength       		= "50"
			Size            		= "50"
			Class           		= "regularxl"
			Operational     		= "1"
			Label           		= "No">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Parent:</TD>
    <TD>
		<select name="LeaveParent" id="LeaveParent" class="regularxl">
		   <cfloop query="parent">
     	   	<option value="#Parent.TimeClass#" <cfif get.LeaveParent eq "#Parent.TimeClass#">selected</cfif>>#Parent.TimeClass#</option>
       	   </cfloop>	
	    </select>
	</TD>
	</TR>
			
	<cfquery name="Action" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Action
		WHERE ActionSource = 'Leave'	
	</cfquery>
	
	<tr>
	<td class="labelmedium">Record as personnel action:</td>
	<td>
		
		<select name="ActionCode" id="ActionCode" class="regularxl">
		    <option value="">N/A</option>
			<cfloop query="Action">
				<option value="#ActionCode#" <cfif get.ActionCode eq ActionCode>selected</cfif>>#ActionCode# #Description#</option>
			</cfloop>		
		</select>		
		
	</td>
	
	</tr>
	
	<TR>
    <TD class="labelmedium">Enable Self service:</TD>
	<td>
		<table>
			<tr>
			    <td class="labelmedium">
					<INPUT type="radio" class="radiol" name="UserEntry" id="UserEntry" value="1" <cfif get.UserEntry eq "1">checked</cfif>></td>
				<td class="labelmedium">Yes</td>
				<td><INPUT type="radio" class="radiol" name="UserEntry" id="UserEntry" value="0" <cfif get.UserEntry eq "0">checked</cfif>></td>
				<td class="labelmedium">No</td>
				
				<TD style="padding-left:10px" class="labelmedium">Listing Order:</TD>
			    <TD class="labelmedium">
				  	   <cfinput type="text" 
					     class="regularxl" 
						 name="ListingOrder" 
						 id="ListingOrder" 
						 value="#Get.ListingOrder#"
					     size="2" 
						 maxlength="3" 
						 style="text-align: center;" 
						 message="Please enter a serialNo" 
						 validate="integer">
			    </TD>
				
				
			</tr>
		</table>
	</td>				
	</TR>
	
	<tr class="labelmedium"><td style="font-size:22px">Workflow settings</td></tr>
				
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode = 'EntLve'
	</cfquery>
	
	<tr>
	<td  style="padding-left:14px" class="labelmedium">Default Workflow:</td>
	<td>
		
		<select name="Workflow" id="Workflow" class="regularxl">
		    <option value="">N/A</option>
			<cfloop query="WorkFlow">
				<option value="#EntityClass#" <cfif get.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
			</cfloop>		
		</select>		
		
	</td>
	</tr>
			
	<TR>
    <TD style="padding-left:14px" class="labelmedium">Step Supervisor 1:</TD>
    <TD>
	
		<cfquery name="EntityAction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityAction
			WHERE  EntityCode = 'EntLve'
			AND    Operational = 1
			AND    ActionType IN ('Action','Decision')
			ORDER BY ListingOrder
		</cfquery>
	
	    <select name="ReviewerActionCodeOne" class="regularxl">
		    <option value="">N/A</option>
			<cfloop query="EntityAction">
				<option value="#ActionCode#" <cfif get.ReviewerActionCodeOne eq ActionCode>selected</cfif>>#ActionDescription#</option>
			</cfloop>		
		</select>		
	
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium" style="padding-left:14px">Step Supervisor 2:</TD>
    <TD>
	
	    <select name="ReviewerActionCodeTwo" class="regularxl">
		    <option value="">N/A</option>
			<cfloop query="EntityAction">
				<option value="#ActionCode#" <cfif get.ReviewerActionCodeTwo eq ActionCode>selected</cfif>>#ActionDescription#</option>
			</cfloop>		
		</select>		
	
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium" style="padding-left:14px">Step Backup:</TD>
    <TD>
	
		<cfquery name="EntityAction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityAction
			WHERE  EntityCode = 'EntLve'
			AND    Operational = 1
			AND    ActionType IN ('Action','Decision')
			ORDER BY ListingOrder
		</cfquery>
	
	    <select name="HandoverActionCode" id="HandoverActionCode" class="regularxl">
		    <option value="">N/A</option>
			<cfloop query="EntityAction">
				<option value="#ActionCode#" <cfif get.HandoverActionCode eq ActionCode>selected</cfif>>#ActionDescription#</option>
			</cfloop>		
		</select>		
	
	</TD>
	</TR>

	<tr>
		<td  style="padding-left:14px" class="labelmedium">Reviewer mode:</td>
		<td>
			<select name="leaveReviewer" id="leaveReviewer" class="regularxl">
				<option value="Staffing" <cfif get.LeaveReviewer eq "Staffing">selected</cfif>>Staff members with higher grade</option>
				
				<option value="Role" <cfif get.LeaveReviewer eq "Role">selected</cfif>>Role granted access</option>
				<option value="User" <cfif get.LeaveReviewer eq "User">selected</cfif>>System users</option>
			</select>
		</td>
	</tr>
	
	<tr class="labelmedium"><td style="font-size:22px">Accrual and balance control</td></tr>
	
	<TR>
    <TD class="labelmedium">Maximum days in single request:</TD>
    <TD>
  	   <cfinput type="text" class="regularxl" name="Leavemaximum" value="#Get.LeaveMaximum#" size="2" maxlength="3" style="text-align: center;" message="Please enter a maximum" validate="integer">
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" class="labelmedium" style="padding-top:3px">Accrual method:</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
		    <tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveAccrual" onclick="toggleme('accrual','regular')" id="LeaveAccrual" value="1" <cfif get.LeaveAccrual eq "1">checked</cfif>> Accrual setting</td></tr>
			<tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveAccrual" onclick="toggleme('accrual','regular')" id="LeaveAccrual" value="2" <cfif get.LeaveAccrual eq "2">checked</cfif>> Recorded Overtime</td></tr>
			<tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveAccrual" onclick="toggleme('accrual','regular')" id="LeaveAccrual" value="3" <cfif get.LeaveAccrual eq "3">checked</cfif>> Contract Entitlement</td></tr>
			<tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveAccrual" onclick="toggleme('accrual','regular')" id="LeaveAccrual" value="4" <cfif get.LeaveAccrual eq "4">checked</cfif>> Threshold</td></tr>
			<tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveAccrual" onclick="toggleme('accrual','hide')" id="LeaveAccrual" value="0" <cfif get.LeaveAccrual eq "0">checked</cfif>> No Accrual</td></tr>
		</table>
	</TD>
	</TR>	
	
	<cfif get.LeaveAccrual eq "0">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl =" regular">
	</cfif>  
		
	<TR name="accrual" class="#cl#">
    <TD valign="top" class="labelmedium" style="padding-top:3px">Balance calculation Mode:</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveBalanceMode" id="LeaveBalanceMode" value="Absolute" <cfif get.LeaveBalanceMode eq "Absolute">checked</cfif>> Absolute</td>			
			<td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveBalanceMode" id="LeaveBalanceMode" value="Relative" <cfif get.LeaveBalanceMode neq "Absolute">checked</cfif>> Relative</td>
			</tr>
		</table>
	</TD>
	</TR>	
	
	
	<cfif get.LeaveAccrual eq "0">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl =" regular">
	</cfif>  
		
	<TR name="accrual" class="#cl#">
    <TD valign="top" class="labelmedium" style="padding-top:3px">Enable sufficient balance check:</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveBalanceEnforce" id="LeaveBalanceEnforce" value="1" <cfif get.LeaveBalanceEnforce eq "1">checked</cfif>> Yes</td>			
			<td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveBalanceEnforce" id="LeaveBalanceEnforce" value="0" <cfif get.LeaveBalanceEnforce eq "0">checked</cfif>> Disabled</td>
			</tr>
		</table>
	</TD>
	</TR>	
			
	<TR name="accrual" class="#cl#">
	
       <td class="labelmedium">Deduct working days only:</TD>    
	   <td>
		   <table>
			   <tr>
			   <td class="labelmedium"><INPUT type="radio" class="radiol" name="WorkdaysOnly" id="WorkdaysOnly" value="1" <cfif get.WorkDaysOnly eq "1">checked</cfif>></td>
			   <td class="labelmedium">Yes</td>
			   <td class="labelmedium"><INPUT type="radio" class="radiol" name="WorkdaysOnly" id="WorkdaysOnly" value="0" <cfif get.WorkDaysOnly eq "0">checked</cfif>></td>
			   <td class="labelmedium">No</td>	
			   </tr>
		   </table>
	   </td>
	</TR>
	
	<!---
			
	<TR name="accrual" class="#cl#">
	    <TD class="labelmedium">Stop accrual calculation during SLWOP :</TD>
		<td>
		   <table>
			   <tr>
			   
				    <td class="labelmedium">
					  <INPUT type="radio" class="radiol" name="StopAccrual" id="StopAccrual" value="1" <cfif get.StopAccrual eq "1">checked</cfif>>
					</td>
					<td class="labelmedium">Yes</td>
					
					<td>
						<table>
							<tr class="labelmedium">
								<td style="padding-top:1px;padding-left:2px;padding-right:4px">if longer than:</TD>
								<td>
						  		   <cfinput type="text" class="regularxl" tooltip="Set threshold for SLWOP accrual suspension" name="ThresholdSLWOP" value="#Get.ThresholdSLWOP#" size="2" maxlength="3" style="text-align: center;" message="Please enter a threshold for SLWOP before it affects the accrual" 
								     validate="integer">
								</td>	
								<td style="padding-left:4px">days</td>
							</tr>
						</table>	
					</td>
					
					<td style="padding-left:4px"></td>	
					<td><INPUT type="radio" class="radiol" name="StopAccrual" id="StopAccrual" value="0" <cfif get.StopAccrual eq "0">checked</cfif>></td>
					<td class="labelmedium">No</td>
				
			   </tr>									
		 </table>
	   </td>		
	</TR>
	
	--->
	
	<TR name="accrual" class="#cl#">
    <TD class="labelmedium">Payroll sensitive:</TD>
	<td>
		<table>
			<tr>
			    <td class="labelmedium">
					<INPUT type="radio" class="radiol" name="EnablePayroll" id="EnablePayroll" value="1" <cfif get.EnablePayroll eq "1">checked</cfif>></td>
				<td class="labelmedium">Yes, final payment</td>
				<td><INPUT type="radio" class="radiol" name="EnablePayroll" id="EnablePayroll" value="0" <cfif get.EnablePayroll eq "0">checked</cfif>></td>
				<td class="labelmedium">No</td>
			</tr>
		</table>
	</td>				
	</TR>
	
	
		
	<tr><td height="1"></td></tr>
		
	</cfoutput>
	
	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center" height="35">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
	
</TABLE>	
		
</CFFORM>

</cf_divscroll>

</td></tr>

</TABLE>