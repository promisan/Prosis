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

<style type="text/css">
 
 TD.headerline {
	padding : 2px; 
	font-size : 13px}
  
 </style>

<cfparam name="url.actionStatus" default="1">

<!--- issues --->

<cfoutput>

<cfsavecontent variable="condition">

	  <!--- clear or not cleared --->
	  
	  <cfif url.actionstatus eq "0">
	  <!--- status --->
	  AND        T.ActionStatus = '0'	  
	  <cfelse>
	  <!--- status --->
	  AND        T.ActionStatus = '1'	  
	  </cfif>	  
	 
	  <!--- villed or not billed --->
	  
	  <cfif url.actionstatus eq "1" or url.actionstatus eq "0">									

	   <!--- not billed yet --->
	   AND        T.TransactionId IN
	                             (
								  SELECT   TransactionId
	                              FROM     ItemTransactionShipping S
	                              WHERE    TransactionId = T.TransactionId 
								  AND      (
								            InvoiceId IS NULL 
								            OR 
											InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
										    )
								 )									 
									
	  
  	  <cfelseif url.actionstatus eq "2">
	  		  	  	  
		  <!--- invoice matched but status = 0 --->
		  AND        T.TransactionId IN
	                             (
								  SELECT   TransactionId
	                              FROM     ItemTransactionShipping S
	                              WHERE    TransactionId = T.TransactionId 
								  AND      InvoiceId IN (SELECT InvoiceId 
								                         FROM   Purchase.dbo.Invoice 
														 WHERE  InvoiceId = S.InvoiceId
														 AND    ActionStatus = '0')
								  )
								  
	  <cfelseif url.actionstatus eq "3">	
	  
	   <!--- invoice matched but status = 1 --->
		  AND        T.TransactionId IN
	                             (
								  SELECT   TransactionId
	                              FROM     ItemTransactionShipping S
	                              WHERE    TransactionId = T.TransactionId 
								  AND      InvoiceId IN (SELECT InvoiceId 
								                         FROM   Purchase.dbo.Invoice 
														 WHERE  InvoiceId = S.InvoiceId
														 AND    ActionStatus = '1')
								  )
	  
	   					  
	  
	  						  
	  </cfif>		
	  
</cfsavecontent>

</cfoutput>

<cfquery name="getSummary" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  
	  SELECT     WL.OrgUnitOperator,
	  
	             (SELECT OrgUnitName
                  FROM   Organization.dbo.Organization 
				  WHERE  OrgUnit = WL.OrgUnitOperator) as OperatorName,
	  
	             T.ItemDescription, 
				 T.ItemNo,
				 T.TransactionUoM,
				 U.UoMDescription, 
				 'Issuance' as Category,
				 'Issuance' as CategoryName,
				 <!---
				 C.Category,
				 C.Description as CategoryName, 
				 --->
                 SUM(- T.TransactionQuantity) AS TransactionQuantity, 
				 SUM(- T.TransactionValue) AS TransactionValue, 
				 COUNT(*) AS Lines
				 
				 
      FROM       ItemTransaction T 			  
				 INNER JOIN ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
				 INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
				 
	  <!---  removed the split by asset		 				 
				 
	  FROM       Item I
	  			 INNER JOIN Ref_Category C ON I.Category = C.Category
	             INNER JOIN AssetItem AI ON I.ItemNo = AI.ItemNo 
				 INNER JOIN ItemTransaction T ON AI.AssetId = T.AssetId
				 INNER JOIN ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
				 INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location --->	 

       <!--- selected warehouse / mission --->
	  WHERE      T.Mission     = '#url.mission#'
	  AND        T.Warehouse   = '#url.warehouse#'				
	   
	  <!--- filter on issuance transactions only to be billed --->	
			  		 
	  AND        T.TransactionType = '2' 
	  
	  <!--- only transactions for external --->
	  AND        T.BillingMode = 'External'
	  
	  AND        WL.OrgUnitOperator IN (SELECT OrgUnit 
	                                    FROM   Organization.dbo.Organization 
										WHERE  OrgUnit = WL.OrgUnitOperator) 	  
	  
	  #preservesinglequotes(condition)#	 
	 							  
	  GROUP BY   WL.OrgUnitOperator,
	  
	             <!---
	             C.Description, 
				 C.Category, --->
				 T.ItemNo,
			     T.ItemDescription, 
				 T.TransactionUoM,
			     U.UoMDescription
				  
	  
	  UNION	ALL		  
	  
	  <!--- transfer --->		   
				 				 
	  SELECT     WL.OrgUnitOperator,
	  
	             (SELECT OrgUnitName
                  FROM   Organization.dbo.Organization 
				  WHERE  OrgUnit = WL.OrgUnitOperator) as OperatorName,
	  
	             T.ItemDescription, 
				 T.ItemNo,
				 T.TransactionUoM,
				 U.UoMDescription, 
				 'Transfer' as Category, 
				 'Transfer' as CategoryName,
                 SUM(- T.TransactionQuantity) AS TransactionQuantity, 
				 SUM(- T.TransactionValue) AS TransactionValue, 
				 COUNT(*) AS Lines
				 
	  FROM       ItemTransaction T 			  
				 INNER JOIN ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
				 INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 	 

       <!--- selected warehouse / mission --->
	  WHERE      T.Mission     = '#url.mission#'
	  AND        T.Warehouse   = '#url.warehouse#'				 
	  
	  <!--- filter on issuance transactions only to be billed --->				  		 
	  AND        T.TransactionType = '8' AND T.TransactionQuantity < 0
	  		  
	  <!--- only transactions for external --->
	  AND        T.BillingMode = 'External'
	  
	  AND        WL.OrgUnitOperator IN (SELECT OrgUnit 
	                                    FROM   Organization.dbo.Organization 
										WHERE  OrgUnit = WL.OrgUnitOperator)
	  
  	  #preservesinglequotes(condition)#
	  
	  GROUP BY   WL.OrgUnitOperator,	             
				 T.ItemNo,
			     T.ItemDescription, 
				 T.TransactionUoM,
			     U.UoMDescription			 
		 
	  ORDER BY 	 WL.OrgUnitOperator,	             
				 T.ItemNo,
			     T.ItemDescription 						 
	  
</cfquery>		

<cfif getSummary.recordcount eq "0">
	<tr><td colspan="8" style="padding-top:15" align="center" class="label">There are no records to show in this view</td></tr>
</cfif>
	
<cfoutput query="getSummary" group="OrgUnitOperator">

		<tr>
		   <td></td><td colspan="7" style="padding-top:5px" class="verdana"><font size="2" color="808080">#OperatorName#</font></td>
		</tr>	
		
		<tr><td></td><td colspan="7" class="linedotted"></td></tr>
	
	<cfoutput>
				
		<tr>
		
		    <td height="17"></td>
			
			<td></td>
			
			<cfset name = "detail_#url.actionstatus#_#currentrow#">			
			<cfset link = "Warehouse/Application/Stock/Shipping/Summary/SummaryDetailBatch.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse=#url.warehouse#&itemno=#itemno#&uom=#transactionuom#&category=#category#&actionstatus=#url.actionstatus#&orgunit=#orgunitoperator#&box=#name#">
			
			<cfif url.actionstatus eq "0">
			
				<td style="cursor: pointer; padding-right:5px" 
				   onclick="drilldownbox('#name#','#link#','#client.VirtualDir#')">
									
					<img src="#SESSION.root#/Images/arrowright.gif" alt="Expand" 
						id="#name#_twistie"	height="12" border="0" class="regular" align="absmiddle">
													
				</td>
				
				<td class="labelit" 
			    onclick="drilldownbox('detail_#url.actionstatus#_#currentrow#','#link#','#client.VirtualDir#')" 
			    style="cursor:pointer">#CategoryName#</td>
			
			<cfelseif url.actionstatus eq "1">
			
				<td></td>					
				<td class="labelit" style="cursor:pointer"
				onclick="selectrow('menu','2','3');ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Stock/Shipping/PendingTransaction/Pending.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#','contentbox1')">
				<font color="0080C0">#CategoryName#</font></td>	
				
			<cfelse>
			
				<td></td>					
				<td class="labelit" style="cursor:pointer">#CategoryName#</td>				
			
			</cfif>			
			
			<td class="labelit" align="center">#Lines#</td>	
			<td class="labelit"><a href="javascript:item('#ItemNo#','#url.systemfunctionid#','#url.mission#')"><font color="0080C0">#ItemDescription#</font></a></td>
			<td class="labelit">#UoMDescription#</td>						
			<td class="labelit" align="right">#numberformat(TransactionQuantity,"__,__._")#</td>		
						
		</tr>
		
		<tr id="#name#_box" class="hide">
		    <td colspan="3"></td>
		    <td colspan="5" style="padding:5px" id="#name#_content"></td>		 
 	    </tr>
		
		<tr class="hide">
			<td>		
			<input type    = "button" 
			       id      = "#name#_refresh" 
				   name    = "#name#_refresh" 
				   onclick = "drilldownbox('#name#','#link#','#client.VirtualDir#','force')">
			</td>
		</tr>
			
	</cfoutput>		
		
</cfoutput>
