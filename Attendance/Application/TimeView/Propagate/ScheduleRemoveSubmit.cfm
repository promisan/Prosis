
<cfquery name="getPersonsList" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	RemoveSchedulePerson_#session.acc#
</cfquery>

<cfif getPersonsList.recordCount gt 0>

	<cfset selDate = replace("#url.removeEffectiveDate#", "'", "", "ALL")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#SelDate#">
	<cfset vEffectiveDate = dateValue>

	<cfset selDate = replace("#url.removeExpirationDate#", "'", "", "ALL")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#SelDate#">
	<cfset vExpirationDate = dateValue>

	<cfset vDoCopy = 0>
	<cfset vMessage = "">

	<cfif vExpirationDate gte vEffectiveDate>
		<cfset vDoCopy = 1>
	<cfelse>
		<cf_tl id="The 'Up to' date must be greater or equal than the 'From' date" var="1">
		<cfset vMessage = vMessage & "#lt_text#.<br>">
	</cfif>

	<cfif vDoCopy eq 1>

		<cfset vDaysToCopy = dateDiff('d', vEffectiveDate, vExpirationDate)>

		<cfloop query="getPersonsList">
			<cfset vThisPerson = personNo>

			<cfloop from="0" to="#vDaysToCopy#" index="vDays">
				<cfset vThisDate = dateAdd('d', vDays, vEffectiveDate)>

				<cftransaction>

					<!--- ****************** REMOVE PERSON WORK *********************** --->
					<cfinvoke component = "Service.Process.Employee.Attendance"  
						method = "RemovePersonWork"
						Datasource = "AppsEmployee"
					   	PersonNo = "#vThisPerson#"
						WorkDate = "#vThisDate#">

					<!--- ****************** REMOVE PERSON FROM TEMP LIST *********************** --->
					<cfquery name="removePersonList" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							DELETE
							FROM 	UserQuery.dbo.RemoveSchedulePerson_#session.acc#
							WHERE	PersonNo = '#vThisPerson#'
					</cfquery>

				</cftransaction>

			</cfloop>

		</cfloop>

		<cfoutput>
		<script>
			openview('#session.timesheet["Presentation"]#');
		</script>
		</cfoutput>
		
	<cfelse>

		<cfoutput>
			<script>
				Prosis.busy('no');
				Prosis.alert("#vMessage#");
			</script>
		</cfoutput>

	</cfif>

<cfelse>

	<cf_tl id="Nothing to remove" var="vNothingMessage">
	<cfoutput>
		<script>
			Prosis.busy('no');
			Prosis.alert("#vNothingMessage#");
		</script>
	</cfoutput>

</cfif>

<cfoutput>
	<cf_tl id="All transactions removed for"> #numberformat(getPersonsList.recordCount, ",")# <cf_tl id="persons">, <cf_tl id="from"> #dateFormat(vEffectiveDate, client.dateformatShow)# <cf_tl id="to"> #dateFormat(vExpirationDate, client.dateformatShow)#.
</cfoutput>