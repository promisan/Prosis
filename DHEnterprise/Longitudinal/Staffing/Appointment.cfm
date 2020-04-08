<cfparam name="URL.Mission" default="SCBD">
<cfparam name="URL.Date" default="2016-06-30">

<cfabort>

<cfquery name="getData" 
	datasource="AppsOrganization">
	SELECT         PostGrade, PostOrder, COUNT(*) AS Vacant
	FROM            NYVM1617.MartStaffing.dbo.Position
	WHERE        (IndexNo IS NULL)
	AND          (SelectionDate = '#URL.Date#') and Mission = '#URL.Mission#'
	GROUP BY PostGrade, PostOrder
	ORDER BY PostOrder, PostGrade
	  
</cfquery>

<cfquery name="qGrades" dbtype="query">
	SELECT 	DISTINCT PostGrade
	FROM 	getData
	ORDER BY PostOrder ASC
</cfquery> 

<cf_mobileRow>
	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:80%;"
		panelClass = "stats hgreen"
		title="VACANCIES BY GRADE">
			
			<cfoutput>
				<cf_mobilerow>
					<cf_mobileCell class="col-md-12">
						
						<table class="table table-striped table-bordered table-hover table-responsive">
							<thead>
								<tr style="background-color:##E8E8E8;">
									<th style="width:100px;text-align:center;"><cf_tl id="Post Grade"></th>
									<th style="width:80%;text-align:center;"><cf_tl id="Vacants"></th>
								</tr>
							</thead>
							<tbody>
								<cfloop query="qGrades">
									<tr>
										<td align="center">#PostGrade#</td>
										<td align="center">
											<cfquery name="qCell" dbtype="query">
												SELECT 	Vacant
												FROM 	getData
												WHERE   PostGrade = '#qGrades.PostGrade#'
											</cfquery>
											#numberformat(qCell.Vacant, ",")#
										</td>
									</tr>
								</cfloop>
							</tbody>

							<tfoot>
								<tr style="background-color: ##E8E8E8;">
									<td align="center"><cf_tl id="Total"></td>
									<td align="center">
										<cfquery name="qCellTotal" dbtype="query">
											SELECT 	SUM(Vacant) AS Vacant
											FROM 	getData
										</cfquery>
										#numberformat(qCellTotal.Vacant, ",")#
									</td>
								</tr>
							</tfoot>

							
						</table>

					</cf_mobileCell>
				</cf_mobilerow>
			</cfoutput>

	</cf_MobilePanel>
</cf_mobileRow>