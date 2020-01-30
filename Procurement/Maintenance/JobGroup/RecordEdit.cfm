<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Edit Job Group" 
			  label="Edit Job Group" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_JobCategory
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record?")) {
		return true 
	}
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" name="dialog">
	
<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2" class="labelit"><font color="808080">Job groups are a means to classify jobs. 
	Groups will also be used for workflow allowing to define different actors for each group although the workflow follows the same pattern (class)
	</font>
	</td></tr>
	
	<tr><td height="5"></td></tr>
	
    <cfoutput>
	<!--- Field: Code--->
	 <TR>
	 <TD class="labelit" width="100">Code:&nbsp;</TD>  
	 <TD class="labelit" width="70%">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
	 </TD>
	 </TR>
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:&nbsp;</TD>
    <TD class="labelit">
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
				
    </TD>
	</TR>
	
	<tr><td></td></tr>
	
	</cfoutput>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
			
</TABLE>

</CFFORM>
	

