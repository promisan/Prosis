

<cfoutput>

		<table width="91%" border="0" cellspacing="0" align="center" id="tab0" class="formpadding">
						
			<tr><td height="5"></td></tr> 
			
			<cfif Access.recordcount neq "0">
			
								
				<tr><td colspan="2" class="labelmedium">Authorization to process a workflow step is in principle granted through user roles. 
				Role access is applied once the defined criteria of the access is matched with the workflow object. 
				</td></tr>
				<tr><td height="4"></td></tr> 
				<tr><td colspan="2" class="labelit">Note that an <b>administrator</b> [role:SUPPORT) and the <b>owner</b> of the workflow (the user that created the workflow object may grant access for a workflow object to any user for any step through the function
				[GRANT ACCESS] which is located in the banner of the workflow object menu (needs to be enabled). Also users with the support role [TREEROLEMANAGER] for the mission/entity as assigned to the workflow object will have have access to this function.				
				</td></tr>	
				<tr><td height="4"></td></tr> 			
				<tr><td colspan="2" class="labelit">Below are several settings that control how regular users can be involved in the process of granting access</font>				
				</td></tr>
							
				<tr><td height="4"></td></tr> 
			
			    <tr><td colspan="2" ><b>Settings for granting access ON-THE-FLY</b></font></td></tr>
				
				<tr><td colspan="2" class="labelmedium">
				A workflow administrator may define various settings that will allow defined workflow processor to grant access to users for that specific workflow object only.
				</td></tr>							
								
				<TR>
			    <TD width="34%" style="padding-left:10px" class="labelmedium">
					<a href="##"
					  title="Allow users that have access to the selected step to delegate/grant access to this step : [#get.ActionDescription#]">
					  Step may be granted FLY access to FROM step:</a></b>
				</TD>
				 <TD style="padding-left:1px">
				  
					<select name="ActionAccess" id="ActionAccess" class="regularxxl" style="width: 100%;" onchange="toggleall('ugselect',this.value)">
					    <option value="" selected></option>
						<cfloop query="Access">
						       <option value="#Access.ActionCode#" <cfif Access.ActionCode eq Get.ActionAccess>selected</cfif>>#Access.ActionCode# #Access.ActionDescription#</option>
						</cfloop>
					</select>
					
				</tr>
				
				<cfif Get.ActionAccess eq "">
					 <cfset cl = "hide">					 
				<cfelse>
					<cfset cl = "regular">	 
				</cfif>
					
				<tr name="ugselect" id="ugselect" class="#cl#">
					<td class="labelmedium" style="padding-left:20px"><a href="##" title="Limit access granting to a member of a specific user group">Limit <u>Processor</u> to members of usergroup:</td>		
					<td style="padding-left:5px">
					
					<cfquery name="Group" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Usernames
						WHERE  AccountType = 'Group'	
						AND    AccountMission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
						ORDER BY AccountMission				
					</cfquery>
					
					
					<cf_uiselect name="ActionAccessUserGroup" id="ActionAccessUserGroup" class="regularxl"
						 style="width: 100%;" 
						    group          = "AccountMission"
							query          = "#Group#"
							queryPosition  = "below"
							filter         = "contains"
							value          = "Account"
							display        = "Account"
							selected       = "#Get.ActionAccessUserGroup#">		
								    
					    <option value="" class="regularxl" selected>[all users]</option>
						
					</cf_uiselect>
					
					</td>
										
				</tr>
				
				<tr name="ugselect" id="ugselect" class="#cl#">
					<td class="labelmedium" style="padding-left:20px"><a href="##" title="Limit access granting to a member of a specific user group">Limit <u>Collaborator</u> to members of usergroup:</td>		
					<td style="padding-left:5px">
					
					<cfquery name="Group" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    Usernames
					WHERE   AccountType = 'Group'	
					AND    AccountMission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
					ORDER BY AccountMission				
					</cfquery>
					
					<cf_uiselect name="ActionAccessUGCollaborate" id="ActionAccessUGCollaborate" class="regularxl"
						 style="width: 100%;" 
						    group          = "AccountMission"
							query          = "#Group#"
							queryPosition  = "below"
							filter         = "contains"
							value          = "Account"
							display        = "Account"
							selected       = "#Get.ActionAccessUGCollaborate#">						 						 
					    <option value="DISABLED" selected>n/a</option>
					    <option>[all users]</option>						
					</cf_uiselect>
					
					</td>
										
				</tr>
									
			</cfif>
			
			<tr><td height="2"></td></tr> 
			
			<cfif Entity.PersonClass neq "">
			
				<tr><td colspan="2" class="labelmedium">
				Some workflows like leave and claims are for a specific person/user. This user is reflected in the field [OrganizationObject.PersonNo]. 				
				</td></tr>		
								
				<tr>
				   <td style="padding-left:10px" class="labelmedium">Allow&nbsp;the&nbsp;person/user&nbsp;<cfoutput>[#Entity.PersonReference#]</cfoutput>&nbsp;to&nbsp;perform&nbsp;step:</td>
				   <TD>			
				   
				   <select name="PersonAccess" id="PersonAccess" class="regularxl" style="width:100%">
				   <option value="0" <cfif Get.PersonAccess eq "0">selected</cfif>><cf_tl id="No"></option>
				   <option value="1" <cfif Get.PersonAccess eq "1">selected</cfif>><cf_tl id="Yes"></option>
				   <option value="2" <cfif Get.PersonAccess eq "2">selected</cfif>><cf_tl id="Yes, if person has other qualifying access"></option>
				   </select>
				 												   
				   </td>
				</tr>
				

			
			</cfif>
						
			<cfif URL.PublishNo eq "">
				
					<cfquery name="GetAccess" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_EntityClassAction
						WHERE  ActionAccess  = '#URL.ActionCode#'
						AND    EntityClass   = '#URL.EntityClass#'
						AND    EntityCode    = '#URL.EntityCode#' 
					</cfquery>
					
			<cfelse>
				
					<cfquery name="GetAccess" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_EntityActionPublish A
						WHERE  A.ActionAccess    = '#URL.ActionCode#'
						AND    A.ActionPublishNo = '#URL.PublishNo#'	
					</cfquery>
				
			</cfif>	
			
			<cfif GetAccess.recordcount gte "1">
			
				<tr><td colspan="2" height="1" class="linedotted"></td></tr>
				<tr><td class="labelmedium"><cf_UIToolTip tooltip="Actions that have been defined as [Delegate From] for this step">From this step authorised users may grant Access to:</cf_UIToolTip></td>
				<td><table>
				    <tr><td width="240">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding:3px;border:0px dotted silver" class="formpadding">
					<cfloop query="GetAccess">
						<tr class="labelmedium">
						<td>
							<cfif URL.PublishNo neq "">
							   	<font color="2894FF">						
							  <a href="javascript:parent.addtab('#ActionCode#','#ActionPublishNo#')" title="Edit Step Configuration">
							</cfif>					
							#currentrow#. #ActionDescription#
							</a>
						</td>
						</tr>			
					</cfloop>
					</table>
					</td>
					<TD class="labelmedium" style="cursor:pointer">
					   <cf_UIToolTip tooltip="Allow to grant access in conjunction with any other steps which have the delegating step defined"><font color="0080C0">All steps:</cf_UIToolTip>
					</TD>
				    <TD style="padding-left:4px"><INPUT type="checkbox" class="radiol" name="ActionAccessPointer" id="ActionAccessPointer" value="1" <cfif Get.ActionAccessPointer eq "1">checked</cfif>></td>	
					</tr>
					</table>
				</td>	
				</tr>	
					
			</cfif>
			
			<tr><td colspan="2" height="1" class="linedotted"></td></tr>			
			
			<tr><td height="10"></td></tr>
			<tr>
			   <TD colspan="2" width="34%" class="labelmedium">
			   Under the <b>global</b> settings for this object you may define if a workflow owner will inherit processor access to all the workflow steps <b>[Grant access to all steps for owner]</b></td>
			</tr>
			
			<tr>				
		   	 <TD style="padding-left:10px" style="cursor:pointer" class="labelmedium"><cf_UIToolTip tooltip="This setting overrules the global setting for this specific step">Disable for Inheritance to Owner for this step:</cf_UIToolTip></TD>
			 <TD>
			   <INPUT type="checkbox" class="radiol" name="disableOwner" id="disableOwner" value="1" <cfif Get.disableOwner eq "1">checked</cfif>>
			 </td>			
			</tr>
			
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" height="1" class="linedotted"></td></tr>			
			
			<tr>
			   <TD colspan="2" width="34%" class="labelmedium">
			   Special pointer to enforce access on the parent document if this step is active and the user has access. Needs to be used using API <b>wfActive</b> for the application</b></td>
			</tr>
			
			<tr>				
		   	 <TD width="50%" style="padding-left:10px" style="cursor:pointer" class="labelmedium">Enable Edit access on the parent document:</TD>
			 <TD>
			   <INPUT type="checkbox" class="radiol" name="EntityAccessPointer" id="EntityAccessPointer" value="1" <cfif Get.EntityAccessPointer eq "1">checked</cfif>>
			 </td>			
			</tr>
			
			<tr><td height="1" class="line" colspan="2"></td></tr>
			
			<tr><td align="center" colspan="2">
			
					<cfif URL.PublishNo eq "">
					<input class="button10g" style="width:130;height:25" type="button" name="Delete" id="Delete" value="Remove" onClick="removeaction()">
					</cfif>
				
					<input class="button10g"  style="width:130;height:25" type="button" name="Update" id="Update" value="Apply" onClick="savequick()">
					<cfparam name="url.action" default="flow">
				
			</td></tr>	
			
			</table>
	
</cfoutput>		
	