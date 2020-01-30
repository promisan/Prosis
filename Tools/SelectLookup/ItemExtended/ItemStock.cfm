
<!--- this screen has a select mode for asset  
and a select/uom/quantity mode if this is for supplies or other classes --->

<!--- get the mode --->

 <cfquery name="getMode" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    W.*, P.LotManagement
         FROM      Warehouse W, Ref_ParameterMission P
         WHERE     W.Warehouse = '#url.filter1value#'		 				 
		 AND       W.Mission = P.Mission 
 </cfquery>

 <cfquery name="Item" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    I.*
		 
		 <cfif filter2 eq "imageclass">
			,II.ImagePath, II.ImageClass,
			R.ResolutionWidth, R.ResolutionHeight
		</cfif>
	
	    FROM   Item	I
	
		<cfif filter2 eq "imageclass">
	
			LEFT JOIN ItemImage II
				ON 	 II.ItemNo = I.ItemNo
				AND  II.ImageClass = '#url.filter2value#'
				AND  II.Mission = I.Mission
				
			LEFT JOIN Ref_ImageClass R
				ON  II.ImageClass = R.Code
	
		</cfif>
		
         WHERE     I.ItemNo = '#itemno#'		 				 
 </cfquery>
  
 <cfquery name="Category" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    *
         FROM      Ref_Category
         WHERE     Category = '#Item.Category#'		 				 
 </cfquery>
   
 <cfquery name="StoreCategory" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT   *
         FROM     WarehouseCategory
         WHERE    Warehouse = '#url.filter1value#'
		 AND      Category = '#Item.Category#'		 				 
 </cfquery>
  
 <cfquery name="UoM" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    *
         FROM      ItemUoM
         WHERE     ItemNo = '#itemno#'		
		 AND       Operational = 1 				 
 </cfquery>
 
 <cfset link = replace(link,"||","&","ALL")> 
  
 <form name="itemform" id="itemform">
 
	<table id="dspecs" 
	   cellpadding="0" 
	   cellspacing="0" 
	   border="0" 
	   width="100%" 
	   bgcolor="transparent" 
	   align="center"> 
	   	   
	   <cfoutput>

       <tr>
			<td valign="middle" align="center" height="1px" style="padding-top:10px">   				
				
				 <cfif Item.ImagePath neq "">
						
					<cfif FileExists("#SESSION.rootDocument#/#Item.ImagePath#") >
				
				         <img src="#SESSION.rootDocument#/#Item.ImagePath#"
							  alt="#Item.ItemDescription# [#Item.Itemno#]"
							  style="max-width: 200px;"
                              border="0"                                       
                              align="absmiddle">	

					</cfif>
								
                  <cfelse>
						   
				   	  <cfif FileExists("#SESSION.rootDocumentPath#/Warehouse/Pictures/#url.ItemNo#.jpg")>

						   <img src="#SESSION.rootDocument#/Warehouse/Pictures/#url.ItemNo#.jpg" 
	                          alt="#Item.ItemDescription#"
	                          height="195"							
	                          border="0"
	                          align="absmiddle">		
							
						</cfif>
							
                 </cfif>    									 


			</td>
		</tr>
		
		<cfif Item.ItemClass eq "Asset">
		
	        <tr class="line">
	           	<td height="30px">
	               	<table cellpadding="0" cellspacing="0" width="100%">
	                   	<tr>
	                       	<td width="90px" style="border-right:3px solid silver; padding-right:5px" align="right" class="labellarge">	                          
	                           	#APPLICATION.BaseCurrency#</font><br>#numberformat(UoM.StandardCost,",.__")#</font>	
	                        </td>	                           
	                       	<td align="left" class="labelmedium">
	                           	#Item.ItemDescription#	                            
                            </td>
	                       </tr>
	                   </table>
	               	
	               </td>
	        </tr>
			
		<cfelse>
		
		   <tr class="line">
	           	<td height="30px">
	               	<table cellpadding="0" cellspacing="0" width="100%">
	                   	<tr>	                       		                           
	                       	<td align="center" class="labelmedium" style="padding-left:6px;padding-right:6px">	                         
	                           	#Item.ItemDescription#	                           
	                         </td>
	                     </tr>
	                </table>	               	
               </td>
           </tr>		
		
		</cfif>
				
		<cfif url.module eq "materials">
		
			<cfquery name="InSale" 
		       datasource="appsMaterials" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
				SELECT     D.TransactionQuantity, D.TransactionUoM, D.ItemNo, U.UoMDescription, C.CustomerName, D.ItemClass
				FROM       userTransaction.dbo.Sale#url.filter1value# AS D INNER JOIN
		                   Materials.dbo.ItemUoM AS U ON D.ItemNo = U.ItemNo AND D.TransactionUoM = U.UoM INNER JOIN
		                   Materials.dbo.Customer AS C ON D.CustomerId = C.CustomerId
				WHERE      D.Created > GETDATE() - 1 
				AND        D.ItemNo = '#url.itemNo#' 
				AND        D.BatchId IS NULL 
				AND        D.ItemClass = 'Supply'
				AND        D.CustomerId != '#url.customerid#'
			</cfquery>
			
			<cfif inSale.recordcount gte "1">
			
			<tr class="line">
	           	<td style="padding-left:20px;padding-right:20px">
					<table cellpadding="0" cellspacing="0" width="100%">
					<tr class="labelmedium line">
					<td><cf_tl id="Customer"></td>
					<td><cf_tl id="UoM"></td>
					<td><cf_tl id="Quantity"></td>
					</tr>
					<cfloop query="InSale">
					<tr class="line">
					    <td>#CustomerName#</td>
						<td>#UoMDescription#</td>
						<td>#TransactionQuantity#</td>
					</tr>
					</cfloop>
					</table>
				</td>
			</tr>		
			
			</cfif>
		
		</cfif>
		
		<!--- additional details --->
     
	    <tr>
          	<td style="padding-left:17px; padding-top:6px; line-height:16px"> 
			   <table>
			        <tr class="labelmedium">
					<td style="padding-left:6px;padding-right:6px"><b>#Category.Description#</b><cfif Item.Classification neq "" and UoM.ItemBarCode neq Item.Classification>&nbsp;#Item.Classification#</cfif></td>
	   			                     	
					</tr>
					<tr class="labelmedium" style="height:20px">
	                  <cfif Item.make neq "">
    	          		<td style="padding-left:6px"><b><cf_tl id="Make">:</b> #Item.make#</td>
        	         </cfif>
                     <cfif Item.model neq "">
                  	    <td style="padding-left:6px"><b><cf_tl id="Model">:</b> #Item.model#</td>
                     </cfif>
                     <cfif Item.itemcolor neq "">
                  	   <td style="padding-left:6px"><b><cf_tl id="Color">:</b> #Item.itemcolor#</td> 
                     </cfif>			 
				    </tr>
					<tr class="labelmedium" style="height:20px">
					  <cfif UoM.ItemBarCode neq "">
                  	   <td style="padding-left:6px"><b><cf_tl id="Barcode">:</b> #UoM.ItemBarCode#</td> 
                     </cfif>		
					</tr> 
				</table>
            </td>
        </tr>
		
		</CFOUTPUT>
		
		<cfif Item.ItemClass eq "Asset">		
			
			<cfoutput>
							
			<tr><td align="center">
			  			  
			  <cfset setlink = "ColdFusion.navigate('#link#&action=insert&#url.des1#=#url.itemNo#','#url.box#')">
			  
				  <input type    = "button" 
				         class   = "button10g" 
						 style   = "width:165;height:40"
				         onclick = "#setlink#;<cfif url.close eq 'Yes'>Prosis.closeWindow('dialog#url.box#')</cfif>" name="Select" value="Save">			  
			  			 						
			  </td>
			  
			</tr>
						
			</cfoutput>
		
		<cfelse>	
						
		   <cfif getMode.LotManagement eq "0" or Item.ItemClass neq "Supply">
			
			   <cfquery name="getItems" 
		       datasource="AppsMaterials" 
	    	   username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
	    	     SELECT    *, 0 as TransactionLot
		         FROM      ItemUoM
		         WHERE     ItemNo = '#itemno#'		
				 AND       Operational = 1 				 
			   </cfquery>
			
			<cfelse>
			
			 <!--- only if there has been A movement in the past of this item --->
									
			   <cfquery name="getItems" 
		       datasource="AppsMaterials" 
	    	   username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
			   
			     SELECT   DISTINCT U.ItemNo, 
				          U.UoM, 
						  U.UoMDescription, 
						  U.UoMMultiplier,
						  U.ItemBarcode,
						  T.TransactionLot
			     FROM     ItemTransaction T INNER JOIN
                          ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN
                          ProductionLot L ON T.Mission = L.Mission AND T.TransactionLot = L.TransactionLot
				 WHERE    T.Warehouse = '#url.filter1value#'
				 AND      T.ItemNo = '#itemno#'
				 AND      U.Operational = 1
				 ORDER BY T.TransactionLot, 
				          U.UoM	    					 
			   </cfquery>
							
			</cfif>			
			
			<cfset show = "0">
			
			<cfif getItems.recordcount eq "0">
						
			<tr><td align="center" style="padding-top:10px" class="labelmedium">
			   <font color="FF0000"><cf_tl id="No movement for item"></font></td>
		    </tr>
			
			</cfif>
		
			<cfoutput query="getItems" group="TransactionLot">

				 <cfif TransactionLot neq "0">				 
			 		<tr><td height="4" style="padding-left:30px" class="labelmedium"><cf_tl id="Lot">:<b>&nbsp;#TransactionLot#</b></td></tr>							
				 </cfif>
											
				 <cfoutput>
				 				
				   <cfif recordcount gt "1">
					    <cfset qty = "0">
					<cfelse>
					    <cfset qty = "1">	
				   </cfif>
				
					<tr><td height="4"></td></tr>
			
			        <tr>
			           	<td height="30px" style="padding-top:10px">
			               	<table cellpadding="0" cellspacing="0" width="100%">							
																
								<cfinvoke component = "Service.Process.Materials.POS"  
									   method           = "getPrice" 
									   warehouse        = "#url.filter1value#" 
									   customerid       = "#url.CustomerId#"
									   customeridTax    = "#url.CustomerIdInvoice#"
									   currency         = "#url.Currency#"
									   TransactionLot   = "#transactionlot#"
									   ItemNo           = "#itemno#"
									   UoM              = "#uom#"
									   quantity         = "1"
									   returnvariable   = "sale">	
								   
								<cfinvoke component = "Service.Process.Materials.Stock"  
									   method           = "getStock" 
									   warehouse        = "#url.filter1value#" 				
									   mission			= "#getMode.Mission#"			  
									   ItemNo           = "#itemno#"
									   UoM              = "#uom#"		
									   TransactionLot   = "#transactionlot#"					  
									   returnvariable   = "stock">		
								  
							    
			                   	<tr>
			                       	<td class="labelit" style="width:100px;border-right:3px solid silver; padding-right:5px" align="right">								  
									
			                           	<font size="5">
			                           	<font size="4">#url.currency#</font><br>#numberformat(Sale.Price,",.__")#</font>	
										<cfif sale.Inclusive eq "1">
										<br>
										<font size="1"><cf_tl id="includes tax"></font>
										</cfif>
			                        </td>	
										                           
			                       	<td style="padding-left:5px" align="left">
									
									    <table cellspacing="0" cellpadding="0">
									
											<tr class="labelmedium"><td>#ItemBarCode#</td></tr>
											<tr class="labelmedium"><td>
													#UoMDescription#
													<cfif UoMMultiplier neq 1>
														x #UoMMultiplier#
													</cfif>	
											
											</td></tr>
											
											<cfif Item.ItemClass eq "Service">
											
											   <cfset pos = "1">

											<cfelse>
											
												<tr><td class="labelit">
												<cfif stock.reserved neq "">
													<cfset pos = stock.onhand - stock.reserved>
												<cfelse>
													<cfset pos = stock.onhand>
												</cfif>
												
												<cfquery name="Location" 
												       datasource="AppsMaterials" 
												       username="#SESSION.login#" 
												       password="#SESSION.dbpw#">
												         SELECT    Location
												         FROM      ItemWarehouseLocation
														 WHERE     ItemNo    = '#itemno#'		
														 AND       UoM       = '#UoM#'
														 AND       Warehouse = '#url.filter1value#'
														 AND       Operational = 1 				 
														 ORDER BY PickingOrder
												</cfquery>																																													
												
												<cfif pos gte "1">
												
													<table>
													<tr class="labelmedium" style="height:15px">
														<td><cf_tl id="In Store"></td><td style="padding-left:6px"><font color="008000">#pos#</font></td>
													</tr>
													
												
													<cfif location.recordcount gt "1">
													
														<cfloop query = "Location">
														
															<cfinvoke component = "Service.Process.Materials.Stock"  
															   method           = "getStock" 
															   mission			= "#getMode.Mission#"	
															   warehouse        = "#url.filter1value#" 
															   location         = "#location#"							  
															   ItemNo           = "#getitems.itemno#"
															   UoM              = "#getitems.uom#"							  
															   returnvariable   = "stock">		
															   
															   <cfif stock.reserved neq "">
																<cfset lpos = stock.onhand - stock.reserved>
																<cfelse>
																<cfset lpos = stock.onhand>
																</cfif>
																
																<cfif lpos gt "0">
																
																	<tr class="labelit" style="height:15px">
																	<td style="padding-left:5px">#location#</td><td style="padding-left:6px"><font color="008000">#lpos#</font></td>
																	</tr>
																
																</cfif>
															   
														</cfloop>									
													
													</cfif>
													
													</table>																
												
												<cfelse>
												
												
												<font face="Calibri" size="2" color="FF0000">not available</font>
			
												</cfif>
											
												</td>
												</tr>
												
											</cfif>
										
										</table>
			                        </td>
									
									<td align="right" style="padding-left:5px;padding-right:10px">
									
									      <!--- we show quantity regardless if oversale is enabled --->
									      
										  <cfif pos gte "1" or StoreCategory.OverSale eq "1" or location.recordcount eq "0">	
										  
										  	  <cfset show = "1">
										  
											  <input type ="text" 
											      name    = "Quantity_#currentrow#" 
												  id      = "Quantity_#currentrow#" 
												  value   = "#qty#" 
												  style   = "text-align:center;width:70;height:40;font-size:30px">
											  
										  <cfelse>		
										  						  
											  <input type = "hidden" 
											      name    = "Quantity_#currentrow#" 
												  id      = "Quantity_#currentrow#" 
												  value   = "0" 
												  style   = "text-align:center;width:70;height:40;font-size:30px">	  
											  
										  </cfif>	
																			  
										    
									</td>
									   
			                       </tr>
			                   </table>
			               	
			               </td>
			        </tr>
					
				</cfoutput>
			
			</cfoutput>
			
			<cfoutput>								
			
			<tr><td style="border-bottom:1px solid silver" height="20"></td></tr>
						
			<tr><td align="center" style="padding-top:5px">
						  			  
			  <cfset setlink = "ColdFusion.navigate('#link#&action=insert&#url.des1#=#url.itemNo#','#url.box#','','','POST','itemform')">
			 	
			  <cfif show eq "1">				 	 	  
			  
				  <input type    = "button" 
				         class   = "button10g" 
				         style   = "font-size:19;width:165;height:35"
				   		 onclick = "#setlink#;<cfif url.close eq 'Yes'>Prosis.closeWindow('dialog#url.box#')</cfif>" 
						 name    = "Select" 
						 value   = "Add">			  
				
			  </cfif>
			  			 						
			  </td>
			  
			</tr>			
			
			</cfoutput>
		
		</cfif>
		      			  
	</table>
	
</form>
	
	<cfquery name="ItemList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	   SELECT *
	   FROM (
	
		SELECT 	 W.WarehouseName AS WarehouseName, 
				 W.Mission AS Mission, 
				 IW.*, 
				 I.ItemPrecision,
				 I.ValuationCode,
				 U.UoMDescription,			 
				 U.ItemBarCode,
				 (
					SELECT ROUND(SUM(TransactionQuantity),5)
					FROM   ItemTransaction 
					WHERE  ItemNo         = I.ItemNo
					AND	   TransactionUoM = U.UoM
					AND    Mission        = W.Mission
					AND	   Warehouse      = W.Warehouse
				 ) as OnHand 
				 
				
		FROM     ItemWarehouse IW 
				 INNER JOIN Warehouse W 
					ON IW.Warehouse = W.Warehouse 
				 INNER JOIN ItemUoM U 
					ON IW.ItemNo = U.ItemNo 
					AND IW.UoM = U.UoM
				 INNER JOIN Item I
					ON IW.ItemNo = I.ItemNo
		WHERE     IW.ItemNo = '#itemno#'
		
		) as XL
		
		WHERE  OnHand > 0  
		AND Warehouse != '#url.filter1value#'
		ORDER BY  Mission, Warehouse
		
	</cfquery>
	
	<cfoutput>
	
	<cfset whs = "">	
	<table width="90%" align="center" class="navigation_table">
	<cfloop query="ItemList">
			<cfif whs eq "">			
			    <tr class="line">
			       	<td style="padding-bottom:5px;padding-top:5px" align="center" colspan="7">
			            <cf_tl id="OTHER WAREHOUSES">	
			        </td>
			    </tr>
				<tr><td style="height:4px"></td></tr>		
			</cfif>
			<cfif whs neq ItemList.warehouseName>
				<tr class="labelmedium" style="height:15px">					
					<td colspan="2" style="font-weight:bold">#WarehouseName#</td>					
				</tr>
				<cfset whs = ItemList.warehouseName>
			</cfif>	
			<tr class="labelmedium navigation_row" style="height:15px">				
				<td style="padding-left:10px">#UoMDescription#</td>				
				<td width="10%" align="right">#numberformat(OnHand,",__")#</td>				
			</tr>			
	</cfloop>
	</table>	
	
	</cfoutput>


<cfset ajaxonload="doHighlight">