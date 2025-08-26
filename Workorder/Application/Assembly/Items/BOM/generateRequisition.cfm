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


<cfset FileNo = round(Rand()*30)>
<CF_DropTable dbName="AppsQuery" tblName="itemList#SESSION.acc#" range="30">  

 
<!--- generate BOM procurement requisition  for supply items --->

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *  
		FROM     Workorder W,WorkOrderLine WL, ServiceItemMission S
		WHERE    W.WorkOrderId    = WL.WorkOrderId
		AND      W.ServiceItem    = S.ServiceItem
		AND      S.Mission        = W.Mission
		AND      WL.WorkOrderId   = '#url.workorderid#' 
		AND      WL.WorkOrderLine = '#url.workorderline#'
</cfquery>	

<!--- -------------------------------------------------------------------- --->
<!--- just a batch clean requisitionline that have not been processed yet- --->
<!--- -------------------------------------------------------------------- --->

<!--- commented out 11/30/2015 by dev , requested by Carolina 
<cfquery name="reset" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Purchase.dbo.RequisitionLine P
		WHERE    WorkOrderId   = '#url.workorderid#' 
		AND      WorkOrderLine = '#url.workorderline#'
		<!--- finished product --->
		AND      RequirementId IN (SELECT WorkOrderItemId 
		                           FROM   WorkOrderLineItem 
								   WHERE  WorkOrderId = P.WorkOrderId)		        
		AND      ActionStatus <= '1'
</cfquery>	

<cfloop query="reset">
	
	<cfquery name="delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Purchase.dbo.RequisitionLine
		WHERE  RequisitionNo = '#requisitionno#'
	</cfquery>

</cfloop>

----->

<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
	   method           = "InternalWorkOrder" 
	   datasource       = "AppsMaterials"
	   mission          = "#WorkOrder.Mission#" 
	   workorderid      = "#url.WorkOrderId#"
       workorderline    = "#url.WorkOrderLine#"
	   Table            = "WorkOrderLineResource"
	   mode             = "view"
	   returnvariable   = "NotEarmarked">	

<!--- -------------------------------------------------------------------- --->
<!--- -------------------------------------------------------------------- --->
<!--- -------------------------------------------------------------------- --->

<cfquery name="ItemList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
							
		SELECT     NEWID() as ListId,
				   WIR.WorkOrderId,
		           WIR.WorkOrderLine, 
				   WIR.ResourceId,
				   WIR.ResourceItemNo, 
				   WIR.ResourceUoM, 
				   I.ItemDescription, 
				   I.Classification,
				   I.Category,
				   I.ItemClass,
				   I.ItemMaster,
				   WIR.ResourceReference,
				   WIR.Memo,				   
				   UoM.UoMDescription, 
				   Quantity, 
				   Price  AS CostPrice, 
		           Amount AS Cost,
		           
		           (SELECT   ISNULL(SUM(RequestQuantity), 0)
		            FROM     Purchase.dbo.RequisitionLine
		            WHERE    Mission = '#url.mission#' AND  RequirementId   = WIR.ResourceId 				                                  
													   AND  WorkOrderId     = WIR.WorkOrderId 
													   AND  WorkOrderLine   = WIR.WorkOrderLine
													   AND  ActionStatus   != '9' 
													   AND  ActionStatus >= '1') AS Procurement,

		           (SELECT   ISNULL(SUM(RequestQuantity), 0)
		            FROM     Purchase.dbo.RequisitionLine
		            WHERE    Mission = '#URL.Mission#' AND  WorkOrderId     = WIR.WorkOrderId 
													   AND  WorkOrderLine   = WIR.WorkOrderLine
													   AND  WarehouseItemNo = WIR.ResourceItemNo
													   AND  WarehouseUoM    = WIR.ResourceUoM 
													   AND  ActionStatus    < '3'
													   AND  ActionStatus    > '0') AS QtyRequested,				   

					(SELECT  ISNULL(SUM(PL.OrderQuantity), 0)   
					FROM        Purchase.dbo.RequisitionLine RL INNER JOIN
					                      Purchase.dbo.PurchaseLine PL ON RL.RequisitionNo = PL.RequisitionNo
					WHERE     	RL.Mission = '#URL.Mission#' 
								AND RL.ActionStatus = '3' 
								AND WorkOrderLine 	= WIR.WorkOrderLine
								AND WorkorderId 	= WIR.WorkOrderId
								AND WarehouseItemNo = WIR.ResourceItemNo
								AND WarehouseUoM 	= WIR.ResourceUoM 
								AND PL.ActionStatus <> '9' 
								AND PL.DeliveryStatus <> '3') AS QtyOrdered,

				   
				   <!--- ----------------------------------------------------------------------------------------------- --->
				   <!--- HAS TO BE REVISTED AS WE WORK NOW different which casues several limes on the requirement level --->
				   
		           (SELECT   ISNULL(SUM(TransactionQuantity), 0)
		            FROM     Materials.dbo.Itemtransaction
		            WHERE    Mission = '#url.mission#' AND  ItemNo          =  WIR.ResourceItemNo 
					                                   AND  TransactionUoM  =  WIR.ResourceUoM
													   AND  TransactionType =  '1' 
													   AND  WorkOrderId     =  WIR.WorkOrderId 
													   AND  WorkOrderLine   =  WIR.WorkOrderLine) AS Received,
													   
				
				
				   <!--- a regular stock query to reflect possible stock 
			                               available for this item in this mission --->	
										   
				   ( SELECT  ISNULL(SUM(TransactionQuantity),0)
		             FROM    Materials.dbo.Itemtransaction T
		             WHERE   Mission        = '#url.mission#' 
					 AND     ItemNo         = WIR.ResourceItemNo 
		             AND     TransactionUoM = WIR.ResourceUoM
					 
					 <!--- approved transaction, but issuance we take immediately --->
					 
					 AND     (
					          (ActionStatus = '1' and TransactionType != '2') OR (ActionStatus  IN ('0','1') and TransactionType = '2')
						     )		
							 
					 AND    (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))) AS OnHand			
			 
			 <!---									   
				   
		           (SELECT  ISNULL(SUM(TransactionQuantity), 0)
		            FROM    Materials.dbo.Itemtransaction
		            WHERE   Mission = '#url.mission#'  AND  ItemNo         = WIR.ResourceItemNo 
											           AND  TransactionUoM = WIR.ResourceUoM) AS Onhand
													   
													   --->
													   
				   <!--- ----------------------------------------------------------------------------------------------- --->
				   <!--- ----------------------------------------------------------------------------------------------- --->								   
		INTO    userquery.dbo.itemList#SESSION.acc#_#fileno#								
		FROM         WorkOrderLineResource WIR 
					 INNER JOIN  Materials.dbo.Item I      ON WIR.ResourceItemNo = I.ItemNo 
					 INNER JOIN  Materials.dbo.ItemUoM UoM ON WIR.ResourceItemNo = UoM.ItemNo AND WIR.ResourceUoM = UoM.UoM 
	
		WHERE        WIR.WorkOrderId   = '#url.workorderid#' 
		AND          WIR.WorkOrderLine = '#url.workorderline#'
		AND          I.Category = '#url.category#'
		
		<!--- only items that indeed need procurement --->
		
		AND          WIR.ResourceMode  = 'Purchase'		
		AND          I.ItemClass IN ('Supply','Service')				
				 
</cfquery>		

<cfquery name="List" datasource="AppsQuery" >
		SELECT * 
		FROM userquery.dbo.itemList#SESSION.acc#_#fileno# 
</cfquery>	

<table width="100%" class="formpadding">

<cfoutput>

        <tr><td colspan="10" style="height:50px;font-size:23px" class="labellarge"><font color="808080"><cf_tl id="Procurement of BOM items required for the fullfilment of the ordered products"></td></tr>

		<tr class="labelmedium">
			<td width="5%"></td>
			<td width="5%">Category</td>
			<td width="5%">UoM</td>
			<td width="5%">Class</td>			
			<td width="40%">Description</td>
			<td align="right" width="6%">Required</td>
			<td align="right" width="6%">On Hand</td>
			<td align="right" width="6%">Requested</td>			
			<td align="right" width="6%">Ordered</td>			
			
			<td align="right" width="6%">Received</td>		
		</tr>
				
		<tr class="line">
			<td colspan="8"></td>
		</tr>
			
		<cfloop query="list">
		
			<tr class="labelmedium line">
				<cfset sListId=Replace(ListId,"-","","all")>
				<td><input type="checkbox" value="'#ListId#'" name="listId" id="listId" onclick="setEnableQty('#sListId#')"></td>
				<td>#Category#</td>
				<td>#ResourceUoM#</td>
				<td>#Classification#</td>	
				<td>#ItemDescription#</td>
				<td align="right" bgcolor="DAF9FC" style="border-left:1px solid silver;padding-right:2px">
					<div id="d_#sListId#" style="padding-top:4px" class="regular labelmedium">
						#NumberFormat(Quantity,"_,_._")#
					</div>	
					<div id="t_#sListId#" class="hide" style="padding-left:5px">
						<input class="regularxl"  type="text" value="#NumberFormat(Quantity,"_,_._")#" name="listQty_#sListId#" id="listQty_#sListId#" size= "8" style="text-align:right;">
					</div>
				</td>
				<td style="border-left:1px solid silver;padding-right:2px" align="right">#NumberFormat(OnHand,"_,_._")#</td>
				<td style="border-left:1px solid silver;padding-right:2px" align="right">#NumberFormat(QtyRequested,"_,_._")#</td>				
				<td style="border-left:1px solid silver;padding-right:2px" align="right">#NumberFormat(QtyOrdered,"_,_._")#</td>
				
				<td style="border-left:1px solid silver" align="right">#NumberFormat(Received,"_,_._")#</td>		
			</tr>	
		
		</cfloop>
		
		<tr>
			<td></td>
			<td colspan="7" align="center" style="padding-top:4px">
					<button type="button" onclick="createBatchRequisitions('#fileNo#','#URL.SystemFunctionId#')"
			  				style="width:250px;height:49px;font-size:14px" class="button10g"><cf_tl id="Generate Procurement requisitions"></button>					
			</td>
		</tr>		
	
</cfoutput>	
</table>	
		
