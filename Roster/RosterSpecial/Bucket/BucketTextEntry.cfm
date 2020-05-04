<cf_textareascript>

<cf_screentop height="100%" label="Record VA" scroll="yes" html="No" jquery="yes">
		
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="white">

<cfform action="BucketTextEntrySubmit.cfm?ID=#URL.ID#" method="post" name="gjp" id="gjp">
  
  <tr>
    <td colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
	<TR>
    <TD width="150"><b><cf_tl id="External VA No">:</TD>
    <td width="80%"><cfoutput>#url.referenceNo#</cfoutput>
	
    	<cfoutput>
			<input type="hidden" name="ReferenceNo" value="#url.referenceNo#" size="20" maxlength="20">
			<input type="hidden" name="FunctionId" value="">
		</cfoutput>		
	
	</TR>	
			
	<tr><td height="1" colspan="4" class="line"></td></tr>
	
	<tr><td height="2" colspan="4">

	  <cf_ApplicantTextArea
			Table           = "FunctionOrganizationNotes" 
			Domain          = "JobProfile"
			FieldOutput     = "ProfileNotes"				
			Mode            = "Edit"
			Format          = "Mini"
			Key01           = "FunctionId"
			Key01Value      = "#URL.ID#">			
	
	</td></tr>
		    
   <tr><td height="2"></td></tr>
   <tr><td colspan="4" align="center">
      <input class="button10g" type="submit" name="Upload" value="Save" onclick="updateTextArea();">
   </td></tr>
   <tr><td height="2"></td></tr>
  		
</TABLE>

</td>

</tr>

</cfform>

</table>

<cfset AjaxOnLoad("initTextArea")>


