<cfquery name="Trigger" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_PayrollTrigger
	WHERE  TriggerGroup = 'Overtime'
</cfquery>

<cftransaction>

	<cfquery name="purgeDetail" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	PersonOvertimeDetail
		WHERE 	OvertimeId = '#url.overtimeId#'
		AND 	PersonNo = '#url.PersonNo#'
	</cfquery>

	<cfoutput query="Trigger">

		<cfif isDefined("Form.#SalaryTrigger#_hour") AND isDefined("Form.#SalaryTrigger#_minu")>
				
			<cfset vHours = evaluate("Form.#SalaryTrigger#_hour")>
			<cfset vMinut = evaluate("Form.#SalaryTrigger#_minu")>
			<cfset vMemo  = evaluate("Form.#SalaryTrigger#_memo")>

			<cfquery name="insertDetail" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">

				INSERT INTO [dbo].[PersonOvertimeDetail]
				      (PersonNo,
					   OvertimeId,
					   SalaryTrigger,
					   OvertimeHours,
					   OvertimeMinutes,
					   BillingPayment,
					   Memo,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)
				VALUES
				     ('#url.PersonNo#','#url.overtimeId#','#SalaryTrigger#','#vHours#','#vMinut#','#Form.OvertimePayment#','#vMemo#',
				      '#session.acc#','#session.last#','#session.first#')

			</cfquery>


		</cfif>
		
	</cfoutput>

</cftransaction>