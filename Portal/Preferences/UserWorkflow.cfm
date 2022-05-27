
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

<tr class="line"><td colspan="2" class="labellarge"><span style="font-size: 24px;margin: 10px 0 6px;display: block;color: #52565B;"><cf_tl id="Workflow settings"></span></td></tr>
	
	
	<tr><td height="8"></td></tr>
	
	<TR>
	    <TD height="26" class="labelmedium">
		
		<cfset link="UserEditDelegate.cfm?">
		
			<cf_selectlookup
			    box          = "sAccountDelegation"
			    link         = "#link#"
				title        = "Delegate [my Clearances]:"
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
    <TD style="height:25" class="labelmedium">Use Mail address:</TD>
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
	
	<table width="760">
		<tr class="line fixlengthlist">
		
		    <cfloop index="itm" from="1" to="2">
						
				<td style="padding-left:10px;min-width:280px">Document</td>
				<td align="right" style="cursor:pointer" title="Show in My Clearances">Clear</td>
				<td align="right" style="cursor:pointer" title="Enable mail Notification">Mail</td>
				<td style="cursor:pointer;padding-left:2px" title="Show action in MS-Exchange task List">Task</td>		
			
			</cfloop>
							
		</tr>
			    
		<cfoutput query="Get" group="SystemModule">
		
			<tr class="line fixlengthlist">
			<td colspan="8" style="height:35" class="labelmedium2">#ModuleDescription#</td>
			</tr>
						
			<cfset i = 0>
			
				<cfoutput>
				
				<cfif i eq "0">
				<tr class="fixlengthlist">
				</cfif>
				
				<cfquery name="Check" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   UserEntitySetting
					WHERE  Account = '#SESSION.acc#'
					AND    EntityCode = '#entityCode#' 
				</cfquery>
											
				<cfset i = i+1>
									
				 <cfset ent = replace(entityCode,"-","","ALL")> 
															
							<td style="padding-left:10px" class="labelit">#EntityDescription# #EntityCode#</td>
							<td align="center"><input type="checkbox" onclick="task(this.checked,'clear_#entitycode#')" name="clear_#ent#" value="1" <cfif Check.EnableMyClearances neq "0">checked</cfif>></td>
							<td align="center"><input type="checkbox" onclick="task(this.checked,'task_#entitycode#')" name="mail_#ent#" value="1" <cfif Check.EnableMailNotification neq "0">checked</cfif>></td>
							<td align="center"><input type="checkbox" name="task_#ent#" value="1" <cfif Check.EnableMailNotification eq "0">disabled<cfelseif Check.EnableExchangeTask eq "1">checked</cfif>></td>
											
				<cfif i eq "2">
					<cfset i = 0>
					</tr>
				</cfif>
			
			    </cfoutput>
						
		</cfoutput>
		
	</table>
	</td></tr>
	
	</cfif>
		
	<tr><td height="3"></td></tr>
	<tr><td height="1" colspan="8" class="line"></td></tr>
	<tr><td height="3"></td></tr>
	
	<tr><td height="1" colspan="8">
	
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
