
<cfparam name="url.name"     default="url.field">
<cfparam name="url.field"    default="gender">
<cfparam name="url.order"    default="gender">
<cfparam name="url.Division" default="">
<cfparam name="url.Id"       default="#url.field#">
<cfparam name="url.Column"   default="gender">
<cfparam name="url.mode"     default="">
<cfparam name="url.content"  default="details">

<!--- URL content  - three possible values -   
		details: prints all data
		table :only table
		graph :only graph
		split : one thing above, and one below
----> 

<cfparam name="url.occgroup"    default="">
<cfparam name="url.condition"   default="">
<cfparam name="url.personGrade" default="">

<cfparam name="url.source"      default="Gender">
<cfparam name="url.countoption" default="1">
<cfparam name="url.category"    default="">

<cfset vDate = URL.Date>

<cfif isDefined("session.acc") AND TRIM(Session.acc) neq "">
	<cfset url.showDetail	= "1">
	<cfelse>
	<cfset url.showDetail	= "0">
</cfif>

<cfinclude template="getData.cfm">


<cfquery name="qPeriod" datasource="martStaffing">
	SELECT   TOP 5 * 
	FROM     Period
	WHERE 
		(
			--Status 			= 5 
			SelectionDate 	<= '#URL.Date#' 
			AND 	SelectionDate 	>'2016-12-31' /*rfuentes*/
		) 
		OR 
			SelectionDate = '#URL.Date#'
	ORDER BY SelectionDate DESC 
</cfquery>	

<cfquery name="qPeriod" dbtype="query"> <!---set different order to show in screen ----->
	SELECT   * 
	FROM     qPeriod
	ORDER BY SelectionDate ASC
</cfquery>	

<cfquery name="qGetTotal" dbtype="query">
	SELECT 	SUM(Total) as Total
	FROM	getData
</cfquery>

<!--- Get palette for the legend --->
<cf_MobileGraphPalette 
	color="female"
	transparency="0.7">
	
<cfset "doChart_g#Trim(URL.id)#" = "">

<cfif getData.recordCount gt 0>

	<cfquery name="maxData" dbtype="query">
		SELECT 	MAX(Total) as Total
		FROM	getData
	</cfquery>
	
	<cfquery name="qColorMale" 
		datasource="martStaffing">		 
			SELECT *
			FROM stLabel 
			WHERE Topic = 'M'
	</cfquery>

	<cfquery name="qColorFemale" 
		datasource="martStaffing">		 
			SELECT *
			FROM stLabel 
			WHERE Topic = 'F'
	</cfquery>
			
	<cfset colors[1] = "###qColorFemale.Color#">
	<cfset colors[2] = "###qColorMale.Color#">	
	
		<cf_MobilePanel 
			bodyClass = "h-200"
			bodyStyle = "font-size:80%;"
			panelClass = "stats hgreen">

				<cfif url.source eq "Gender">
				
					<cfquery name="qHeader" 
						datasource="martStaffing">		 
							SELECT DISTINCT #url.column# as ColumnName 
							FROM   Gender
							#PreserveSingleQuotes(vCondition)# 
							
					</cfquery>
					
				<cfelse>
				
					<cfquery name="qHeader" 
						datasource="martStaffing">		 
							SELECT DISTINCT #url.column# as ColumnName 
							FROM Recruitment
							#PreserveSingleQuotes(vCondition)# 
							AND #url.column#!='' 
					</cfquery>	
								
				</cfif>	
				
				<cfset vAdded = "Description, CategoryOrder,ClosingDate">
				<cfset vAddedType = "VarChar, Integer,Date">
				
				<cfloop query="qHeader">
					<cfset vAdded = "#vAdded#,#Left(qHeader.ColumnName,4)#">	
					<cfset vAddedType = "#vAddedType#,Integer">
				</cfloop>
				
				<cfloop query="qHeader">
					<cfset vAdded = "#vAdded#,p#Left(qHeader.ColumnName,4)#">	
					<cfset vAddedType = "#vAddedType#,Integer">
				</cfloop>	
					
				<cfset genderTable = QueryNew("#vAdded#", "#vAddedType#")>				
				
				<cfsavecontent variable="dTable">
				
					<cfoutput>
						<table width="100%">
							<tr>
								<td align="left">
									<table>
										<tr>
											<td><input type="radio" name="opResultSelector" id="opResultSelectorQ" onclick="$('.clsPercentage').hide();$('.clsQuantity').show();" checked> 
													<label style="font-weight:normal;" for="opResultSelectorQ">Quantities</label>
											</td>
											<td style="padding-left:10px;"><input type="radio" name="opResultSelector" id="opResultSelectorP" onclick="$('.clsQuantity').hide();$('.clsPercentage').show();"> 
												<label style="font-weight:normal;" for="opResultSelectorP">Percentages</label>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr><td height="10"></td></tr>
							<tr>
								<td>
									<table style="width:100%;" class="table table-bordered table-striped" id="mainTable">
										<thead>
											
											<tr>
												<th></th>
												
												<cfloop query="qPeriod">
			
													<th colspan="#qHeader.recordcount+1#" style="text-align:center; border-bottom:1px solid ##DDD;">
														#DateFormat(SelectionDate,CLIENT.DateFormatShow)#
													</th>
												</cfloop>	
												<cfif getParams.LoggedIn eq "1">
													<th colspan="3" style="text-align:center;">
														Efforts in #DateFormat(URL.date,"YYYY")#
													</th>	
												
													<th style="text-align:center;" colspan="5">
														<cf_tl id="Targets">
													</th>
												</cfif>
											</tr>
											
											<cfset vNumberOfColumns = 0>
											
											<tr valign="center">
												<th style="text-align:center;">
													<cfquery name="qTitle" 
														datasource="martStaffing">		 
															SELECT *
															FROM stLabel 
															WHERE Topic = '#URL.field#'
													</cfquery>
													<cfif qTitle.recordcount neq 0> 
														#qTitle.Description#
													<cfelse>
														#url.field#
													</cfif>					
												</th>
												
												<cfset vNumberOfColumns++/>
												
												<cfloop query="qPeriod">
												
													<cfloop query="qHeader">
														<cfquery name="qTopic" 
															datasource="martStaffing">		 
																SELECT *
																FROM stLabel 
																WHERE Topic = '#qHeader.ColumnName#'
														</cfquery>										
														<th style="text-align:center;" class="clsQuantity">
															<cfif qTopic.Image neq "">
																<img src="img/#qTopic.Image#" width="20px" height="20px" title="#qTopic.Description#">
															<cfelse>
																#Left(qTopic.Description,1)#
															</cfif>		
														</th>
														<cfset vNumberOfColumns++/>
														
													</cfloop>
													
													<cfloop query="qHeader">
														<cfquery name="qTopic" 
															datasource="martStaffing">		 
																SELECT *
																FROM stLabel 
																WHERE Topic = '#qHeader.ColumnName#'
														</cfquery>										
														<th style="text-align:center; display:none;" class="clsPercentage">
															<cfif qTopic.Image neq "">
																<img src="img/#qTopic.Image#" width="20px" height="20px" title="#qTopic.Description#">
															<cfelse>
																#Left(qTopic.Description,1)#
															</cfif>		
														</th>
														<cfset vNumberOfColumns++/>
														
													</cfloop>
												
													<th style="text-align:center;">Total</th>
													<cfset vNumberOfColumns++/>
													
												</cfloop>	
												
												<cfif getParams.LoggedIn eq "1">
													<th style="text-align:center;">Target met?</th>	
													<th style="text-align:center;">Trend</th>
													<th style="text-align:center;">Under represented gender</th>
													
													<cfloop index = "i" from = 0 to = 4> 
														<th style="text-align:center;">#DateFormat(URL.date,"YYYY")+i#</th>
													</cfloop>									
												</cfif>

											</tr>
											
										</thead>
										<tbody>
			
											<cfset cntRow = 1>
											<cfset vTransactionsTotal = 0>
											<cfset vGrandTotal = 0>
											<cfset vFemaleTotal = 0>
											<cfset vMaleTotal = 0>
											
											<cfset isTarget = 0>
											<cfset vTotal = 0>
											
											<cfloop query="getData">
																				
												<cfquery name="qCheck" 
													datasource="HubEnterprise">		 
														SELECT *
														FROM   NOVA.dbo.ProgramTarget 
														WHERE  Department = '#URL.Mission#'
															
														<!----rfuentes We DO HAVE post in G3 but contract in G4 and above, so here it was only showing G4 and above, 
														but filter was applied to PostGrade, it was only GRADECONTRACT not OR---->
														<cfif URL.field eq "GradeContract" OR URL.field eq "PositionGrade">
														AND    PersonGrade = '#CategoryDescription#' 
														<cfelse>
														AND    1 = 0 	
														</cfif>	
														AND    Year = '#DateFormat(vDate,"YYYY")#'
														AND    Topic = 'F'
												</cfquery>	
																								
												<cfif qCheck.recordcount neq 0>
												
													 <tr>
														<td style="text-transform:capitalize;text-align:center;">														
															#ucase(CategoryDescription)# 
														</td>
														
														<cfset vTargetPercentageF = "0">
														
														<cfloop query="qPeriod">
															
															<cfif SelectionDate eq vDate>
																<cfset vTargetPercentageF_Previous = vTargetPercentageF>
															</cfif>	
																										
															<cfset QueryAddRow(genderTable)>											
															<cfset vTargetPercentage = "">
															<cfset vTargetPercentageF = "0">
															<cfset vTotalRow = 0>
															<cfset vFemale = 0>
															<cfset includeRow ="0">
															<!---for percentages we need to know first the totals ---->
															<cfset vTotalPerc	="0">
															
															<cfloop query="qHeader">
																<cfset URL.Date = qPeriod.SelectionDate>
																<cfinclude template="getDataDetails.cfm">
																<cfif qHeaderValue.total neq "">
																	<cfset vTotalPerc = vTotalPerc + qHeaderValue.total>
																</cfif>	
															</cfloop>	
															<cfif vTotalPerc eq 0> <cfset vTotalPerc	="1"> </cfif>
															
															<cfloop query="qHeader">
					
																<cfset URL.Date = qPeriod.SelectionDate>
																
																<cfinclude template="getDataDetails.cfm">
																	
																<cfif qHeaderValue.total neq "">
																	<cfset vTotalRow = vTotalRow + qHeaderValue.total>
																</cfif>	
																 												
																<td align="right" class="clsQuantity">
																	<cfif isDefined("session.authent")>
																		<cfif session.authent eq 1>
																			<a onclick="showdrilldown('DrillDown.cfm','#URL.source#','#URL.Mission#','#url.Division#','#url.column#','#qHeader.ColumnName#','#URL.field#','#getData.CategoryDescription#','#URL.Date#','#url.Category#','#URL.Seconded#','#URL.Level#','#URL.Condition#','#URL.PersonGrade#')">#qHeaderValue.total#</a>
																		<cfelse>
																			#qHeaderValue.total#
																		</cfif>	
																	<cfelse>
																		#qHeaderValue.total# 
																	</cfif>	
																</td>
																
																<cfif qHeaderValue.recordcount neq 0>
																	<cfset Temp = QuerySetCell(genderTable,Left(qHeader.ColumnName,4), qHeaderValue.total)>
																<cfelse>
																	<cfset Temp = QuerySetCell(genderTable,Left(qHeader.ColumnName,4), "0")> <!---add with zero value, as it mus be reflected in the rows ----->
																</cfif>
																<cfif qHeader.ColumnName eq "F">
																	<cfif qHeaderValue.recordCount gte 1>
																		<cfset vFemale =  qHeaderValue.total>
																	<cfelse>
																		<cfset vFemale =  "0">
																	</cfif>
																	
																	<cfset vTargetPercentageF = (vFemale/vTotalPerc)>
																</cfif>		
																<cfif qHeaderValue.recordCount gte 1>
																	<cfset vTargetPercentageF = (qHeaderValue.total/vTotalPerc)*100>
																<cfelse>
																	<cfset vTargetPercentageF = "0">
																</cfif>
																
																
																<!---moved from the out of the loop to inside the loop, as it was taking when M is null, nothing added, but then the whole row was not added ----->
																<cftry>	
																<td align="right" style="display:none;" class="clsPercentage">#numberformat(vTargetPercentageF,'._')#%</td>
																	 <!--- 
																	 <cfif getData.CategoryDescription eq "G-3" > 
																		<cfoutput> {#GetData.CategoryDescription#:#qHeader.ColumnName# - #qHeaderValue.Total#}/#includeRow# </cfoutput> 
																	 </cfif> 
																	---->
																	<cfif qHeaderValue.Description neq "" > <!---- if F = 0, which is leading, then the whole Category is not added/shown, must do differently------->
																		<cfset Temp = QuerySetCell(genderTable, "p#Left(qHeaderValue.Description,4)#", vTargetPercentageF)>
																		<cfset Temp = QuerySetCell(genderTable, "Description", ucase(GetData.CategoryDescription))>
																		<cfset Temp = QuerySetCell(genderTable, "CategoryOrder", getData.CategoryOrder)>
																		<cfset Temp = QuerySetCell(genderTable, "ClosingDate", qPeriod.SelectionDate)>
																	</cfif>	
																<cfcatch>
																	#cfcatch.message#
																</cfcatch>		
																</cftry>	
																
															</cfloop>														
															
															<cfif vFemale neq "" and vTotalRow neq "">
																<cfset vTargetPercentageF = (vTargetPercentageF * 10)>
															</cfif>	
																
															<td align="right" style="display:none;" class="clsPercentage" > <b> #numberformat(vTotalPerc,',')# </b> </td>
																
															<td align="right" style="color:##4D4D4D; font-size:100%;" class="clsQuantity">
																<b>#vTotalRow#</b>
															</td>
																
														</cfloop>
														
														<cfif getParams.LoggedIn eq "1">
															<cfif (qCheck.Target lt 55 and vTargetPercentageF gte qCheck.Target) or (qCheck.Target gte 55 and vTargetPercentageF lte qCheck.Target)>
																<cfset OnTarget  = 1>
															<cfelse>
																<cfset OnTarget  = 0>
															</cfif>	
															
															<td align="center" style='background-color:<cfif OnTarget eq 1>##d9ffcc<cfelse>##ffe6e6</cfif>'>
																<cfif OnTarget eq 1>Yes<cfelse>No</cfif>
															</td>	
															<td align="center">
																<cftry>
																	<cfif vTargetPercentageF_Previous eq vTargetPercentageF>
																		Same status
																	<cfelseif  qCheck.Target-vTargetPercentageF_Previous gt qCheck.Target-vTargetPercentageF>
																		Progress towards targets
																	<cfelse>
																		Distancing from targets		
																	</cfif>
																<cfcatch>
																</cfcatch>		
																</cftry>		 											
															</td>
															<td align="center">
																<cfif vTargetPercentageF lt 50>
																	Female
																<cfelseif vTargetPercentageF gt 50>
																	Male	
																</cfif>	
															</td>
														</cfif>
														
																												
														<!---- targets --->
														
														<cfif getParams.LoggedIn eq "1">
																												
															<cfloop index = "i" from = 0 to = 4> 
			
																<cfquery name="qTarget" 
																	datasource="HubEnterprise">		 
																		SELECT *
																		FROM NOVA.dbo.ProgramTarget 
																		WHERE Department = '#URL.Mission#'
																		AND Year = '#DateFormat(vDate,"YYYY")+i#'
																		<!----rfuentes We DO HAVE post in G3 but contract in G4 and above, so here it was only showing G4 and above, 
																			but filter was applied to PostGrade, it was only GRADECONTRACT not OR---->
																		<cfif URL.field eq "GradeContract" OR URL.field eq "PositionGrade">
																			AND PersonGrade = '#CategoryDescription#'
																		<cfelse>
																			AND 1 = 0 	
																		</cfif>	
																		AND Topic = 'F'
																</cfquery>	
																
																<td>#qTarget.Target#</td>
															
															</cfloop>		
																																					
														</cfif>																			
													</tr>
													<cfset cntRow = cntRow + 1>
												<cfelse>
													<td align="center" style='background-color:##d9ffff'>Undef. Targ (#CategoryDescription#)</td>
												</cfif>
												
											</cfloop>
			
											<tr>
												<td style="background-color:##E8E8E8;"><cf_tl id="Total"></td>
												
												<cfloop query="qPeriod">
													<cfset vTotal = 0>
													<cfloop query="qHeader">
													
														<cfquery name="qTotal" dbtype="query">
															SELECT sum(#Left(qHeader.ColumnName,4)#) as Total
															FROM   genderTable
															WHERE  ClosingDate = '#qPeriod.SelectionDate#'
														</cfquery>

														<td align="right" class="clsQuantity">#NumberFormat(qTotal.Total,",")#</td>
														<cfif qTotal.Total neq "">
															<cfset vTotal = vTotal + qTotal.Total>
														</cfif>	
															 
													</cfloop>
													<td class="clsPercentage" style="display:none;"></td>
													<td class="clsPercentage" style="display:none;"></td>
													<td align="right"><b>#vTotal#</b></td>
												</cfloop>	
												
											</tr>
											
										</tbody>
									</table>
									
									<cfif URL.mode eq "Target" AND getParams.LoggedIn eq "1">
										<table style="width:100%;" cellpadding="1" cellspacing="1">
												<tr>
													<td align="right" style="background-color:##d9ffcc;width:5%;">
														&nbsp;
													</td>
													<td style="padding-left:10px;">On target</td>
												</tr>	
												
												<tr>
													<td align="right" style="background-color:##ffe6e6"></td>
													<td style="padding-left:10px;">Below target</td>
												</tr>	
												<tr>
													<td></td>
													<td style="padding-left:10px;">
														Targets are measured by department by grade, excluding seconded officers and staff on temporary appointments
													</td>
												</tr>	
										</table>
									</cfif>	
									
								</cfoutput>
								</td>
							</tr>
						</table>

				</cfsavecontent>

				<cfsavecontent variable="dGraph" >
				
					<cfif URL.column eq "Gender">
						
						<cftry>
							<cfquery name="qMales" dbtype="query" >
								SELECT   Description, pM as Total
								FROM     genderTable
								ORDER BY CategoryOrder
							</cfquery>
						<cfcatch>
							<cfquery name="qMales" dbtype="query" >
								SELECT   Description, 0 as Total
								FROM     genderTable
								ORDER BY CategoryOrder
							</cfquery>
						</cfcatch>		
						</cftry>		 
						
						<cftry>
							<cfquery name="qFemales" dbtype="query" >
								SELECT Description, pF as Total
								FROM genderTable
								ORDER BY CategoryOrder
							</cfquery>
						<cfcatch>
							<cfquery name="qFemales" dbtype="query" >
								SELECT   Description, 0 as Total
								FROM     genderTable
								ORDER BY CategoryOrder
							</cfquery>
						</cfcatch>		
						</cftry>							
						
						<cfset vSeriesArray = ArrayNew(1)>
						
						<cfset vSeries = StructNew()>
						<cfset vSeries.color = "rgba(#qColorMale.R#,#qColorMale.G#,#qColorMale.B#,0.7)">
						<cfset vSeries.name = "Male">
						<cfset vSeries.label = "Male">
						<cfset vSeries.query = "#qMales#">
						<cfset vSeries.label = "Description">
						<cfset vSeries.value = "Total">
						<cfset vSeriesArray[2] = vSeries>
	
						
						<cfset vSeries = StructNew()>
						<cfset vSeries.color = "rgba(#qColorFemale.R#,#qColorFemale.G#,#qColorFemale.B#,0.7)">
						<cfset vSeries.name = "Female">
						<cfset vSeries.label = "Female">
						<cfset vSeries.query = "#qFemales#">
						<cfset vSeries.label = "Description">
						<cfset vSeries.value = "Total">
						<cfset vSeriesArray[1] = vSeries>
						
					<cfelse>
					
						<cftry>
							<cfquery name="qPM" dbtype="query" >
								SELECT Description, pPM as Total
								FROM genderTable
								ORDER BY CategoryOrder
							</cfquery>
						<cfcatch>
							<cfquery name="qPM" dbtype="query" >
								SELECT Description, 0 as Total
								FROM genderTable
								ORDER BY CategoryOrder
							</cfquery>
						</cfcatch>		
						</cftry>									 
						
						<cftry>
							<cfquery name="qTA" dbtype="query" >
								SELECT Description, pTA as Total
								FROM genderTable
								ORDER BY CategoryOrder
							</cfquery>			
						<cfcatch>
							<cfquery name="qTA" dbtype="query" >
								SELECT Description, 0 as Total
								FROM genderTable
								ORDER BY CategoryOrder
							</cfquery>			
						</cfcatch>		
						</cftry>													
						
						<cfset vSeriesArray = ArrayNew(1)>
						
						<cfset vSeries = StructNew()>
						<cfset vSeries.color = "rgba(#qColorPM.R#,#qColorPM.G#,#qColorPM.B#,0.7)">
						<cfset vSeries.name = "#qColorPM.Description#">
						<cfset vSeries.label = "#qColorPM.Description#">
						<cfset vSeries.query = "#qPM#">
						<cfset vSeries.label = "Description">
						<cfset vSeries.value = "Total">
						<cfset vSeriesArray[2] = vSeries>
	
						
						<cfset vSeries = StructNew()>
						<cfset vSeries.color = "rgba(#qColorTA.R#,#qColorTA.G#,#qColorTA.B#,0.7)">
						<cfset vSeries.name = "#qColorTA.Description#">
						<cfset vSeries.label = "#qColorTA.Description#">
						<cfset vSeries.query = "#qTA#">
						<cfset vSeries.label = "Description">
						<cfset vSeries.value = "Total">
						<cfset vSeriesArray[1] = vSeries>
								
					</cfif>							

					<cfset vMaxScale =100>					
					
					<cfset gheight = genderTable.recordcount*60>
					
					<cf_mobileGraph
						id = "g#Trim(URL.Id)#"
						height = "#gheight#px"
						type = "horizontalBar"
						legend = "true"
						stacked = "true"
						series = "#vSeriesArray#"
						onclick = "clickElement"
						datapoints ="yes">
					</cf_mobileGraph>
					
				</cfsavecontent>				

				<cfoutput>
				<cf_mobileCell class="col-md-12">
				<cfoutput>
					<h4>
						<cfquery name="qTopicTitle" 
							datasource="martStaffing">		 
								SELECT *
								FROM stLabel 
								WHERE Topic = '#URL.title#'
						</cfquery>							
						<cfif qTopicTitle.recordcount eq 0>
							#URL.title#
						<cfelse>
							#qTopicTitle.Description#	
						</cfif>		
					</h4>
				</cfoutput>
				</cf_mobileCell>
					
				<cfswitch expression="#URL.content#">
					<cfcase value="details">
					
						<cf_mobilerow>
						
							<cfset width = 6>
							<cf_mobileCell class="col-md-6 table-responsive">
								#dTable#
							</cf_mobileCell>
											
							<cf_mobileCell class="col-md-#width#">
								#dGraph#
							</cf_mobileCell>
							
						</cf_mobilerow>
	
					</cfcase>	
					<cfcase value="table">
						<cf_mobilerow>
							<cf_mobileCell class="col-md-12 table-responsive">
								#dTable#
							</cf_mobileCell>
						</cf_mobilerow>	
					</cfcase>	
					<cfcase value="graph">
						<cf_mobilerow>
							<cfset width = 12>
							<cf_mobileCell class="col-md-#width#">
								#dGraph#
							</cf_mobileCell>
						</cf_mobilerow>		
					</cfcase>						
					<cfcase value="split">
						<cfset width = 12>
						<cf_mobilerow>
							<cf_mobileCell class="col-md-#width#">
								#dTable#
							</cf_mobileCell>
						</cf_mobilerow>
						<cf_mobilerow>
							<cf_mobileCell class="col-md-#width#">
								#dGraph#
							</cf_mobileCell>
						</cf_mobilerow>		
								
					</cfcase>		
					
				</cfswitch>
				</cfoutput>				
			
		</cf_MobilePanel>	

<!-----
<cfelse>
	<tr><td align="center"> <h4> No data found to meet your criteria</h4> </td> </tr>
	---->

</cfif>