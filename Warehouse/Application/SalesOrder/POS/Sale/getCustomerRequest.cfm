
<cfquery name="warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Warehouse  
	WHERE     Warehouse = '#url.Warehouse#' 
</cfquery>	

<cfquery name="checkHeader" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     CustomerRequest 			
	WHERE    Warehouse       = '#url.warehouse#'
	AND      CustomerId      = '#url.customerid#'		
	AND      AddressId       = '#url.addressid#'		
	AND      ActionStatus != '9'
</cfquery>		

<cfif checkheader.recordcount eq "0">
			
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
			   
	<cfquery name="checkHeader" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     CustomerRequest T			
			WHERE    T.Warehouse       = '#url.warehouse#'
			AND      T.CustomerId      = '#url.customerid#'		
			AND      T.AddressId       = '#url.addressid#'		
			AND      T.ActionStatus != '9'
	</cfquery>									
			
</cfif> 
			
<cfset caller.thisRequestno = CheckHeader.RequestNo>