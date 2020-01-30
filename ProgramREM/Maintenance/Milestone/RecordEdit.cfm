
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Edit" 
			  layout="webapp" 
			  menuAccess="Yes"
			  systemfunctionid="#url.idmenu#"
			  scroll="Yes">
			    
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_SubPeriod
WHERE   SubPeriod = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this milestone?")) {
		return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <cfoutput>
    <TR>
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="SubPeriod" value="#get.SubPeriod#" size="2" maxlength="2"class="regular">
	   <input type="hidden" name="SubPeriodold" value="#get.SubPeriod#">
    </TD>
	</TR>
	
	<TR>
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="40" 
	   maxlenght = "40" class= "regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Abbreviation:</TD>
    <TD>
  	   <input type="text" name="DescriptionShort" value="#get.DescriptionShort#" size="6" class="regular" style="text-align: center;" maxlenght="6">
    </TD>
	</TR>
	
	<TR>
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="text" name="DisplayOrder" value="#get.DisplayOrder#" message="please enter a valid number" style="text-align: center;" required="yes" size="1" 
	   maxlenght = "1" class= "regular">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td colspan="2" align="center" height="30">
		<input class="button10g" type="button" style="width:80" name="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" style="width:80" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" style="width:80" name="Update" value="Update">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>
