
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM UserNames 
	WHERE Account = '#SESSION.acc#'
</cfquery>

<cfform method="POST" onsubmit="return false"
		name="formsetting">
 	
<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="8"></td></tr>
	
	<TR>
	    <TD height="26" class="labelmedium">
		
		<cfset link="UserEditDelegate.cfm?">
		
						<cf_selectlookup
						    box          = "sAccountDelegation"
						    link         = "#link#"
							title        = "<font color='6688aa'>Delegate [my Clearances] to:</font>"
							button       = "No"
							iconheight   = "25"
							icon         = "finger.gif"
							close        = "Yes"
							class        = "user"
							des1         = "accountdelegate">	
						
		</TD>
	    <TD>
	    	<table width="100%">
					    		
	    		<tr>
	    			<td>
						<cfdiv id="sAccountDelegation" bind="url:UserEditDelegate.cfm">
					</td>
				</tr>
			</table>			
	    </TD>
	</TR>			
	
		
	<!---		 
    <TR>
    <TD>Automatic Mail: &nbsp;</TD>
    <TD>
		
		<cfoutput query="get">	
		<input type="radio" name="Pref_WorkflowMail" value="1" <cfif #Pref_WorkflowMail# eq "1">checked</cfif>>&nbsp;Enabled
		<input type="radio" name="Pref_WorkflowMail" value="0" <cfif #Pref_WorkflowMail# eq "0">checked</cfif>>&nbsp;Disabled
		</cfoutput> 
	</TD>
	</TR>
	--->
	
	<TR>
    <TD style="height:25" class="labelmedium">Sent Mail to:</TD>
    <TD>
	  <table cellspacing="0" cellpadding="0"><tr>
		
		<cfoutput query="get">	
		<td><input type="radio" class="radiol" name="Pref_WorkflowMailAccount" value="Primary" <cfif Pref_WorkflowMailAccount eq "Primary">checked</cfif>></td><td class="labelmedium" style="padding-left:7px">Primary</td>
		<td style="padding-left:7px"><input type="radio" class="radiol" name="Pref_WorkflowMailAccount" value="Secundary" <cfif Pref_WorkflowMailAccount eq "Secundary">checked</cfif>></td><td class="labelmedium" style="padding-left:7px">Secondary</td>
		<td style="padding-left:7px"><input type="radio" class="radiol" name="Pref_WorkflowMailAccount" value="Both" <cfif Pref_WorkflowMailAccount eq "Both">checked</cfif>></td><td class="labelmedium" style="padding-left:7px">Both</td>
		</cfoutput> 
		
		</td>
	    <TD class="labelmedium" style="padding-left:30px">Send SMS to Number : </TD>
	    <TD>
			 <cfoutput query="get">
				 <input class="regularxl" type="text" name="Pref_SMS" value="#Pref_SMS#" size="10" maxlength="10">
			 </cfoutput>
		</TD>
		</TR>
		
		</table>
	</TD>
	</TR>
	
	 <!--- Field: Ref_PageRecords--->
    <TR>
    <TD style="height:25" width="170" class="labelmedium">Send mail as BCC: &nbsp;</TD>
    <TD>
	   <table cellspacing="0" cellpadding="0">
	   <tr>
		<cfoutput query="get">	
		<td><input type="radio" class="radiol" name="Pref_BCC" value="1" <cfif Pref_BCC eq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:7px">Enabled</td>
		<td style="padding-left:7px"><input type="radio" class="radiol" name="Pref_BCC" value="0" <cfif Pref_BCC eq "0">checked</cfif>></td><td class="labelmedium" style="padding-left:7px">Disabled</td>
		</cfoutput> 
	   </tr>	
	   </table>
	</TD>
	</TR>		
	
	<tr><td height="10"></td></tr>
	
	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *, S.Description as ModuleDescription
		FROM  Ref_Entity I, 
		      Ref_AuthorizationRole R, 
			  System.dbo.Ref_SystemModule S
		WHERE R.Role = I.Role
		AND   I.Operational = 1
		AND   S.Operational = 1
		AND   S.SystemModule = R.SystemModule
		<!--- AND   R.SystemModule != 'System' Remed out, otherwise System Error workflow would not appear --->
		
		<cfif getAdministrator("*") eq "0">
		
		
		AND   (
		        R.SystemModule IN (SELECT DISTINCT SystemModule 
				                   FROM   OrganizationAuthorization O, Ref_AuthorizationRole R1
								   WHERE  O.Role = R1.Role 
								   AND    UserAccount = '#SESSION.acc#')

			    OR
				
				I.EntityCode IN ( SELECT O.EntityCode
                                  FROM   OrganizationObject AS O INNER JOIN
				                         OrganizationObjectActionAccess AS OA ON O.ObjectId = OA.ObjectId
								  WHERE  UserAccount = '#SESSION.acc#'
								)  			
				
			  )		
       </cfif>			  			
					 
		ORDER BY MenuOrder, I.ListingOrder, I.EntityDescription
	</cfquery>
	
	<cfif get.recordcount neq "0">
	
	<tr>
	
	<td colspan="2" style="padding-left:10px">
	
	<table width="760" cellspacing="0" cellpadding="0">
		<tr>
		<td>
			<table width="350" cellspacing="0" cellpadding="0">
			<tr>
			<td style="padding: 0px;" width="6">&nbsp;&nbsp;</td>
			<td width="320" class="labelit">Document</td>
			<td align="right" style="cursor:pointer" class="labelit"><cf_space spaces="10"><cf_UItooltip tooltip="Enable mail Notification">Mail</cf_UItooltip></td>
			<td style="cursor:pointer;padding-left:2px" class="labelit"><cf_space spaces="10"><cf_UItooltip tooltip="Show action in MS-Exchange task List">Task</cf_UItooltip></td>
			</tr>
			</table>
		</td>
		<td>
		<table width="350" cellspacing="0" cellpadding="0">
			<tr>
			<td style="padding: 0px;" width="6">&nbsp;&nbsp;</td>
			<td width="320" class="labelit">Document</td>
			<td align="right" style="cursor:pointer" class="labelit"><cf_space spaces="10"><cf_UItooltip tooltip="Enable mail Notification">Mail</cf_UItooltip></td>
			<td style="cursor:pointer;padding-left:2px" class="labelit"><cf_space spaces="10"><cf_UItooltip tooltip="Show action in Exchange task List">Task</cf_UItooltip></td>
			</tr>
			</table>
		</td>	
		
		</tr>
		<tr><td colspan="2" class="linedotted" height="1"></td></tr>
	    
		<cfoutput query="Get" group="SystemModule">
		
			<tr><td colspan="2" style="height:35" valign="bottom" class="labelmediumcl">#ModuleDescription#</td></tr>
			
			<tr><td class="linedotted" colspan="2"></td></tr>
			
			<cfset i = 0>
			
				<cfoutput>
				
				<cfquery name="Check" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   UserEntitySetting
					WHERE  Account = '#SESSION.acc#'
					AND    EntityCode = '#entityCode#' 
				</cfquery>
			
				<cfif i eq "0"><tr></cfif>
				
					<cfset i = i+1>
					
					<td>
					
					 <cfset ent = replace(entityCode,"-","","ALL")> 
					
						<table width="350" cellspacing="0" cellpadding="0">
							<tr>							
							<td width="300" style="padding-left:10px" class="labelit">#EntityDescription# #EntityCode#</td>
							<td>					
							<input type="checkbox" onclick="task(this.checked,'task_#entitycode#')" name="mail_#ent#" value="1" <cfif Check.EnableMailNotification neq "0">checked</cfif>>
							</td>
							<td>					
							<input type="checkbox" name="task_#ent#" value="1" <cfif Check.EnableMailNotification eq "0">disabled<cfelseif Check.EnableExchangeTask eq "1">checked</cfif>>
							</td>
							</tr>
						</table>
					</td>
					
					<cfif i eq "2">
						<cfset i = 0></tr>
					</cfif>
			
			</cfoutput>
		
		</cfoutput>
		
	</table>
	</td></tr>
	
	</cfif>
		
	<tr><td height="3"></td></tr>
	<tr><td height="1" colspan="2" class="line"></td></tr>
	<tr><td height="3"></td></tr>
	
	<tr><td height="1" colspan="2">
	
	<cf_tl id="Save" var="vSave">
	
	<cfoutput>
	<input type="button" onclick="prefsubmit('workflow')" name="Save" id="Save" value="#vSave#" class="button10g">
	</cfoutput>
		
	</td></tr>
			
</table>

</cfform>	

<script>
	Prosis.busy('no');	
</script>
