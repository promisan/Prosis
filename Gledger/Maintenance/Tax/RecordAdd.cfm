<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Taxation" 
			  banner="gray" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="TaxAccount"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Account
	WHERE TaxAccount = 1
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="94%" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>

    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <cfinput class="regularxxl" type="Text" name="TaxCode" value="" message="Please enter a code" required="Yes" size="10" maxlength="10">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	    <cfinput class="regularxxl" type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50">
    </TD>
	</TR>
		
	<TR class="labelmedium2">
    <TD>Percentage:</TD>
    <TD>
  	    <cfinput class="regularxxl" type="Text" name="Percentage" value="0" message="Please enter a percentage" validate="float" required="Yes" size="5" maxlength="5">%
    </TD>
	</TR>
	      	
	<TR class="labelmedium2">
    <TD>Calculation:</TD>
    <TD>
  	   <select class="regularxxl" name="TaxCalculation" size"1">
          <option value="Inclusive" selected><font size="1" face="Tahoma">Inclusive</font></option>
		  <option value="Exclusive"><font size="1" face="Tahoma">Exclusive</font></option>
	   </select>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Rounding:</TD>
    <TD>
  	   <select class="regularxxl" name="TaxRounding" size"1">
          <option value="0">Lowest decimal</option>
		  <option value="1" selected>Nearest decimal</option>
	   </select>
    </TD>
	</TR>
		
	<TR class="labelmedium2">
    <TD>Account Paid:</TD>
    <TD>
  	  <select class="regularxxl" name="glaccountpaid">
     	  <option value=""></option>  
            <cfoutput query="TaxAccount">
        	<option value="#GLAccount#"><font face="Tahoma" size="1">#GLAccount# #Description#</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>		
		
	<TR class="labelmedium2">
    <TD>Account:</TD>
    <TD>
  	  <select class="regularxxl" name="glaccountreceived">
     	   <cfoutput query="TaxAccount">
        	<option value='#GLAccount#'><font face="Tahoma" size="1">#GLAccount# #Description#</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
		
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="40" align="center">
		
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</TD></TR>
	
</TABLE>	
	
</CFFORM>
