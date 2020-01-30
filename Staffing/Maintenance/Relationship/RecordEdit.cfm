<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Relationship
	WHERE Relationship = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Relationship ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
              label="Relationship" 
			  layout="webapp" 
			  user="No"  
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" class="formpadding" align="center">
	
<tr><td></td></tr>	
	
    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <input type="text" name="Relationship" value="#get.Relationship#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="RelationshipOld" value="#get.Relationship#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelit">Descriptive:</TD>
    <TD>
  	   <input type="text" name="Description" value="#get.Description#" size="30" maxlength="50" class="regularxl">
	   
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" style="width:80" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" style="width:80" name="Delete" value="Delete" onclick="return ask()">
    <input class="button10g" type="submit" style="width:80" name="Update" value="Update">
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	