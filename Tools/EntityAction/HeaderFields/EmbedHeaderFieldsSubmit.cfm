<!--- save custom fields --->

<cfquery name="Object" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
     SELECT    R.*
	 FROM      OrganizationObject R 
	 WHERE     (ObjectKeyValue4 = '#Attributes.EntityId#' OR Objectid = '#Attributes.EntityId#')
	 <cfif attributes.EntityCode neq "">
	 	AND EntityCode='#attributes.EntityCode#'
	 </cfif>
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

		