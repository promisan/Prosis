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
<!--- save custom fields --->

<cfquery name="Object" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
     SELECT    R.*
	 FROM      OrganizationObject R 
	 WHERE     Objectid = '#URL.Objectid#'
</cfquery>
   
<cfquery name="Fields" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
     SELECT    R.*
	 FROM      Ref_EntityDocument R 
	 WHERE     R.DocumentType = 'field'
	 AND       R.Operational = 1
	 AND       R.EntityCode = '#Object.EntityCode#'
	
	 <!---
	 AND       R.DocumentId IN (SELECT DocumentId 
	                            FROM   Ref_EntityActionPublishDocument 
								WHERE  ActionPublishNo = '#Object.ActionPublishNo#' and Operational = 1)	
  --->								
	ORDER BY DocumentOrder														
</cfquery>
	
<cfloop query="Fields">
	
	<!--- check if field exist --->
	
	<cfquery name="Check" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	   
	     SELECT   *
		 FROM     OrganizationObjectInformation
		 WHERE    ObjectId = '#Object.ObjectId#'
		 AND      DocumentId = '#DocumentId#'
	</cfquery>
	
	<cfparam name="Form.f_#DocumentCode#" default="">
	<cfset val = evaluate("Form.f_#DocumentCode#")>
	
	<cfif val neq "">
	
		<cfif fieldtype eq "list">
			
				 <cfquery name="List" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">	   
				 SELECT *
				 FROM Ref_EntityDocumentItem
				 WHERE DocumentId = '#documentid#'
				 AND  DocumentItem = '#val#'				 
			   </cfquery>
			   
			   <cfset cde = val>
			   <cfset val = list.DocumentItemName>
			   
		<cfelse>
			
			   <cfset cde = fieldtype>
			   <cfset val = val>   
						
		</cfif>

		<cfif check.recordcount eq "0">
					
			   <cfquery name="Insert" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">	   
				 INSERT INTO OrganizationObjectInformation
				   (ObjectId, 
				    DocumentId, 
					DocumentDescription, 
					DocumentItem,
					DocumentItemValue, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName)
				 VALUES
				 ('#Object.ObjectId#',
				   '#DocumentId#',
				   '#DocumentDescription#',
				   '#cde#',
				   '#val#',
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')		
			   </cfquery>
			
		<cfelse>	
		
				<cfquery name="Update" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">	   
					 UPDATE   OrganizationObjectInformation
					 SET      DocumentDescription = '#DocumentDescription#', 
					          DocumentItem = '#cde#',
						      DocumentItemValue = '#val#'
					 WHERE    ObjectId = '#Object.ObjectId#'
					 AND      DocumentId = '#DocumentId#'					
				</cfquery>
			
		</cfif>
		
	</cfif>
	
</cfloop>	

<cfoutput>
	<script>	
	    #ajaxlink('#url.caller#')#					
	</script>	
</cfoutput>		
		