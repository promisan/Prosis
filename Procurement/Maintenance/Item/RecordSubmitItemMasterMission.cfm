<cfquery name="ClearItemMasterMission" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE 	ItemMasterMission
		WHERE	ItemMaster = '#url.immCode#'
</cfquery>

<cfquery name="Mis" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	M.*
	FROM 	Ref_ParameterMission M
	WHERE 	M.Mission IN (SELECT Mission 
                          FROM   Organization.dbo.Ref_MissionModule 
			              WHERE  SystemModule = 'Procurement')
	AND     M.MissionPrefix is not NULL						  
</cfquery>

<cfloop query="Mis">

    <cfparam name="Form.Mission_#MissionPrefix#" default="">

	<cfset selected = evaluate("Form.Mission_#MissionPrefix#")>
	
	<cfif selected neq "">
		
		<cfquery name="InsertItemMasterMission" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				INSERT INTO	ItemMasterMission (
						ItemMaster,
						Mission,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )
						
				VALUES ('#url.immCode#',
						'#Mission#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )					
						
		 </cfquery>
		
	</cfif>

</cfloop>