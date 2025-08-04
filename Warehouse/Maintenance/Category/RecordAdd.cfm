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
<cf_tl id="No" var = "vNo">
<cf_tl id="Yes" var = "vYes">

<cf_dialogLedger>

<cfquery name="Ledger" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AreaGledger
ORDER BY ListingOrder
</cfquery>

<script>
function validateFileFields(control) {			 			
	document.formunittab.tabIcon.focus(); 
	document.formunittab.tabIcon.blur(); 
	
	if (control != null) control.focus();			
}

function validateFileFields() {			 			
	document.category.tabIcon.focus(); 
	document.category.tabIcon.blur(); 
	
	if (document.category.tabIcon.value != "")
	{
		if (document.category.validateIcon.value == 0) 
		{ 
			alert('Icon path not validated!');
			return false;
		}
		else
		{
			return true;
		}
	}
	else
	{
		return true;
	}		
}

function toggleEnableTransactions(control,id) {
	if (control.checked) {
		document.getElementById('div'+id).style.display = 'block';
		document.getElementById('td'+id).style.backgroundColor = 'E1EDFF';
	}
	else{
		document.getElementById('div'+id).style.display = 'none';
		document.getElementById('td'+id).style.backgroundColor = '';
	}
}

</script>

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Add Category" 
			  banner="green" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
	
<table width="100%"
       border="0"
	   height="100%">

<tr><td colspan="2" bgcolor="white" valign="top">  
	 
<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST"  name="category">

<!--- Entry form --->

<cfoutput>

<table width="92%" align="center" class="formpadding">

 <tr><td height="6"></td></tr>
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium2"><cf_tl id="Id">:</TD>
    <TD class="labelmedium2">
		<cfinput class="regularxxl" type="Text" name="Category" message="Please enter an Id" required="Yes" size="20" maxlength="20">
	</TD>
	</TR>
	
	<TR>
		<TD class="labelmedium2"><cf_tl id="Acronym">:&nbsp;</TD>  
		<TD class="labelmedium2">
		<cfinput type="Text" name="Acronym" value="" message="Please enter a valid acronym" required="No" size="5" maxlength="2" class="regularxxl">
		</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2" valign="top" style="padding-top:4px"><cf_tl id="Description">:</TD>
    <TD class="labelmedium2">
			
	<cf_LanguageInput
			TableCode       = "Ref_Category" 
			Mode            = "Edit"
			Name            = "Description"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "50"
			Class           = "regularxxl">
			
	</TD>
	</TR>
	
	<!--- Field: tabOrder --->
	 <TR>
		 <TD class="labelmedium2"><cf_tl id="Tab Order">:&nbsp;</TD>  
		 <TD class="labelmedium2">
		 	<cfinput type="Text" name="tabOrder" value="" message="Please enter a numeric Tab Order" validate="integer" required="No" size="5" maxlength="3" class="regularxxl">
		 </TD>
	 </TR>
	 
	 <!--- Field: tabIcon --->
	 <TR>
		 <TD class="labelmedium2"><cf_tl id="Icon">:&nbsp;</TD>  
		 <TD class="labelmedium2">
		    #SESSION.root#/Custom/
		 	<cfset iconDirectory = "Custom/">
			
		 	<cfinput type="Text" 
				name="tabIcon" 
				value="" 
				message="Please enter a Tab Icon" 
				onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template=#iconDirectory#'+this.value+'&container=iconValidationDiv&resultField=validateIcon','iconValidationDiv')"
				required="No" 
				size="30" 
				maxlength="60" 
				class="regularxxl">										
		 </TD>
		 <td valign="middle">
		 	<cfdiv id="iconValidationDiv" bind="url:CollectionTemplate.cfm?template=#iconDirectory#&container=iconValidationDiv&resultField=validateIcon">				
		 </td>
	 </TR>
	
    <!--- Field: Initial review --->
    <TR>
    <TD class="labelmedium2"><cf_tl id="Initial review requisition">: </font> </TD>
    <TD class="labelmedium2"><table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="InitialReview" id="InitialReview" value="0" checked></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="No"></td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="InitialReview" id="InitialReview" value="1"></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Yes"></td>
		</tr></table>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Stock Management Mode">: </font> </TD>
    <TD class="labelmedium2">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="StockControlMode" id="StockControlMode" value="Stock" checked></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Accumulated stock"> [<cf_tl id="Default">]</td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="StockControlMode" id="StockControlMode" value="Individual"></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Transactional"></td>
		</tr></table>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Finished Product"> (<cf_tl id="WorkOrder">): </font> </TD>
    <TD class="labelmedium2">
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="FinishedProduct" id="FinishedProduct" value="0" checked></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="No"></td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="FinishedProduct" id="FinishedProduct" value="1"></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Yes"></td>
		</tr></table>
	</TD>
	</TR>
	
	<!--- Field: Initial review --->
    <TR>
    <TD class="labelmedium2"><cf_tl id="Sensitivity Level">: </font> </TD>
    <TD  class="labelmedium2">
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="SensitivityLevel" id="SensitivityLevel" value="0" checked></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Low"></td>
		<td style="padding-left:6px"><input type="radio" class="radiol" name="SensitivityLevel" id="SensitivityLevel" value="1"></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="High"></td>
		</tr></table>
	</TD>
	</TR>
	
	<!--- Field: Volume Management --->
    <TR>
    <TD  class="labelmedium2"><cf_tl id="Volume Management">:</TD>
    <TD class="labelmedium2">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="VolumeManagement" id="VolumeManagement" value="0" checked></td><td style="padding-left:4px" class="labelmedium2">#vNo#</td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="VolumeManagement" id="VolumeManagement" value="1"></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr>
	</table>	
	</TD>
	</TR>
	
	<!--- Field: Initial review --->
    <TR>
    <TD class="labelmedium2"><cf_tl id="Enable Transactions">:</TD>
    <TD class="labelmedium2">
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="EnableTransaction" id="EnableTransaction" value="0" checked></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="No"></td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="EnableTransaction" id="EnableTransaction" value="1"></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Yes"></td>
		</tr></table>
	</TD>
	</TR>
	
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="3"><b><cf_tl id="Supply Distribution"></b></td>
	</tr>
	<tr><td colspan="3" class="line"></td></tr>
	<tr><td height="3"></td></tr>
	
	<tr>
		<td class="labelmedium2"><cf_tl id="Distribution Mode">:</td>
		<td>
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px">
			<select name="DistributionMode" id="DistributionMode" class="regularxxl">
				<option value="Standard"><cf_tl id="Standard">
				<option value="Meter"><cf_tl id="Meter">
			</select>
		</td>
		<td style="padding-left:13px">
		<input type="radio" class="radiol" name="DistributionFilter" id="DistributionFilter" value="1"></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr>
		</table>
	</TD>
	</tr>
	
	<!--- Field: Initial review --->
    <TR>
    <TD  class="labelmedium2"><cf_tl id="Limit Issuance to enabled Warehouse">:</TD>
    <TD class="labelmedium2">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="DistributionFilter" id="DistributionFilter" value="0" checked></td><td style="padding-left:4px" class="labelmedium2">#vNo#</td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="DistributionFilter" id="DistributionFilter" value="1"></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr>
	</table>
	</TD>	
	</TR>
	
	<!--- Field: Commision Management --->
    <TR>
    <TD style="padding-right:10px" class="labelmedium2"><cf_tl id="Commisson Mode"> (<cf_tl id="Sale">):</TD>
    <TD class="labelmedium2" style="height:28">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="CommissionMode" id="CommissionMode" value="0" checked></td><td style="padding-left:4px" class="labelmedium2">#vNo#</td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="CommissionMode" id="CommissionMode" value="1"></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr>
	</table>
	</TD>
	</TR>
	
	
	<tr><td colspan="3" align="center" height="12">
	<tr><td colspan="3" class="line"></td></tr>
	<tr><td colspan="3" align="center" height="6">
	
	<tr><td colspan="3" align="center">
		
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " style="width:120" onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Save " style="width:120" onclick="return validateFileFields();">
	
	</td></tr>
	   
</TABLE>
</cfoutput>

</CFFORM>

<td></tr>
</table>

