
<cfquery name="validatePersonTo" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePersonTo_#session.acc#
</cfquery>

<cfif validatePersonTo.recordCount gt 0>
	<cfset selDate = replace("#url.asof#", "'", "", "ALL")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#SelDate#">
	<cfset vAsOf = dateValue>

	<cfset selDate = replace("#url.maxTo#", "'", "", "ALL")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#SelDate#">
	<cfset vMaxTo = dateValue>

	<cfset vDoCopy = 0>
	<cfset vMessage = "">

	<cfif vMaxTo gte vAsOf>
		<cfset vDoCopy = 1>
	<cfelse>
		<cf_tl id="The 'Up to' date must be greater or equal than the 'From' date" var="1">
		<cfset vMessage = vMessage & "#lt_text#.<br>">
	</cfif>

	<cfif vDoCopy eq 1>
		<cfinclude template="ScheduleCopySubmitTo.cfm">
		<script>
			openview('rolling');
		</script>
	<cfelse>
		<cfoutput>
			<script>
				Prosis.busy('no');
				Prosis.alert("#vMessage#");
			</script>
		</cfoutput>
	</cfif>
<cfelse>
	<cfset selDate = replace("#url.asof#", "'", "", "ALL")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#SelDate#">
	<cfset vAsOf = dateValue>

	<cfset vAsOfEnd = dateAdd('d', (url.weeks*7)-1, vAsOf)>

	<cfset selDate = replace("#url.effective#", "'", "", "ALL")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#SelDate#">
	<cfset vEffective = dateValue>

	<cfset selDate = replace("#url.max#", "'", "", "ALL")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#SelDate#">
	<cfset vMax = dateValue>

	<cfset vDoCopy = 0>
	<cfset vMessage = "">

	<cfif vEffective gt vAsOfEnd && vMax gte vEffective>
		<cfset vDoCopy = 1>
	<cfelse>
		<cf_tl id="The 'Effective' date must be greater than the 'As of' date plus" var="1">
		<cfset vMessage = vMessage & "#lt_text# #url.weeks#">
		<cf_tl id="weeks, and the 'Max' date must be greater or equal than the 'Effective' date" var="1">
		<cfset vMessage = vMessage & "#lt_text#.<br>">
	</cfif>

	<cfif vDoCopy eq 1>
		<cfinclude template="ScheduleCopySubmitFrom.cfm">
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
</cfif>