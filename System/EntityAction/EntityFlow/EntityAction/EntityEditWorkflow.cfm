<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding" >
		
		<tr><td height="5"></td></tr>
		
		<tr class="line"><td colspan="2" style="font-size:28px;font-weight:200" class="labelmedium">Messaging</td></tr>
		
		<tr>			
		<td style="padding-left:10px" class="labelmedium" style="cursor:pointer"><cf_UIToolTip tooltip="Disable/Enable email notification. <br>This option overrules a similar setting per class (workflow instance)">E-Mail:</cf_UIToolTip></td>
		    
		<td class="labelmedium">
		    <input type="checkbox" name="EnableEMail" id="EnableEMail" value="1" <cfif "1" eq Entity.EnableEMail>checked</cfif>>&nbsp;Workflow eMail notification agent enabled
		  </td>
		</TR>	
			
		
		<tr>
		<td class="labelmedium" style="padding-left:10px" style="cursor:pointer"><cf_UIToolTip tooltip="Define a default FROM address for the mail">E-Mail FROM Name:</cf_UIToolTip></td>
		
		<td>
				   <cfinput type="Text"
			       name="MailFrom"
			       required="No"
			       visible="Yes"
				   value="#entity.MailFrom#"
			       enabled="Yes"
			       size="50"
				   tooltip="This represents the name that will be tied to the email e.g. John Doe"
			       maxlength="50"
			       class="regularxl"> 
		</td>	
		</tr>

		<TR>
		<td class="labelmedium" style="padding-left:10px" style="cursor:pointer"><cf_UIToolTip tooltip="Define a default e-Mail from address for the mail">E-Mail FROM Address:</cf_UIToolTip></td>
		
		<td>
				   <cfinput type="Text"
			       name="MailFromAddress"
			       required="No"
			       visible="Yes"
				   value="#entity.MailFromAddress#"
			       enabled="Yes"
			       size="50"
				   tooltip="This represents the email address that is tied to the email. e.g. jdoe@test.com"
			       maxlength="50"
			       class="regularxl"
				   validate="email"> 
		</td>	
		</TR>
		
		<!---
		<cfif entity.EntityKeyField4 neq "">
		--->
		
			<TR>
			<td class="labelmedium" style="padding-left:10px" style="cursor:pointer"><cf_UIToolTip tooltip="Set the link to object attachments">Object Attachment Logical Folder:</cf_UIToolTip></td>
			
			<td>		
					
			<cfquery name="Attachment" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM Ref_Attachment		
			</cfquery>
	
			<select name="DocumentPathName" class="regularxl">
			<option value="">N/A</option>
				<cfoutput query="attachment">
					<option value="#DocumentPathName#" <cfif entity.DocumentPathName eq DocumentPathName>selected</cfif>>/#DocumentPathName#/</option>
				</cfoutput>		
			</select>
			
			</td>	
			</TR>
		
		<!---		
		</cfif>
		--->
		
		
		<TR>
		<td class="labelmedium" style="padding-left:10px" style="cursor:pointer"><cf_UIToolTip tooltip="Disable/Enable email reminders.">REMINDER Mail:</cf_UIToolTip></td>
		<td class="labelmedium">
		    <input type="checkbox" class="radiol" name="EnableEMailReminder" id="EnableEMailReminder" value="1" <cfif "1" eq Entity.EnableEMailReminder>checked</cfif>>&nbsp;Workflow eMail reminder agent enabled
		  </td>
		</TR>	
		
		<tr>
		<td class="labelmedium" style="padding-left:10px" style="cursor:pointer"><cf_UIToolTip tooltip="Use this option only during development to test eMail distribution">Enforced Mail Recipient:</cf_UIToolTip></td>
		<td>
				   <cfinput type="Text"
				       name="MailRecipient"
				       message="You must enter a valid email address"
				       validate="email"
				       required="No"
				       visible="Yes"
					   tooltip="Enforce all Custom and Standard mail message to be sent to this account"
					   value="#entity.MailRecipient#"
				       enabled="Yes"
				       size="50"
				       maxlength="50"
				       class="regularxl"> 
		</td>	
		</tr>
		
		
		<tr>
		<td class="labelmedium" style="padding-left:10px">Default Mail attachment format: </td>	    
		<td class="labelmedium">	
			<input type="radio" class="radiol" name="DefaultFormat" id="DefaultFormat" value="HTML" <cfif "HTML" eq #Entity.DefaultFormat#>checked</cfif>>HTML	
			<input type="radio" class="radiol" name="DefaultFormat" id="DefaultFormat" value="FlashPaper" <cfif "FlashPaper" eq #Entity.DefaultFormat#>checked</cfif>>FlashPaper
			<input type="radio" class="radiol" name="DefaultFormat" id="DefaultFormat" value="PDF" <cfif "PDF" eq #Entity.DefaultFormat#>checked</cfif>>PDF
	    </td>
		</TR>	
		
		<tr><td height="8"></td></tr>
		
		<tr class="line"><td colspan="2" style="font-size:28px;font-weight:200" class="labelmedium">Workflow Features</td></tr>
				
		<tr>			
		<td style="padding-left:10px" class="labelmedium" style="cursor:pointer">Workflow is around a person:</td>			
		   <td height="19" class="labelmedium">		   
		   <cfif Entity.PersonReference eq "">No<cfelse><cfoutput><i>label:</i> #Entity.PersonReference#</cfoutput></cfif>		   
		  </td>
		</TR>
		
		<cfif Entity.PersonReference eq "">
		
			<input type="hidden" name="EnableSelfProcess" id="EnableSelfProcess" value="0">
		
		<cfelse>
		
		<tr>	
		<td style="padding-left:20px" style="cursor:pointer" class="labelmedium">
		<cf_UIToolTip tooltip="Allow users to process a workflow object which is assigned to a personNo which is the same as the personNo assigned to the user account">
		Disable self-processing of a workflow unless explicitly enabled for a step:
		</cf_UIToolTip>
		</td>	    
		   <td>
		    <input type="checkbox" class="radiol" name="EnableSelfProcess" id="EnableSelfProcess" value="0" <cfif Entity.EnableSelfProcess neq "1">checked</cfif>>					
		  </td>
		</TR>
		
		</cfif>
					
		<tr>			
		<td style="padding-top:3px;padding-left:10px;cursor:pointer" class="labelmedium" valign="top">
		<cf_UIToolTip tooltip="Show / Hide the menu bar on top of the workflow object">Show Workflow toolbar:</cf_UIToolTip>
		</td>	    
		
		   <td>
			    <table cellspacing="0" cellpadding="0">
				 <tr>
					 <td><input type="radio" class="radiol" name="EnableTopMenu" id="EnableTopMenu" value="0" <cfif "0" eq Entity.EnableTopMenu>checked</cfif>></td>
					 <td class="labelmedium" style="padding-left:4px">Always hide</td>
				 </tr>
				 <tr>	 
					 <td><input type="radio" class="radiol" name="EnableTopMenu" id="EnableTopMenu" value="1" <cfif "1" eq Entity.EnableTopMenu>checked</cfif>></td>	
					 <td class="labelmedium" style="padding-left:4px">Show only to Owner (and administrator)</td>
				 </tr>
				 <tr>	 
					 <td><input type="radio" class="radiol" name="EnableTopMenu" id="EnableTopMenu" value="3" <cfif "3" eq Entity.EnableTopMenu>checked</cfif>></td>
					 <td class="labelmedium" style="padding-left:4px">Always show (unless revoked on the workflow template Toolbar=No)</td>
				 </tr>
				</table>				
		  </td>
		</TR>
		
		<tr>	
		<td style="padding-left:20px" class="labelmedium" style="cursor:pointer">
		<cf_UIToolTip tooltip="Allow users to change the selected workflow for the object">
		Enable menu: <u>Change Workflow</u>:
		</cf_UIToolTip>
		</td>	    
		   <td>
		    <input type="checkbox" class="radiol" name="EnableClassSelect" id="EnableClassSelect" value="1" <cfif "1" eq Entity.EnableClassSelect>checked</cfif>>		
			
		  </td>
		</TR>
		
		<tr>	
		<td style="padding-left:20px" class="labelmedium" style="cursor:pointer" title="Allow change the selected authorization group for the workflow object">
		Enable menu: <u>Change Authorization Group</u>:		
		</td>	    
		   <td>
		    <input type="checkbox" class="radiol" name="EnableGroupSelect" id="EnableGroupSelect" value="1" <cfif "1" eq Entity.EnableGroupSelect>checked</cfif>>					
		  </td>
		</TR>
				
		<tr><td height="8"></td></tr>		
		<tr class="line"><td colspan="2" style="font-size:28px;font-weight:200" class="labelmedium">Advanced</td></tr>
	
		<tr>	
		<td class="labelmedium" style="padding-left:10px" style="cursor:pointer">Enable flow refresh upon any step activity recorded:</td>	
		   <td>
		    <table>
			<tr class="labelmedium">
			<td>
		    <input type="checkbox" class="radiol" name="EnableRefresh" id="EnableRefresh" value="1" <cfif "1" eq Entity.EnableRefresh>checked</cfif>>		
			</td>
			<td style="padding-left:5px;color:gray">if selected set refresh interval on the level of the Workflow Class</td>
			</tr>
			</table>
		  </td>
		</TR>	
		
		<tr>	
		<td class="labelmedium" style="padding-left:10px" style="cursor:pointer">
		<cf_UIToolTip tooltip="Upon creation of the workflow the first step is set as completed and all processing is done as if the user has finished this step">
		Auto complete first step upon Object creation:
		</td>	    
		</cf_UIToolTip>
		   <td>
		    <input type="checkbox" class="radiol" name="EnableFirstStep" id="EnableFirstStep" value="1" <cfif "1" eq Entity.EnableFirstStep>checked</cfif>>		
		  </td>
		</TR>
		
		<tr>	
		<td class="labelmedium" style="padding-left:10px" style="cursor:pointer">
		<cf_UIToolTip tooltip="Upon closing of the workflow allow the processor to reopen the last step">Reopen last step of the workflow:
		</td>	    
		</cf_UIToolTip>
		   <td>
		    <input type="checkbox" class="radiol" name="EnableReopen" id="EnableReopen" value="1" <cfif "1" eq Entity.EnableReopen>checked</cfif>>		
		  </td>
		</TR>
		
		<cfquery name="entityclass" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_EntityClass
			WHERE  EntityCode = '#URL.ID#'
			AND    Operational = 1
			ORDER BY ListingOrder		
		</cfquery>	
		
		<script>
		 function toggle(itm,val) {
		    
	    	 if ( val == true ) {
			   document.getElementById(itm).className='regular labelmedium'
			   } else {
			   document.getElementById(itm).className='hide'
			   }	 
		 }
		</script>
		
		<tr>	
		<td valign="top" class="labelmedium" style="padding-top:5px;cursor:pointer;padding-left:10px"><cf_UIToolTip tooltip="Assign access to all workflow steps to owner of the workflow (initiator)">Inherit access to all steps to owner:</cf_UIToolTip></td>
		   <td>
		   		
		   <table cellspacing="0" cellpadding="0">
		
		<cfoutput query="entityClass">
		
			<cfset cid = replaceNoCase(entityClass," ","","ALL")>
		
		    <tr style="height:10px">
			<td style="padding-right:10px">#entityclassName#:</td>
			<td>
		    <input type="checkbox" class="radiol" onclick="toggle('#cid#lvl',this.checked)" name="f#cid#EnableActionOwner" id="f#cid#EnableActionOwner" value="1" <cfif "1" eq EnableActionOwner>checked</cfif>>		
			</td>
			<cfif EnableActionOwner eq "0">
				<cfset cl = "hide">
			<cfelse>
				<cfset cl = "regular">	
			</cfif>
			<td id="#cid#lvl" class="#cl#">
			<table>
			<tr>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="f#cid#OwnerAccessLevel" id="f#cid#OwnerAccessLevel" value="1" <cfif "1" eq OwnerAccessLevel>checked</cfif>></td><td class="labelmedium">Process</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="f#cid#OwnerAccessLevel" id="f#cid#OwnerAccessLevel" value="0" <cfif "0" eq OwnerAccessLevel>checked</cfif>></td><td class="labelmedium">Collaborate</td>				
			</tr>
			</table>
			</td>		
			</tr>
		  
		
		</cfoutput>
		
		 </table>
		  </td>
		</TR>
		
		<tr>	
			<td class="labelmedium"  valign="top" style="padding-left:10px;padding-top:4px;cursor:pointer"><cf_UIToolTip tooltip="If a user received an action mail to perform a step, check this box to enforce log-on">Mail Notification Logon:</cf_UIToolTip></td>
			<td>
			<table cellspacing="0" cellpadding="0">
				<tr>
				<td class="labelmedium"><input type="checkbox" class="radiol" name="EnableEMailLogon" id="EnableEMailLogon" value="0" <cfif "0" eq Entity.EnableEMailLogon>checked</cfif>>&nbsp;Logon only if no user session is active</td>			
				</tr>
				<tr>
				<td class="labelmedium"><input type="checkbox" class="radiol" name="EnableEMailLogon" id="EnableEMailLogon" value="1" <cfif "1" eq Entity.EnableEMailLogon>checked</cfif>>&nbsp;Always Enforce logon</td>			
				</tr>
			</table></td>
		</TR>	
		
		<tr>
		<td class="labelmedium" style="cursor:pointer;padding-left:10px"><cf_UIToolTip tooltip="Define how many historical workflows should be presented">Show No of Archived Workflows:</cf_UIToolTip></td>
		
		<td>
				<cfinput type="Text"
			       name="ShowHistory"
			       message="You must enter a valid no"
			       validate="integer"
			       required="No"
			       visible="Yes"
				   tooltip="Define how many historical workflows should be presented"
				   value="#entity.ShowHistory#"
			       enabled="Yes"
			       size="1"
				   style="width:30;text-align:center"
			       maxlength="1"
			       class="regularxl"> 
				   
		</td>	
		</tr>				
				
		<TR>
		    <td class="labelmedium" style="padding-left:10px">Entity application templates:</td>
			<td class="labelmedium" ><input type="checkbox" class="radiol" onclick="toggledet(this.checked)" name="EnableCreate" id="EnableCreate" value="1" <cfif "1" eq Entity.EnableCreate>checked</cfif>>&nbsp;Enabled</td>
		</TR>	
						
		<TR>
	    	<td class="labelmedium" style="padding-left:19px">CREATE:</td>
			<td><cfinput type="Text" name="TemplateCreate" value="#Entity.TemplateCreate#" size="50" maxlength="50" class="regularxl"></td>
		</TR>			
		
		<TR>
		    <td class="labelmedium" style="padding-left:19px">SEARCH:</td>
			<td><cfinput type="Text" name="TemplateSearch" value="#Entity.TemplateSearch#" size="50" maxlength="50" class="regularxl"></td>
		</TR>	
		
		<TR>
	    	<td class="labelmedium" style="padding-left:19px">LISTING:</td>
			<td><cfinput type="Text" name="TemplateListing" value="#Entity.TemplateListing#" size="50" maxlength="50" class="regularxl"></td>		
		</TR>			
				
		<tr><td height="5"></td></tr>
		<tr><td height="1" class="linedotted" colspan="2"></td></tr>
		<tr><td height="5"></td></tr>
		
		<tr><td align="center" colspan="2" style="height:36px">
			<input type="button" style="width:160px;height:27px" name="save" id="save" value="Apply" class="button10g" onclick="validate()"> 
		</td></tr>	
		
</table>