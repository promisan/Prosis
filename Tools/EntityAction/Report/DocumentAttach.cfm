
<!--- declare documents to be attached --->

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
	AND    Operational = 1
	
	AND     DocumentId IN (
					
				SELECT     DocumentId
				FROM       Ref_EntityActionPublishDocument
				WHERE      ActionPublishNo = '#Object.ActionPublishNo#'
					
			)
	
	AND    DocumentId NOT IN (SELECT DocumentId 
	                          FROM   OrganizationObjectDocument 
							  WHERE  ObjectId = '#Object.ObjectId#')
</cfquery>

<!--- check if declared for this flow and action  --->

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
    SELECT   R.*	,
	
	           ( SELECT TOP 1 ObjectFilter
	             FROM    Ref_EntityActionPublishDocument
			  	  WHERE   ActionPublishNo = '#Object.ActionPublishNo#' 
				  AND     ActionCode      = '#Action.ActionCode#' 
				  AND     DocumentId      = R.DocumentId
				  AND     Operational     = 1) as ObjectFilter
	
	
		
    FROM     Ref_EntityDocument R,
		     Ref_EntityActionDocument R1
    WHERE    R1.ActionCode   = '#Action.ActionCode#' 
	AND      R.DocumentId    = R1.DocumentId
	AND      R.DocumentType  = 'Attach'
	AND      R.DocumentMode  = 'Step'
	AND      R.Operational   = 1
	
	<!--- is intended for this object, see above --->
	AND      R.DocumentId IN (SELECT DocumentId 
	                          FROM   OrganizationObjectDocument
							  WHERE  ObjectId = '#Object.ObjectId#'
							  AND    Operational = 1) 
							  
	<!--- is declared for this step --->			
	<cfif check.recordcount gte "1">	  
	AND 	EXISTS (SELECT  'X'
	                FROM    Ref_EntityActionPublishDocument
					WHERE   ActionPublishNo = '#Object.ActionPublishNo#' 
					AND     ActionCode      = '#Action.ActionCode#' 
					AND     DocumentId      = R.DocumentId
					AND     Operational     = 1)		
	</cfif>										  
	ORDER BY DocumentOrder
</cfquery>

<cfif External.recordcount gte "1">

<tr class="labelmedium line"><td colspan="2" style="padding-top:10px;padding-left:10px;height:30px;font-size:20px" colspan"2"><cf_tl id="Attachments"></td></tr>
	
<tr><td colspan="2">

<table width="100%" align="center"> 
	
	<cfoutput query="External">
	
		<cfset l = len(DocumentDescription)>
		<cfset w = l*8>
				
		<tr class="linedotted">
		    <td width="9"></td>					
		   	<td style="min-width:320px;max-width:420px;width:420px;padding-left:10px" class="labelmedium">#DocumentDescription# <cfif FieldRequired eq "1"><font color="FF0000">*</font></cfif> :</td>
			<td style="height:100%" valign="top">
			
			<cfif ObjectFilter eq "Inquiry">
				<cfset mode = "Inquiry">
			<cfelse>
				<cfset mode = "Edit">
			</cfif>
			
			<cfset box = "b#currentrow#">
			<cfset objectid = Object.objectid>
			<cfset name     = documentDescription>
			
			<cfinclude template="../ProcessObjectAttachment.cfm">
			
			</td>
		</tr>	
	
	</cfoutput>
	
	
</TABLE>

</td</tr>
	
</cfif>   
