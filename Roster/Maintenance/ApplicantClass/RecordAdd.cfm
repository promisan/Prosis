
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%"
			  title="Applicant class" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog"><br>

<table width="92%" align="center" class="formpadding formspacing">
    
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="ApplicantClassId" value="" message="Please enter a code" required="Yes" size="3" maxlength="2" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxxl">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium2">Scope:</TD>
    <TD  class="labelmedium">
  	  	<INPUT type="radio" class="radiol" name="Scope" value="Applicant" checked> Applicant
		<INPUT type="radio" class="radiol" name="Scope" value="CaseFile"> Case File
		<INPUT type="radio" class="radiol" name="Scope" value="Patient"> Patient
		<INPUT type="radio" class="radiol" name="Scope" value="Customer"> Customer
    </TD>
	</TR>
		
	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
		
	<tr>	
	<td align="center" colspan="2"  valign="bottom">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	</tr>
	
</table>

</cfform>


