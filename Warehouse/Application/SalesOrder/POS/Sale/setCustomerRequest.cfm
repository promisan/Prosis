
<cfquery name="warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Warehouse  
	WHERE     Warehouse = '#url.Warehouse#' 
</cfquery>	

<cfquery name="getQuote" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     CustomerRequest 			
	WHERE    Warehouse       = '#url.warehouse#'
	AND      CustomerId      = '#url.customerid#'		
	AND      AddressId       = '#url.addressid#'	
	AND      BatchNo is NULL	
	<!--- entered directly or submitted as quote --->
	AND      (
		      (Source = 'Manual' AND ActionStatus IN ('0','1'))
			   OR Source != 'Manual' AND ActionStatus = '1' <!--- web and quote --->
			 )		
</cfquery>		

<cfif getQuote.recordcount eq "0">
			
	<cfquery name="InsertHeader" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		INSERT INTO CustomerRequest ( 	
		        Mission, 
				Warehouse, 
				CustomerId, 
				AddressId, 				
				Source, 
				ActionStatus,
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName )
			VALUES ('#warehouse.Mission#', 
				'#url.warehouse#', 
				'#url.Customerid#', 
				'#url.addressId#',
				'Manual',
				'0',
				'#session.acc#',
				'#session.last#',
				'#session.first#' )
	</cfquery>
	
	<cfquery name="getQuote" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     CustomerRequest T			
			WHERE    T.Warehouse       = '#url.warehouse#'
			AND      T.CustomerId      = '#url.customerid#'		
			AND      T.AddressId       = '#url.addressid#'		
			AND      T.ActionStatus    != '9'
			ORDER BY RequestNo DESC			
	</cfquery>		
	
	<cfquery name="Customer" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Customer 			
		WHERE    CustomerId      = '#url.customerid#'	
		ORDER BY Created DESC		
	</cfquery>	
		
	<cf_workflowenabled 
		 mission="#Warehouse.mission#" 
		 entitycode="WhsQuote">

	<cfif WorkflowEnabled eq "1">
	
		<cfquery name="OrgUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT      *
		FROM        Organization.dbo.Organization
		WHERE       MissionOrgUnitId = '#warehouse.MissionOrgUnitId#'
		ORDER BY    Created DESC
		</cfquery>
				
		<cfset link = "Warehouse/Application/SalesOrder/Quote/QuoteView.cfm?requestno=#getQuote.requestno#">
				   			   				
		<cf_ActionListing 
		    EntityCode       = "WhsQuote"
			EntityClass      = "Standard"			
			EntityStatus     = ""	
			Mission          = "#warehouse.Mission#"
			OrgUnit          = "#OrgUnit.OrgUnit#"			
			ObjectReference  = "Quotation #getQuote.requestno#"
			ObjectReference2 = "#Customer.CustomerName#"
			ObjectKey1       = "#getQuote.RequestNo#"	
		  	ObjectURL        = "#link#"
			AjaxId           = "#getQuote.RequestNo#"
			Show             = "No"
			PersonNo         = "#Customer.PersonNo#"
			PersonEMail      = "#Customer.eMailAddress#">			
	
	</cfif>						
			
</cfif> 
			
<cfset caller.thisRequestno = getQuote.RequestNo>