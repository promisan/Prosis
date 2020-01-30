<cfset dateValue = "">
<cf_DateConvert Value="#url.upToDate#">
<cfset vDateExpiration = dateValue>
<cfset vInitDate = url.selectedDate>

<cfset k = dateAdd("d", 0, vInitDate)>
<cfset vDateExpiration = dateAdd("d", 0, vDateExpiration)>

<cfloop condition="#k# lte #vDateExpiration#">
	
	<cfif evaluate("url.day_" & DayOfWeek(k)) eq "true">
	
		<cfset go = "0">
		<cfif url.mth_1 eq "" and url.mth_2 eq "" and url.mth_3 eq "">
		   
		   <cfset go = "1">
		   
		<cfelse>
		
		   <cfset dom = dateformat(k,"d")>
		
		   <cfif dom eq url.mth_1 or dom eq url.mth_2 or dom eq url.mth_3>
		       <cfset go = "1">
		   </cfif>
		   
		</cfif>
		
		<cfif go eq "1">
				
			<cfset url.action        = "add">
			<cfset url.refreshDetail = "0">
			<cfset url.selectedDate  = createDate(dateFormat(k,"yyyy"),dateFormat(k,"m"),dateFormat(k,"d"))>		
			<cfinclude template="ScheduleDateDetailSubmit.cfm">
					
		</cfif>
				
	</cfif>
	
	<cfif url.everyNSelector eq "day">
		<cfset k = dateAdd("d", url.everyNDays, k)>
	<cfelseif url.everyNSelector eq "month">
		<cfset k = dateAdd("m", url.everyNMonths, k)>
	<cfelseif url.everyNSelector eq "year">
		<cfset k = dateAdd("yyyy" , url.everyNYears, k)>
	</cfif>
	
</cfloop>

<!--- Save Inherit Schema --->
<cfset url.schemaEffective = vInitDate>
<cfset url.schemaExpiration = vDateExpiration>
<cfinclude template="ScheduleInheritSchemaSubmit.cfm">

<!--- Calendar Refresh --->
<cfset vEndRefreshDay = daysInMonth(vInitDate)>
<cfif vDateExpiration lt createDate(year(vInitDate),month(vInitDate),daysInMonth(vInitDate))>
	<cfset vEndRefreshDay = day(vDateExpiration)>
</cfif>

<cfloop index="d" from="#day(vInitDate)#" to="#vEndRefreshDay#">
	<cfset vDate = createDate(year(vInitDate),month(vInitDate),d)>
	<cfoutput>
		<script>
			calendarrefresh('#d#','#urlencodedformat(vDate)#');
		</script>
	</cfoutput>
</cfloop>

<!--- Detail Refresh --->
<cfset url.selectedDate = vInitDate>
<cfinclude template="ScheduleDateDetail.cfm">

<!--- Remove modal box --->
<cfoutput>
	<script>
		ColdFusion.navigate('ScheduleSummary.cfm?scheduleid=#url.scheduleid#','summarybox');
		try {
			ColdFusion.Window.destroy('inheritWOSchedule');
		}catch(e){}		
		try { if ($('###url.scheduleid#').length > 0) { opener.applyfilter('1','','#url.scheduleid#'); } } catch(e) { }		
	</script>
</cfoutput>

