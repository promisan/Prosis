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
<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_WarehouseBatchClass
	WHERE  	Code = '#URL.ID1#'
</cfquery>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Batch Class" 
			  option="Maintain Batch Class - #URL.ID1#" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_tl id = "Do you want to remove this record ?" var = "vRemove">

<cfoutput>
	
	<script language="JavaScript">
	function ask() {
		if (confirm("#vRemove#")) {	
		return true 	
		}	
		return false	
	}	
	
	function validateFields() {	
		var controlToValidate;	 
		var vReturn = false;
		var vMessage = "";
		
		if (document.getElementById('ReportTemplate').value != "")
		{
			if (document.getElementById('validatePath').value == 0) 
			{ 
				vMessage = vMessage + 'Not valid path!';
			}
		}
		
		if (vMessage != "") {
			alert(vMessage);
			return false;
		}
		else{
			return true;	
		}
	}
	</script>

</cfoutput>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">


<!--- edit form --->

<table width="92%" align="center" class="formpadding">

	<tr><td colspan="2" align="center" height="10"></tr>
	
    <cfoutput>
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
  	   #get.Code#
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="10"class="regular">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required="Yes" size="30" maxlength = "50" class= "regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Order">:</TD>
    <TD>
  	   <cfinput type="text" name="ListingOrder" value="#get.ListingOrder#" message="please enter a numeric order" validate="integer" required="Yes" size="1" maxlength = "3" class= "regularxxl" style="text-align:center;">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Printout">:</TD>
    <TD>
			<table cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<cfinput 
				   		type="text" 
						name="ReportTemplate" 
						id="ReportTemplate"
						value="#get.ReportTemplate#" 
						message="please enter a description" 
						required="No" 
						size="40" 
						maxlength="80" 
						class= "regularxxl"
						onblur= "ptoken.navigate('FileValidation.cfm?template='+this.value+'&container=pathValidationDiv&resultField=validatePath','pathValidationDiv')" >
				</td>
				<td valign="middle" align="left">
					<cf_securediv id="pathValidationDiv" bind="url:FileValidation.cfm?template=#get.ReportTemplate#&container=pathValidationDiv&resultField=validatePath">				
				</td>
			</tr>
		</table>
    </TD>
	</TR>
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6"></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6"></tr>
	
	<tr><td align="center" colspan="2" height="40">
    <input class="button10g" type="submit" name="Update" id="Update" value=" Save " onclick="return validateFields();">
	</td>	
	
	</tr>
	
</TABLE>
	
</CFFORM>

