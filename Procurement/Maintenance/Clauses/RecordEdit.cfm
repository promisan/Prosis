<cfparam name="url.idmenu" default="">

<cf_TextAreaScript>

<cf_screentop layout="webapp" 
	  height="100%" 
	  label="Clause Edit Form" 
	  menuAccess="Yes" 
	  banner="gray"	  
	  jquery="Yes"
	  doctype="Standards"
	  line="no"
	  systemfunctionid="#url.idmenu#">	
  
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {
		return true 
	}	
	return false	
}	

</script>


<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Clause
	WHERE Code = '#URL.ID1#' 
</cfquery>

<cfquery name="Language" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_SystemLanguage 
</cfquery>


<CFFORM action="RecordSubmit.cfm" method="post" style="height:100%">

<table width="98%" height="99%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr><td height="4"></td></tr>

    <TR>
	
    <TD style="padding-left:5px" class="labelit" height="20">Code:</TD>
    <TD class="labelit"><cfoutput><b>#URL.ID1#</cfoutput></TD>
	<TD class="labelit" style="padding-left:10px">Name:</TD>
    
	<TD>
	
  	    <cfoutput query="get">
		<input type="hidden" name="Code" id="Code" value="#Code#">
		<cfinput type="Text" class="regularxl" name="ClauseName" value="#ClauseName#" message="Please enter a description" required="Yes" size="30" maxlength="30">
		</cfoutput>
		
    </TD>
	
	<td style="padding-left:10px" class="labelit">Operational:</td>
	
	<td>
	
	    <cfoutput query="get">
	    	<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif operational eq "1">checked</cfif>>		
		</cfoutput>
	
	</td>
	
	<td style="padding-left:10px" class="labelit">Language:</td>
	
	<td>
	  <select name="LanguageCode" id="LanguageCode" class="regularxl">
	  <cfoutput query="language">
	    <option value="#Code#" <cfif code eq get.LanguageCode>selected</cfif>>#LanguageName#</option>		
	  </cfoutput>
	  </select>
		
	</td>
	
	<td width="20%"></td>
	
	</TR> 
	
     <!--- Field: Capacity --->
    <TR valign="top" style="padding-top:7px">
		
	    <td colspan="9" style="height:100%;border:0px solid e3e3e3;padding:0px;padding-top:10px"> 	
											
		<cfoutput>
			<cf_textarea color= "ffffff" height="630" init="Yes" name="clausetext">#Get.ClauseText#</cf_textarea>
		</cfoutput>
				
		</TD>
	
	</TR>
	
	<!---
	<tr><td height="1" colspan="9" class="linedotted"></td></tr>
	--->
	
	<tr><td colspan="9" align="center" height="20">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
		<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>

</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">