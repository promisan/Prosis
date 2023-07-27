
<cfquery name="Update" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM OrganizationObjectActionReport
	WHERE    ActionId   = '#URL.ID#' 
</cfquery>

<cfquery name="Object" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   OrganizationObject
	WHERE  ObjectId IN (SELECT ObjectId 
	                   FROM OrganizationObjectAction
	                   WHERE  ActionId   = '#URL.ID#')
</cfquery>

<!--- register selected reports --->

<cfparam name="Form.DocumentId" default="">
<cfparam name="Form.SignatureBlock" default="">

<cfloop index="Item" 
        list="#Form.DocumentId#" 
        delimiters="' ,">
				
		<cfquery name="Format" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   R.*
		    FROM     Ref_EntityDocument R
		    WHERE    DocumentId   = '#Item#'
			AND      DocumentType = 'Report'
			AND      Operational  = 1 
			ORDER BY DocumentOrder
		</cfquery>
		
		<cfif format.recordcount eq "1">
		
			<cfquery name="Signature" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_EntityDocumentSignature
				WHERE  EntityCode = '#Object.EntityCode#'
				AND    Code = '#Form.SignatureBlock#' 
				AND	   Operational = 1
			</cfquery>	
		
			<cfsavecontent variable="text">
			<cfinclude template="../../../#Format.DocumentTemplate#">						
			</cfsavecontent>
									
			<cftry>	
					
			<cfquery name="Insert" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO OrganizationObjectActionReport
							 (ActionId,
							 DocumentId,
							 DocumentContent,
							 SignatureBlock,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#URL.ID#', 
						  '#item#',
						  '#text#',
						  '#Form.SignatureBlock#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
			</cfquery>	
			
			<cfcatch></cfcatch>
			
			</cftry>
				
		</cfif>		
	
</cfloop>
