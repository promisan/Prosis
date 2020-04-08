<cfparam name="url.name"     	default="url.field">
<cfparam name="url.field"    	default="gender">
<cfparam name="url.order"    	default="gender">
<cfparam name="url.orderType"   default="VarChar">
<cfparam name="url.Division" 	default="">
<cfparam name="url.Id"       	default="#url.field#">
<cfparam name="url.Column"   	default="gender">
<cfparam name="url.mode"     	default="">
<cfparam name="url.content"  	default="details">
<cfparam name="url.total"    	default="yes">
<cfparam name="url.cntTotalTimes" 	default= "1">
<cfparam name="url.cntThisTime"	 	default= "1">
<cfparam name="url.contentResults"	default= "0">


<!--- URL content  - three possible values -   
		details: prints all data
		table :only table
		graph :only graph
		split : one thing above, and one below
---> 

<cfparam name="url.occgroup"    default="">
<cfparam name="url.condition"   default="">
<cfparam name="url.personGrade" default="">

<cfparam name="url.source"      default="Gender">
<cfparam name="url.countoption" default="1">
<cfparam name="url.category"    default="">

<cfif isDefined("session.acc") AND TRIM(Session.acc) neq "">
	<cfset url.showDetail	= "1">
	<cfelse>
	<cfset url.showDetail	= "0">
</cfif>

<cfset url.debug ="no">

<cfinclude template="getData.cfm">

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
	
	<cfif URL.column eq "Gender">
		
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
			
	<cfelse>
		
		<cfquery name="qColorPM" 
			datasource="martStaffing">		 
				SELECT *
				FROM  stLabel 
				WHERE Topic = 'PM'
		</cfquery>
	
		<cfquery name="qColorTA" 
			datasource="martStaffing">		 
				SELECT *
				FROM  stLabel 
				WHERE Topic = 'TA'
		</cfquery>	
		
	</cfif>		
	
		<cf_MobilePanel 
			bodyClass = "h-200"
			bodyStyle = "font-size:80%;"
			panelClass = "stats hgreen">

				<cfif url.source eq "Gender">
				
					<cfquery name="qHeader" 
						datasource="martStaffing">		 
							SELECT DISTINCT #url.column# as ColumnName 
							FROM    Gender
							#PreserveSingleQuotes(vCondition)# 
					</cfquery>
					
				<cfelseif source eq "Recruitment">
								
					<cfquery name="qHeader" 
						datasource="martStaffing">		 
							SELECT DISTINCT #url.column# as ColumnName 
							FROM Recruitment
							#PreserveSingleQuotes(vCondition)# 
							AND #url.column#!=''
					</cfquery>		
					
				<cfelse>
				
					<cfquery name="qHeader" 
						datasource="martStaffing">		 
							SELECT DISTINCT #url.column# as ColumnName 
							FROM Recruitment S INNER JOIN RecruitmentStage R ON S.SelectionDate = R.SelectionDate AND S.Recordid = R.RecordId					
							#PreserveSingleQuotes(vCondition)# 
							AND #url.column#!=''
					</cfquery>		
					
												
				</cfif>	
				
				<cfset vAdded = "Description, CategoryOrder">
				<cfset vAddedType = "VarChar, #url.orderType#">
				
				<cfloop query="qHeader">
					<cfset vAdded = "#vAdded#,#Left(qHeader.ColumnName,4)#">	
					<cfset vAddedType = "#vAddedType#,Integer">
				</cfloop>
				
				<cfloop query="qHeader">
					<cfset vAdded = "#vAdded#,p#Left(qHeader.ColumnName,4)#">	
					<cfset vAddedType = "#vAddedType#,Integer">
				</cfloop>	
				
				<cfset genderTable = QueryNew("#vAdded#", "#vAddedType#")>				
				
				<cfsavecontent variable="dTable" >
					<cfoutput>
						<table style="width:100%;" class="table table-striped table-bordered table-hover">
							<thead>
								
								<cfset vNumberOfColumns = 0>
								<tr>
									<th style="text-align:center;" valign="middle">
													
									</th>
									
									<cfset vNumberOfColumns++/>
									
									<cfloop query="qHeader">
										<cfquery name="qTopic" 
											datasource="martStaffing">		 
												SELECT *
												FROM stLabel 
												WHERE Topic = '#qHeader.ColumnName#'
										</cfquery>	
																
										<th colspan="2" style="text-align:center; border-bottom:1px solid ##DDD;">
											<cfif qTopic.Image neq "">
												<img src="img/#qTopic.Image#" width="20px" height="20px">
											<cfelse>
												#qTopic.Description#
											</cfif>		
										</th>
										<cfset vNumberOfColumns++/>
										<cfset vNumberOfColumns++/>
										
									</cfloop>
									
									<th style="text-align:center;" valign="middle"></th>
									<cfset vNumberOfColumns++/>
									
									<cfif url.mode eq "target">
										<th style="text-align:center;" valign="middle"></th>
										
										<th style="text-align:center; border-bottom:1px solid ##DDD;" colspan="4">Parity Targets</th>
										<cfset vNumberOfColumns = vNumberOfColumns + 4>
									</cfif>	
									
								</tr>
								
								<tr>
									<th style="text-align:center;" valign="middle">
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
									
									<cfloop query="qHeader">
									
										<cfquery name="qTopic" 
											datasource="martStaffing">		 
												SELECT *
												FROM stLabel 
												WHERE Topic = '#qHeader.ColumnName#'
										</cfquery>		
																		
										<th style="text-align:center;">##</th>
										<th style="text-align:center;">%</th>
									</cfloop>	
									
									<!---
									<th></th>
									--->
									<th style="text-align:center;" valign="middle"><cf_tl id="Total"></th>
									<cfif url.mode eq "target">
									
									<th style="text-align:center;" valign="middle"><cf_tl id="Parity Progress"></th>
									
										<cfloop index = "i" from = 0 to = 3> 
											<th style="text-align:center; border-bottom:1px solid ##DDD;">#DateFormat(URL.date,"YYYY")+i#</th>
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
									
									<cfif url.mode eq "target">	
										
										<cfloop index = "i" from = 0 to = 3> 		
												
											<cfquery name="qTarget" 
												datasource="HubEnterprise">		 
													SELECT *
													FROM NOVA.dbo.ProgramTarget 
													WHERE Department = '#URL.Mission#'
													AND Year = '#DateFormat(URL.date,"YYYY")+i#'
													<cfif URL.field eq "GradeContract" OR URL.field eq "PositionGrade">
														AND PersonGrade = '#CategoryDescription#'
													<cfelse>
														AND 1 = 0 	
													</cfif>	
													AND Topic = 'F'
											</cfquery>
											
											<cfif isTarget eq 0 and qTarget.recordcount neq 0>
												<tr>
													<td colspan="#vNumberOfColumns#"></td>
												</td>	
												<cfset isTarget = 1>
											</cfif>	
											
											<cfif isTarget eq 1 and qTarget.recordcount eq 0>
												<tr>
													<td colspan="#vNumberOfColumns#"></td>
												</td>
												<cfset isTarget = 2>	
											</cfif>
											
										</cfloop>	
									</cfif>									
									
									<cfset QueryAddRow(genderTable)> 
									
									<cfset vClickElement = "">
									<cfset vClickElementStyle = "">
									<cfif url.showDetail eq "1">
										<cfset vClickElement = "clickElement('#CategoryDescription#','#url.field#','#url.division#','#url.source#');">
										<cfset vClickElementStyle = "color:##358FDE;cursor:pointer;">
									</cfif>
									
									<tr>
										<td style="font-size:85%;text-transform:capitalize;padding-left:10px;text-align:left; #vClickElementStyle#" 
										   onclick="#vClickElement#">
										#ucase(CategoryDescription)# 
										</td>
										<cfset vFPercentage ="0">
										<cfset vMPercentage ="0">
										<cfset vTargetPercentage = "">
										
										<cfloop query="qHeader">
											<cfset url.debug = "no">
											<cfinclude template="getDataDetails.cfm">
																							
											<td align="right" style="font-size:85%;"><cfif qHeaderValue.total gte 1> #qHeaderValue.total# <cfelse> 0 </cfif></td>
											<cfset Temp = QuerySetCell(genderTable,Left(qHeader.ColumnName,4), qHeaderValue.total)>

											<cfif qHeaderValue.total neq "">
												<cfset vPercentage = ROUND((qHeaderValue.total/GetData.Total)*100)>
												<cfif url.mode eq "target" and vTargetPercentage eq "">
													<cfset vTargetPercentage = vPercentage> 
												</cfif>	
												<!----round up rfuentes as per Ruy request, avoid 2 digits in NumberFormat below  ------->
												<td align="right" style="background-color:##F2F2F2;font-size:85%;"><b>#numberformat(vPercentage,',')# </b></td>
												<cfset Temp = QuerySetCell(genderTable, "p#Left(qHeaderValue.Description,4)#", #vPercentage#)>
												
												<cfif qHeaderValue.Description eq "F">
													<cfset vFPercentage = "#numberformat(vPercentage,',._')#">
												</cfif>
												<cfif qHeaderValue.Description eq "M">
													<cfset vMPercentage = "#numberformat(vPercentage,',._')#">
												</cfif>
												
											<cfelse>
												<td align="right" style="font-size:85%;">0</td>	
											</cfif>
											
										</cfloop>												
										
										<td align="right" style="color:##4D4D4D; font-size:85%;">#GetData.Total#</td>
										<cfset cnt = 1>
										
										<cfif url.mode eq "target">
										
											<!---prepare for the 1st column for Parity progress for current year ----->
												<cfquery name="qTarget" 
													datasource="HubEnterprise">		 
														SELECT *
														FROM   NOVA.dbo.ProgramTarget 
														WHERE  Department = '#URL.Mission#'
														AND    Year = '#DateFormat(URL.date,"YYYY")#'
														<cfif URL.field eq "GradeContract" OR URL.field eq "PositionGrade" >
														AND    PersonGrade = '#CategoryDescription#'
														<cfelse>
														AND    1 = 0 	
														</cfif>	
														AND    Topic = 'F'
												</cfquery>
												
												<cfif qTarget.recordcount neq 0>
													<cfset metTarget ="ffe6e6">
													<cfset valueToShow ="0">
													<cfset RPcurrentTotalCount	="#GetData.Total#">
													<cfset RPCurrentFPerc		="#vFPercentage#">
													<cfinclude template 		="RepresentationLogic.cfm">
													<cfset valueToShow			="#LabelToBeDispRep#">
													<cfset metTarget			="#ColorToBeDispRep#">
													<!----
													<cfif vFPercentage gte (qTarget.Target - qTarget.Margin ) AND vFPercentage lte (qTarget.Target + qTarget.Margin )>
															<cfset metTarget 	= "D9FFCC">
															<cfset valueToShow 	= "At Parity">
														<cfelse>
															<cfif vFPercentage LT (qTarget.Target - 3.0)>
																<cfset metTarget 	= "FFE6E6"> 
																<cfset valueToShow = "F Underrep.">
															<cfelse>
																<cfset metTarget	= "FFCC00">
																<cfset valueToShow = "M Underrep.">
															</cfif>
													</cfif>
													----->
												<cfelse>
													<cfset valueToShow 	= "Undef">
													<cfset metTarget  	= "F2F2F2">
												</cfif>
												<td align="center" style="font-size:90%; background-color:##<cfoutput>#metTarget#</cfoutput> "> #ValueToShow#</td> <!----  here goes the "Parity progress" value--->
											
											<!---finishes logic for this year ----->
											
											<cfloop index = "i" from = 0 to = 3>
												<cfquery name="qTarget" 
													datasource="HubEnterprise">		 
														SELECT *
														FROM   NOVA.dbo.ProgramTarget 
														WHERE  Department = '#URL.Mission#'
														AND    Year = '#DateFormat(URL.date,"YYYY")+i#'
														<cfif URL.field eq "GradeContract" OR URL.field eq "PositionGrade" >
														AND    PersonGrade = '#CategoryDescription#'
														<cfelse>
														AND    1 = 0 	
														</cfif>	
														AND    Topic = 'F'
												</cfquery>												
												
												<cfif qTarget.recordcount neq 0>
													<cfset valueToShow 	="#qTarget.Target#">
													<cfset metTarget 	= "F2F2F2">
												<cfelse>
													<cfset valueToShow 	= "0">
													<cfset metTarget  	= "F2F2F2">
												</cfif>
													<td align="right" style="font-size:60%; background-color:##<cfoutput>#metTarget#</cfoutput>">
														#NumberFormat(valueToShow, ",._")#+- #qTarget.Margin# %
													</td>
												<cfset cnt++>	
											</cfloop>
											
											
										<cfelse>
											<!---
											<td align="right" style="color:##4D4D4D; font-size:85%;">#NumberFormat(GetData.Total*100/qGetTotal.Total, ",._")# %..</td>
											--->												
										</cfif>	
										
										<cfset Temp = QuerySetCell(genderTable, "Description", ucase(CategoryDescription))>
										<cfset Temp = QuerySetCell(genderTable, "CategoryOrder", getData.CategoryOrder)>
										
									</tr>
									<cfset cntRow = cntRow + 1>
									<cfset vTotal = vTotal + GetData.Total>
									
								</cfloop>
								
								<cfif url.total eq "Yes">
								
									<cfset vClickElement = "">
									<cfset vClickElementStyle = "">
									<cfif url.showDetail eq "1">
										<cfset vClickElement = "clickElement('','#url.field#','#url.division#','#url.source#');">
										<cfset vClickElementStyle = "color:##358FDE;cursor:pointer;">
									</cfif>

									<tfoot>
									<tr style="background-color:##F2F2F2;">
										<th style="font-size:85%;text-transform:capitalize;padding-left:10px;text-align:left; #vClickElementStyle#" 
											onclick="#vClickElement#"><cf_tl id="Total"></th>									
										<cfloop query="qHeader">
											<cfquery name="qTotal" dbtype="query" >
												SELECT sum(#Left(qHeader.ColumnName,4)#) as Total
												FROM genderTable
											</cfquery>										
											<th style="text-align:right;">#NumberFormat(qTotal.Total,",")#</th>
											<th></th>											 
										</cfloop>
										<th style="text-align:right;">#vTotal#</th>
									</tr>
									</tfoot>
								
								</cfif>													
								
							</tbody>
						</table>
						
						<cfif URL.mode eq "Target">
							<table style="width:100%;">
									<tr>
										<td></td>
										<td>
										Targets are measured by department by grade, excluding seconded officers and staff on temporary appointments
										</td>
									</tr>	
							</table>
						</cfif>	

					</cfoutput>
					
				</cfsavecontent>

				<cfsavecontent variable="dGraph" >
				
					<cfif URL.column eq "Gender">
						
						<cftry>
							<cfquery name="qMales" dbtype="query" >
								SELECT Description, pM as Total
								FROM genderTable
								ORDER BY CategoryOrder
							</cfquery>
						<cfcatch>
							<cfquery name="qMales" dbtype="query" >
								SELECT Description, 0 as Total
								FROM genderTable
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
								SELECT Description, 0 as Total
								FROM genderTable
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
								FROM   genderTable
								ORDER BY CategoryOrder
							</cfquery>			
						<cfcatch>
							<cfquery name="qTA" dbtype="query" >
								SELECT Description, 0 as Total
								FROM   genderTable
								ORDER BY CategoryOrder
							</cfquery>			
						</cfcatch>		
						</cftry>													
						
						<cfset vSeriesArray = ArrayNew(1)>
						
						<cfset vSeries = StructNew()>
						<cfset vSeries.color   = "rgba(#qColorPM.R#,#qColorPM.G#,#qColorPM.B#,0.7)">
						<cfset vSeries.name    = "#qColorPM.Description#">
						<cfset vSeries.label   = "#qColorPM.Description#">
						<cfset vSeries.query   = "#qPM#">
						<cfset vSeries.label   = "Description">
						<cfset vSeries.value   = "Total">
						<cfset vSeriesArray[2] = vSeries>	
						
						<cfset vSeries = StructNew()>
						<cfset vSeries.color   = "rgba(#qColorTA.R#,#qColorTA.G#,#qColorTA.B#,0.7)">
						<cfset vSeries.name    = "#qColorTA.Description#">
						<cfset vSeries.label   = "#qColorTA.Description#">
						<cfset vSeries.query   = "#qTA#">
						<cfset vSeries.label   = "Description">
						<cfset vSeries.value   = "Total">
						<cfset vSeriesArray[1] = vSeries>
								
					</cfif>		 
					
					<cfset vMaxScale =100>					
					
					<cfset gheight = genderTable.recordcount*60>
					<cfif gheight lt 250>
						<cfset gheight = 250>
					</cfif>
					
					<cfset vClickElement = "">
					<cfif url.showDetail eq "1">
						<cfset vClickElement = "clickElement(e.label,'#url.field#','#url.division#','#url.source#');">
					</cfif>
					
					<cf_mobileGraph
						id = "g#Trim(URL.Id)#"
						height = "#gheight#px"
						type = "horizontalBar"
						legend = "true"
						stacked = "true"
						series = "#vSeriesArray#"
						onclick = "function(e) { #vClickElement# }"
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

</cfif>
		