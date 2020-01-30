<cfparam name="url.idmenu" default="">

<cf_tl id="Edit Cause" var="1">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Cause" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Incident
	WHERE  Code = '#URL.ID1#'
	AND    Class='Cause'
</cfquery>

<cfoutput>
<cf_tl id = "Do you want to remove this record ?" var ="1">
<script language="JavaScript">
function ask() {

	if (confirm("#lt_text#")) {
	
	return true 
	
	}
	
	return false
}	
</script>
</cfoutput>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- edit form --->


<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td height="6"></td></tr>

<!--- Field: code --->
	 <cfoutput>
	 <TR>
	 <TD class="labelit"><cf_tl id="Code">:&nbsp;</TD>  
	 <TD class="labelit">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regular">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelit"><cf_tl id="Description">:&nbsp;</TD>
    <TD class="labelit">
		<cf_tl id="Please enter a description" var = "1" class="Message">
  	  	<cfinput type="Text" name="Description" id="Description" value="#get.Description#" message="#lt_text#" required="Yes" size="50" maxlength="50" class="regularxl">
				
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	

	<tr>	
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Delete" var = "1">
		<input class="button10g" type="submit" name="Delete" value=" #lt_text# " onclick="return ask()">
		<cf_tl id="Update" var = "1">
		<input class="button10g" type="submit" name="Update" value=" #lt_text# ">
		</td>
	</tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>
