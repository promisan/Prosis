<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="URL.ID1"    default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="url.mycl"   default="0">
<cfparam name="url.wf"     default="0">
<cfparam name="url.action" default="0">

<cf_ActionListingScript>

<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonAction
	WHERE  PersonNo       = '#URL.ID#' 
	AND    PersonActionId = '#URL.ID1#'
</cfquery>

<cfif get.recordcount eq "0">
	
	<cfif url.mycl eq "1">
		
		<cfquery name="clear" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM        OrganizationObject
			WHERE       ObjectKeyValue4 = '#URL.ID1#'
		</cfquery>
		
	<cfabort>
	
	</cfif>

</cfif>

<!--- check for active workflow --->  
<cf_wfActive entitycode="HRAction" objectkeyvalue4="#url.id1#">	
  		
<cfif get.actionStatus eq "1" <!--- action is cleared, can not change anymore --->
	    or url.action eq "1" <!--- if opened from PA module, do not allow editing --->
		or url.mycl eq "1"> <!--- if opened from Myclearances, do not allow editing --->
	
	  <cfset mode = "view">	
		   
<cfelse>
	
	  <cfset mode = "edit">	 
		  
</cfif>  

<cfquery name="Mission" 
datasource="AppsEmployee"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
</cfquery>

<cfquery name="Action" 
datasource="AppsEmployee"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Action
	WHERE ActionSource = 'Payroll'
	AND Operational = '1'
	
</cfquery>

<cfquery name="EntityClass" 
datasource="AppsOrganization"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_EntityClass
	WHERE EntityCode = 'HRAction'
</cfquery>

<cfform method="POST" name="actionform">

<cfparam name="url.header" default="0">

<cfif url.header eq "1">
	<cfinclude template="../PersonViewHeader.cfm">
</cfif>

<table><td height="1"></td></table>

<cfoutput>

<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonAction
	WHERE  PersonNo       = '#url.id#'
	AND    PersonActionId = '#url.id1#'
</cfquery>

<cfif get.recordcount eq "0">

	<cf_assignid>

	<input type="hidden" name="PersonNo"       value="#URL.ID#">
	<input type="hidden" name="PersonActionId" value="#rowguid#">
	<cfset AttachmentId = RowGuid>

<cfelse>

	<input type="hidden" name="PersonNo"       value="#URL.ID#">
	<input type="hidden" name="PersonActionId" value="#URL.ID1#">
	<cfset AttachmentId = URL.ID1>

</cfif>

</cfoutput>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  <tr><td height="100%">

	<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	  <cfoutput>
	  	
	  <tr>
	    <td width="100%" height="22" colspan="2" align="left" valign="middle" style="font-size:25" class="labellarge">
		    <cf_tl id="Payroll Action"> (#get.ActionStatus#)</b>
	     </td>
	  </tr> 	
	    
	  <tr class="labelmedium">
			<TD height="21" width="20%"><cf_tl id="Action">:</TD>
						
				<cfquery name="pAction" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_Action
					WHERE  ActionCode    = '#get.ActionCode#' 								
				</cfquery>
									
				<cfif mode eq "view">
				
					<cfquery name="getAction" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   EmployeeAction
							WHERE  ActionPersonNo   = '#get.PersonNo#'
							AND    ActionSourceId   = '#get.PersonActionId#' 								
						</cfquery>
				
					  <TD width="80%" class="labelmedium">#pAction.Description#				 
					  <cfif getAction.ActionDate neq "">
					   : #dateformat(getAction.ActionDate,CLIENT.DateFormatShow)#
					  </cfif>
					  </td>
					  
				</cfif>	 
							
				<cfif mode eq "edit"> 
								
					<td width="70%">
					
					    <cfif url.wf eq "9999999">
											
							<cfquery name="ActionSel" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM  Ref_Action
								WHERE ActionSource = 'Payroll'		
								AND Operational = 1		
								ORDER BY ListingOrder				
							</cfquery>
																								
							<select name="ActionCode" class="regularxl">					    
								<cfloop query="ActionSel">
									<option value="#ActionCode#" <cfif get.ActionCode eq ActionCode>selected</cfif>>#Description#</option>
								</cfloop>		
							</select>										
					
						<cfelseif mode eq "edit" and get.ActionCode neq "">							
													
							<cfquery name="pAction" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
								    FROM  Ref_Action
									WHERE ActionSource = 'Payroll'	
									 AND  ActionCode  = '#get.ActionCode#'											 
							</cfquery>
																		
							#pAction.Description#
							
							<cfquery name="getAction" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM   EmployeeAction
								WHERE  ActionPersonNo   = '#get.PersonNo#'
								AND    ActionSourceId   = '#get.PersonActionId#' 								
							</cfquery>
							
							<cfif getAction.ActionDate neq "">
							  : #dateformat(getAction.ActionDate,CLIENT.DateFormatShow)#
							  </cfif>
													
							<input type="hidden" name="actioncode" value="#pAction.actionCode#">
						
						<cfelse>
														
							<cfquery name="pAction" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT   *
							    FROM     Ref_Action
								WHERE    ActionSource = 'Payroll'	
								AND Operational = 1									
								ORDER BY ListingOrder		
							</cfquery>	
																			
							<select name="actioncode" class="regularxl">
							    <!--- <option value="">-- select action --</option> --->
								<cfloop query="pAction">
									<option value="#ActionCode#" <cfif get.ActionCode eq ActionCode>selected</cfif>>#Description#</option>
								</cfloop>		
							</select>								
											
						</cfif>
					
					</td>	
									  
				</cfif>  
					
			</tr>
			
			<tr>
			<TD height="21" width="20%" class="labelmedium"><cf_tl id="Entity">:</TD>
							
			<cfquery name="Mission" 
			datasource="AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_ParameterMission			
			</cfquery>
			
			<td class="labelmedium">
			
			 <cfif mode eq "edit">		 
			 	
				
				   <cfif get.Mission neq "">
				   
				     <cfset mis = get.Mission>
					 
				   <cfelse>
				   
				   	 <cfquery name="OnBoard" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   TOP 1 P.*
						 FROM     PersonAssignment PA, Position P
						 WHERE    PersonNo             = '#url.id#'
						 AND      PA.PositionNo        = P.PositionNo					 
						 AND      PA.AssignmentStatus IN ('0','1')
						 AND      PA.AssignmentClass   = 'Regular'
						 AND      PA.AssignmentType    = 'Actual'
						 AND      PA.Incumbency        = '100'  
						 ORDER BY PA.DateEffective DESC
					</cfquery>
					
					<cfset mis = Onboard.Mission>	 
				  
				   </cfif>
				   
				   <select name="Mission" class="regularxl">
								
						 <cfinvoke component="Service.Access" 
					     method="contract"
						 personno="#URL.ID#"			
						 returnvariable="access">
	
						<cfloop query="Mission">
						
							 <cfif access eq "EDIT" or access eq "ALL">					
			 					      <option value="#Mission#" <cfif mission eq mis>selected</cfif> >#Mission#</option>
							 </cfif>
						 	  
						</cfloop>					
				  </select>
			 
			 <cfelse>
			 
			 	#get.Mission#
				
			 </cfif>	
			
			</td>
			</tr>
			
			<tr>
			<TD class="labelmedium" height="21" width="20%"><cf_tl id="Effective Period">:</TD>
			
			<td class="labelmedium">
			
			 <cfif mode eq "edit">
			 
			 	<table cellspacing="0" cellpadding="0">
				<tr><td style="padding-right:8px">
		
				  <cf_intelliCalendarDate9
					FieldName="DateEffective" 
					allowblank="false"
					class="regularxl"
					Default="#Dateformat(get.DateEffective, CLIENT.DateFormatShow)#">	
				
				</td>
				
				<td>-</td>
				
				<td style="padding-left:8px">
				
				 <cf_intelliCalendarDate9
					FieldName="DateExpiration" 
					allowblank="true"
					class="regularxl"
					Default="#Dateformat(get.DateExpiration, CLIENT.DateFormatShow)#">	
				
				</td></tr>
				</table>
			
			<cfelse>
			
				#Dateformat(get.DateEffective, CLIENT.DateFormatShow)# - <cfif get.DateExpiration eq "">end of contract<cfelse>#Dateformat(get.DateExpiration, CLIENT.DateFormatShow)#</cfif>
			
			</cfif>
			
			</td>
			</tr>
					
			<tr>
			<TD height="21" width="20%" class="labelmedium"><cf_tl id="Workflow Class">:</TD>
			
			<td class="labelmedium">
					
			<cfif mode eq "edit" and get.ActionCode eq "">
									
					<cfquery name="EntityClassList" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Ref_EntityClass C
						WHERE    EntityCode = 'HRAction'		 
					</cfquery>
					
					<select name="EntityClass" class="regularxl">
						<option value="">No Workflow</option>
						<cfloop query="EntityClassList">
							<option value="#EntityClass#" <cfif entityclass eq get.entityclass>selected</cfif> >#EntityClassName#</option>
						</cfloop>					
					</select>
					
			<cfelseif mode eq "edit" and get.ActionCode neq "">		
			
				<cfquery name="getClass" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Ref_EntityClass C
						WHERE    EntityCode = 'HRAction'		 
						AND      EntityClass = '#get.EntityClass#'
					</cfquery>
					
					#getClass.EntityClassName#
			
					<input type="hidden" name="entityclass" value="#getClass.entityclass#">
									
			<cfelse>
				
					<cfquery name="getClass" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Ref_EntityClass C
						WHERE    EntityCode = 'HRAction'	
						AND      EntityClass = '#get.EntityClass#'	 
					</cfquery>
					
					<cfif getClass.recordcount eq "0">
					
						<font color="FF0000">no workflow</font>
					
					<cfelse>
								
						#getClass.EntityClassName#			
						
					</cfif>	
				
			 </cfif>
			
			</td>
			</tr>		
			
			<tr>
				<TD class="labelmedium" height="21" width="20%"><cf_tl id="Remarks">:</TD>
				<td>
				
				<cfif mode eq "Edit">
				
				 <input type="text" 
				     name="Remarks" 
					 value="#get.Remarks#" 				
					 size="60"
					 style="height:27px"
					 class="regularxl" 
					 maxlength="100">
					 
				<cfelse>
				
				    <input type="text" 
				     name="Remarks" 
					 value="#get.Remarks#" 
					 onchange="ptoken.navigate('../../../Staffing/Application/Employee/HRAction/HRActionUpdate.cfm?PersonActionId=#URL.ID1#','process','','','POST','actionform')"
					 size="60"
					 style="height:27px"
					 class="regularxl" 
					 maxlength="100">
					 
				</cfif>	 
				
			</tr>
			
			
			<cf_filelibraryscript>
	
			<tr>
				<td class="labelmedium"><cf_tl id="Attachment">:</td>
				<td><cfdiv bind="url:../../../Staffing/Application/Employee/HRAction/HRActionAttachment.cfm?id=#get.PersonNo#&ActionId=#AttachmentId#" id="att"></td>			
			</tr>
					   			
			
			<tr><td id="process"></td></tr>
					
			<tr><td height="1" colspan="2" class="line"></td></tr>
				
			<tr><td height="35" colspan="2" align="center" style="padding:1px">
			
			     <table class="formspacing">
				 <tr>
				 <td>
	
			     <input type="button" 
				        name="back" 
						value="Back" 
						class="button10g" 
				        onClick="ptoken.navigate('#SESSION.root#/staffing/application/employee/HRAction/HRAction.cfm?id=#url.id#&status=valid','contentbox1')">
						
				 </td>				
				
				 <cfif wfexist eq "0" or getAdministrator("*")>
				 
					 <cfif get.Recordcount eq "1">
					 	
						 <cfinvoke component="Service.Access" 
					     method="contract"
						 personno="#URL.ID#"			
						 returnvariable="access">
	
						 <cfif mode eq "edit" or getAdministrator("*") eq "1" or ACCESS eq "ALL" or ACCESS eq "EDIT">
						    <td>
						 	<input class="button10g" type="button" name="Delete" value="Delete" onclick="ptoken.navigate('#SESSION.root#/staffing/application/employee/HRAction/HRActionEditSubmit.cfm?action=delete&wf=#url.wf#','contentbox1','','','POST','actionform')">
							</td>
						 </cfif>
						 
					 </cfif>
					 
					 <cfif mode eq "edit">
					 	<td>					
					    <input class="button10g" type="button" name="Submit" value="Save" onclick="ptoken.navigate('#SESSION.root#/staffing/application/employee/HRAction/HRActionEditSubmit.cfm?action=edit&wf=#url.wf#','contentbox1','','','POST','actionform')">
						</td>
					 </cfif>
				 
				 </cfif>
				 
				 </tr></table>
			   
			   </td>
		   </tr>	   


		   <cfif get.actionStatus eq "0" or wfStatus eq "Open" or url.action eq "1">	
		   
		   <tr><td height="1" colspan="2" class="line"></td></tr>	
						  
	  	    <!--- show workflow --->
			   	
			<tr>
			<td colspan="2">
			
				<cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Person
					WHERE  PersonNo = '#get.PersonNo#' 
				</cfquery>
							
				<cfoutput>	
												
					<input type="hidden" 
						   name="workflowlink_#get.personactionid#" 
						   id="workflowlink_#get.personactionid#" 				   
						   value="../../../staffing/application/employee/HRAction/HRActionWorkflow.cfm">	
						
					<tr id="box_#get.PersonActionId#">
					
						<td colspan="14" id="#get.PersonActionId#">
						
						   <cfset url.ajaxid = get.PersonActionId>
						   <cfinclude template="HRActionWorkflow.cfm">
						
						</td>
					
					</tr>	
										
				</cfoutput>							
					
			 </td>
			</tr>
			
		</cfif>		
	
	</TABLE>

</td></tr>
 
</table>

</cfoutput>

</CFFORM>

<cfset ajaxOnload("doCalendar")>
