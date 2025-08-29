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
			  label="Accounting Parent" 
			  option="Edit Accounting Parent" 
			  banner="gray" 
			  menuAccess="Yes" 
			  line="no"
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountParent
WHERE AccountParent = '#URL.ID#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this parent ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<CFFORM action="AccountParentSubmit.cfm" method="post">

<!--- Entry form --->

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="8"></td></tr>

    <TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
	
	    <cfoutput>
	    <input type="hidden" name="AccountParent" value="#get.AccountParent#" class="regularxl">
		</cfoutput>
			
		<cf_LanguageInput
				TableCode       = "AccountParent" 
				Key1Value       = "#get.AccountParent#"
				Mode            = "Edit"
				Name            = "Description"
				Value           = "#get.Description#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please enter a description"
				MaxLength       = "80"
				Size            = "50"
				Class           = "regularxl">	
		
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
		      SELECT AccountParent
		      FROM Ref_AccountGroup
		      WHERE AccountParent  = '#get.AccountParent#' 
		 </cfquery>
			
		<cfif countrec.recordcount eq "0">		
			<input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
		</cfif>
			
		<input class="button10g" type="submit" name="Update" value="Update">

	</td></tr>	
	
</TABLE>
	
</CFFORM>


