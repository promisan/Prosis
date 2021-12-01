<cfquery name="clearLines" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   	ServiceItemUnitMissionRemuneration
		WHERE	CostId = '#vThisCostId#'
</cfquery>

<cfquery name="getGrades" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Postgrade
		FROM   	Employee.dbo.Position
		WHERE	Mission = '#Form.Mission#'
</cfquery>

<cfoutput query="getGrades">
	<cfset vPostGradeId = trim(replace(Postgrade," ","_","ALL"))>
	<cfset vPostGradeId = replace(vPostGradeId,"-","_","ALL")>
	
	<cfif isDefined("Form.postgrade_#vPostGradeId#")>
		<cfset vAmount = evaluate("Form.postgrade_#vPostGradeId#")>
		<cfset vAmount = trim(replace(vAmount,",","","ALL"))>

		<cfquery name="insertRemuneration" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ServiceItemUnitMissionRemuneration
					(
						CostId,
						Postgrade,
						Amount,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#vThisCostId#',
						'#Postgrade#',
						'#vAmount#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
		</cfquery>

	</cfif>
</cfoutput>