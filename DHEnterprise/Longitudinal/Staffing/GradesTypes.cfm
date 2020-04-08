<cfparam name="URL.Mission" default="SCBD">
<cfparam name="URL.Date" default="2019-03-31">

<cfset ajaxOnLoad("initPanelButtons")>

<cfif url.level eq "null">
	<cfset url.level = "">
</cfif>
<cfset url.level = replace(url.level, "'", "", "ALL")>
<cfset url.level = ListQualify(url.level, "'")>

<cfquery name="getData" 
	datasource="AppsOrganization">
	SELECT   PostGrade, 
			 (SELECT count(*) 
			  FROM  NYVM1617.MartStaffing.dbo.Position
	          WHERE  SelectionDate = '#URL.Date#' 
	          AND    Mission = '#URL.Mission#'
	          AND    PostType = P.PostType) as TypeTotal,
	         PostOrder, 
	         PostType, 
	         PostTypeName, 
	         COUNT(*) AS counted
	FROM     NYVM1617.MartStaffing.dbo.Position P
	WHERE    (SelectionDate = '#URL.Date#') and Mission = '#URL.Mission#'
	<cfif url.level neq "">
	AND 	Postgrade IN (#preserveSingleQuotes(url.level)#)
	</cfif>
	GROUP BY PostGrade, PostOrder, PostType, PostTypeName
	ORDER BY PostOrder, PostType
	  
</cfquery>

<cfset url.level = replace(url.level, "'", "", "ALL")>

<cfquery name="qGrades" dbtype="query">
	SELECT 	DISTINCT PostGrade
	FROM 	getData
	ORDER BY PostOrder ASC
</cfquery> 

<cfquery name="qPostTypes" dbtype="query">
	SELECT 	DISTINCT PostType, PostTypeName, TypeTotal
	FROM 	getData
	ORDER BY TypeTotal DESC
</cfquery>

<cf_mobileRow>
	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:80%;"
		panelClass = "stats hgreen"
		title="GRADES VS TYPES">
			
			<cfoutput>
				<cf_mobilerow>
					<cf_mobileCell class="col-md-12">
						
						<table class="table table-striped table-bordered table-hover table-responsive">
							<thead>
								<tr style="background-color:##E8E8E8;">
									<th><cf_tl id="Post Grade"></th>
									<cfloop query="qPostTypes">
										<th style="text-align:center;width:15%;">#PostTypeName#</th>
									</cfloop>
									<th style="min-width:100px;text-align:center;width:15%;"><cf_tl id="Total"></th>
								</tr>
							</thead>
							<tbody>
								<cfloop query="qGrades">
									<tr>
										<td>#PostGrade#</td>
										<cfloop query="qPostTypes">
										
											<cfquery name="qCell" dbtype="query">
												SELECT 	Counted
												FROM 	getData
												WHERE   PostGrade = '#qGrades.PostGrade#'
												AND 	PostType = '#qPostTypes.PostType#'
											</cfquery>
												
											<cfset vThisStyle = "color:##358FDE;cursor:pointer;">
											<cfset vThisScript = "showDrillDetail('#qPostTypes.PostTypeName# - #qGrades.PostGrade#', 'Details', 'DrilldownPosition.cfm?date=#url.date#&mission=#url.mission#&postgrade=#qGrades.PostGrade#&posttype=#qPostTypes.PostType#&level=#url.level#');">
											
											<cfif qCell.counted eq 0 OR qCell.counted eq "">
												<cfset vThisStyle = "">
												<cfset vThisScript = "">
											</cfif>
											
											<td 
												align="center" 
												style="#vThisStyle#" 
												onclick="#vThisScript#">
												<cfif qCell.counted eq "">
													-
												<cfelse>
												#numberformat(qCell.Counted, ",")#
												</cfif>
											</td>
										</cfloop>
										<td align="center">
										<cfquery name="qCell" dbtype="query">
												SELECT 	sum(Counted) as Counted
												FROM 	getData
												WHERE   PostGrade = '#qGrades.PostGrade#'
											</cfquery>
											<cfif qCell.counted eq "">
												-
											<cfelse>
											#numberformat(qCell.Counted, ",")#
											</cfif>
										
										</td>
									</tr>
								</cfloop>
							</tbody>

							<tfoot>
								<tr style="background-color: ##E8E8E8;">
									<td align="center"><cf_tl id="Total"></td>
									<cfloop query="qPostTypes">
										<td align="center">
											<cfquery name="qCellTotal" dbtype="query">
												SELECT 	SUM(Counted) AS Counted
												FROM 	getData
												WHERE   PostType = '#qPostTypes.PostType#'
											</cfquery>
											#numberformat(qCellTotal.Counted, ",")#
										</td>
									</cfloop>
									
									<td align="center">
										<cfquery name="qCell" dbtype="query">
												SELECT 	sum(Counted) as Counted
												FROM 	getData
											</cfquery>
											<cfif qCell.counted eq "">
												-
											<cfelse>
											#numberformat(qCell.Counted, ",")#
											</cfif>
										
										</td>
								</tr>
							</tfoot>

							
						</table>

					</cf_mobileCell>
				</cf_mobilerow>
			</cfoutput>

	</cf_MobilePanel>
</cf_mobileRow>