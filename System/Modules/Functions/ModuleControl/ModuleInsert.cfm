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

<cfparam name="Attributes.SystemModule"  default="">
<cfparam name="Attributes.Hint"          default="">

	<!--- check role --->
	<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AuthorizationRoleOwner
		ORDER BY Created	
	</cfquery>

	<!--- check role --->
	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_SystemModule
		WHERE   SystemModule  = '#Attributes.SystemModule#' 	
	</cfquery>
			
	<cfif Check.recordcount eq "0">
		  	   
	    <cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO  Ref_SystemModule
			    (SystemModule, 
				  Description, 
				  TemplateRoot, 	
				  Hint,		
				  MenuOrder,
				  Operational,
				  RoleOwner) 
				
			VALUES ('#Attributes.SystemModule#', 
				  '#Attributes.Description#', 
				  '#Attributes.MenuTemplate#', 			 
				  '#Attributes.Hint#',
				  '#Attributes.MenuOrder#', 
				  0, 
				  '#role.Code#') 
	   </cfquery>
	   
	    <cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO  Ref_ApplicationModule
			      (Code,
				  SystemModule ) 				
			VALUES ('AD','#Attributes.SystemModule#') 
	   </cfquery>
	   
	   
	<cfelse>
	
	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_SystemModule
		SET     Description = '#Attributes.Description#'
		WHERE   SystemModule  = '#Attributes.SystemModule#' 	
	</cfquery>
		
	<!--- update --->   	  
		
	</cfif>