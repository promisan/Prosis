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
<cfparam name="FORM.AuthorizationAccount" default="">

<CF_DateConvert Value="#FORM.DateEffective_Date#">
<cfset tDate = dateValue>	
<cfset hour = Evaluate("#FORM.DateEffective_hour#")>
<cfset minute = Evaluate("#FORM.DateEffective_minute#")>
<cfset vDate = DateAdd("h", hour, tDate)>		
<cfset vDateEffective = DateAdd("n", minute, vDate)>

<CF_DateConvert Value="#FORM.DateExpiration_Date#">
<cfset tDate = dateValue>	
<cfset hour = Evaluate("#FORM.DateExpiration_hour#")>
<cfset minute = Evaluate("#FORM.DateExpiration_minute#")>
<cfset vDate = DateAdd("h", hour, tDate)>		
<cfset vDateExpiration = DateAdd("n", minute, vDate)>


<cfquery name="qInsert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
INSERT INTO Ref_ModuleControlAuthorization
           (
           SystemFunctionId
		   <cfif FORM.AuthorizationAccount neq "">
	           ,Account
		   </cfif>
   		   <cfif FORM.AuthorizationMission neq "">
	           ,Mission
			</cfif>	   
			<cfif FORM.DateEffective_Date neq "">			
	           ,DateEffective
			</cfif>
			<cfif FORM.DateExpiration_Date neq "">   
	           ,DateExpiration
			</cfif>   
			<cfif FORM.AuthorizationLevel neq "">   			
	           ,AuthorizationLevel
			</cfif>   
			<cfif FORM.AuthorizationCode neq "">   									
	           ,AuthorizationCode
			</cfif>   
           ,OfficerUserId
           ,OfficerLastName
           ,OfficerFirstName)
     VALUES
           (
           '#URL.ID#'
		   <cfif FORM.AuthorizationAccount neq "">
	           ,'#FORM.AuthorizationAccount#'
		   </cfif>
   		   <cfif FORM.AuthorizationMission neq "">
	           ,'#FORM.AuthorizationMission#'
			</cfif>	   
			<cfif FORM.DateEffective_Date neq "">
	           ,#vDateEffective#
			</cfif>
			<cfif FORM.DateExpiration_Date neq "">   
	           ,#vDateExpiration#
			</cfif>   
			<cfif FORM.AuthorizationLevel neq "">   						
	           ,'#FORM.AuthorizationLevel#'
		 	</cfif>	   
			<cfif FORM.AuthorizationCode neq "">   												
	           ,'#FORM.AuthorizationCode#'
			</cfif>   
           ,'#SESSION.Acc#'
           ,'#SESSION.Last#'
           ,'#SESSION.First#')
</cfquery>

<cfset URL.mode = "active">
<cfinclude template="AuthorizationRoles.cfm">