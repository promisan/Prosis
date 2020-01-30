<cfparam name="url.idmenu" default="">

<!--- Query returning search results --->
<cfquery name="Tax"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,2,0,0)#">
    SELECT *
	FROM Ref_Tax
</cfquery>	

<cfquery name="Bank" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_BankAccount	
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Currency
	FROM Journal
	WHERE Mission = '#URL.Mission#'
</cfquery>
 
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Account
	WHERE GLAccount = '#URL.ID1#'
</cfquery>

<cfquery name="Group" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AccountGroup
	WHERE AccountParent = '#URL.ID2#'
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

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this account ?")) {
	return true 	
	}	
	return false	
}	

</script>


<cf_divscroll style="height:100%">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formspacing">

    <tr><td height="2"></td></tr>	
	
	<cfoutput>
		<TR><TD height="20" class="labelmedium"><cf_tl id="Account">:</TD>
		    <td class="labelmedium">#URL.ID1# <cfoutput>/#url.mission#</cfoutput></td>
		</TR>
	</cfoutput>	
	
    <TR>
    <TD class="labelmedium"><cf_tl id="Group">:</TD>
    <TD>
       <cfselect name="AccountGroup" message="Please select a group" required="Yes" class="regularxl">
         <cfoutput query="Group">
       	 <option value="#AccountGroup#" <cfif AccountGroup is Get.AccountGroup>selected</cfif>>
	     #AccountGroup# #Description#	
		 </option>
    	 </cfoutput>
	   </cfselect>
  
    </TD>
	</TR>
	
	
    <TR>
	    <TD class="labelmedium"><cf_tl id="Label">:</TD>
	    <TD>
	  	    <cfoutput query="get">		  
			<cfinput type="Text" class="regularxl" name="AccountLabel" value="#AccountLabel#" message="Please enter a description" required="No" size="10" maxlength="10">
			</cfoutput>
	    </TD>
	</TR>
	
    <TR>
	    <TD valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Description">:</TD>
	    <TD>
		
		<cfoutput>
		<input type="hidden" name="GLAccount" value="#get.GLAccount#" class="regularxl">
		</cfoutput>
			
		<cf_LanguageInput
				TableCode       = "AccountGL" 
				Mode            = "Edit"
				Name            = "Description"
				Value           = "#get.Description#"
				Key1Value       = "#get.GLAccount#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please enter a description"
				MaxLength       = "80"
				Size            = "60"
				Class           = "regularxl">	
			  
       	</TD>
		
		<!---
		
	  	    <cfoutput query="get">
		    <input type="hidden" name="GLAccount" value="#GLAccount#" class="regularxl">
			<cfinput type="Text" class="regularxl" name="Description" value="#Description#" message="Please enter a description" required="Yes" size="50" maxlength="80">
			</cfoutput>
			
			--->
			
	    </TD>
	</TR>
	
	
		
	<TR>
	    <TD class="labelmedium"><cf_tl id="Account type">:</TD>
	    <TD>
		
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
		
	  	   <select name="AccountType" size"1" class="regularxl">
	          <option class="radiol" value="Debit" <cfif Get.AccountType is 'Debit'>selected</cfif>>Debit</option>
			  <option class="radiol" value="Credit" <cfif Get.AccountType is 'Credit'>selected</cfif>>Credit</option>
		   </select>
		   
		   </td>
		   
		    <TD style="padding-left:7px" class="labelmedium"><cf_tl id="Class">:</TD>		
		    <TD style="padding-left:7px" class="labelmedium">
		  	   <select name="AccountClass" size"1" class="regularxl" onchange="monetary(this.value)">
		          <option class="radiol" value="Balance" <cfif Get.AccountClass eq "Balance">selected</cfif>>Balance</option>
				  <option class="radiol" value="Result" <cfif Get.AccountClass neq "Balance">selected</cfif>>Result</option>
			   </select>
		    </TD>
			
			<TD style="padding-left:7px" class="labelmedium"><cf_tl id="Usage">:</TD>		
		    <TD style="padding-left:7px" class="labelmedium">
		  	   <select name="AccountCategory" size"1" class="regularxl">
		          <option class="radiol" value="Vendor" <cfif Get.AccountCategory eq "Vendor">selected</cfif>>Vendor</option>
				  <option class="radiol" value="Customer" <cfif Get.AccountCategory eq "Customer">selected</cfif>>Customer</option>
				  <option class="radiol" value="Neutral" <cfif Get.AccountCategory eq "Neutral">selected</cfif>>Neutral</option>
			   </select>
		    </TD>
			
			
			<TD style="padding-left:5px" class="hide labelmedium"><cf_tl id="Presentation">:</TD>
		    <TD class="hide">
		       <cfselect name="PresentationClass" message="Please select a group" required="Yes" class="regularxl">
		         <cfoutput query="PresClass">
		       	 <option value="#Code#" <cfif Code is Get.PresentationClass>selected</cfif>>#Description#</option>
		    	 </cfoutput>
			   </cfselect>
		  
		    </TD>
		   
		   </tr></table>
	    
	    </TD>
	
	</tr>
			
	
	<script>
	 
	 function monetary(val) {
		  f1 = document.getElementById("fund1")
		  s1 = document.getElementById("monetary1")
		  s2 = document.getElementById("monetary2")	 
		  r1 = document.getElementById("recon1")
		  r2 = document.getElementById("recon2")	 
		  r3 = document.getElementById("recon3")	
		 
		  if (val == "Balance") {	
		     f1.className = "regular"  
		     s1.className = "regular"
			 s2.className = "regular"
			 r1.className = "regular"
			 r2.className = "regular"
			 r3.className = "regular"
		  } else {
		     f1.className = "hide"  
		     s1.className = "hide"
			 s2.className = "hide"
			 r1.className = "hide"
			 r2.className = "hide"
			 r3.className = "hide"
		  }
	 
	 }
	
	</script>
	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Tax application">:</TD>
    <TD>
        <select name="taxcode" class="regularxl">
            <cfoutput query="Tax">
        	<option value="#TaxCode#" <cfif Get.TaxCode is TaxCode>selected</cfif>>#TaxCode# #Description#
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	
	<cfif moduleenabled eq "1">		
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Associated Object code">:</TD>
	    <TD>
		
	 	  <select name="objectcode" class="regularxl">
	   		   <option value=""></option>  
	            <cfoutput query="ObjectList">
	        	<option value="#Code#" <cfif Get.ObjectCode is Code>selected</cfif>>
				#Code# #Description#
				</option>
	         	</cfoutput>
		      </select>
	    </TD>
		</TR>
		<tr><td></td><td width="70%" class="labelit"><font color="gray">Legacy : Use for mapping of this account to an object of expenditure (Budget execution). This mapping
		will kick in if for some external transactions posted without an object of expenditure assigned. See also [Force Budget Management]		
		</td>
		</tr>
		
	</cfif>
	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Usage Memo">:</TD>
	    <TD>
	  	    <cfoutput query="get">		   
			<cfinput type="Text" class="regularxl" name="Memo" value="#Memo#" size="60" maxlength="80">
			</cfoutput>
	    </TD>
	</TR>
	
	<tr><td colspan="2" style="height:50px" id="accountid" class="labellarge">
	<cfdiv bind="url:setAccount.cfm?type={AccountType}&class={AccountClass}">	
	</td></tr>
		
	<cfquery name="Mission" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AccountMission
		WHERE  Mission    = '#URL.Mission#'
		AND    GLAccount  = '#URL.ID1#'	
	</cfquery>
			
	<cfquery name="System" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SystemAccount	
		WHERE  Operational = 1
		AND    Code NOT IN (SELECT SystemAccount
		                    FROM   Ref_AccountMission 
		                    WHERE  Mission       = '#URL.Mission#' 
						    AND    SystemAccount <> '#Mission.SystemAccount#'
						   )
	</cfquery>
		
	<TR>
    <TD style="padding-left:20px" class="labelmedium"><cf_UItooltip  tooltip="Please check with vendor before you change">System Account for:</cf_UItooltip></TD>
    <TD>
	
       <cfselect name="SystemAccount" message="Please select a system account" required="No" class="regularxl">
	     <option value="">n/a</option>
         <cfoutput query="System">
       	 <option value="#Code#" <cfif Code is Mission.SystemAccount>selected</cfif>>
	       #Code#
		 </option>
    	 </cfoutput>
	   </cfselect>
  
    </TD>
	</TR>
	
	<cfif Get.AccountClass is "Result">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl = "regular">
	</cfif>    
	
	
	<cfif Get.MonetaryAccount is "1">
	   <cfset bk = "regular">	
	<cfelse>
	   <cfset bk = "hide">
	</cfif>
		
	<TR id="monetary1" class="<cfoutput>#cl#</cfoutput>">
	    <TD style="padding-left:20px" class="labelmedium"><cf_UItooltip  tooltip="Amounts will be revaluated upon currency change">Monetary:</cf_UItooltip></TD>
	    <TD class="labelmedium">
		 <table cellspacing="0" cellpadding="0">
		    <tr>
			<td>
	  	      <input class="radiol" type="radio" onclick="bank('0')" name="MonetaryAccount" value="0" <cfif Get.MonetaryAccount is '0'>checked</cfif>>
			 </td>
			 <td class="labelmedium" style="padding-left:4px">No</td>
			 <td style="padding-left:4px">
			  <input class="radiol" type="radio" onclick="bank('1')" name="MonetaryAccount" value="1" <cfif Get.MonetaryAccount is '1'>checked</cfif>>
			 </td>
			<td class="labelmedium" style="padding-left:4px">Yes</td>
						
			<td id="bank3" class="<cfoutput>#bk#</cfoutput>" style="padding-left:5px">
				<table cellspacing="0" cellpadding="0">
					<tr>
					<td class="labelmedium" style="padding-right:4px">currency:</td>
					<td>
					
					 <cfselect name="ForceCurrency" required="No" class="regularxl">
					     <option value="">n/a</option>
				         <cfoutput query="Currency">
				       	 <option value="#Currency#" <cfif Currency is get.ForceCurrency>selected</cfif>>
					       #Currency#
						 </option>
				    	 </cfoutput>
					 </cfselect>			
					
					</td>			
					</tr>
				</table>
			</td>
			
			<td id="bank4" class="<cfoutput>#bk#</cfoutput>" style="padding-left:7px">
				<table cellspacing="0" cellpadding="0">
					<tr>
					<td class="labelmedium" style="padding-right:4px">Revaluate:</td>
					<td>
					
					<input type="checkbox" value="1" class="radiol" name="RevaluationMode" <cfif get.RevaluationMode eq "1">checked</cfif>>
										
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
	is recorded in a currency different from the base currency. Example: Receivables, Account Payables, Advances, Bank accounts. Usually Asset and stock values are NOT
	defined as monetary.	
	</td></tr>
	
		
	<TR id="bank1" class="<cfoutput>#bk#</cfoutput>">
    <TD style="padding-left:20px" class="labelmedium"><cf_UItooltip  tooltip="Associated Bank Account Record">Bank:</cf_UItooltip></TD>
    <TD>
  	      <select name="bankid" class="regularxl">
		    <option value=""></option>
            <cfoutput query="Bank">
        	<option value="#BankId#" <cfif Get.BankId eq BankId>selected</cfif>>#BankName#</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>	
	
	<tr id="bank2"  class="<cfoutput>#bk#</cfoutput>">
	   <td></td>
	   <td width="70%" class="labelit"><font color="gray">Use to associate a cash/bank account to a registered bank account record. Associating an account to a bank record will
	allow you to ensure that payables made to a certain bank are then presented for reconciliation under the correct journal.	
	   </td>
	</tr>		
	
	
	
	<script>
	 
	 function bank(val) {
	 
	  s1 = document.getElementById("bank1")
	  s2 = document.getElementById("bank2")	 
	  s3 = document.getElementById("bank3")
	  s4 = document.getElementById("bank4")
	 
	  if (val == 1) {	  
	     s1.className = "regular"
		 s2.className = "regular"
		 s3.className = "regular"
		 s4.className = "regular"
	  } else {	 
	     s1.className = "hide"
		 s2.className = "hide"
		 s3.className = "hide"
		 s4.className = "hide"
	  }
	 
	 }
	
	</script>
	
	
	<cfif Get.AccountClass is "Result">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl = "regular">
	</cfif>    
	
	<TR id="recon1" class="<cfoutput>#cl#</cfoutput>">
    <TD style="padding-left:20px" class="labelmedium">Bank Reconciliation:</TD>
    <TD class="labelmedium">
	
  	      <input type="radio" class="radiol" name="BankReconciliation" value="0" <cfif Get.BankReconciliation is '0'>checked</cfif>>No
		  <input type="radio" class="radiol" name="BankReconciliation" value="1" <cfif Get.BankReconciliation is '1'>checked</cfif>>Yes
    </TD>
	</TR>
	
	<tr id="recon2" class="<cfoutput>#cl#</cfoutput>">
	
	 <td></td><td width="70%" class="labelit"><font color="gray">Select this option for an account that represents amounts that require successive bank reconciliation upon receipts like [Payments underway], [Receivables]. This will 
	 ensure that posting on this account will  will be shown for successive bank reconciliation.	
	</td></tr>
	
	<cfif moduleenabled eq "1">		
	
	<TR>
    <TD style="padding-left:20px" class="labelmedium"><cf_UItooltip  tooltip="Requires data entry with program field entered">Budget Execution:</cf_UItooltip></TD>
    <TD class="labelmedium">
  	      <input type="radio" class="radiol" name="ForceProgram" value="0" <cfif Get.ForceProgram is '0'>checked</cfif>>No
		  <input type="radio" class="radiol" name="ForceProgram" value="1" <cfif Get.ForceProgram is '1'>checked</cfif>>Yes
    </TD>
	</TR>
	
	<tr id="bud">	
		 <td></td><td width="70%" class="labelit"><font color="gray">Enforce the selection of a Fund and Project code when recording transactions for this account.</td></tr>
	
	</cfif>
	
	<tr><td style="padding-left:20px" colspan="2" class="labelmedium"><cf_tl id="Account"><cf_tl id="Classifications"></td></tr>
	
	<TR id="fund1" class="<cfoutput>#cl#</cfoutput>">
    <TD style="padding-left:40px" class="labelmedium"><cf_UItooltip  tooltip="Account Used for Flow of Fund Statement">Fund:</cf_UItooltip></TD>
    <TD class="labelmedium">
  	      <input type="radio" class="radiol" name="FundAccount" value="0" <cfif Get.FundAccount is '0'>checked</cfif>>No
		  <input type="radio" class="radiol" name="FundAccount" value="1" <cfif Get.FundAccount is '1'>checked</cfif>>Yes
    </TD>
	</TR>
	
	<TR id="recon3" class="<cfoutput>#cl#</cfoutput>">
    <TD style="padding-left:40px" class="labelmedium"><cf_tl id="Physical Stock">:</TD>
    <TD class="labelmedium">
  	      <input type="radio" class="radiol" name="StockAccount" value="0" <cfif Get.StockAccount is "0">checked</cfif>>No
		  <input type="radio" class="radiol" name="StockAccount" value="1" <cfif Get.StockAccount is "1">checked</cfif>>Yes
    </TD>
	</TR>
	
	<TR>
    <TD style="padding-left:40px" class="labelmedium"><cf_tl id="Tax usage">:</TD>
    <TD class="labelmedium">
  	      <input type="radio" class="radiol" name="TaxAccount" value="0" <cfif Get.TaxAccount is "0">checked</cfif>>No
		  <input type="radio" class="radiol" name="TaxAccount" value="1" <cfif Get.TaxAccount is "1">checked</cfif>>Yes
    </TD>
	</TR>
	
	<tr id="bud">	
		 <td></td><td width="70%" class="labelit"><font color="gray">Used for tax control processing screens.</td>
    </tr>
	
	
</table>

</cf_divscroll>

