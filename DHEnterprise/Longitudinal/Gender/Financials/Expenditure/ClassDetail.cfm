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

		SELECT     B.CBFund, 
		           B.CBPeriod, 
				   R.SponsoredClass, 
				   O.ObjectClassName as SponsoredClassName, 
				   O.ListingOrder,
				   ROUND(SUM(B.BaseAmount), 0) AS Total
		FROM       UMOJA.dbo.IMP_CoreFundsCBD AS B INNER JOIN
		           Ref_GLAccount AS R ON B.GLAccount = R.GLAccount INNER JOIN 
				   Ref_ObjectClass O ON R.SponsoredClass = O.ObjectClass
		WHERE      B.CBPeriod = '#url.pPeriod#' 
		AND        R.SponsoredClass IS NOT NULL
		GROUP BY   B.CBFund, B.CBPeriod, R.SponsoredClass, O.ObjectClassName,O.ListingOrder
		<!--- no longer needed
		also add mission to the filter 
		UNION
		SELECT     B.CBFund, B.CBPeriod, R.GLAccount, R.Description, ROUND(SUM(B.BaseAmount), 0) AS Total
		FROM         [NYVM1618].UMOJA.dbo.IMP_CoreFundsCBD AS B INNER JOIN
		                     [NYVM1618].EnterpriseHub.dbo.Ref_GLAccount AS R ON B.GLAccount = R.GLAccount
		WHERE     (B.CBPeriod = '#url.pPeriod#') AND (R.SponsoredClass IS NULL)
		GROUP BY B.CBFund, B.CBPeriod, R.SponsoredClass, R.GLAccount, R.Description
		--->
		ORDER BY O.ListingOrder, O.ObjectClassName, B.CBFund
		  
</cfquery>

<cfquery name="getFunds" dbtype="query">
	SELECT DISTINCT CBFund
	FROM   getBaseData
	ORDER BY CBFund DESC
</cfquery>

<cfquery name="getClasses" dbtype="query">
	SELECT DISTINCT SponsoredClass, SponsoredClassName
	FROM   getBaseData
	ORDER BY ListingOrder
</cfquery>

<cf_mobileRow>

	<cf_MobilePanel 
		bodyClass  = "h-200"
		bodyStyle  = "font-size:80%; max-height:72%; overflow:auto; padding-top:10px;"
		panelClass = "stats hgreen">
							
			<cfoutput>
			
				<cf_mobilerow>
				
					<cf_mobileCell class="col-md-12">
												
						<table class="detailContent table table-striped table-bordered table-hover clsNoPrint tableFixHead" style="width:100%">
																	    
							<thead>							    
								<tr style="background-color:##E8E8E8">
									<th width="1%"></th>
									<th style="width:100%"><cf_tl id="Cost Type"></th>
									<cfloop query="getFunds">
										<th style="min-width:170px;text-align:center;">#CBFund#</th>
									</cfloop>
									<th style="min-width:180px;text-align:center;"><cf_tl id="Total"></th>
									<!---
									<th width="5%"></th>
									--->
								</tr>
							</thead>												
							
							<tbody>		
								
								<cfset totline = 0>
								
								<cfloop query="getClasses">
								
									<tr style="height:20px;!important;">
										<td align="center">#currentrow#.</td>
										<td>#SponsoredClassName#</td>
										
										<cfset totline = 0>
										
										<cfloop query="getFunds">
										
											<cfset vThisTotal = 0>
											<cfquery name="getTotal" dbtype="query">
												SELECT 	SUM(Total) as Total
												FROM 	getBaseData
												WHERE 	SponsoredClass = '#getClasses.SponsoredClass#'
												AND 	CBFund = '#CBFund#'
											</cfquery>
											<cfif getTotal.recordCount eq 1 AND getTotal.Total neq "">
												<cfset vThisTotal = getTotal.Total>
											</cfif>
											<td style="text-align:center;">#numberFormat(vThisTotal,",")#</td>
											<cfset totline = totline + vThisTotal>
											
										</cfloop>
										
										<td style="text-align:center;">#numberFormat(totline,",")#</td>
										
										<!---
										
										<td>
										
											<cfquery name="getGraphData" dbtype="query">
												SELECT 	CBFund, SUM(Total) as Total
												FROM 	getBaseData
												WHERE 	SponsoredClass = '#getClasses.SponsoredClass#'
												GROUP BY CBFund
											</cfquery>
											
											<cfset vSeriesArray = ArrayNew(1)>
											<cfset vSeries = StructNew()>
											<cfset vSeries.query = "#getGraphData#">
											<cfset vSeries.label = "CBFund">
											<cfset vSeries.value = "Total">
											<cfset vSeriesArray[1] = vSeries>
											
											<!---
											<cf_mobileGraph
												id = "fund_#getClasses.SponsoredClass#"
												type = "Pie"
												series = "#vSeriesArray#"
												responsive = "yes"
												scaleStep = "4"
												height = "50px"
												width = "150px"
												maxScale = "#getGraphData.Total#"
												scaleLabel = "<%= numberAddCommas(roundNumber(value, )) %>"
												tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(roundNumber(value, 2)) %>">
												
											</cf_mobileGraph>
											--->
											
										</td>
										
										--->
																				
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
												SELECT 	 SponsoredClass, SponsoredClassName, SUM(Total) as Total
												FROM 	 getBaseData
												WHERE 	 CBFund = '#CBFund#'
												GROUP BY SponsoredClass, SponsoredClassName
											</cfquery>
																														
											<cfset vSeries.query = "#getGraphData#">
											<cfset vSeries.label = "SponsoredClassName">
											<cfset vSeries.value = "Total">
											<cfset vSeriesArray[1] = vSeries>
											
											<cf_mobileGraph
												id           = "class_#cbFund#"
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
										SELECT 	 SponsoredClass, SponsoredClassName, SUM(Total) as Total
										FROM 	 getBaseData												
										GROUP BY SponsoredClass, SponsoredClassName
									</cfquery>										
																			
									<cfset vSeries.query = "#getGraphData#">
									<cfset vSeries.label = "SponsoredClassName">
									<cfset vSeries.value = "Total">
									<cfset vSeriesArray[1] = vSeries>
											
									<cf_mobileGraph
											id          = "class"
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

<cfset doChartsScript = evaluate("doChart_class")>

<!---
<cfloop query="getClasses">
	<cfset doChartsScript = "#doChartsScript# " & evaluate("doChart_fund_#SponsoredClass#")>
</cfloop>
--->

<cfloop query="getFunds">
	<cfset doChartsScript = "#doChartsScript# " & evaluate("doChart_class_#CBFund#")>
</cfloop>

<cfset AjaxOnLoad("function() { #doChartsScript# }")>

<!---
<cfset ajaxOnLoad("function(){ $('.detailContent').DataTable({ 'pageLength':100, 'dom':'<\'dataTableWrapper\'f><\'dataTableWrapper\'ip>t<\'dataTableWrapper\'lr>', 'order': [[4, 'asc']], 'columnDefs':[{'orderData':[5], 'targets':[4]},{'targets':[5],'visible':false,'searchable':false}] }); }")>
--->

