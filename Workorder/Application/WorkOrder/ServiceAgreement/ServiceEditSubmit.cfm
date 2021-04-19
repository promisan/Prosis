
<cfparam name="Form.TransactionReference"  default="">
<cfparam name="Form.TransactionMemo"       default="">
<cfparam name="Form.TransactionQuantity"   default="0">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset eff = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateExpiration#">
<cfset exp = dateValue>

<cfquery name="workorder" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrder
  WHERE  WorkOrderId = '#URL.workorderId#'
</cfquery>

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrderBaseLine
  WHERE  TransactionId = '#form.TransactionId#' 
</cfquery>

<cfif get.recordcount eq "1">

	   <cftransaction>

	   <cfquery name="Update" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE   WorkOrderBaseLine 
			  SET  TransactionReference = '#Form.TransactionReference#', 				 
				   DateEffective        = #Eff#,
				   DateExpiration       = #Exp#,
				   TransactionMemo      = '#Form.TransactionMemo#'
				   <!--- TransactionQuantity  = '#Form.TransactionQuantity#', --->
				   <!--- TransactionAmount    = '#Form.TransactionAmount#'	  --->
			 WHERE TransactionId  = '#form.TransactionId#'
	    </cfquery>	
		
		<cfquery name="clear" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  DELETE  FROM   WorkOrderBaseLineDetail
		  WHERE   TransactionId  = '#form.TransactionId#'		 	  		 
		</cfquery>		
						
		<cfquery name="unitlist" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   ServiceItemUnit
		  WHERE  ServiceItem = '#workorder.serviceitem#'
		  AND    BaseLineMode = 1		  		 
		</cfquery>		
		
		<cfloop query="unitlist">
		
		    <cfparam name="form.#unit#_qty" default="">
			<cfparam name="form.#unit#_rte" default="">
			
			<cfset qty = evaluate("form.#unit#_qty")>
			<cfset rte = evaluate("form.#unit#_rte")>
			
			<cfif qty gt "0">
			
			<cfquery name="Insert" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO WorkOrderBaseLineDetail 
			         (TransactionId,
					 ServiceItem,				
					 ServiceItemUnit,
					 Quantity,
					 Rate,
					 OfficerUserId,
					 OfficerLastname,
					 OfficerFirstName)
			      VALUES
				     ('#form.TransactionId#',
					  '#serviceitem#',
					  '#unit#',				 										
					  '#qty#',
					  '#rte#',	
			      	  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
				</cfquery>	
				
			  </cfif>		
		
		</cfloop>
		
			
		</cftransaction>	
		
		<!--- workflow --->
								
		<cfquery name="workorder" 
		datasource="appsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  WorkOrder
			WHERE WorkOrderId = '#URL.WorkOrderId#'
		</cfquery>		
		
		<cfquery name="serviceitem" 
		datasource="appsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  ServiceItem
			WHERE Code = '#workorder.serviceitem#'
		</cfquery>
			
		<cfset link = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#url.WorkOrderId#&selected=servicelevel">			
				
		<cf_ActionListing 
			    EntityCode       = "WrkAgreement"
				EntityClass      = "Standard"
				EntityGroup      = ""
				EntityStatus     = ""
				Mission          = "#workorder.mission#"				
				ObjectReference  = "#Form.TransactionReference#"
				ObjectReference2 = "#serviceitem.description#" 			    
				ObjectKey4       = "#form.transactionid#"
				AjaxId           = "#form.transactionid#"
				ObjectURL        = "#link#"
				Reset            = "Limited"
				Show             = "No">	
					
<cfelse>

		<!--- remove baselines that are not completed --->
		
		<cfquery name="delete" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM WorkOrderBaseLine 
		      WHERE WorkOrderId = '#URL.WorkOrderId#'
			  AND  DateEffective = #eff#
			  AND  ActionStatus < '3'
			</cfquery>
				
		<cfquery name="Insert" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO WorkOrderBaseLine 
		         (WorkOrderId,
				 TransactionId,
				 TransactionReference,				
				 TransactionMemo,
				 DateEffective,		
				 DateExpiration,						
				 OfficerUserId,
				 OfficerLastname,
				 OfficerFirstName)
		      VALUES
			     ('#URL.WorkOrderId#',
			      '#form.TransactionId#',
				  '#Form.TransactionReference#',
				  '#Form.TransactionMemo#',				 
				  #eff#,	
				  #exp#,											 
		      	  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
			</cfquery>
			
			<cfquery name="unitlist" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM   ServiceItemUnit
			  WHERE  ServiceItem = '#workorder.serviceitem#'
			  AND    BaseLineMode = 1		  		 
			</cfquery>		
			
			<cfloop query="unitlist">
			
			    <cfparam name="form.#unit#_qty" default="">
				<cfparam name="form.#unit#_rte" default="">
				
				<cfset qty = evaluate("form.#unit#_qty")>
				<cfset rte = evaluate("form.#unit#_rte")>
				
				<cfif qty gt "0">
				
					<cfquery name="Insert" 
					     datasource="AppsWorkOrder" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO WorkOrderBaseLineDetail 
					         (TransactionId,
							 ServiceItem,				
							 ServiceItemUnit,
							 Quantity,
							 Rate,
							 OfficerUserId,
							 OfficerLastname,
							 OfficerFirstName)
					      VALUES
						     ('#form.TransactionId#',
							  '#serviceitem#',
							  '#unit#',				 										
							  '#qty#',
							  '#rte#',	
					      	  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
					</cfquery>	
					
				  </cfif>		
			
			</cfloop>
			
			<!--- workflow --->
								
			<cfquery name="workorder" 
			datasource="appsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  WorkOrder
				WHERE WorkOrderId = '#form.transactionid#'
			</cfquery>		
			
			<cfquery name="serviceitem" 
			datasource="appsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  ServiceItem
				WHERE Code = '#workorder.serviceitem#'
			</cfquery>
				
			<cfset link = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#workorder.WorkOrderId#&selected=servicelevel">			
					
			<cf_ActionListing 
				    EntityCode       = "WrkAgreement"
					EntityClass      = "#Form.EntityClass#"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#workorder.mission#"				
					ObjectReference  = "#Form.TransactionReference#"
					ObjectReference2 = "#serviceitem.description#" 			    
					ObjectKey4       = "#form.transactionid#"
					AjaxId           = "#form.transactionid#"
					ObjectURL        = "#link#"
					Reset            = "Limited"
					Show             = "No">						
				   	
</cfif>

<cfoutput>
<script>
  parent.parent.agreementrefresh('#url.tabno#','#url.workorderid#')
  parent.parent.ProsisUI.closeWindow('mydialog')  
</script>
</cfoutput>