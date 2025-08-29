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
<cfoutput>

<cfquery name="Last" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ContractPeriod
		WHERE    Mission = '#url.mission#'
		AND      ContractClass = '#url.class#'
		ORDER BY PASPeriodStart DESC
	</cfquery>
	
	<cfif last.recordcount gte "1">

    	<cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(last.PASPeriodEnd,CLIENT.DateFormatShow)#">
	
		<cfset STR = dateAdd("d",1,dateValue)>
		<cfset END = dateAdd("yyyy",1,dateValue)>
	
		<script>
		
			document.getElementById('PASPeriodStart').value = '#dateformat(STR,client.dateformatshow)#'
			document.getElementById('PASPeriodEnd').value   = '#dateformat(END,client.dateformatshow)#'
		</script>

	<cfelse>
	
		<cfset st = "">	
		
	</cfif>	
	
</cfoutput>	

