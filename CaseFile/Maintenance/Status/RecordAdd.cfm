<cfparam name="url.idmenu" default="">

<cf_tl id = "Add Status" var = "1">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray"
			  title="#lt_text#" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->
<cfoutput>

<table width="95%" align="center" class="formpadding formspacing">

	 <TR class="labelmedium2">
	 <TD><cf_tl id="Class">:&nbsp;</TD>  
	 <TD>
			<select name="StatusClass" class="regularxxl">
			  <option value="clm">Claim Header</option>
			  <option value="lne">Line</option>
			</select>
	 </TD>
	 </TR>
	 
   <!--- Field: Id --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
		<cf_tl id = "Please enter a status code" var = "1" class = "Message">
		<cfinput type="Text" name="Status" id="Status" value="" message="#lt_text#" required="Yes" size="2" maxlength="2"
		class="regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
		<cf_tl id = "Please enter a description" var = "1" class = "Message">
		<cfinput type="Text" name="Description" id="Description" value="" message="#lt_Text#" required="Yes" size="50" maxlength="50"
		class="regularxxl">
	</TD>
	</TR>
		
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>		
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Submit" var = "1">
		<input class="button10g" type="submit" name="Insert" value=" #lt_text# ">
		</td>
	</tr>
    
</TABLE>
</cfoutput>
	


</CFFORM>

</BODY></HTML>