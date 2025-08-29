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
    FROM     WorkOrder
	WHERE    WorkOrderId = '#url.workorderid#'	
</cfquery>	   
<cfset count = 0>
<cfset total = 0>

<cfparam name="url.mode" default="stock">

<cfif url.mode eq "stock" or url.mode eq "overdraw">
		
	<!--- quantity based --->
	
	<cfquery name="getLines" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    SELECT     U.ItemUoMId,			
				   T.Location, 			  
				   PL.TransactionLotSerialNo,
				   SUM(TransactionQuantity) as OnHand
				   
	    FROM       Materials.dbo.ItemTransaction T INNER JOIN               	           
	               Materials.dbo.ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN
				   Materials.dbo.ProductionLot PL ON T.Mission = PL.Mission AND T.TransactionLot = PL.TransactionLot 
				   
	    WHERE      T.Mission        = '#get.mission#' 
		AND        T.Warehouse      = '#url.warehouse#'		
		AND        T.WorkOrderId    = '#url.workorderid#'	
				
		GROUP BY   T.Location, 
				   U.ItemUoMId,
				   PL.TransactionLotSerialNo 			 		   
				   
	</cfquery>
	
	<cfloop query="getLines">
	
		<cfset id = replace(ItemUoMId,"-","","ALL")>
		
		<cfparam name="ship_#id#_#location#_#TransactionlotSerialNo#" default="0">
		
		<cfset shipment = evaluate("ship_#id#_#location#_#TransactionlotSerialNo#")>
		
		<cfset amt = replaceNoCase(shipment,",","","ALL")> 
		<cfset amt = replaceNoCase(amt," ","","ALL")> 
				
		<cfif LSIsNumeric(amt)>
		
			<cfif amt neq "0">
			
			    <cfif url.mode eq "stock">
					
					<cfif amt lte onhand>
						<cfset total = total + amt>
						<cfset count = count+1>
					<cfelse>
					    <cfoutput>
						<script language="JavaScript">		  
						  alert("Problem :\n\nQuantity [#amt#] exceeds the earmarked quantity.\n\nResetting to its maximum : #onhand#")
						  document.getElementById('ship_#id#_#location#_#TransactionlotSerialNo#').value = '#OnHand#'		  
						</script>	
						</cfoutput>
						<cfset total = total + onhand>
						<cfset count = count+1>
					</cfif>	
				
				</cfif>
			
			</cfif>
			
		<cfelse>
		
			<cfoutput>
			<script language="JavaScript">		  
			  document.getElementById('ship_#id#_#location#_#TransactionlotSerialNo#').value = ''		  
			</script>			
			</cfoutput>
			
		</cfif>	
		
	</cfloop>	
	
<cfelse>
	
	<cfquery name="getLines" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TransactionId, 
		          TransactionQuantity 						         
		FROM      ItemTransaction T
		WHERE     T.Mission        = '#get.mission#'
		AND       T.Warehouse      = '#url.warehouse#'
		AND       T.WorkOrderId    = '#url.workorderid#'												
		AND       T.TransactionIdOrigin IS NULL 		
		GROUP BY  TransactionId,
		          TransactionQuantity 		          
		
		<!--- transaction was not depleted yet --->
		
		HAVING    TransactionQuantity +
                            (SELECT     ISNULL(SUM(TransactionQuantity), 0)
                             FROM       ItemTransaction
                             WHERE      TransactionidOrigin = T.TransactionId) > 0
	
	</cfquery>
	
	<cfloop query="getLines">
	
		<cfset id = replace(TransactionId,"-","","ALL")>
		<cfparam name="form.ship_#id#" default="0">
		<cfset shipment = evaluate("form.ship_#id#")>
			
		<cfset amt = replaceNoCase(shipment,",","","ALL")> 
		<cfset amt = replaceNoCase(amt," ","","ALL")> 
		
		<cfif LSIsNumeric(amt)>
				
			<cfif shipment neq 0>
				<cfset total = total + amt>
				<cfset count = count+1>
			</cfif>	
			
		</cfif>	
		
	</cfloop>	

</cfif>	

<cfoutput>#total# (#count#)</cfoutput>