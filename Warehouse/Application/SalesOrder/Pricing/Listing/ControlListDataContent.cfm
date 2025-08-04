<!--
    Copyright © 2025 Promisan

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

<!--- control list data content --->
 
<cfif url.SelectionDate neq "">
     <cfset dateValue = "">
	 <CF_DateConvert Value="#url.SelectionDate#">
	 <cfset dte = dateValue>	
</cfif>	

<cfif url.ReceiptDate neq "">
     <cfset dateValue = "">
	 <CF_DateConvert Value="#url.ReceiptDate#">
	 <cfset rcp = dateValue>	
</cfif>	

<cfquery name="getWarehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Warehouse
		WHERE 	Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="Schedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_PriceSchedule
		WHERE    Code IN (SELECT  DISTINCT PriceSchedule 
		                  FROM    WarehouseCategoryPriceSchedule
					 	  WHERE   Warehouse = '#url.warehouse#'
						  <cfif url.Category neq "">
						  AND     Category  = '#url.category#'
						  </cfif>
						  )		
		<cfif url.priceSchedule neq "">
		AND      Code = '#url.priceSchedule#'
		</cfif>
						  
		ORDER BY Code		 				
</cfquery>

<cfsavecontent variable="myquery">
	
	<cfoutput>	
		
	    SELECT * 
		
		<cfloop query="schedule">
		
		, (CASE WHEN PriceSchedule#currentrow# IS NULL THEN PriceScheduleAny#currentrow# ELSE PriceSchedule#currentrow# END) as Price#currentrow#
		
		</cfloop>
		
		FROM (
	
			SELECT   C.CategoryItemOrder, 
					 C.CategoryItemName,
					 I.ItemNo, 
			         I.ItemDescription, 			   			 
					 U.ItemUoMId,
					 U.UoMDescription,
					 U.ItemBarCode,
					 '#url.currency#' as Currency,

					   <cfloop query="schedule">
					   
				          ISNULL(
							    (SELECT   TOP 1 SalesPrice
					            FROM      ItemUoMPrice
					            WHERE     ItemNo        = IW.ItemNo 
								AND       UoM           = IW.UoM 
								AND       Currency      = '#url.currency#' 
								AND       PriceSchedule = '#code#' 
								AND       Warehouse     = '#url.warehouse#'
								AND       DateEffective <= #dte#	
								ORDER BY  DateEffective DESC		
				            ),
													
								(SELECT   TOP 1 SalesPrice
					            FROM      ItemUoMPrice
					            WHERE     ItemNo        = IW.ItemNo 
								AND       UoM           = IW.UoM 
								AND       Currency      = '#url.currency#' 
								AND       PriceSchedule = '#code#' 
								AND       Warehouse     = '#url.warehouse#'
								AND       DateEffective > #dte#	
								ORDER BY  DateEffective ASC		
				            )
							) 
										
						   AS PriceSchedule#currentrow#,
						  						  
						   ISNULL(
							    (SELECT     TOP 1 SalesPrice
					             FROM      ItemUoMPrice
					             WHERE     ItemNo        = IW.ItemNo 
								 AND       UoM           = IW.UoM 
								 AND       Currency      = '#url.currency#' 
								 AND       PriceSchedule = '#code#' 
								 AND       Warehouse     IS NULL
								 AND       DateEffective <= #dte#	
								 ORDER BY  DateEffective DESC		
				            ),
													
								(SELECT     TOP 1 SalesPrice
					             FROM      ItemUoMPrice
					             WHERE     ItemNo        = IW.ItemNo 
								 AND       UoM           = IW.UoM 
								 AND       Currency      = '#url.currency#' 
								 AND       PriceSchedule = '#code#' 
								 AND       Warehouse     IS NULL
								 AND       DateEffective > #dte#	
								 ORDER BY  DateEffective ASC		
				            )
							) 
										
						  AS PriceScheduleAny#currentrow#,
						  
						 
						</cfloop>
						
					  I.ItemNoExternal, 
					  I.ItemColor,
					  (     SELECT     TOP 1 TransactionCostPrice
					        FROM       ItemTransaction
					 	    WHERE      ItemNo    = I.ItemNo
						    AND        TransactionUoM     = U.UoM
						    AND        Mission            = '#getWarehouse.Mission#'
						    AND        TransactionType    = '1'
						    ORDER BY Created DESC
					   ) as LastCost,
					   
					   <!--- a bit specific for Charlie --->

					   (    SELECT  TOP 1 IVO.OfferMinimumQuantity
							FROM 	ItemVendor IV 
									INNER JOIN ItemVendorOffer IVO ON IV.ItemNo = IVO.ItemNo
							WHERE 	IV.ItemNo  = I.ItemNo
							AND		IV.UoM = U.UoM
							AND 	IV.Preferred = '1'
							ORDER BY IVO.DateEffective DESC
					   ) AS Ctn,

					   (  	SELECT 	SUM(Ix.TransactionQuantity)
							FROM 	ItemTransaction Ix WITH (NOLOCK)
							WHERE 	Ix.Mission        = '#URL.Mission#'
							AND     Ix.ItemNo         = I.ItemNo
							AND 	Ix.TransactionUoM = U.UoM							
					   ) as StockMission,	
					   
					   (  	SELECT 	ISNULL(SUM(Iw.TransactionQuantity),-1)
							FROM 	ItemTransaction Iw WITH (NOLOCK)
							WHERE 	Iw.Warehouse      = '#URL.Warehouse#'
							AND     Iw.ItemNo         = I.ItemNo
							AND 	Iw.TransactionUoM = U.UoM							
					   ) as Stock						   
					  
			FROM      ItemWarehouse IW 
			          INNER JOIN Item I ON IW.ItemNo = I.ItemNo 
					  INNER JOIN ItemUoM U ON IW.ItemNo = U.ItemNo AND IW.UoM = U.UoM 
					  INNER JOIN Ref_CategoryItem C ON I.Category = C.Category AND I.CategoryItem = C.CategoryItem
					  
					  <!---
					  LEFT OUTER JOIN ItemUoMMission UM ON U.ItemNo = UM.ItemNo AND U.UoM = UM.UoM AND UM.Mission = '#url.mission#'
					  --->
					  
			WHERE     IW.Warehouse = '#url.warehouse#' 
			
			<cfif url.Category neq "">
			AND       I.Category   = '#url.Category#'
			</cfif>
			
			<cfif url.programcode neq "">
			AND      I.ProgramCode = '#url.programCode#'
			</cfif>
			
			<cfif url.hasPrice eq "0">
			
			AND      NOT EXISTS (SELECT 'X' 
			                     FROM  ItemUoMPrice 
						         WHERE Mission         = '#url.mission#'
							     AND   ItemNo          = I.ItemNo
							     AND   UoM             = U.UoM
							     <cfif url.priceSchedule neq "">
								 AND   PriceSchedule  = '#url.priceSchedule#' 
							     </cfif>)
								 
			<cfelseif url.priceSchedule neq "">
			
			AND      EXISTS (SELECT 'X' 
			                 FROM  ItemUoMPrice 
						     WHERE Mission        = '#url.mission#'
							 AND   ItemNo         = I.ItemNo
							 AND   UoM            = U.UoM
							 AND   PriceSchedule  = '#url.priceSchedule#')
			
			</cfif>					 
						
			<cfif url.taxcode neq "">
			
			AND      EXISTS (SELECT 'X' 
			                 FROM ItemUoMPrice 
						     WHERE Mission         = '#url.mission#'
							 AND   ItemNo          = I.ItemNo
							 AND   UoM             = U.UoM
							 AND   TaxCode         = '#url.taxcode#')
			
			</cfif>
			
			
			
			<cfif url.receiptDate neq "">
			
			AND      EXISTS (SELECT 'X' 
			                 FROM  ItemTransaction 
						     WHERE Mission = '#url.mission#'
							 AND   ItemNo           = I.ItemNo
							 AND   TransactionUoM   = U.UoM
							 AND   TransactionType  = '1'
							 AND   TransactionDate >= #rcp#)
			
			</cfif>
												
			) as C		
			
			WHERE 1=1				
			
			<cfif url.instock eq "1">			
			AND     Stock > 0
			<cfelseif url.instock eq "0">
			AND     Stock = 0	
			<cfelseif url.instock eq "9">
			AND     Stock = -1								
			</cfif>
			
			--condition
				
	</cfoutput>	
	
</cfsavecontent>


<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="Sub-Category" var = "1">
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "CategoryItemName",		
																																							
						search      	= "text",
						filtermode  	= "3"}>		
						
	<!--- fieldsort   	= "CategoryItemOrder",	--->					
	
	<cfset itm = itm+1>
	<cf_tl id="ItemNo" var = "1">
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field      		= "ItemNo",																		
						functionscript  = "itemopen"}>		

	<cfset itm = itm+1>
		
	<cf_tl id="Name" var = "1">		
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "ItemDescription",																																								
						search      	= "text"}>				
							
	<cfset itm = itm+1>
	<cf_tl id="UoM" var = "1">			
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "UoMDescription",																												
						search      	= "text",
						filtermode  	= "2"}>	

    <cfif url.priceSchedule neq "">		
						
		<cfset itm = itm+1>
		<cf_tl id="Barcode" var = "1">			
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "ItemBarcode",																												
							search      = "text",
							filtermode  = "2"}>	
	</cfif>					
						
	<cfset itm = itm+1>
	<cf_tl id="External" var = "1">			
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "ItemNoExternal",																													
						search      	= "text"}>		

	<cfset itm = itm+1>
	<cf_tl id="CTN" var = "1">			
	<cfset fields[itm] = {label         = "#lt_text#",                    
		     				field       = "CTN",	
							width       = "15",
							align       = "right",				
							alias       = "",					
							formatted   = "numberformat(CTN,',')"}>	

	<cfset itm = itm+1>
	<cf_tl id="Stock" var = "1">			
	<cfset fields[itm] = {label         = "#lt_text#",                    
		     				field       = "Stock",	
							width       = "15",
							align       = "right",				
							alias       = "",
							search      = "amount",					
							formatted   = "numberformat(Stock,',')"}>	

	<cfset itm = itm+1>
	<cf_tl id="Last Cost" var = "1">			
	<cfset fields[itm] = {label         = "#lt_text#",                    
		     				field       = "LastCost",	
							width       = "15",
							align       = "right",				
							alias       = "",					
							formatted   = "numberformat(LastCost,',.__')"}>																
	
	<cfset itm = itm+1>
	<cf_tl id="Curr" var = "1">			
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "Currency",	
						align           = "right",					
						alias       	= ""}>
						
	<cfif url.priceSchedule neq "">
	
		<cfset itm = itm+1>
		<cf_tl id="Tax" var = "1">			
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "TaxCode",										
							alias       = ""}>
	
	</cfif>					
													
	<cfloop query="schedule">
	
		<cfset itm = itm+1>
		<cf_tl id="Quantity" var = "1">							
		<cfset fields[itm] = {label     = "#Acronym#",                    
		     				field       = "Price#currentrow#",	
							width       = "15",
							align       = "right",				
							alias       = "",					
							formatted   = "numberformat(Price#currentrow#,',.__')"}>		
		
	</cfloop>	
	
	<cfset itm = itm+1>	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "ItemUoMId",					
						display     	= "No",
						alias       	= ""}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->
	
<cf_listing
	    header              = "PriceListing"
	    box                 = "saleprice"
		link                = "#SESSION.root#/Warehouse/Application/SalesOrder/Pricing/Listing/ControlListDataContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&currency=#url.currency#&category=#url.category#&programcode=#url.programcode#&selectiondate=#url.selectiondate#&taxcode=#url.TaxCode#&InStock=#url.InStock#&PriceSchedule=#url.PriceSchedule#&receiptDate=#url.ReceiptDate#&hasPrice=#url.hasPrice#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"	
		listgroupfield      = "CategoryItemName"
		listgroup           = "CategoryItemName"
		listgroupdir        = "ASC"	
		listorderfield      = "ItemDescription"
		listorder           = "ItemDescription"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "20"		<!--- better to let is be set in the preferences --->
		menu                = "#menu#"
		filtershow          = "Hide"
		excelshow           = "Yes" 			
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;880;false;false"	
		drilltemplate       = "Warehouse/Maintenance/ItemMaster/Pricing/PricingData.cfm?mission=#url.mission#&drillid="
		drillkey            = "ItemUoMId"
		drillbox            = "addlisting">	
		