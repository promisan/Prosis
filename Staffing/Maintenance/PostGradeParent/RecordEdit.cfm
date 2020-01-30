<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PostGradeParent
WHERE Code = '#URL.ID1#'
</cfquery>


<cfquery name="Posttype"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostType
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this Parent grade ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="93%"  cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="2" colspan="2"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Description" value="#Get.Description#" message="Please enter a display description" required="Yes" size="30" maxlength="40" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Listing order:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="ViewOrder" value="#Get.ViewOrder#" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Show subtotal:&nbsp;</TD>
    <TD style="height:25" class="labelmedium">
  	   <input type="Radio" name="ViewTotal" value="1" <cfif #Get.ViewTotal# eq "1">checked</cfif>>Yes
	   <input type="Radio" name="ViewTotal" value="0" <cfif #Get.ViewTotal# eq "0">checked</cfif>>No
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Posttype:</TD>
    <TD class="regular">
	   <select name="PostType" class="regularxl">
	   <cfloop query="PostType">
	   <cfoutput>
	   <option value="#PostType.PostType#" <cfif #PostType.PostType# eq #Get.PostType#>selected</cfif>>#PostType.Description#</option>
	   </cfoutput>
	   </cfloop>
	   </select>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Category:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Category" value="#Get.Category#" message="Please enter a category" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>

	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<TR>
		<td align="center" colspan="2">
		
	    <input class="button10g" style="width:100;height:23" type="submit" name="Delete" value="Delete" onclick="return ask()">
	    <input class="button10g" style="width:100;height:23" type="submit" name="Update" value="Save">
		</td>	
	</TR>
	
	</cfoutput>	

	
	
</TABLE>

	
	
</CFFORM>


