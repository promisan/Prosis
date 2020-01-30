<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
  			  scroll="Yes" 
			  layout="webapp" 			 
			  label="New class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Enforce TO Attachment">:</TD>
    <TD>
		<input type="Radio" id="TaskOrderAttachmentEnforce" name="TaskOrderAttachmentEnforce" value="1" checked> Yes
  	   	<input type="Radio" id="TaskOrderAttachmentEnforce" name="TaskOrderAttachmentEnforce" value="0"> No
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Self Service">:</TD>
    <TD>
  	   	<input type="Radio" id="SelfService" name="SelfService" value="1" checked> Yes
  	   	<input type="Radio" id="SelfService" name="SelfService" value="0"> No
    </TD>
	</TR>
	
		
	<tr><td height="3"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr>
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Save ">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>




