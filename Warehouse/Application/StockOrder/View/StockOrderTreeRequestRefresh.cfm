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
<cfinclude template="StockOrderTreeData.cfm">
			   
<cfoutput query="warehouselist">   
	
	  <cfset whs = warehouse>
	
		<script language="JavaScript">  
	    try {
        document.getElementById('treestatus_#whs#').innerHTML = "#counted#"		
		} catch(e) {}
      </script>
				 
	  <cfloop query="status">
	  
	  		  <cfset st = status>
				
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
			  
			  <script language="JavaScript">  
			    try {
		        document.getElementById('treestatus_#whs#_#status#').innerHTML = "#cell#"		
				} catch(e) {}
		      </script>
						  				  
			 <cfif status eq "3">			 	
						 
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
				 
				 <script language="JavaScript">  
				    try {							
			        document.getElementById('treestatuslines_#whs#_#st#').innerHTML = "#lines#"		
					} catch(e) {}
				  </script>	
				  
				   <cfquery name="getCategory" dbtype="query">						  
						  SELECT Category, count(*) as Total
						  FROM   StatusTaskList
						  WHERE  Warehouse = '#whs#'	
						  GROUP BY Category							 						
				  </cfquery>	
				  
				  <cfloop query="getCategory">	
				  
					 <cfset cat = category>
														  
					 <cfif total eq "">
					     <cfset cell = 0>
					 <cfelse>
					  	 <cfset cell = Total>
					 </cfif>	
					
					 <script language="JavaScript">  
					    try {							
				        document.getElementById('treestatus_#whs#_#st#_#cat#').innerHTML = "#cell#"		
						} catch(e) {}
					 </script>	
										 
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
						
						<script language="JavaScript">  
						    try {							
					        document.getElementById('treestatus_#whs#_#st#_#source#').innerHTML = "#cell#"		
							} catch(e) {}
						  </script>	
																
						  <cfquery name="getA" dbtype="query">						  
							  SELECT count(*) as Total
							  FROM   StatusTaskList
							  WHERE  Warehouse = '#whs#'
							  AND    Source    = '#source#'		
							  AND    Category  = '#cat#'
							  AND    StockOrderid IS NULL
							  <!--- has somehow no shipping records yet, strange but possible --->
							  AND    Shipped = 0
						  </cfquery>		
										  
						  <cfif getA.total eq "">
							    <cfset cell = 0>
						  <cfelse>
						  	    <cfset cell = getA.Total>
						  </cfif>	
						  
						<script language="JavaScript">  
						    try {							
					        document.getElementById('treestatus_#whs#_#st#_#source#_pending').innerHTML = "#cell#"		
							} catch(e) {}
						</script>											
																	   
						<cfif source neq "Procurement">															 				
									  
							  <!--- pending receipt  --->		
							  
							  <cfquery name="getP" dbtype="query">						  
									  SELECT count(*) as Total
									  FROM   StatusTaskList
									  WHERE  Warehouse = '#whs#'
									  AND    Category  = '#cat#'
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
							  
							  <script language="JavaScript">  
							    try {							
						        document.getElementById('treestatus_#whs#_#st#_#source#_collectionreceipt').innerHTML = "#cell#"		
								} catch(e) {}
							  </script>								
																				
							  <!--- pending confirmation --->
								   		
							  <cfquery name="getR" dbtype="query">						  
									  SELECT count(*) as Total
									  FROM   StatusTaskList
									  WHERE  Warehouse = '#whs#'		
									  AND    Category  = '#cat#'
									  AND    Source    = '#source#'							
									  AND    ShippedNoConfirmation > 0
									  AND    ShipToMode = 'Collect'												  
							  </cfquery>		
								   
							  <cfif getR.total eq "">
								  <cfset cell = 0>
							  <cfelse>
							      <cfset cell = getR.Total>
							  </cfif>		
								  
							  <script language="JavaScript">  
							     try {							
							        document.getElementById('treestatus_#whs#_#st#_#source#_collectionconfirmation').innerHTML = "#cell#"		
								 } catch(e) {}
							  </script>								 
																  
						</cfif>
										  
						<!--- ---------- --->
						<!--- Delivery-- --->
						<!--- ---------- --->		
																  
						  <!--- pending receipt --->							
					
					      <cfquery name="getP" dbtype="query">						  
								  SELECT count(*) as Total
								  FROM   StatusTaskList
								  WHERE  Warehouse = '#whs#'
								  AND    Category  = '#cat#'
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
						   
						  <script language="JavaScript">  
						     try {							
						        document.getElementById('treestatus_#whs#_#st#_#source#_deliveryreceipt').innerHTML = "#cell#"		
							 } catch(e) {}
						  </script>																							  
							
						  <!--- pending confirmation --->
								   	
						  <cfquery name="getR" dbtype="query">						  
								  SELECT count(*) as Total
								  FROM   StatusTaskList
								  WHERE  Warehouse = '#whs#'	
								  AND    Category  = '#cat#'
								  AND    Source    = '#source#'								
								  AND    ShippedNoConfirmation > 0
								  AND    ShipToMode = 'Deliver'										
						  </cfquery>	
								  
						  <cfif getR.total eq "">
							   <cfset cell = 0>
						  <cfelse>
						  	   <cfset cell = getR.Total>
						  </cfif>		
						  
						  <script language="JavaScript">  
						     try {							
						        document.getElementById('treestatus_#whs#_#st#_#source#_deliveryconfirmation').innerHTML = "#cell#"		
							 } catch(e) {}
						  </script>											
					
			 			</cfloop>			 
	 
					</cfloop>
					
			     </cfif>
		
		</cfloop>			
					
</cfoutput>
	
<cf_compression>			