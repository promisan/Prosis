<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset eff = dateValue>

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
  FROM   WorkOrderEvent
  WHERE  WorkOrderEventId = '#form.WorkOrderEventId#' 
</cfquery>

<cfif get.recordcount eq "1">

	   <cftransaction>

	   <cfquery name="Update" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE   WorkOrderEvent 
			  SET  EventReference = '#Form.EventReference#', 				 
				   EventDate      = #Eff#
			 WHERE WorkOrderEventId  = '#form.WorkOrderEventId#'
	    </cfquery>	
		
			
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
			    EntityCode       = "WrkEvent"
				EntityClass      = "Standard"
				EntityGroup      = ""
				EntityStatus     = ""
				Mission          = "#workorder.mission#"				
				ObjectReference  = "#Form.EventReference#"
				ObjectReference2 = "#serviceitem.description#" 			    
				ObjectKey4       = "#form.WorkOrderEventId#"
				AjaxId           = "#form.WorkOrderEventId#"
				ObjectURL        = "#link#"
				Reset            = "Limited"
				Show             = "No">	
					
<cfelse>

		<!--- remove baselines that are not completed --->
				
		<cfquery name="Insert" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO WorkOrderEvent
		         (WorkOrderId,
				 WorkOrderEventId,
				 EventReference,	
				 EventDate,		
				 OfficerUserId,
				 OfficerLastname,
				 OfficerFirstName)
		      VALUES
			     ('#URL.WorkOrderId#',
			      '#Form.WorkOrderEventId#',
				  '#Form.EventReference#',				 
				  #eff#,										 
		      	  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
			</cfquery>
			
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
				
			<cfset link = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#workorder.WorkOrderId#&selected=servicelevel">			
					
			<cf_ActionListing 
				    EntityCode       = "WrkEvent"
					EntityClass      = "#Form.EntityClass#"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#workorder.mission#"				
					ObjectReference  = "#Form.EventReference#"
					ObjectReference2 = "#serviceitem.description#" 			    
					ObjectKey4       = "#form.WorkOrderEventId#"
					AjaxId           = "#form.WorkOrderEventId#"
					ObjectURL        = "#link#"
					Reset            = "Limited"
					Show             = "No">	
						
				   	
</cfif>


<cfoutput>
<script>
  parent.parent.agreementrefresh('#url.tabno#','#url.workorderid#')
  parent.parent.ColdFusion.Window.destroy('mydialog',true)  
</script>
</cfoutput>

<script>
  returnValue = 2
  window.close()
</script>