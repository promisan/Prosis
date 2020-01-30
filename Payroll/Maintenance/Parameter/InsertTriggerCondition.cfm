
<!--- check class --->

<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_TriggerCondition
WHERE TriggerCondition = '#Attributes.TriggerCondition#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_TriggerCondition
	       (TriggerCondition, Description) 
	VALUES ('#Attributes.TriggerCondition#',
	        '#Attributes.Description#')
	</cfquery>
	
</cfif>

