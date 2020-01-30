
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
         SELECT    *
         FROM      Item
         WHERE     ItemNo = '#url.itemno#'		 				 
 </cfquery>
  
 <cfquery name="Category" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    *
         FROM      Ref_Category
         WHERE     Category = '#Item.Category#'		 				 
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
	   width="100%"
	   height="100%" 	    
	   align="center"> 
	   
	   <cfoutput>
		
		<cfif Item.ItemClass eq "Asset">
		
	        <tr>
	           	<td height="30px" style="padding-top:10px">
	               	<table cellpadding="0" cellspacing="0" width="100%">
	                   	<tr>
	                       	<td width="90px" style="border-right:3px solid silver; padding-right:5px" align="right" class="labellarge">	                          
	                           	#APPLICATION.BaseCurrency#</font><br>#numberformat(UoM.StandardCost,"__,__.__")#</font>	
	                           </td>
	                           
	                       	<td style="padding-left:5px" align="left" class="labelmedium">
	                           	#Item.ItemDescription#	                            
	                           </td>
	                       </tr>
	                   </table>
	               	
	               </td>
	        </tr>
			
		<cfelse>
		
		   <tr class="line labelmedium">
	           	<td style="font-size:16px;padding-left:5px">#Item.ItemDescription#</td>	         	              
           </tr>		
		
		</cfif>
						
		</CFOUTPUT>
		
		<cfif Item.ItemClass eq "Asset">	
		
			<!---	
			
			<cfoutput>
							
			<tr><td align="center">
			  			  
			  <cfset setlink = "ColdFusion.navigate('#link#&action=insert&#url.des1#=#url.itemNo#','#url.box#')">
			  
				  <input type    = "button" 
				         class   = "button10s" 
						 style   = "width:165;height:40"
				         onclick = "#setlink#;<cfif url.close eq 'Yes'>ColdFusion.Window.destroy('dialog#url.box#')</cfif>" name="Select" value="Save">			  
			  			 						
			  </td>
			  
			</tr>
						
			</cfoutput>
			
			--->
		
		<cfelse>	
						
		   <cfif getMode.LotManagement eq "0">
			
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
						
			   <cfquery name="getItems" 
		       datasource="AppsMaterials" 
	    	   username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
			   
			   SELECT    DISTINCT U.ItemNo, U.UoM, U.UoMDescription, U.ItemBarcode,T.TransactionLot
			   FROM      ItemTransaction T INNER JOIN
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
		
			<cfoutput query="getItems" group="TransactionLot">

				 <cfif TransactionLot neq "0">
				 
				 		<tr><td height="4" style="padding-left:30px" class="labelmedium">Lot:<b><i>&nbsp;#TransactionLot#</b></i></td></tr>	
						
				 </cfif>
											
				 <cfoutput>
				
				   <cfif recordcount gt "1">
					    <cfset qty = "0">
					<cfelse>
					    <cfset qty = "1">	
				   </cfif>
				
					<tr><td height="4"></td></tr>
			
			        <tr>
			           	<td height="30" style="padding-top:10px">
			               	<table cellpadding="0" cellspacing="0" width="100%">						
							
							     <!--- disabled for now 
								<cfinvoke component = "Service.Process.Materials.POS"  
									   method           = "getPrice" 
									   warehouse        = "#url.filter1value#" 
									   customerid       = "#url.customerid#"
									   currency         = "#url.Currency#"
									   TransactionLot   = "#transactionlot#"
									   ItemNo           = "#itemno#"
									   UoM              = "#uom#"
									   quantity         = "1"
									   returnvariable   = "sale">	
									   
								--->	   
								   
								<cfinvoke component = "Service.Process.Materials.Stock"  
									   method           = "getStock" 
									   warehouse        = "#url.filter1value#" 							  
									   ItemNo           = "#itemno#"
									   UoM              = "#uom#"		
									   TransactionLot   = "#transactionlot#"					  
									   returnvariable   = "stock">		   
							    
			                   	<tr>
																 										                           
			                       	<td style="padding-left:10px" align="left">
									
									    <table>
									
											<tr class="labelmedium"><td style="height:20px">#ItemBarCode#</td></tr>
											<tr class="labelmedium"><td style="height:20px">#UoMDescription#</td></tr>
											<tr class="labelmedium"><td style="height:20px">
											
											<cfif stock.reserved neq "">
												<cfset pos = stock.onhand - stock.reserved>
											<cfelse>
												<cfset pos = stock.onhand>
											</cfif>
											
											<cfif pos gte "1">
												<font color="008000">available #pos#</font>
											<cfelse>
												<font color="FF0000">not available</font>
											</cfif>
											
											</td>
											</tr>
										
										</table>
										
			                        </td>
									
									<td align="right" style="padding-right:20px">
									
										  <cfif pos gte "1">	
										  
										  	  <cfset show = "1">
										  
											  <input type ="text" 
											      name    = "Quantity_#currentrow#" 
												  id      = "Quantity_#currentrow#" 
												  value   = "#qty#" 
												  style   = "text-align:center;width:50;height:40;font-size:26px">
											  
										  <cfelse>		
										  						  
											  <input type = "hidden" 
											      name    = "Quantity_#currentrow#" 
												  id      = "Quantity_#currentrow#" 
												  value   = "0" 
												  style   = "text-align:center;width:50;height:40;font-size:26px">	  
											  
										  </cfif>	
																			  
										    
									</td>
									   
			                       </tr>
			                   </table>
			               	
			               </td>
			        </tr>
					
				</cfoutput>
			
			</cfoutput>
			
			<cfoutput>								
												
			<tr class="line"><td align="center" style="padding:5px">
									  			  
			  <cfset setlink = "ColdFusion.navigate('#link#&action=insert&#url.des1#=#url.itemNo#','#url.box#','','','POST','itemform')">
			 			  
			  <cfif show eq "1">				 	 	  
			  
			  	 <cf_tl id="Add" var="vAdd">
			  
				  <input type="button" 
				         class="button10g" 
				         style="font-size:17;width:165;height:35"
				   		 onclick="#setlink#;<cfif url.close eq 'Yes'>ColdFusion.Window.destroy('dialog#url.box#')</cfif>" 
						 name="Select" 
						 value="#vAdd#">			  
				
			  </cfif>
			  			 						
			  </td>
			  
			</tr>	
						
			</cfoutput>
		
		</cfif>
		      			  
	</table>
	
</form>

