<!--
    Copyright © 2025 Promisan

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

<!--- save the delivery request 

Allow to select the type of workorder : delivery and class for the modality <br>

- Transfer to shipper 
- Delivery internal
- Orgunit that performs : orgunitimplementer
- OrgUnit that triggers => warehouse orgunit

first we check if the customer exists in workorder and will add the record 
the we record workorder and workorder line 
and create an action

then we show the workflow object 

--->

<cfparam name="url.BatchId" default="">

<cfquery name="get"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT *
			FROM WarehouseBatch
			WHERE BatchId = '#url.BatchId#'
</cfquery>	

<cfinvoke component     = "Service.Process.WorkOrder.Delivery"  
	   method               = "addDelivery" 
	   batchid              = "#url.BatchId#" 
	   Memo                 = "#form.Packaging#"
	   Comments             = "#form.Comments#"
	   servicedomain        = "DEL" 
	   domainclass          = "#form.domainclass#"
	   actionclassdelivery  = "Delivery"
	   addressid            = "#form.addressid#"
	   deliverydate         = "#form.DateEffective#"
	   returnvariable       = "workorder">	   
		   
	<cfquery name="get"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			  	SELECT    *
				FROM      WorkOrderLineAction
				WHERE     WorkOrderid = '#url.BatchId#' 
				AND       WorkOrderLine = '1' 
				AND       ActionClass = 'Delivery'		
	</cfquery>	
				
    <cfset url.ajaxid = get.WorkActionId>
	<cfparam name="url.mid" default="">
	<cfset wflnk = "#session.root#/Warehouse/Application/Stock/Delivery/DeliveryWorkflow.cfm">
	<input type="hidden" id="workflowlink_#url.ajaxid#" value="#wflnk#"> 
    <cfdiv id="#url.ajaxid#"  bind="url:#wflnk#?ajaxid=#url.ajaxid#&mid=#url.mid#"/>   
   
<script>
	Prosis.busy('no')
</script>    
   
   
     
   



