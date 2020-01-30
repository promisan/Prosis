<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Language" 
			  menuAccess="Yes" 
			  banner="gray"
			  systemfunctionid="#url.idmenu#">

 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="4"></td></tr>
	
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium" width="30%">Code:</TD>
    <TD>
		<cfinput type="Text" name="LanguageId" id="LanguageId" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
		<cfinput type="Text" name="LanguageName" ID="LanguageName" value="" message="Please enter a description" required="Yes" size="30" maxlength="30"
		class="regularxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Class:</TD>
    <TD class="labelmedium">
	  <input type="radio" name="LanguageClass" id="LanguageClass" value="Official">Official
	  <input type="radio" name="LanguageClass" id="LanguageClass" value="Standard" checked>Standard
	</TD>
	</TR>


	<tr><td colspan="2" height="4"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>	
	
	<TR>
		<td colspan="2" align="center">
		<input class="button10s" style="width:110px" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10s" style="width:110px" type="submit" name="Insert" value=" Submit ">
		</td>
	</TR>
    
</TABLE>

</CFFORM>