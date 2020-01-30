
<!--- check role --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_EntityClass
	WHERE   EntityCode = '#Attributes.code#'
	AND     EntityClass = '#Attributes.Class#'
</cfquery>

<cfif Check.recordcount eq "0">

    <cfquery name="InsertClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityClass
	       (EntityCode, 
		    EntityClass,
			EntityClassName)
	VALUES ('#Attributes.code#',
	        '#Attributes.Class#',
			'#Attributes.Description#')
	</cfquery>
				
<cfelse>

	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  Ref_EntityClass
    SET     EntityClassName = '#Attributes.description#'
	WHERE   EntityCode  = '#Attributes.code#'
	AND     EntityClass = '#Attributes.Class#'	   
	</cfquery>

</cfif>
