<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund"    default="">
<cfparam name="URL.pYear"    default="2019">
<cfparam name="URL.pDonor"   default="">
<cfparam name="URL.pPeriod"  default="">

<cfif trim(URL.pYear) eq "" OR trim(URL.pYear) eq "undefined">
	<cfset URL.pYear = year(now())>
</cfif>

<cfset vThisYear = URL.pYear>

<cfquery name="getBaseData" 
	datasource="HubEnterprise">
		SELECT    R.ProgramCode, R.ProgramName, R.ListingOrder, T.CBFund, ROUND(SUM(T.BaseAmount), 0) AS Total
		FROM      _WBseMapping AS M INNER JOIN
                  NYVM1613.Program.dbo.Program AS R ON M.ProgramCode = R.ProgramCode INNER JOIN
                  FinanceTransaction AS T ON M.CBWBSe = T.CBWBSe
		WHERE     T.Mission = '#url.pMission#' 
		AND       T.CBFund IN ('40BYL', '40BBL', '40BGL') 
		AND       T.FiscalYear = '#url.pYear#'
		--- AND   T.PostingClass = 'Budget'
		GROUP BY  T.CBFund, R.ProgramCode, R.ProgramName, R.ListingOrder
		ORDER BY  R.ListingOrder  
</cfquery>

<cfquery name="getFunds" dbtype="query">
	SELECT DISTINCT CBFund
	FROM   getBaseData
	ORDER BY CBFund DESC
</cfquery>

<cfquery name="getResources" dbtype="query">
	SELECT DISTINCT ProgramCode, ProgramName
	FROM   getBaseData
	ORDER BY ListingOrder
</cfquery>

<cf_mobileRow>

	<cf_MobilePanel 
		bodyClass  = "h-200"
		bodyStyle  = "font-size:80%; max-height:72%; overflow:auto; padding-top:0px;"
		panelClass = "stats hgreen">
							
			<cfoutput>
			
				<cf_mobilerow style="border-top:10px solid ##FFFFFF;">
				
					<cf_mobileCell class="col-md-12">
												
						<table class="detailContent table table-striped table-bordered table-hover clsNoPrint tableFixHead" style="width:100%">
																	    
							<thead>							    
								<tr style="background-color:##E8E8E8">
									<th width="1%"></th>
									<th style="width:100%"><cf_tl id="Resource"></th>
									<cfloop query="getFunds">
									
											<cfquery name="getFund" dbtype="query">
												SELECT 	SUM(Total) as Total
												FROM 	getBaseData
												WHERE 	CBFund = '#CBFund#'
											</cfquery>
											
											<cfparam name="Total#CBFund#" default="#getFund.total#">
									
										<th style="min-width:170px;text-align:center;">#CBFund#</th>
									</cfloop>
									     <cfquery name="getFund" dbtype="query">
												SELECT 	SUM(Total) as Total
												FROM 	getBaseData
											</cfquery>
											
											<cfparam name="allTotal" default="#getFund.total#">
											
									<th style="min-width:180px;text-align:center;"><cf_tl id="Total"></th>
									<!---
									<th width="5%"></th>
									--->
								</tr>
							</thead>												
							
							<tbody>		
								
								<cfset totline = 0>								
																
								<cfloop query="getResources">
								
									<tr style="height:20px;!important;">
										<td align="center">#currentrow#.</td>
										<td>#ProgramName#</td>
										
										<cfset totline = 0>
										
										<cfloop query="getFunds">
										
											<cfset vThisTotal = 0>
											
											<cfquery name="getTotal" dbtype="query">
												SELECT 	SUM(Total) as Total
												FROM 	getBaseData
												WHERE 	ProgramCode = '#getResources.ProgramCode#'
												AND 	CBFund = '#CBFund#'
											</cfquery>
											
											<cfif getTotal.recordCount eq 1 AND getTotal.Total neq "">
												<cfset vThisTotal = getTotal.Total>
											</cfif>
											
											<cfset fundtotal = evaluate("Total#CBFund#")>
											
											<td>
												<table style="width:100%">
												<tr>
												<td style="min-width:110px;text-align:right;padding-right:6px">#numberFormat(vThisTotal,",")#</td>
												<td style="border-left:1px solid silver;min-width:70px;text-align:right;padding-right:4px">#numberFormat(vThisTotal*100/fundtotal,"._")#%</td>
												</tr>
												</table>
											</td>
											<cfset totline = totline + vThisTotal>
											
										</cfloop>
										
										<td style="text-align:center;">
										
										<table style="width:100%">
												<tr>
												<td style="min-width:110px;text-align:right;padding-right:6px">#numberFormat(totline,",")#</td>
												<td style="border-left:1px solid silver;min-width:70px;text-align:right;padding-right:4px">#numberFormat(totLine*100/alltotal,"._")#%</td>
												</tr>
												</table>
										</td>
																				
									</tr>
								</cfloop>
															
							</tbody>
							
							<tfoot>
							
								<tr>
									<td></td>
									<td></td>
									<cfloop query="getFunds">
									
										<td style="text-align:center;">
										
											<cfquery name="getGraphData" dbtype="query">
												SELECT 	 ProgramCode, ProgramName, SUM(Total) as Total
												FROM 	 getBaseData
												WHERE 	 CBFund = '#CBFund#'
												GROUP BY ProgramCode, ProgramName
											</cfquery>
																														
											<cfset vSeries.query = "#getGraphData#">
											<cfset vSeries.label = "ProgramName">
											<cfset vSeries.value = "Total">
											<cfset vSeriesArray[1] = vSeries>
											
											<cf_mobileGraph
												id           = "resource_#cbFund#"
												type         = "Pie"
												series       = "#vSeriesArray#"
												responsive   = "yes"
												scaleStep    = "4"
												height       = "145px"
												width        = "165px"
												maxScale     = "#getGraphData.Total#"
												scaleLabel    = "<%= numberAddCommas(roundNumber(value, )) %>"
												tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(roundNumber(value, 2)) %>">
											</cf_mobileGraph>
											
										</td>
									</cfloop>
									<td>
									
									<cfquery name="getGraphData" dbtype="query">
										SELECT 	 ProgramCode, ProgramName, SUM(Total) as Total
										FROM 	 getBaseData												
										GROUP BY ProgramCode, ProgramName
									</cfquery>										
																			
									<cfset vSeries.query = "#getGraphData#">
									<cfset vSeries.label = "ProgramName">
									<cfset vSeries.value = "Total">
									<cfset vSeriesArray[1] = vSeries>
											
									<cf_mobileGraph
											id          = "resource"
											type        = "Pie"
											series      = "#vSeriesArray#"
											responsive  = "yes"
											scaleStep   = "4"
											height      = "145px"
											width       = "165px"
											maxScale    = "#getGraphData.Total#"
											scaleLabel  = "<%= numberAddCommas(roundNumber(value, )) %>"
											tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(roundNumber(value, 2)) %>">
									</cf_mobileGraph>
									
									</td>
									
									<!---
									<td></td>
									--->
									
								</tr>
								
								<tr style="background-color: ##f1f1f1">
								
									<td></td>
									<td></td>
									
									<cfset totline = 0>
									
									<cfloop query="getFunds">
									
										<cfset vThisTotal = 0>
										<cfquery name="getTotal" dbtype="query">
											SELECT 	SUM(Total) as Total
											FROM 	getBaseData
											WHERE 	CBFund = '#CBFund#'
										</cfquery>
										<cfif getTotal.recordCount eq 1 AND getTotal.Total neq "">
											<cfset vThisTotal = getTotal.Total>
										</cfif>
										
										<td style="text-align:center;">#numberFormat(vThisTotal,",")#</td>
										
										<cfset totline = totline + vThisTotal>	
										
									</cfloop>
									
									<td style="text-align:center;">#numberFormat(totline,",")#</td>		
									<!---
									<td></td>	
									--->
								</tr>
										
							</tfoot>
														
						</table>

					</cf_mobileCell>
				</cf_mobilerow>
			</cfoutput>

	</cf_MobilePanel>
</cf_mobileRow>

<cfset doChartsScript = evaluate("doChart_resource")>

<!---
<cfloop query="getClasses">
	<cfset doChartsScript = "#doChartsScript# " & evaluate("doChart_fund_#SponsoredClass#")>
</cfloop>
--->

<cfloop query="getFunds">
	<cfset doChartsScript = "#doChartsScript# " & evaluate("doChart_resource_#CBFund#")>
</cfloop>

<cfset AjaxOnLoad("function() { #doChartsScript# }")>

<!---
<cfset ajaxOnLoad("function(){ $('.detailContent').DataTable({ 'pageLength':100, 'dom':'<\'dataTableWrapper\'f><\'dataTableWrapper\'ip>t<\'dataTableWrapper\'lr>', 'order': [[4, 'asc']], 'columnDefs':[{'orderData':[5], 'targets':[4]},{'targets':[5],'visible':false,'searchable':false}] }); }")>
--->

