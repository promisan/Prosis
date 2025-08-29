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
<cfinvoke component   = "Service.Access"  
	   method         = "useradmin" 
	   accesslevel    = "'0','1','2'"
	   returnvariable = "accessUserAdmin">
	   
<cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL">
	
	<cfparam name="Form.iAccount" default="">
	<cfparam name="Form.oAccount" default="">
	<cfparam name="Form.Missions" default="">

	<cfoutput>
	
		<cfloop list="#Form.Missions#"  index="Element">
		
			<cfset vToCreate=#Element#&#Form.iAccount#>
			<cfset vToCreate=Left(vToCreate,20)>
					
			<cfquery name="check" datasource="AppsSystem">
				SELECT  * 
				FROM    UserNames 
				WHERE   Account = '#vToCreate#'
			</cfquery>
			
			<cfif check.recordcount eq 0>
			
				<!--- Account can be created without problem --->
				
				<cfquery name="first" datasource="AppsSystem">
				
					INSERT INTO UserNames (
					
							   [Account]
						      ,[AccountType]
						      ,[IndexNo]
						      ,[PersonNo]
						      ,[ApplicantNo]
						      ,[FirstName]
						      ,[LastName]
						      ,[Gender]
						      ,[Password]
						      ,[PasswordModified]
						      ,[PasswordHint]
						      ,[AccountOwner]
						      ,[AccountGroup]
						      ,[AccountMission]
						      ,[eMailAddress]
						      ,[eMailAddressExternal]
						      ,[NodeIP]
						      ,[AccountDelegate]
						      ,[MailServerAccount]
						      ,[MailServerPassword]
						      ,[Pref_PageRecords]
						      ,[Pref_Color]
						      ,[Pref_Interface]
						      ,[Pref_BCC]
						      ,[Pref_SMS]
						      ,[Pref_DashBoard]
						      ,[Pref_SystemLanguage]			     
						      ,[Pref_WorkflowMailAccount]		      
						      ,[DateEffective]
						      ,[DateExpiration]
						      ,[Disabled]
						      ,[DisabledModified]
						      ,[DisabledSource]
						      ,[PasswordExpiration]
						      ,[AllowMultipleLogon]
						      ,[DisableTimeOut]
						      ,[DisableNotification]
						      ,[DisableIPRouting]
						      ,[Remarks]
						      ,[OfficerUserId]
						      ,[OfficerLastName]
						      ,[OfficerFirstName]
						      ,[Source]) 
							  
					SELECT 	  '#vToCreate#'
						      ,[AccountType]
						      ,[IndexNo]
						      ,[PersonNo]
						      ,[ApplicantNo]
						      ,[FirstName]
						      ,[LastName]
						      ,[Gender]
						      ,[Password]
						      ,[PasswordModified]
						      ,[PasswordHint]
						      ,[AccountOwner]
						      ,[AccountGroup]
						      ,'#Element#'
						      ,[eMailAddress]
						      ,[eMailAddressExternal]
						      ,[NodeIP]
						      ,[AccountDelegate]
						      ,[MailServerAccount]
						      ,[MailServerPassword]
						      ,[Pref_PageRecords]
						      ,[Pref_Color]
						      ,[Pref_Interface]
						      ,[Pref_BCC]
						      ,[Pref_SMS]
						      ,[Pref_DashBoard]
						      ,[Pref_SystemLanguage]			      
						      ,[Pref_WorkflowMailAccount]		     
						      ,[DateEffective]
						      ,[DateExpiration]
						      ,[Disabled]
						      ,[DisabledModified]
						      ,[DisabledSource]
						      ,[PasswordExpiration]
						      ,[AllowMultipleLogon]
						      ,[DisableTimeOut]
						      ,[DisableNotification]
						      ,[DisableIPRouting]
						      ,'Auto-created by #SESSION.welcome#'
						      ,'#SESSION.acc#'
						      ,'#SESSION.last#'
						      ,'#SESSION.first#'
						      ,'Manual'
							  
				  FROM    UserNames
				  
				  WHERE   Account = '#Form.oAccount#'
				  
				</cfquery>
				
				<cfquery name="second" datasource="AppsOrganization">
					
					INSERT INTO  OrganizationAuthorization (
					
					       [Mission]
					       ,[OrgUnit]
					       ,[OrgUnitInherit]
					       ,[UserAccount]
					       ,[Role]
					       ,[ClassParameter]
					       ,[GroupParameter]
					       ,[ClassIsAction]
					       ,[AccessLevel]
					       ,[Source]
					       ,[RecordStatus]
					       ,[OfficerUserId]
					       ,[OfficerLastName]
					       ,[OfficerFirstName])
						  
					SELECT '#Element#'
					       ,[OrgUnit]
					       ,[OrgUnitInherit]
					       ,'#vToCreate#'
					       ,[Role]
					       ,[ClassParameter]
					       ,[GroupParameter]
					       ,[ClassIsAction]
					       ,[AccessLevel]
					       ,'Manual'
					       ,[RecordStatus]
					       ,'#SESSION.acc#'
					       ,'#SESSION.last#'
					       ,'#SESSION.first#'
						   
					  FROM   OrganizationAuthorization OA
			  		  WHERE  UserAccount = '#Form.oAccount#'		
					  AND    (OrgUnit=0 OR OrgUnit IS NULL)
					  AND NOT EXISTS (  SELECT 'X'
										FROM   OrganizationAuthorization OA2
										WHERE  OA2.UserAccount      = '#vToCreate#'
										AND    OA2.Role             = OA.Role
										AND    OA2.Mission          = OA.Mission
										AND    OA2.Mission          = '#Element#'
										AND    (OA2.OrgUnit         = 0 OR OA2.OrgUnit IS NULL)
										AND    OA2.ClassParameter   = OA.ClassParameter
										AND    OA2.Source           = OA.Source
										AND    OA2.GroupParameter   = OA.GroupParameter
										AND    OA2.AccessLevel      = OA.AccessLevel	
									 )
				</cfquery>
				
			</cfif>
			
		</cfloop>
		
		<script>			    
			<!--- try { opener.location.reload(); } catch(e) { } --->
			parent.parent.todays("yes")
			parent.parent.ProsisUI.closeWindow('mydialog',true)			
		</script>	
	
	</cfoutput>

<cfelse>

	<cf_message message = "The current Account is not associated to a mission" return = "">
	<cfabort>
	
</cfif>