
<cfquery name="get"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     Request
		WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
</cfquery>	

<cfquery name="getOrder"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrder
		WHERE    RequestId = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfquery name="getPersonFrom"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId      = '#Object.ObjectKeyValue4#'			
		AND      Amendment      = 'PersonNo'
</cfquery>	

<cfif get.DateExpiration neq "" AND
      get.DateExpiration gt get.DateEffective>
	  
	<cfset dt = "#dateformat(get.DateExpiration,CLIENT.DateFormatShow)#">  
 
<cfelse>

	<cfset dt = "#dateformat(now(),CLIENT.DateFormatShow)#">
	
</cfif>

<!--- Safeguard applied 10/4/2012 --->

<cfif getOrder.workorderidto neq "">

	<cfset returnfrom      =  getOrder.WorkorderIdTo>
	<cfset returnfromline  =  getOrder.WorkorderLineTo>
	<cfset returnto        =  getOrder.WorkorderId>

<cfelse>

	<cfset returnfrom      =  getOrder.WorkorderId>
	<cfset returnfromline  =  getOrder.WorkorderLine>
	
	<cfquery name="getOrder"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	SELECT   ParentWorkOrderId 		         
			FROM     WorkOrderLine
			WHERE    WorkOrderId   = '#getOrder.workorderid#'	
			AND      WorkOrderLine = '#getOrder.workorderline#'	
	</cfquery>		
	
	<cfset returnto        =  getOrder.ParentWorkOrderId>

</cfif>
		
<cfif returnto eq "">	

	<font face="Calibri" size="3" color="FF0000">There is no current return workorder available</font>

<cfelse>
	
	<!--- return to old order --->
	
	<cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
	   method           = "ApplyTransfer" 
	   mode             = "return"
	   requestid        = "#get.requestid#"	
	   workorderid      = "#returnfrom#"	
	   workorderline    = "#returnfromline#"	 
	   workorderidTo    = "#returnto#" 
	   effectivedate    = "#dt#"
	   personno         = "#getPersonFrom.ValueFrom#">	
   
</cfif>   