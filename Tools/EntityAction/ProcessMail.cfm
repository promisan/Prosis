<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="counter" default="0">

<cfparam name="eMailType" default="STANDARD">

<cfquery name="Org" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Organization
	 WHERE    OrgUnit = '#Object.OrgUnit#'  
</cfquery>


   
<cfif object.MailRecipient neq "">
 
     <!--- ----------------------------------------------------------------------- --->
 	 <!--- overruling email to a global address during design and development only --->  
	 <!--- ----------------------------------------------------------------------- --->
 
     <cfset to = Object.MailRecipient>
	 
	 <cfset accesslevel = "1">
	 
	 <cfif eMailtype eq "AUTOREMIND">
		<cfset subjecttype = "REMINDER">
	 <cfelse>
	    <cfset subjecttype = "Notification">
	 </cfif>
	 	 
	 <cfinclude template="ProcessMailAction.cfm">
	 
	 	 
<cfelse>	    
  
 	<cfquery name="Potential" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
	 	 <!--- presetted access --->
		 
		 <cfif NextCheck.NotificationGlobal eq "1">
	 
			 SELECT   A.UserAccount, 
			          A.AccessLevel,  
			          U.eMailAddress, 
					  U.eMailAddressExternal, 
					  U.Pref_WorkFlowMailAccount,
					  U.MailServerAccount,
					  U.MailServerPassword
			 FROM     OrganizationAuthorization A INNER JOIN
					  System.dbo.UserNames U ON A.UserAccount = U.Account  
			 WHERE    A.ClassParameter = '#NextCheck.ActionCode#' 
			 AND      A.GroupParameter = '#Object.EntityGroup#' 
			 AND      A.AccessLevel IN ('0','1')  <!--- '0' = info --->	 
			 AND      U.Disabled = 0
			 
			 <cfif Object.OrgUnit eq "0" or Object.OrgUnit eq "">
			 
			 AND      (A.Mission = '#Object.Mission#' or A.Mission is NULL)
			 
			 <cfelse>
			 
			 AND     (     
			               (A.OrgUnit       = '#Object.OrgUnit#')
			            OR ((A.OrgUnit is NULL OR A.OrgUnit = '0') and A.Mission = '#Object.Mission#')
				        OR ((A.OrgUnit is NULL OR A.OrgUnit = '0') and A.Mission is NULL)
					 ) 				 
					 
			 </cfif>		 
					 						   
			 UNION		 
		
		 </cfif>
		 
		 <cfif NextCheck.NotificationFly eq "1">
		 
			 <!--- fly access --->
			 
			 SELECT   A.UserAccount, 
			          '1' as AccessLevel,
			          U.eMailAddress, 
					  U.eMailAddressExternal, 
					  U.Pref_WorkFlowMailAccount,
					  U.MailServerAccount,
					  U.MailServerPassword
			 FROM     OrganizationObjectActionAccess A INNER JOIN
					  System.dbo.UserNames U ON A.UserAccount = U.Account
			 WHERE    A.ObjectId      = '#ObjectId#' 
			 AND      U.Disabled = 0
			 AND      A.ActionCode    = '#NextCheck.ActionCode#' 
			 AND      A.AccessLevel   >= '0' 
			 	 
			 UNION 
		 
		 </cfif>
		 
		 <!--- if this action was performed by a specific 
		 user before in the same workflow, send the same person a mail --->
		 
		 SELECT   A.OfficerUserId as UserAccount, 
		          '1' as AccessLevel,
		          U.eMailAddress, 
				  U.eMailAddressExternal, 
				  U.Pref_WorkFlowMailAccount,
				  U.MailServerAccount,
				  U.MailServerPassword
	     FROM     OrganizationObjectAction A INNER JOIN
	              System.dbo.UserNames U ON A.OfficerUserId = U.Account
		 WHERE    A.ObjectId      = '#ObjectId#'
		 AND      U.Disabled = 0
		 AND      A.ActionCode    = '#NextCheck.ActionCode#' 	
											  
	</cfquery>		
				
	<cfloop query="Potential">	
	
	    <!--- ------------------------------------------- --->
		<!--- check if user wants to have an eMail at all --->
		<!--- ------------------------------------------- --->
		
		<!--- check if the actor already was sent an eMail today --->
		
		<cfquery name="CheckLast" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   TOP 1 *
			 FROM     OrganizationObjectMail
			 WHERE    ObjectId    = '#Object.Objectid#'
			 AND      Account     = '#UserAccount#'  
			 AND      ActionCode  = '#NextCheck.ActionCode#'
			 ORDER BY Created DESC
		</cfquery>
		
		<cfparam name="eMailType" default="STANDARD">
		
		<!--- remove this condition after battes finishes --->
		
		<cfif dateformat(checklast.created,CLIENT.DateFormatShow) eq dateformat(now(),CLIENT.DateFormatShow) and eMailtype eq "AUTOREMIND">
				
				<!--- an eMail was already sent today, no need to repeat this --->
		
		<cfelse>		
					
			<cfquery name="Notify" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     System.dbo.UserEntitySetting
				 WHERE    Account     = '#UserAccount#'  
				 AND      EntityCode  = '#Object.EntityCode#'
			</cfquery>
			
			<!--- if not record exist we assume the user wants a mail --->
			
			<cfif Notify.EnableMailNotification eq "1" or Notify.recordcount eq "0">
			
	 		    <cfset to = "">
	 	
				<cfswitch expression="#Pref_WorkFlowMailAccount#">
				
					<cfcase value="Primary">
					
						<cfif emailaddress neq "">
					
							<cfif to eq "">
							   <cfset to = "#emailAddress#">
							<cfelse>
							   <cfset to = "#to#, #emailAddress#">
							</cfif>  
						
						</cfif> 
					
					</cfcase>
					
					<cfcase value="Secundary">
					
						<cfif emailaddressexternal neq "">
					
							<cfif to eq "">
							   <cfset to = "#emailAddressExternal#">
							<cfelse>
							   <cfset to = "#to#, #emailAddressExternal#">
							</cfif>  							
							
						<cfelse>
						
							<!--- we fall back to the alternate --->
						
							<cfif to eq "">
							   <cfset to = "#emailAddress#">
							<cfelse>
							   <cfset to = "#to#, #emailAddress#">
							</cfif> 								
						
						</cfif> 
					
					</cfcase>
					
					<cfcase value="Both">
					
						<cfif emailaddress neq "">
					
							<cfif to eq "">
							   <cfset to = "#emailAddress#">
							<cfelse>
							   <cfset to = "#to#, #emailAddress#">
							</cfif>  
						
						</cfif> 
						
						<cfif emailaddressexternal neq "">
					
							<cfif to eq "">
							   <cfset to = "#emailAddressExternal#">
							<cfelse>
							   <cfset to = "#to#, #emailAddressExternal#">
							</cfif>  
						
						</cfif> 	
					
					</cfcase>
					
				</cfswitch> 
							
				<cfif to neq "">				
				
					<cfset counter = counter+1>
								
					<cf_assignid>
					
					<cfif eMailtype eq "AUTOREMIND">
						<cfset subjecttype = "REMINDER">
					<cfelse>
					    <cfset subjecttype = "Notification">
					</cfif>
																				
					<cfinclude template="ProcessMailAction.cfm">
										
					<cfparam name="eMailType" default="STANDARD">
				
					<cfquery name="RegisterMail" 
						datasource="AppsOrganization"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					
						INSERT INTO OrganizationObjectMail
							(ObjectMailId,
							 ObjectId, 
							 ActionCode, 
							 Account, 
							 eMailType,
							 eMailAddress, 
							 OfficerUserId, 
							 OfficerLastName,
							 OfficerFirstName)
						VALUES
							('#rowguid#',
							 '#Object.ObjectId#',
							 '#NextCheck.ActionCode#',
							 '#UserAccount#', 
							 '#emailtype#',
							 '#eMailAddress#', 
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#')
			 		</cfquery>	
					
					<cfquery name="System" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 	SELECT   *
						FROM     System.dbo.Parameter			
				    </cfquery>
					
													  
					<!--- -------------------------------------------- --->			  
				    <!--- check if user has a MS exchange 2016 mailbox --->
					<!--- -------------------------------------------- --->							
																									
				   <cfif MailServerAccount neq ""  
				         and Notify.EnableExchangeTask eq "1" 
						 and System.ExchangeServer neq "">
				   				   				   				  			   
					    	<cfoutput>
							
								<!--- define the task content --->
				   
						   		<cfsavecontent variable="taskmessage">
								
								  <table cellspacing="1" cellpadding="1">
								   <tr style="border-bottom:1px solid silver">
								      <td colspan="2" align="center" style="height:40px;color:white;padding-left:4px;width:530px;padding-right:4px;background-color:gray">#session.welcome# <cf_tl id="Action"></td>								      
								   </tr>
								   <tr style="border-bottom:1px solid silver"><td style="color:white;padding-left:4px;width:150px;padding-right:4px;background-color:1E90FF"><cf_tl id="Requested"></td>
								       <td style="padding-left:4px">#session.first# #session.last#</td>
								   </tr>								  
								   <tr style="border-bottom:1px solid silver"><td style="color:white;padding-left:4px;width:150px;padding-right:4px;background-color:1E90FF"><cf_tl id="Reference"></td>
								       <td style="padding-left:4px">#Object.ObjectReference2#</td>
								   </tr>
								    <tr style="border-bottom:1px solid silver"><td style="color:white;padding-left:4px;width:150px;padding-right:4px;background-color:1E90FF"><cf_tl id="Action"></td>
								       <td style="padding-left:4px">#NextCheck.ActionDescription#</td>
								   </tr>
								   <tr style="border-bottom:1px solid silver"><td style="color:white;padding-left:4px;width:150px;padding-right:4px;background-color:1E90FF"><cf_tl id="Link"></td>
								       <td style="padding-left:4px">
									   <a href="#SESSION.root#/ActionView.cfm?id=#Object.Objectid#&actioncode=#NextCheck.ActionCode#&target=#NextCheck.NotificationTarget#" style="color: ##1E90FF;"><cf_tl id="Click here to process action"></a>
									   </td>
								   </tr>
								   <tr style="border-bottom:1px solid silver">
								      <td colspan="2" align="right" style="border-top:1px solid silver;height:15px;font-size:11px;padding-right:4px;color:black;padding-right:4px">Prosis for Exchange (C) 2021</td>								      
								   </tr>
								  </table>					 		  
								 								
								</cfsavecontent>
							
								<cfscript>
									    stask=StructNew();		
									    stask.Subject          = "#NextCheck.ActionDescription# - #Object.ObjectReference#";
										stask.Message          = "#taskmessage#";
										stask.Priority         = "high"; 										
										sTask.Companies        = "#Object.Mission#";
										stask.StartDate        = "#timeformat(now(),'HH:MM:SS')# #dateformat(now(),Client.dateSQL)#";
										stask.DueDate          = "#timeformat(now(),'HH:MM:SS')# #dateformat(now(),Client.dateSQL)#";
										stask.ReminderDate     = "#dateformat(now()+3,Client.dateSQL)#";
										stask.Status           = "In_progress";
									    stask.PercentCompleted = 0;							
								</cfscript> 
									
							</cfoutput>	
							
							<!--- write the task also in exchange for this user ---> 
																												
							<cf_ExchangeTask
								alias	  	= "AppsOrganization"
								account     = "#UserAccount#"
								mailboxname = "#MailServerAccount#"
								password    = "#MailServerPassword#"
								task        = "#stask#"
								action      = "create"
								result      = "exchangeid">  							
							
							<!--- confirm the task write ---> 
													
							<cfquery name="UpdateMail" 
							datasource="AppsOrganization"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE   OrganizationObjectMail
								SET 	 ExchangeId   = '#exchangeID#'
								WHERE    ObjectMailId = '#rowguid#' 
							</cfquery>								
																   		   
				   </cfif>				   	 			
				   				
				</cfif>
				
			</cfif>	
		
		</cfif>
						
	 </cfloop>	
	 
</cfif>	