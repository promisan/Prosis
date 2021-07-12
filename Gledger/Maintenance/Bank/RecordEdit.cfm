
<cfparam name="url.idmenu" default="">

<cf_textareascript>
<cf_screentop height="100" 
			  scroll="Yes" 
			  layout="webapp" 			 
			  label="Edit Bank Account"
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">
			  
    
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  B.*, A.GLAccount, A.Description
FROM    Ref_BankAccount B LEFT OUTER JOIN
        Ref_Account A ON B.BankId = A.BankId
WHERE   B.BankId = '#URL.ID#'
</cfquery>


<cfquery name="check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    TransactionHeader
WHERE   ActionBankId = '#URL.ID#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this bank account ?")) {
	return true 
	}
	return false
	
}	

function applyaccount(acc) {
   ptoken.navigate('setAccount.cfm?account='+acc,'process')
}  

</script>

<cf_dialogLedger>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr class="hide" ><td id="process"></td></tr>
	<tr><td height="14"></td></tr>
    <cfoutput>
    <TR>
    <TD width="20%" class="labelmedium">Institution:</TD>	
    <TD><cfinput type="Text" class="regularxl" name="Bank" value="#get.bankName#" message="Please enter the bank acronym" required="Yes" size="20" maxlength="20">
         <input type="hidden" name="BankId" value="#get.bankId#">
    </TD>
	</TR>
	
	
	<TR>
    <TD valign="top" style="padding-top:3px" class="labelmedium">Bank Address:</TD>
    <TD>
		<cfset i = 0>
		<table width="100%" cellspacing="0">

			<cfloop list="#get.bankAddress#" index="vAddress" delimiters="|">
				<cfset i = i + 1>
				<tr>	
					<td width="20%"  style="padding-top:.7em;padding-bottom:.7em">
						<cfswitch expression="#i#">
							<cfcase value="1">Street</cfcase>
							<cfcase value="2">City</cfcase>
							<cfcase value="3">Zip</cfcase>
							<cfcase value="4">Country</cfcase>
							<cfcase value="5">Country Code</cfcase>														
						</cfswitch>
					</td>
					<td>
					<cfinput type="Text" class="regularxl" name="BankAddress#i#" value="#ltrim(rtrim(vAddress))#" required="No" size="30" maxlength="40">
					</td>
				</tr>
			</cfloop>
	
			<cfloop index = "j" from = "#i+1#" to = 5> 
				<tr>	
					<td width="20%">
						<cfswitch expression="#j#">
							<cfcase value="1">Street</cfcase>
							<cfcase value="2">City</cfcase>
							<cfcase value="3">Zip</cfcase>
							<cfcase value="4">Country</cfcase>
							<cfcase value="5">Country Code</cfcase>														
						</cfswitch>					
					</td>
					<td>
						<cfinput type="Text" class="regularxl" name="BankAddress#j#" value="" required="No" size="30" maxlength="40">
					</td>
				</tr>		
				
			</cfloop>		
		</table>
		
	</TR>
		
	<TR>
    <TD class="labelmedium">Name:</TD>
    <TD><cfinput type="Text" class="regularxl" name="AccountName" value="#get.accountname#" message="Please enter the name of your account" required="Yes" size="40" maxlength="40">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Currency:</TD>
    <TD><input type="text" class="regularxl" name="Currency" value="#get.currency#" size="4" maxlength="4" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Account No:</TD>
    <TD><cfinput type="Text"  class="regularxl" name="AccountNo" value="#get.accountNo#" message="Please enter the number of your account" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Account ABA:</TD>
    <TD><cfinput type="Text" class="regularxl" name="AccountABA" value="#get.accountaba#" message="Please enter the ABA No of your account" required="No" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:3px" class="labelmedium">Account Address:</TD>
    <TD><cf_textarea 
			color   = "ffffff"
			toolbar = "basic"	 
			init    = "yes"
			height  = "100"
    		style="font-size:14;padding:3px;width:98%" name="AccountAddress" >#get.accountaddress#
    		</cf_textarea>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">GL account:</TD>
    <TD>
	   <cfoutput>	
	    
		   <input type="Text" name="glaccount" id="glaccount" value="#get.glaccount#" size="6" class="regularxl" readonly>
    	   <input type="text" name="gldescription" id="gldescription" value="#get.description#" class="regularxl" size="50" readonly>
		   <input type="hidden" name="debitcredit" id="debitcredit" value="" class="regularxl" size="6" readonly>
		    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="20" height="20" border="0" align="absmiddle" 
				  onClick="selectaccountgl('','','','','applyaccount')">
					
		 </cfoutput>	
	</TD>
	</TR>	
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	<cfif check.recordcount eq "0">
	<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	</cfif>
	<input class="button10g" type="submit" name="Update" value=" Update " onclick="return updateTextArea()">
	</td></tr>
		
	</cfoutput>
			
</TABLE>

</CFFORM>
	
