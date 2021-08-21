<cfparam name="url.sort"  default="category">

<cfset dest = "userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc#">

<cfquery name="ResultList" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   #dest# D, Materials.dbo.#CLIENT.LanPrefix#Ref_CategoryItem C
	WHERE  D.CategoryItem = C.CategoryItem
	AND    D.Category     = C.Category		
	AND    Operational    = 1
	<!--- 
	WHERE  ToBeRequested > 0 
	--->
	<cfif url.sort eq "Category">
	ORDER BY D.Category,CategoryItemOrder, D.CategoryItem,ItemDescription,UoM
	<cfelseif url.sort eq "Item">
	ORDER BY D.Mission,D.ItemNoExternal,ItemDescription,UoM
	<cfelse>
	ORDER BY D.Category,CategoryItemOrder, D.CategoryItem,ItemDescription,UoM
	</cfif>
	
</cfquery>

<cfif ResultList.recordcount gte "250">

	<table class="formspacing">

	<tr><td height="30"></td></tr>
	<tr><td height="100%" colspan="3" align="center" class="labelmedium" style="padding-left:20px">
		<cf_tl id="There were too many items found that would need to be replenished. Please update your filtering">
	</td>
	</tr>
	<tr> 	  
	 <TD height="20" style="padding-left:20px" align="left" class="labelmedium"><cf_tl id="Filter Item">:</TD>		 
	 <td colspan="2" style="padding-left:20px">
	    <cfoutput>
		   <input type="text" name="filter" id="filter" size="30" class="regularxl" style="font-size:30px;height:40px"
		 	onkeyup="if (event.keyCode == 13) {resupply('s','#url.systemfunctionid#',document.getElementById('restocking').value,'filter')}">					
		</cfoutput> 
	 </td>
	</tr>		
	
	
	</table>
	
	<script>
		Prosis.busy('no')
	</script>

<cfelse>

	<table height="100%" border="0" width="100%" align="center">

	<tr> 	  
	 <TD colspan="3">
	 
	 <cfoutput>
	 <table>
	 <tr>
	 <TD align="left" class="labelmedium"><cf_tl id="Filter Item"></TD>		 
	 <td colspan="2" style="padding-left:4px">
	      
		   <input type="text" name="filter" id="filter" size="20" value="#Form.filter#" class="regularxl" 
		 	onkeyup="if (event.keyCode == 13) {resupply('s','#url.systemfunctionid#',document.getElementById('restocking').value,'filter')}"
			style="border:0px;border-left:1px solid silver;border-right:1px solid silver;background-color:f1f1f1;">		 
		 	
	 </td>
	 <td>
			<table>									  
			   <tr class="labelmedium">			   			   	  
				   <td style="padding-left:10px;padding-right:5px"><cf_tl id="Items"></td>
				   <td style="border-left:1px solid silver;border-right:1px solid silver;width:50px;padding-left:5px;padding-right:5px;" align="center" id="items">#resultlist.recordcount#</td>
				   <td colspan="2" style="padding-left:10px;padding-right:8px" align="right" id="selected"><cf_tl id="Selected">:</td>
				   <td bgcolor="ffffbf" colspan="2" style="border-left:1px solid silver;border-right:1px solid silver;width:50px;padding-left:5px;padding-right:5px;" align="center" class="labelmedium" id="section0"></td>		   		   					   
			   </tr>				   
		   </table>
				
	  </td>				   		
	  </tr>
	  </table>
	</tr>	
	 </cfoutput>
	
	<cfset url.archive = 0>		
			
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
	<cfquery name="PeriodList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT R.*, M.MandateNo 
		FROM   Ref_Period R, 
		       Organization.dbo.Ref_MissionPeriod M
		WHERE  IncludeListing = 1
		AND    M.Mission      = '#URL.Mission#' 
		AND    R.Period       = M.Period
	</cfquery>
		
	<cfif Parameter.DefaultPeriod eq "">
		
		<cfset url.period = periodList.Period>
			
	<cfelse>
		
		<cfset url.period = Parameter.DefaultPeriod>	
		
	</cfif>
		
	<!--- generate a record --->
	<cfinclude template="../../../../Procurement/Application/Requisition/Requisition/RequisitionEntryRecord.cfm">
		
		<cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT L.*
		    FROM RequisitionLine L
			WHERE RequisitionNo = '#URL.ID#'
		</cfquery>				
		
			<cfoutput>
					
			<cfquery name="Unit" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		    	   SELECT 	TOP 1 *
				   FROM 	Warehouse W, Organization.dbo.Organization O
				   WHERE 	Warehouse = '#URL.Warehouse#'
				   AND      W.MissionOrgUnitId = O.MissionOrgUnitId
				   ORDER BY DateEffective
			 </cfquery>
							
			 <input type="hidden" name="requisitionno" id="requisitionno" value="#URL.ID#">	
			 <input type="hidden" name="mission"       id="mission"       value="#URL.Mission#">
			 <input type="hidden" name="warehouse"     id="warehouse"     value="#URL.Warehouse#">	
							 
			</cfoutput>
						
			<script>
				 Prosis.busy('no')
			</script>

			<tr bgcolor="ffffff">
			
				<td height="100%" colspan="3" style="border:0px solid silver">
									
				<cf_divscroll overflowy="scroll" style="padding-right:5px">
														
				<table width="99%" border="0" class="navigation_table">
																				
					<tr class="labelmedium2 line fixrow" style="height:26px;border-top:1px solid silver">
					    <td style="min-width:35px"></td>
						<td align="center" style="min-width:50px;border-left:1px solid silver;padding-right:4px"><cf_tl id="No"></td>
						<td align="center" style="min-width:110px;border-left:1px solid silver;padding-right:4px"><cf_tl id="External"></td>
						<td align="center" style="width:89%;border-left:1px solid silver;padding-right:4px"><cf_tl id="Item"></td>	
						<td align="center" style="min-width:80px;border-left:1px solid silver;padding-right:4px"><cf_tl id="MinOrder"></td>			
						<td align="center" style="min-width:80px;border-left:1px solid silver;padding-right:4px"><cf_tl id="Price"></td>			
						<td align="center" style="min-width:50px;border-left:1px solid silver;padding-right:4px" align="right"><cf_tl id="Min"></td>
						<td align="center" style="min-width:50px;border-left:1px solid silver;padding-right:4px" align="right"><cf_tl id="Max"></td>
						<td align="center" style="min-width:70px;border-left:1px solid silver;padding-right:4px" align="right"><cf_tl id="OnHand"></td>
						<td style="border-left:1px solid silver;padding-right:4px" align="center" colspan="2"><cf_tl id="Procurement"></td>				
						<td style="border-left:1px solid silver;padding-right:4px" align="center" colspan="2"><cf_tl id="Reserved"></td>				
						<td style="border-left:1px solid silver;padding-right:4px" align="center"><cf_tl id="Economic"></td>				
						<td colspan="2" style="border-left:1px solid silver;border-right:1px solid silver;;padding-right:4px" align="center"><cf_tl id="Proposed"></td>				
					</tr>
							
					<tr class="labelmedium line fixrow2">
					
					    <td colspan="9">
						
						   <table>
						   <tr>	
						   <cfoutput>		  
						   <td>
						   <select name="sort" id="sort" style="border:0px;border-left:1px solid silver;border-right:1px solid silver;width:300px;background-color:ffffcf" class="regularxl" 
							    onChange="resupplysort('s','#url.systemfunctionid#',document.getElementById('restocking').value)">
								<option value="category" <cfif url.sort eq "category">selected</cfif>><cf_tl id="Category"></option>
								<option value="item" <cfif url.sort eq "item">selected</cfif>><cf_tl id="Item"></option>				
							</select>	
							</td>		
							</cfoutput>	  
							
							</tr>
						    </table>						   
									
						</td>
					   
						<td style="border-left:1px solid silver;min-width:55px;padding-right:2px" align="center"><cf_tl id="Request"></td>
						<td style="border-left:1px solid silver;min-width:55px;padding-right:2px" align="center"><cf_tl id="Purchase"></td>				
						<td style="border-left:1px solid silver;min-width:55px;padding-right:2px" align="center"><cf_tl id="Request"></td>		
						<td style="border-left:1px solid silver;min-width:55px;padding-right:2px" align="center"><cf_tl id="Order"></td>					
						<td style="border-left:1px solid silver;min-width:70px;padding-right:4px" align="right"></td>				
						<td colspan="2" style="min-width:90px;border-left:1px solid silver;padding-left:12px;padding-right:10px;border-right:1px solid silver;" align="right">
																	
					     <!---
						 <cfset cnt = 0>
						 --->
																	 				
						 <cfif url.sort neq "Category">
						 
						 		 <cfset section = "0">
						 						 
						       <cfoutput>
							   <table>
							   <tr>
							   <td>
							   <cf_tl id="All" var="tAll">
							   <input type="button" class="button10g" onclick="ptoken.navigate('#session.root#/warehouse/application/stock/resupply/setCheckbox.cfm?warehouse=#url.warehouse#&action=all&lineno=&section=#section#&sort=#url.sort#','submitted')" style="height:19px;width:60;border-top-left-radius:9px;border-bottom-left-radius:9px" value="#tAll#">
							   </td>
							   <td>
		   					   <cf_tl id="None" var="tNone">
							   <input type="button" class="button10g" onclick="ptoken.navigate('#session.root#/warehouse/application/stock/resupply/setCheckbox.cfm?warehouse=#url.warehouse#&action=none&lineno=&section=#section#&sort=#url.sort#','submitted')" style="height:19px;width:60;border-top-right-radius:9px;border-bottom-right-radius:9px" value="#tNone#">
							   </td>
							   </tr>
							   </table>		
							   </cfoutput>
							   
						 </cfif>	   
							
						
						</td>				
				</tr>
				
				<cfset section = 0>
				
				<cfif url.sort eq "Category">
					<cfset lsort[1] = "category">
					<cfset lsort[2] = "CategoryItemOrder">
					<cfset lsort[3] = "CategoryItem">	
				<cfelse>
				    <cfset lsort[1] = "mission">
					<cfset lsort[2] = "ItemNoExternal">
					<cfset lsort[3] = "ItemDescription">	
				</cfif>					
								
				<cfoutput query="ResultList" group="#lsort[1]#">
				
					<cfset cnt=0>
				
					<tr class="fixrow3" style="height:26px">
						
						    <td colspan="4" style="width:100%;padding-top:1px;font-weight:bold" class="labellarge">
							
							<cfif lsort[1] eq "category">
							
								<cfquery name="get" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     #CLIENT.LanPrefix#Ref_Category
									WHERE    Category = '#category#'																				
								</cfquery>		
								
								#get.Description#
								
							</cfif>
							
							</td>																
							<td></td>				
							<td></td>
							<td></td>				
							<td></td>		
							<td></td>							
							<td></td>		
							<td></td>		
							<td></td>	
							<td></td>				
							<td></td>	
							<td colspan="2"></td>				
									
						</tr>									
								
				<cfoutput group="#lsort[2]#">
				
				<cfoutput group="#lsort[3]#">
				
					 <cfset sel = 0>	
				
					<cfif url.sort eq "category">
					
					     <!---
						 <cfset cnt = 0>
						 --->
										    				
				         <cfset section = section + 1>
				 				
						 <tr class="line">
						   <td colspan="4" style="padding-left:5px;width:100%;height:35px" class="labelmedium"><cfif CategoryItemName neq "Default">#CategoryItemName#</cfif></td>
						   <td colspan="12" align="right" style="padding-right:7px">	
							   <table>
							   <tr>
							   <td>
							   <cf_tl id="All" var="tAll">
							   <input type="button" class="button10g" onclick="ptoken.navigate('#session.root#/warehouse/application/stock/resupply/setCheckbox.cfm?warehouse=#url.warehouse#&action=all&lineno=#lineno#&section=#section#&sort=#url.sort#','submitted')" style="height:21px;width:60;border-top-left-radius:4px;border-bottom-left-radius:4px" value="#tAll#">
							   </td>
							   <td>
		   					   <cf_tl id="None" var="tNone">
							   <input type="button" class="button10g" onclick="ptoken.navigate('#session.root#/warehouse/application/stock/resupply/setCheckbox.cfm?warehouse=#url.warehouse#&action=none&lineno=#lineno#&section=#section#&sort=#url.sort#','submitted')" style="height:21px;width:60;border-left:0px;border-top-right-radius:4px;border-bottom-right-radius:4px" value="#tNone#">
							   </td>
							   </tr>
							   </table>		
							   
						   </td>				 
						 </tr>				
					 
					 </cfif>						
				   
					<cfoutput>
					
					    <cf_precision number="#ItemPrecision#">
						<tr class="labelmedium line navigation_row" style="height:20px" bgcolor="<cfif ToBeRequested lt 1>F4f4f4<cfelse>FFFFFF</cfif>">		
								
						<td style="padding-top:2px;padding-left:3px">
						   <table>
						   <tr>
						   <td>
						   <cf_img icon="select" onclick="itemopen('#ItemNo#','#url.systemfunctionid#')" >
						   </td>
						   <td id="act_#lineno#">
						   <cfif hasOccurence eq "">
						   <cf_img icon="delete" onclick="ptoken.navigate('../Resupply/ResupplyDeleteItem.cfm?itemno=#ItemNo#','act_#lineno#')">
						   </cfif>
						   </td>
						   </tr>
						   </table>
						</td>
						<td style="padding-left:3px">#ItemNo#</td>
						<td style="padding-left:3px">#ItemNoExternal#</td>
						<td style="min-width:89%;padding-left:3px"><cfif len(ItemDescription) lte 5>#ItemDescriptionExternal#<cfelse>#ItemDescription#</cfif> : #UOMDescription#</td>	
						
						<cfif hasVendor gte "1" and url.restocking eq "Procurement">
										
							<cfquery name="getRelatedUoM" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								SELECT     TOP 1 IVO.OfferMinimumQuantity, IVO.Currency, IVO.ItemPrice
								FROM       ItemVendor AS IV INNER JOIN
		                        		   ItemVendorOffer AS IVO ON IV.ItemNo = IVO.ItemNo AND IV.UoM = IVO.UoM
								WHERE      IV.ItemNo   = '#ItemNo#' 
								AND        IV.UoM      = '#UoM#'
								<cfif url.offer eq "0">
								AND        IVO.Mission = '#URL.Mission#'
								</cfif>
							    ORDER BY   IV.Preferred DESC, 
								           IVO.DateEffective DESC		
																											
							</cfquery>
												
							<td align="right" bgcolor="FED7CF" style="padding-right:4px">																
								<cfloop query="getRelatedUoM">						
									#OfferMinimumQuantity# 
								</cfloop>	
							</td>
							
							<td align="right" style="border-left:1px solid silver;padding-right:4px" bgcolor="FED7CF">						
								<cfloop query="getRelatedUoM">	
									<table width="100%"><tr><td style="padding-left:3px">#Currency#</td><td align="right">#numberformat(ItemPrice,",.__")#</td></tr></td></table>
								</cfloop>
							</td>
							
						<cfelse>
						
							<td>#MinReorderQuantity#</td>	
							<td></td>
							
						</cfif>	
															
						<td align="right" style="border-left:1px solid silver;padding-right:4px" bgcolor="ffffaf">#numberFormat(MinimumStock,"#pformat#")#</td>
						<td align="right" style="border-left:1px solid silver;padding-right:4px" bgcolor="CCFFCC">#numberFormat(MaximumStock,"#pformat#")#</td>	
						 
						<td align="right" bgcolor="EAFBFD" style="border-left:1px solid silver;padding-right:4px">		
						
						<cfif OnHandMission neq "0">
						
							<cf_UITooltip
								id         = "drill#currentrow#"
								ContentURL = "#session.root#/warehouse/application/Stock/Resupply/GetStockLevel.cfm?mission=#url.mission#&itemno=#ItemNo#&uom=#UoM#"
								CallOut    = "true"
								Position   = "right"
								Width      = "320"							
								Height     = "200"
								Duration   = "300">#numberFormat(OnHand,"#pformat#")#</cf_uitooltip>						
							
						</cfif>
							
						</td>	
						
						<td align="right" style="border-left:1px solid silver;padding-right:4px">
						<cfif InternalRequested neq "0">#numberFormat(InternalRequested,"#pformat#")#</cfif></td>				
						<td align="right" style="border-left:1px solid silver;padding-right:4px">
						<cfset val = requested + onorder>
						<cfif val neq "0">#numberFormat(val,"#pformat#")#</cfif></td>			
						<td align="right" style="border-left:1px solid silver;padding-right:4px">
						<cfset val = Reserved-Fulfilled>
						<cfif val neq "0">#numberFormat(Reserved-Fulfilled,"#pformat#")#</cfif></td>		
						<td align="right" style="border-left:1px solid silver;padding-right:4px">---</td>				
						<td align="right" bgcolor="<cfif EconomicStock lt MinimumStock>FF8080</cfif>" style="border-left:1px solid silver;padding-right:4px">
							<cfif EconomicStock lt MinimumStock><font color="FFFFFF"></cfif>#numberFormat(EconomicStock,"#pformat#")#
						</td>
						
						<cfif (url.restocking eq "Procurement" and (toberequested gte "0" or MaximumStock gt "0")) 
						   or (url.restocking eq "Warehouse"    and toberequested gte "0" and MaximumStock gt "0")>
									
						     <cfset cnt = cnt+1>
						
							 <td align="center" style="border-left:1px solid silver;padding-left:4px;padding-right:4px">
							 
							 <table style="height:100%">
							 
							 <tr><td style="padding-right:5px;padding-top:1px">
														
							<cfset vToBeRequested = ToBeRequested>
							<cfset vInternalDraft = InternalDraft>		
																		
									 
							 <cfif vToBeRequested gt 0 and selected eq '1'>
							 								 								 
							    <cfset sel = sel+1>
							 	<input type="checkbox" style="height:14px;height:14px" class="checkbox_#section# enterastab" name="selected_#lineno#" id="selected_#lineno#" checked value="1" 
								   onClick="resupplyupdate('#lineno#',document.getElementById('requestedqty_#lineno#').value,this.checked,'#section#','#url.sort#')">
								<cfset cl = "no">   
								<cfset color = "C6F2E2">
								   
							 <cfelseif vInternalDraft gt 0 and selected eq '1'>
							 
							    <cfset sel = sel+1>
								
							 	<input type="checkbox" style="height:14px;height:14px" class="checkbox_#section# enterastab" name="selected_#lineno#" id="selected_#lineno#" checked value="1" 
								   onClick="resupplyupdate('#lineno#',document.getElementById('requestedqty_#lineno#').value,this.checked,'#section#','#url.sort#')"> 	
								   
								 <cfset cl = "no">   
								 <cfset color = "C6F2E2">   
								   
							 <cfelse>
							 
							 	<input type="checkbox" style="height:14px;height:14px" class="checkbox_#section# enterastab" name="selected_#lineno#" id="selected_#lineno#" value="1" 
								   onClick="resupplyupdate('#lineno#',document.getElementById('requestedqty_#lineno#').value,this.checked,'#section#','#url.sort#')">
								   								   
								   <cfset cl = "yes"> 
								   <cfset color = "f4f4f4">
								   
							 </cfif>
							   
						     </td>
						
							<td align="right" id="requestedqtycell_#lineno#" style="min-width:50px;height:20px">
																		   						
								  <input type = "Text"
							       name       = "requestedqty_#lineno#"
								   id         = "requestedqty_#lineno#"
							       value      = "#vToBeRequested#"
							       visible    = "Yes"
							       disabled   = "#cl#"
								   onChange   = "resupplyupdate('#lineno#',requestedqty_#lineno#.value,document.getElementById('selected_#lineno#').checked,'#section#','#url.sort#')"
								   style      = "border:0px;border-left:1px solid silver;border-right:1px solid silver;background-color:#color#;padding-right:3px;text-align: right;height:100%;font-size:11px;width:100%"								       
							       maxlength  = "20"
							       class      = "regularxl enterastab enter_#section#">						
							   
						   </td>
						   
						   <td id="message_#lineno#" style="padding-left:3px"></td>
						   
						   </tr>
						   
						   </table>	
						   
						   <td class="hide" id="c#lineno#"></td>				
					   
					   <cfelse>
					   
						   <td></td>
						   <td></td>
					   
					   </cfif>
					   
					   </tr>	
					   
					</cfoutput>  
					
				   <cfif url.sort eq "category">	 		
					
					   <tr><td height="4"></td></tr>
					   <tr>			   
					   <td colspan="4" style="height:25px" class="labelit"></td>
					   <td class="labelmedium" colspan="4"><cf_tl id="Items">&nbsp;:&nbsp;#cnt#</b></td>
					   <td colspan="2" style="padding-right:8px" align="right" id="selected" class="labelmedium"><cf_tl id="Selected"></td>
					   <td bgcolor="ffffbf" 
					     colspan="2" style="border:1px solid silver;padding-left:10px;padding-right:5px;" align="right" class="labelmedium" id="section#section#">#sel#</td>		   		   					   
					   </tr>	
				   
				   </cfif> 
				   
				</cfoutput>  						      
				   
				</cfoutput>
								
				</cfoutput>
				
				</table>
				
				</cf_divscroll>
				
			</td></tr>
			
						
			<cfif ResultList.recordcount gte "1">
			
			<tr><td class="line" colspan="2"></td></tr>	
							
			<cfif url.restocking eq "Procurement">		
			
					
				<!--- 22/3/2017 by default the current period is taken here, little ne3ed to changeit in this screen
				we can adjust it if needed ,but for now we save the space 
								 	
				<tr>
				
					<cfoutput>
				
					<cfquery name="PeriodList" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				       SELECT R.*, M.MandateNo 
					   FROM   Ref_Period R, 
					          Organization.dbo.Ref_MissionPeriod M
					   WHERE  IncludeListing = 1
					     AND  M.Mission      = '#URL.Mission#' 
					     AND  R.Period       = M.Period
				    </cfquery>
									
					<TD width="133" style="padding-left:14px;height:25px" class="labelmedium"><cf_tl id="Period">:</TD>
					<TD>		 
					  
					  <select name="period" id="period" class="regularxl" onChange="javascript:changeperiod('#URL.ID#',this.value,'Edit')">
					     <cfloop query="PeriodList">
					        <option value="#Period#" <cfif Line.Period eq Period> SELECTED</cfif>>#Period#</option>
					     </cfloop>
				      </select>
					  
				    </td>
				
					</cfoutput>
				
				</tr>
				
				--->
				
				<input type="hidden" name="period" id="period" value="<cfoutput>#line.Period#</cfoutput>">
			
			<cfelse>
			
				<!--- select the reason for the request to trigger a workflow if needed --->
				
								
				<tr>
				
				<TD width="133" style="padding-left:14px;height:27px" class="labelmedium"><cf_tl id="Request"></TD>
				
					<cfquery name="RequestTypeList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   * 
							FROM     Ref_Request P
							WHERE    Operational = '1'	
							AND      Code IN (SELECT RequestType 
							                  FROM   Ref_RequestWorkflowWarehouse 
											  WHERE  Code = P.Code 
											  AND    Warehouse = '#url.warehouse#')
							ORDER BY ListingOrder						
					</cfquery>
					
					<cfif RequestTypeList.recordcount eq "0">
									
							<cfquery name="RequestTypeList" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     Ref_Request
									WHERE    Operational = '1'							
									ORDER BY ListingOrder						
							</cfquery>
								
					</cfif>
						
					<td>
										
						<select name="requesttype" id="requesttype" class="regularxl" style="width:328">
							<cfoutput query="RequestTypeList">
								<option value="#Code#">#Description#</option>
							</cfoutput>
						</select>			
			
					</td>
			
				</tr>	
				
				<tr>
					<TD style="padding-left:14px;height:28px" class="labelmedium"><cf_tl id="Priority"> <font color="FF0000">*</font></TD>						
					<td id="requestaction">		
						<cfdiv bind="url:#SESSION.root#/Warehouse/Application/Stock/Resupply/getRequestAction.cfm?warehouse=#url.warehouse#&requesttype={requesttype}">		
					</td>
				</tr>		
					
			</cfif>
			
												
			<TR> 
		       <TD style="padding-left:14px;height:25px" class="labelmedium"><cf_tl id="Unit"><font color="FF0000">*</font></TD>
		       <td align="left">
			   
			   <cfquery name="Units" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		    	   SELECT 	*
				   FROM 	Organization.dbo.Organization O
				   WHERE    Mission    = '#unit.mission#'
				   AND      MandateNo  = '#unit.MandateNo#'
				   AND      HierarchyCode LIKE '#unit.hierarchycode#%'			   
				   ORDER BY HierarchyCode
			   </cfquery>
			   
			    <cfquery name="UserDefault" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			   		SELECT Top 1 OrgUnit
					FROM   Organization.dbo.OrganizationAuthorization
					WHERE  UserAccount = '#Session.acc#' AND Role = 'ProcReqReview'
					ORDER  BY Created DESC
			   </cfquery>		   
			   
			   <select name="orgunit" id="orgunit" class="regularxl" style="width:328">
						<cfoutput query="Units">
							<option value="#OrgUnit#" <cfif UserDefault.OrgUnit eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
						</cfoutput>
				</select>	
			   		   			
			   </td>			  	   
		    </TR>
			
			<input type="hidden" name="fundingentered" id="fundingentered" value="0">	
			
			<cfif url.restocking eq "Procurement">
				
				<TR>
			        <td style="padding-left:13px;height:25px" class="labelmedium" id="fundingrefresh" onclick="funding()">
					<cf_tl id="Funding">
					</td>
					
					<TD id="fundbox" style="padding-right:20px">
					
						<cfset url.access  = "edit">
						<cfset url.per     = "#Line.Period#">
						<cfset url.object  = "">
						<cfset enforcefund = "1">
						
						<cfinclude template="../../../../Procurement/Application/Requisition/Requisition/RequisitionEntryFunding.cfm">
																	
				    </TD>
			      		
				</TR>
			
			</cfif>		
			
			<tr><td style="height:3px"></td></tr>
			<TR> 
		       <TD style="padding-left:14px;height:25px;min-width:200px" class="labelmedium"><cf_tl id="Memo"><font color="FF0000">*</font></TD>
		       <td align="left" style="width:100%">
			   
			    <cf_tl id="Replenishment" var="memo">
				<cfset memo = "#memo# #dateformat(now(),'mm/yyyy')#">
				<input type="text" name="description" id="description" class="regularxl" style="width:80%" value="<cfoutput>#memo#</cfoutput>" maxlength="80">
				
			   </td>			  	   
		    </TR>
			
			<tr><td style="height:3px"></td></tr>
						
			<tr><td id="submitted" colspan="3"></td></tr>	
				
			
			<cfoutput>
			
			<tr><td colspan="2" class="line">
			
				<table align="center">
				<tr>
				
				<td class="labelmedium">
																	
					<cfif url.restocking eq "Warehouse">		
					
						<cfif Unit.supplywarehouse eq "">
						
							<font color="FF0000"><cf_tl id="Request can not be submitted as there is no supply warehouse set"></font>
						
						<cfelse>
						
						  <table align="center">
						  <tr><td style="height:35px">
						  
						      <!--- show only if there are items with status i enabled  --->
							 					
						      <cf_tl id="Save as Draft" var="1">
						  
						      <input type  = "button" 
						         name      = "save"
								 id        = "save" 
						         value     = "#lt_text#" 
								 style     = "width:240px;height:26px;font-size:15px"
								 class     = "button10g" 				
								 onClick   = "Prosis.busy('yes');resupplysubmit('#URL.ID#','#url.systemfunctionid#','i')">		
								 
							</td>
							
							<td style="padding-left:2px">
							
								<cfinvoke component = "Service.Access"  
								   method           = "RoleAccess" 
								   role             = "'ReqClear'"
								   mission          = "#url.mission#"	   
								   MissionOrgUnitId = "#Unit.MissionOrgUnitId#"
								   AccessLevel      = "'1','2'"
								   returnvariable   = "access">	
		   
								<cfif access eq "GRANTED">

								   <cf_tl id="Submit" var="1">
							  
								   <input type="button" 
								         name="save"
										 id="save" 
								         value="#lt_text#" 
										 style="width:170px;height:26px;font-size:15px"
										 class="button10g" 				
										 onClick="Prosis.busy('yes');resupplysubmit('#URL.ID#','#url.systemfunctionid#','')">		
									 
								</cfif>	 
								 
							</td>
							
							</tr></table>	 
						
						</cfif>			
					
					<cfelse>
					
					   <cf_tl id="Submit" var="1">
					  
					   <input type="button" 
					         name="save"
							 id="save" 
					         value="#lt_text#" 
							 style="width:170px;height:29px;font-size:16px"
							 class="button10g" 				
							 onClick="Prosis.busy('yes');resupplysubmit('#URL.ID#','#url.systemfunctionid#','')">					
					
					</cfif>			  
				  			
				</td>
					
				</tr>
				</table>   		 
						 	
			</td></tr>
			</cfoutput> 
			
		</cfif>	
		
</cfif>			
		
</table>
	
<cfset ajaxonload("doHighlight")>

