
<cfparam name="URL.id"        default="0000">
<cfparam name="URL.mission"   default="Promisan">
<cfparam name="URL.Group"     default="ItemNo">
<cfparam name="URL.Page"      default="1">
<cfparam name="URL.IDStatus"  default="2">
<cfparam name="URL.ItemClass" default="Supply">
<cfparam name="URL.fnd"       default="">

<cfinvoke component = "Service.Access"  
     method             = "function"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 warehouse          = "#url.warehouse#"
	 SystemFunctionId   = "#url.SystemFunctionId#" 
	 returnvariable     = "access">	 	

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr><td align="center" height="40" class="labelit">
			    <font color="FF0000">
				<cf_tl id="Detected a Problem with your access"  class="Message">
				</font>
			</td></tr>
	</table>	
	<cfabort>	
		
</cfif>		

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
<cfif URL.Group eq "">
  <cfset URL.Group = "ItemNo">
</cfif>

<cfinclude template="getListingData.cfm">

<cfquery name="get" dbtype="query">	
	SELECT DISTINCT Reference 
	FROM   SearchResult
</cfquery>

<cfset rows = 10>
<cfset first   = ((URL.Page-1)*rows)+1>
<cfset pages   = Ceiling(get.recordCount/rows)>
<cfif pages lt '1'>
   <cfset pages = '1'>
</cfif>

<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">
	
<form method="post" name="pickingform" id="pickingform">

<table width="100%"      
     border="0"
	 align="center"
	 class="formpadding"
     cellspacing="0"	   
	 cellpadding="0">
	 
	  <cfoutput>
	  
	 <!---
	   
	<tr>
	  <td height="57">
	 
		 
		  
	  			<table height="57px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
					<tr>
						<td style="z-index:5; position:absolute; top:5px; left:35px; ">
							<img src="#SESSION.root#/images/shipbox.jpg" width="60" height="60">
						</td>
					</tr>							
					<tr>
						<td style="z-index:3; position:absolute; top:27px; left:100px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
							<cfoutput>#lt_content#</cfoutput>
						</td>
					</tr>
					<tr>
						<td style="position:absolute; top:4px; left:100px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
							<cfoutput>#lt_content#</cfoutput>
						</td>
					</tr>							
					<tr>
						<td style="position:absolute; top:55px; left:100px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">								
						</td>
					</tr>							
				</table>
		
		  </td>
		  
	</tr>
	
	--->
	
	<tr>  
		  <td style="height:40px;padding-left:20px">
		  
		  	<table class="formspacing">
			<tr>			
				<td><input type="radio" checked name="Process" id="Process" value="Process" style="height:19px;width:19px" class="radiol" onclick="stockpicking('s','#url.systemfunctionid#')"/></td>
				<td style="padding-top:3px;font-size:18px;padding-left:3px" class="labelmedium"><cf_tl id="Process Replenishment request or Internal request"></td>
				<td style="padding-left:10px"><input type="radio" name="Process" id="Process" style="height:19px;width:19px" value="Pending" class="radiol" onclick="stockbackorder('s','#url.systemfunctionid#')"/></td>
				<td style="padding-top:3px;font-size:18px;padding-left:3px" class="labelmedium"><cf_tl id="On Backorder"></td>		
				<td style="padding-left:10px"><input type="radio" name="Process" id="Process" style="height:19px;width:19px" value="Shipping" class="radiol" onclick="stockshipment('s','#url.systemfunctionid#')"/></td>
				<td style="padding-top:3px;font-size:18px;padding-left:3px" class="labelmedium"><cf_tl id="Pending shipment"></td>		
			</tr>
			</table>
				
		  </td>		 
	  
  </tr>	 	  
		  
  </cfoutput>
	  
  <tr><td colspan="3" height="1" class="line"></td></tr>
	  	   
  <tr onKeyUp="javascript:search()">
  
	  <td valign="top" colspan="3" width="100%" style="padding-left:20px;border:0px dotted silver">
					
				<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
				
				<tr>
				<td class="labelit"><cf_tl id="Filter">:</td>
				
				<td width="238px" class="labelit" style="border:0px solid silver;padding-left:3px">
				
				  <cfoutput>
				  	
					  <table>
					  <tr><td>				  
					
					   
						   <input type   = "text"
						       name      = "find"
							   id        = "find"
						       value     = "#URL.Fnd#"
						       size      = "15"
						       maxlength = "25"
						       class     = "regularxl"
						       style     = "border: 1px solid silver;"
						       onClick   = "javascript:clearsearch()">
						   
						   </td>
						   <td style="padding-left:3px">					   
						    
					     		<img src="#SESSION.root#/Images/search.png" 
								  alt         = "Search" 
								  name        = "locate" 
								  height      = "25"
								  width       = "25"
								  onMouseOver = "document.locate.src='#SESSION.root#/Images/contract.gif'" 
								  onMouseOut  = "document.locate.src='#SESSION.root#/Images/search.png'"
								  style       = "cursor: pointer; height:25px;border-radius:4px" 
								  border      = "0" 
								  align       = "absmiddle" 
								  onclick     = "stockpicking('s','#url.systemfunctionid#')">				   			
							  
							 </td>
							 
							 </tr>
							 
	  				 </table> 			  
				
				</td>
				
				<TD height="26" align="right" style="padding-right:1px">	
						
					<select name="group" id="group" class="regularxl" size="1" onChange="stockpicking('s','#url.systemfunctionid#')">
					     <option value="Location" <cfif URL.Group eq "Location">selected</cfif>><cf_tl id="Group by Location">
					     <OPTION value="ItemNo" <cfif URL.Group eq "ItemNo">selected</cfif>><cf_tl id="Group by Item">
					</SELECT> 
					
				   	<select name="page" id="page" class="regularxl" size="1" onChange="stockpicking('s','#url.systemfunctionid#')">
					    <cfloop index="Item" from="1" to="#pages#" step="1">
					        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
				    	</cfloop>	 
					</SELECT>   
					
				
				</TD>
				</tr>
				</table>	
				
				</cfoutput>			
	  </td>			
  </tr>
 
  <tr><td colspan="2" height="36" style="padding-left:25px">
  <cf_tl id="Process Selected Requests" var="1">
  <cfoutput>
	  <input type="button" class="button10g" style="width:230px;height:27" name="Add" id="Add" onclick="stockpickingprocess('#url.systemfunctionid#')" value="#lt_text#">
  </cfoutput>
  </td></tr>
  
  <tr><td colspan="2" height="1" class="linedotted"></td></tr>
					
  <TR>
	<td colspan="2" valign="top">
				
		<table width="93%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
		
		<cfoutput>
		
		 <cfif SearchResult.recordcount gte "1">
		
		<tr class="labelmedium line">
		    <!---
		    <TD width="15%"><cf_tl id="Contact"></TD>	
			--->
		    <td align="right" width="3%" height="18" style="padding-right:5px">
				<cf_tl id="Select all" var="1">
				<input type     = "Checkbox" 
						name    = "CBRequest_SelectALL" 
						id      = "CBRequest_SelectALL" 		
						style   = "height:14px; width:14px;" 										
						class   = "clsCBRequest_SelectALL" 
						onclick = "reqSelectALL(this, '.clsCBRequest,.clsCBRequest_SelectALL_Class');" 
						title   = "#lt_text#" checked>
			</td>						
					
			<TD width="20%"><cf_tl id="Item"></TD>			
		    <TD width="10%"><cf_tl id="UoM"></TD>
			<td style="width:10px"></td>
		    <TD width="7%" align="right"><cf_tl id="Qty"></TD>
			<TD width="9%" align="right"><cf_tl id="Picked"></TD>
			<td width="8%" align="right"><cf_tl id="Cost"></td>
			<td width="9%" align="right"><cf_tl id="Total"></td>
			<td width="8%" align="right"><cf_tl id="Price"></td>
			<td width="9%" align="right"><cf_tl id="Total"></td>
		</TR>
				 
		 </cfif>
		 
		 		 
		 <cfif SearchResult.recordcount eq "0">
		 
		  <tr>
		  <td colspan="10" align="center" class="labelmedium" style="height:40px">
			  <font color="gray"><cf_tl id="There are no items to show in this view"></font>
		  </td>
		  </tr>
		 
		 </cfif> 
							
	 	<input type="hidden" name="refresh" id="refresh" onClick="javascript:stockpicking('s','#url.systemfunctionid#')">	
											
		</cfoutput>
				
				<cfset row   = 0>
				<cfset grp   = 1>
				<cfset prior = "">
				
				<cfset amtT    = 0>
				<cfset amt    = 0>
				
				<cfset start = ((url.page-1)*rows)+1>
																
				<cfoutput query="SearchResult" group="reference">
				
					<cfset row = row+1>
																												
				    <cfif row gte start and row lte rows*url.page>										
																									
					<cfquery name="getTotal" dbtype="query">
						SELECT count(*) as Counted, 
							   SUM(ItemAmount) as ItemAmount,	
						       SUM(RequestedAmount) as RequestedAmount
						FROM   SearchResult
						WHERE  Reference = '#reference#'
					</cfquery>
					
					<tr><td height="10px"></td></tr>
					
					<tr class="labelmedium">
						<td id="tdHeader" colspan="5" style="height:30;font-size:15px;">
							<table>
								<tr>
									<td style="padding-right:5px">
										<cfset vReference = replace(reference," ","","ALL")>
										<cfset vReference = replace(vReference,"-","","ALL")>
										<cf_tl id="Select all within this class" var="1">
										
										<input type="Checkbox" 
											name="CBRequest_Select_#vReference#" 
											id="CBRequest_Select_#vReference#" 
											style="height:17px; width:17px;" 
											class="clsCBRequest_SelectALL_Class" 
											onclick="reqSelectALL(this, '.clsCBRequest_#vReference#');" 
											title="#lt_text#"
											checked>
									</td>
									<td style="padding-left:10px;"><b><label for="CBRequest_Select_#vReference#">#ucase(reference)#</label></td>
									<td style="padding-left:10px;"><b>#dateformat(DateDue,client.dateformatshow)#</td>
									<td style="padding-left:10px;"><b>#Remarks#</td>
								</tr>
							</table>
						</td>
						<td align="right" class="labelmedium"><!---#getTotal.counted#---></td>
						<td class="labelit">#currency#</td>						
						<td align="right" id="boxstd_#reference#" style="padding-right:1px;height:27" class="labelmedium">#NumberFormat(getTotal.RequestedAmount,',.__')#</td>
						<td></td>
						<td align="right" id="boxprc_#reference#" style="padding-right:1px;height:27" class="labelmedium">#NumberFormat(getTotal.ItemAmount,',.__')#</td>
						
					</tr>
										
					<cfset priorcontact = "">	
					
					<cfif ShipToWarehouseName neq "">
							   <cfset  to = ShipToWarehouseName>
							<cfelse>
								<cfset to = Contact>
							</cfif>		
					
					<cfif to neq priorcontact>
					
					<tr class="line">
					
						<td valign="top" style="padding-left:10px" colspan="3" class="labelmedium">
							<table>						
								<cfif ShipToWarehouseName neq "">
																								
								<cfquery name="Warehouse" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT * 
										FROM   Warehouse
										WHERE  Warehouse = '#ShipToWarehouse#'
								</cfquery>
	
								<tr class="labelmedium"><td>#to#</td></tr>
								<tr class="labelmedium"><td style="padding-left:15px height:10px;font-size:10px">#Warehouse.Address#</td></tr>
								<cfelse>
								<tr><td>#to#</td></tr>
								</cfif>
							</table>
						</td>
						<td align="right" id="content_#currentrow#" colspan="8"><cfinclude template="PickingHistory.cfm"></td>
					</tr>
					
					</cfif>
																					
					<cfoutput>													
										  				  						
						    <tr class="line navigation_row labelmedium" style="cursor:pointer;height:19px"	
								ondblclick="javascript:item('#ItemNo#','','#URL.Mission#')">
															
							<!---
							<td style="padding-left:3px"><cfif to neq priorcontact>#to#</cfif></td>							
							--->
							
							<cfset priorcontact = to>
							
							<cfif itemClass eq "Supply">
							
						    	<td align="left" style="padding-left:30px;padding-right:7px;">
								
									<cfif Status is '2' or Status is "2b">
									   	<input class="enterastab clsCBRequest clsCBRequest_#vReference#" 
										    type="checkbox" 
											name="selected" 
											id="selected" 
											value="'#RequestId#'" checked>
							    	</cfif>
									
								</td>
								
							<cfelse>
							
						    	<td align="center" style="padding-left:16px">	
															
								   	<cfif Status is "2" or Status is "2b">			
														
										<img src="#SESSION.root#/Images/btn_select.jpg" name="sel#RequestId#" 
											onMouseOver="document.sel#RequestId#.src='#SESSION.root#/Images/btn_select1.jpg'" 
											onMouseOut="document.sel#RequestId#.src='#SESSION.root#/Images/btn_select.jpg'" 
											style="cursor: pointer;" 
											alt="" 
											border="0" 
											onClick="javascript:asset('#RequestId#')">									
										
							    	</cfif>								
								
								</td>
								
						    </cfif>									
							
							<td>#ItemNo# #ItemDescription#</td>							
						    <td>#UoMDescription#</td>
							
							<td align="center" style="width:10px;padding-top:1px" class="navigation_action">
							
								<cfset vTemplate = "Warehouse/Inquiry/Print/PickTicket/PickTicket.cfr">								
								<cf_img icon="print" onClick="javascript:printpickticket('#vTemplate#', '#RequestId#')">
								
							</td>							
							
						    <td align="right" style="padding-bottom:1px">
							
								 <cfif Parameter.EnableQuantityChange eq "1">
						   
								   <input type="text" 
								       name="quantity" 
									   id="quantity"
									   value="#RequestedQuantity#"
								       size="2" 
									   class="regularh enterastab" 
									   maxlength="5" 
									   style="border:0px;border-left:1px solid silver;border-right:1px solid silver;text-align:center;font-size:12px;padding-top:1px"
								       onchange="stockpickingedit('#requestId#',this.value)">		 
								   
						   		<cfelse>
						   
				   					#RequestedQuantity#    
								
							   </cfif>			   
							
							</td>
							<td align="right"><cfif fullfilled eq "">0<cfelse>#fullfilled#</cfif></td>
						    <td style="padding-right:4px" align="right">#NumberFormat(StandardCost,'_____,__.__')#</td>	
							<td id="amount_#requestId#" style="padding-right:1px" align="right">#NumberFormat(RequestedAmount,'_____,__.__')#</td>	
							
							<cfset Amt  = Amt  + RequestedAmount>
						    <cfset AmtT = AmtT + RequestedAmount>
							
							<td style="padding-right:4px" align="right">#NumberFormat(ItemPrice,'_____,__.__')#</td>	
							<td id="sale_#requestId#" style="padding-right:1px" align="right">#NumberFormat(ItemAmount,'_____,__.__')#</td>
						    		
							</tr>
										  
					        <cfset prior = itemno>									
					
					</cfoutput>
					
														
					</cfif>			
												 									
				</CFOUTPUT>
					
			</TABLE>
										
		</td>
		
	</tr>		
	
</table>	

</form>	

<cfset ajaxonload("doHighlight")>
