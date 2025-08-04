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

<table width="95%" align="center" class="formpadding formspacing">
		
	<tr><td height="5"></td></tr>	
	
	<TR>
    <td class="labelmedium2">Personnel Action Mode:</b></td>
    <TD class="labelmedium2">	
	<table><tr>
	  <td><input type="radio" name="ActionMode" <cfif ActionMode eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium2">Enabled (strongly recommended)</td>
	  <td><input type="radio" name="ActionMode" <cfif ActionMode eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium2">Disabled</td>
	  </tr>
	</table>   	
    </td>
    </tr>	
	<tr><td></td><td class="labelmedium2">
	<font color="808080">
	- If enabled the system will separately record a personnel action entry for contract, assignments, leave and dependent entries and/or amendments.<br>
	- It will create a clearance workflow only if this enabled for the action class for that entity (refer to the other tabs in this function). <br>
	- If no workflow is enabled the action is considered approved upon submission
	</font></td></tr>
			
	<TR>
    <td style="height:25px;width:300px" class="labelmedium2">Edit/Show Dependent Entitlements:</b></td>
    <TD class="labelmedium2">	
	<table><tr>
	  <td><input class="radiol" type="radio" name="DependentEntitlement" id="DependentEntitlement" <cfif DependentEntitlement eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium2">Show even if payroll is disabled</td>
	  <td><input class="radiol" type="radio" name="DependentEntitlement" id="DependentEntitlement" <cfif DependentEntitlement eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium2">Only if Payroll is enabled</td>
	  </tr></table>   	
    </td>
    </tr>		
	
	<TR>
    <td style="height:25px;width:300px" class="labelmedium2">Enable Custom Fields Employee:</b></td>
    <TD class="labelmedium2">	
	 <table><tr>
	  <td><input class="radiol" type="radio" name="EnablePersonGroup" id="EnablePersonGroup" <cfif EnablePersonGroup eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium2">No</td>
	  <td><input class="radiol" type="radio" name="EnablePersonGroup" id="EnablePersonGroup" <cfif EnablePersonGroup eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium2">Yes</td>
	  </tr></table>   
		
    </td>
    </tr>		
		
		
	<TR>
    <td style="height:25px;width:300px" class="labelmedium2">Create candidate upon personnel record:</b></td>
    <TD class="labelmedium2">	 
	  <table><tr>
	  <td><input class="radiol" type="radio" name="GenerateApplicant" id="GenerateApplicant" <cfif Get.GenerateApplicant eq "0">checked</cfif> value="0"></td>
	  <td class="labelmedium2">No</td>
	  <td><input class="radiol" type="radio" name="GenerateApplicant" id="GenerateApplicant" <cfif Get.GenerateApplicant eq "1">checked</cfif> value="1"></td>
	  <td class="labelmedium2">Yes</td>
	  </tr></table>   
    </td>
    </tr>
	
	<TR>
    <td style="height:25px;width:300px" class="labelmedium2">Enforce Leave request fields:</b></td>
    <TD>	
	<table><tr>
	<td ><input type="radio" class="radiol" name="LeaveFieldsEnforce" <cfif get.LeaveFieldsEnforce eq "0">checked</cfif> value="0"></td><td style="padding-left:4px" class="labelmedium2">Disabled</td>
	<td style="padding-left:4px" ><input class="radiol" type="radio" name="LeaveFieldsEnforce" <cfif get.LeaveFieldsEnforce eq "1">checked</cfif> value="1"></td><td style="padding-left:4px"  class="labelmedium2">Enabled</td>	
	</tr>
	</table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium2">Indexno Label:</b></td>
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
	         class="regularxxl">
		 
		 </td>
		 
		 <td class="labelmedium2" style="padding-left:10px">Indexno Last:</b></td>
		 
		 <td>
		 <cfinput type="Text"
	       name="IndexNo"
	       value="#IndexNo#"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"    
	       maxlength="10"
	       style="width:50px;text-align:center"
	         class="regularxxl">
		 </td>
		 
		 <td class="labelmedium2" style="padding-left:5px"><font color="808080">Leave blank to allow for manual entry</td>
		 
		 </tr>
		 
		 </table>
	   </td>
    </tr>	
	
	<TR>
    <td class="labelmedium2">Profile Picture:</b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
	<tr><td class="labelmedium2">Height:</td><td style="padding-left:4px">
		<cfinput type="Text"
	       name="PictureWidth"
    	   validate="integer"
		   value="#PictureWidth#"
		   style="width:35px"
	       required="Yes"
		   class="regularxxl"
	       visible="Yes"
	       enabled="Yes">
	   </td><td class="labelmedium2" style="padding-left:10px">Width:</td>
	    <td style="padding-left:4px">
		<cfinput type="Text"
	       name="PictureHeight"
    	   validate="integer"
		   value="#PictureHeight#"
		   style="width:35px"
	       required="Yes"
		   class="regularxxl"
	       visible="Yes"
	       enabled="Yes">		
		</td></tr>
	</table>
	</td>
    </tr>	
	
	<TR>
    <td style="cursor: pointer;" class="labelmedium2" title="Show address information in employee profile banner">Profile Address:</td>
    <TD>	
	
		<cfselect name="AddressType" class="regularxxl">
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
	       class="button10g" style="width:120"
		   value="Save"
	       name="Update" 
		   onclick=" if (confirm('These settings will apply to all entities. Do you want to continue?')) ptoken.navigate('ParameterEditMiscellaneousSubmit.cfm','contentbox1','','','POST','formmiscell')">
	</td></tr>
	
	<tr><td height="5"></td></tr>
			
	</table>
</CFFORM>		
	
</cfoutput>	