<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="DocumentType" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="23" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium">Enable removal:</b></td>
    <TD>  
	  <input type="radio" name="EnableRemove" checked value="0">No
	  <input type="radio" name="EnableRemove" value="1">Yes 
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Enable edit:</b></td>
    <TD>  
	  <input type="radio" name="EnableEdit" checked value="0">No
	  <input type="radio" name="EnableEdit" value="1">Yes 
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Enable Validation:</b></td>
    <TD class="labelmedium">  
	  <input type="radio" name="VerifyDocumentNo" checked value="0">Optional
	  <input type="radio" name="VerifyDocumentNo" value="1">Obligatory 
	  <input type="radio" name="VerifyDocumentNo" value="2">Validate 
    </td>
    </tr>
	
</table>

<cf_dialogBottom option="add">

</CFFORM>
