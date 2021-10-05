
<cfquery name="Get" 
datasource="AppsInit">
	SELECT *
	FROM Parameter 
	WHERE HostName = '#URL.host#' 
</cfquery>

<cfform method="POST" name="editform"  onsubmit="return false">

	<input type="hidden" name="Form.HostName" id="Form.HostName" value="#get.hostname#">
				
	<table width="92%" border="0" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td height="5"></td></tr>
	
	<cfoutput query="Get">
	<!--- Field: Default Login --->
    <TR>
	<cf_UIToolTip tooltip="This account should have DB_READER and DB_WRITER role for all #SESSION.welcome# databases and DBO access in addition for db.UserQuery.">
    <td style="cursor:pointer" class="labelmedium" width="160">SQL Connection Account:<cf_space spaces="75">
	</td>
	</cf_UIToolTip>
    <TD><table cellspacing="0" cellpadding="0">
		<tr><td class="labelmedium">
	  	<img src="#SESSION.root#/Images/sql_login.jpg"
	     border="0"
	     align="absmiddle">&nbsp;
    	 	<cfinput class="regularxl" type="Text" name="DefaultLogin" value="#DefaultLogin#" message="Please enter the database account" required="Yes" size="10" maxlength="20">
		</TD>
	    <td class="labelmedium" style="padding-right:4px;padding-left:10px">Password:</td>
	    <TD>
		<cfoutput>
		
		<cftry>
		 <cf_decrypt text = "#get.DefaultPassword#">
		 <cfcatch>
		 <cfset decrypted = get.DefaultPassword>
		 </cfcatch>
		</cftry> 
		
  	    <input type="Password"
	       name="DefaultPassword"
		   id="DefaultPassword"
	       size="20"
	       maxlength="30"
	       value="#Decrypted#"	      
	       class="regularxl">
		
		</cfoutput>
		
		
    	</TD></TR>	
		</table>
	</td></tr>	
		
		
	<TR>
	
    <td style="padding-top:6px;cursor:pointer" title="Verifies passed URL query string (?id=xxxxxx&id1=xxxxxx) prior to processing the request." 
	valign="top" class="labelmedium" width="160">URL query string protection (XSS):</td>
	
	<TD class="labelmedium">
	
	<table cellspacing="0" cellpadding="0"><tr>
	<td valign="top">
	<input type="radio" class="radiol" name="EnableURLCheck" id="EnableURLCheck" value="0" <cfif get.EnableURLCheck eq "0">checked</cfif>>
	</td>
	<td class="labelmedium" style="padding-left:10px">Disabled
	</td>
	</tr>
	
	<tr>
	<td valign="top">
	<input type="radio" class="radiol" name="EnableURLCheck" id="EnableURLCheck" value="1" <cfif get.EnableURLCheck eq "1">checked</cfif>>
	</td>
	<td class="labelmedium" style="padding-top:2px;padding-left:10px">Prosis SQL keyword and Coldfusion string protection</td>
	</tr>
	
	<tr>
	<td valign="top">
	<input type="radio" class="radiol" name="EnableURLCheck" id="EnableURLCheck" value="2" <cfif get.EnableURLCheck eq "2">checked</cfif>>
	</td>
	<td class="labelmedium" style="padding-top:2px;padding-left:10px"><b>F</b>use<b>G</b>uard<br><font color="808080">extended protection recuires installation</font></td>
	</tr>
	</table>
		</td>
	</tr>
	
	<TR>
	<cf_UIToolTip tooltip="Validates User access for the content of the URL prior to processing the request.">
    <td valign="top" style="padding-top:6px" class="labelmedium" width="160">Cross-site Request Forgery CSFR:</td>
	</cf_UIToolTip>
	<TD>
	<table cellspacing="0" cellpadding="0"><tr>
	<td valign="top">
	<input type="radio" class="radiol" name="URLProtectionMode" id="URLProtectionMode" value="0" <cfif get.URLProtectionMode eq "0">checked</cfif>>
	</td>
	<td class="labelmedium" style="padding-left:10px">Only Cross-site POST are scanned.
	<!---
	Standard (validates for incorrectly formulated URL to initiate hacking, refer ot table System.dbo.SyntaxVerification)
	
	---></td>
	</tr>
	
	<tr>
	<td valign="top">
	<input type="radio" class="radiol" name="URLProtectionMode" id="URLProtectionMode" value="1" <cfif get.URLProtectionMode eq "1">checked</cfif>>
	</td>
	<td class="labelmedium" style="padding-top:2px;padding-left:10px">Enabled, allows for bookmarking (ajax excluded) by same user under an authenticated session<br><font color="808080">adds anti-CSRF token (mid) to the URL, which is validated upon opening the template</font></td>
	</tr>
	
	<tr>
	<td valign="top">
	<input type="radio" class="radiol" name="URLProtectionMode" id="URLProtectionMode" value="2" <cfif get.URLProtectionMode eq "2">checked</cfif>>
	</td>
	<td class="labelmedium" style="padding-top:2px;padding-left:10px">Enabled, strict (no bookmarking)<br><font color="808080">adds anti-CSRF token (mid) to the URL, which is expired upon receiving the template</font></td>
	</tr>
	</table>
   
	</td>
	</tr>
	
	<TR>
	<td width="160" class="labelmedium" style="cursor:pointer" title="Validates User Session and terminates session if conflict exists">Validate User Session:</td>	
	<TD>
	
		<table cellspacing="0" cellpadding="0"><tr>
		<td>
		<input type="radio" class="radiol" name="SessionProtectionMode" id="SessionProtectionMode" value="0" <cfif get.SessionProtectionMode eq "0">checked</cfif>>
		</td>
		<td class="labelmedium">Standard</td>
		<td class="labelmedium" style="padding-left:5px">Interval:</td>
		<td style="padding-left:5px;padding-right:5px">
			<cfinput type="Text"
		       name="SessionProtectionInterval"
		       width="1"
			   value="#get.SessionProtectionInterval#"
			   style="text-align:center;width:30px"
		       validate="integer"
		       required="Yes"
		       visible="Yes"
			   class="regularxl"
		       enabled="Yes"
		       size="3"
		       maxlength="2"> 
		 </td>
		 <td class="labelmedium">seconds.</td>  
	    	
		<td style="padding-left:8px">
		<input type="radio" class="radiol" name="SessionProtectionMode" id="SessionProtectionMode" value="1" <cfif get.SessionProtectionMode eq "1">checked</cfif>>
		</td>
		<td class="labelmedium">Secure (terminates mixed sessions)</td>			
		</tr>
		</table>
   
	</td>
	</tr>
		
	<TR> 
	  <td style="cursor:pointer" title="Verifies passed FORM elements prior to processing the user request" width="160" class="labelmedium">Customised check FORM elements:</td>	 	  
	  <TD><input type="checkbox" class="radiol" name="EnableFormCheck" id="EnableFormCheck" value="1" <cfif get.EnableFormCheck eq "1">checked</cfif>></TD>
	  
	</TR>
	
	<TR>
	<cf_UIToolTip tooltip="Records visit to a webpage template per defined interval in minutes. <br> Set to 0 min to record each visit.">
    <td style="cursor:pointer" width="160" class="labelmedium">Page Visit Logging:</td>
	</cf_UIToolTip>
	<TD class="labelmedium">
	
	<cfinput type="Text"
       name="TemplateLogging"
       width="1"
	   value="#get.templateLogging#"
	   style="text-align:center;width:30px"
       validate="integer"
       required="Yes"
       visible="Yes"
       enabled="Yes"
	   class="regularxl"
       size="2"
       maxlength="1"> min

		
	<TR>
	<td style="cursor:pointer" width="160" class="labelmedium">
		<cf_UIToolTip tooltip="Option to disable IP routing on the application server level for all its users.">
		Disable IP routing:
		</cf_UIToolTip>
	</td>
	
	<TD class="labelmedium">
	  <input type="radio" class="radiol" name="DisableIPRouting" id="DisableIPRouting" value="0" <cfif get.DisableIPRouting eq "0">checked</cfif>>No
      <input type="radio" class="radiol" name="DisableIPRouting" id="DisableIPRouting" value="1" <cfif get.DisableIPRouting eq "1">checked</cfif>>Yes
	</TD>
	</TR>
		
	<tr><td class="linedotted" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center">
	 	<input type="button" onclick="validate('security')" name="Update" id="Update" value="Save" class="button10g">	
	</td></tr>
	
	</table>
	
	</cfoutput>
	
</cfform>	