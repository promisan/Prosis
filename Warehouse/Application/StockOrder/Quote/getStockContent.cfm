
<cfparam name="form.priceschedule"    default="3">
<cfparam name="Form.Category"         default="">
<cfparam name="Form.SettingOnHand"    default="">
<cfparam name="Form.SettingPromotion" default="">
<cfparam name="Form.FilterMake"       default="">

<cfif Form.filterMake neq "">

	<cfset make = "">
	
	<cfloop index="itm" list="#form.FilterMake#" delimiters="|">
		
		<cfif make eq "">
			<cfset make = "'#itm#'">
		<cfelse>
			<cfset make = "#make#,'#itm#'">	
		</cfif>
	
	</cfloop> 

</cfif>


<cfparam name="Form.FilterSubCat"     default="">

<cfif Form.FilterSubCat neq "">

	<cfset subcat = "">
	
	<cfloop index="itm" list="#form.FilterSubCat#" delimiters="|">
		
		<cfif subcat eq "">
			<cfset subcat = "'#itm#'">
		<cfelse>
			<cfset subcat = "#subcat#,'#itm#'">	
		</cfif>
	
	</cfloop> 

</cfif>


<cfquery name="Topics" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	 	 SELECT     *
         FROM       Ref_Topic
         WHERE      Code IN
                      (SELECT    Code
                       FROM      Ref_TopicCategory
                       WHERE     Category = '#form.category#')
		AND        Operational = 1
		AND        TopicClass = 'Category'	
		AND        ValueClass IN ('List','Text','Lookup')		   
	</cfquery>	
			
	
<cfloop query = "topics">
     <cfparam name="Form.Filter#code#"     default="">
</cfloop>	



<cfquery name="Warehouse" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Warehouse
	   WHERE     Mission = '#form.mission#'
	   AND       Warehouse IN (SELECT Warehouse FROM itemTransaction)
	   AND       Operational = 1  	   
	</cfquery>

<cfquery name="get" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		
		SELECT     TOP 400 Mission, Warehouse, WarehouseName, ItemPrecision,
		           ItemNo, ItemNoExternal, ItemDescription, Category, CategoryName, UoM, UoMName, MinReorderQuantity,
				   PriceSchedule, PriceScheduleDescription, Promotion, Currency, SalesPrice, PriceDate, LastSold,
				   QuantityForSale, 
				   QuantityReserved,
				   QuantityRequested 
				   
		FROM       (SELECT        DISTINCT 
		                          L.Mission, W.Warehouse, N.WarehouseName, L.ItemNo, I.ItemDescription, I.ItemNoExternal, 
								  L.Category, C.Description as CategoryName,
								  L.UoM, 
								  L.UoMName, 
								  I.ItemPrecision,
								  L.PriceSchedule, L.PriceScheduleDescription, 
								  L.Promotion, L.Currency, L.SalesPrice, L.PriceDate,
		                          MinReorderQuantity,
								  
								 (SELECT     MIN(TransactionDate)
                                   FROM       ItemTransaction
                                   WHERE      Mission = L.Mission AND Warehouse = W.Warehouse AND ItemNo = L.ItemNo AND TransactionUoM = L.UoM AND TransactionType = '2') AS LastSold,								
		
                                  (SELECT     ISNULL(SUM(TransactionQuantity),0) AS stockOnHand
                                   FROM       ItemTransaction
                                   WHERE      Mission = L.Mission AND Warehouse = W.Warehouse AND ItemNo = L.ItemNo AND TransactionUoM = L.UoM AND WorkOrderId IS NULL) AS QuantityForSale,
								   
                                  (SELECT     ISNULL(SUM(TransactionQuantity),0) AS stockOnHand
                                   FROM       ItemTransaction AS ItemTransaction_1
                                   WHERE      Mission = L.Mission AND Warehouse = W.Warehouse AND ItemNo = L.ItemNo AND TransactionUoM = L.UoM AND WorkOrderId IS NOT NULL) AS QuantityReserved,
								   
								   (SELECT   ISNULL(SUM(TransactionQuantity),0)
								    FROM     vwCustomerRequest
								    WHERE    ItemNo          = L.ItemNo
								    AND      TransactionUoM  = L.UoM
								    AND      Warehouse       = W.Warehouse
								    AND      BatchNo IS NULL 
								    AND      RequestClass = 'QteReserve' 
								    AND      ActionStatus = '1') as QuantityRequested 
								   
                    FROM           skMissionItemPrice AS L INNER JOIN
                                   ItemWarehouse AS W ON L.ItemNo = W.ItemNo AND L.UoM = W.UoM INNER JOIN
								   Item I ON L.ItemNo = I.ItemNo INNER JOIN
								   Warehouse N ON W.Warehouse = N.Warehouse INNER JOIN
								   Ref_Category C ON L.Category = C.Category
					
					WHERE          N.Mission = '#Form.Mission#'		
					AND            L.Mission = '#form.Mission#'   
                    <cfif form.warehouse neq "">
					AND            W.Warehouse = '#form.Warehouse#'
					</cfif>
					
					<cfif form.priceschedule neq "">
					AND            L.PriceSchedule = '#form.priceschedule#' 
					<cfelse>
					AND            L.PriceSchedule = '3' 					
					</cfif>			
					
					<cfif form.category neq "">
					AND            I.Category = '#form.Category#'
					</cfif>
					
					<cfif form.filterSubCat neq "">
						AND        I.ItemNo IN (SELECT ItemNo FROM Item WHERE CategoryItem IN (#preservesinglequotes(subcat)#))
					</cfif>
					
					<cfif Form.filterMake neq "">
					AND            I.Make IN (#preservesinglequotes(make)#) 		
					</cfif>
					
					<cfif Form.itemNo neq "">
										
					AND            (I.ItemNo LIKE '%#form.ItemNo#' OR I.ItemNoExternal LIKE '%#form.ItemNo#%')
					</cfif>
					
					<!--- apply the fuzzy search for the name and apply support for spanish sign --->						
					<cfif Form.itemName neq "">
					
					AND  <cf_softlike left="I.ItemDescription" right="#form.ItemName#" language="#client.languageId#">
					
					</cfif>			
					
					AND            W.Warehouse IN (#quotedvalueList(warehouse.warehouse)#)		
					AND            W.Operational   = 1 
												
					AND            I.Operational   = 1 ) AS D
					
		WHERE      1=1
		AND        QuantityForSale IS NOT NULL
		<cfif Form.SettingOnHand eq "1">
		AND        QuantityForSale > 0
		</cfif>
		<cfif Form.SettingPromotion eq "1">
		AND        Promotion > 1
		</cfif>
		<cfif form.warehouse eq ""> 
		ORDER BY    ItemDescription, ItemNo, Warehouse
		<cfelse>
		ORDER BY    ItemDescription, ItemNo, Warehouse				
		</cfif>
		
		
</cfquery>

<table style="width:97%" class="formpadding navigation_table">
		
		<cfoutput>
		
		<tr class="labelmedium2 fixrow">	
		    
			<td style="padding-left:4px;min-width:170px"><cf_tl id="Store"></td>
			
			<td style="min-width:60px;max-width:100px;white-space: nowrap; overflow: hidden;text-overflow: ellipsis;" align="right"><cf_tl id="Sale UoM"></td>
			<td style="min-width:80px" align="right"><cf_tl id="Price"></td>
			<td style="min-width:80px" align="right"><cf_tl id="Promotion"></td>
			
			<td style="min-width:60px" align="right"><cf_tl id="UoM"></td>	
			<td style="min-width:60px" align="right"><cf_tl id="Sold"></td>
			<td style="min-width:100px;padding-right:4px;" align="right"><cf_tl id="Available"></td>		
			<td style="min-width:70px;padding-right:4px" align="right"><cf_tl id="Reserved"></td>
			<td style="min-width:70px;padding-right:4px" align="right"><cf_tl id="Requested"></td>	
			<td style="min-width:70px;padding-right:4px" align="right"><cf_tl id="Exhibition"></td>
			<!---
			<td style="min-width:70px;padding-right:4px" align="right"><cf_tl id="Disposed"></td>		
			--->			
		</tr>
		
		</cfoutput>
		
		<cfif form.warehouse eq "">
		
		   <cfset gr = "ItemNo">
		
		<cfelse>
		
		   <cfset gr = "Warehouse">
		
		</cfif>
		
		<cf_tl id="Add" var="1">
					
			<cfoutput query="get" group="#gr#">	
			
				<cfif form.warehouse eq "">		
							
					<tr class="fixrow2"><td colspan="10" style="padding-top:10px;padding-bottom:4px">

					<table style="width:100%">
							
					<tr style="height:26px;width:80%" class="labelmedium2 fixrow2">
						<td style="border-radius:6px;padding-left:13px;padding-bottom:3px;background-color:gray">
						<table style="width:100%">
						<tr>
						<td style="color:white;background-color:gray;font-weight:xbold;font-size:15px"><cfif itemNoExternal neq ""><b>#ItemNoExternal#</b><cfelse>#ItemNo#</cfif> : #ItemDescription#</td>
						<td align="right" style="color:white;background-color:gray;width:20%;padding-right:4px;font-size:15px">#CategoryName#</td>
						</tr>
						</table>
						</td>						
					</tr>
					
					<cf_tl id="Add" var="1">
										
					<tr><td colspan="9" align="center" style="padding-top:4px;padding-left:10px">
					   <input type="button" value="#lt_text#" class="button10g" style="width:170px;border:1px solid silver" 
						onClick="additem('#warehouse#','#itemno#','#uom#','#currency#','#priceschedule#')">
					</td></tr>
					
					</table>
					
					</td></tr>
				
				</cfif>
							
				<cfoutput>
				
				<cf_precision precision="#ItemPrecision#">
											
				<tr class="labelmedium2 line navigation_row">	
				   
	   			    <cfif form.warehouse eq "">						
					<td style="font-size:15px;background-color:##f1f1f150;padding-left:18px">#WarehouseName#</td>						
					<cfelse>
					<td style="background-color:##f1f1f150;padding-left:3px">
					<table>
					<tr>
					<td style="padding-right:4px">
					<input type="button" value="#lt_text#" class="button10g" style="border-radius:10px;width:60px;border:1px solid silver" 
						onClick="additem('#warehouse#','#itemno#','#uom#','#priceschedule#','#currency#')">
					</td>
					<td>
					<cfif itemNoExternal neq "">#ItemNoExternal#<cfelse>#ItemNo#</cfif>: #ItemDescription#
					</td>
					</tr>
					</table>
					</td>	
					</cfif>
					<td style="background-color:##B0D8FF50;padding-right:3px" align="right">#MinReorderQuantity#</td>
					<td style="background-color:##B0D8FF50;padding-right:3px" align="right">#numberformat(SalesPrice,',.__')#</td>
					
					<td style="background-color:##B0D8FF50;padding-right:3px;font-weight:bold" align="right">
					<cfif promotion eq "0">--<cfelse>#numberformat(SalesPrice,',.__')#</cfif></td>		
					<td style="padding-right:3px" align="right">#UoM#</td>		
					<td style="background-color:##ffffaf50;font-size:12px;padding-left:7px;padding-right:7px" align="right">
					#dateformat(LastSold,client.dateformatshow)#</td>
					<cfif QuantityForSale eq "0">
						<td style="font-size:13px;background-color:##f1f1f150;padding-right:3px" align="right">--</td>
						<cfelse>				
						<td style="font-size:16px;background-color:##80FF8050;padding-right:3px" align="right">
						#numberformat(QuantityForSale,'#pformat#')#
						</td>
						</cfif>	
																						
					<cfif quantityreserved eq "0">
						<td style="font-size:14px;background-color:##e1e1e1;padding-right:3px;" align="right">--</td>
					<cfelse>					
						<td style="font-size:15px;background-color:008080;padding-right:3px;" align="right">
						<a style="color:white" href="javascript:stockreserve('#warehouse#','#itemno#','#uom#','reserve')">
						#numberformat(quantityreserved,'#pformat#')#</a>
						</td>
					</cfif>
					
					<td style="backgtround-color:##ffffaf50;padding-right:3px" align="right">
					
					   <cfif QuantityRequested eq "0">--<cfelse>
					   <a href="javascript:stockreserve('#warehouse#','#itemno#','#uom#','request')">
					   #numberformat(QuantityRequested,'#pformat#')#
					   </a>
					   </cfif> 
					</td>
					<td style="background-color:##ffffaf50;padding-right:3px" align="right">				
					<!--- <cfif stockdisposed eq "0">--<cfelse>#numberformat(StockDisposed,',.__')#</cfif> --->				
					</td>								
				</tr>
				
				</cfoutput>
			
			</cfoutput>
	
	</table>

	<cfset ajaxonload("doHighlight")>
