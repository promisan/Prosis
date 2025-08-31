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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Request Type" 
			  option="Add a request type" 
			  layout="webapp" 
			  JQuery="yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}

function validateFileFields(control) {			 			
	var controlValidate = document.getElementById('validateTemplate');
	
	if (controlValidate)
	{
		if (controlValidate.value == 0 && $('#TemplateApply').val() != '')
		{
			alert('Template path does not exist.');
			return false;
		}
	}
	
	if (control != null) control.focus();
	
	return true;
}


</script>

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="frmRequestType">

	<tr><td height="6"></td></tr>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD colspan="2">
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD colspan="2">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="No" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Template:</TD>
    <TD>
		<cfoutput><!--- #SESSION.root# --->Warehouse/Application/</cfoutput>
	 	<cfset templateDirectory = "Warehouse/Application/">
		
	 	<cfinput type="Text" 
			name="TemplateApply" 
			value="" 
			message="Please enter a template" 
			onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template=#templateDirectory#'+this.value+'&container=templateValidationDiv&resultField=validateTemplate','templateValidationDiv')"
			required="No" 
			size="30" 
			maxlength="30" 
			class="regularxl">										
	 </TD>
	 <td width="35%" valign="left">
	 	<cfdiv id="templateValidationDiv" bind="url:CollectionTemplate.cfm?template=#templateDirectory#&container=templateValidationDiv&resultField=validateTemplate">				
	 </td>
	</TR>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD colspan="2">
  	   <cfinput type="Text" name="listingOrder" value="" message="Please enter a numeric listing order" validate="integer" required="Yes" size="2" maxlength="3" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
	
	<TR>
		<TD class="labelit">Force Program:</TD>
	    <TD colspan="2" class="labelit">
	  	   	<input type="radio" name="ForceProgram" id="ForceProgram" value="0" checked>No
			<input type="radio" name="ForceProgram" id="ForceProgram" value="1">Yes	
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelit">Shipment Order:</TD>
	    <TD class="labelit" colspan="2">
	  	   	<input type="radio" name="StockOrderMode" id="StockOrderMode" value="0">No
			<input type="radio" name="StockOrderMode" id="StockOrderMode" value="1" checked>Yes	
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelit">Operational:</TD>
	    <TD colspan="2" class="labelit">
	  	   	<input type="radio" name="Operational" id="Operational" value="0">No
			<input type="radio" name="Operational" id="Operational" value="1" checked>Yes	
	    </TD>
	</TR>
	
	<tr><td colspan="3" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="3" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Save" id="Save" value="Save" onclick="return validateFileFields(this)">
	</td>	
	
	</tr>
		
	</CFFORM>
	
</table>

<cf_screenbottom layout="innerbox">
