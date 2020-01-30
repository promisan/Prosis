
<cfquery name="get" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT W.*	
     FROM   WorkOrderLine W, RequestWorkorder R
	 WHERE  R.Requestid     = '#url.requestid#'			
	 AND    W.WorkorderId   = R.WorkOrderId	     
	 AND    W.WorkOrderLine = R.WorkOrderLine			 		
</cfquery>

<cfif get.recordcount gte "1">
	
	<cfquery name="wo" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT *	
	     FROM   WorkOrder W,
				ServiceItem S
		 WHERE  W.ServiceItem = S.Code		
		 AND    W.Workorderid = '#get.workorderid#'		 	 		
	</cfquery>
	
	<cfquery name="domain" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT *	
	     FROM   Ref_ServiceItemDomain 
		 WHERE  Code = '#wo.servicedomain#'				 	 		
	</cfquery>
		
	<cfoutput>
	   <a href="javascript:editworkorderline('#get.workorderlineid#')">
	   <font color="0080FF" size="2"><b>		  
	   <cf_stringtoformat value="#get.reference#" format="#domain.DisplayFormat#">	
		#val#   
	   </font>
	   </a>
	</cfoutput>   
	
<cfelse>

	<cf_compression>	 

</cfif>  

