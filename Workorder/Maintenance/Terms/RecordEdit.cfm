<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	select *
	from Ref_Terms
	WHERE code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" label="Terms" layout="webapp" user="No">

<!--- edit form --->

<table width="92%" cellspacing="4" cellpadding="4" align="center" class="formpadding">

<cfform action="RecordSubmit.cfm" 
		method="POST" 
		enablecab="Yes" 
		name="dialog" 
		menuAccess="Yes" 
		systemfunctionid="#url.idmenu#">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
		#get.code#
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <input type="text" name="Description" id="Description" value="#get.Description#" size="30" maxlength="20" class="regularxl">
	   
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Payment days:</TD>
    <TD>
  	   <cfinput type="Text" name="paymentDays" value="#get.paymentDays#" message="Please enter a number as payment day" required="Yes" validate="integer" size="10" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Discount:</TD>
    <TD>
  	   <cfinput type="Text" name="discount" value="#get.discount#" message="Please enter a decimal number as discount" required="Yes" validate="float" size="10" maxlength="6" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Discount days:</TD>
    <TD>
  	   <cfinput type="Text" name="discountDays" value="#get.discountDays#" message="Please enter a number as discount day" required="Yes" validate="integer" size="10" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Operational:</TD>
    <TD>
		<SELECT class="regularxl" name="operational" id="operational">		
			<OPTION class="radiol" value="0" <cfif #get.operational# eq 0>selected</cfif>>No</OPTION>
			<OPTION class="radiol" value="1" <cfif #get.operational# eq 1>selected</cfif>>Yes </OPTION>	
		</SELECT>
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" style="width:80" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <cfif #URL.OC# eq 0><input class="button10g" type="submit" style="width:80" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
    <input class="button10g" type="submit" style="width:80" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>
	
</CFFORM>
	
</TABLE>

<cf_screenbottom layout="webapp">
	