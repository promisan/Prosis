
<cf_screentop html="No">


<cfparam name="URL.Mission" default="">

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Item
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   ItemUoM
		WHERE  ItemNo = '#URL.ID#'				
</cfquery>	

<!--- global --->

<cfloop query="ItemUoM">
	
		<cfquery name="Schedule"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT  *
			   FROM    Ref_PriceSchedule
			   WHERE   Code IN (SELECT PriceSchedule
			                 FROM   WarehouseCategoryPriceSchedule
					         WHERE  Warehouse IN (SELECT Warehouse FROM Warehouse WHERE Mission = '#url.mission#')
					         AND    Category   = '#Item.Category#'
							 AND    Operational = 1)		
		</cfquery>

		<cfloop query="schedule">		
		
			<cfquery name="Currency" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Accounting.dbo.Currency
					WHERE  EnableProcurement = 1
					AND	   Currency IN (SELECT Currency
						                 FROM   WarehouseCategoryPriceSchedule
								         WHERE  Warehouse IN (SELECT Warehouse FROM Warehouse WHERE Mission = '#url.mission#')
								         AND    Category      = '#Item.Category#'
										 AND    Operational   = 1
										 AND    PriceSchedule = '#code#')
				</cfquery>
						
			<cfloop query="Currency">
			
				<cfparam name="Form._#itemuom.uom#_#schedule.code#_#currency#_dateeffective" default="">
				<cfparam name="Form._#itemuom.uom#_#schedule.code#_#currency#_promotion"     default="0">
				<cfparam name="Form._#itemuom.uom#_#schedule.code#_#currency#_salesprice"    default="">
				<cfparam name="Form._#itemuom.uom#_#schedule.code#_#currency#_taxcode"       default="">
			
				<cfset dte = evaluate("Form._#itemuom.uom#_#schedule.code#_#currency#_dateeffective")>
				<cfset pro = evaluate("Form._#itemuom.uom#_#schedule.code#_#currency#_promotion")>
				<cfset prc = evaluate("Form._#itemuom.uom#_#schedule.code#_#currency#_salesprice")>
				<cfset tax = evaluate("Form._#itemuom.uom#_#schedule.code#_#currency#_taxcode")>						
				
			   	<cfset dateValue = "">
				<CF_DateConvert Value="#dte#">
				<cfset eff = dateValue>
										
				<!--- check if exists --->
								
					<cfquery name="check"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     *
						FROM       ItemUoMPrice
						WHERE      ItemNo        = '#url.id#'
						AND        Mission       = '#URL.Mission#' 
						AND        UoM           = '#itemuom.uom#'
						AND        PriceSchedule = '#schedule.code#' 						
						AND        Warehouse     is NULL
						AND        Currency      = '#currency#'		
						AND        DateEffective = #eff#							
					</cfquery>
					
					<cfif check.recordcount eq "1">
					
						<cfquery name="update"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE     ItemUoMPrice
							SET        SalesPrice    = '#prc#', 
							           TaxCode       = '#tax#',
									   Promotion     = '#pro#'						
							WHERE      ItemNo        = '#url.id#'
							AND        Mission       = '#URL.Mission#' 
							AND        UoM           = '#itemuom.uom#'
							AND        PriceSchedule = '#schedule.code#' 						
							AND        Warehouse     IS NULL 
							AND        Currency      = '#currency#'		
							AND        DateEffective = #eff#							
						</cfquery>
					
					<cfelse>
					
						<cfquery name="insert"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ItemUoMPrice
							(ItemNo, 
							 UoM, 
							 PriceSchedule, 
							 Mission, 							
							 Currency, 
							 DateEffective, 
							 Promotion,
							 SalesPrice, 
							 TaxCode, 
							 OfficerUserId, 
							 OfficerLastName, 
		                     OfficerFirstName)
							VALUES
							(
							'#url.id#', 
							'#itemuom.uom#', 
							'#schedule.code#', 
							'#url.mission#', 							
							'#currency#', 
							#eff#, 
							'#pro#',
							'#prc#', 
							'#tax#', 
							'#SESSION.acc#', 
							'#SESSION.last#', 
		                    '#SESSION.first#') 
								
						</cfquery>
					
					</cfif>

			</cfloop>
		</cfloop>
	</cfloop>


<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT Warehouse
		FROM   ItemWarehouse I
		WHERE  ItemNo  = '#URL.ID#'			
		AND    I.Warehouse IN (SELECT Warehouse 
		                       FROM   Warehouse 
					  		   WHERE  Mission = '#url.mission#'
							   AND    Warehouse = I.Warehouse 
							   AND    Operational = 1)
							   
	    AND	   I.Warehouse IN (SELECT Warehouse
			                   FROM   WarehouseCategoryPriceSchedule
					           WHERE  Category   = '#Item.Category#'
							   AND    Operational = 1)
</cfquery>	

<cfloop query="Warehouse">

	<cfloop query="ItemUoM">
	
		<cfquery name="Schedule"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT  *
			   FROM    Ref_PriceSchedule
			   WHERE   Code IN (SELECT PriceSchedule
			                 FROM   WarehouseCategoryPriceSchedule
					         WHERE  Warehouse = '#Warehouse.Warehouse#'
					         AND    Category   = '#Item.Category#'
							 AND    Operational = 1)		
		</cfquery>

		<cfloop query="schedule">		
		
			<cfquery name="Currency" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Accounting.dbo.Currency
					WHERE  EnableProcurement = 1
					AND	   Currency IN (SELECT Currency
						                 FROM   WarehouseCategoryPriceSchedule
								         WHERE  Warehouse  = '#Warehouse.Warehouse#'
								         AND    Category   = '#Item.Category#'
										 AND    Operational = 1
										 AND    PriceSchedule = '#code#')
				</cfquery>
						
			<cfloop query="Currency">
			
				<cfparam name="Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_dateeffective" default="">
				<cfparam name="Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_promotion" default="">
				<cfparam name="Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_salesprice" default="">
				<cfparam name="Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_taxcode" default="">
			
				<cfset dte = evaluate("Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_dateeffective")>
				<cfset pro = evaluate("Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_promotion")>
				<cfset prc = evaluate("Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_salesprice")>
				<cfset tax = evaluate("Form.#warehouse.warehouse#_#itemuom.uom#_#schedule.code#_#currency#_taxcode")>	
				
				<cfif prc neq "">				
				
			   	  <cfset dateValue = "">
				  <CF_DateConvert Value="#dte#">
				  <cfset eff = dateValue>
										
				   <!--- check if exists --->
								
					<cfquery name="check"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     *
						FROM       ItemUoMPrice
						WHERE      ItemNo        = '#url.id#'
						AND        Mission       = '#URL.Mission#' 
						AND        UoM           = '#itemuom.uom#'
						AND        PriceSchedule = '#schedule.code#' 						
						AND        Warehouse     = '#warehouse.warehouse#'
						AND        Currency      = '#currency#'		
						AND        DateEffective = #eff#							
					</cfquery>
					
					<cfif check.recordcount eq "1">
					
						<cfquery name="update"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE     ItemUoMPrice
							SET        SalesPrice = '#prc#', 
							           TaxCode    = '#tax#',
									   Promotion  = '#pro#'						
							WHERE      ItemNo        = '#url.id#'
							AND        Mission       = '#URL.Mission#' 
							AND        UoM           = '#itemuom.uom#'
							AND        PriceSchedule = '#schedule.code#' 						
							AND        Warehouse     = '#warehouse.warehouse#'
							AND        Currency      = '#currency#'		
							AND        DateEffective = #eff#							
						</cfquery>
					
					<cfelse>
					
						<cfquery name="insert"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ItemUoMPrice
							(ItemNo, 
							 UoM, 
							 PriceSchedule, 
							 Mission, 
							 Warehouse, 
							 Currency, 
							 DateEffective, 
							 Promotion,
							 SalesPrice, 
							 TaxCode, 
							 OfficerUserId, 
							 OfficerLastName, 
		                     OfficerFirstName)
							VALUES
							(
							'#url.id#', 
							'#itemuom.uom#', 
							'#schedule.code#', 
							'#url.mission#', 
							'#warehouse.warehouse#', 
							'#currency#', 
							#eff#, 
							'#pro#',
							'#prc#', 
							'#tax#', 
							'#SESSION.acc#', 
							'#SESSION.last#', 
		                    '#SESSION.first#') 
								
						</cfquery>
					
					</cfif>
					
				 </cfif>	

			</cfloop>
		</cfloop>
	</cfloop>
</cfloop>

<cfoutput>

<script>
    window.location = "#SESSION.root#/Warehouse/Maintenance/ItemMaster/Pricing/PricingData.cfm?drillid=#url.drillid#&mission=#url.mission#&id=#url.id#"
	try {	
	opener.applyfilter('1','','#url.drillid#')		
	} catch(e) {}
</script>

</cfoutput>
