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
<cfquery name = "ClaimType" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT * FROM Ref_ClaimType
	WHERE Code = '#URL.ID1#'

</cfquery>


<CFFORM onsubmit="return false" name="editGeneral">
<cfoutput query="ClaimType">

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		
    <TR>
    <TD class="labelit"><cf_tl id="Code">:</TD>
    <TD>
		#Code#
		<input type="hidden" value="#Code#" name="Code" class="regularxl">
	</TD>
	</TR>
	
    <TR>
    <TD class="labelit"><cf_tl id="Description">:</TD>
    <TD class="labelit">
		<cf_tl id="Please add a description" var="1">
		<cfinput name="Description" value="#Description#" type="text" required="yes" size="40" maxlength="50" message="#lt_text#" class="regularxl">
	</TD>
	</TR>
	
	
    <TR>
    <TD class="labelit"><cf_tl id="Claimant"> <font color="red">*</font>:</TD>
    <TD class="labelit">
		<select name="Claimant" class="regularxl">
			<option value="Employee" <cfif Claimant eq "Employee">selected</cfif>>Employee</option>
			<option value="OrgUnit" <cfif Claimant eq "OrgUnit">selected</cfif>>OrgUnit</option>
		</select>
	</TD>
	</TR>
  
	<TR>
    <td class="labelit"><cf_tl id="Operational">:</td>
    <TD class="labelit">  
	 	<input type="radio" name="Operational" value="1" <cfif Operational eq 1>checked</cfif>>Enabled
	 	<input type="radio" name="Operational" value="0" <cfif Operational eq 0>checked</cfif>>Disabled
    </td>
    </tr>		
	
	<tr>	
		<td align="center" colspan="2">
		<cf_tl id="Save" var="1">
		<input class="button10g" type="submit" name="Update" value=" #lt_text# " onclick="javascript:do_submit_general() ">		
		</td>	
	</tr>

	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="right">
	<cf_tl id="Element recorded by"> #ClaimType.OfficerFirstName# #ClaimType.OfficerLastName# <cf_tl id="on"> #Dateformat(Created, "#CLIENT.DateFormatShow#")#
	</td></tr>
	
    
</TABLE>


</cfoutput>
</CFFORM>