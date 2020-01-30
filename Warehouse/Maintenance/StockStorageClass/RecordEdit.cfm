<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_WarehouseLocationClass
	WHERE  	Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT 		LocationClass
 	FROM 		WarehouseLocation
 	WHERE 		LocationClass  = '#URL.ID1#'
</cfquery>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Storage Location" 
			  option="Maintain Storage Location #URL.ID1#" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this record ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">


<!--- edit form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td colspan="2" align="center" height="10"></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <cfif CountRec.recordCount eq 0>
	   		<cfinput type="text" name="Code" value="#get.Code#" message="please enter a code" required="Yes" size="5" maxlength="20" class="regularxl">
	   <cfelse>
	   		#get.Code#
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required="No" size="30" maxlenght = "50" class= "regularxl">
    </TD>
	</TR>
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6"></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6"></tr>
	
	<tr><td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <cfif #CountRec.recordCount# eq 0><input class="button10g" type="submit" name="Delete" ID="Delete" value=" Delete " onclick="return ask()"></cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	
	</tr>
	
</TABLE>
	
</CFFORM>

