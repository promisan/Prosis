
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>
	
		<tr style="height:30px">	
		
		<td></td>	
		
		<td colspan="13">
		
			<table width="100%" height="100%" border="0" class="navigation_table">
			     
	 			<cfloop query="ReceiptList">
				
		  		 	 <tr class="labelmedium navigation_row <cfif currentrow neq recordcount>line</cfif>" style="height:15px">
					 
					   <td width="3%" bgcolor="ffffff" align="center">
					   
						   <cfif currentrow eq recordcount>
						   <img src="#SESSION.root#/Images/join.gif" alt="" border="0">
						   <cfelse>
						   <img src="#SESSION.root#/Images/joinbottom.gif" alt="" border="0">
						   </cfif>			   
					   
					   </td>
					   <td width="30" align="center" style="padding-left:2px;padding-right:2px;">
					   
						    <cfif ActionStatus gte "1">
								<img src="#SESSION.root#/Images/checked_green.gif" height="11" alt="Cleared" border="0">
							<cfelse>
								<img src="#SESSION.root#/Images/pending.gif" height="11" alt="Pending Clearance" border="0">
							</cfif>
						
					   </td>
					   
					   <cfif Warehouse neq "">
					   
						   <cfquery name="get" 
							 datasource="AppsMaterials" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							  SELECT  *
							  FROM    Warehouse
						   	  WHERE   Warehouse = '#Warehouse#' 					    	 
						  	</cfquery>		
							
							 <td style="min-width:150px;padding-left:4px">#get.WarehouseName#</td>
							 
							 <cfinvoke component   = "Service.Access"
							   Method            = "procRI"
							   MissionOrgUnitId  = "#get.MissionOrgUnitId#"
							   OrderClass        = "#PO.OrderClass#"
							   ReturnVariable    = "ReceiptAccess">	
							
								<cfif ReceiptAccess eq "NONE">
									<td style="min-width:80px">#ReceiptNo#</td>
								<cfelse>				   
				  	       		<td style="min-width:80px">
									<a href="javascript:receipt('#receiptNo#','receipt')">#ReceiptNo#</a>
								 </td>
								</cfif>						 
							 
						<cfelse>
						
							<cfinvoke component   = "Service.Access"
							   Method            = "procRI"
							   OrgUnit  		 = "#PO.OrgUnit#"
							   OrderClass        = "#PO.OrderClass#"
							   ReturnVariable    = "ReceiptAccess">	
						
							<td></td>	
							
							<cfif ReceiptAccess eq "NONE">
								<td style="min-width:80px">#ReceiptNo#</td>
							<cfelse>				   
			  	       			<td style="min-width:80px"><a href="javascript:receipt('#receiptNo#','receipt')"><font color="0080FF">#ReceiptNo#</font></a></td>
							</cfif>
											   				   
					   </cfif>
					  					   
					   <td style="min-width:90px;padding-right:4px">#DateFormat(DeliveryDate, CLIENT.DateFormatShow)#</td>			   
			  	       <td style="width:35%;padding-left:2px">#ReceiptItem#</td> 
			  		   <td style="width:10%;padding-left:2px">#TransactionLot# </td>		
					   
					   <td width="80" align="right" style="padding-right:5px">
					   
					   <cfif WarehouseItemNo neq "" and WarehouseUoM neq "">
					   
					  	    <cfquery name="getItem" 
							 datasource="AppsMaterials" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							  SELECT  *
							  FROM    Item 
						   	  WHERE   ItemNo = '#WarehouseItemNo#' 					    	 
						  	</cfquery>			
					   
					   	   <cf_precision number="#getItem.ItemPrecision#">
						   
						   #numberformat("#ReceiptWarehouse#","#pformat#")#
					      				   
					   <cfelse>
					   
						   #ReceiptQuantity#
						   
					   </cfif>	   
					   
					   </td>
					 
					   <td width="120">
					   
					   <cfif WarehouseItemNo neq "" and WarehouseUoM neq "">
					   
						    <cfquery name="UoM" 
							 datasource="AppsMaterials" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							  SELECT  *
							  FROM    ItemUoM 
						   	  WHERE   ItemNo = '#WarehouseItemNo#' 
							  AND     UoM    = '#WarehouseUoM#'		   	 
						  	</cfquery>				
							#UoM.UoMDescription#			   
							<cf_space spaces="46">
					   <cfelse>
						   #ReceiptUoM#
					   </cfif>
					   
					   </td>
					   
					   <td width="30" align="right" style="padding-top:2px;font-size:10px;padding-right:4px">#Currency#</td>
					   <td width="8%" align="right" style="padding-right:13px">#NumberFormat(ReceiptAmount,",.__")#</td>
					   <td width="30" align="right" style="padding-top:2px;font-size:10px;padding-right:5px">#APPLICATION.BaseCurrency#</td>
			   		   <td width="8%" align="right" style="min-width:80px;padding-right:20px">#NumberFormat(ReceiptAmountBase,",.__")#</td>			  
					 </tr>
					 
									 				 
				 </cfloop>
				 
				 <cfif ReceiptList.recordcount gt "1">
				 
					 <!--- receipts --->				
					 <cfquery name="ReceiptTotal" dbtype="query">
					  	  SELECT  SUM(ReceiptQuantity) as Quantity,
						          SUM(ReceiptAmountbase) as Total
						  FROM    ReceiptList
				   	 </cfquery>		
				 
					 <tr class="labelit" style="height:28px">
					 	<td colspan="6">
						<td align="right"></td>
						<td align="right" style="padding-top:3px;padding-right:4px"><b>#NumberFormat(ReceiptTotal.Quantity,",.__")#</td>
						<td align="right" colspan="4"></td>						
						<td align="right" style="padding-top:3px;padding-right:20px"><b>#NumberFormat(ReceiptTotal.total,",.__")#</td>
					 </tr>
				 
				 </cfif>
						
			</table>
			
		</td>
		</tr>	
			
</cfoutput>			