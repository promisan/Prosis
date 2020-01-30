
 <cfquery name="Rate" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT  * 
		  FROM    ServiceItemUnitMission
		  WHERE   ServiceItem = '#URL.ServiceItem#'
		  AND     ServiceItemUnit = '#Form.ServiceItemUnit#'
		  AND     Mission = '#URL.Mission#' 
   	</cfquery>

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Cart
		  SET     ServiceItemUnit = '#Form.ServiceItemUnit#',
 		          Reference       = '#Form.Reference#',
				  Currency        = '#Rate.Currency#',
				  Amount          = '#Rate.StandardCost#'				 
		  WHERE   Cartid = '#URL.ID2#'			 
   	</cfquery>
			
	<cfset url.id2 = "new">
    <cfinclude template="CartLine.cfm">		
		
<cfelse>
			
	<cfquery name="Insert" 
	     datasource="AppsWorkOrder" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Cart
	         (Mission,
			 ServiceItem,
			 ServiceItemUnit,
			 Reference,
			 Currency,
			 Amount,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.Mission#',
		      '#url.serviceitem#',
			  '#Form.ServiceItemUnit#',
			  '#Form.Reference#',
			  '#Rate.Currency#',
			  '#Rate.StandardCost#',
			  '#Client.acc#',
			  '#client.last#',
			  '#client.first#') 
	</cfquery>
	
	<cfset url.id2 = "new">
    <cfinclude template="CartLine.cfm">		
	   	
</cfif>
 	

  
