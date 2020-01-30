
<cfparam name="Attributes.ActionClass" default="">
<cfparam name="Attributes.Description" default="">
<cfparam name="Attributes.ActionParent" default="">
<cfparam name="Attributes.ListingOrder" default="1">
<cfparam name="Attributes.ProgramLookup" default="0">

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_WorkAction
WHERE ActionClass = '#Attributes.ActionClass#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_WorkAction
	       (ActionClass, 
		    ActionDescription,
			ActionParent,
			ListingOrder,
			ProgramLookup,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName)
	VALUES ('#Attributes.ActionClass#',
	        '#Attributes.Description#',
			'#Attributes.ActionParent#',
			'#Attributes.ListingOrder#',
			'#Attributes.ProgramLookup#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>
			
<cfelse>

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_WorkAction
       SET   ActionDescription = '#Attributes.Description#',
	   		 ActionParent = '#Attributes.ActionParent#',
	   		 ListingOrder = '#Attributes.ListingOrder#',
	   		 ProgramLookup = '#Attributes.ProgramLookup#'
	WHERE ActionClass = '#Attributes.ActionClass#'	   
	</cfquery>

</cfif>
