<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineItem
		WHERE   WorkOrderItemId = '#url.workorderitemid#'		
</cfquery>
	
<cfquery name="validate" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineItemResource
		<cfif url.workorderitemidResource eq "">
		WHERE  1=0
		<cfelse>
		WHERE   WorkOrderItemIdResource = '#url.WorkOrderItemIdResource#'
		</cfif>		
</cfquery>

<cfparam name="Form.Apply" default="0">
	
<cfif validate.recordCount eq 0>
		
		<cfquery name="validate" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WorkOrderLineItemResource (
						WorkOrderItemIdResource,
						WorkOrderItemId,
						OrgUnit,
						ResourceItemNo,
						ResourceUoM,
						Reference,
						Quantity,
						Price,
						Memo,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )
				VALUES ('#form.IdResource#',
				        '#url.WorkOrderItemId#',
						'#Form.orgUnit#',
						'#Form.ItemNo#',
						'#Form.UoM#',
						'#Form.Reference#',
						#Replace(Form.Quantity,",","","ALL")#,						
						#Replace(Form.Price,",","","ALL")#,
						'#LEFT(Form.Remarks,100)#',
						'#session.acc#',
						'#session.last#',
						'#session.first#' )		
		</cfquery>
			
<cfelse>	
	
	<!--- check if the new combination exists already  --->
	
	<cfquery name="check" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM 	WorkOrderLineItemResource
			WHERE   WorkOrderItemId          = '#validate.WorkOrderItemId#'
			AND     OrgUnit                  = '#FORM.OrgUnit#'	
			AND     ResourceItemNo           = '#FORM.ItemNo#'
			AND 	ResourceUoM              = '#FORM.UoM#'    
			AND		Reference                = '#FORM.Reference#'
			AND     WorkOrderItemIdResource != '#url.WorkOrderItemIdResource#'	
	</cfquery>		
	
	<cfif check.recordcount eq "1">
	
		<!--- we remove it ---> 
		
		<cfquery name="delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  FROM WorkOrderLineItemResource
			WHERE 	WorkOrderItemIdResource = '#check.WorkOrderItemIdResource#'							
		</cfquery>		
	
	</cfif>
	
	<!--- we can safely update existing entry --->
	
	<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				UPDATE	WorkOrderLineItemResource
				SET		ResourceItemNo   = '#Form.ItemNo#',
						ResourceUoM      = '#Form.UoM#',    
						Reference        = '#FORM.Reference#',  
						Quantity         = #Replace(Form.Quantity,",","","all")#,
						Price            = #Replace(Form.Price,",","","all")#,
						OrgUnit          = '#FORM.OrgUnit#',					
						Memo             = '#LEFT(FORM.Remarks,100)#'
				WHERE   WorkOrderItemIdResource = '#url.WorkOrderItemIdResource#'			
	</cfquery>	
	
		
	<cfif form.apply eq "1">
	
		<!--- inherit the change to any item in the bom for this workorder line --->
	
		<cfquery name="update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					UPDATE	WorkOrderLineItemResource
					SET		ResourceItemNo   = '#Form.ItemNo#',
							ResourceUoM      = '#Form.UoM#',    
							Reference        = '#FORM.Reference#',  							
							Price            = #Replace(Form.Price,",","","all")#,
							OrgUnit          = '#FORM.OrgUnit#',					
							Memo             = '#LEFT(FORM.Remarks,100)#'
					WHERE   WorkorderItemId IN (SELECT WorkorderItemId
												FROM   WorkOrderlineItem
												WHERE  WorkOrderId      = '#get.WorkOrderId#'
												AND    WorkOrderLine    = '#get.WorkorderLine#')
												
					AND     WorkOrderItemIdResource != '#url.WorkOrderItemIdResource#'		
					AND     ResourceItemNo  = '#Validate.ResourceItemNo#'	
					AND     ResourceUoM     = '#Validate.ResourceUoM#'					
		</cfquery>	
		
	</cfif>
			
</cfif>

<!--- sync the BOM table on the higher level --->
				
<cfinvoke component="Service.Process.WorkOrder.WorkOrderLineItem" 
	  method		      = "SyncWorkOrderLineResource" 
      workorderid 	      = "#get.WorkOrderId#" 
	  workorderline       = "#get.WorkOrderLine#">

<cfoutput>  
<script>
	<cfif form.apply eq "0">
	    parent.editResourceRefresh('3','#url.workorderitemid#','','')
		parent.ColdFusion.Window.destroy('mysupply',true)
	<cfelse>
	    parent.editResourceRefresh('2','','#get.WorkOrderId#','#get.WorkorderLine#')
		parent.ColdFusion.Window.destroy('mysupply',true)
	</cfif>
	
</script>
</cfoutput>
