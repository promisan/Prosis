<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Group"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">

    <TR>
    <TD class="labelmedium2" height="25px">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="GroupCode" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2" height="25px">Domain:</TD>
    <TD>
	   <cfselect name="GroupDomain" class="regularxxl">
			<option value="Candidate" SELECTED>Candidate</option>
			<option value="Bucket">Roster bucket</option>
		</cfselect>
     </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2" height="25px">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxxl">
    </TD>
	</TR>

	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>
		
	<tr>		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	</tr>
	
</table>

</cfform>