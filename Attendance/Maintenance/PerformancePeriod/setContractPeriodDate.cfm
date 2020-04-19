
<!--- set the date --->

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

