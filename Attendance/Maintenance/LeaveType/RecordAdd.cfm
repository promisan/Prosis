<cfparam name="url.idmenu" default="">

<script language="JavaScript">

function hidebox(box,action) {   	
	
	se = document.getElementsByName(box) 	
	cnt = 0		
	while (se[cnt]) {
	  se[cnt].className = action
	  cnt++
	}

}
</script>

<cf_screentop html="Yes" 
			  label="Add Leave Type" 
			  height="100%" 
			  BANNER="gray"
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_TimeClass
</cfquery>

<table width="95%" cellspacing="0" align="center" cellpadding="0" class="formpadding"><tr><td>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog" id="dialog">

<!--- Entry form --->

<table width="98%" cellspacing="0" cellpadding="0" class="formpadding" align="center">

	<tr><td></td></tr>
	
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput class="regularxl" type="text" name="LeaveType" id="LeaveType" value="" message="Please enter a code" required="Yes" size="10" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" valign="top" style="padding-top:4px">Description</TD>
	
    <TD class="labelmedium">
	
  	   <cf_LanguageInput
			TableCode       		= "Ref_LeaveType" 
			Mode            		= "Edit"
			Name            		= "Description"
			Key1Value       		= ""
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
	
	<tr>
    <td class="labelmedium">Parent:</td>
    <td class="labelmedium">
		<select name="LeaveParent" id="LeaveParent" class="regularxl">
		   <cfoutput query="parent">
     	   	<option value="#Parent.TimeClass#">#Parent.TimeClass#</option>
       	   </cfoutput>	
	    </select>
	</td>
	</tr>
			
	<cfquery name="Action" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Action
		WHERE ActionSource = 'Leave'	
	</cfquery>
	
	<td class="labelmedium">PA Action:</td>
	<td>
		
		<select name="ActionCode" id="ActionCode" class="regularxl">
		    <option value="">N/A</option>
			<cfoutput query="Action">
				<option value="#ActionCode#">#Description#</option>
			</cfoutput>		
		</select>		
		
	</td>
				
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode = 'EntLve'
	</cfquery>
	
	<tr>
	<td class="labelmedium">Workflow Class:</td>
	<td>
		
		<select name="Workflow" id="Workflow" class="regularxl">
		    <option value="">N/A</option>
			<cfoutput query="Workflow">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfoutput>		
		</select>		
		
	</td>
	</tr>
	
	<cfoutput>
	<TR>
    <TD class="labelmedium" style="padding-left:14px">Step Supervisor 1:</TD>
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
	
	    <select name="ReviewerActionCodeOne"  class="regularxl">
		    <option value="">N/A</option>
			<cfloop query="EntityAction">
				<option value="#ActionCode#">#ActionDescription#</option>
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
				<option value="#ActionCode#">#ActionDescription#</option>
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
				<option value="#ActionCode#">#ActionDescription#</option>
			</cfloop>		
		</select>		
	
	</TD>
	</TR>
	</cfoutput>
		
	<tr>
		<td class="labelmedium">Reviewer:</td>
		<td>
			<select name="leaveReviewer" id="leaveReviewer" class="regularxl">
				<option value="Staffing">Staff members with higher grade</option>
				<option value="Role">Role granted access</option>
				<option value="User">System users</option>
			</select>
		</td>
	</tr>
	
	<TR>
    <TD class="labelmedium">Maximum days allowed:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxl" name="LeaveMaximum" value="99" message="Please enter a maximum" style="text-align: center;" validate="integer" required="Yes" size="2" maxlength="3">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium" valign="top" style="padding-top:4px">Accrual method :</TD>
    <TD>
	    <table cellspacing="0" cellpadding="0" class="cellspacing">
	    <tr><td class="labelmedium"><INPUT class="radiol" type="radio" onclick="hidebox('accrual','regular')" name="LeaveAccrual" value="1" checked> Accrual record</td></tr>
		<tr><td class="labelmedium"><INPUT class="radiol" type="radio" onclick="hidebox('accrual','regular')" name="LeaveAccrual" value="2"> Recorded Overtime</td></tr>
		<tr><td class="labelmedium"><INPUT class="radiol" type="radio" onclick="hidebox('accrual','regular')" name="LeaveAccrual" value="3"> Contract Entitlement</td></tr>
		<tr><td class="labelmedium"><INPUT class="radiol" type="radio" onclick="hidebox('accrual','hide')" name="LeaveAccrual" value="0"> No</td></tr>
		</TABLE>
	</TD>
	</TR>
			
	<TR name="accrual" class="regular">
    <TD valign="top" class="labelmedium" style="padding-top:3px">Balance calculation Mode:</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveBalanceMode" id="LeaveBalanceMode" value="Absolute" checked> Absolute (default)</td>			
			<td class="labelmedium"><INPUT type="radio" class="radiol" name="LeaveBalanceMode" id="LeaveBalanceMode" value="Relative"> Relative</td>
			</tr>
		</table>
	</TD>
	</TR>	
		
	<TR id="accrual" class="regular">
    <TD class="labelmedium">Threshold SLWOP:</TD>
    <TD>
  	   <cfinput type="text" class="regularxl" tooltip="Set threshold for SLWOP accrual suspension" 
	    name="ThresholdSLWOP" value="30" size="2" maxlength="3" style="text-align: center;" message="Please enter a threshold for SLWOP before it affects the accrual" validate="integer">
    </TD>
	</TR>
	
	<TR id="accrual" class="regular">	
    <TD class="labelmedium">Deduct working days only:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" class="radiol" name="WorkdaysOnly" id="WorkdaysOnly" value="1" checked> Yes
		<INPUT type="radio" class="radiol" name="WorkdaysOnly" id="WorkdaysOnly" value="0"> No
	</TD>
	</TR>
	
	<!---	
	<TR id="accrual" class="regular">
    <TD class="labelmedium">Stop credit calculation:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" class="radiol" name="StopAccrual" id="StopAccrual" value="1"> Yes
		<INPUT type="radio" class="radiol" name="StopAccrual" id="StopAccrual" value="0" checked> No
	</TD>
	</TR>
	--->
		
	<TR>
    <TD class="labelmedium">Self service:</TD>
    <TD>
	    <INPUT type="radio" class="radiol" name="UserEntry" id="UserEntry" value="1" checked> Yes
		<INPUT type="radio" class="radiol" name="UserEntry" id="UserEntry" value="0"> No
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium">Listing Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" class="regularxl" name="ListingOrder" id="ListingOrder" value="1" size="2" maxlength="3" style="text-align: center;" message="Please enter a serialNo" validate="integer">
    </TD>
	</TR>
		
	<tr><td colspan="2" class="linedotted"></td></tr>
		
	<tr>	
		
	<td align="center" colspan="2" height="35">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
	
	</td>	
	
</TABLE>

</CFFORM>


</TABLE>