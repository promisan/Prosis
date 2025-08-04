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
<cfparam name="url.showClose" default="1">

<cfquery name="Account" 
	datasource="AppsSystem">
		SELECT * 
		FROM   System.dbo.UserNames
		WHERE  eMailAddress = '#Form.eMailAddress#'	
</cfquery>

<cfquery name="Check" 
	 datasource="AppsSystem">		 
		 SELECT *
		 FROM   UserRequest
		 WHERE  MailAddress  = '#Form.eMailAddress#'
		 AND    ActionStatus IN ('0','1')		 
</cfquery>

<table>

<tr>

	<td style="padding-top:80px; font-size:14px;" align="center">
	
	<cfset createWorkflow = 1>
	
	<!--- <cfif Check.recordcount eq 0> --->
	
	<cfif Account.Account neq "Administrator">
	
		<cfif Account.recordcount gt 0>  <!--- Account exists --->
		
			<!--- <cfif Account.Disabled eq 1> ---> <!--- Account is disabled --->
				 
				 <cftransaction>
				 
				 	 <cf_assignId>
				 	 <cfset RequestId = rowguid>
					 
					 <cfquery name="Last" 
						datasource="AppsSystem">
							SELECT   TOP 1 *
							FROM     UserRequest
							WHERE    Owner = '#Form.Owner#'		
							ORDER BY RequestNo DESC
					</cfquery>
					
					<cfif last.recordcount eq "0">
					
						<cfset la = 1>
						<cfset ref = "#Form.Owner#000#la#">
						
					<cfelse>
					
						<cfset la = last.requestno+1>
					
						<cfif len(la) eq "1">
							<cfset ref = "#Form.Owner#000#la#">
						<cfelseif len(la) eq "2">
						    <cfset ref = "#Form.Owner#00#la#">
						<cfelseif len(la) eq "3">
						    <cfset ref = "#Form.Owner#0#la#">
						<cfelse>
						    <cfset ref = "#Form.Owner#0#la#">	
						</cfif>
					
					</CFIF>
					 				 
					<cfquery name="Insert" 
					  datasource="AppsSystem">				
						 INSERT INTO UserRequest( 
				               RequestId,
				 			   Reference,
							   RequestNo,
				 			   Mission,
							   Owner,
							   Application,
							   MailAddress,
							   RequestMemo)									
						 VALUES 
						 	('#RequestId#',
						     '#ref#',
							 '#la#',
						 	 '#Form.Mission#', 
						 	 '#Form.Owner#', 
							 '#Form.Workgroup#',
							 '#Form.eMailAddress#', 
							 '#Form.Memo#')				
					</cfquery>
					 
					<cfquery name="Insert" 
					  datasource="AppsSystem">
					  		
							INSERT INTO UserRequestNames(RequestId,Account)
							VALUES ('#RequestId#',
									'#Account.Account#'	)
							
					  </cfquery>
		
				  </cftransaction>
		
				  <!--- <cfset createWorkflow = 1> --->
				  <!--- <cfset WFClass        = "EditAccess"> --->
		
				  <cf_tl id="Your request has been submitted.">
						
		
		<cfelse>  <!--- Account does not exist --->
		
				 <cftransaction>
		
				 	<cf_assignId>
				 	<cfset RequestId = rowguid>
					 
					<cfquery name="Last" 
						datasource="AppsSystem">
							SELECT   TOP 1 *
							FROM     UserRequest
							WHERE    Owner = '#Form.Owner#'		
							ORDER BY RequestNo DESC
					</cfquery>
					
					<cfif last.recordcount eq "0">
					
						<cfset la = 1>
						<cfset ref = "#Form.Owner#000#la#">
						
					<cfelse>
					
						<cfset la = last.requestno+1>
					
						<cfif len(la) eq "1">
							<cfset ref = "#Form.Owner#000#la#">
						<cfelseif len(la) eq "2">
						    <cfset ref = "#Form.Owner#00#la#">
						<cfelseif len(la) eq "3">
						    <cfset ref = "#Form.Owner#0#la#">
						<cfelse>
						    <cfset ref = "#Form.Owner#0#la#">	
						</cfif>
					
					</CFIF>
					
					<cfquery name="Insert" 
					  datasource="AppsSystem">				
						 INSERT INTO UserRequest( 
				               RequestId,
				 			   Reference,
							   RequestNo,
				 			   Mission,
							   Owner,
							   Application,
							   MailAddress,
							   RequestMemo)									
						 VALUES 
						 	('#RequestId#',
						     '#ref#',
							 '#la#',
						 	 '#Form.Mission#', 
						 	 '#Form.Owner#', 
							 '#Form.Workgroup#',
							 '#Form.eMailAddress#', 
							 '#Form.Memo#')				
					</cfquery>					 
										 
					 <cfquery name="Insert" 
					  datasource="AppsSystem">
					
						 INSERT INTO  UserRequestNewAccount( RequestId,
						 			  FirstName,
									  LastName,
									  Gender,
									  IndexNo,
									  Telephone,
									  eMailAddress,
									  MailServerAccount,
						 			  AccountMission,
									  AccountOwner,
									  MemoAccess)
										
						 VALUES ('#RequestId#',
								 '#Form.FirstName#',
								 '#Form.LastName#',
								 '#Form.Gender#',
								 '#Form.IndexNo#',
								 '#Form.Telephone#',
								 '#Form.eMailAddress#',
								 '#Form.ldapAccount#',
						 		 '#Form.Mission#', 
						 		 '#Form.Owner#', 
								 '#Form.Memo#' )
					
					</cfquery>
				 
				 </cftransaction>
				 
	 			 <!--- <cfset createWorkflow = 1> --->
				 <!--- <cfset WFClass        = "NewAccount"> --->
				 <table>
				 	<tr>
						<td style="padding-top" class="labellarge"><cf_tl id="Your request has been submitted and will be forwarded to the focal point of your organization."></td>
					</tr>
				 </table>
		
		</cfif>
	
	<cfelse>
	
		<font color="FF0000"><cf_tl id="Invalid account"></font>
	
	</cfif>
	
	<!--- <cfelse>
		
		<cf_tl id="The email address you entered is already associated to an existing request."><br><br>
		<cf_tl id="Please check with your assigned focal point.">
		
	</cfif> --->
	
	<br>
	
	<cfif Account.Account neq "Administrator">
	
		<cfif createWorkflow eq 1>
		
			<cfquery name="Workgroup" 
			datasource="AppsOrganization">
			    SELECT  TOP 1 *			<!--- To be enhanced --->
			    FROM    Ref_EntityGroup
			    WHERE   EntityCode = 'AuthRequest' 
			    AND     Owner      = '#Form.Owner#'
			</cfquery>
			
			<cfset link = "System/AccessRequest/DocumentEntry.cfm?drillid=#RequestId#">
			
			<cfset WFClass     = "Standard">
		
			<cf_ActionListing 
			  EntityCode       = "AuthRequest"
			  EntityGroup      = "#Workgroup.EntityGroup#"
			  EntityClass      = "#WFClass#"
			  EntityStatus     = "0"  
			  PersonEMail      = "#Form.eMailAddress#"
			  ObjectReference  = "Account Request by #Form.LastName#,#Form.FirstName#"
			  ObjectKey4       = "#RequestId#"
			  ObjectURL        = "#link#"
			  Show             = "No"
			  Toolbar          = "No"
			  Framecolor       = "ECF5FF"
			  CompleteFirst    = "Yes"> 
		
		</cfif>
		
		<cfif url.showClose eq 1>
		
			<cf_button label="Close" 
					   color="white" 
					   fontweight="bold" 
					   mode="blueshadow" 
					   id="bclose" 
					   onclick="parent.document.getElementById('requestaccess').style.display='none'; parent.document.getElementById('modalbg').style.display='none';">
		</cfif>
		
	</cfif>
	
	</td>
		   
</tr>
   
</table>