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