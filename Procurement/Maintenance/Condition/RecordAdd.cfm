<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="" 
			  label="Add condition" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<table width="95%" align="center" class="formpadding">

	<tr><td style="height:6px"></td></tr>

   <!--- Field: Id --->
    <TR>
    <TD class="labelmediumn2">Code:</TD>
    <TD class="labelit">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxxl">
	</TD>
	</TR>
		
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelit">
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50"
		class="regularxxl">
	</TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">

	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>
