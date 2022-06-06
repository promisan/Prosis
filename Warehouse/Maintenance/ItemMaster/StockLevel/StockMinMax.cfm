
<cfparam name="URL.ID"      default="0001">
<cfparam name="URL.Mission" default="Promisan">

<!--- show all warehouses of the mission/entity 
that carry this item and that are enabled --->


<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Item
		WHERE  ItemNo = '#URL.ID#'				
</cfquery>	

<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	 SELECT DISTINCT Warehouse
		FROM   ItemTransaction I
		WHERE  Mission = '#URL.Mission#'
		AND    ItemNo  = '#URL.ID#'	
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Operational = 1)		
							 
		UNION 
		
		SELECT DISTINCT Warehouse
		FROM   ItemWarehouse I
		WHERE  ItemNo  = '#URL.ID#'	
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Mission     = '#url.mission#'
							 AND    Operational = 1)		
	
	    UNION
		
		SELECT DISTINCT Warehouse
		FROM   WarehouseCategory I
		WHERE  Category = '#get.Category#'
		AND    Operational = 1
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Mission     = '#url.mission#'
							 AND    Operational = 1)	
	    
</cfquery>	

<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   ItemUoM
		WHERE  ItemNo = '#URL.ID#'		
		AND    Operational = 1		
		ORDER BY UoM
</cfquery>	

<cfquery name="TaxList"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Tax
		
</cfquery>	

<table width="100%">
    <tr><td height="10"></td></tr>
	<tr>
		<td valign="middle" class="labellarge" style="font-size:17px">
			<cfoutput>
				<a href="javascript:toggleAllStockLevelWarehouse();">
					<img src="#SESSION.root#/Images/expand1.gif" id="twistie" height="18">&nbsp;<cf_tl id="Expand / collapse all facilities"></span>
				</a>
			</cfoutput>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
</table>

<cfform method="POST" id="inputform">

<table id="stockListing" width="99%">

	<cfset row = 0>

	<cfoutput query="warehouse">	
			
	<cfquery name="get"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Warehouse
			WHERE  Warehouse = '#warehouse#'				
	</cfquery>	
	
	<cfset w = warehouse>
	
	<cfinvoke 
		component		= "Service.Presentation.Presentation"
       	method			= "highlight2"
		tableListingId 	= "stockListing"
		multiselect		= "no"
		rowCounter		= "#warehouse.currentrow#"
    	returnvariable	= "highlightStyle">
		
	<tr #highlightStyle# class="line">
		<td colspan="2" style="height:35px;font-size:19px;padding-left:4px;cursor:pointer;" onclick="toggleStockLevelWarehouse('#w#');">
			<img src="#SESSION.root#/Images/arrow.gif" class="twistie" id="twistie_#w#" height="11"> &nbsp;
			#get.WarehouseName# <font face="Calibri" size="2">[#w#]</font>
		</td>			
	</tr>
		
	<tr id="trDetail_#w#" style="display:none;" class="trDetail">
	
		<td width="20"></td>
		<td width="100%">
			<table width="100%" align="center" class="formspacing">
			
			<cfloop query="ItemUoM">
	
			    <cfset row = row + 1>
			
				<cfquery name="whs"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM   ItemWarehouse
					WHERE  Warehouse = '#W#'
					AND    ItemNo    = '#URL.ID#'
					AND    UoM       = '#UoM#'
					AND    Operational = 1
				</cfquery>	
							
				<tr class="labelmedium">
					<td style="padding-top:4px;font-weight:bold;padding-left:15px;font-size:17px">#UoMDescription# (#UoM#)</td>
				</tr>	
				<tr>
					
					<td style="padding-left:10px">
						<table width="100%"  align="center">
													
							<tr class="labelmedium2">
								<cfif whs.MinimumStock gt whs.MaximumStock>
									<cfset cl = "yellow">
								<cfelse>
									<cfset cl = "">
								</cfif>
								
								<td style="padding-left:5px;" width="18%"><cf_tl id="Minimum Stock">:</td>
								
								<td bgcolor="#cl#" align="left">
											
									<cfinput type="Text" 
										name="MinimumStock_#row#" 
										message="Please enter a numeric value"
										value="#whs.MinimumStock#"
										class="regularxxl"				
										required="Yes"
										style="border:0px;background-color:e1e1e1;text-align:center;width:50"				
										visible="Yes" enabled="Yes">
										
								</td>	
								
								<cfif whs.MinimumStock gt whs.MaximumStock>
									<td>
									<img src="#SESSION.root#/images/alert.gif" alt="Exceeds maximum" border="0">				
									</td>
								<cfelse>
								    <td></td>					
								</cfif>	
								
								<td style="padding-left:10px;min-width:170px"><cf_tl id="Maximum Stock">:</td>				
								<td colspan="2" align="left">
								
									<cfinput type="Text" 
										name="MaximumStock_#row#" 				
										message="Please enter a numeric value"
										value="#whs.MaximumStock#"				
										required="Yes"
										class="regularxxl"
										style="border:0px;background-color:e1e1e1;text-align:center;width:50"
										visible="Yes" enabled="Yes">
								</td>
							</tr>
																					
							<tr class="labelmedium2">
								
								<td style="padding-left:5px;"><cf_tl id="Tax">:</td>
								<td colspan="2">
								
								<cfselect name="TaxCode_#row#"
							          query="taxlist"
							          value="TaxCode"
							          display="Description"
							          selected="#whs.TaxCode#"
							          visible="Yes"
							          enabled="Yes"
							          required="Yes"
							          type="Text"
									  style="border:0px;background-color:e1e1e1;font:10px"
							          class="regularxxl"/>									
								
								</td>
								
								<td style="padding-left:10px;"><cf_tl id="Min Order">:</td>
								    <cfif whs.MinReorderQuantity gt whs.MaximumStock>
										<cfset cl = "yellow">
									<cfelse>
										<cfset cl = "">
									</cfif>
								
								<td bgcolor="#cl#">
								
									<cfinput type="Text" 
									    name     = "MinReorderQuantity_#row#" 				
										value    = "#whs.MinReorderQuantity#"
										required = "Yes"
										message  = "Please enter a numeric value"				
										class    = "regularxxl"
										style    = "border:0px;background-color:e1e1e1;text-align:center;width:50px"
										visible  = "Yes" 
										enabled  = "Yes">
									
								</td>
								
								<cfif whs.MinReorderQuantity gt whs.MaximumStock>
									<td style="padding-left:3px">
									<img src="#SESSION.root#/images/alert.gif" alt="Exceeds maximum" border="0"></td>
								<cfelse>
									<td></td>
								</cfif>
								
							</tr>							
																						
							<tr class="labelmedium2">	
								<td style="height:26;padding-left:5px;"><cf_tl id="Replenishment">:</td>
								<td colspan="2">			
									<input type="checkbox" class="radiol"
									       name="ReorderAutomatic_#row#" 
										   id="ReorderAutomatic_#row#"
										   <cfif whs.ReorderAutomatic eq "1">checked</cfif>
										   value="#whs.reorderautomatic#">
										   
								</td>
													
								<td colspan="4" style="padding-left:10px;">								
								<table>
								<tr>
								    <td><cf_tl id="Through">:</td>
									<td><input type="radio" class="radiol" name="Restocking_#row#" id="Restocking_#row#" value="Procurement" <cfif whs.Restocking neq "Warehouse">checked</cfif>></td>
									<td style="padding-left:4px"><cf_tl id="Procurement"></td>
									<td style="padding-left:4px"><input type="radio" class="radiol" name="Restocking_#row#" id="Restocking_#row#" value="Warehouse" <cfif whs.Restocking eq "Warehouse">checked</cfif>></td>
									<td style="padding-left:4px"><cf_tl id="Parent Warehouse"></td>								
								</tr>
								</table>	
								</td>					
								
							</tr>								
																					
							<tr class="labelmedium2">	
								<td style="padding-left:5px;"><cf_tl id="Request">:</td>
								<td colspan="4">
								<table><tr class="labelmedium2">
								<td>
								<input type="radio" class="radiol" name="RequestType_#row#" id="RequestType_#row#" value="Regular" <cfif whs.RequestType neq "Pickticket">checked</cfif>>
								</td>
								<td style="padding-left:4px"><cf_tl id="Regular"></td>
								<td style="padding-left:6px"><input type="radio" class="radiol" name="RequestType_#row#" id="RequestType_#row#" value="Pickticket" <cfif whs.RequestType eq "Pickticket">checked</cfif>></td>
								<td style="padding-left:4px"><cf_tl id="Pickticket"></td>	
								</tr></table>
								
							</tr>							
																					
							<tr class="labelmedium2">	
								<td title="Record the number of days over which the average comsumption will be calculated" 
								style="padding-left:5px;"><cf_tl id="Average Days">:</td>
								<td colspan="2">
									<cfinput type="Text" 
									name="AveragePeriod_#row#" 				
									value="#whs.AveragePeriod#"
									required="Yes"
									message="Record the number of days over which the average comsumption will be calculated" 
									validate="integer"
									class="regularxxl" 
									size="3" 
									maxlength="3"
									style="text-align:center;border:0px;background-color:e1e1e1;"
									visible="Yes" enabled="Yes">
								</td>
								
								<!---
								<td><cf_tl id="Average">:</td>
								<td colspan="2">
									
									<!---
									<b>#lsNumberFormat(whs.distributionAverage,",.___")#</b>
									--->
									
									
									
								</td>
								
								--->
								
							</tr>	
							
							<cfquery name="stockC"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT 	C.*,
												ISNULL((SELECT TargetQuantity FROM ItemWarehouseStockClass WHERE Warehouse = '#w#' AND ItemNo = '#url.id#' AND UoM = '#uom#' AND StockClass = C.Code),0) as TargetQuantity
										FROM   	Ref_StockClass C
										ORDER BY C.ListingOrder ASC
									</cfquery>
									
							<cfif stockC.recordcount gte "1">	
														
								<tr class="labelmedium2">	
									<td style="padding-left:5px;"><cf_tl id="Stock Class">:</td>
									<td colspan="5">
																		
										<table>
											<tr>
												<cfloop query="stockC">
													<td class="labelmedium2">#Description#:</td>
													<td style="padding-left:4px;padding-right:10px">
														<cfinput type="Text" 
															name="TargetQuantity_#row#_#code#" 				
															value="#targetQuantity#"
															required="Yes"
															message="Please enter an integer average days value" 
															validate="numeric"
															class="regularxxl" 
															size="4" 
															maxlength="10"
															style="text-align:right; padding-right:2px;">
													</td>												
												</cfloop>
											</tr>
										</table>
										
									</td>
								</tr>
							
							</cfif>
							
							<cfquery name="getTopics" 
								datasource="AppsMaterials"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									
									SELECT	 P.Description,P.SearchOrder,T.*, T.Description as TopicDescription
									FROM     Ref_Topic T 
												-- AND  ValueClass IN ('List','Lookup')
											 INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent	
									WHERE    T.TopicClass = 'ItemUoM'															
									
							</cfquery>
														 
							 <tr><td colspan="6" style="padding-right:40px">
							 							 
							 <table>
							 
							  <tr class="line">  	
								  
								  	<td width="80" height="23" style="padding-left:5px" class="labelmedium2"><cf_tl id="Replenishment topic"></td>
																	
								    <cfloop index="itm" list="System,OE">
									
										<cfif itm eq "OE">
										<td colspan="4"><cf_tl id="Expert opinion"></td>										
										<cfelse>
										<td colspan="3"><cf_tl id="Generated"></td>
										</cfif>
																		
									</cfloop>
									
							 </tr>		
																												
							<cfloop query="getTopics">
															
								  <tr>  	
								  
								  	<td width="80" height="23" style="border:1px solid solid silver;min-width:230px;padding-left:5px" class="labelmedium2">#TopicDescription#: <cfif ValueObligatory eq "1"><font color="ff0000">*</font></cfif></td>
																	
								    <cfloop index="src" list="System,OE">										
									  
										<cfquery name="getValue" 
										datasource="AppsMaterials"
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										  	SELECT   DateEffective, 
											         ListCode, TopicValue, TopicAttribute1, TopicAttribute2, TopicAttribute3
			                                FROM     ItemUoMTopic
			                                WHERE    ItemNo    = '#URL.Id#' 
											AND      UoM       = '#ItemUoM.UoM#' 
											AND      Topic     = '#Code#' 
											AND      Warehouse = '#w#' 
											AND      Source    = '#itm#' 
											AND      Mission is NULL 
											AND      Operational = 1
			                                ORDER BY DateEffective DESC
										</cfquery>											
									
										<td style="padding-left:9px;padding-right:3px;min-width:100px">										
										
										<cfif getValue.dateEffective neq "">
										    <cfset st  = dateformat(getValue.dateEffective, client.dateformatshow)>
											<cfset sts = "#Dateformat(getValue.dateEffective, 'YYYYMMDD')#">
										<cfelse>
											<cfset st = dateformat(now(), client.dateformatshow)>
											<cfset sts = "#Dateformat('01/01/2020', 'YYYYMMDD')#">
										</cfif>
																														
										<cf_setCalendarDate
										      name     = "DateEffective_#row#_#Code#_#src#"     
											  id       = "DateEffective_#row#_#Code#_#src#"   											        
										      font     = "16"
											  edit     = "Yes"
											  class    = "regularxxl"				  
											  value    = "#st#"
										      mode     = "date"> 																				
										
										</td>								
									
									<td style="min-width:80px;padding-left:3px">																		
																		   
										<cfif ValueClass eq "List">
										
										    <!---
										
											<cfquery name="GetList" 
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT	T.*, 
															P.ListCode as Selected
													FROM 	Ref_TopicList T 
															LEFT OUTER JOIN #tbcl# P ON P.Topic = T.Code AND P.ItemNo = '#url.id#'
													WHERE 	T.Code = '#Code#'  
													AND 	T.Operational = 1
													ORDER BY T.ListOrder ASC
											</cfquery>
											
											<select class="regularxxl" name="Topic_#Code#" ID="Topic_#Code#">
												<cfif ValueObligatory eq "0">
													<option value=""></option>
												</cfif>
												<cfloop query="GetList">
													<option value="#GetList.ListCode#" <cfif GetList.Selected eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
												</cfloop>
											</select> 
											
											--->
											
										<cfelseif ValueClass eq "Lookup">
										
										    <!---
										
											<cfquery name="GetList" 
												  datasource="#ListDataSource#" 
												  username="#SESSION.login#" 
												  password="#SESSION.dbpw#">
											
													 SELECT     DISTINCT 
													            #ListPK# as ListCode, 
													            #ListDisplay# as ListValue,
															    #ListOrder# as ListOrder,
															    P.Value as Selected
													  FROM      #ListTable# T LEFT OUTER JOIN 
															   	(SELECT ItemNo, Topic, ListCode As Value 
																 FROM   Materials.dbo.#tbcl# 
																 WHERE  ItemNo='#Item.ItemNo#') P ON P.Topic = '#GetTopics.Code#' 
													  WHERE     #PreserveSingleQuotes(ListCondition)#
													  ORDER BY  #ListOrder#
											
											</cfquery>
												
											<select class="regularxxl" name="Topic_#Code#" ID="Topic_#Code#">
												<cfif ValueObligatory eq "0">
													<option value=""></option>
												</cfif>
												<cfloop query="GetList">
													<option value="#ListCode#" <cfif Selected eq ListCode>selected</cfif>>#ListValue#</option>
												</cfloop>
											</select> 	
											
											--->
											   
										<cfelseif ValueClass eq "Text">																																								
											
											<cfinput type = "Text"
										       name       = "Topic_#row#_#Code#_#src#"
										       required   = "#ValueObligatory#"					     
										       size       = "#valueLength#"
											   style      = "width:99%;text-align:right;padding-right:4px;<cfif src eq 'System'>background-color:eaeaea<cfelse>background-color:ffffff</cfif>"
											   class      = "regularxxl enterastab"
											   message    = "Please enter a #Description#"
											   value      = "#GetValue.TopicValue#"
										       maxlength  = "#ValueLength#">   
											   
										<cfelseif ValueClass eq "Numeric">											
											
											<cfinput type = "Text"
										       name       = "Topic_#row#_#Code#_#src#"
										       required   = "#ValueObligatory#"					     
										       size       = "#valueLength#"
											   style      = "width:99%;text-align:right;padding-right:4px;<cfif src eq 'System'>background-color:eaeaea<cfelse>background-color:ffffff</cfif>"											 
											   validate   = "float"
											   class      = "regularxxl enterastab"
											   message    = "Please enter a #Description#"
											   value      = "#GetValue.TopicValue#"
										       maxlength  = "#ValueLength#">   				   
											  										    
										</cfif>
														
									</td>
									
									<cfif src eq "OE">
																										
										<td style="padding-left:3px;width:60%">
										  <input class="regularxxl" style="min-width:300px;width:99%;background-color:ffffcf" type="text" 
										  name="Memo_#row#_#Code#_#src#">
										</td>
										
										</cfif>		
									
									<td style="padding-left:2px">
									
									<input type="button" value="H" style="height:28px;width:30px;border:1px solid silver" class="button10g" title="History">
									
									</td>
																	
									
									</cfloop>
									
									<td style="width:10%"></td>
																		
									</tr>							
								
							</cfloop>	
							
							</table></td></tr>	
							
							<tr><td style="padding-top:4px"></td></tr>								
							<tr class="labelmedium2">	
								<td style="padding-left:5px;"><cf_tl id="Shipping Memo">:</td>
								<td colspan="6">
								<input type="text" name="ShippingMemo_#row#" id="ShippingMemo_#row#" value="#whs.ShippingMemo#" style="border:0px;background-color:e1e1e1;f1f1f1;width:90%;height:25;font-size:14px;padding:3px" class="regular">
								</td>
							</tr>	
							
							<tr style="height:6px"><td></td></tr>						
														
						</table>
					</td>
				</tr>
							
				</cfloop>
				
			</table>
		</td>
	</tr>
	
	</cfoutput>
		
	<tr>
		<td colspan="2" align="center" style="height:40px">
			<input type="button" style="width:140px" class="button10g" name="Save" id="Save" value="Save" onclick="itmlevelsubmit()">
		</td>
	</tr>
	
</table>

</cfform>



