<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Add Bank" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Currency"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Currency
</cfquery>

<cf_dialogLedger>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
			
	<tr><td height="9"></td></tr>

    <TR>
    <TD class="labelit"><cf_tl id="Institution">:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxl" name="Bank" value="" message="Please enter the bank acronym" required="Yes" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Address">:</TD>
    <TD>
  	    <textarea class="regular" name="BankAddress" style="font-size:13px;padding:3px;width:98%">11111111111</textarea>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Name">:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountName" value="" message="Please enter the name of your account" required="Yes" size="30" maxlength="40">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelit"><cf_tl id="Currency">:</TD>
     <TD>
  	    <select name="currency" id="currency" class="regularxl">
     	   <cfoutput query="currency">
        	<option value="#Currency#" <cfif APPLICATION.BaseCurrency eq currency>selected</cfif>>#Currency#
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Account No">:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountNo" value="" message="Please enter the number of your account" required="Yes" size="20" maxlength="20">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit"><cf_tl id="ABA/IBAN">:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="AccountABA" value="" message="Please enter the ABA No of your account" required="No" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Address">:</TD>
    <TD>
  	    <textarea class="regular" name="AccountAddress" style="font-size:13px;padding:3px;width:98%;font-size:13px;padding;3px;"></textarea>
    </TD>
	</TR>
			
	<TR>
    <TD class="labelit"><cf_tl id="GL account">:</TD>
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
		       size="6"
		       class="regularxl"
               STYLE="text-align: center;">
				
		    <input type="text" name="gldescription" id="gldescription" value="" class="regularxl" size="40" readonly style="text-align: center;">
		    <input type="hidden" name="debitcredit" id="debitcredit" value="" size="10" readonly style="text-align: center;">
		 </cfoutput>	
	</TD>
	</TR>
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="30" align="center">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Save ">
	</td></tr>
		
</TABLE>

</CFFORM>	

<cf_screenbottom layout="innerbox">	