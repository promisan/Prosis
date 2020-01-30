<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Review Class" 
			  menuAccess="Yes"
			  jquery="yes"
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ReviewClass
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this event category?")) {	
		return true 	
		}	
		return false	
	}	

</script>

<cfajaximport tags="cfform">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="10"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium" width="20%">Code:</TD>
    <TD class="labelmedium">
		#get.code#
  	   <input type="hidden" name="Code" value="#get.Code#" size="15" maxlength="15"class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="15" maxlength="15" readonly>
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="30"class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	<cfquery name="Category" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterSkill
	</cfquery>
	
	<TR>
    <TD class="labelmedium">Category:</TD>
    <TD>
	   <select name="ExperienceCategory" class="regularxl">
	   <option selected></option>
	   <cfloop query="category">
	   <option value="#Code#" <cfif #get.ExperienceCategory# eq "#Code#">selected</cfif>>#Description#</option>
	   </cfloop>
	   </select>
  	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD class="labelmedium">
		<table>
			<tr>
				<td><INPUT type="radio" name="Operational" value="0" <cfif "0" eq "#get.Operational#">checked</cfif>></td>
				<td style="padding-left:2px;">Disabled</td>
				<td style="padding-left:8px;"><INPUT type="radio" name="Operational" value="1" <cfif "1" eq "#get.Operational#">checked</cfif>></td>
				<td style="padding-left:2px;">Enabled</td>
			</tr>
		</table>
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<tr>
		<td class="labelmedium" valign="top" style="padding-top:5px;">Owners:</td>
		<td class="labelmedium" valign="top" style="padding-top:3px;">
			<cfdiv id="divOwner" bind="url:Owner.cfm?code=#get.code#">
		</td>
	</tr>
	
	</cfoutput>
	
	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>
	
	<tr><td colspan="2" align="center">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Save ">
	</td></tr>
	
	
</TABLE>

	
</CFFORM>


</BODY></HTML>