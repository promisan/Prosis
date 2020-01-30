<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              label="Edit"
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_DocumentType
WHERE DocumentType = '#URL.ID1#'
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="DocumentType" value="#get.DocumentType#" size="10" maxlength="10" class="regularxl">
	   <input type="hidden" name="DocumentTypeOld" value="#get.DocumentType#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="23" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium">Enable removal:</b></td>
    <TD class="labelmedium">  
	  <input type="radio" name="EnableRemove" <cfif #Get.EnableRemove# eq "0">checked</cfif> value="0">No
	  <input type="radio" name="EnableRemove" <cfif #Get.EnableRemove# eq "1">checked</cfif> value="1">Yes 
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Enable edit:</b></td>
    <TD class="labelmedium">  
	  <input type="radio" name="EnableEdit" <cfif #Get.EnableEdit# eq "0">checked</cfif> value="0">No
	  <input type="radio" name="EnableEdit" <cfif #Get.EnableEdit# eq "1">checked</cfif> value="1">Yes 
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Mode:</b></td>
    <TD class="labelmedium">  
	  <input type="radio" name="VerifyDocumentNo" <cfif Get.VerifyDocumentNo eq "0">checked</cfif> value="0">Optional
	  <input type="radio" name="VerifyDocumentNo" <cfif Get.VerifyDocumentNo eq "1">checked</cfif> value="1">Obligatory 
	  <input type="radio" name="VerifyDocumentNo" <cfif Get.VerifyDocumentNo eq "2">checked</cfif> value="2">Validate 
    </td>
    </tr>
	
	</cfoutput>
	
	
</TABLE>

<cf_dialogBottom option="edit" delete="Document type">
	
</CFFORM>

</BODY></HTML>