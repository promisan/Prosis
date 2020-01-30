
<!--- check class --->

<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_PayrollTrigger
WHERE SalaryTrigger = '#Attributes.SalaryTrigger#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_PayrollTrigger
	       (SalaryTrigger, Description, TriggerGroup, TriggerCondition,TriggerConditionPointer,EntitlementClass) 
	VALUES ('#Attributes.SalaryTrigger#',
	        '#Attributes.Description#',
			'#Attributes.TriggerGroup#',
			'#Attributes.TriggerCondition#',
			'#Attributes.TriggerConditionPointer#',
			'#Attributes.EntitlementClass#')
	</cfquery>
	
</cfif>

