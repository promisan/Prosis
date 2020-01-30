<cftransaction>
	
	<cfquery name="removePrevious" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  
			FROM 	Ref_StatementAccountUnit 
			WHERE   Mission = '#url.mission#'
			AND		GlAccount = '#url.GlAccount#'
			AND		OrgUnit = '#url.OrgUnit#'
	</cfquery>

	<cfif trim(url.statementCode) neq "">
		
		<cfquery name="insertNew" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_StatementAccountUnit
					(
						Mission,
						StatementCode,
						GLAccount,
						OrgUnit,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#URL.Mission#',
						'#URL.StatementCode#',
						'#URL.GLAccount#',
						'#URL.OrgUnit#',
						'#SESSION.ACC#',
						'#SESSION.LAST#',
						'#SESSION.FIRST#'
					)
		</cfquery>

	</cfif>

</cftransaction>

<cf_tl id="Saved">