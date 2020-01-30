
<cfparam name="url.orgunit"     	default="0">
<cfparam name="url.type" 			default="from">
<cfparam name="url.PersonNo" 		default="">
<cfparam name="url.PersonNoTo" 		default="">
<cfparam name="url.weeks" 			default="6">
<cfparam name="url.asof" 			default="#dateformat(now(), client.DateFormatShow)#">
<cfparam name="url.effective" 		default="#dateformat(now(), client.DateFormatShow)#">
<cfparam name="url.maxTo" 			default="#dateformat(now(), client.DateFormatShow)#">

<cfif trim(url.type) eq "to">
	<cfset url.personNoTo = url.personNo>
	<cfset url.personNo = "">
</cfif>

<cfif url.effective eq "">
	<cfset url.effective = dateformat(now(), client.DateFormatShow)>
</cfif>

<cfif url.asof eq "">
	<cfset url.asof = dateformat(now(), client.DateFormatShow)>
</cfif>

<cfif url.maxTo eq "">
	<cfset url.maxTo = dateformat(now(), client.DateFormatShow)>
</cfif>

<cfif url.weeks eq "">
	<cfset url.weeks = 6>
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
		if not exists (select * from sysobjects where name='CopySchedulePerson_#session.acc#' and xtype='U')
	    create table CopySchedulePerson_#session.acc# (
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
		FROM 	CopySchedulePerson_#session.acc#
		WHERE 	PersonNo = '#URL.PersonNo#'
</cfquery>

<cfif trim(URL.PersonNo) neq "" AND validatePerson.recordCount eq 0>

	<cfquery name="insertPerson" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO CopySchedulePerson_#session.acc#
			VALUES ('#URL.PersonNo#',
					'#getPerson.LastName#',
					'#getPerson.FirstName#'	)
	</cfquery>
</cfif>

<cfquery name="getPersonList" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePerson_#session.acc#
		ORDER BY LastName, FirstName
</cfquery>

<!--- *********** PERSON TO ***************** --->
<cfquery name="getPerson" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Person
		WHERE	PersonNo = '#URL.PersonNoTo#'
</cfquery>

<cfquery name="createTable" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		if not exists (select * from sysobjects where name='CopySchedulePersonTo_#session.acc#' and xtype='U')
	    create table CopySchedulePersonTo_#session.acc# (
	        PersonNo varchar(20)  not null,
	        LastName varchar(40)  not null,
	        FirstName varchar(50) not null
	    )
</cfquery>

<cfquery name="validatePersonTo" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePersonTo_#session.acc#
		WHERE 	PersonNo = '#URL.PersonNoTo#'
</cfquery>

<cfquery name="validatePersonToInFrom" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePerson_#session.acc#
		WHERE 	PersonNo = '#URL.PersonNoTo#'
</cfquery>

<cfif trim(URL.PersonNoTo) neq "" AND validatePersonTo.recordCount eq 0 AND validatePersonToInFrom.recordCount eq 0>
	<cfquery name="insertPerson" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO CopySchedulePersonTo_#session.acc#
			VALUES	('#URL.PersonNoTo#',
					'#getPerson.LastName#',
					'#getPerson.FirstName#'	)
	</cfquery>
</cfif>

<cfquery name="getPersonToList" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePersonTo_#session.acc#
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
							<cf_tl id="Copy schedule for" var="1">
							#ucase(lt_text)#
						</td>
					</tr>
					<cfloop query="getPersonList">
						<tr class="navigation_row">
							<td width="1%" class="labellarge clsTimeSheetPerson_#personno#">
								<cf_img icon="delete" onclick="doCopyPersonTableRemove('#personNo#', 'from');">	
							</td>
							<td style="font-weight:bold; padding-right:10px;" class="labellarge clsTimeSheetPerson_#personno#" onmouseover="highlightTimesheePerson('#personNo#', '##8AFFBB');" onmouseout="highlightTimesheePerson('#personNo#', '');">
								#lastname#, #firstName#
							</td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>
		
		<cfif getPersonToList.recordCount gt 0>
			<tr><td height="10"></td></tr>
			<tr class="line">
				<td>
					<table width="100%" class="formpadding navigation_table">
						<tr>
							<td colspan="2" style="font-size:80%; color:808080;" class="labellarge">
								<cf_tl id="Copy schedule to" var="1">
								#ucase(lt_text)#
							</td>
						</tr>
						<cfloop query="getPersonToList">
							<tr class="navigation_row">
								<td width="1%" class="labellarge clsTimeSheetPerson_#personno#">
									<cf_img icon="delete" onclick="doCopyPersonTableRemove('#personNo#', 'to');">	
								</td>
								<td style="font-weight:bold; padding-right:10px;" class="labellarge clsTimeSheetPerson_#personno#" onmouseover="highlightTimesheePerson('#personNo#', '##8AFFBB');" onmouseout="highlightTimesheePerson('#personNo#', '');">
									#lastname#, #firstName#
								</td>
							</tr>
						</cfloop>
					</table>
				</td>
			</tr>
		</cfif>
		<tr><td height="10"></td></tr>
		
		
		<cfif validatePersonToInFrom.recordCount neq 0>
			<tr>
				<td class="labelit" style="color:FF3333;">
					** <cf_tl id="Cannot copy TO the same person">.
				</td>
			</tr>
			<tr><td height="10"></td></tr>
		</cfif>

		<cfif getPersonToList.recordCount gt 0 AND getPersonList.recordCount gt 1>
			<tr>
				<td class="labelmedium" style="color:FF3333;" align="center">
					<cfset selDate = replace("#url.asof#", "'", "", "ALL")>
					<cfset dateValue = "">
					<CF_DateConvert Value="#SelDate#">
					<cfset vAsOf = dateValue>
					<cfset vAsOfEnd = dateAdd('d', url.weeks*7, vAsOf)>
					<cfset vAsOfEndString = dateFormat(vAsOfEnd, client.DateFormatShow)>

					[ <cf_tl id="Cannot copy FROM more than 1 person at a time"> ]
					<input type="hidden" id="copyAsOfDate" value="#url.asof#">
					<input type="hidden" id="copyWeeks" value="#url.weeks#">
					<input type="hidden" id="copyEffectiveDate" value="#vAsOfEndString#">
					<input type="hidden" name="copyMaxDate" value="#vAsOfEndString#">
					<input type="hidden" id="copyEffectiveDateTo" value="#url.asof#">
					<input type="hidden" name="copyMaxDateTo" value="#url.asof#">
				</td>
			</tr>
		<cfelse>
			<cfif getPersonList.recordCount gt 0>
				<tr>
					<td>
						<cfdiv id="divScheduleCopyDetail" bind="url:#session.root#/Attendance/Application/TimeView/Propagate/ScheduleCopyDetail.cfm?orgunit=#url.orgunit#&asof=#url.asof#&weeks=#url.weeks#&effective=#url.effective#&max=#url.max#&maxTo=#url.maxTo#">
					</td>
				</tr>
				<tr><td height="10"></td></tr>
				<tr><td class="line"></td></tr>
				<tr><td height="10"></td></tr>
				<tr>
					<td align="center">	
						<cf_tl id="Copy" var="vSubmitLabel">	
						<cf_tl id="This action will replace the whole planning for the selected period and persons." var="vConfirm1">
						<cf_tl id="Do you confirm you want to continue ?" var="vConfirm2">
						<input 
							type="button" 
							class="button10g" 
							name="btnCopy" 
							id="btnCopy" 
							value="#ucase(vSubmitLabel)#"
							onclick="if (confirm('#vConfirm1#\n#vConfirm2#')) { doScheduleCopy(); }">
					</td>
				</tr>
				<tr><td height="10"></td></tr>
				<tr><td id="targetDoCopy" align="center" class="labelmedium"></td></tr>
			<cfelse>
				<tr>
					<td class="labelmedium" style="color:FF3333;" align="center">
						[ <cf_tl id="No persons to copy from"> ]
					</td>
				</tr>
			</cfif>

		</cfif>

	</table>
</cfoutput>

<cfset ajaxOnLoad("doHighlight")>

<cfinclude template="ValidatePersonSelection.cfm">