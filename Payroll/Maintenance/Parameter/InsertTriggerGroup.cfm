
<!--- check class --->

<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_TriggerGroup
WHERE TriggerGroup = '#Attributes.TriggerGroup#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_TriggerGroup
	       (TriggerGroup, Description) 
	VALUES ('#Attributes.TriggerGroup#',
	        '#Attributes.Description#')
	</cfquery>
	
</cfif>

