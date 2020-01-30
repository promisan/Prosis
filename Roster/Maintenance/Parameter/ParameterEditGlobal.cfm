
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM Parameter 
</cfquery>

<CFFORM action="ParameterEditGlobalSubmit.cfm" method="post">

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="9"></td></tr>
	
	<cfoutput query = "Get">
      <input type="Hidden" name="Identifier" value="#Identifier#">
    </cfoutput>  
	
    <TR>
    <td class="labelit" width="140">Last Roster search No:</b></td>
    <TD><cfoutput query="get">
		<input class="regularxl" type="text"   name="SearchNo" value="#SearchNo#" size="10" maxlength="10" style="text-align: right;">
		</cfoutput>
    </TD>
	</TR>
	
	<tr><td height="2"></td></tr>
			
	   <!--- Field: Prosis Document Root --->
    <TR>
    <td class="labelit">Path and URL Document Root:</b></td>
    <TD>
  	    <cfoutput query="get">
			<cfinput class="regularxl"  type="Text" name="DocumentLibrary" value="#DocumentLibrary#" message="Please enter the correct root" required="Yes" size="30" maxlength="30">
		</cfoutput>
		<cfoutput query="get">
			<cfinput class="regularxl"  type="Text" name="DocumentURL" value="#DocumentURL#" message="Please enter the correct local path" required="Yes" size="30" maxlength="30">
		</cfoutput>
    </TD>
	</TR>
	
	<tr><td height="4"></td></tr>
	
	<TR>
	<td class="labelit" style="cursor: pointer;"><cf_UIToolTip tooltip="Allow users to view review actions for a candidate which initiated by a different owner">Share Review Actions between owners:</cf_UIToolTip></td>
    <TD class="labelit">
			
	<cfoutput query="get">
	<input type="radio" class="radiol" name="ReviewOwnerAccess" <cfif ReviewOwnerAccess eq "1">checked</cfif> value="1">Share
	<input type="radio" class="radiol" name="ReviewOwnerAccess" <cfif ReviewOwnerAccess eq "0">checked</cfif> value="0">Do not share	
	</cfoutput>
	
    </td>
    </tr>
	
	
	<tr><td height="4"></td></tr>
	
	 <!--- Field: Editions --->
    <TR>
    <td class="labelit">PHP self service module:</b></td>
    <TD></td>
	</tr>
	
	 <!--- Field: Editions --->
    <TR>
    <td align="right" class="labelit">PHP External:</td>
    <TD>
		
		<cfquery name="Org" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Source
		</cfquery>
		
		<cfselect name="PHPSource" class="regularxl" tooltip="The source used for external/uploaded PHP records" visible="Yes" enabled="Yes">
		<cfoutput query = "Org">
		 <option value="#Org.Source#" <cfif Get.PHPSource eq "#Org.Source#">selected</cfif>>#Org.Source#</option>  
	    </cfoutput>  
		</cfselect>
			
    </td>
    </tr>
	
	 <!--- Field: Editions --->
    <TR>
    <td align="right" class="labelit">PHP Entry:</td>
    <TD class="labelit">
		
		<cfquery name="Org" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Source
		</cfquery>
		
		<cfselect name="PHPEntry" class="regularxl" tooltip="The source used to for entries made through the PHP/SI module">
		<cfoutput query = "Org">
		 <option value="#Org.Source#" <cfif #Get.PHPEntry# eq "#Org.Source#">selected</cfif>>#Org.Source#</option>  
	    </cfoutput>  
		</cfselect>
		
		<cf_UIToolTip tooltip = "Disabling the calendar will improve performance for remote users.">
		<input type="checkbox" class="radiol" name="PHPEntryCalendar" value="1" <cfif #Get.PHPEntryCalendar# eq "1">checked</cfif>>Show calendar
		</cf_UIToolTip>
		
    </td>
    </tr>
						
	<tr><td align="right" class="labelit">Template root:&nbsp;</td>	
	    <td><cfinput type="Text" name="TemplateRoot" value="#Get.TemplateRoot#" message="Please enter a path" required="Yes" visible="Yes" enabled="Yes" size="60" maxlength="80" class="regularxl" style="text-align: left;"></td>
	</tr>
	<tr><td align="right" class="labelit">Template home:&nbsp;</td>	
	    <td><cfinput class="regularxl" type="text" name="TemplateHome" value="#Get.TemplateHome#" size="60" maxlength="80" required="Yes" style="text-align: left;" message="Please enter a path">
	</td>
	</tr>
	<tr><td align="right" class="labelit">Template introduction:&nbsp;</td>	
	    <td><cfinput class="regularxl" type="text" name="TemplateIntroduction" value="#Get.TemplateIntroduction#" size="60" maxlength="80"   style="text-align: left;" message="Please enter a path">
			<cf_tip text="This custom template contains the introduction portal text for the PHP module.">
	</td>
	</tr>
	<tr><td align="right" class="labelit">Template validation:&nbsp;</td>	
	    <td><cfinput class="regularxl" type="text" name="TemplateValidation" value="#Get.TemplateValidation#" size="60" maxlength="80"   style="text-align: left;" message="Please enter a path">
			<cf_tip text="This custom template is used to validate entered PHP account information. \n \n If you leave it blank it will allow any account to be created if it does not exisits already in dbo.Applicant.">
	</td>
	</tr>
		
	<cfquery name="Org" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Organization
	</cfquery>
	
	<tr><td height="4"></td></tr>
	
    <TR>
    <td style="cursor: pointer;" class="labelit">
	<cf_UIToolTip tooltip="A recruitment request generates a buckets under this area">Default area:</cf_UIToolTip></b>
	</td>
    <TD>
	
	<select name="DefaultOrganization" class="regularxl">
	<cfoutput query = "Org">
	     <option value="#Org.OrganizationCode#" <cfif Get.DefaultOrganization eq "#Org.OrganizationCode#">selected</cfif>>#Org.OrganizationDescription#</option>  
    </cfoutput> 
	</select> 	
		
    </td>
    </tr>
	
	<tr><td height="3"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="3"></td></tr>
	
	<tr><td height="10" colspan="2" align="center" valign="absmiddle">
	    <input type="button" value="Back" class="button10g"  onclick="menu()">	
		<input type="submit" name="Update" value=" Update " class="button10g">
	</td></tr>
	
</table>
		
</cfform>
	
