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
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<cfquery name="getSchema" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    ProgramActivitySchema
	  WHERE   ActivityId = '#url.activityId#'
	  AND     Operational = 1
	  AND     Weekday = '#dayofweek(dte)#'
</cfquery>

<cfif getSchema.recordcount eq "1">
	
	<!--- populate the selection hours based on the schema --->
	<cfoutput>
		<script>
		_cf_loadingtexthtml='';
		ptoken.navigate('setEntryFormSlots.cfm?id=#url.id#&class=#url.class#&activityid=#url.activityid#&date=#url.date#','myslots')
		</script>
	</cfoutput>

</cfif>