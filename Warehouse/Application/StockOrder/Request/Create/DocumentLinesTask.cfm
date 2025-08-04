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

<cfparam name="url.itemlocationid" default="">

<!--- remove invalid records --->

<cfquery name="remove" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	DELETE FROM  RequestTask
	WHERE    RequestId = '#url.requestid#'
	<!--- only valid tasks --->
	AND      RecordStatus = '0'
</cfquery>

<cfquery name="Tasked" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *,
	
			 (  SELECT  Reference 
			    FROM    TaskOrder 
				WHERE   StockorderId = RT.StockOrderId 
			 ) as TaskOrderReference,
				        
			 (  SELECT  ISNULL(SUM(TransactionQuantity),0)
                FROM    ItemTransaction S
	 			WHERE   RequestId    = RT.RequestId									
				AND     TaskSerialNo = RT.TaskSerialNo					 		
				AND     TransactionQuantity > 0													 
				AND     ActionStatus != '9' ) as Shipped	
			
			
	FROM     RequestTask RT
	WHERE    RequestId = '#url.requestid#'
	<!--- only valid tasks --->
	AND      (RecordStatus = '1' or recordstatus = '3')
</cfquery>

<cfif tasked.recordcount eq "0">
	
	<table width="100%" cellspacing="0" cellpadding="0"><tr><td align="center" class="labelit">
		<cf_tl id="No task order was prepared for this line.">
	</td></tr>
	<tr><td class="labelit"></td></tr>
	</table>

<cfelse>
	
	<table width="100%" border="0" class="formpadding" cellspacing="0" cellpadding="0">
	
	<cfif url.itemlocationid eq "">
	
		<tr bgcolor="eaeaea">			 	 
		 <td height="20" class="labelit" width="30%" colspan="2" style="border:1px solid silver;padding-left:5px"><cf_tl id="Issuance by"></td>
		 <td style="border:1px solid silver;padding-left:4px" width="120" class="labelit"><cf_tl id="Order"></td>
		 <td style="border:1px solid silver;padding-left:4px" width="90" class="labelit" colspan="2"><cf_tl id="Mode"></td>				
		 <td style="border:1px solid silver;padding-left:4px" width="10%" class="labelit"><cf_tl id="Location"></td>
		 <td style="border:1px solid silver;padding-left:4px" width="10%" class="labelit"><cf_tl id="Processed by"></td>
		 <td style="border:1px solid silver;padding-left:4px" width="90" class="labelit"><cf_tl id="Task date"></td>
		 <td style="border:1px solid silver;padding-left:4px" class="labelit" width="100"><cf_tl id="Quantity"></td>		
		 <td style="border:1px solid silver;padding-left:4px" class="labelit" width="100"><cf_tl id="Shipped"></td>	
		 <td style="border:1px solid silver;padding-left:4px" align="center" class="labelit" width="2%"><cf_tl id="S"></td>
		</tr>		
		
		<tr><td colspan="11" class="linedotted"></td></tr>
		
	</cfif>
	
	<cfoutput query="tasked">
	
		<tr>				
			
			<cfif tasktype eq "purchase">
								
				<cfquery name="Purchase" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT   *
					FROM     PurchaseLine
					WHERE    RequisitionNo = '#sourcerequisitionno#'				
				</cfquery>
								
				<td class="labelit" colspan="2" style="border:0px solid silver;padding-left:4px"><a href="javascript:ProcPOEdit('#Purchase.purchaseno#')">#Purchase.PurchaseNo#</a></td>
				
			<cfelse>
			
				<cfquery name="Warehouse" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT   *
					FROM     Warehouse
					WHERE    Warehouse = '#sourcewarehouse#'				
				</cfquery>
			
				<cfquery name="Location" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT   *
					FROM     WarehouseLocation
					WHERE    Warehouse = '#sourcewarehouse#'				
					AND      Location  = '#sourceLocation#'
				</cfquery>
				
				<td colspan="2" class="labelit" style="border:0px solid silver;padding-left:4px">#Warehouse.WarehouseName# #Location.Description# <!--- #Location.StorageCode# ---></td>
				
			</cfif>			
			
			<cfif stockorderid neq "">			 
				<td align="center" bgcolor="98E8F3" class="labelit" style="cursor:pointer;border:0px solid silver;padding-left:4px" onclick="StockOrderEdit('#stockorderid#')">					
					#TaskOrderReference#										
				</td>
			<cfelse>
				<td align="center" bgcolor="FFFF00" class="labelit" style="cursor:pointer;border:0px solid silver;padding-left:4px" ><i>Pending</i></td>
			</cfif>
			
			<td style="border:0px solid silver;padding-left:4px;padding-right:4px" class="labelit">
			   <cfif stockorderid neq "">
			      <cfif shiptomode eq "Deliver">Delivery<cfelse>Collection</cfif>
			   <cfelse>
			      <cfif shiptomode eq "Deliver">Delivery<cfelse>Collection</cfif>
			   </cfif>
			</td>	
						
			<td style="border:0px solid silver;padding-left:4px;padding-right:4px" class="labelit">#TaskType#</td>
						
			<cfif shiptomode eq "Deliver">
			
			   <cfquery name="GeoLocation" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT   L.LocationName
					FROM     WarehouseLocation WL, Location L
					WHERE    WL.LocationId = L.Location
					AND      WL.Warehouse     = '#shiptowarehouse#'				
					AND      WL.Location      = '#shiptolocation#'
			   </cfquery>
				
				<td class="labelit" style="border:0px solid silver;padding-left:4px;padding-right:4px"><cfif geolocation.recordcount eq "0">--<cfelse>#GeoLocation.LocationName#</cfif></td>	
			
			<cfelse>
			
				<td></td>
			
			</cfif>
	
			<td class="labelit" style="border:0px solid silver;padding-left:4px">#OfficerLastName#</td>
			
			<td class="labelit" align="center" style="border:0px solid silver;padding-right:4px">#dateformat(shiptodate,CLIENT.DateFormatShow)#</td>
			
			<td class="labelit" align="right" style="border:1px solid silver;padding-right:4px">#numberformat(TaskQuantity,',__')#</td>
			
			<cfif shipped gte "1">
				<td class="labelit" align="right" bgcolor="98E8F3" style="border:1px solid silver;padding-right:4px">#numberformat(Shipped,',__')#</td>	
			<cfelse>
				<td class="labelit" align="right" style="border:1px solid silver;padding-right:4px">#numberformat(Shipped,',__')#</td>	
			</cfif>	
			
			<td class="labelit" align="right" bgcolor="<cfif recordstatus eq "3">red</cfif>" style="border:1px solid silver;padding-left:4px;padding-right:4px"><font color="FF0000"><cfif recordstatus eq "3"><font color="FFFFFF">Closed</cfif></td>
			
		</tr>
		
		<cfif shipped gt "0">
								
			<tr>	
			
				<td></td>				
				<td align="right"><img src="#session.root#/images/join.gif" alt="" border="0"></td>
				<td bgcolor="ffffaf" style="border:1px solid silver;padding-left:4px" class="labelsmall">BatchNo</td>
				<td bgcolor="ffffaf" style="border:1px solid silver;padding-left:4px" class="labelsmall" colspan="2">Status</td>
				<td bgcolor="ffffaf" style="border:1px solid silver;padding-left:4px" class="labelsmall"><cf_tl id="SlipNo"></td>
				<td bgcolor="ffffaf" style="border:1px solid silver;padding-left:4px" class="labelsmall"><cf_tl id="Received by"></td>
				<td bgcolor="ffffaf" style="border:1px solid silver;padding-left:4px" class="labelsmall"><cf_tl id="Received on"></td>
				<td></td>
				<td bgcolor="ffffaf" style="border:1px solid silver;padding-left:4px" class="labelsmall"><cf_tl id="Quantity"></td>
				
			</tr>	
			
			
			<cfquery name="Shiplist" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				        
				   SELECT  *
	                FROM    ItemTransaction S
		 			WHERE   RequestId    = '#RequestId#'								
					AND     TaskSerialNo = '#TaskSerialNo#'					 		
					AND     TransactionQuantity > 0													 
					AND     ActionStatus != '9' 
					
			</cfquery>		
			
			<cfloop query="shiplist">	
			
			<cfif TransactionType eq "1">
				<cfset cl = "ffffcf">
			<cfelse>
				<cfset cl = "E6F2FF">
			</cfif>		
			
			<tr>	
				<td></td>				
				<td align="right"></td>
				<td bgcolor="#cl#" class="labelit" align="center" style="border:1px solid silver;padding-right:4px">
				
				<cfif TransactionType eq "1">
				
					<cfquery name="Receipt" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						        
						   SELECT  *
			                FROM   Purchase.dbo.PurchaseLineReceipt S
				 			WHERE   ReceiptId   = '#ReceiptId#'														
							
					</cfquery>		
					
					<a href="javascript:receipt('#Receipt.ReceiptNo#','receipt')"><font color="6688aa">#Receipt.ReceiptNo#</font></a>
				
				<cfelse>
				
					<a href="javascript:batch('#TransactionBatchNo#','','process')"><font color="6688aa">#TransactionBatchno#</font></a>
					
				</cfif>
				
				</td>	
				<td bgcolor="#cl#" class="labelit" align="center" colspan="2" style="border:1px solid silver;padding-right:4px"><cfif ActionStatus eq "0">Pending<cfelse>Confirmed</cfif></td>
				<td bgcolor="#cl#" class="labelit" style="border:1px solid silver;padding-left:4px">#TransactionReference#</td>
				<td bgcolor="#cl#" class="labelit" style="border:1px solid silver;padding-left:4px">#OfficerLastName#</td>
				<td bgcolor="#cl#" class="labelit" align="center" style="border:1px solid silver;padding-right:4px">#dateformat(TransactionDate,client.dateformatshow)#</td>
				<td></td>
				<td bgcolor="#cl#" class="labelit" align="right" style="border:1px solid silver;padding-right:4px">#numberformat(TransactionQuantity,',__')#</td>
			</tr>	
			
			</cfloop>			
		
		</tr>
		
		</cfif>
		
	</cfoutput>
	</table>

</cfif>	


