<cfquery name="Account" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	PersonAccount
		WHERE 	PersonNo = '#URL.PersonNo#'
		<cfif url.accountid neq "">
			AND 	AccountId = '#URL.AccountId#'
		<cfelse>
			AND 	1=0
		</cfif>
</cfquery>

<cfquery name="getMissions" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ParameterMission
</cfquery>

<table class="formpadding">
	<cfoutput query="getMissions">
		<tr>
			<td class="labellarge">
				#Mission# :
			</td>
			<td style="padding-left:10px;">
				<select name="bank_#mission#" id="bank_#mission#" class="regularxl" required="yes">
					<option value=""> -- <cf_tl id="Select a Bank"> --
					<cfquery name="getBanks" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT 	B.*,
						    		(
						    			SELECT 	PAMx.BankId
						    			FROM	Payroll.dbo.PersonAccountMission PAMx
						    			WHERE 	PAMx.PersonNo = '#url.PersonNo#'
						    			<cfif url.accountid neq "">
							    			AND 	PAMx.AccountId = '#url.AccountId#'
							    		<cfelse>
							    			AND 	1=0
						    			</cfif>
						    			AND 	PAMx.Mission = '#mission#'
						    			AND 	PAMx.BankId = B.BankId
						    		) as Selected
						    FROM 	Ref_BankAccount B
						    ORDER BY BankName ASC
					</cfquery>
					<cfloop query="getBanks">
						<option value="#BankId#" <cfif bankId eq selected>selected</cfif>> #BankName# - #AccountNo# (#Currency#)
					</cfloop>
				</select>
			</td>
		</tr>
	</cfoutput>
</table>


