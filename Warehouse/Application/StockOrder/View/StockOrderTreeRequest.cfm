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
<cfoutput>

<cfinclude template="StockOrderTreeData.cfm">


<!--- value 0 : receipt by recipient, 1 receipt entry by provider (default, except for external --->

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<cfform>	

<cfif warehouselist.recordcount eq "0">
		
	<tr>
		<td colspan="2" align="center" height="60" class="labelit">   
			<font color="FF0000">No records found or no access granted.</font>
		</td>	
	</tr>
	
<cfelse>
			
	<tr class="hide">	

		<td id="treerefresh" 
		   onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeRequestRefresh.cfm?mission=#url.mission#','treerefresh')"></td>

	</tr>		
				
	<tr><td colspan="2" style="padding-top:4px;padding-left:5px" height="20" valign="top">   
						
		<cftree name="root"
		   font="verdana"
		   fontsize="11"		
		   bold="No"   
		   format="html"    
		   required="No">   
			   
		   <cfif WarehouseList.recordcount gte "4">
			   <cfset sh = "No">
		   <cfelse>
		       <cfset sh = "Yes">	   
		   </cfif>
			   
			<cfloop query="warehouselist">   
			
			  <cfset whs = warehouse>
			  
			  <cfif len(warehousename) gt "21">
			    <cfset nme  = "#uCase(left(warehousename,21))#..">
			  <cfelse>
			    <cfset nme  = "#uCase(warehousename)#">	
			  </cfif>
			  			  			
			  <cftreeitem value="#whs#"
				  display="<font size='2'>#nme# (<a id='treestatus_#whs#'>#counted#</a>)</font>"
				  parent="root"		
				  href    = "javascript:showrequest('#url.mission#','#whs#','','','#url.systemfunctionid#')"			 				  		  								
				  expand="#sh#">		
				 
				<cfset pgroup = ""> 
		
				<cfloop query="status">
				
					<cfif ListingGroup neq pgroup>
					
					   <cfset pgroup = ListingGroup>
				
					   <cfif ListingGroup neq "">	
					   <cftreeitem value="dummy"
						  display="<span style='padding-top:3px;padding-bottom:3px' class='labelmedium'><i><b>#ListingGroup#</span>"
						  parent="#whs#">	
					   </cfif>	  						 
						  
					</cfif>	  
					
					  <cfset st= status>
										
					  <cfif status neq "3">	
					  
					      <!--- retrieve the total --->
					  	  <cfquery name="get" dbtype="query">						  
								  SELECT Total
								  FROM   StatusList
								  WHERE  Warehouse = '#whs#'
								  AND    ActionStatus = '#status#'								
						  </cfquery>	
						  
						  <cfif get.total eq "">
						    <cfset cell = 0>
						  <cfelse>
						  	<cfset cell = get.Total>
						  </cfif>
						  						  
						  <cfif status eq "9">						  
						  						  
							   <cftreeitem value="#whs#_#status#"
						        display = "<span style='text-decoration: line-through;color:FF6464'>#Description#(</span><b><a name='treestatus_#whs#_#status#' id='treestatus_#whs#_#status#' style='color:FF6464'>#cell#</a><span style='color:red'>)</span>"
								parent  = "#whs#"	
								href    = "javascript:showrequest('#url.mission#','#whs#','#status#','','#url.systemfunctionid#')"															
						        expand  = "No">	
						  
						  <cfelse>
					  
						  	  <cftreeitem value="#whs#_#status#"
						        display = "#Description# (<b><a id='treestatus_#whs#_#status#'>#cell#</a>)"
								parent  = "#whs#"	
								href    = "javascript:showrequest('#url.mission#','#whs#','#status#','','#url.systemfunctionid#')"															
						        expand  = "No">	
							
							</cfif>
													
								<cfquery name="RequestType" 
								  datasource="AppsMaterials" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								    SELECT   DISTINCT R.Code, R.Description
								    FROM     RequestHeader AS S INNER JOIN Ref_Request AS R ON S.RequestType = R.Code 									 						
																
									WHERE    S.Mission      = '#url.mission#'
									AND      S.ActionStatus = '#status#'
									AND      S.Reference IN (SELECT Reference 
									                         FROM   Request
															 WHERE  Mission   = '#url.mission#'
															 AND    Warehouse = '#whs#'													 
															 AND    Reference = S.Reference													
															 )
															 
								    GROUP BY R.Code, R.Description
									ORDER BY R.Code, R.Description
								 </cfquery>
		  
		  						 <cfset st= status>
						
						         <cfloop query="RequestType">
						
									  <cftreeitem value="#whs#_#st#_#code#"
									        display="#Description#"
											parent="#whs#_#st#"													
											href="javascript:showrequest('#url.mission#','#whs#','#st#','#code#','#url.systemfunctionid#')"								
									        expand="No">	
								
								 </cfloop>
						 
					  <cfelse>
					  
					     <!--- ----------------------------------------------------------------------------------------- --->
					  	 <!--- status is 3 tasked and now we are going to show this per tasked or purchase order instead --->
						 <!--- ----------------------------------------------------------------------------------------- --->
					  
					  	 <cfquery name="get" dbtype="query">						  
									  SELECT Total
									  FROM   StatusList
									  WHERE  Warehouse    = '#whs#'									
									  AND    ActionStatus = '#status#'								
						 </cfquery>	
							  
						 <cfif get.total eq "">
						     <cfset cell = 0>
						 <cfelse>
						  	 <cfset cell = get.Total>
						 </cfif>
						 
						 <cfquery name="lines" dbtype="query">						  
									  SELECT count(*) as Total
									  FROM   StatusTaskList
									  WHERE  Warehouse    = '#whs#'											 																  						
						 </cfquery>	
							 
						 <cfif lines.total eq "">
						     <cfset lines = 0>
						 <cfelse>
						  	 <cfset lines = lines.Total>
						 </cfif>
						  
						 <cftreeitem value="#whs#_#status#"
						    display = "#Description# (<b><a id='treestatus_#whs#_#status#'>#cell#</a>)</b> | [<a id='treestatuslines_#whs#_#status#'>#lines#</a>]"
							parent  = "#whs#"	
							href    = "javascript:showrequest('#url.mission#','#whs#','#status#','','#url.systemfunctionid#','','')"															
						    expand  = "Yes">	
							
						  <cfquery name="getCategory" dbtype="query">						  
								  SELECT Category, ItemCategory, count(*) as Total
								  FROM   StatusTaskList
								  WHERE  Warehouse = '#whs#'	
								  GROUP BY Category, ItemCategory							 						
						  </cfquery>	
						  
						   <cfloop query="getCategory">		
						   														   	
								<!--- presentation mode collection --->
								
								<cfquery name="CollectionReceipt" 
								  datasource="AppsMaterials" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
									SELECT   ModeShipmentEntry
									FROM     Ref_ShipToModeMission
									WHERE    Mission  = '#url.mission#' 
									AND      Category = '#Category#' 
									AND      Code     = 'Collect'
								</cfquery>	
								
								<cfquery name="DeliveryReceipt" 
								  datasource="AppsMaterials" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
									SELECT   ModeShipmentEntry
									FROM     Ref_ShipToModeMission
									WHERE    Mission  = '#url.mission#' 
									AND      Category = '#Category#' 
									AND      Code     = 'Deliver'
								</cfquery>		
								
							    <cfset cat = Category>		
							  
								<cfif total eq "">
								     <cfset cell = 0>
								<cfelse>
								  	 <cfset cell = Total>
								</cfif>	
																																
							  <cftreeitem value="#whs#_#st#_#cat#"
							     display = "<span style='padding-top:3px;padding-bottom:3px;color: B08C42;' class='labellarge'><b>#ItemCategory#</b> [<b><a id='treestatus_#whs#_#st#_#cat#'>#cell#</a>]</span>"
								 parent  = "#whs#_#st#"															
							     expand  = "No">																					  				   
						 
							  <cfquery name="getSource" dbtype="query">						  
									  SELECT Source, count(*) as Total
									  FROM   StatusTaskList
									  WHERE  Warehouse = '#whs#'	
									  AND    Category  = '#cat#'	
									  GROUP BY Source						 						
							  </cfquery>								  											 
												  
							  <cfloop query="getSource">
							 		
								 <cfif total eq "">
								     <cfset cell = 0>
								 <cfelse>
								  	 <cfset cell = Total>
								 </cfif>	
								 
								 <cfif source is "Procurement">
									 <cfset color = "black">
								 <cfelse>
								     <cfset color = "black">
								 </cfif>
							  
							  	 <cftreeitem value="#whs#_#st#_#cat#_#source#"
							        display = "<span style='padding-top:3px;padding-bottom:3px;color: #color#;' class='labelmedium'><b>#Source#</b> [<b><a style='color: #color#;' id='treestatus_#whs#_#st#_#cat#_#source#'>#cell#</a>]</span>"
									parent  = "#whs#_#st#_#cat#"	
									href    = "javascript:showrequesttask('#url.mission#','#whs#','#st#','','#url.systemfunctionid#','','#source#','#cat#')"															
							        expand  = "No">		
									
								      <cfquery name="getA" dbtype="query">						  
										  SELECT count(*) as Total
										  FROM   StatusTaskList
										  WHERE  Warehouse = '#whs#'
										  AND    Category  = '#Cat#'	
										  AND    Source    = '#source#'		
										  AND    StockOrderid IS NULL									  
										  <!--- has somehow no shipping records yet, strange but possible --->
										  AND    Shipped = 0
									  </cfquery>		
										  
									  <cfif getA.total eq "">
										    <cfset cell = 0>
									  <cfelse>
									  	    <cfset cell = getA.Total>
									  </cfif>	
									  
									  <cftreeitem value="#whs#_#st#_#cat#_#source#_pending"
									        display="Pending Ship Order [<a id='treestatus_#whs#_#st#_#cat#_#source#_pending'>#cell#</a>]"
											parent="#whs#_#st#_#cat#_#source#"											
											href="javascript:showrequesttask('#url.mission#','#whs#','#st#','O','#url.systemfunctionid#','','#source#','#cat#')" 
									        expand="No">					
																			   
										  <cfif source neq "Procurement">
										  
											  <!--- ---------- --->
											  <!--- Collection --->
											  <!--- ---------- --->		
											  
											  <cfif CollectionReceipt.ModeShipmentEntry eq "0">
											  
											  		<cfset rct = "Pending Receipt Unit">
													<cfset con = "Pending Confirmation Provider">
		
										      <cfelse>
											  
											  		<cfset rct = "Pending Receipt Provider">
													<cfset con = "Pending Confirmation Unit">
											  
											  </cfif>	
											  
											   <cftreeitem value="#whs#_#st#_#cat#_#source#_collection"
											        display = "<span style='color: #color#;padding-top:3px;padding-bottom:3px;' class='labelmedium'>Collection</b></span>"
													parent  = "#whs#_#st#_#cat#_#source#"																					
											        expand  = "Yes">									 				
											  
											  <!--- pending receipt  --->		
											  
											  <cfquery name="getP" dbtype="query">						  
													  SELECT count(*) as Total
													  FROM   StatusTaskList
													  WHERE  Warehouse = '#whs#'
													  AND    Category  = '#Cat#'	
													  AND    Source    = '#source#'		
													  AND    Shipped < TaskQuantity
													  AND    ShipToMode = 'Collect'
													  AND    (StockOrderId IS NOT NULL or Shipped > 0)
											  </cfquery>	
											  								   
											  <cfif getP.total eq "">
												    <cfset cell = 0>
											  <cfelse>
											  	<cfset cell = getP.Total>
											  </cfif>							
														
										      <cftreeitem value="#whs#_#st#_#cat#_#cat#_#source#_collectionreceipt"
												        display="#rct# [<a id='treestatus_#whs#_#st#_#cat#_#source#_collectionreceipt'>#cell#</a>]"
														parent="#whs#_#st#_#cat#_#source#_collection"															
														href="javascript:showrequesttask('#url.mission#','#whs#','#st#','P','#url.systemfunctionid#','Collect','#source#','#cat#')" 
												        expand="No">	
														
											  <!--- pending confirmation --->
											   		
											  <cfquery name="getR" dbtype="query">						  
													  SELECT count(*) as Total
													  FROM   StatusTaskList
													  WHERE  Warehouse = '#whs#'	
													  AND    Category  = '#Cat#'		
													  AND    Source    = '#source#'							
													  AND    ShippedNoConfirmation > 0
													  AND    ShipToMode = 'Collect'												  
											  </cfquery>		
											   
											  <cfif getR.total eq "">
												  <cfset cell = 0>
											  <cfelse>
											      <cfset cell = getR.Total>
											  </cfif>								 
														
											  <cftreeitem value="#whs#_#st#_#cat#_#source#_collectionconfirmation"
												        display="#con# [<a id='treestatus_#whs#_#st#_#cat#_#source#_collectionconfirmation'>#cell#</a>]"
														parent="#whs#_#st#_#cat#_#source#_collection"															
														href="javascript:showrequesttask('#url.mission#','#whs#','#st#','R','#url.systemfunctionid#','Collect','#source#','#cat#')" 
												        expand="No">									
														
										  
										  </cfif>
										  
										  <!--- ---------- --->
										  <!--- Delivery-- --->
										  <!--- ---------- --->		
										  
										  <cfif source eq "Procurement">
										  
										  		<cfset rct = "Pending Receipt Fuel Unit">
												<cfset con = "Pending Confirmation <b>Unit</b>">	
										  
										  <cfelseif DeliveryReceipt.ModeShipmentEntry eq "0">
										  
										  		<cfset rct = "Pending Receipt <b>Unit</b>">
												<cfset con = "Pending Confirmation Provider">
	
									      <cfelse>
										  
										  		<cfset rct = "Pending Receipt Contractor">
												<cfset con = "Pending Confirmation <b>Unit</b>">
										  
										  </cfif>		
										  
										  <cfif source eq "Procurement">
										  									 
											  <!--- pending receipt --->							
										
										      <cfquery name="getP" dbtype="query">						  
													  SELECT count(*) as Total
													  FROM   StatusTaskList
													  WHERE  Warehouse = '#whs#'
													  AND    Category  = '#Cat#'	
													  AND    Source    = '#source#'		
													  AND    TaskQuantity > Shipped
													  AND    ShipToMode = 'Deliver'
													  AND     (StockOrderId IS NOT NULL or Shipped > 0)
											   </cfquery>		
											   
											   <cfif getP.total eq "">
												   <cfset cell = 0>
											   <cfelse>
											  	   <cfset cell = getP.Total>
											   </cfif>																							  
												
											   <cftreeitem value="#whs#_#st#_#cat#_#source#_deliveryreceipt"
												        display="#rct# [<a id='treestatus_#whs#_#st#_#cat#_#source#_deliveryreceipt'>#cell#</a>]"
														parent="#whs#_#st#_#cat#_#source#"															
														href="javascript:showrequesttask('#url.mission#','#whs#','#st#','P','#url.systemfunctionid#','Deliver','#source#','#cat#')" 
												        expand="No">																							
												
											   <!--- pending confirmation --->
											   	
											   <cfquery name="getR" dbtype="query">						  
													  SELECT count(*) as Total
													  FROM   StatusTaskList
													  WHERE  Warehouse = '#whs#'	
													  AND    Category  = '#Cat#'	
													  AND    Source    = '#source#'								
													  AND    ShippedNoConfirmation > 0
													  AND    ShipToMode = 'Deliver'
													
											  </cfquery>	
											  
											  <cfif getR.total eq "">
												   <cfset cell = 0>
											  <cfelse>
											  	   <cfset cell = getR.Total>
											  </cfif>											
														
											  <cftreeitem value="#whs#_#st#_#cat#_#source#_deliveryconfirmation"
												        display="#con# [<a id='treestatus_#whs#_#st#_#cat#_#source#_deliveryconfirmation'>#cell#</a>]"
														parent="#whs#_#st#_#cat#_#source#"															
														href="javascript:showrequesttask('#url.mission#','#whs#','#st#','R','#url.systemfunctionid#','Deliver','#source#','#cat#')" 
												        expand="No">						
										   
										  <cfelse> 
										  
										  	  <cftreeitem value="#whs#_#st#_#cat#_#source#_delivery"
										        display = "<span style='color: #color#;padding-top:3px;padding-bottom:3px;' class='labelmedium'>Delivery</b></span>"
												parent  = "#whs#_#st#_#cat#_#source#"																					
										        expand  = "Yes">			
											  
											  <!--- pending receipt --->							
										
										      <cfquery name="getP" dbtype="query">						  
													  SELECT count(*) as Total
													  FROM   StatusTaskList
													  WHERE  Warehouse = '#whs#'
													  AND    Category  = '#Cat#'	
													  AND    Source    = '#source#'		
													  AND    Shipped < TaskQuantity
													  AND    ShipToMode = 'Deliver'
													  AND     (StockOrderId IS NOT NULL or Shipped > 0)
											   </cfquery>		
											   
											   <cfif getP.total eq "">
												   <cfset cell = 0>
											   <cfelse>
											  	   <cfset cell = getP.Total>
											   </cfif>																							  
												
											   <cftreeitem value="#whs#_#st#_#cat#_#source#_unit_deliveryreceipt"
												        display="#rct# [<a id='treestatus_#whs#_#st#_#cat#_#source#_deliveryreceipt'>#cell#</a>]"
														parent="#whs#_#st#_#cat#_#source#_delivery"														
														href="javascript:showrequesttask('#url.mission#','#whs#','#st#','P','#url.systemfunctionid#','Deliver','#source#','#cat#')" 
												        expand="No">																							
												
											   <!--- pending confirmation --->
											   	
											   <cfquery name="getR" dbtype="query">						  
													  SELECT count(*) as Total
													  FROM   StatusTaskList
													  WHERE  Warehouse = '#whs#'	
													  AND    Category  = '#Cat#'	
													  AND    Source    = '#source#'								
													  AND    ShippedNoConfirmation > 0
													  AND    ShipToMode = 'Deliver'													
											  </cfquery>	
											  
											  <cfif getR.total eq "">
												   <cfset cell = 0>
											  <cfelse>
											  	   <cfset cell = getR.Total>
											  </cfif>											
														
											  <cftreeitem value="#whs#_#st#_#cat#_#source#_deliveryconfirmation"
												        display="#con# [<a id='treestatus_#whs#_#st#_#cat#_#source#_deliveryconfirmation'>#cell#</a>]"
														parent="#whs#_#st#_#cat#_#source#_delivery"															
														href="javascript:showrequesttask('#url.mission#','#whs#','#st#','R','#url.systemfunctionid#','Deliver','#source#','#cat#')" 
												        expand="No">						
										  
										  </cfif>													 													 
						 
						 			</cfloop>
									
								</cfloop>	
					 </cfif>
				
				</cfloop>
								
			</cfloop>					
			
			</cftree>
						
	</td></tr>
	
</cfif>

</cfform>

</cfoutput>

</table>


