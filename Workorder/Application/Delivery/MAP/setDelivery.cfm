
<cfset dateValue = "">
<CF_DateConvert Value="#form.transaction_date#">
<cfset DTE = dateValue>

<cfset dte = DateAdd("h","#form.transaction_hour#", dte)>
<cfset dte = DateAdd("n","#form.transaction_minute#", dte)>

<cfparam name="form.complete" default="0">
	
<cfquery name="get"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT  * 
		FROM    WorkOrderLine	
		WHERE   WorkOrderLineId = '#url.cfmapname#' 			   	    	  
</cfquery>	
	
<cfif form.complete eq "1">	
	
	<cfquery name="set"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
			UPDATE  WorkOrderLineAction
			SET     DateTimeActual = #dte#
			WHERE   WorkOrderId   = '#get.WorkOrderId#' 	
			AND     WorkOrderLine = '#get.WorkOrderLine#'
			AND     ActionClass   = 'Delivery'	   	    	  		
	</cfquery>	

</cfif>

<!--- set icon --->

<cfset icon = "Icons/Delivered.png">

<cfquery name="Customer"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   C.*				 
	    FROM     Customer C, WorkOrder W
		WHERE    C.CustomerId = W.CustomerId
		AND      WorkOrderId = '#get.WorkOrderId#'
</cfquery>	

<cfoutput>
	<font color="green">Applied</font>
</cfoutput>