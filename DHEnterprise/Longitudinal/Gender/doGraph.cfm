<cfparam name="url.name"          default="url.field">
<cfparam name="url.field"         default="gender">
<cfparam name="url.order"         default="gender">
<cfparam name="url.source"        default="Gender">
<cfparam name="url.countoption"   default="1">
<cfparam name="url.title"         default="">
<cfparam name="URL.graph"         default="doughnut">
<cfparam name="url.id"            default="#url.field#">
<cfparam name="url.condition"     default="">

<cfparam name="url.division"      default="">
<cfparam name="url.personGrade"   default="">
<cfparam name="url.category"      default="">
<cfparam name="url.occgroup"      default="">

<cfif isDefined("session.acc") AND TRIM(Session.acc) neq "">
	<cfset url.showDetail	= "1">
	<cfelse>
	<cfset url.showDetail	= "0">
</cfif>

<cfinclude template="getData.cfm">

<cfquery name="qGetTotal" dbtype="query">
	SELECT 	SUM(Total) as Total
	FROM	getData
</cfquery>

<!--- Get palette for the legend --->
<cf_MobileGraphPalette 
	color="gender"
	transparency="0.7">
	
<cfset "doChart_g#url.id#" = "">

<cfif getData.recordCount gt 0>

	<cfquery name="maxData" dbtype="query">
		SELECT 	MAX(Total) as Total
		FROM	getData
	</cfquery>	
	
		<cf_tl id="Last update" var="lastUpdateLabel">
		
		<cf_MobilePanel 
			bodyClass = "h-200"
			bodyStyle = "font-size:80%;"
			panelClass = "stats hgreen">

			<cf_mobilerow>

				<cf_mobileCell class="col-md-12">
					<cfoutput>
						<cfif url.title neq "">	
							<h4>#ucase(url.title)#</h4>
						<cfelse>		
							<cf_tl id="By #url.field#" var="1">
							<h4>#ucase(lt_text)#</h4>
						</cfif>	
					</cfoutput>
				</cf_mobileCell>

			</cf_mobilerow>
			
			<cf_mobilerow>
			
				<cf_mobileCell class="col-md-6 table-responsive">

					<cfoutput>

						<table style="width:100%;" class="table table-bordered table-striped">
							<thead>
								<tr>
									<th style="text-align:center;"><cf_tl id="Description"></th>
									<th style="text-align:center;">
										<cf_tl id="Count">
										<cfif url.field neq "Gender">
											<br> <span style="font-size:60%;">F | M</span>
										</cfif>
									</th>
									<th style="text-align:center;">Total Percentage</th>
								</tr>
							</thead>
							<tbody>

								<cfset cntRow = 1>
								<cfset vTransactionsTotal = 0>
								<cfset vGrandTotal = 0>

								<cfset colorTable = QueryNew("Description,Color", "Varchar,VarChar")> 

								<cfloop query="getData">
									<cfquery name="qTopic" 
										datasource="martStaffing">		 
											SELECT *
											FROM stLabel 
											WHERE Topic = '#CategoryDescription#'
									</cfquery>
																		
									<tr>
										<cfset vClickElement = "">
										<cfset vClickElementStyle = "">
										<cfif url.showDetail eq "1">
											<cfset vClickElement = "clickElement('#CategoryDescription#','#url.field#','#url.division#','#url.source#');">
											<cfset vClickElementStyle = "color:##358FDE;cursor:pointer;">
										</cfif>
										<td style="text-transform:capitalize;text-align:center;#vClickElementStyle#" onclick="#vClickElement#">
												<cfif qTopic.recordCount neq 0>
														#ucase(qTopic.Description)#
														<cfif qTopic.R neq "">
													   		<cfset QueryAddRow(colorTable)>
													   		<cfset Temp = QuerySetCell(colorTable, "Description", CategoryDescription)>
													   		<cfset Temp = QuerySetCell(colorTable, "Color", "rgba(#qTopic.R#,#qTopic.G#,#qTopic.B#,0.7)")>
														</cfif>													
												<cfelse>
													#ucase(CategoryDescription)#
												</cfif>

												
										</td>
										<td align="center">
											<cfif url.field neq "Gender" AND url.source eq "Gender">
												<cfquery name="qCellFemale" datasource="martStaffing">
													SELECT 	COUNT(*) AS Total
													FROM 	Gender
													#PreserveSingleQuotes(vCondition)#
													AND  	Gender = 'F'
													AND 	#url.field# = '#CategoryDescription#'
												</cfquery>
												<cfset vFemale = 0>
												<cfif qCellFemale.recordCount gt 0 AND qCellFemale.Total neq "">
													<cfset vFemale = qCellFemale.Total>
												</cfif>
												#NumberFormat(Total,",")#
												<br> <span style="font-size:60%;">#vFemale# | #Total - vFemale#</span>
											<cfelse>
												#NumberFormat(Total,",")#
											</cfif>
										</td>
										<td align="center" style="color:##4D4D4D; font-size:85%;">#NumberFormat(Total*100/qGetTotal.Total, ",._")# %</td>										
									</tr>
									<cfset cntRow = cntRow + 1>
									<cfset vTransactionsTotal = vTransactionsTotal + Total>
								</cfloop>

								<cfset vClickElement = "">
								<cfset vClickElementStyle = "">
								<cfif url.showDetail eq "1">
									<cfset vClickElement = "clickElement('','#url.field#','#url.division#','#url.source#');">
									<cfset vClickElementStyle = "color:##358FDE;cursor:pointer;">
								</cfif>
								<tr>
									<td style="background-color:##E8E8E8;text-transform:capitalize;text-align:center; #vClickElementStyle#" 
										onclick="#vClickElement#"><cf_tl id="Total"></td>
									<td align="center" style="background-color:##E8E8E8;">
										<cfif url.field neq "Gender" AND url.source eq "Gender">
											<cfquery name="qCellFemale" datasource="martStaffing">
												SELECT 	COUNT(*) AS Total
												FROM 	Gender
												#PreserveSingleQuotes(vCondition)#
												AND  	Gender = 'F'
											</cfquery>
											<cfset vFemale = 0>
											<cfif qCellFemale.recordCount gt 0 AND qCellFemale.Total neq "">
												<cfset vFemale = qCellFemale.Total>
											</cfif>
											#NumberFormat(vTransactionsTotal,",")#
											<br> <span style="font-size:60%;">#vFemale# | #vTransactionsTotal - vFemale#</span>
										<cfelse>
											#NumberFormat(vTransactionsTotal,",")#
										</cfif>
									</td>
									<td></td>
								</tr>
								
							</tbody>
						</table>

					</cfoutput>

				</cf_mobileCell>
				
				<cf_mobileCell class="col-md-6">

					<cfset vSeriesArray = ArrayNew(1)>
					
					<cfquery name="qColor" 
						datasource="martStaffing">		 
							SELECT *
							FROM stLabel 
							WHERE Topic = 'M'
					</cfquery>					
					
					<cfset vSeriesArray = ArrayNew(1)>
					
					<cfset vSeries = StructNew()>
					<cfset vSeries.query = "#getData#">
					<cfset vSeries.label = "CategoryDescription">
					<cfset vSeries.value = "Total">

					<cfif URL.graph eq "bar">
					
						<cfset vSeries.colorMode = "custom">
						<cfset vSeries.color = ["rgba(256, 0, 0, 0.7", "rgba(163, 88, 237, 0.7)", "rgba(0, 0, 256, 0.7)", "rgba(232, 126, 4, 0.7)", "rgba(101, 198, 187, 0.7)", "rgba(224, 130, 131, 0.7)", "rgba(100, 130, 131, 0.7)", "rgba(100, 256, 100, 0.7)", "rgba(0, 256, 256, 0.7)"]>										

						<cfset vSeriesArray[1] = vSeries>
						
						<cfset vClickElement = "">
						<cfif url.showDetail eq "1">
							<cfset vClickElement = "clickElement(e.label,'#url.field#','#url.division#','#url.source#');">
						</cfif>
						
						<cf_mobileGraph
							id = "g#url.id#"
							height = "250px"
							type = "bar"
							series = "#vSeriesArray#"
							onclick = "function(e) { #vClickElement# }"
							legend  ="no"
							datapoints = "yes">
						</cf_mobileGraph>						
						
					<cfelse>
					
						<cfset vColorArray     = ArrayNew(1)>
						<cfset vColor          = StructNew()>
						<cfset vColor.query    = "#colorTable#">
						<cfset vColorArray[1]  = vColor>
						<cfset vSeriesArray[1] = vSeries>
						
						<cfset vClickElement = "">
						<cfif url.showDetail eq "1">
							<cfset vClickElement = "clickElement(e.label,'#url.field#','#url.division#','#url.source#');">
						</cfif>

						<cf_mobileGraph
							id = "g#url.id#"
							height = "250px"
							type = "doughnut"
							series = "#vSeriesArray#"
							onclick = "function(e) { #vClickElement# }"
							legend  ="true"
							color = "#vColorArray#"
							datapoints = "yes">
						</cf_mobileGraph>

					</cfif>	
				</cf_mobileCell>
				
			</cf_mobilerow>
			
		</cf_MobilePanel>		
	
</cfif>
		