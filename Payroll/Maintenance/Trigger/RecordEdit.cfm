<cfparam name="url.idmenu" default="">
<cfparam name="URL.ID1" default="">

<cfquery name="Get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_PayrollTrigger
	WHERE  SalaryTrigger = '#URL.ID1#'
</cfquery>

<cfquery name="Check"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_PayrollComponent
	WHERE  SalaryTrigger = '#URL.ID1#'
</cfquery>


<cfquery name="Group"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_TriggerGroup
</cfquery>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  title="Trigger" 			  
			  label="Trigger" 
			  line="no"
			  jquery="yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfajaximport tags="cfwindow">
<cf_tl id="Do you want to remove this group ?" var="lblRemove">

<cfoutput>
	<script>

	function ask() {
		if (confirm("Do you want to remove this Code?")) {	
		return true 	
		}	
		return false	
	}	

	function editGroup(SalaryTrigger, EntitlementGroup) {
		try { ColdFusion.Window.destroy('weditgroup',true) } catch(e) {}
		ColdFusion.Window.create('weditgroup', 'Payroll Trigger Group', '',{x:100,y:100,height:400,width:500,modal:true,resizable:false,center:true});	
		ptoken.navigate('#session.root#/payroll/Maintenance/Trigger/PayrollTriggerGroup/RecordView.cfm?SalaryTrigger='+SalaryTrigger+'&EntitlementGroup='+EntitlementGroup,'weditgroup')
	}

	function removeGroup(SalaryTrigger, EntitlementGroup) {
		if (confirm('#lblRemove#')) {
			ptoken.navigate('#session.root#/payroll/Maintenance/Trigger/PayrollTriggerGroupPurge.cfm?SalaryTrigger='+SalaryTrigger+'&EntitlementGroup='+EntitlementGroup,'divPayrollTriggerGroup')
		}
	}

	</script>
</cfoutput>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td height="15"></td></tr>
    <cfoutput>
			
	<TR>
    <TD class="labelmedium" width="20%"><cf_tl id="Trigger Group">:</TD>
    <TD><select name="TriggerGroup" onchange="toggle(this.value)" class="regularxl" style="width:300px">
     	   <cfloop query="Group">
        	   <option value="#TriggerGroup#" <cfif get.TriggerGroup eq triggergroup>selected</cfif>>#Description#</option>
         	</cfloop>
	    </select>		
    </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD><cfinput type="text" name="SalaryTrigger" value="#get.SalaryTrigger#" message="Please enter a code" required="Yes" size="20" maxlength="30" class="regularxl">
       <input type="hidden" name="Codeold" value="#get.SalaryTrigger#" class="regular">
    </TD>
	</TR>	

	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD><cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required="yes" size="30" 
	   maxlength = "50" class= "regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Instruction">:</TD>
    <TD><textarea style="font-size:13px;width:95%;height:70;padding:3px" class="regular" name="TriggerInstruction">#get.TriggerInstruction#</textarea>
    </TD>
	</TR>
	
	<script>
	
	function toggle(val) {
	  
			 if (val != "Entitlement")  {		     
			     document.getElementById("contractbox").className = "hide"
			 } else {	   
			     document.getElementById("contractbox").className = "regular"
			 }	 
		 }
	
	</script>
	
				
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Applies to">:</TD>
    <TD class="labelmedium">
	<table>
	   <tr class="labelmedium"><td><INPUT class="radiol" type="radio" onclick="document.getElementById('pointer').className='hide'" name="TriggerCondition" value="None" <cfif "None" eq get.TriggerCondition  or get.TriggerCondition eq "">checked</cfif>></td>
	   <TD colspan="4" style="padding-left:5px">Employee only</td>
	   
	   
	   </tr>
	   <tr class="labelmedium">
	     <td><INPUT class="radiol" type="radio" onclick="document.getElementById('pointer').className='regular'" name="TriggerCondition" value="Dependent" <cfif "Dependent" eq get.TriggerCondition>checked</cfif>></td>			 
		 <TD colspan="1" style="padding-left:5px">Dependent and Staffmember</TD>	     	
		 <td style="padding-left:5px">: Counter dependent trigger:</td>
		 <TD style="padding-left:4px">
		      <select name="TriggerDependent" class="regularxl" style="width:300px">
			    <option value=""><cf_tl id="NA"></option>
	        	<option value="#Get.TriggerDependent#" <cfif get.TriggerDependent eq get.SalaryTrigger>selected</cfif>>#get.TriggerDependent#</option>
	        	<cfif get.TriggerDependent neq "Insurance">
		        	<option value="Insurance" <cfif get.TriggerDependent eq "Insurance">selected</cfif>>Default (Insurance Coverage)</option>
	        	</cfif>
				<cfif get.TriggerDependent neq get.SalaryTrigger>
		        	<option value="#Get.SalaryTrigger#" <cfif get.TriggerDependent eq get.SalaryTrigger>selected</cfif>>#get.SalaryTrigger#</option>
				</cfif>
		    </select>
	     </TD>	
		 
	   </tr>	
	</table>
	</TD>
	</TR>
		
	<cfif get.TriggerCondition eq "Dependent">
		<cfset cl = "regular">
	<cfelse>
	    <cfset cl = "hide">
	</cfif>
	
	<TR class="#cl#" id="pointer">
    <TD class="labelmedium" style="padding-right:4px" align="right"><cf_tl id="Dependent pointers">:</TD>
    <TD class="labelmedium" >
		
	  <cfinput type="text" 
	   name="TriggerConditionPointer" 
	   value="#get.TriggerConditionPointer#" tooltip="Pointer to apply different rates based on the number of dependents for an employee" size="20" 
	   maxlength="20" class= "regularxl">
	
	</TD>
	</TR>
		
	<script language="JavaScript">
	
	function formula(val) {
	  
		 if (val != "rate")  {		     
		     document.getElementById("formulabox").className = "hide"
		 } else {	   
		     document.getElementById("formulabox").className = "regular"
		 }
	 
	 }
	
	</script>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Calculation Class">:</TD>
    <TD>
	    <table><tr><td>
	    <INPUT type="radio" class="radiol" name="EntitlementClass" onclick="javascript:formula('percentage')"  value="Percentage" <cfif "Percentage" eq "#get.EntitlementClass#">checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Percentage"></td>
		<td style="padding-left:4px">
	    <INPUT type="radio" class="radiol" name="EntitlementClass" onclick="javascript:formula('rate')" value="Rate" <cfif "Rate" eq get.EntitlementClass or get.EntitlementClass eq "">checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Rate"></td>
		</tr>
		</table>
	</TD>
	</TR>	
	
	<cfif get.EntitlementClass eq "Rate" or get.EntitlementClass eq "">
	    <cfset cl = "regular">
	<cfelse>
		<cfset cl = "hide">  
	</cfif>
	
	<TR id="formulabox" class="<cfoutput>#cl#</cfoutput>">
    <TD class="labelmedium"><cf_tl id="Rate mode">:</TD>
    <TD>
	    <table><tr><td>
	    <INPUT type="radio" class="radiol" name="EnableAmount" value="0" <cfif get.EnableAmount eq "0" or get.EnableAmount eq "">checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Rate"></td>
		<td style="padding-left:4px">
	    <INPUT type="radio" class="radiol" name="EnableAmount" value="2" <cfif get.EnableAmount eq "1">checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Amount"><cf_tl id="Formula"></td>
		</tr>
		</table>
	</TD>
	</TR>	
	
	<cfif get.TriggerGroup neq "Entitlement">
	    <cfset cl = "regular">
	<cfelse>
		<cfset cl = "regular">  
	</cfif>
		
	<TR id="contractbox" class="<cfoutput>#cl#</cfoutput>">
    <TD class="labelmedium" style="cursor:pointer;padding-top:4px" valign="top">
		<cf_UItooltip tooltip="Entitlement can be enabled/disabled as part of the <br> employee contract registration screen and will inherit the contract effective dates">
			<cf_tl id="Associated to contract">:
		</cf_UItooltip>
	</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
		<tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="EnableContract" value="0" <cfif "1" neq get.EnableContract>checked</cfif>> No	</td></tr>
		<tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="EnableContract" value="1" <cfif "1" eq get.EnableContract>checked</cfif>> Yes, default unchecked </td></tr>
		<tr><td class="labelmedium"><INPUT type="radio" class="radiol" name="EnableContract" value="2" <cfif "2" eq get.EnableContract>checked</cfif>> Yes, default checked</td></tr>
		</table>
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Entitlement Period">:</TD>
    <TD>
	    <table><tr><td>
	    <INPUT type="radio" class="radiol" name="EnablePeriod" value="1" <cfif 1 eq get.EnablePeriod or get.EnablePeriod eq "">checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Effective">-<cf_tl id="Expiration"></td>
		<td style="padding-left:14px">
	    <INPUT type="radio" class="radiol" name="EnablePeriod" value="0" <cfif "0" eq get.EnablePeriod>checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Single date"></td>
		</tr>
		</table>
	</TD>
	</TR>	

	<TR>
    <TD class="labelmedium"><cf_tl id="Operational">:</TD>
    <TD CLASS="labelmedium">
	
	<table>
	<tr>
	<td><INPUT type="radio" class="radiol" name="Operational" value="1" <cfif "1" eq get.Operational>checked</cfif>></td>
	<td style="padding-left:5px"><cf_tl id="Yes"></td>
	<td style="padding-left:5px"><INPUT type="radio" class="radiol" name="Operational" value="0" <cfif "1" neq get.Operational>checked</cfif>></td>
	<td style="padding-left:5px"><cf_tl id="No"></td>
	</tr>
	</table>
		
	</TD>
	</TR>

	<cfif trim(url.id1) neq "">
		<tr>
			<TD class="labelmedium" valign="top" style="padding-top:5px;"><cf_tl id="Entitlement Grouping">:</TD>
			<td valign="top" style="padding-top:3px;">
				<cfdiv id="divPayrollTriggerGroup" bind="url:#session.root#/Payroll/Maintenance/Trigger/PayrollTriggerGroup/RecordListing.cfm?payrollTrigger=#url.id1#">
			</td>
		</tr>
	</cfif>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="30">

		<cfif url.id1 eq "">
				
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    	<input class="button10g" type="submit" name="Insert" value=" Save ">
		
		<cfelse>	
		
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
			<cfif check.recordcount eq "0">
		    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
			</cfif>
		    <input class="button10g" type="submit" name="Update" value=" Update ">
			
		</cfif>
	
	</td></tr>
				
</TABLE>

</CFFORM>

