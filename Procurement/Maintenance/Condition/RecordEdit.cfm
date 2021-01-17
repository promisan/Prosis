<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="" 
			  label="Edit Condition" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_condition
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

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td style="height:6px"></td></tr>

<!--- Field: code --->
	 <cfoutput>
	 <TR>
	 <TD class="labelmedium2">Code:&nbsp;</TD>  
	 <TD class="labelit">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20" class="regularxxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="labelit">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD class="labelit">
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>

</BODY></HTML>