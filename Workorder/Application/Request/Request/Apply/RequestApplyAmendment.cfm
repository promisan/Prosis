<!--- handles the workorder lines for amendment which means

change of service : porting
change of responsibility
termination (end) -

--->

<!--- retrieve the line of the request which has just one record for this --->

<cfquery name="get"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     Request
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfquery name="getLine"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestLine
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfquery name="getOrder"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrder
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfquery name="Current" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   L.*, 
		         W.CustomerId, 
			     W.ServiceItem
		FROM     Workorder W, WorkOrderLine L
		WHERE    W.Workorderid   = L.WorkOrderId
		AND      L.WorkorderId   = '#getOrder.workorderid#'			
		AND      L.Workorderline = '#getOrder.workorderline#'
</cfquery>  

<!--- define the workorder id to which we connect the new line --->

<cfquery name="getCustomer"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId      = '#Object.ObjectKeyValue4#'	
		AND      WorkorderId    = '#getOrder.workorderid#'			
		AND      Workorderline  = '#getOrder.workorderline#'
		AND      Amendment      = 'Customer'
</cfquery>	

<cfif getCustomer.ValueTo eq "">
     <cfset cus = current.customerid>
<cfelse>
     <cfset cus = getCustomer.ValueTo>  
</cfif>

<!-- define the workorder id to which we connect the new line --->

<cfquery name="getService"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
		AND      WorkorderId   = '#getOrder.workorderid#'			
		AND      Workorderline = '#getOrder.workorderline#'
		AND      Amendment     = 'ServiceItem' 
</cfquery>	

<cfif getCustomer.ValueTo neq "" or getService.ValueTo neq "">

	<!--- MOVE to a different workorder because of a 
	    different customer or a different service 		
	--->
	
	<cfif cus eq "">
	    <cfset cus = "00000000-0000-0000-0000-000000000000">
	</cfif>
	
	<cfquery name="GetWorkorder" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		     SELECT   TOP 1 *
		     FROM     Workorder 
		     WHERE    CustomerId    = '#cus#'			
	         AND      ServiceItem   = '#getService.ValueTo#' 
			 ORDER BY Created DESC
	</cfquery>  
	
	<cfif getworkorder.recordcount gte "1">

			<!--- define the new workorder --->
			<cfset workorderidto = getWorkorder.workorderid>
			
	<cfelse>		
	
		<script>
			alert("Customer does not have the requested service authorised. Operation denied")
		</script>	
		<cfabort>  	
	
	</cfif>

<cfelse>

     <!--- no changes in customer --->
	<cfset workorderidto = current.workorderid>

</cfif>

<!--- change of service type --->

<cfquery name="getService"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
		AND      WorkorderId   = '#getOrder.workorderid#'			
		AND      Workorderline = '#getOrder.workorderline#'
		AND      Amendment = 'ServiceItem'
</cfquery>			

<!--- user --->

<cfquery name="getPerson"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
		AND      WorkorderId   = '#getOrder.workorderid#'			
		AND      Workorderline = '#getOrder.workorderline#'
		AND      Amendment = 'PersonNo'
</cfquery>	

<cfif getPerson.ValueTo eq "">

    <!--- we keep the same person 21/3/2012 adjustment --->
    <cfset per = current.personNo>

<cfelse> 

    <cfset per = getPerson.ValueTo>
	
</cfif>

<!--- retrieve the move of asset pointer --->

<cfquery name="getAsset"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
		AND      WorkorderId   = '#getOrder.workorderid#'			
		AND      Workorderline = '#getOrder.workorderline#'
		AND      Amendment = 'Asset'
</cfquery>		

<!--- retrieve the move to personal usage -> termination --->

<cfquery name="getPersonal"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
		AND      WorkorderId   = '#getOrder.workorderid#'			
		AND      Workorderline = '#getOrder.workorderline#'
		AND      Amendment     = 'Personal'
</cfquery>

<!--- perform a cfc posting function ---> 

<cfif getPersonal.recordcount eq "1"> 

    <!--- this is determined a termination --->
		
	<cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
	  	   method           = "ApplyTermination"   
		   requestid        = "#Object.ObjectKeyValue4#"	
		   effectivedate    = "#dateformat(get.DateEffective,CLIENT.DateFormatShow)#"
		   workorderid      = "#current.workorderid#"	
		   workorderline    = "#current.workorderline#">	

<cfelseif current.customerid  neq get.customerid or
          current.personno    neq getPerson.ValueTo or
	      current.serviceitem neq getService.ValueTo>
	  	  	  	  		 
		  <!--- perform a cfc posting movement function --->  
		  
		  <cfif current.serviceitem neq getService.ValueTo>
		       <cfset billing = "Y">
		  <cfelse>
		       <cfset billing = "N">
		  </cfif>  
		  	
		  <cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
			   method           = "ApplyTransfer" 
			   requestid        = "#Object.ObjectKeyValue4#"	
			   workorderid      = "#current.workorderid#"	
			   workorderline    = "#current.workorderline#"	 
			   workorderidTo    = "#workorderidto#" <!--- in case of customer or porting --->
			   effectivedate    = "#dateformat(get.DateEffective,CLIENT.DateFormatShow)#"
			   personno         = "#per#"
			   billing          = "#billing#"
			   assets           = "#getAsset.ValueTo#">	
		   			  
<cfelse>

		<script>
			alert("You have not made any changes. Operation denied (apply)")
		</script>	
		<cfabort>  	
	  
</cfif>

<!--- create a new entry in workorderline --->