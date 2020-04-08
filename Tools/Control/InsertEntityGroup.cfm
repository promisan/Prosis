
<!--- check role --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_EntityGroup
	WHERE   EntityCode  = '#Attributes.EntityCode#'
	AND     EntityGroup = '#Attributes.EntityGroup#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cftry>

    <cfquery name="InsertGroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityGroup
	         (EntityCode, 
		      EntityGroup,
			  EntityGroupName)
	VALUES ('#Attributes.EntityCode#',
	        '#Attributes.EntityGroup#',
			'#Attributes.EntityGroupName#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>
				
<cfelse>

	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityGroup
		SET    EntityGroupName   = '#Attributes.EntityGroupName#',
		       Operational       = 1
		WHERE  EntityCode      = '#Attributes.EntityCode#'
		AND    EntityGroup     = '#Attributes.EntityGroup#'	   
	</cfquery>

</cfif>
