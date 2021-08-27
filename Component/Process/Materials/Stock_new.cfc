

<!--- recalculate average price --->


<cffunction name="redoIssuanceTransaction"
        access="public"
        returntype="any"
        displayname="Source an issuance transaction and revaluate and post the amounts">
			
		<cfargument name="Datasource"    type="string" 	default="AppsMaterials" required="yes">						
		<cfargument name="Mode"          type="string" 	default="Standard" required="yes">	
		<cfargument name="filterMission" type="string" 	default=""         required="yes">
		<cfargument name="filterItemNo"  type="string" 	default=""         required="yes">	
		<cfargument name="revaluation"   type="string" 	default="0"        required="yes">	
		<cfargument name="initialStatus" type="numeric" default="0"        required="yes">	
		<cfargument name="finalStatus"   type="numeric" default="1"        required="yes">
			
		<!--- general variables --->
		
		<cfset price   = "0.03">
		<cfset stock   = "0">
		
		<cfquery name="transaction" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
								
				SELECT      *
				FROM        ItemTransaction
				WHERE       Mission   = '#filtermission#'
				AND         ItemNo    = '#filterItemNo#'
				AND         Quantity <> 0
				ORDER BY    TransactionDate, DocumentNo  <!--- first the receipts --->				
																
		</cfquery>		
		
		<cfloop query="Transaction">
		
			<!--- we set the initial price --->		
			
		
			<cfif quantity gt "0" and TransactionType eq "3">
			
					<!--- we take the current stock * price + value of the receipt
					 determine the new price for this date after the added quantity is added --->
			
					<cfset val    = (stock * price) + TransactionValue>					
					<cfset stock  = stock + TransactionQuantity>
					<cfset price  = round(val*100000 / stock)/100000>
					
					<cfquery name="check" 
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      *
						FROM        ItemCostPrice
						WHERE       Mission   = '#filtermission#
						AND         ItemNo    = '#filterItemNo#'
						AND         SelectionDate = '#transactiondate#'
					</cfquery>
					
					<cfif check.recordcount eq "1">
					
						<cfquery name="update" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE      ItemCostPrice
							SET         CostPrice = '#price#'
							WHERE       Mission   = '#filtermission#'
							AND         ItemNo    = '#filterItemNo#'
							AND         SelectionDate = '#transactiondate#'
						</cfquery>					
					
					<cfelse>
					
						<cfquery name="addprice" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ItemCostPrice
							(Mission,ItemNo,SelectionDate,CostPrice)
							VALUES
							('#filtermission#','#filterItemNo#','#transactiondate#','#price#')
						</cfquery>	
					
					</cfif>
								
					<!--- Attention : also store price in a table --->
								 
			<cfelse>
						
					<cfset stock = stock + Transactionquantity> 
					<cfset TransactionValue = Transactionquantity * price>
					
					<cfquery name="transaction" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
											
							UPDATE      ItemTransaction
							SET         TransactionValue = '#TransactionValue#'
							            TransactionCostPrice = '#price#'
							WHERE       TransactionId = '#TransactionId#'									
																			
					</cfquery>						
		
			</cfif>				
		
		</cfloop>	
		
		
</cffunction>	