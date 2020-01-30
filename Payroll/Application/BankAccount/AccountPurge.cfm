 
<cftransaction>
	 
	<cfquery name="validateDelete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   AccountId
	    FROM     EmployeeSettlementDistribution
		WHERE    PersonNo = '#URL.ID#' 
		AND      AccountId = '#URL.ID1#'
		UNION ALL
		SELECT   AccountId
	    FROM     PersonDistribution
		WHERE    PersonNo = '#URL.ID#' 
		AND      AccountId = '#URL.ID1#'
	</cfquery>

	<cfif validateDelete.recordCount eq 0>
		<cfquery name="deleteAccount" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   DELETE
			   FROM PersonAccount 
			   WHERE PersonNo = '#URL.ID#' AND AccountId  = '#URL.ID1#' 
		</cfquery>
	</cfif>

</cftransaction>

<cf_SystemScript>
<cfoutput>	
<script>
	 ptoken.location("EmployeeBankAccount.cfm?ID=#url.id#");
</script>	
</cfoutput>