
<cfquery name="Items" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Item
		WHERE 	Operational = 1
		AND		ItemNo IN (SELECT DISTINCT ItemNo FROM ItemUoMMission WHERE Mission = '#url.mission#' AND Operational = 1)
		AND		Category = (SELECT Category FROM Item WHERE ItemNo = '#url.itemNo#')
		AND		ItemClass = (SELECT ItemClass FROM Item WHERE ItemNo = '#url.itemNo#')
		AND		ItemNo != '#url.itemNo#'
</cfquery>

<cfif isDefined("Form.sync")>

	<cfquery name="delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM 	ItemPriceSchedule
			WHERE	ItemNo IN
					(
						SELECT 	ItemNo
						FROM 	Item
						WHERE 	Operational = 1
						AND		ItemNo IN (SELECT DISTINCT ItemNo FROM ItemUoMMission WHERE Mission = '#url.mission#' AND Operational = 1)
						AND		Category = (SELECT Category FROM Item WHERE ItemNo = '#url.itemNo#')
						AND		ItemClass = (SELECT ItemClass FROM Item WHERE ItemNo = '#url.itemNo#')
						AND		ItemNo != '#url.itemNo#'
					)
	</cfquery>

</cfif>


<cfloop query="Schedule">

	<cfloop query="Currency">
	
		<cfif isDefined("Form.cb_#Schedule.code#_#Currency.Currency#")>
		
			<cfloop query="Items">
		
				<cftry>
				
					<cfquery name="insert" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ItemPriceSchedule 
								(
									ItemNo,
									Mission,
									PriceSchedule,
									Currency,
									Operational,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName
								)
							VALUES
								(
									'#Items.ItemNo#',
									'#url.mission#',
									'#Schedule.code#',
									'#Currency.currency#',
									1,
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#'
								)
					</cfquery>
					
					<cfcatch></cfcatch>
				</cftry>
			
			</cfloop>
			
		</cfif>
	
	</cfloop>

</cfloop>