<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
	  scroll="Yes" 
	  layout="webapp" 
	  banner="gray"	 
	  label="Edit Class" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">  
  
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AddressType
	WHERE AddressType = '#URL.ID1#'
</cfquery>

<cfoutput>
<cf_tl id="Do you want to remove this address type ?" var="vRemove"> 

<script language="JavaScript">

	function ask()
	
	{
		if (confirm("#vRemove#")) {
		
		return true 
		
		}
		
		return false
		
	}	

</script>

</cfoutput>

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <cfoutput>
	<tr><td height="4"></td></tr>
    <TR>
    <TD class="labelit"><cf_tl id="Code">:</TD>
    <TD class="labelit">
  	   <input type="text" name="Code" id="Code" value="#get.AddressType#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.AddressType#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Description">:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided="yes" size="30" maxlenght="30" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Order">:</TD>
    <TD>
  	   <cfinput type="text" name="ListingOrder" value="#get.ListingOrder#" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
			
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="1">
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
	
</TABLE>

</CFFORM>
	


