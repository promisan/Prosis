
 <cfquery name="Totals" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    DistributionCategory as Category, count(*) as Total
		FROM      UserReportDistribution
		WHERE    (ReportId = '#reportId#' 
		     AND ReportId != '00000000-0000-0000-0000-000000000000')
		OR       (ControlId = '#ControlId#' 
		     AND Account = '#SESSION.acc#' 
			 AND ReportId = '00000000-0000-0000-0000-000000000000')
		GROUP BY DistributionCategory 	 
		ORDER BY DistributionCategory 
		</cfquery>
					
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="flash" 
		         chartheight="260" 
				 chartwidth="400" 
				 scalefrom="0"
				 scaleto="300" 
				 showxgridlines="yes" 
				 showygridlines="yes"
				 gridlines="6" 
				 showborder="no" 
				 fontsize="11" 
				 fontbold="yes" 
				 fontitalic="no" 
				 xaxistitle="" 
				 yaxistitle="Distribution" 
				 show3d="no" 
				 rotated="yes" 
				 sortxaxis="no" 
				 showlegend="no" 
				 tipbgcolor="##FFFFCC" 
				 showmarkers="yes" 
				 markersize="30" 
				 backgroundcolor="##ffffff">
		
		<cfchartseries type="bar" 
		         query="Totals" 
				 itemcolumn="Category" 
				 valuecolumn="Total" 
				 seriescolor="##CCCC66" 
				 paintstyle="shade" 
				 markerstyle="snow" colorlist="##CCCC66,##FFFF99,##3399FF,##66CC66,##999999,##9966FF,##FF7777,##FFFFFF">
		</cfchartseries>
		</cfchart>
			
	


			