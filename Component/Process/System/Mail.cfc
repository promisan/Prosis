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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Mail functions">

	<cffunction name="MailContentConversion"
        access="public"
        returntype="string">
		
		<cfargument name="DataSource"  type="string"  required="false" default="appsOrganization">			
		<cfargument name="ObjectId"    type="string"  required="false" default="">	
		<cfargument name="ActionId"    type="string"  required="false" default="">	
		<cfargument name="PersonNo"    type="string"  required="false" default="">	
		<cfargument name="FunctionId"  type="string"  required="false" default="">
		<cfargument name="ReviewId"    type="string"  required="false" default="">
		<cfargument name="DateTime"    type="string"  required="false" default="">			
		<cfargument name="Content"     type="string"  required="yes">	 	 				
				
		<cfif ObjectId neq "">
		
			<cfquery name="Object" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      OrganizationObject 						
				WHERE     ObjectId = '#ObjectId#'
			</cfquery>
			
			<cfquery name="Person" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Employee.dbo.Person 						
				WHERE     PersonNo = '#Object.PersonNo#'
			</cfquery>
			
			<cfquery name="Candidate" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Applicant.dbo.Applicant 						
				WHERE     PersonNo = '#Object.PersonNo#'
			</cfquery>
			
			 <cfset htmllink = "<a href='#SESSION.root#/ActionView.cfm?id=#Object.Objectid#'><font color='0080FF'>Click here to process</font></a>">			  
				  
			  <cfset content = replaceNoCase( "#content#", "@link",     "#htmllink#",                                "ALL")>				
			  <cfset content = replaceNoCase( "#content#", "@user",     "#SESSION.first# #SESSION.last#",            "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@ref1",     "#Object.ObjectReference#",                  "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@ref2",     "#Object.ObjectReference2#",                 "ALL")>		
			  <cfset content = replaceNoCase( "#content#", "@person",   "#Person.FirstName# #Person.LastName#",      "ALL")>	
			  <cfset content = replaceNoCase( "#content#", "@candidate","#Candidate.FirstName# #Candidate.LastName#","ALL")>		 	 
			  <cfset content = replaceNoCase( "#content#", "@mission",  "#Object.Mission#",                          "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@owner",    "#Object.Owner#",                            "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@holder",   "#Object.OfficerFirstName# #Object.OfficerLastName#",       "ALL")>	
			  <cfset content = replaceNoCase( "#content#", "@ipaddress","#Object.OfficerNodeIP#",                    "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@today",    "#dateformat(now(),CLIENT.DateFormatShow)#", "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@time",     "#timeformat(now(),'HH:MM')#",               "ALL")>
						
		</cfif>	
		
		<cfif ActionId neq "">					
							
			 <cfquery name="Object" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT    O.*, 
					          A.ActionCode, 
							  A.TriggerActionType, 
							  A.TriggerActionId,
							  R.PersonClass,
							  AA.ActionDescription,
							  AA.ActionCompleted,
							  R.DocumentPathName,
							  R.MailFrom,
							  R.MailFromAddress,
							  R.EntityDescription,
							  C.EntityClassName,
							  R.EnableEMail,
							  C.EnableEMail as ClassMail
					FROM      OrganizationObject O, 
					          OrganizationObjectAction A,
							  Ref_EntityActionPublish AA,  
							  Ref_Entity R,
							  Ref_EntityClass C
					WHERE     O.ObjectId        = A.ObjectId 
					AND       R.EntityCode      = O.EntityCode
					AND       A.ActionPublishNo = AA.ActionPublishNo 
					AND       A.ActionCode      = AA.ActionCode
					AND       C.EntityCode      = O.EntityCode
					AND       C.EntityClass     = O.EntityClass
					AND       A.ActionId        = '#ActionId#' 	
				
			  </cfquery>	
				
			  <cfset content = replaceNoCase( "#content#", "@action",   "#Object.ActionDescription#","ALL")>
  			  <cfset content = replaceNoCase( "#content#", "@entity",   "#Object.EntityDescription#","ALL")>
  			  <cfset content = replaceNoCase( "#content#", "@class",    "#Object.EntityClassName#","ALL")>
			  
		</cfif>	  
		
		<cfif PersonNo neq "">
		
			<cfquery name="Person" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Employee.dbo.Person 						
				WHERE     PersonNo = '#PersonNo#'
			</cfquery>
			
			<cfif Person.recordcount eq "0">
			
				<cfquery name="Person" 
					datasource="#DataSource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    * 
					FROM      Applicant.dbo.Applicant 						
					WHERE     PersonNo = '#PersonNo#'
				</cfquery>
							
			</cfif>
						
			<cfset content = replaceNoCase( "#content#", "@personemail","#Person.EmailAddress#","ALL")>
			<cfset content = replaceNoCase( "#content#", "@person","#Person.FirstName# #Person.LastName#","ALL")>
				
		</cfif>
		
		<cfif ActionId neq "" and ReviewId neq "">
		
			<cfquery name="WebSession" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Organization.dbo.OrganizationObjectActionSession 						
				WHERE     ActionId = '#actionid#'
				AND       EntityReference = '#ReviewId#' 
				
			</cfquery>	
			
			<cfif websession.recordcount eq "1">
								
				<cfset content = replaceNoCase( "#content#", "@websession","<a href='#session.root#/ActionSession.cfm?id=#websession.actionSessionId#' target='_blank'>Open test</a>","ALL")>
		
			</cfif>
		
		
		</cfif>
		
		<cfif FunctionId neq "">
		
			<cfquery name="Function" 
					datasource="#DataSource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    * 
					FROM      Applicant.dbo.FunctionOrganization 						
					WHERE     FunctionId = '#FunctionId#'
				</cfquery>
				
			<cfset content = replaceNoCase( "#content#", "@functionid","#Function.ReferenceNo#","ALL")>
			
			<!--- --- title ---- --->
			
			<cfquery name="Title" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      Applicant.dbo.FunctionTitle
					WHERE     FunctionNo ='#Function.FunctionNo#' 					
			</cfquery>
			
			<cfset content = replaceNoCase( "#content#", "@functiontitle","#Title.FunctionDescription#","ALL")>
			
			<!--- extended title CBD only --->
			
			<cfquery name="Title" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    TOP (1) QuestionScore, QuestionMemo
					FROM      OrganizationObjectQuestion
					WHERE     QuestionId = 'c98830f3-5474-4f31-a603-9b5fc5df016f' 
					AND       ObjectId = '#ObjectId#'
					ORDER BY  Created DESC
			</cfquery>
			
			<cfset content = replaceNoCase( "#content#", "@functionextended","#Title.QuestionMemo#","ALL")>
						
				
		</cfif>
		
		<cfif DateTime neq "">
					
			<cfset content = replaceNoCase( "#content#", "@datetime","#dateformat(DateTime,'DDDD DD MMMM YYYY')# #TimeFormat(DateTime,'HH:MM')#","ALL")>
		
		</cfif>
						
		<cfreturn content>		   	
				
	</cffunction>	
	
</cfcomponent>			 