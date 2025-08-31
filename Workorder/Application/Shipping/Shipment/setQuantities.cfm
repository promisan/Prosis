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
	WHERE   WorkorderItemId = '#url.workorderItemId#'	
</cfquery>  

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT  * 
	FROM    WorkOrder W, Customer C 
	WHERE   WorkorderId = '#get.workorderid#'
	AND     W.Customerid = C.CustomerId
</cfquery>  


<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
   method           = "InternalWorkOrder" 
   mission          = "#WorkOrder.Mission#" 
   Table            = "WorkOrderlineItem"
   workorderid      = "#get.WorkOrderId#"
   workorderline    = "#get.WorkOrderLine#"
   PointerSale      = "0" 
   mode             = "view" 
   returnvariable   = "NotEarmarked">	
   
<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
   method           = "InternalWorkOrder" 
   mission          = "#WorkOrder.Mission#" 
   Table            = "WorkOrderlineItem"
   workorderid      = "#get.WorkOrderId#"
   workorderline    = "#get.WorkOrderLine#"
   PointerSale      = "1"  
   mode             = "view"
   returnvariable   = "OtherEarmarked">	   

<cfquery name="getAmount" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT   		 
			 <!--- quantities received=1/produced=0/transferred=6 for this earmarked for this FP line 
			 													in particular workorderline  --->
             (SELECT     ISNULL(SUM(TransactionQuantity), 0)
               FROM      Materials.dbo.ItemTransaction T
               WHERE     RequirementId = I.WorkOrderItemId) AS Earmarked,
			 
			 <!--- onhand for not earmarked for other Sale workorders for the requested item --->		
			 				   
             (SELECT     ISNULL(SUM(TransactionQuantity), 0)
               FROM      Materials.dbo.ItemTransaction T
               WHERE     T.MIssion        = '#workorder.mission#' 	
			   AND       T.Warehouse      = '#url.warehouse#'  		   
			   AND       T.ItemNo         = I.ItemNo 
			   AND       T.TransactionUoM = I.UoM 
			   AND       (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))
			 ) AS OtherOnHand,  
			 
			  <!--- onhand for earmarked for other Sale workorders for the same requested item --->		
						 				   
             (SELECT     ISNULL(SUM(TransactionQuantity), 0)
               FROM      Materials.dbo.ItemTransaction T
               WHERE     T.Mission        = '#workorder.mission#' 			
			   AND       T.Warehouse      = '#url.warehouse#'   
			   <!--- to adjust to allow also similar items to be selected ?? --->
			   AND       T.ItemNo         = I.ItemNo 			   
			   <!--- 18/11 maybe we need to adjust to inherit based on the code and not on the UoM --->
			   AND       T.TransactionUoM = I.UoM 
			   AND       T.RequirementId IN (#preserveSingleQuotes(OtherEarmarked)#) ) 
			    AS OtherEarmarked,    
			 
			 <!--- quantities issued for this sales line --->  			   
			 
             (SELECT     ISNULL(SUM(TransactionQuantity*-1), 0)
               FROM      Materials.dbo.ItemTransaction
               WHERE     RequirementId = I.WorkOrderItemId AND TransactionType = '2') AS Shipped			   
			   
    FROM     WorkOrderLineItem I 	
	
	WHERE    I.WorkOrderItemId = '#url.workorderItemId#'	
	
</cfquery>	

<cfoutput>

<script language="JavaScript">
	document.getElementById('#url.workorderItemId#_earmarked').innerHTML = "#getAmount.Earmarked#"
	document.getElementById('#url.workorderItemId#_onhand').innerHTML    = "#getAmount.OtherOnHand#"
	document.getElementById('#url.workorderItemId#_other').innerHTML     = "#getAmount.OtherEarmarked#"
</script>

</cfoutput>