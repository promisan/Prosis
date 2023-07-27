

<cfparam name="url.context" default="Backoffice">

<cfif url.scope eq "Edit">
	
	<cfquery name="Get" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    WorkOrder W,
			        WorkOrderLine WL
			WHERE   W.WorkOrderid = WL.WorkOrderid		   
			AND     WL.WorkOrderLineId = '#url.workorderlineid#'	
	</cfquery>
	
	<cfif get.recordcount eq "0">
	
		<table align="center">
		   <tr><td align="center" height="60" class="labelit"><cf_tl id="Workorder record not found"></td></tr>
	    </table>
		
		<cfabort>
		
	</cfif>
	
	<cfparam name="url.workorderid"   default="#get.workorderid#">
	<cfparam name="url.workorderline" default="#get.workorderline#">
		
	<cfquery name="Type" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   *
     FROM     ServiceItem
	 WHERE    Code IN (SELECT ServiceItem 
                     FROM   WorkOrder 
			         WHERE  WorkOrderId = '#get.workorderid#')	
	 AND      Operational = 1				
	 ORDER BY ListingOrder	
	</cfquery>
	
	<cfset url.serviceitem = type.code>

<cfelse>

	<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
	<cfparam name="url.workorderline" default="1">
		
	<cfquery name="Type" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
        FROM   ServiceItem
		WHERE  Code = '#url.serviceitem#'	
	</cfquery>
	
</cfif>

<cfif len(type.customform) lte "4">

	<!--- default empty form to prevent script will fail --->
		
	<cfform name="orderform" onsubmit="return false"></cfform>
	
<cfelse>

	<cfset l = len(type.customform)>		
	<cfset path = left(type.customform,l-4)>	
				 
	<cfoutput> 
	
	
	
	<input type="hidden" 
           name="formsave" id="formsave"
           value="#SESSION.root#/WorkOrder/Application/WorkOrder/Create/#path#Submit.cfm?context=#url.context#&mission=#url.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&serviceitem=#url.serviceitem#">
		  
		
		<cfinclude template      = "#type.customform#">
					
	</cfoutput>		
	
	
</cfif>		   

	
