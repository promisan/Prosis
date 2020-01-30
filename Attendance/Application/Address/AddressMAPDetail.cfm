<cfparam name="url.cfmapname" default="gmap">

<cfif url.cfmapname neq "gmap">

	<!--- detail --->
	
	<cfquery name="Address"
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
		   
			SELECT    P.PersonNo, 
			          P.IndexNo, 
					  P.LastName, 
					  P.FirstName, 
					  P.Gender, 
					  P.Nationality, 
					  A.Address, 
					  A.AddressCity, 
					  A.AddressPostalCode, 
					  A.Country, 
					  A.EMailAddress, 
					  A.Contact, 
					  A.ContactRelationship, 
					  A.ActionStatus,
					  A.Coordinates,
					  A.AddressId
		    FROM      vwPersonAddress A INNER JOIN
		              Person P ON A.PersonNo = P.PersonNo
			WHERE     A.AddressId = '#url.cfmapname#'
			
	</cfquery>	
	
	
	<cfoutput>
		
		<cfset url.id  = Address.PersonNo>
		<cfset url.id1 = Address.AddressId>
		<cfinclude template = "AddressContactView.cfm">
		<!---
		<cfinclude template = "AddressEditShort.cfm">
		--->
		
	</cfoutput>

<cfelse>

	<font face="calibri" size="2">
		Warden Zone
	</font>
	
</cfif>