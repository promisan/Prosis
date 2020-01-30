
<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_GLCategory
	WHERE   GLCategory = '#Attributes.GLCategory#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_GLCategory  (GLCategory,Description) 
		VALUES ('#Attributes.GLCategory#',
				'#Attributes.Description#')
	</cfquery>
	
</cfif>

