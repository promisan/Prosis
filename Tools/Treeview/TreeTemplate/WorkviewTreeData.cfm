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
 <cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT E.*, M.SystemModule, M.Description, M.MenuOrder 
      FROM Ref_Entity E, Ref_AuthorizationRole R, System.dbo.Ref_SystemModule M
	  WHERE E.Operational = '1'		
	  <cfif SESSION.isAdministrator eq "No">
	  <!--- determine if person has access to at least one instance --->
	  AND EntityCode IN
		 	 (SELECT DISTINCT E.EntityCode
				FROM  Ref_EntityAction E, 
				      OrganizationAuthorization A
				WHERE E.ActionCode    = A.ClassParameter
				AND   A.UserAccount   = '#SESSION.acc#'
				AND   A.ClassIsAction = '1')
	  </cfif>	
	  AND E.Role = R.Role
	  AND (E.TemplateSearch like '%.cfm')
	  AND R.SystemModule = M.SystemModule
	  ORDER BY M.MenuOrder, M.SystemModule		
 </cfquery>
 
<cfif Entity.recordcount eq "0">

<font color="FF0000">No access</font>

<cfelse>
	 
	<cftree name="root"
	   fontsize="11"		
	   bold="No"   
	   format="html"    
	   required="No">     
		  	         	   	  	  
	 <cfoutput query="Entity" group="MenuOrder">
	 
		 <cfoutput group="Description">
		 
		 	<cftreeitem value="#SystemModule#"
			        display="<b>#Description#</b>"
					parent="Root"							
			        expand="Yes">	
		 
			 <cfoutput>
				 
			    <cfset et  = Entity.EntityCode>
				
				<cfif TemplateSearch neq "">
				
					<cftreeitem value="#EntityCode#"
				        display="#EntityDescription#"
						parent="#SystemModule#"		
						href="#SESSION.root#/#TemplateSearch#"					
						target="right"
				        expand="No">
						
				<cfelseif TemplateListing neq "">
				
					<cftreeitem value="#EntityCode#"
				        display="#EntityDescription#"
						parent="#SystemModule#"		
						href="#SESSION.root#/#TemplateListing#"					
						target="right"
				        expand="No">		
						
				<cfelse>
				
					<cftreeitem value="#EntityCode#"
				        display="#EntityDescription#"
						parent="#SystemModule#"				
				        expand="No">
						
				</cfif>			
				
			  	<cfquery name="Create" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
			      SELECT DISTINCT E.EntityCode
				    FROM  Ref_EntityAction E, OrganizationAuthorization A
					WHERE E.ActionCode  = A.ClassParameter
					AND   A.UserAccount = '#SESSION.acc#'
					AND   E.EntityCode  = '#Entity.EntityCode#'
					AND   E.ActionType  = 'Create'
				</cfquery>
				
				<cfif TemplateSearch neq "">
				
					<cftreeitem value="#EntityCode#_adv"
				        display="List and Search"
						parent="#EntityCode#"		
						href="#SESSION.root#/#TemplateSearch#"					
						target="right"
				        expand="No">		
						
				</cfif>
						
				<cfif EnableCreate eq "1" and TemplateCreate neq "" and (Create.Recordcount gte "1" or SESSION.isAdministrator eq "Yes")>
				
					<cftreeitem value="#EntityCode#_new"
				        display="Register New"
						parent="#EntityCode#"		
						href="#SESSION.root#/#TemplateCreate#"					
						target="right"
				        expand="No">	
									
				</cfif>		
				
			</cfoutput>	
		
		</cfoutput>	
											   
	</cfoutput>
	
	</cftree>
	
</cfif>

 




