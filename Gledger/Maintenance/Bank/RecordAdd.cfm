
<cfparam name="url.idmenu" default="">

<cf_textareascript>
	
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 			  
			  label="Add Bank Account" 
			  menuAccess="Yes" 			  
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">

<cfquery name="Currency"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Currency
</cfquery>

<cf_dialogLedger>

<script language="JavaScript">

function applyaccount(acc) {
   ptoken.navigate('setAccount.cfm?account='+acc,'process')
}  

</script>

<cfajaximport tags="cfwindow">	

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr class="hide" ><td id="process"></td></tr>
	
	<tr><td height="10"></td></tr>
	  
    <TR>
    <TD class="labelmedium" width="20%">Institution:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxl" name="Bank" value="" message="Please enter the bank acronym" required="Yes" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD style="padding-top:3px" valign="top" class="labelmedium">Address:</TD>
    <TD>
		<table width="100%" cellspacing="0">
			<cfloop index = "i" from = "1" to = 5> 
				<tr>	
					<td width="20%" style="padding-top:.7em;padding-bottom:.7em">
						<cfswitch expression="#i#">
							<cfcase value="1">Street</cfcase>
							<cfcase value="2">City</cfcase>
							<cfcase value="3">Zip</cfcase>
							<cfcase value="4">Country</cfcase>
							<cfcase value="5">Country Code</cfcase>														
						</cfswitch>					
					</td>
					<td>
						<cfinput type="Text" class="regularxl" name="BankAddress#i#" value="" required="No" size="30" maxlength="40">
					</td>
				</tr>		
			</cfloop>		
		</table>	
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Name:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountName" value="" message="Please enter the name of your account" required="Yes" size="30" maxlength="40">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">Currency:</TD>
     <TD>
  	    <select name="currency" class="regularxl">
     	   <cfoutput query="currency">
        	<option value="#Currency#" <cfif APPLICATION.BaseCurrency eq currency>selected</cfif>>#Currency#
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Account No:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountNo" value="" message="Please enter the number of your account" required="Yes" size="20" maxlength="20">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Account ABA:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountABA" value="" message="Please enter the ABA No of your account" required="No" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD style="padding-top:3px" align="top" class="labelmedium">Address:</TD>
    <TD>
  	    <cf_textarea 
			color   = "ffffff"
			toolbar = "basic"	 
			init    = "yes"
			height  = "100px"
  	    	style="height:100px;font-size:14;padding:3px;width:98%" name="AccountAddress" ></cf_textarea>
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">GL account:</TD>
    <TD>
	   <cfoutput>	
	   
	     <input type="Text" name="glaccount" id="glaccount" size="6" class="regularxl" readonly>
    	   <input type="text" name="gldescription" id="gldescription" value="" class="regularxl" size="50" readonly>
		   <input type="hidden" name="debitcredit" id="debitcredit" value="" class="regularxl" size="6" readonly>
		    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="20" height="20" border="0" align="absmiddle" 
				  onClick="selectaccountgl('','','','','applyaccount')">
				  
		<!---		   
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
		       size="6"
		       class="regularxl"
                STYLE="text-align: center;">
		    <input type="text" name="gldescription" value="" class="regularxl" size="40" readonly style="text-align: center;">
		    <input type="hidden" name="debitcredit" value="" size="10" readonly style="text-align: center;">
			
			--->
			
		 </cfoutput>	
	</TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Save "   onclick="return updateTextArea()">
	</td></tr>
	
	
</TABLE>
	
</CFFORM>

</BODY></HTML>