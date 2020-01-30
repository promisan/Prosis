
<!--- ****************** CALCULATE HOW MANY TIMES (WEEKS) THE BLOCK WILL BE COPIED *********************** --->
<cfset vTimesToBeCopied = ceiling((dateDiff('d', vEffective, vMax) + 1) / 7 / url.weeks)>
<cfset vLastDayWillBeCopied = dateAdd('d', (7 * vTimesToBeCopied) - 1, vEffective)>
<cfset vCountInserts = 0>

<!--- ****************** GET PERSONS IN THE TEMP FROM LIST *********************** --->
<cfquery name="getPersonList" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePerson_#session.acc#
</cfquery>

<!--- ****************** LOOP THROUG ALL THE PERSONS IN THE TEMP FROM LIST *********************** --->
<cfloop query="getPersonList">
	<cfset vThisPersonNo = personNo>

	<!--- ****************** COPY AS MANY TIMES IS NEEDED *********************** --->
	<cfloop from="0" to="#vTimesToBeCopied-1#" index="vThisTimeToBeCopied">

		<!--- ****************** BLOCK TO BE COPIED *********************** --->
		<cfloop from="0" to="#url.weeks-1#" index="vThisWeek">

			<cfloop from="0" to="6" index="vThisDay">
				<cfset vThisDateFrom = dateAdd('d', vThisDay + (7 * vThisWeek), vAsOf)>
				<cfset vThisDateTo = dateAdd('d', vThisDay + (7 * vThisWeek) + (7 * vThisTimeToBeCopied * url.weeks), vEffective)>
				
				<!--- ****************** INSERT PERSON WORK *********************** --->
				<cfinvoke component = "Service.Process.Employee.Attendance"  
					method = "InsertPersonWork"
				   	PersonNoFrom = "#vThisPersonNo#"
					WorkDateFrom = "#vThisDateFrom#"
					PersonNoTo = "#vThisPersonNo#"
					WorkDateTo = "#vThisDateTo#" 
					returnvariable="vThisCountInserts">

				<cfset vCountInserts = vCountInserts + vThisCountInserts> 	

			</cfloop>

		</cfloop>

	</cfloop>

	<!--- ****************** REMOVE PERSON FROM TEMP LIST *********************** --->
	<cfquery name="removePersonList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM 	UserQuery.dbo.CopySchedulePerson_#session.acc#
			WHERE	PersonNo = '#vThisPersonNo#'
	</cfquery>

</cfloop>

<cfoutput>
	#numberformat(vCountInserts, ",")# <cf_tl id="transactions were inserted"> <cf_tl id="for"> #numberformat(getPersonList.recordCount, ",")# <cf_tl id="persons">, <cf_tl id="from"> #dateFormat(vEffective, client.dateformatshow)# <cf_tl id="to"> #dateFormat(vLastDayWillBeCopied, client.dateformatshow)#.
</cfoutput>
