<!--- ****************** PERIOD SETTING *********************** --->
<cfset vInitialDate = vAsOf>
<cfset vLastDate = vMaxTo>
<cfset vDaysToCopy = dateDiff('d', vInitialDate, vLastDate)>
<cfset vCountInserts = 0>

<!--- ****************** GET PERSONS IN THE TEMP FROM LIST *********************** --->
<cfquery name="getPersonFromList" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePerson_#session.acc#
</cfquery>

<!--- ****************** GET PERSONS IN THE TEMP TO LIST *********************** --->
<cfquery name="getPersonToList" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePersonTo_#session.acc#
</cfquery>

<!--- ****************** LOOP THROUG ALL THE PERSONS IN THE TEMP FROM LIST *********************** --->
<cfloop query="getPersonFromList">
	<cfset vThisPersonFrom = personNo>

	<cfloop query="getPersonToList">
		<cfset vThisPersonTo = personNo>
		<cfset vThisDate = vInitialDate>

		<cfloop from="0" to="#vDaysToCopy#" index="dayCount">
			<cfset vThisDate = dateAdd("d", dayCount, vInitialDate)>
			
			<!--- ****************** INSERT PERSON WORK *********************** --->
			<cfinvoke component = "Service.Process.Employee.Attendance"  
				method = "InsertPersonWork"
			   	PersonNoFrom = "#vThisPersonFrom#"
				WorkDateFrom = "#vThisDate#"
				PersonNoTo = "#vThisPersonTo#"
				WorkDateTo = "#vThisDate#" 
				returnvariable="vThisCountInserts">	

			<cfset vCountInserts = vCountInserts + vThisCountInserts>
		</cfloop>

		<!--- ****************** REMOVE PERSON FROM TEMP TO LIST *********************** --->
		<cfquery name="removePersonList" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM 	UserQuery.dbo.CopySchedulePersonTo_#session.acc#
				WHERE	PersonNo = '#vThisPersonTo#'
		</cfquery>

	</cfloop>

	<!--- ****************** REMOVE PERSON FROM TEMP TO LIST *********************** --->
	<cfquery name="removePersonList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM 	UserQuery.dbo.CopySchedulePerson_#session.acc#
			WHERE	PersonNo = '#vThisPersonFrom#'
	</cfquery>

</cfloop>

<cfoutput>
	#numberformat(vCountInserts, ",")# <cf_tl id="transactions were inserted"> <cf_tl id="for"> #numberformat(getPersonToList.recordCount, ",")# <cf_tl id="persons">, <cf_tl id="from"> #dateFormat(vInitialDate, client.dateformatshow)# <cf_tl id="to"> #dateFormat(vLastDate, client.dateformatshow)#.
</cfoutput>