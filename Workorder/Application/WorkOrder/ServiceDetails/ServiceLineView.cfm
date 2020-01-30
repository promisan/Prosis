
<cfparam name="url.id"       default="">   
<cfparam name="url.drillid"  default="#url.id#">
<cfparam name="url.openmode" default="dialog">

<cfif url.drillid neq "">
	
	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderLineId     = '#url.drillid#'	
	</cfquery>
	
	<cfif Line.recordcount eq "0">
	
	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLineItem
		 WHERE   WorkOrderItemId     = '#url.drillid#'	
	</cfquery>
	
	</cfif>
	
	<cfset url.workorderline = line.workorderline>
	<cfset url.workorderid   = line.workorderid>
	
<cfelse>

	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   1 = 0 	
	</cfquery>
		
</cfif>		

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'	
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

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Customer
	 WHERE   CustomerId = '#workorder.customerid#'	
</cfquery> 

<!--- -----------load the scripts-------- --->
<cfinclude template="ServiceLineScript.cfm">
<!--- ----------------------------------- --->

<cf_screentop label="#Customer.CustomerName# / #Item.Description#" 
   height        = "100%" 
   scroll        = "Yes" 
   systemmodule  = "WorkOrder"
   functionclass = "Window"
   functionName  = "WorkOrder Line"
   layout        = "webapp" 
   line          = "no" 
   busy          = "busy10.gif" 
   banner        = "blue" 
   bannerforce   = "Yes" 
   jQuery        = "yes">
 
<cf_listingScript gadgets="Yes">
 
<cfif domain.description neq "">
	<cfset option = "#Domain.description#">
<cfelse>
    <cfset option = "">
</cfif>

<cfset option = "#option#">
      	    	
	<cf_divscroll>
				
	<cfif Line.recordcount eq "1">
				
		<cfinclude template="ServiceLineFormEdit.cfm">
		
	<cfelse>	
	
	    <!--- no longer relevant, redirect to service line form entry --->		
		<cfinclude template="ServiceLineFormEntry.cfm">	
			
	</cfif>	
	
	</cf_divscroll>
	
<cf_screenbottom layout="webapp">	
