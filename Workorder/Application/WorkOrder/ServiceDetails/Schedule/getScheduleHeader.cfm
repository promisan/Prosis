<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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