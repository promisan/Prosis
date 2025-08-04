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