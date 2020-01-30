
<!--- check role --->

<cfparam name="Attributes.TimeClass" default="">
<cfparam name="Attributes.Description" default="">

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_TimeClass
WHERE TimeClass = '#Attributes.TimeClass#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_TimeClass
	       (TimeClass, 
		    Description)
	VALUES ('#Attributes.TimeClass#',
	        '#Attributes.description#')
	</cfquery>
			
<cfelse>

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_TimeClass
       SET Description = '#Attributes.description#'
	WHERE TimeClass = 	'#Attributes.TimeClass#'	   
	</cfquery>

</cfif>
