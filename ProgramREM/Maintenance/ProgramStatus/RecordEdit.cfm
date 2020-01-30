<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Status" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

 
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ProgramStatus
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this status?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <cfoutput>
	
	<tr><td height="5"></td></tr>
	
	<TR>
    <TD class="labelmedium">Class:</TD>
    <TD class="labelmedium">
	   <select name="StatusClass"  class="regularxl">
		   <option value="Status" <cfif Get.StatusClass eq "Status">selected</cfif>>Status</option>
		   <option value="Urgency" <cfif Get.StatusClass eq "Urgency">selected</cfif>>Urgency</option>
		   <option value="Necessity" <cfif Get.StatusClass eq "Necessity">selected</cfif>>Necessity</option>
		   <option value="Importancy" <cfif Get.StatusClass eq "Importancy">selected</cfif>>Importancy</option>
	   </select>
     </TD>
	</TR>
		
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20"class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="30" 
	   maxlenght = "40" class= "regularxl">
    </TD>
	</TR>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>	
		
	<TR>
		<td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" value=" Update ">
		</td>	
	</TR>
	</cfoutput>
	
	
</TABLE>


		
	
	
</CFFORM>


