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
<cfset dateValue = ""> 
<cf_DateConvert Value="#Form.DateEffective#"> 
<cfset DEFF = dateValue>

<cfloop list="#Form.TopicValueCode#" index="element1">

	<cfloop list="#Form.MissionList#" index="element2">
	
		<cfquery name="qCheck" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM  ItemMasterStandardCost
			WHERE ItemMaster		= '#Form.Code#' 
			AND	  TopicValueCode	= '#element1#'		
			AND   Mission			= '#element2#'		
			AND   Location		    = '#Form.Location#'	
			AND   DateEffective	    = #DEFF# 	
			AND   CostElement		= '#Form.CostElement#'		
		</cfquery>
	
		<cfif qCheck.recordcount eq 0>
		
				<cfquery name="qInsert" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ItemMasterStandardCost
				           (ItemMaster
				           ,TopicValueCode
				           ,Mission
				           ,Location
				           ,DateEffective
				           ,CostElement
						   ,CostOrder
				           ,CostBudgetMode
				           ,CostAmount
				           ,OfficerUserId
				           ,OfficerLastName
				           ,OfficerFirstName)
				     VALUES
				           ('#Form.Code#'
				           ,'#element1#'
				           ,'#element2#'
				           ,'#Form.Location#'
				           , #DEFF#
				           ,'#Form.CostElement#'
						   ,'#Form.CostOrder#'
				           ,'#Form.CostBudgetMode#'
				           ,'#Form.CostAmount#'
				           ,'#Session.acc#'
				           ,'#Session.last#'
				           ,'#Session.first#')
				</cfquery>
				
		<cfelse>
		
			<cfquery name="qUpdate" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE ItemMasterStandardCost
			SET    CostBudgetMode   = '#Form.CostBudgetMode#', 
			       CostAmount       = '#Form.CostAmount#'
			WHERE  ItemMaster		= '#Form.Code#' 
			AND	   TopicValueCode	= '#element1#'		
			AND    Mission			= '#element2#'		
			AND    Location		    = '#Form.Location#'	
			AND    DateEffective	= #DEFF# 	
			AND    CostElement		= '#Form.CostElement#'		
		</cfquery>				
				
		</cfif>				
		
	</cfloop>	
	
</cfloop>

<cfoutput>

<script>
	ptoken.navigate('Budgeting/CostElementList.cfm?id1=#Form.Code#','dExisting');
	ProsisUO.closeWindow('wCostElement');	
</script>

</cfoutput>