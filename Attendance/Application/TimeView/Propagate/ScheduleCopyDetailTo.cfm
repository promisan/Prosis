
<cfoutput>

<cfquery name="check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT       MAX(CalendarDateEnd) AS Date
    FROM         OrganizationAction
    WHERE        OrgUnit = '#url.orgunit#' 
	AND          ActionStatus = '1'
</cfquery>	

<cfif check.date eq "">

	<cfset dte = "20180101">

<cfelse>

	<cfset dte = dateformat(check.date+1, "yyyymmdd")>

</cfif>

	<table width="100%" align="center" class="formpadding">
		<tr class="linedotted">
			<td class="labellarge" colspan="2">
				<cf_tl id="Starting" var="1">
				#ucase(lt_text)#
			</td>
		</tr>
		<tr>
			<td class="labelmedium" width="45%">
				<cf_tl id="From" var="1">
				<span style="font-size:90%; color:808080; text-transform:capitalize;">#lt_text#:</span>
			</td>
			<td align="right">
				<!-- <cfform name="copySchedule4">-->
				<cf_intelliCalendarDate9
				    class          = "regularxl"
					FieldName      = "copyEffectiveDateTo" 
					Default        = "#dateformat(vAsOf, CLIENT.DateFormatShow)#"
					DateValidStart = "#dte#"
					message        = "Enter a valid effective date"
					AllowBlank     = "False"
					Manual         = "False"
					scriptdate     = "doScheduleToChangeDate">	
				<!-- </cfform> -->
			</td>
		</tr>
		<tr>
			<td class="labelmedium" width="45%">
				<cf_tl id="Up to" var="1">
				<span style="font-size:90%; color:808080;">#lt_text#:</span>
			</td>
			<td align="right">
				<!-- <cfform name="copySchedule5">-->
				<cf_intelliCalendarDate9
				    class="regularxl"
					FieldName="copyMaxDateTo" 
					Default="#dateformat(vMaxTo, CLIENT.DateFormatShow)#"
					DateValidStart="#dateformat(vMaxTo, 'yyyymmdd')#"
					message="Enter a valid max date"
					AllowBlank="False"
					Manual="False">	
				<!-- </cfform> -->
			</td>
		</tr>
	</table>
</cfoutput>