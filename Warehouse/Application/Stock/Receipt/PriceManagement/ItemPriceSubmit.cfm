
<cfset selDate = replace("#url.dateEffective#","'","","ALL")>
<cfset dateValue = "">
<cf_dateConvert Value="#SelDate#">
<cfset vDateEffective = dateValue>

<cfset vSalesPrice = trim(url.salesPrice)>

<!---
<cfif trim(url.salesPrice) eq "" or not isNumeric(url.salesPrice)>
	<cfset vSalesPrice = '0.00'>
</cfif>
--->

<cfoutput>
	
	<script>
		document.getElementById('salesPrice_#url.id#_#url.schedule#_#url.currency#').value = '#vSalesPrice#';
	</script>
	
	
</cfoutput>

<cfquery name="getLine"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM 	Receipt#URL.Warehouse#_#SESSION.acc#
		WHERE	TransactionId = '#url.id#'		
</cfquery>

<cfquery name="validatePrice"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*  
		FROM 	ItemUoMPrice
		WHERE 	Mission       = '#url.mission#'
		AND		(Warehouse    = '#url.destinationWarehouse#' OR Warehouse IS NULL)
		AND		ItemNo        = '#getLine.ItemNo#'
		AND		UoM           = '#getLine.UoM#'
		AND		PriceSchedule = '#url.schedule#'
		AND		Currency      = '#url.currency#'
		AND		DateEffective = #vDateEffective# 
</cfquery>

<!--- we only do something if a price is entered, if blank, we do nothing --->

<cfif vSalesPrice neq "" and vSalesPrice gte 0>

		<cfif validatePrice.recordCount eq 0>
		
			<cfquery name="insert"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					INSERT INTO ItemUoMPrice (
							ItemNo,
							UoM,
							PriceSchedule,
							Mission,
							Warehouse,
							Currency,
							DateEffective,
							SalesPrice,
							TaxCode,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						) VALUES (
							'#getLine.ItemNo#',
							'#getLine.UoM#',
							'#url.schedule#',
							'#url.mission#',
							<cfif url.inherit eq 1>null<cfelseif url.inherit eq 0>'#url.destinationWarehouse#'</cfif>,
							'#url.currency#',
							#vDateEffective#,
							#vSalesPrice#,
							'#url.taxCode#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
				
			</cfquery>
		
		<cfelse>
		
			<cfquery name="update"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE 	ItemUoMPrice
					SET		SalesPrice    = #vSalesPrice#,
							TaxCode       = '#url.taxCode#'
					WHERE 	Mission       = '#url.mission#'
					<cfif url.inherit eq 1>
					AND     Warehouse is NULL  
					<cfelseif url.inherit eq 0>
					AND Warehouse = '#url.destinationWarehouse#' 
					</cfif>					
					AND		ItemNo        = '#getLine.ItemNo#'
					AND		UoM           = '#getLine.UoM#'
					AND		PriceSchedule = '#url.schedule#'
					AND		Currency      = '#url.currency#'
					AND		DateEffective = #vDateEffective# 
			</cfquery>
		
		</cfif>
		
		<table>
		<td align="center" style="color:2D9BEC; font-size:10px;"><cf_tl id="Saved"></td>
	</table>
		
<cfelseif vSalesPrice eq "">	
	
		<cfquery name="delete"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE 	ItemUoMPrice					
					WHERE 	Mission       = '#url.mission#'
					<cfif url.inherit eq 1>
					AND     Warehouse is NULL  
					<cfelseif url.inherit eq 0>
					AND Warehouse = '#url.destinationWarehouse#' 
					</cfif>		
					AND		ItemNo        = '#getLine.ItemNo#'
					AND		UoM           = '#getLine.UoM#'
					AND		PriceSchedule = '#url.schedule#'
					AND		Currency      = '#url.currency#'
					AND		DateEffective = #vDateEffective# 
					
			</cfquery>
				
	<table>
		<td align="center" style="color:2D9BEC; font-size:10px;"><cf_tl id="Saved"></td>
	</table>

</cfif>