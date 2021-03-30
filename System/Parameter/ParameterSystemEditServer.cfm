<table width="97%" border="0"  class="formspacing formpadding" align="center">
		
		<tr><td height="6"></td></tr>
			
	    <TR>
	    <td  colspan="2" style="font-size:25px" width="170">Web Application Server</td>
		</tr>
				
	    <TR>
	    <td class="labellarge" style="padding-left:10" width="170">Virtual Directory to root:</td>
	    <TD width="70%">
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="VirtualDirectory" value="#VirtualDirectory#" required="No" size="30" maxlength="30">
			</cfoutput>
	    </TD>
		</TR>
		
		
		 <!--- Field: DefaulteMail --->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Document Web Server URL:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="DocumentServer" value="#DocumentServer#" required="Yes" size="70" maxlength="70">
			</cfoutput>
	    </TD>
		</TR>			
			

		 <!--- Field: DefaulteMail --->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Turn on/off Document Storage Server:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<INPUT type="radio" name="DocumentServerDisable" id="DocumentServerDisable" value="1" <cfif Get.DisableDocument eq "1">checked</cfif>> Enabled
			<INPUT type="radio" name="DocumentServerDisable" id="DocumentServerDisable" value="0" <cfif Get.DisableDocument eq "0">checked</cfif>> Disabled
			</cfoutput>
	    </TD>
		</TR>			
		

		 <!--- Field: ReplyTo--->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Turn on/off "Reply to" address:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<INPUT type="radio" name="ReplyTo" id="ReplyTo" value="1" <cfif #Get.ReplyTo# eq "1">checked</cfif>> Enabled
			<INPUT type="radio" name="ReplyTo" id="ReplyTo" value="0" <cfif #Get.ReplyTo# eq "0">checked</cfif>> Disabled
			</cfoutput>
	    </TD>
		</TR>			
			
		 <!--- Field: DefaulteMail --->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Default eMail Address:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="DefaultEMail" value="#DefaultEMAIL#" message="Please enter a contact" required="No" size="50" maxlength="50">
			</cfoutput>
	    </TD>
		</TR>
		
		 <!--- Field: DefaulteMail --->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Log attachments:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<INPUT type="radio" name="LogAttachment" id="LogAttachment" value="1" <cfif #Get.LogAttachment# eq "1">checked</cfif>> Enabled (recommended)
			<INPUT type="radio" name="LogAttachment" id="logAttachment" value="0" <cfif #Get.LogAttachment# eq "0">checked</cfif>> Disabled
			</cfoutput>
	    </TD>
		</TR>
		
		 <!--- Field: DateFormat --->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Presentation date Format:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<cfif #DateFormat# is 'EU'>
			<INPUT type="radio" name="DateFormat" id="DateFormat" value="EU" checked> European (dd/mm/yy)
			<INPUT type="radio" name="DateFormat" id="DateFormat" value="US"> American (mm/dd/yy) 
			<cfelse>
			<INPUT type="radio" name="DateFormat" ID="DateFormat" value="EU"> European (dd/mm/yy)
			<INPUT type="radio" name="DateFormat" id="DateFormat" value="US" checked> American (mm/dd/yy) 
			</cfif>
			</cfoutput>
	    </TD>
		</TR>
		
		 <!--- Field: Language --->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Initial Language:</td>
	    <TD>
			<select name="Language" id="Language" class="regularxl">
			<cfoutput>
			<cfloop query="Language">
			  <option value="#Code#" <cfif #Get.LanguageCode# eq "#Code#">selected</cfif>>#Code#</option>
			</cfloop>
			</cfoutput>
			</select>
		</td>
		</tr>
		
		<tr><td height="10"></td></tr>
		
	    <TR>
	    <td colspan="2" style="font-size:25px" class="labellarge" width="170">SQL Server</b></td>
		</tr>
			
		<TR>
	    <td class="labellarge" style="padding-left:10" width="190"><cf_UIToolTip tooltip="db.System and db.Organization">Configuration and Authorization:</cf_UIToolTip></td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="AuthorizationServer" value="#AuthorizationServer#" required="Yes" size="20" maxlength="30">
			</cfoutput>
	    </TD>
		</TR>
				
		<TR>
	    <td class="labellarge" style="padding-left:10">Transactional Server:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" tooltip="<b> Release 7</b> :Server name must be the same as for the Authorization server" name="DataBaseServer" value="#DataBaseServer#" required="Yes" size="20" maxlength="30">
			</cfoutput>
	    </TD>
		</TR>
		
		<TR>
	    <td class="labellarge" style="padding-left:40">Server Usage/Upgrade License:</td>
	    <TD>
			<table cellspacing="0" cellpadding="0">
			<tr>
	  	    <cfoutput query="get">			
				<td>
					<cfinput class="regularxl" type="Text" tooltip="Database server license</b> Contact : info@promisan.com to acquire one" name="DatabaseServerLicenseId" value="#DatabaseServerLicenseId#" required="Yes" size="58" maxlength="60">				
				</td>
				<td style="padding-left:6px">
					<cf_licensecheck mode="server">
					<cfinclude template="ShowLicenseExpiration.cfm">		
				</td>			
			</cfoutput>
			</tr>
			</table>
	    </TD>
		</TR>
		
		<TR>
	    <td class="labellarge" style="padding-left:40">Server Timezone (GMT +/-):</td>
		
		 <td>
		  <cfoutput query="get">
			   <cfinput class="regularxl"
			        type="Text" 
					name="DataBaseServerTimeZone" 
					range="-12,12" 
					value="#DataBaseServerTimeZone#" 
					validate="range" 
					required="Yes" 
					style="text-align:center;width:40">
		  </cfoutput> 
		</td>
		</tr>
				
		<TR>
	    <td class="labellarge" style="padding-left:10">Default OLAP database:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regularxl" tooltip="Database name must be located on the Transaction server" type="Text" name="DataBaseAnalysis" value="#DataBaseAnalysis#" required="Yes" size="30" maxlength="30">
			</cfoutput>
	    </TD>
		</TR>
		
		 <!--- Field: DateFormat --->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Server date format:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfif #DateFormatSQL# is 'EU'>
			<INPUT type="radio" name="DateFormatSQL" id="DateFormatSQL" value="EU" checked> European (dd/mm/yy)
			<INPUT type="radio" name="DateFormatSQL" id="DateFormatSQL" value="US"> American (mm/dd/yy) 
			<cfelse>
			<INPUT type="radio" name="DateFormatSQL" ID="DateFormatSQL" value="EU"> European (dd/mm/yy)
			<INPUT type="radio" name="DateFormatSQL" ID="DateFormatSQL" value="US" checked> American (mm/dd/yy) 
			</cfif>
			</cfoutput>
	    </TD>
		</TR>	
		
		<TR>
	    <td class="labellarge" style="padding-left:10">SQL Collate (searches):</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SQLCollate" value="#SQLCollate#" required="No" size="50" maxlength="50">
			</cfoutput>
	    </TD>
		</TR>
		
		<tr><td height="10"></td></tr>
		
		<TR>
	    <td colspan="2" style="font-size:25px" class="labellarge">Mail Server </b><font face="Calibri" size="2">MS Exchange 2013 / 2016 or 2019</b></td>
		</tr>
				
		<TR>
	    <td class="labellarge" style="padding-left:10" width="170">IP/Name:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ExchangeServer" value="#ExchangeServer#" size="50" maxlength="50">
			</cfoutput>
	    </TD>
		</TR>
		
		
		 <!--- Field: ReplyTo--->
	    <TR>
	    <td class="labellarge" style="padding-left:10">SMTP sending mode:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<INPUT type="radio" name="MailSendMode" id="MailSendMode" value="1" <cfif Get.MailSendMode eq "1">checked</cfif>> Comma separated
			<INPUT type="radio" name="MailSendMode" id="MailSendMode" value="0" <cfif Get.MailSendMode eq "0">checked</cfif>> One by one
			</cfoutput>
	    </TD>
		</TR>	
		
		 <!--- Field: ReplyTo--->
	    <TR>
	    <td class="labellarge" style="padding-left:10">Mail Content mode:</td>
	    <TD class="labellarge">
	  	    <cfoutput query="get">
			<INPUT type="radio" name="MailOutputMode" id="MailOutputMode" value="HTML" <cfif Get.MailOutputMode eq "HTML">checked</cfif>> HTML
			<INPUT type="radio" disabled name="MailOutputMode" id="MailOutputMode" value="LotusNotes" <cfif Get.MailOutputMode eq "LotusNotes">checked</cfif>> Lotus Notes
			</cfoutput>
	    </TD>
		</TR>				
		
		<tr><td height="10"></td></tr>
		
		<TR class="line">
		    <td colspan="2" style="width:100%" id="idLDAP">
				<cfinclude template="ParameterSystemEditLDAP.cfm">
			</td>
		</tr>
				
		<tr><td colspan="2" height="25">
	
			<input type="submit" name="Update" id="Update" value=" Apply " class="button10g">	
	
		</td></tr>
			
</table>