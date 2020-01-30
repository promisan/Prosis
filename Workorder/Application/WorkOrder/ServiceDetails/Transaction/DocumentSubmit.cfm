
<!--- validate the amounts etc. --->

<cfparam name="url.transactionid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderid"     default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline"   default="1">
<cfparam name="url.action"          default="">
<cfparam name="url.scope"           default="entry">

<cfif url.action eq "purge">

	<cfquery name="Update" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			DELETE  WorkOrderLineDetail			
			WHERE   TransactionId  = '#URL.transactionid#'									  
	</cfquery>		

<cfelse>
	
	<cfquery name="get" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrderLineDetail
			WHERE  TransactionId  = '#URL.transactionid#'						  
	</cfquery>		
	
	<cfif get.recordcount eq "1">
	 	<cfset url.workorderid   = get.workorderid>
		<cfset url.workorderline = get.workorderline>
	</cfif>
	
	<cfquery name="workorder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrder
			WHERE  WorkOrderId  = '#url.workorderid#'						  
	</cfquery>		
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#form.transactiondate#">
	<cfset DTE = dateValue>
			
	<cfif get.recordcount eq "0">
		  
			<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO WorkOrderLineDetail
			         (WorkOrderId,
					 WorkOrderLine,
					 ServiceItem,
					 ServiceItemUnit,
					 Reference,
					 DetailReference,
					 TransactionDate,					
					 Quantity,
					 Currency,
					 Rate,	
					 Source,					
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#url.workorderid#',
			          '#url.workorderline#',				        
					  '#workorder.ServiceItem#',
			          '#form.serviceitemunit#', 
					  '#form.reference#', 
					  '#form.DetailReference#',
					  #dte#,					 
					  '#form.quantity#',
					  '#form.currency#',
					  '#form.price#',						 
					  'Manual',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
			</cfquery>
			
	<cfelse>
	
						
		<cfquery name="Update" 
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				UPDATE WorkOrderLineDetail
				SET    ServiceItemUnit  = '#form.serviceitemunit#',
					   Reference       = '#form.reference#',
					   DetailReference = '#form.DetailReference#',
					   TransactionDate = #dte#,			
					   WorkOrderId     = '#url.workorderid#',		   
					   Quantity        = '#form.quantity#',
					   Currency        = '#form.currency#',
					   Rate            = '#form.price#'				
				WHERE  TransactionId  = '#URL.transactionid#'					  
		</cfquery>			
	
	</cfif>
	
	
</cfif>	

<cfoutput>

	<script>

		<cfif url.scope eq "entry">		
		
		    parent.applyfilter('1','','content') 
		    parent.ColdFusion.Window.destroy('mydialog',true)
				  
		<cfelseif url.scope eq "edit">		
		
		    parent.applyfilter('1','','#url.transactionid#') 
		    parent.ColdFusion.Window.destroy('adddetail',true)
			
		</cfif>	

	</script>
	
</cfoutput>


