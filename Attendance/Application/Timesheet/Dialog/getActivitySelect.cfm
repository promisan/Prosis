
<!--- apply the selected schema --->

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