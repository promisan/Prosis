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
	FROM Ref_WarehouseClass
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfoutput>
<cf_tl id="Do you want to remove this class ?" var="vRemove"> 

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

	<tr><td height="10"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided="yes" size="30" maxlenght="30" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Enforce TO Attachment">:</TD>
    <TD>
  	   	<input type="Radio" class="radiol" id="TaskOrderAttachmentEnforce" name="TaskOrderAttachmentEnforce" value="1" <cfif get.TaskOrderAttachmentEnforce eq 1>checked</cfif>> Yes
  	   	<input type="Radio" class="radiol" id="TaskOrderAttachmentEnforce" name="TaskOrderAttachmentEnforce" value="0" <cfif get.TaskOrderAttachmentEnforce eq 0>checked</cfif>> No
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Self Service">:</TD>
    <TD>
  	   	<input type="Radio" class="radiol" id="SelfService" name="SelfService" value="1" <cfif get.SelfService eq 1>checked</cfif>> Yes
  	   	<input type="Radio" class="radiol" id="SelfService" name="SelfService" value="0" <cfif get.SelfService eq 0>checked</cfif>> No
    </TD>
	</TR>


	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td align="center" colspan="2" height="40">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>
	


