<cftransaction>
	
	<cfquery name="getAccount" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
		    FROM 	PersonAccount
			WHERE 	PersonNo = '#vPersonNo#'
			AND 	AccountId = '#vAccountId#'
	</cfquery>

	<cfquery name="getMissions" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ParameterMission
	</cfquery>

	<cfquery name="clearAccountMission" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM 	PersonAccountMission
	      	WHERE 	PersonNo  = '#vPersonNo#'
	      	AND 	AccountId = '#vAccountId#'
	</cfquery>

	<cfoutput query="getMissions">
	 		
			<cfif isDefined("Form.Bank_#Mission#")>
				<cfset vBankId = evaluate("Form.Bank_#Mission#")>
				
				<cfif vBankId neq "">
				
					<cfquery name="insertAccountMission" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO [dbo].[PersonAccountMission]
							           (PersonNo,
							            AccountId,
							            Mission,
							            BankId,
							            OfficerUserid,
							            OfficerLastName,
							            OfficerFirstName)
							     VALUES ('#vPersonNo#',
							             '#vAccountId#',
							             '#Mission#',
							             '#vBankId#',
							             '#session.acc#',
							             '#session.last#',
							             '#session.first#')
					</cfquery>
				
				</cfif>
				
			</cfif>
			
	</cfoutput>

</cftransaction>