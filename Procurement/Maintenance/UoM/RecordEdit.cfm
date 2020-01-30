<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Units of Measure" 
			  label="Edit" 
			  banner="gray"
			  menuAccess="Yes"
			  systemfunctionid="#url.idmenu#">

 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_UoM
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this record ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- edit form --->
<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<!--- Field: code --->
	 <cfoutput>
	 <TR>
	 <TD class="labelit">Code:&nbsp;</TD>  
	 <TD class="labelit">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20" class="regularxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="labelit">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:&nbsp;</TD>
    <TD class="labelit">
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
				
    </TD>
	</TR>
	
	<!--- Field: FieldDefault --->
    <TR>
    <TD class="labelit">Default UoM:&nbsp;</TD>
    <TD class="labelit">
		<cfif get.FieldDefault eq 1>
	  	  	<b>Yes</b>
			<input type="Hidden" name="FieldDefault" id="FieldDefault" value="1">
		<cfelse>
			<input type="Checkbox" name="FieldDefault" id="FieldDefault">
		</cfif>
				
    </TD>
	</TR>
	
	<tr><td colspan="2" clas="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<cfif get.FieldDefault eq 0>
		<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">	
	</cfif>
	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
	
	

</cfoutput>
    	
</TABLE>

</CFFORM>

</BODY></HTML>