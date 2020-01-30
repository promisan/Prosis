<cfparam name="url.OrgUnit" 				default="0">
<cfparam name="url.PersonNo" 				default="">
<cfparam name="url.removeEffectiveDate" 	default="#dateformat(now(), client.DateFormatShow)#">
<cfparam name="url.removeExpirationDate" 	default="#url.removeEffectiveDate#">
<cfparam name="url.validStartDateFrom"		default="#dateformat(now(), client.DateFormatShow)#">
<cfparam name="url.validStartDateTo"		default="#url.removeEffectiveDate#">

<cfif url.removeEffectiveDate eq "">
	<cfset url.removeEffectiveDate = dateformat(now(), client.DateFormatShow)>
</cfif>

<cfif url.removeExpirationDate eq "">
	<cfset url.removeExpirationDate = url.removeEffectiveDate>
</cfif>

<cfif url.validStartDateFrom eq "">
	<cfset url.validStartDateFrom = url.removeEffectiveDate>
</cfif>

<cfif url.validStartDateTo eq "">
	<cfset url.validStartDateTo = url.removeEffectiveDate>
</cfif>

<cfset selDate = replace("#url.validStartDateFrom#", "'", "", "ALL")>
<cfset dateValue = "">
<CF_DateConvert Value="#SelDate#">
<cfset vDateValidStartFrom = dateValue>

<cfset selDate = replace("#url.validStartDateTo#", "'", "", "ALL")>
<cfset dateValue = "">
<CF_DateConvert Value="#SelDate#">
<cfset vDateValidStartTo = dateValue>

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

<!--- *********** PERSON FROM ***************** --->
<cfquery name="getPerson" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Person
		WHERE	PersonNo = '#URL.PersonNo#'
</cfquery>

<cfquery name="createTable" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		if not exists (select * from sysobjects where name='RemoveSchedulePerson_#session.acc#' and xtype='U')
	    create table RemoveSchedulePerson_#session.acc# (
	        PersonNo varchar(20) not null,
	        LastName varchar(40) not null,
	        FirstName varchar(50) not null
	    )
</cfquery>

<cfquery name="validatePerson" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	RemoveSchedulePerson_#session.acc#
		WHERE 	PersonNo = '#URL.PersonNo#'
</cfquery>

<cfif trim(URL.PersonNo) neq "" AND validatePerson.recordCount eq 0>
	<cfquery name="insertPerson" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO RemoveSchedulePerson_#session.acc#
			VALUES
				(
					'#URL.PersonNo#',
					'#getPerson.LastName#',
					'#getPerson.FirstName#'
				)
	</cfquery>
</cfif>

<cfquery name="getPersonList" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	RemoveSchedulePerson_#session.acc#
		ORDER BY LastName, FirstName
</cfquery>

<cfoutput>
	<table width="91%" align="center" class="formpadding">
		<tr><td height="10"></td></tr>
		<tr class="line">
			<td>
				<table width="100%" class="formpadding navigation_table">
					<tr>
						<td colspan="2" style="font-size:80%; color:808080;" class="labellarge">
							<cf_tl id="Remove schedule for" var="1">
							#ucase(lt_text)#
						</td>
					</tr>
					<cfloop query="getPersonList">
						<tr class="navigation_row">
							<td width="1%" class="labellarge clsTimeSheetPerson_#personno#">
								<cf_img icon="delete" onclick="doRemovePersonTableRemove('#personNo#');">	
							</td>
							<td style="font-weight:bold; padding-right:10px;" class="labellarge clsTimeSheetPerson_#personno#" onmouseover="highlightTimesheePerson('#personNo#', '##8AFFBB');" onmouseout="highlightTimesheePerson('#personNo#', '');">
								#lastname#, #firstName#
							</td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>
		<tr><td height="10"></td></tr>

		<cfif getPersonList.recordCount gt 0>
			<tr>
				<td>
					<table width="100%" align="center" class="formpadding">
						<tr>
							<td class="labelmedium" width="45%">
								<cf_tl id="From" var="1">
								<span style="font-size:90%; color:808080; text-transform:capitalize;">#lt_text#:</span>
							</td>
							<td align="right">
								<!-- <cfform name="copySchedule6">-->
								<cf_intelliCalendarDate9
								    class="regularxl"
									FieldName="removeEffectiveDate" 
									Default="#url.removeEffectiveDate#"
									DateValidStart="#dte#"
									message="Enter a valid effective date"
									AllowBlank="False"
									Manual="False"
									scriptdate="doScheduleRemoveChangeDate">	
								<!-- </cfform> -->
							</td>
						</tr>
						<tr>
							<td class="labelmedium" width="45%">
								<cf_tl id="Up to" var="1">
								<span style="font-size:90%; color:808080;">#lt_text#:</span>
							</td>
							<td align="right">
								<!-- <cfform name="copySchedule7">-->
								<cf_intelliCalendarDate9
								    class="regularxl"
									FieldName="removeExpirationDate" 
									Default="#url.removeExpirationDate#"
									DateValidStart="#dateformat(vDateValidStartTo, "yyyymmdd")#"
									message="Enter a valid max date"
									AllowBlank="False"
									Manual="False">	
								<!-- </cfform> -->
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr><td class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td align="center">	
					<cf_tl id="Remove" var="vSubmitLabel">	
					<cf_tl id="This action will REMOVE the whole planning for the selected period and persons." var="vConfirm1">
					<cf_tl id="Do you confirm you want to continue ?" var="vConfirm2">
					<input type="button" 
						class="button10g" 
						name="btnCopy" 
						id="btnCopy" 
						value="#ucase(vSubmitLabel)#"
						onclick="if (confirm('#vConfirm1#\n#vConfirm2#')) { doScheduleRemove(); }">
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr><td id="targetDoRemove" align="center" class="labelmedium"></td></tr>
		<cfelse>
			<tr>
				<td class="labelmedium" style="color:FF3333;" align="center">
					[ <cf_tl id="No persons to remove from"> ]
				</td>
			</tr>
		</cfif>

	</table>
</cfoutput>

<cfset ajaxOnLoad("function() { doHighlight(); doCalendar(); }")>

<cfinclude template="ValidatePersonSelection.cfm">