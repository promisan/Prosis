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
			  label="Order class" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_OrderClass
WHERE Code = '#URL.ID1#'
</cfquery>


<cfquery name="TaxAccount"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Account
	WHERE TaxAccount = 1
</cfquery>


<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- edit form --->

<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<!--- Field: code --->
	 <cfoutput>
	 <tr><td height="7"></td></tr>
	 <TR>
	 <TD class="labelmedium2">Code:&nbsp;</TD>  
	 <TD>
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
	 </TD>
	 </TR>
	 	  
	<cfquery name="Mis" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
	</cfquery>
	 
	 <TR>
	 <TD class="labelmedium2" width="150">Entity:</TD>  
	 <TD>
	 	<select name="Mission" id="Mission" class="regularxxl">
		<option value="">[Apply to all]</option>
		<cfloop query="Mis">
		<option value="#Mission#" <cfif get.Mission eq mission>selected</cfif>>#Mission#</option>
		</cfloop>
		</select>
	 </TD>
	 </TR>
	 
	 <TR class="labelmedium2">
    <TD>Tax Account :</TD>
    <TD>
  	  <select class="regularxxl" name="glaccounttax">
     	  <option value="">Use System default</option>  
            <cfloop query="TaxAccount">
        	<option value="#GLAccount#" <cfif Get.GLAccountTax is GLAccount>selected</cfif>>#GLAccount# #Description#</option>
         	</cfloop>
	    </select>
    </TD>
	</TR>
	 
		 
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="50" maxlength="50" class="regularxxl">				
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	<TR>
    <td valign="top" style="padding-top:3px" class="labelmedium2">Modality:</td>
    <TD>
	<table class="formpadding">
	<tr class="labelmedium2"><td><input type="radio" class="radiol" name="PreparationMode" id="PreparationMode" value="Job"      <cfif get.PreparationMode eq "Job">checked</cfif>></td><td colspan="3">Standard Procurement (Vendor)</td></tr>
	<tr class="labelmedium2"><td><input type="radio" class="radiol" name="PreparationMode" id="PreparationMode" value="Position" <cfif get.PreparationMode eq "Position">checked</cfif>></td><td colspan="3">Outsourced Position (New and Extension)</td></tr>
	<tr class="labelmedium2"><td><input type="radio" class="radiol" name="PreparationMode" id="PreparationMode" value="SSA"      <cfif get.PreparationMode eq "SSA">checked</cfif>></td><td colspan="3">Personal Service Agreement (Person)</td></tr>
	<tr class="labelmedium2"><td><input type="radio" class="radiol" name="PreparationMode" id="PreparationMode" value="Direct"   <cfif get.PreparationMode eq "Direct">checked</cfif>></td><td>Direct Purchase</td><td><input type="checkbox" class="radiol" name="PreparationModeCreate" id="PreparationModeCreate" value="1"  <cfif get.PreparationModeCreate eq "1">checked</cfif>></td><td>Auto approve </td></tr>
	<tr class="labelmedium2"><td><input type="radio" class="radiol" name="PreparationMode" id="PreparationMode" value="Travel"   <cfif get.PreparationMode eq "Travel">checked</cfif>></td><td colspan="3">Travel / Special Service Extension</td></tr>
	</table>
    </td>
    </tr>	
	
	<tr><td></td><td class="labelit">&nbsp;<font color="gray">Note : Direct Purchase needs to be enabled on the parameter level</td></tr>
	
	<tr><td class="labelmedium2" height="3">Print Templates</td></tr>
	
	<tr><td colspan="2">
	<table class="formpadding" style="width:100%">
	
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD style="width:140px;padding-left:15px">Purchase Order:</TD>
    <TD>
		<cfinput type="Text" style="width:90%" name="PurchaseTemplate" value="#get.PurchaseTemplate#" message="Please enter a template path" required="No" maxlength="100"
		class="regularxxl">
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD style="padding-left:15px">Execution&nbsp;Request:&nbsp;</TD>
    <TD>
		<cfinput type="Text" style="width:90%" name="ExecutionTemplate" value="#get.ExecutionTemplate#" message="Please enter a template path" required="No" maxlength="100"
		class="regularxxl">
	</TD>
	</TR>	
	
	</table>
	</td>
	</tr>	
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
		<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>
