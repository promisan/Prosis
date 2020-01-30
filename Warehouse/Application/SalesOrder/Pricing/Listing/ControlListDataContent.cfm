
<!--- control list data content --->

 
<cfif url.SelectionDate neq "">
     <cfset dateValue = "">
	 <CF_DateConvert Value="#url.SelectionDate#">
	 <cfset dte = dateValue>	
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
						
					  I.Classification, 
					  I.ItemColor,
					  (
					    SELECT     TOP 1 TransactionCostPrice
					    FROM       ItemTransaction
					 	WHERE      ItemNo    = I.ItemNo
						AND        TransactionUoM     = U.UoM
						AND        Mission            = '#getWarehouse.Mission#'
						AND        TransactionType    = '1'
						ORDER BY Created DESC
					   ) as LastCost	
					  
			FROM      ItemWarehouse IW 
			          INNER JOIN Item I ON IW.ItemNo = I.ItemNo 
					  INNER JOIN ItemUoM U ON IW.ItemNo = U.ItemNo AND IW.UoM = U.UoM 
					  INNER JOIN Ref_CategoryItem C ON I.Category = C.Category AND I.CategoryItem = C.CategoryItem
					  LEFT OUTER JOIN ItemUoMMission UM ON U.ItemNo = UM.ItemNo AND U.UoM = UM.UoM AND UM.Mission = '#getWarehouse.Mission#'
			WHERE     IW.Warehouse = '#url.warehouse#' 
			<cfif url.Category neq "">
			AND       I.Category   = '#url.Category#'
			</cfif>
			<cfif url.programcode neq "">
			AND      I.ProgramCode = '#url.programCode#'
			</cfif>
			
			<!--- has a price defined 
			AND       I.ItemNo IN  (SELECT    ItemNo
			 		                FROM      ItemUoMPrice
				                    WHERE     ItemNo        = IW.ItemNo 
							        AND       UoM           = IW.UoM 
							        AND       Currency      = '#url.currency#'  ) 
									
									--->
									
			) as C		
			
			WHERE 1=1				
								  
			ORDER BY  CategoryItemOrder, ItemDescription, UoM
			
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="Category" var = "1">
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "CategoryItemOrder",		
						formatted   	= "CategoryItemName",																																		
						search      	= "text",
						filtermode  	= "2"}>		
	
	<cfset itm = itm+1>
	<cf_tl id="ItemNo" var = "1">
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field      		= "ItemNo",																		
						functionscript  = "itemopen",																
						search      	= "text",						
						filtermode  	= "2"}>		

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
						
	<cfset itm = itm+1>
	<cf_tl id="Codified" var = "1">			
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "Classification",																													
						search      	= "text"}>		

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
						alias       	= "",																			
						search      	= "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->
	
<cf_listing
	    header              = "PriceListing"
	    box                 = "saleprice"
		link                = "#SESSION.root#/Warehouse/Application/SalesOrder/Pricing/Listing/ControlListDataContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&currency=#url.currency#&category=#url.category#&programcode=#url.programcode#&selectiondate=#url.selectiondate#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"	
		listgroupfield      = "CategoryItemName"
		listgroup           = "CategoryItemOrder"
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
		