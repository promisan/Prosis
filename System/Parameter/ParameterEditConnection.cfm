
<cfquery name="Get" 
datasource="AppsInit">
	SELECT *
	FROM Parameter 
	WHERE HostName = '#URL.host#' 
</cfquery>

<cfform method="POST" name="editform"  onsubmit="return false">

	<input type="hidden" name="Form.HostName" id="Form.HostName" value="#get.hostname#">

	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="5"></td></tr>
				
	<TR>
    <td width="200" class="labelmedium">Application Server Contact:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SystemContact" value="#SystemContact#" message="Please enter a contact name" required="Yes" size="40" maxlength="50">
		</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <td style="padding: 2px;" class="labelmedium">eMail address:</b></td>
    <TD style="padding: 2px;">
    	<cfoutput query="get">
			<cfinput type="Text" name="SystemContactEMail" value="#SystemContactEMAIL#" message="Please enter a contact eMail address" validate="email" required="Yes" visible="Yes" enabled="Yes" size="50" maxlength="50" class="regularxl">
		</cfoutput>
	</TD>
	</TR>
	<TR>
    <td style="padding: 2px;" class="labelmedium">Support Link:</b></td>
    <TD style="padding: 2px;">
		
		<cfquery name="Link" 
		datasource="AppsSystem">
			SELECT    *
			FROM      PortalLinks
			WHERE     Class = 'Reference'
		</cfquery>	
	
		<select name="SystemSupportPortalId" id="SystemSupportPortalId" class="regularxl">
		<option value="">N/A</option>
    	<cfoutput query="link">
		   <option value="#PortalId#" <cfif portalid eq get.SystemSupportPortalId>selected</cfif>>#Description#</option>
		</cfoutput>
		</select>
	</TD>
	</TR>
	
	<tr>
			<td style="padding: 2px;" class="labelmedium">Password Reset Mode:</td>
			<td>
				<table width="100%">
					<td width="1%" align="right">
						<INPUT class="radiol" type="radio" name="PasswordReset" id="PasswordReset" value="1" <cfif Get.PasswordReset eq "1">checked</cfif>>
					</td>
					<td style="padding-left:5px" class="labelmedium" width="2%" align="left">Send temporary password<cf_space spaces="50"></td>
					<td style="padding-left:9px" width="1%" align="right">
						<INPUT class="radiol" type="radio" name="PasswordReset" id="PasswordReset" value="0" <cfif Get.PasswordReset eq "0">checked</cfif>>
					</td>
					<td style="padding-left:5px" class="labelmedium" width="2%" align="left">Send Link<cf_space spaces="30"></td>
					<td></td>
				</table>	
			</td>
		</tr>
	
	<TR>
    <td style="padding: 2px;" class="labelmedium">Enable User Account notification <b><a href="##" title="Send eMail to users upon changing or adding new accounts">Mail</a></b>:</b></td>
    <TD style="padding: 2px;">
	  <table cellspacing="0" cellpadding="0"><tr><td>	
	  <input type="radio" class="radiol" name="AccountNotification" id="AccountNotification" value="1" <cfif Get.AccountNotification eq "1">checked</cfif>></td><td class="labelmedium">Yes</td>
	  <td><input type="radio" class="radiol" name="AccountNotification" id="AccountNotification" value="0" <cfif Get.AccountNotification eq "0">checked</cfif>></td><td class="labelmedium">No</td>
	  </tr>
	  </table>
    </TD>
	</TR>
	
	<TR>
    <td style="padding: 2px;" class="labelmedium">Allow Users to connect:</b></td>
    <TD style="padding: 2px;">
	  <table cellspacing="0" cellpadding="0"><tr><td>
	  <input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif Get.Operational eq "1">checked</cfif>>
	  </td><td class="labelmedium">Yes</td>
	  <td>
	  <input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif Get.Operational eq "0">checked</cfif>>
	  </td><td class="labelmedium">No</td>
	  </tr>
	  </table>
	</td>
	</tr>
	
	<tr>	  
	  <td style="padding: 2px;" class="labelmedium"><cf_UIToolTip tooltip="Option to disable system access for the define period">Always disable connection between :</cf_UIToolTip></td>
	   <td>
	  	 <table cellspacing="0" cellpadding="0"><tr><td>
			  	<cfif len(Get.DisableTimeStart) lte "4">
				  <cfset h = "">
				  <cfset m = "">
				<cfelse>
				  <cfset h = left(Get.DisableTimeStart,2)>  
				  <cfset m = mid(Get.DisableTimeStart,  4,  2)>
				</cfif>  
			  				
						<cfinput type = "Text"
					       name       = "StartHour"
					       value      = "#h#"
					       message    = "Please enter time using 24 hour format"
					       validate   = "regular_expression"
					       pattern    = "[0-1][0-9]|[2][0-3]"
					       visible    = "Yes"
					       enabled    = "Yes"
						   required   = "no"
					       size       = "1"
						   onKeyUp    = "return autoTab(this, 2, event);"
					       maxlength  = "2"
						   style      = "text-align: center;width:25"
					       class      = "regularxl">
												 				
			   </td>
			   <TD align="center">:</TD>
			   <td align="center">
										
						<cfinput type="Text"
					       name      = "StartMinute"
					       value     = "#m#"
					       message   = "Please enter a departure minute between 00 and 59"
					       validate  = "regular_expression"
					       pattern   = "[0-5][0-9]"
					       required  = "no"
					       size      = "1"
						   maxlength = "2"
					       style     ="text-align: center;width:25"
					       class="regularxl">				 
			  
			  </td>
			  
			  <td>&nbsp;</td>
			  <td class="labelmedium">and:</td>
			  <td>&nbsp;</td>
			  
			  <td>
			  
			  	<cfif len(Get.DisableTimeEnd) lte "4">
				  <cfset h = "">
				  <cfset m = "">
				<cfelse>
				  <cfset h = left(Get.DisableTimeEnd,2)>  
				  <cfset m = mid(Get.DisableTimeEnd,  4,  2)>
				</cfif>  
			  				
				<cfinput type = "Text"
			       name       = "EndHour"
			       value      = "#h#"
			       message    = "Please enter time using 24 hour format"
			       validate   = "regular_expression"
			       pattern    = "[0-1][0-9]|[2][0-3]"
			       visible    = "Yes"
			       enabled    = "Yes"
				   required   = "no"
			       size       = "1"
				   onKeyUp    = "return autoTab(this, 2, event);"
			       maxlength  = "2"
				   style      = "text-align: center;width:25"
			       class      = "regularxl">
												 				
			   </td>
			   <TD align="center">:</TD>
			   <td align="center">
										
				<cfinput type="Text"
			       name      = "EndMinute"
			       value     = "#m#"
			       message   = "Please enter a departure minute between 00 and 59"
			       validate  = "regular_expression"
			       pattern   = "[0-5][0-9]"
			       required  = "no"
			       size      = "1"
				   maxlength = "2"
			       style     ="text-align: center;width:25"
			       class="regularxl">				 
			  
			  </td>  
	  
	  </tr>
	  </table>	
    </TD>
	</TR>
		
	<TR>
    <td style="padding: 2px;" class="labelmedium"><cf_UIToolTip tooltip="Message to user when loggin on to the system">Message to users:</cf_UIToolTip></b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput type="Text" name="OperationalMemo" value="#get.OperationalMemo#" message="Please enter a system message" required="No" visible="Yes" enabled="Yes" size="50" maxlength="80" class="regularxl">
		</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <td style="padding: 2px;" class="labelmedium">Language and Help <a href="##" title="Allows [administrator] account to make direct changes to language sensistive field and embedded help text"><b>Editing</a>:</b></td>
    <TD class="labelmedium">
	  <input type="radio" class="radiol" name="EnableCM" id="EnableCM" value="1" <cfif Get.EnableCM eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="EnableCM" id="EnableCM" value="0" <cfif Get.EnableCM eq "0" or Get.EnableCM eq "">checked</cfif>>No
    </TD>
	</TR>
	
	<tr><td height="9"></td></tr>	
	<tr><td class="linedotted" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" HEIGHT="34">
	 	<input type="button" onclick="validate('connection')" name="Update" ID="Update" value="Save" class="button10g">	
	</td></tr>
	
	</table>
	
</cfform>	