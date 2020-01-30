
<cftransaction>

<cfquery name="Clear" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM WorkOrderGledger
		WHERE  WorkOrderId = '#url.workorderid#' 
</cfquery>

<cfquery name="Ledger" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AreaGledger
	ORDER BY ListingOrder
</cfquery>

<cfloop query="Ledger">

	<cfparam name="Form.#area#GLAccount" default="">

	<cfset gl = evaluate("Form.#area#GLAccount")>
	
	<cfif gl neq "">
	
		<cfquery name="Insert" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrderGledger
			(WorkorderId,Area,GLAccount)
			VALUES ('#url.WorkOrderId#','#area#','#gl#')
		</cfquery>		
	
	</cfif>	
		
</cfloop>

</cftransaction>
