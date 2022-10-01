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

<table width="93%" align="center" class="formpadding formspacing">

	<tr><td></td></tr>
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="Text" name="DocumentType" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="23" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <td><cf_tl id="Enable removal">:</td>
    <TD>  
	  <input type="radio" name="EnableRemove" checked value="0">No
	  <input type="radio" name="EnableRemove" value="1">Yes 
    </td>
    </tr>
	
	<TR class="labelmedium2">
    <td><cf_tl id="Enable edit">:</td>
    <TD>  
	  <input type="radio" name="EnableEdit" checked value="0">No
	  <input type="radio" name="EnableEdit" value="1">Yes 
    </td>
    </tr>
	
	<TR class="labelmedium2">
    <td><cf_tl id="Enable Validation">:</td>
    <TD>  
	  <input type="radio" name="VerifyDocumentNo" checked value="0"><cf_tl id="Optional">
	  <input type="radio" name="VerifyDocumentNo" value="1"><cf_tl id="Obligatory"> 
	  <input type="radio" name="VerifyDocumentNo" value="2"><cf_tl id="Validate"> 
    </td>
    </tr>
	
</table>

<cf_dialogBottom option="add">

</CFFORM>
