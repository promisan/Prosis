<cfparam name="URL.Mission" default="SCBD">
<cfparam name="URL.Date" default="2019-03-31">

<cfset vLevel = "">
<cfif url.level neq "null">
	<cfset vLevel = ListQualify(url.level, "'")>
</cfif>

<cfset ajaxOnLoad("initPanelButtons")>

<cfquery name="getData" 
	datasource="AppsOrganization">
	SELECT    PostGrade, 
	          PostOrder, 
			  SelectionDate, 
			  (SELECT count(DISTINCT PositionId) 
			   FROM   NYVM1617.MartStaffing.dbo.Position
			   WHERE  Mission       = '#url.mission#'
			   AND    SelectionDate = P.SelectionDate
			   AND    PostGrade     = P.PostGrade) as Positions,			  
			  COUNT(DISTINCT PositionId) AS Vacant
	FROM      NYVM1617.MartStaffing.dbo.Position P
	WHERE     IndexNo IS NULL
	AND       SelectionDate <= '#URL.Date#' 
	AND       Mission       = '#URL.Mission#'
	<cfif vLevel neq "">
	AND 	PostGrade IN (#preservesinglequotes(vLevel)#)
	</cfif>
	GROUP BY  SelectionDate,PostGrade, PostOrder
	ORDER BY  SelectionDate,PostOrder, PostGrade	  
</cfquery>

<cfquery name="Dates" datasource="appsOrganization" maxrows=15>
        SELECT    DISTINCT SelectionDate
		FROM      NYVM1617.MartStaffing.dbo.Position
		WHERE     SelectionDate <= '#url.date#'
		ORDER BY 1 DESC
</cfquery>

<cfquery name="qDate" dbtype="query">
		SELECT    *
		FROM      Dates
		ORDER BY 1 ASC</cfquery>

<cfquery name="qGrades" dbtype="query">
	SELECT 	DISTINCT PostGrade
	FROM 	getData
	ORDER BY PostOrder ASC
</cfquery> 

<cf_mobileRow>

	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:80%; max-height:78%; overflow:auto; padding-top:0px;"
		panelClass = "stats hgreen"
		title="VACANCIES BY GRADE">
			
			<cfoutput>
				<cf_mobilerow>
					<cf_mobileCell class="col-md-12">
						
						<table class="table table-striped table-bordered table-hover table-responsive tableFixHead">
							<thead>
								<tr style="background-color:##E8E8E8;">
									<th style="width:50%;text-align:center;"><cf_tl id="Post Grade"></th>
									<cfloop query="qDate">
									<th style="width:100px;text-align:center;">#dateformat(selectiondate,"YYYY/MM")#</th>
									</cfloop>
								</tr>
							</thead>
							<tbody>
								<cfloop query="qGrades">
									<tr>
										<td align="center">#PostGrade#</td>
										
										<cfset p = "0">
										
										<cfloop query="qDate">
										
											<cfquery name="qCell" dbtype="query">
												SELECT 	Vacant, Positions
												FROM 	getData
												WHERE   PostGrade     = '#qGrades.PostGrade#'
												AND     SelectionDate = '#selectiondate#'
											</cfquery>
											<cfif qCell.Vacant gt p and p neq "0">
											<td align="center" style="background-color: ##FFA07A80;">
											<cfelseif qCell.Vacant lt p and p neq "0">
											<td align="center" style="background-color: ##FFFF0080;">
											<cfelse>
											<td align="center">
											</cfif>											
											<font size="4">#numberformat(qCell.Vacant, ",")#</font> 
											<cfif qCell.Vacant neq "">
											<font size="1">/#qCell.Positions#<br>#numberformat(qCell.Vacant*100/qCell.Positions, "._")#%</font>
											</cfif>
										    </td>
											<cfset p = qCell.Vacant>
										</cfloop>
									</tr>
								</cfloop>
							</tbody>
						

							<tfoot>
								<tr style="background-color: ##E8E8E8;">
									<td align="center"><cf_tl id="Total"></td>
									
									<cfloop query="qDate">
										<td align="center">
											<cfquery name="qCell" dbtype="query">
												SELECT 	SUM(Vacant) as Vacant
												FROM 	getData
												WHERE    SelectionDate = '#selectiondate#'
											</cfquery>
											#numberformat(qCell.Vacant, ",")#
										</td>
									</cfloop>
										
									
								</tr>
							</tfoot>

							
						</table>

					</cf_mobileCell>
				</cf_mobilerow>
			</cfoutput>

	</cf_MobilePanel>
</cf_mobileRow>