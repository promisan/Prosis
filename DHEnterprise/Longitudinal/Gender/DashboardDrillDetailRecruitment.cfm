
<cfif url.level eq "null">
	<cfset url.level = "">
</cfif>
<cfset url.level = replace(url.level, "'", "", "ALL")>
<cfset url.level = ListQualify(url.level, "'")>

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset refDate = dateValue>

<cfquery name="getData" 
	datasource="martStaffing">		 
		SELECT  JobOpeningId, 
				JobOpeningPosted, 
				JobOpeningClose, 
				JobCodeName, 
				PostGrade, 
				PostGradeOrder,
				  (SELECT     TOP (1) DocumentNo
					FROM          nyvm1613.Applicant.dbo.FunctionOrganization AS FunctionOrganization_1
					WHERE      (ReferenceNo = R.JobOpeningId)
					ORDER BY Created DESC) AS NovaDocumentNo
		FROM	Recruitment AS R <cfif url.source eq "RecruitmentStage">INNER JOIN RecruitmentStage S ON S.SelectionDate = R.SelectionDate AND S.Recordid = R.RecordId</cfif>
		WHERE   Mission = '#URL.Mission#'
		AND		YEAR(JobOpeningPosted) = #year(refDate)#
		<cfif trim(url.context) neq "" AND trim(url.context) neq "undefined" AND trim(url.contextValue) neq "" AND trim(url.contextValue) neq "undefined">
			AND 	#url.context# = '#url.contextValue#'
		<cfelse>
			AND 	JobOpeningClass IN ('Job Opening','Temporary Job Opening')	
		</cfif>
		<cfif url.level neq "">
			AND Left(PostGrade,2) IN (#preserveSingleQuotes(url.level)#)
		</cfif>	
		<cfif URL.Seconded eq "1">									
			AND    left(PostGrade,1) IN ('P','D')
		</cfif>
		GROUP BY 
				JobOpeningId, 
				JobOpeningPosted, 
				JobOpeningClose, 
				JobCodeName, 
				PostGrade, 
				PostGradeOrder
		ORDER BY PostGradeOrder ASC
</cfquery>

<table class="detailContent table table-striped table-bordered table-hover clsNoPrint" style="width:100%">
	<thead>
		<tr>
			<th><cf_tl id="Id"></th>
			<th width="15%"><cf_tl id="Posted"></th>
			<th width="15%"><cf_tl id="Close"></th>
			<th><cf_tl id="Name"></th>
			<th><cf_tl id="Grade"></th>
			<th><cf_tl id="Order"></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="getData">
			<tr>
				<td>
					<cfif novaDocumentNo eq "">
						#JobOpeningId#
					<cfelse>
						<a href="#session.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=#novaDocumentNo#" target="_blank" style="color:##358FDE;">#JobOpeningId#</a>
					</cfif>
				</td>
				<td>#JobOpeningPosted#</td>
				<td>#JobOpeningClose#</td>
				<td>#JobCodeName#</td>
				<td>#PostGrade#</td>
				<td>#PostGradeOrder#</td>
			</tr>
		</cfoutput>
	</tbody>
</table>

<!--- USED FOR PRINTING --->
<table class="detailContentExpanded table table-striped table-bordered table-hover" style="width:100%; display:none;">
	<thead>
		<tr>
			<th><cf_tl id="Id"></th>
			<th width="15%"><cf_tl id="Posted"></th>
			<th width="15%"><cf_tl id="Close"></th>
			<th><cf_tl id="Name"></th>
			<th><cf_tl id="Grade"></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="getData">
			<tr>
				<td>
					<a href="#session.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=#novaDocumentNo#" target="_blank" style="color:##358FDE;">#JobOpeningId#</a>
				</td>
				<td>#JobOpeningPosted#</td>
				<td>#JobOpeningClose#</td>
				<td>#JobCodeName#</td>
				<td>#PostGrade#</td>
			</tr>
		</cfoutput>
	</tbody>
</table>