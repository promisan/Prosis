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

<cf_screentop height="100%" 
			  scroll="No" 
			  layout="webapp" 
			  option="Define Accounting Group" 
			  label="Add Group" 
			  line="no"
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Parent" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountParent
</cfquery>

<cfquery name="ParentSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountParent
WHERE AccountParent = '#URL.ID1#'
</cfquery>

<cfoutput>

<script>
function reloadForm(selected) {
     window.location="AccountGroupAdd.cfm?idmenu=#url.idmenu#&ID1=" + selected;
}
</script>	

</cfoutput>
 
<cfform action="AccountGroupSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="9"></td></tr>

    <TR>
    <TD class="labelit">Parent: </TD>
    <TD>
  	   <cfselect name="AccountParent" message="Please select a parent" class="regularxl" required="Yes" onChange="javascript:reloadForm(this.value)">
         <cfoutput query="Parent">
       	 <option value=#AccountParent# <cfif #AccountParent# is #ParentSelect.AccountParent#>selected</cfif>>
	      #AccountParent# #Description#	
		 </option>
    	 </cfoutput>
	   </cfselect>
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	    <cfinput type="Text" name="AccountGroup" class="regularxl" value="" message="Please enter a code" required="Yes" size="10" maxlength="20">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
  
    <TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	    <cfinput type="Text" name="description" class="regularxl" value="" message="Please enter a description" required="Yes" size="30" maxlength="60">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
  
    <TR>
    <TD class="labelit">Statement Order:</TD>
    <TD>
  	    <cfinput type="Text" name="listingorder" message="Please enter a description" value="1" validate="integer" size="3" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	<TR>
    <TD class="labelit">Type:</TD>
    <TD>
  	   <select name="AccountType" class="regularxl">
          <option value="Debit" <cfif ParentSelect.AccountType is 'Debit'>selected</cfif>><font size="1" face="Tahoma">
		  
		  Debit</font></option>
		  <option value="Credit" <cfif ParentSelect.AccountType is 'Credit'>selected</cfif>><font size="1" face="Tahoma">Credit</font></option>
	   </select>
    </TD>
	</TR>
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelit">Class:</TD>
    <TD>
  	   <select name="AccountClass" size"1" class="regularxl">
          <option value="Balance" <cfif ParentSelect.AccountClass is 'Balance'>selected</cfif>>Balance</option>
		  <option value="Result" <cfif ParentSelect.AccountClass is 'Result'>selected</cfif>>Result</option>
	   </select>
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
		
	<tr><td colspan="2" align="center">

	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Insert" value=" Submit ">

	</td></tr>		
	
</TABLE>

	
</CFFORM>

</BODY></HTML>