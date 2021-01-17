<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" scroll="Yes" label="Edit" layout="webapp" menuAccess="Yes" systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Nation
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- edit form --->


<table width="92%" align="center" class="formpadding formspacing">

    <tr><td height="4"></td></tr>
	
	<cfoutput>
	<TR>
	 <TD class="labelmedium2">Code:</TD>  
	 <TD class="labelmedium">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="3" maxlength="3" class="regularxxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="3" maxlength="3"class="labelmedium">
	 </TD>
	</TR>
	
    <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium">
  	  	<input type="Text" name="name" id="name" value="#get.name#" message="Please enter a description" size="20" maxlength="25" class="regularxxl">
				
    </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium2">Iso Code (3 chars):</TD>
    <TD class="labelmedium">
  	  	<input type="Text" name="isocode" id="isocode" value="#get.IsoCode#" message="Please enter a Iso" size="3" maxlength="3" class="regularxxl">
				
    </TD>
	</TR>

    <TR>
    <TD class="labelmedium2">Iso Code (2 chars):</TD>
    <TD class="labelmedium">
  	  	<input type="Text" name="isocode2" id="isocode2" value="#get.IsoCode2#" message="Please enter a Iso" size="2" maxlength="2" class="regularxxl">
				
    </TD>
	</TR>
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Operation:</TD>
    <TD class="labelmedium">
	  <input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif get.Operational eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif get.Operational eq "0">checked</cfif>>No
	</TD>
	</TR>
	
	<tr><td colspan="2" height="1" class="line"></td></tr>
	
	</cfoutput>
	
 	<tr><td colspan="2" align="center" height="30">	
	<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
	<input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td></tr>	
   	
</TABLE>

</CFFORM>
