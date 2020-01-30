
<!--- check class --->

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_TimeClassParent
	WHERE   TimeParent = '#Attributes.TimeParent#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_TimeClassParent
	    	   (TimeParent, Description, AllowOverlap) 
		VALUES ('#Attributes.TimeParent#',
		        '#Attributes.Description#',
				'#Attributes.AllowOverlap#')
	</cfquery>
	
</cfif>

