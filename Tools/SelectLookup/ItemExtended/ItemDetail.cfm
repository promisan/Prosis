
<!--- this screen has a select mode for asset  
and a select/uom/quantity mode if this is for supplies or other classes --->

 <cfquery name="Item" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    * 
         FROM      Item
         WHERE     ItemNo = '#itemno#'		 				 
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

 <cfoutput>

	<table id="dspecs" 
	   cellpadding="3" cellspacing="3" border="0" width="100%" bgcolor="transparent" align="center" 
	   style="border-collapse:separate"> 

       <tr>
			<td valign="middle" align="center" height="1px" style="padding-top:10px">   							 
		
		
					<cfif FileExists("#SESSION.rootDocumentPath#/Warehouse/Pictures/#url.ItemNo#.jpg")>
					
					   <img src="#SESSION.rootDocument#/Warehouse/Pictures/#url.ItemNo#.jpg" 
                          alt="#Item.ItemDescription#"
                          height="195"							
                          border="0"
                          align="absmiddle">		 
					
					
					<cfelse>					
					
					   <img src="#SESSION.root#/images/image-not-found1.gif" 
                          alt="#Item.ItemDescription#"
                          height="195"							
                          border="0"
                          align="absmiddle">						
					
					</cfif>      									 


			</td>
		</tr>
		
		<cfif Item.ItemClass eq "Asset">
		
	        <tr>
	           	<td height="30px" style="padding-top:10px">
	               	<table cellpadding="0" cellspacing="0" width="100%">
	                   	<tr>
	                       	<td width="90px" style="border-right:3px solid silver; padding-right:5px" align="right">
	                           	<font size="5" face="calibri">
	                           	<font size="4">#APPLICATION.BaseCurrency#</font><br>#numberformat(UoM.StandardCost,",.__")#</font>	
	                           </td>
	                           
	                       	<td align="left">
	                           	<font size="4" face="calibri">
	                           	#Item.ItemDescription#
	                             </font>
	                           </td>
	                       </tr>
	                   </table>
	               	
	               </td>
	        </tr>
			
		<cfelse>
		
		   <tr>
	           	<td height="30px" style="padding-top:10px">
	               	<table cellpadding="0" cellspacing="0" width="100%">
	                   	<tr>	                       		                           
	                       	<td align="center">
	                           	<font size="4" face="calibri">								
	                           	#Item.ItemDescription#
	                            </font>
	                         </td>
	                     </tr>
	                </table>	               	
               </td>
           </tr>		
		
		</cfif>
		
		<!--- additional details --->
     
	    <tr>
          	<td height="40px" style="padding-left:17px; padding-top:6px; line-height:16px"> 
			   <table>
			        <tr>
					<td style="padding-left:6px"><font size="2" face="calibri"> <b>Category:</b> #Category.Description#</td>
	   			    <td style="padding-left:6px"><font size="2" face="calibri"><b>Classification:</b>  <cfif Item.Classification eq "">n/a<cfelse>#Item.Classification#</cfif></td>	                  	
					</tr>
					<tr>
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
				</table>
            </td>
        </tr>
		
		<cfif Item.ItemClass eq "Asset">
							
			<tr><td align="center">
			  			  
			  <cfset setlink = "ColdFusion.navigate('#link#&action=insert&#url.des1#=#url.itemNo#','#url.box#')">
			  
			  <input type="button" 
			         class="button10g" 
					 style="width:165;height:40"
			         onclick="#setlink#;<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>" name="Select" value="Save">			  
			  			 						
			  </td>
			  
			</tr>
		
		<cfelse>
		
			<cfset show = "0">
		
			<cfloop query="UoM">
			
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
							   customerid       = "#url.customerid#"
							   currency         = "#url.Currency#"
							   ItemNo           = "#itemno#"
							   UoM              = "#uom#"
							   quantity         = "1"
							   returnvariable   = "sale">	
							   
						<cfinvoke component = "Service.Process.Materials.Stock"  
							   method           = "getStock" 
							   warehouse        = "#url.filter1value#" 							  
							   ItemNo           = "#itemno#"
							   UoM              = "#uom#"							  
							   returnvariable   = "stock">		   
						    
		                   	<tr>
		                       	<td width="120px" style="border-right:3px solid silver; padding-right:5px" align="right">								  
		                           	<font size="5" face="calibri">
		                           	<font size="4">#url.currency#</font><br>#numberformat(Sale.Price,",.__")#</font>	
									<cfif sale.Inclusive eq "1">
									<br>
									<font size="1" face="calibri"><cf_tl id="includes tax"></font>
									</cfif>
		                        </td>		                           
		                       	<td style="padding-left:5px" align="left">
								    <table cellspacing="0" cellpadding="0">
									<tr><td><font size="2" face="calibri"><i>#ItemBarCode#</i></font></td></tr>
									<tr><td>
		                           	<font size="3" face="calibri">#UoMDescription#</font>
									</td></tr>
									<tr><td>
																											
									<cfif stock.reserved neq "">
									<cfset pos = stock.onhand - stock.reserved>
									<cfelse>
									<cfset pos = stock.onhand>
									</cfif>
																		
									<cfif pos gte "1">
									
									<table>
									<tr class="labelmedium">
										<td><cf_tl id="Store"></td><td><font color="008000">#pos#</font></td>
									</tr>
									
									<cfquery name="Location" 
								       datasource="AppsMaterials" 
								       username="#SESSION.login#" 
								       password="#SESSION.dbpw#">
								         SELECT    *
								         FROM      ItemWarehouseLocation
										 WHERE     ItemNo    = '#itemno#'		
										 AND       UoM       = '#UoM#'
										 AND       Warehouse = '#url.filter1value#'
										 AND       Operational = 1 				 
										 ORDER BY  PickingOrder
								    </cfquery>
									
									<cfif location.recordcount gte "1">
									
										<cfloop query = "Location">
										
											<cfinvoke component = "Service.Process.Materials.Stock"  
											   method           = "getStock" 
											   warehouse        = "#url.filter1value#" 
											   location         = "#location#"							  
											   ItemNo           = "#itemno#"
											   UoM              = "#uom#"							  
											   returnvariable   = "stock">		
											   
											   <cfif stock.reserved neq "">
												<cfset pos = stock.onhand - stock.reserved>
												<cfelse>
												<cfset pos = stock.onhand>
												</cfif>
												
												<tr class="labelmedium">
												<td><cf_tl id="Location"></td><td><font color="008000">#pos#</font></td>
												</tr>
											   
										</cfloop>									
									
									</cfif>
									
									</table>																
									
									<cfelse>
									
									<font face="Calibri" size="2" color="FF0000">not available</font>

									</cfif>
									</td>
									</tr>
									</table>
		                        </td>
								<td align="right" style="padding-right:20px">
								  <cfif pos gte "1">	
								  <cfset show = "1">
								  <input type="text" 
								      name="Quantity_#replace(UoM,"/","")#" 
									  id="Quantity_#replace(UoM,"/","")#" 
									  value="#qty#" 
									  style="text-align:center;width:50;height:40;font:30px">
								  <cfelse>								  
								  <input type="hidden" 
								      name="Quantity_#replace(UoM,"/","")#" 
									  id="Quantity_#replace(UoM,"/","")#" 
									  value="0" 
									  style="text-align:center;width:50;height:40;font:30px">	  
								  </cfif>	  
								</td>
								   
		                       </tr>
		                   </table>
		               	
		               </td>
		        </tr>
			
			</cfloop>
			
			<tr><td style="border-bottom:1px solid silver" height="20"></td></tr>
						
			<tr><td align="center">
						  			  
			  <cfset setlink = "ColdFusion.navigate('#link#&action=insert&#url.des1#=#url.itemNo#','#url.box#','','','POST','itemform')">
			  
			  <cfif url.module eq "Workorder">
			  
			  <cfelse>
			  
			  	<input type="hidden" name="Form.CustomerId"        value="#url.customerid#">
				<input type="hidden" name="Form.CustomerIdInvoice" value="#url.customeridinvoice#">
				<input type="hidden" name="Form.Currency"          value="#url.currency#">
			  
			  </cfif>		
			  
			  <cfif show eq "1">				 	 	  
			  
				  <input type="button" class="button10s" style="width:165;height:35"
				    onclick="#setlink#;<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>" name="Select" value="Save">			  
				
			  </cfif>
			  			 						
			  </td>
			  
			</tr>
			
		
		</cfif>
		      			  
	</table>

</cfoutput>

</form>

