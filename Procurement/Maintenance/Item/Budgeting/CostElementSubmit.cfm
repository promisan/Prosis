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