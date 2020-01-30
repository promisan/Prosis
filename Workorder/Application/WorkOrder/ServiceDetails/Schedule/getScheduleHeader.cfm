
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder W
		WHERE   WorkOrderId = '#url.workorderid#'		
</cfquery>

<cfquery name="Item" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    ServiceItem
		 WHERE   Code   = '#workorder.serviceitem#'	
	</cfquery>												
							
	<cfquery name="Domain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Ref_ServiceItemDomain
		 WHERE   Code   = '#item.servicedomain#'	
	</cfquery>
															
	<cfquery name="Line" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT  *	
		     FROM    WorkOrderLine WL 
			 		 INNER JOIN WorkOrderService WS 
					 	ON WL.ServiceDomain = WS.ServiceDomain 
						AND WL.Reference = WS.Reference 
			 WHERE   WL.WorkOrderId     = '#url.workorderid#'	
			 AND     WL.WorkOrderLine   = '#url.workorderline#'
	</cfquery>						
								
	<cfquery name="DomainClass" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Ref_ServiceItemDomainClass
			WHERE    ServiceDomain    = '#line.servicedomain#'	
			AND      Code             = '#line.servicedomainclass#'
	</cfquery>

	<cfoutput>

	<font color="0080C0">
	<!--- <cfif domain.description neq "">#Domain.description#<cfelse>Id</cfif> ---> [#line.reference#] #line.Description# : #domainClass.description# </b>
	</font>
	
	</cfoutput>