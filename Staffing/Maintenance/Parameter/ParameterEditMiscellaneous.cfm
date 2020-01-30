
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter
</cfquery>

<cfquery name="Address" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AddressType
</cfquery>

<cfoutput query="get">

<cfform method="POST"
   name="formmiscell">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<tr><td height="5"></td></tr>	
	
	<TR>
    <td class="labelmedium">Personnel Action Mode:</b></td>
    <TD class="labelmedium">	
	<table><tr>
	  <td><input type="radio" name="ActionMode" <cfif ActionMode eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium">Enabled (strongly recommended)</td>
	  <td><input type="radio" name="ActionMode" <cfif ActionMode eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium">Disabled</td>
	  </tr>
	</table>   	
    </td>
    </tr>	
	<tr><td></td><td class="labelmedium">
	<font color="808080">
	- If enabled the system will separately record a personnel action entry for contract, assignments, leave and dependent entries and/or amendments.<br>
	- It will create a clearance workflow only if this enabled for the action class for that entity (refer to the other tabs in this function). <br>
	- If no workflow is enabled the action is considered approved upon submission
	</font></td></tr>
			
	<TR>
    <td style="height:25px;width:300px" class="labelmedium">Edit/Show Dependent Entitlements:</b></td>
    <TD class="labelmedium">	
	<table><tr>
	  <td><input class="radiol" type="radio" name="DependentEntitlement" id="DependentEntitlement" <cfif DependentEntitlement eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium">Show even if payroll is disabled</td>
	  <td><input class="radiol" type="radio" name="DependentEntitlement" id="DependentEntitlement" <cfif DependentEntitlement eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium">Only if Payroll is enabled</td>
	  </tr></table>   	
    </td>
    </tr>		
	
	<TR>
    <td style="height:25px;width:300px" class="labelmedium">Enable Custom Fields Employee:</b></td>
    <TD class="labelmedium">	
	 <table><tr>
	  <td><input class="radiol" type="radio" name="EnablePersonGroup" id="EnablePersonGroup" <cfif EnablePersonGroup eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium">No</td>
	  <td><input class="radiol" type="radio" name="EnablePersonGroup" id="EnablePersonGroup" <cfif EnablePersonGroup eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium">Yes</td>
	  </tr></table>   
		
    </td>
    </tr>		
		
		
	<TR>
    <td style="height:25px;width:300px" class="labelmedium">Create candidate upon personnel record:</b></td>
    <TD class="labelmedium">	 
	  <table><tr>
	  <td><input class="radiol" type="radio" name="GenerateApplicant" id="GenerateApplicant" <cfif Get.GenerateApplicant eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium">No</td>
	  <td><input class="radiol" type="radio" name="GenerateApplicant" id="GenerateApplicant" <cfif Get.GenerateApplicant eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium">Yes</td>
	  </tr></table>   
    </td>
    </tr>
	
	<TR>
    <td style="height:25px;width:300px" class="labelmedium">Enforce Leave request fields:</b></td>
    <TD>	
	<table><tr>
	<td ><input type="radio" class="radiol" name="LeaveFieldsEnforce" <cfif get.LeaveFieldsEnforce eq "0">checked</cfif> value="0"></td><td style="padding-left:4px" class="labelmedium">Disabled</td>
	<td style="padding-left:4px" ><input class="radiol" type="radio" name="LeaveFieldsEnforce" <cfif get.LeaveFieldsEnforce eq "1">checked</cfif> value="1"></td><td style="padding-left:4px"  class="labelmedium">Enabled</td>	
	</tr>
	</table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Indexno Label:</b></td>
    <TD>	
	
	   <table><tr><td>
			<cfinput type="Text"
	       name="IndexNoName"
	       value="#IndexNoName#"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"    
	       maxlength="10"
	       style="width:75px"
	         class="regularxl">
		 
		 </td>
		 
		 <td class="labelmedium" style="padding-left:10px">Indexno Last:</b></td>
		 
		 <td>
		 <cfinput type="Text"
	       name="IndexNo"
	       value="#IndexNo#"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"    
	       maxlength="10"
	       style="width:50px;text-align:center"
	         class="regularxl">
		 </td>
		 
		 <td class="labelmedium" style="padding-left:5px"><font color="808080">Leave blank to allow for manual entry</td>
		 
		 </tr>
		 
		 </table>
	   </td>
    </tr>	
	
	<TR>
    <td class="labelmedium">Profile Picture:</b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
	<tr><td class="labelmedium">Height:</td><td style="padding-left:4px">
		<cfinput type="Text"
	       name="PictureWidth"
    	   validate="integer"
		   value="#PictureWidth#"
		   style="width:35px"
	       required="Yes"
		   class="regularxl"
	       visible="Yes"
	       enabled="Yes">
	   </td><td class="labelmedium" style="padding-left:10px">Width:</td>
	    <td style="padding-left:4px">
		<cfinput type="Text"
	       name="PictureHeight"
    	   validate="integer"
		   value="#PictureHeight#"
		   style="width:35px"
	       required="Yes"
		   class="regularxl"
	       visible="Yes"
	       enabled="Yes">		
		</td></tr>
	</table>
	</td>
    </tr>	
	
	<TR>
    <td style="cursor: pointer;" class="labelmedium">
	<cf_UIToolTip  tooltip="Show address information in employee profile banner">Profile Address:</cf_UIToolTip>
	</td>
    <TD>	
	
		<cfselect name="AddressType" class="regularxl" tooltip="Show address information in employee profile banner">
			<cfloop query="Address">
				<option value="#AddressType#" <cfif addresstype eq get.addresstype>selected</cfif>>#Description#</option>
			</cfloop>
		</cfselect>
	
	</td>
    </tr>			
		
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" align="center">
	<input type="button" 
	       class="button10s" style="width:120"
		   value="Save"
	       name="Update" 
		   onclick=" if (confirm('These settings will apply to all entities. Do you want to continue?')) ColdFusion.navigate('ParameterEditMiscellaneousSubmit.cfm','contentbox1','','','POST','formmiscell')">
	</td></tr>
	
	<tr><td height="5"></td></tr>
			
	</table>
</CFFORM>		
	
</cfoutput>	