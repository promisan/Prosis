
<cfparam name="Attributes.CustomForm" default="">


<!--- check class --->

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Status
WHERE   Class = '#Attributes.Class#'
AND     Status = '#attributes.Status#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Status
	       (Class,Status,Description) 
	VALUES ('#Attributes.Class#',
	        '#Attributes.Status#',
	        '#Attributes.Description#')
	</cfquery>
	
<cfelse>
		
	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Status
		SET    Description  = '#Attributes.Description#'		
		WHERE   Class = '#Attributes.Class#'
		AND     Status = '#attributes.Status#'
	</cfquery>
	
</cfif>

