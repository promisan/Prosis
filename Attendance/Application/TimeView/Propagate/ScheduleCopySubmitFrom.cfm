<!--
    Copyright © 2025 Promisan B.V.

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
