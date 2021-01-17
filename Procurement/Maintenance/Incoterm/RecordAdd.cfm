
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="No" 
			  layout="webapp" 
			  label="Add Incoterm" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">
	
	<!--- Entry form --->
	
	<table width="90%" class="formpadding formspacing"  align="center">
	
	   <!--- Field: Id --->
	   
	    <tr><td height="7"></td></tr>
	    <TR>
	    <TD style="height:29" class="labelmedium2">Code:</TD>
	    <TD class="regular">
			<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
			class="regularxxl">
		</TD>
		</TR>	
	
	   <!--- Field: Description --->
	   
	    <TR>
	    <TD style="height:29" class="labelmedium2">Description:</TD>
	    <TD class="regular">
			<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50"
			class="regularxxl">
		</TD>
		</TR>
				
		<tr><td colspan="2" class="line"></td></tr>
			
		<tr>	
			<td align="center" colspan="2" height="30">
			<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
			<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
			</td>
		</tr>
		   
	</TABLE>

</CFFORM>

