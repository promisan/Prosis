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

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityGroup
		  SET     Operational = '#Form.Operational#',
 		          EntityGroupName = '#Form.EntityGroupName#',
				  <cfif form.owner eq "">
				      Owner = NULL
				  <cfelse>
				      Owner = '#form.Owner#'				  
				  </cfif>
		  WHERE   EntityGroup = '#URL.ID2#'
			 AND  EntityCode = '#URL.EntityCode#'
   	</cfquery>
			
	<cfset url.id2 = "new">
    <cfinclude template="ActionGroup.cfm">		
		

<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityGroup
		WHERE EntityCode = '#URL.EntityCode#' 
		AND EntityGroup = '#Form.EntityGroup#'
	</cfquery>
	
	<cfif #Exist.recordCount# eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityGroup
			         (EntityCode,
					 EntityGroup,
					  <cfif Form.Owner neq "">
						 Owner,
					  </cfif>
					 EntityGroupName,
					 Operational,
					 Created)
			      VALUES ('#URL.EntityCode#',
				      '#Form.EntityGroup#',
					  <cfif Form.Owner neq "">
						  '#Form.Owner#',
					   </cfif>
					  '#Form.EntityGroupName#',
				      '#Form.Operational#',
					  getDate())
			</cfquery>
	</cfif>	
	
	<cfset url.id2 = "new">
    <cfinclude template="ActionGroup.cfm">		
	   	
</cfif>
 	

  
