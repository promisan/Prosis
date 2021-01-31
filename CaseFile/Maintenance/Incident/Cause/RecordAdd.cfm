<cfparam name="url.idmenu" default="">

<cf_tl id="Add Cause" var="1">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Cause" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_PreventCache>
 
<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- Entry form --->

<cfoutput>
<table width="95%" align="center" class="formpadding formspacing">

	<tr><td></td></tr>
   <!--- Field: Id --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
		<cf_tl id = "Please enter a code" var = "1">
		<cfinput type="Text" name="Code" id="Code" value="" message="#lt_text#" required="Yes" size="20" maxlength="20"
		class="regularxxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
		<cf_tl id = "Please enter a description" var = "1">
		<cfinput type="Text" name="Description" id="Description" value="" message="#lt_text#" required="Yes" size="50" maxlength="50"
		class="regularxxl">
	</TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr>
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var ="1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Submit" var ="1">
		<input class="button10g" type="submit" name="Insert" value=" #lt_text# ">
		</td>	
	</tr>
	

    
</TABLE>
</cfoutput>

</CFFORM>

