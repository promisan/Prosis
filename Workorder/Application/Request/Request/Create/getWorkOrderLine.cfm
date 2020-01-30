
<!--- show the line of the workorder --->

<cfparam name="url.requestid"         default="">
<cfparam name="url.workorderlineid"   default="">

<cfquery name="Serviceitem" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			 SELECT  *	
		     FROM    ServiceItem
			 WHERE  Code  = '#url.serviceitem#'	     	
	</cfquery>

<!--- current value --->

<cfif url.workorderlineid neq "">
		
	<cfquery name="Order" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			 SELECT  *	
		     FROM    WorkOrderLine
			 WHERE   WorkorderLineId   = '#url.workorderlineid#'	     	
	</cfquery>
	
	<cfquery name="Customer" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			 SELECT  C.*
		     FROM    WorkOrder W, Customer C
			 WHERE   W.CustomerId = C.CustomerId
			 AND     WorkorderId   = '#Order.WorkOrderId#'	     				 
	</cfquery>	
			
<cfelse>	

	<cfif url.requestid eq "">
	
		<!--- retrieve from initial passed from workorder --->
		
		<cfquery name="Order" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
				 SELECT  *	
			     FROM    WorkOrderLine
				 <cfif url.workorderid eq "">
				 WHERE 1= 0
				 <cfelse>
				 WHERE   WorkorderId   = '#url.workorderid#'	     	
				 AND     WorkorderLine = '#url.workorderline#'
				 </cfif>
	   </cfquery>
	
		<cfif url.workorderid neq "">
			<cfquery name="Customer" 
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">	
					 SELECT  C.*
				     FROM  Workorder W
					 INNER JOIN Customer C ON W.CustomerId = C.CustomerId
					 WHERE   W.WorkorderId   = '#url.workorderid#'	     	
		   </cfquery>		 
	   </cfif>
	   
	<cfelse>
	
		<cfquery name="Line" 
	    datasource="AppsWorkOrder" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT  *	
		    FROM    RequestWorkOrder								
			WHERE   Requestid     = '#url.requestid#'	
        </cfquery>
			
		<cfquery name="Order" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
				 SELECT *	
			     FROM   WorkOrderLine
				 <cfif Line.WorkorderLine eq "">
				 WHERE 1=0
				 <cfelse>
				 WHERE  WorkorderId   = '#Line.WorkOrderId#'	     
				 AND    WorkOrderLine = '#Line.WorkOrderLine#'
				 </cfif>			
		</cfquery>
				
		<cfquery name="Customer" 
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">	
				 SELECT  C.*
			     FROM  Workorder W
				 INNER JOIN Customer C ON W.CustomerId = C.CustomerId
				  <cfif Line.WorkorderLine eq "">
				 WHERE 1=0
				 <cfelse>
				 WHERE  WorkorderId   = '#Line.WorkOrderId#'	     				
				 </cfif>							     	
		 </cfquery>	
		
	</cfif>	
		
</cfif>

<table width="300" cellspacing="0" cellpadding="0">

<tr><td>
		
	</td>
	
	 <cfquery name="Format" 
		datasource="appsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ServiceItemDomain
			WHERE  Code = '#serviceitem.serviceDomain#'			
	</cfquery>
   
   <cfif Format.displayformat eq "">
		<cfset val = Order.reference>
	<cfelse>
	    <cf_stringtoformat value="#Order.reference#" format="#Format.DisplayFormat#">						
	</cfif>

	<td width="100%" style="padding-left:3px;padding-top:0px;padding-bottom:0px;height:25px;border: 1px solid Silver;">
	<cfoutput query="Order">
	#val#
	</cfoutput>	
	</td>
	
	<cfif url.workorderlineid neq "">	
	<td style="padding-left:4px;padding-right:4px;padding-top:1px;padding-bottom:0px;height:25px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	<cfoutput>
	<img src="#SESSION.root#/images/locate3.gif" height="17" width="17" alt="" border="0" onclick="editworkorderline(document.getElementById('workorderlineid').value)">
	</cfoutput>
	</td>
	
	</cfif>
		
</tr>

</table>

<cfif order.workorderlineid neq "">
	
	<cfoutput>
		<script>	 	
		  ColdFusion.navigate('getUnit.cfm?orgunit=#customer.orgunit#','unit')
		  document.getElementById('workorderlineid').value = '#Order.WorkorderLineId#'	  
		  se = document.getElementById('requesttype')		   
		  loadcustomform('#url.requestid#',se.value,'#url.serviceitem#','#url.accessmode#','#Order.WorkorderLineId#','')
		</script>
	</cfoutput>

</cfif>
	