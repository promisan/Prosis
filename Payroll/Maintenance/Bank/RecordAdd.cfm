<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Bank" 
			  label="Edit Bank" 
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

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td></td></tr>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxl" name="Code" value="" message="Please enter the bank acronym" required="Yes" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Name:</TD>
    <TD>
   	   <cfinput type="Text" class="regularxl" name="Description" value="" message="Please enter the bank acronym" required="Yes" size="50" maxlength="50">

    </TD>
	</TR>
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td colspan="2" height="55" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Save ">
	</td></tr>
	
	
</TABLE>
	
</CFFORM>
