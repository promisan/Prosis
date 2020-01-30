
<!--- check reference --->

<cfif url.reference neq "">
	
	<cfquery name="WorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrder
			WHERE  Mission   = '#URL.Mission#'					  
			AND    ServiceItem = '#url.serviceitem#'
			AND    Reference = '#url.reference#'
	</cfquery>			
	
	<cfif workorder.recordcount gte "1">
	
	<font color="FF0000"><b><cf_tl id="Reference exists"></font>
	
	</cfif>
	
</cfif>	