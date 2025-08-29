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
			  label="Edit Bank" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  B.*, 
        A.GLAccount, 
		A.Description
FROM    Ref_Bankaccount B LEFT OUTER JOIN Ref_Account A ON B.BankId = A.BankId
WHERE   B.BankId = '#URL.ID#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this bank account ?")) {
	return true 
	}
	return false
	
}	
</script>

<cf_dialogLedger>
<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
		
    <tr><td height="1"></td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD><cf_tl id="Institution">:</TD>
    <TD>
		   <cfinput type="Text" class="regularxl" name="Bank" value="#get.bankName#" message="Please enter the bank acronym" required="Yes" size="20" maxlength="20">
          <input type="hidden" name="BankId" id="BankId" value="#get.bankId#">
    </TD>
	</TR>
	
	
	<TR class="labelmedium">
    <TD><cf_tl id="Address">:</TD>
    <TD>
  	    <textarea class="regular" name="BankAddress" style="padding:3px;font-size:13px;width:98%">#get.bankAddress#</textarea>
    </TD>
	</TR>
		
	<TR class="labelmedium">
    <TD><cf_tl id="Name">:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountName" value="#get.accountname#" message="Please enter the name of your account" required="Yes" size="30" maxlength="40">
    </TD>
	</TR>
		
	<TR class="labelmedium">
    <TD><cf_tl id="Currency">:</TD>
    <TD>
  	    <input type="text"class="regularxl" name="Currency" id="Currency" value="#get.currency#" size="4" maxlength="4" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Account No">:</TD>
    <TD>
  	    <cfinput type="Text"  class="regularxl" name="AccountNo" value="#get.accountNo#" message="Please enter the number of your account" required="Yes" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="ABA/IBAN">:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountABA" value="#get.accountaba#" message="Please enter the ABA No of your account" required="No" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Account Address">:</TD>
    <TD>
  	    <textarea class="regular" name="AccountAddress" style="padding:3px;font-size:13px;width:98%">#get.accountaddress#</textarea>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="GL account">:</TD>
    <TD>
	   <cfoutput>	 
	   
		    <img src="#SESSION.root#/Images/contract.gif" alt="Select item master" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
				  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
				  onClick="javascript:selectaccount('glaccount','gldescription','debitcredit','');">
				  
		    <cfinput type="Text"
		       name="glaccount"
		       message="You must define an associated GL account"
		       required="Yes"
		       visible="Yes"
		       enabled="No"
			   value="#get.glaccount#"
		       size="6"
		       class="regularxl" STYLE="text-align: center;">
				
		    <input type="text" class="regularxl" name="gldescription" id="gldescription" value="#get.description#" size="35" readonly style="text-align: center;">
		    <input type="hidden" name="debitcredit" id="debitcredit" value="" size="10" readonly style="text-align: center;">
			
		 </cfoutput>	
		 
	</TD>
	</TR>
		
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="30" align="center">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
		<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
			
	</cfoutput>	
			
</TABLE>

</CFFORM>	

<cf_screenbottom layout="innerbox">
