
<cfquery name="InsertAttach" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	INSERT INTO OrganizationObjectDocument
	       (ObjectId,
		    DocumentId,
			DocumentCode,
			OfficerUserId, 
			OfficerLastName,
			OfficerFirstName)
	SELECT '#Object.ObjectId#',
	       DocumentId,
		   DocumentCode,
		   '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#'
	FROM   Ref_EntityDocument
	WHERE  EntityCode     = '#Object.EntityCode#' 
	AND    DocumentType   = 'attach'
	AND    DocumentId NOT IN (SELECT DocumentId 
	                          FROM   OrganizationObjectDocument 
							  WHERE  ObjectId = '#Object.ObjectId#')
</cfquery>

<!--- check if defined --->

<cfquery name="Check" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  'X'
    FROM    Ref_EntityActionPublishDocument
    WHERE   ActionPublishNo = '#Object.ActionPublishNo#' 
	AND     ActionCode = '#Action.ActionCode#' 
	AND     DocumentId IN (SELECT DocumentId 
	                       FROM   Ref_EntityDocument 
						   WHERE  EntityCode = '#Object.EntityCode#'
						   AND    DocumentType = 'attach')
</cfquery>	
										

<cfquery name="External" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   R.*			
    FROM     Ref_EntityDocument R,
		     Ref_EntityActionDocument R1
    WHERE    R1.ActionCode   = '#Action.ActionCode#' 
	AND      R.DocumentId    = R1.DocumentId
	AND      R.DocumentType  = 'Attach'
	AND      R.DocumentMode  = 'Step'
	AND      R.Operational   = 1
	AND      R.DocumentId IN (SELECT DocumentId 
	                          FROM   OrganizationObjectDocument
							  WHERE  ObjectId = '#Object.ObjectId#'
							  AND    Operational = 1) 
	<!--- 17/7/2018 and enabled for the step in the config --->			
	<cfif check.recordcount gte "1">	  
	AND 	EXISTS (SELECT  'X'
	                FROM    Ref_EntityActionPublishDocument
					WHERE   ActionPublishNo = '#Object.ActionPublishNo#' 
					AND     ActionCode = '#Action.ActionCode#' 
					AND     DocumentId = R.DocumentId
					AND     Operational = 1)		
	</cfif>										  
	ORDER BY DocumentOrder
</cfquery>

<cfif External.recordcount gte "1">

<tr><td colspan="2">

<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">

	<cfoutput query="External">
	
		<cfset l = len(DocumentDescription)>
		<cfset w = l*8>
				
		<tr class="line">
		    <td width="9"></td>					
		   	<td height="30" width="172" valign="top" style="padding-top:4px" class="labelmedium">#DocumentDescription#:</td>
			<td height="30" style="padding-left:3px">
			<cfset mode = "edit">
			<cfset box = "b#currentrow#">
			<cfset objectid = Object.objectid>
			<cfinclude template="../ProcessObjectAttachment.cfm">
			</td>
		</tr>	
	
	</cfoutput>
	
</TABLE>

</td</tr>
	
</cfif>   
	 	   	


