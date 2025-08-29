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
			  label="Accounting Group" 
			  option="Edit Accounting Group" 
			  banner="gray" 
			  menuAccess="Yes" 
			  line="no"
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountGroup
WHERE AccountGroup = '#URL.ID1#'
</cfquery>

<cfquery name="Parent" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountGroup
WHERE AccountParent = '#Get.AccountParent#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this group ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<CFFORM action="AccountGroupSubmit.cfm" method="post">

<!--- Entry form --->

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="8"></td></tr>

    <TR>
    <TD class="labelit"><cf_tl id="Parent">:</TD>
    <TD>
	   <cfoutput>
	   <input type="text" class="regularxl"  name="AccountParent" value="#Get.AccountParent# #Parent.Description#" size="30" maxlength="30" readonly style="text-align: left; background: f3f3f3;">
  	   </cfoutput>
    </TD>
	</TR>
		  
    <TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
	
	    <cfoutput>
		<input type="hidden" name="AccountGroup" value="#get.AccountGroup#" class="regularxl">
		</cfoutput>
			
		<cf_LanguageInput
				TableCode       = "AccountGroup" 
				Mode            = "Edit"
				Name            = "Description"
				Value           = "#get.Description#"
				Key1Value       = "#get.AccountGroup#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please enter a description"
				MaxLength       = "70"
				Size            = "50"
				Class           = "regularxl">	
			  
	
		<!---	
	
  	    <cfoutput query="get">
	    <input type="hidden" name="AccountGroup" value="#AccountGroup#">
		<cfinput type="Text" class="regularxl" name="Description" value="#Description#" message="Please enter a description" required="Yes" size="30" maxlength="60">
		</cfoutput>
		
		--->
		
    </TD>
	</TR>
	
	
	
	
  
    <TR>
    <TD class="labelit"><cf_tl id="Order">:</TD>
    <TD>
  	    <cfinput type="Text" name="listingorder" message="Please enter a description" value="#Get.ListingOrder#" validate="integer" size="3" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	
		
	<TR>
    <TD class="labelit"><cf_tl id="Type">:</TD>
    <TD>
  	   <select name="AccountType" size"1" class="regularxl">
          <option value="Debit" <cfif Get.AccountType is "Debit">selected</cfif>>Debit</option>
		  <option value="Credit" <cfif Get.AccountType is "Credit">selected</cfif>>Credit</option>
	   </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Class:</TD>
    <TD>
  	   <select name="AccountClass" size"1" class="regularxl">
          <option value="Balance" <cfif #Get.AccountClass# is "Balance">selected</cfif>><font size="1" face="Tahoma">Balance</font></option>
		  <option value="Result" <cfif #Get.AccountClass# is "Result">selected</cfif>><font size="1" face="Tahoma">Result</font></option>
	   </select>
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="2">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="2">
	
	<tr><td colspan="2" align="center">
	
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
				
		<cfquery name="CountRec" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		      SELECT AccountGroup
		      FROM Ref_Account
		      WHERE AccountGroup  = '#get.AccountGroup#' 
		 </cfquery>
			
		<cfif countrec.recordcount eq "0">		
			<input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
		</cfif>
			
		<input class="button10g" type="submit" name="Update" value="Update">

	</td></tr>	
	
</TABLE>
	
</CFFORM>


