<cf_screentop height="100%" 
		      scroll="Yes" 
			  layout="webapp" 
			  label="Edit decision code" >
			  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_RosterDecision
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this entry?")) {
	return true 
	}
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="93%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <tr><td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="15" maxlength="15" class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="15" maxlength="15" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="30"class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	<TR valign="top">
    <TD class="labelmedium">Memo:</TD>
    <TD>
	   <textarea cols="44" style="font-size:13px;padding:3px" rows="6" name="DescriptionMemo" class="regular">#get.DescriptionMemo#</textarea>
  	  
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>
	</tr>
	
</TABLE>
		
</CFFORM>