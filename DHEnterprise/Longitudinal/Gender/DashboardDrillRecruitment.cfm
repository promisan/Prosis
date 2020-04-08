<cfparam name="url.context" 		default="">
<cfparam name="url.contextValue" 	default="">
<cfparam name="url.division" 		default="">
<cfparam name="url.level" 			default="">
<cfparam name="url.source" 			default="Gender">

<cfset url.contextValue = URLDecode(url.contextValue)>

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

<cfset url.level = replace(url.level, "'", "", "ALL")>

<cfif getData.recordCount gt 0>

	<cfquery name="getTotal" dbtype="query">
		SELECT 	 COUNT(*) as Total
		FROM 	 getData
	</cfquery>
	
	<cfquery name="getSummary" dbtype="query">
		SELECT 	 PostGrade, 
		         PostGradeOrder, 
				 COUNT(*) as Total
		FROM 	 getData
		GROUP BY PostGrade, PostGradeOrder
		ORDER BY PostGradeOrder ASC
	</cfquery>
	
	<cfset vPercentageSize = "70%">
	
	<cfoutput>
		<table class="formpadding" style="width:100%">
			<tr class="clsNoPrint hidden-xs">
				<td style="<cfif getSummary.recordCount lte 1>padding-bottom:20px;</cfif>">
					<cfoutput>
						<button class="btn btn-primary" onclick="___prosisMobileWebPrint('##modalDetail .modal-content', true, '#session.root#/DHEnterprise/Longitudinal/Gender/Styles/printStyle.css?ts=#gettickcount()#', '$(\'.detailContentExpanded\').show(); $(\'.dataTables_filter, .dataTables_info, .dataTables_paginate, .dataTables_length\').hide();')">
							<span class='glyphicon glyphicon-print'></span> <cf_tl id="Print">
						</button>
					</cfoutput>
				</td>
			</tr>
			<cfif getSummary.recordCount gt 1>
				<tr>
					<td>
						<table class="table table-striped table-bordered table-hover" style="width:50%" align="center">
							<thead style="border-bottom:2px solid silver;">
								<tr>
									<th><cf_tl id="Grade"></th>
									<th style="text-align:right; padding-right:5px;"><cf_tl id="Total"></th>
								</tr>
							</thead>
							<tbody>
								<cfset vTotal = 0>
								<cfloop query="getSummary">
									<tr>
										<td>#PostGrade#</td>
										<td style="text-align:right; padding-right:5px;">
											<cfif getTotal.recordCount gt 0>
												#numberformat(total,',')# <cfif getTotal.total gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(total*100/getTotal.Total)#%)</span></cfif>
											<cfelse>
												0 (0%)
											</cfif>
										</td>
									</tr>
									<cfset vTotal = vTotal + total>
								</cfloop>
							</tbody>
							<tfoot style="border-top:2px solid silver;">
								<tr style="background-color:##F2F2F2;">
									<th><cf_tl id="Total"></th>
									<th style="text-align:right; padding-right:5px;">#numberformat(vTotal,',')# <cfif vTotal gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(vTotal*100/vTotal)#%)</span></cfif></th>
								</tr>
							</tfoot>
						</table>
					</td>
				</tr>
				<tr><td height="10"></td></tr>
			</cfif>
			<tr>
				<td align="right" style="padding-right:2%; height:40px;">
					<table style="display:none;">
						<tr class="labellarge">
							<td>
								<input 
									type="Radio" 
									id="fldAll" 
									name="fldGender" 
									value="" 
									checked 
									onclick="showDrillDetailContext('#url.mission#','#url.date#','#url.seconded#', '','#url.context#','#url.contextvalue#','#url.division#','#url.source#','#url.level#','#url.uniformed#')"> 
								<label for="fldAll"><cf_tl id="All"></label>
							</td>
							<td style="padding-left:10px;">
								<input 
									type="Radio" 
									id="fldMale" 
									name="fldGender" 
									value="M" 
									onclick="showDrillDetailContext('#url.mission#','#url.date#','#url.seconded#','M','#url.context#','#url.contextvalue#','#url.division#','#url.source#','#url.level#','#url.uniformed#')"> 
								<label for="fldMale"><cf_tl id="Male"></label>
							</td>
							<td style="padding-left:10px;">
								<input 
									type="Radio" 
									id="fldFemale" 
									name="fldGender" 
									value="F"
									onclick="showDrillDetailContext('#url.mission#','#url.date#','#url.seconded#','F','#url.context#','#url.contextvalue#','#url.division#','#url.source#','#url.level#','#url.uniformed#')"> 
								<label for="fldFemale"><cf_tl id="Female"></label>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td id="detailContainer"></td>
			</tr>
		</table>
	</cfoutput>
	
	<cfset vDetailTitle = "#url.mission# - Position Grade">
	<cfif isDefined("url.date") AND url.date neq "">
		<cfset vDetailTitle = "#vDetailTitle# - #year(refDate)#">
	</cfif>
	<cfif isDefined("url.context") AND url.context neq "" AND isDefined("url.contextvalue") AND url.contextvalue neq "">
		<cfquery name="qTopic" 
			datasource="martStaffing">		 
				SELECT *
				FROM stLabel 
				WHERE Topic = '#url.context#'
		</cfquery>
		
		<cfset vContextLabel = url.context>
		<cfif qTopic.recordcount gt 0>
			<cfset vContextLabel = qTopic.Description>
		</cfif>
	
		<cfset vDetailTitle = "#vDetailTitle# - #vContextLabel#: #url.contextvalue#">
	</cfif>
	
	<cfset ajaxOnLoad("function(){ $('##modalDetail .modal-title').html('#vDetailTitle#'); showDrillDetailContext('#url.mission#','#url.date#','#url.seconded#','','#url.context#','#url.contextvalue#','#url.division#','#url.source#','#url.level#','#url.uniformed#'); }")>

</cfif>