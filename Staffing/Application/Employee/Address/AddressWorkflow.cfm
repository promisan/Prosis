		
	<cfquery name="Address" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   vwPersonAddress
		WHERE  AddressId  = '#url.ajaxid#'		
	</cfquery>
	
	<cfset mission = "">	

	<cfif address.AddressZone eq "">
	
		<cf_verifyOnBoard PersonNo = "#Address.PersonNo#">

	<cfelse>

		<cfquery name = "qAddressZone" 
		   datasource = "AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#"> 
			SELECT * 
			FROM  Ref_AddressZone
			WHERE Code = '#Address.AddressZone#'
	    </cfquery>
		<cfset mission = qAddressZone.Mission>
		
	</cfif>		
	
	<cfquery name="AddressType" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AddressType
		WHERE  AddressType  = '#Address.AddressType#'
		<!--- has a published workflow --->
		AND    EntityClass IN (SELECT EntityClass 
		                       FROM   Organization.dbo.Ref_EntityClassPublish 
							   WHERE  EntityCode = 'PersonAddress')
	</cfquery>

	<cfif addresstype.recordcount eq "1">
	
		<cfif mission neq "">		

			<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Person
				WHERE  PersonNo = '#Address.PersonNo#' 
			</cfquery>
							
			<cfset link = "Staffing/Application/Employee/Address/AddressEdit.cfm?id=#Address.PersonNo#&id1=#url.ajaxid#">
									
			<cf_ActionListing 
			    EntityCode       = "PersonAddress"
				EntityClass      = "#addresstype.entityclass#"
				EntityGroup      = ""
				EntityStatus     = ""	
				Mission          = "#mission#"
				PersonNo         = "#Address.PersonNo#"
				ObjectReference  = "#Address.AddressType#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
			    ObjectKey1       = "#Address.PersonNo#"
				ObjectKey4       = "#URL.ajaxid#"
				AjaxId           = "#URL.ajaxid#"	
				ObjectURL        = "#link#"
				Show             = "Yes">
				
		</cfif>

	</cfif>