
<!--- check class --->

<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_SlipGroup
WHERE Printgroup = '#Attributes.PrintGroup#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_SlipGroup
	       (PrintGroup, Description, PrintGroupOrder) 
	VALUES ('#Attributes.PrintGroup#',
	        '#Attributes.Description#',
			'#Attributes.PrintGroupOrder#')
	</cfquery>
	
</cfif>

