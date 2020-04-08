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

<cfset vMode = Session.Gender["Mode"]>
<cfif vMode eq "1">
   <cfset vField = "GradeContract">
<cfelse>
   <cfset vField = "PositionGrade">
</cfif>

<cfquery name="getData" 
	datasource="martStaffing">		 
		SELECT   *,
				 #vField# as GradeField
		FROM     Gender G
		WHERE    1=1
		AND 	 Mission        = '#URL.Mission#'
		AND      Incumbency     = '100'
		AND      SelectionDate  = '#URL.Date#'
		AND    TransactionType 	  = '#thisPeriodicity#'
		
		<cfif URL.Seconded eq "1">
			AND    AppointmentType NOT IN ('04')
			AND    ContractTerm NOT IN ('100','125','250')
			AND    left(#vField#,1) IN ('P','D')

			<cfif url.personGrade neq "">
				AND   #getParams.GenderField# = '#url.personGrade#'
				</cfif>	
		<cfelseif URL.Seconded eq "5">
		AND       PositionSeconded   = '#URL.Seconded#'	
		<cfif url.personGrade neq "">
				AND   #getParams.CurrentField# = '#url.personGrade#'
				</cfif>
		<cfelse>
		
		<cfif url.personGrade neq "">
				AND   #getParams.CurrentField# = '#url.personGrade#'
				</cfif>	
		</cfif>		
		
		<cfif url.level neq "">
		
			<cfif URL.Seconded eq "1">		
			AND     left(GradeContract,2) IN (#preserveSingleQuotes(url.level)#)
			<cfelse>
			AND     left(PositionGrade,2) IN (#preserveSingleQuotes(url.level)#)
			</cfif>
		
		</cfif>
		
		<cfif URL.Uniformed eq "1">	
			AND    PositionSeconded   = '1'
		<cfelseif URL.Uniformed eq "0">
			AND    PositionSeconded   = '0' 
		</cfif>	
		
		<cfif trim(url.division) neq "">
		AND       MissionParent = '#url.division#'
		</cfif>
		<cfif trim(url.context) neq "" AND trim(url.context) neq "undefined" AND trim(url.contextValue) neq "" AND trim(url.contextValue) neq "undefined">
		AND 	  #url.context# = '#url.contextValue#'
		</cfif>
</cfquery>

<cfset url.level = replace(url.level, "'", "", "ALL")>

<cfif getData.recordCount gt 0>

	<cfquery name="getTotal" dbtype="query">
		SELECT 	 COUNT(*) as Total
		FROM 	 getData
	</cfquery>
	
	<cfquery name="getSummary" dbtype="query">
		SELECT 	 GradeField, 
		         #vField#Order as GradeOrder, 
				 COUNT(*) as Total
		FROM 	 getData
		GROUP BY GradeField, #vField#Order
		ORDER BY #vField#Order ASC
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
									<th style="text-align:right; padding-right:5px;"><cf_tl id="Female"></th>
									<th style="text-align:right; padding-right:5px;"><cf_tl id="Male"></th>
									<th style="text-align:right; padding-right:5px;"><cf_tl id="Total"></th>
								</tr>
							</thead>
							<tbody>
								<cfset vTotal = 0>
								<cfloop query="getSummary">
									<cfquery name="getMale" dbtype="query">
										SELECT 	COUNT(*) as Total
										FROM 	getData
										WHERE 	GradeField = '#GradeField#'
										AND 	Gender = 'M'
									</cfquery>
									
									<cfset vMaleTotal = 0>
									<cfset vFemaleTotal = 0>
									<cfif getMale.recordCount gt 0>
										<cfset vMaleTotal = getMale.total>
									</cfif>
									<cfset vFemaleTotal = total - vMaleTotal>
									
									<tr>
										<td>#GradeField#</td>
										<td style="text-align:right; padding-right:5px;">#numberformat(vFemaleTotal,',')# <cfif total gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(vFemaleTotal*100/total,'._')#%)</span></cfif></td>
										<td style="text-align:right; padding-right:5px;">#numberformat(vMaleTotal,',')# <cfif total gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(vMaleTotal*100/total,'._')#%)</span></cfif></td>
										<td style="text-align:right; padding-right:5px;">
											<cfif getTotal.recordCount gt 0>
												#numberformat(total,',')# <cfif getTotal.total gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(total*100/getTotal.Total,'._')#%)</span></cfif>
											<cfelse>
												0 (0%)
											</cfif>
										</td>
									</tr>
									<cfset vTotal = vTotal + total>
								</cfloop>
							</tbody>
							<tfoot style="border-top:2px solid silver;">
								<cfquery name="getMaleTotal" dbtype="query">
									SELECT 	COUNT(*) as Total
									FROM 	getData
									WHERE 	Gender = 'M'
								</cfquery>
								<cfset vMaleGrandTotal = 0>
								<cfset vFemaleGrandTotal = 0>
								<cfif getMaleTotal.recordCount gt 0>
									<cfset vMaleGrandTotal = getMaleTotal.total>
								</cfif>
								<cfset vFemaleGrandTotal = vTotal - vMaleGrandTotal>
									
								<tr style="background-color:##F2F2F2;">
									<th><cf_tl id="Total"></th>
									<th style="text-align:right; padding-right:5px;">#numberformat(vFemaleGrandTotal,',')# <cfif vTotal gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(vFemaleGrandTotal*100/vTotal,'._')#%)</span></cfif></th>
									<th style="text-align:right; padding-right:5px;">#numberformat(vMaleGrandTotal,',')# <cfif vTotal gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(vMaleGrandTotal*100/vTotal,'._')#%)</span></cfif></th>
									<th style="text-align:right; padding-right:5px;">#numberformat(vTotal,',')# <cfif vTotal gt 0><span style="font-size:#vPercentageSize#">(#numberFormat(vTotal*100/vTotal,'._')#%)</span></cfif></th>
								</tr>
							</tfoot>
						</table>
					</td>
				</tr>
				<tr><td height="10"></td></tr>
			</cfif>
			<tr>
				<td align="right" style="padding-right:2%;">
					<table>
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
	
	<cfset vDetailTitle = "#url.mission#">
	<cfif isDefined("vMode") AND vMode neq "">
		<cfif vMode eq "1">
			<cfset vDetailTitle = "#vDetailTitle# - Contract Grade">
		<cfelse>
			<cfset vDetailTitle = "#vDetailTitle# - Position Grade">
		</cfif>
	</cfif>
	<cfif isDefined("url.date") AND url.date neq "">
		<cfset vThisDate = ParseDateTime(url.date)>
		<cfset vDetailTitle = "#vDetailTitle# - As of #dateformat(vThisDate,client.dateformatshow)#">
	</cfif>
	<cfif isDefined("url.seconded") AND url.seconded neq "">
		<cfif URL.Seconded eq "1">
			<cfset vDetailTitle = "#vDetailTitle# - Gender Strategy">
		<cfelseif URL.Seconded eq "5">
			<cfset vDetailTitle = "#vDetailTitle# - Seconded Personnel">
		<cfelse>
			<cfset vDetailTitle = "#vDetailTitle# - Overall Composition">
		</cfif>		
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