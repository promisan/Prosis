<cfparam name="url.idmenu" default="">

<cf_TextareaScript>

<cf_screentop height="100%" 
			  layout="webapp" 
			  label="Clause Entry Form" 
			  menuAccess="Yes" 
			  jQuery="Yes"
			  banner="gray"
			  line="no"
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->



<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="98%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="5"></td></tr>

    <!--- Field: Id --->
    <TR>
    <td class="labelmedium" width="90">Code:</td>
    <TD>
		<cfinput type="Text" class="regularxl" name="Code" message="Please enter a Code" required="Yes" size="10" maxlength="10">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
		<cfinput type="Text" class="regularxl" name="ClauseName" message="Please enter description" required="Yes" size="50" maxlength="50">
	</TD>
	</TR>
	
	<tr>
	<td class="labelmedium">Operational:</td>	
	<td>		 
    	<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>				
	</td>
	</tr>
				
	<cfquery name="Language" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_SystemLanguage 
	</cfquery>
	
	<tr>
	<td class="labelmedium">Language:</td>
	
	<td>
	  <select name="LanguageCode" class="regularxl" id="LanguageCode">
	  <cfoutput query="language">
	    <option value="#Code#">#LanguageName#</option>		
	  </cfoutput>
	  </select>
		
	</td>
	</tr>
	
	<tr><td height="5"></td></tr>
 
    <!--- Field: Fielname --->
    <TR>
      <td colspan="2" style="padding-top:6px">	  
		<cf_textarea height="540" color= "ffffff" init="Yes" name="clausetext"></cf_textarea>
	  </td>
	</TR>
	
	<tr>	
		<td align="center" colspan="2" height="32">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value="Save">
		</td>
	</tr>
	
</TABLE>

</CFFORM>


