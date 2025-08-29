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
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  label="Taxation" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Tax
WHERE TaxCode = '#URL.ID1#'
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
	if (confirm("Do you want to remove this account ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post">

<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>

    <TR>
    <TD>Code:</TD>
    <TD>
  	   <input type="text" class="regularxl" name="TaxCode" value="<cfoutput>#Get.TaxCode#</cfoutput>" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="Description" value="#Get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Percentage:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="Percentage" value="#Get.Percentage*100#" message="Please enter a percentage" validate="float" required="Yes" size="5" maxlength="5">%
    </TD>
	</TR>
	      	
	<TR class="labelmedium">
    <TD>Calculation:</TD>
    <TD>
  	   <select class="regularxl" name="TaxCalculation" size"1">
          <option value="Inclusive" <cfif Get.TaxCalculation is "Inclusive">selected</cfif>>Inclusive</font></option>
		  <option value="Exclusive" <cfif Get.TaxCalculation is "Exclusive">selected</cfif>>Exclusive</font></option>
	   </select>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Rounding:</TD>
    <TD>
  	   <select class="regularxl" name="TaxRounding" size"1">
          <option value="0" <cfif Get.TaxRounding is "0">selected</cfif>>Lowest decimal</option>
		  <option value="1" <cfif Get.TaxRounding is "1">selected</cfif>>Nearest decimal</option>
	   </select>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Account Paid:</TD>
    <TD>
  	  <select class="regularxl" name="glaccountpaid">
     	  <option value=""></option>  
            <cfoutput query="TaxAccount">
        	<option value="#GLAccount#" <cfif #Get.GLAccountPaid# is "#GLAccount#">selected</cfif>>#GLAccount# #Description#</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	
	<TR class="labelmedium">
    <TD>Account Received:</TD>
    <TD>
  	  <select class="regularxl" name="glaccountreceived">
     	  <option value=""></option>  
            <cfoutput query="TaxAccount">
        	<option value="#GLAccount#" <cfif #Get.GLAccountReceived# is "#GLAccount#">selected</cfif>>#GLAccount# #Description#</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="25" align="center">
	
	<input class="button10g" type="button" style="width:90" name="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" style="width:90" name="Delete" value=" Delete " onclick="return ask()">
	<input class="button10g" type="submit" style="width:90" name="Update" value=" Update ">

	</td></tr>

</table>
	
</CFFORM>


