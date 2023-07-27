<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              label="Add Account" 
			  scroll="yes" 
			  layout="webapp" 
			  banner="yellow"
			  menuAccess="Yes" 
			  line="no"
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Group" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountGroup
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Currency
	FROM Journal
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Bank" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_BankAccount	
</cfquery> 

<cfquery name="GroupSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountGroup
WHERE AccountGroup = '#URL.ID1#'
</cfquery>


<!--- Query returning search results --->
<cfquery name="Tax"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Tax
</cfquery>	

<cfquery name="PresClass" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PresentationClass
</cfquery>

<cf_verifyOperational 
         datasource= "AppsLedger"
         module    = "Program" 
		 Warning   = "No">
		 
<cfif moduleenabled eq "1">		 
	
	<cfquery name="ObjectList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM Ref_Object
	</cfquery>

</cfif>

<script>

var acctpe = new Array();
var acccls  = new Array();

<cfquery name="Group" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountGroup
</cfquery>

<cfoutput query="Group">
   acctpe[#AccountGroup#] = "#AccountType#";
   acccls[#AccountGroup#]  = "#AccountClass#";
</cfoutput>

function lookup(selected)
{
	 dialog.accounttype.value  = acctpe[selected];
     dialog.accountclass.value = acccls[selected];
}

</script>	

<!--- Entry form --->

<cfform action="AccountCodeSubmit.cfm?mission=#url.mission#" method="POST" name="dialog">

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td height="7"></td></tr> 
    <TR>
    <TD class="labelmedium">Account Group:</TD>
    <TD>
  	   <cfselect name="AccountGroup" message="Please select a group" class="regularxl" required="Yes" onChange="javascript:lookup(this.value)">
         <cfoutput query="Group">
       	 <option value="#AccountGroup#" <cfif #AccountGroup# is #GroupSelect.AccountGroup#>selected</cfif>>
	      #AccountGroup# #Description#	
		 </option>
    	 </cfoutput>
	   </cfselect>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	    <cfinput type="Text" name="GLAccount" class="regularxl" value="" message="Please enter a code" required="Yes" size="10" maxlength="20">
    </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	    <cfinput type="Text" name="description" class="regularxl" value="" message="Please enter a description" required="Yes" size="50" maxlength="80">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Type: </TD>
    <TD>
  	   <select name="accounttype" size"1" class="regularxl">
          <option value="Debit" <cfif GroupSelect.AccountType eq "Debit">selected</cfif>>Debit</font></option>
		  <option value="Credit" <cfif GroupSelect.AccountType neq "Debit">selected</cfif>>Credit</option>
	   </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Class:</TD>
    <TD>
  	   <select name="accountclass" size"1" class="regularxl" onchange="monetary(this.value)">
          <option value="Balance" <cfif GroupSelect.AccountClass eq "Balance">selected</cfif>>Balance</option>
		  <option value="Result" <cfif GroupSelect.AccountClass neq "Balance">selected</cfif>>Result</option>
	   </select>
    </TD>
	</TR>
	
	<TR>
	<TD class="labelmedium"><cf_tl id="Usage">:</TD>		
		    <TD style="padding-left:7px" class="labelmedium">
		  	   <select name="accountcategory" size"1" class="regularxl">
		          <option class="radiol" value="Vendor">Vendor</option>
				  <option class="radiol" value="Customer">Customer</option>
				  <option class="radiol" value="Advance">Advance</option>
				  <option class="radiol" value="Neutral">Other</option>
			   </select>
		    </TD>
	</tr>		
	
	<script>
	 
	 function monetary(val) {
	 
		  f1 = document.getElementById("fund1")
		  s1 = document.getElementById("monetary1")
		  s2 = document.getElementById("monetary2")	 
		  r1 = document.getElementById("recon1")
		  r2 = document.getElementById("recon2")	 
		 
		  if (val == "Balance") {	
		     f1.className = "regular"  
		     s1.className = "regular"
			 s2.className = "regular"
			 r1.className = "regular"
			 r2.className = "regular"
		  } else {
		     f1.className = "hide"  
		     s1.className = "hide"
			 s2.className = "hide"
			 r1.className = "hide"
			 r2.className = "hide"
		  }
	 
	 }
	
	</script>
	
	<cfquery name="System" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SystemAccount	
		WHERE  Operational = 1
		AND    Code NOT IN (SELECT SystemAccount
		                   FROM   Ref_AccountMission 
		                   WHERE  Mission = '#URL.Mission#' 
						   AND    SystemAccount <> '#URL.ID1#')
	</cfquery>
	
	<cfquery name="Mission" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_AccountMission
		WHERE Mission = '#URL.Mission#'
		AND  GLAccount = '#URL.ID1#'	
	</cfquery>
	
	<TR>
    <TD class="labelmedium"><cf_UItooltip  tooltip="Please check with vendor before you change">System Account for:</cf_UItooltip></TD>
    <TD>
       <cfselect name="SystemAccount" message="Please select a group" required="No" class="regularxl">
	     <option value="">n/a</option>
         <cfoutput query="System">
       	 <option value="#Code#" <cfif Code is Mission.SystemAccount>selected</cfif>>
	       #Code#	
		 </option>
    	 </cfoutput>
	   </cfselect>
  
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Presentation Class:</TD>
    <TD>
       <cfselect name="PresentationClass" class="regularxl">
         <cfoutput query="PresClass">
       	 <option value="#Code#">
	     #Description#	
		 </option>
    	 </cfoutput>
	   </cfselect>
  
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Default Tax Calculation:</TD>
    <TD>
        <select name="taxcode" class="regularxl">
            <cfoutput query="Tax">
        	<option value='#TaxCode#'>#TaxCode# #Description#</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	<cfif moduleenabled eq "1">		
			
		<TR>
	    <TD class="labelmedium">Budget Object code:</TD>
	    <TD>
	 	  <select name="ObjectCode" class="regularxl">
	   		   <option value=''></option>  
	            <cfoutput query="ObjectList">
	        	<option value="#Code#">#Code# #Description#</option>
	         	</cfoutput>
		      </select>
	    </TD>
		</TR>
		<tr><td></td>
		 <td width="70%" class="labelit"><font color="gray">Use for mapping of this account to a object of expenditure. This mapping
		will supersede the object of expenditire posted into the transaction by the Purchase Series interface.
		</td></tr>
	
	</cfif>
	
	<cfif GroupSelect.AccountClass is "Result">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl = "regular">
	</cfif>    
	
	<TR id="fund1" class="<cfoutput>#cl#</cfoutput>">
    <TD class="labelmedium"><cf_UItooltip  tooltip="Account Used for Flow of Fund Statement">Fund Account:</cf_UItooltip>:</TD>
    <TD class="labelmedium">
		<table cellspacing="0" cellpadding="0">
			    <tr>
				<td><input class="radiol" type="radio" name="FundAccount" value="0" checked></td>
				<td class="labelmedium" style="padding-left:4px">No</td>
				<td><input class="radiol" type="radio" name="FundAccount" value="1"></td>
				<td class="labelmedium" style="padding-left:4px">Yes</td>
		</table>		
    </TD>
	</TR>
	
		
	<TR id="monetary1" class="<cfoutput>#cl#</cfoutput>">
	    <TD class="labelmedium"><cf_UItooltip  tooltip="Amounts will be revaluated upon currency exchange rate change">Monetary Account:</cf_UItooltip>:</TD>
		
	    <TD class="labelmedium">
	
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td><input class="radiol" type="radio" onclick="bank('0')" name="MonetaryAccount" value="0" checked></td>
			<td class="labelmedium" style="padding-left:4px">No</td>
			<td><input class="radiol" type="radio" onclick="bank('1')" name="MonetaryAccount" value="1"></td>
			<td class="labelmedium" style="padding-left:4px">Yes</td>
						
			<td id="bank3" class="hide" style="padding-left:8px">
				<table cellspacing="0" cellpadding="0">
					<tr>
					<td class="labelmedium" style="padding-right:5px">Enforce currency:</td>
					<td>
					 <cfoutput>
					 <cfselect name="ForceCurrency" required="No" class="regularxl">
					     <option selected value="">n/a</option>
				         <cfloop query="Currency">
				       	 	<option value="#Currency#">
					       	#Currency#
						 	</option>
				    	 </cfloop>
					 </cfselect>			
					 </cfoutput>
					</td>			
					</tr>
				</table>
			</td>
			</tr>
		 </table>  		
		 	
	    </TD>
	</TR>
	
	
	<tr id="monetary2" class="<cfoutput>#cl#</cfoutput>">
	<td></td>
	<td width="70%" class="labelit"><font color="gray">Monetary account are accounts that are used to reflect values that are affected by exchange rate changes if the transaction
	is recorded in a currency different from the base currency. Example: Invoices Pyables, Bank account. Usually Asset and stock values are not
	defined as monetray accounts.	
	</td></tr>
	
	<script>
	 
	 function bank(val) {
	 
	  s1 = document.getElementById("bank1")
	  s2 = document.getElementById("bank2")	 
	  s3 = document.getElementById("bank3")
	 
	  if (val == 1) {	  
	     s1.className = "regular"
		 s2.className = "regular"
		 s3.className = "regular"
	  } else {	 
	     s1.className = "hide"
		 s2.className = "hide"
		 s3.className = "hide"
	  }
	 
	 }
	
	</script>
		
	
	<TR id="bank1" class="hide">
    <TD class="labelmedium"><cf_UItooltip  tooltip="Bank account">Bank Account:</cf_UItooltip>:</TD>
    <TD>
  	      <select name="bankid" class="regularxl">
		    <option value=""></option>
            <cfoutput query="Bank">
        	<option value="#BankId#">#BankName#</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>	
	
	<tr id="bank2"  class="hide">
	   <td></td>
	   <td class="labelit" width="70%"><font color="gray">Use to associate a cash/bank account to a registered bank account record. Associating an account to a bank record will
	allow you to ensure that payables made to a certain bank are then presented for reconciliation under the correct journal.	
	   </td>
	</tr>	
	
	<cfif GroupSelect.AccountClass is "Result">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl = "regular">
	</cfif>
	
	<TR id="recon1" class="<cfoutput>#cl#</cfoutput>">
    <TD class="labelmedium">Bank Reconciliation:</TD>
    <TD class="labelmedium">
  	      <input type="radio" class="radiol" name="BankReconciliation" value="0" onclick="bank('0')" checked>No
		  <input type="radio" class="radiol" name="BankReconciliation" value="1" onclick="bank('1')">Yes
    </TD>
	</TR>
	<tr id="recon2" class="<cfoutput>#cl#</cfoutput>">
	   <td></td>
	   <td class="labelit" width="70%"><font color="gray">Select this option for an account that represents amounts that require successive bank reconciliation upon receipt of the statement.	
	</td></tr>
	
	<cfif moduleenabled eq "1">		
	
		<TR>
	    <TD class="labelmedium"><cf_UItooltip  tooltip="Requires data entry with program and fund field entered. Use for result accounts only">Enforce Program/Fund:</cf_UItooltip>:</TD>
	    <TD class="labelmedium">
	  	      <input type="radio" class="radiol" name="ForceProgram" value="0" checked>No
			  <input type="radio" class="radiol" name="ForceProgram" value="1">Yes
	    </TD>
		</TR>
	
	</cfif>
	
	<TR>
    <TD class="labelmedium">Tax account:</TD>
    <TD class="labelmedium">
  	      <input type="radio" class="radiol" name="TaxAccount" value="0" checked>No
		  <input type="radio" class="radiol" name="TaxAccount" value="1" >Yes
    </TD>
	</TR>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	<tr><td colspan="2" align="center" height="30">
	<input class="button10g" style="width:120px" type="button" name="Cancel" value=" Close " onClick="window.close()">
    <input class="button10g" style="width:120px" type="submit" name="Insert" value=" Save ">

	</td></tr>
		
</TABLE>

</CFFORM>


