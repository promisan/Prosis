
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Organization" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ApplicantClass
WHERE ApplicantClassId = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this class?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	    <cfoutput>
		<tr><td></td></tr>
	    <TR>
	    <TD  class="labelmedium">Code:</TD>
	    <TD>
	  	   <input type="text" name="ApplicantClassId" id="ApplicantClassId" value="#get.ApplicantClassId#" size="10" maxlength="2" class="regularxl">
		   <input type="hidden" name="ApplicantClassIdOld" id="ApplicantClassIdOld" value="#get.ApplicantClassId#">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD  class="labelmedium">Scope:</TD>
	    <TD  class="labelmedium">
	  	  	<INPUT type="radio" name="Scope" id="Scope" value="Applicant" <cfif get.scope eq "Applicant">checked</cfif>> Applicant
			<INPUT type="radio" name="Scope" id="Scope" value="CaseFile" <cfif get.scope eq "CaseFile">checked</cfif>> Case File
			<INPUT type="radio" name="Scope" id="Scope" value="Patient" <cfif get.scope eq "Patient">checked</cfif>> Patient
	    </TD>
		</TR>
		
		</cfoutput>
	
		<tr><td colspan="2" height="6"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td colspan="2" height="6"></td></tr>
	
		
		<tr>
		<td align="center" colspan="2" valign="bottom">
		<input class="button10g" style="width:90" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" style="width:90" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" style="width:90" type="submit" name="Update" value=" Update ">
		</td>	
		</tr>
		
	</table>	

</cfform>

