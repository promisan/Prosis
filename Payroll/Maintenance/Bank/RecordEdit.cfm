<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Bank" 
			  label="Edit Bank" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  B.*
FROM    Ref_Bank B
WHERE   B.Code= '#URL.ID#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this bank account ?")) {
	return true 
	}
	return false	
}	
</script>

<cf_dialogLedger>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="94%" align="center" class="formpadding formspacing">

    <tr><td style="height:10px"></td></tr>
    
	<cfoutput>
	
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
		   <cfinput type="Text" class="regularxxl" name="Bank" value="#get.Code#" message="Please enter the bank acronym" required="Yes" size="20" maxlength="20">
          <input type="hidden" name="CodeOld" value="#get.Code#">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium2">Name:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxxl" name="Description" value="#get.Description#" message="Please enter the name of your account" required="Yes" size="24" maxlength="40">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
		<input type="checkbox" name="Operational" class="radiol" value="1" <cfif get.operational eq "1">checked</cfif>>
  	 </TD>
	</TR>
		
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="55" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
			
		<cfquery name="Check" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  TOP 1 *
			FROM    PersonAccount
			WHERE   BankCode= '#URL.ID#'
		</cfquery>
	
	<cfif check.recordcount eq "0">
		<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	</cfif>
	<input class="button10g" type="submit" name="Update" value=" Update ">
	
	</td></tr>
			
	</cfoutput>
		
</TABLE>
	
</CFFORM>

