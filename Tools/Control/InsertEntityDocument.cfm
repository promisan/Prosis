
<cfparam name="Attributes.documentstringlist" default="">

<!--- check role --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_EntityDocument
WHERE EntityCode   = '#Attributes.code#'
AND   DocumentType = '#Attributes.documenttype#'
AND   DocumentCode = '#Attributes.documentcode#'
</cfquery>

<cfif Check.recordcount eq "0">

    <cfquery name="InsertClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityDocument
	       (EntityCode, 
		    DocumentType, 
			DocumentCode, 
			DocumentDescription, 
			DocumentTemplate, 
			DocumentMode,
			DocumentStringList,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName)
	VALUES ('#Attributes.code#',
	        '#Attributes.DocumentType#',
			'#Attributes.DocumentCode#',
			'#Attributes.DocumentDescription#',
			'#Attributes.DocumentTemplate#',
			'#Attributes.DocumentMode#',
			'#Attributes.DocumentStringList#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>
				
<cfelse>

	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityDocument
	    SET    DocumentDescription  = '#Attributes.DocumentDescription#',
			   DocumentStringList   = '#Attributes.DocumentStringList#', 
			   DocumentTemplate     = '#Attributes.DocumentTemplate#'  
	   	WHERE  EntityCode   		= '#Attributes.code#'
		AND    DocumentType 		= '#Attributes.documenttype#'
	    AND    DocumentCode 		= '#Attributes.documentcode#'   
		
	</cfquery>

</cfif>
