
<cfquery name="domains" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_IntervalDomain 
		ORDER BY ListingOrder ASC
</cfquery>

<cfquery name="scheduleValues" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineScheduleDetail
		WHERE	ScheduleId = '#url.ScheduleId#'
</cfquery>

<table width="100%" align="center">

	<cfloop query="domains">
	
		<cfquery name="qScheduleValuesCheck" dbtype="query">
			SELECT 	*
			FROM	scheduleValues
			WHERE	IntervalDomain = '#intervalDomain#'
			AND		Operational = 1
		</cfquery>
		
		<cfset vDivStyle = "display:none;">
		<cfset vArrow = "arrow.gif">
		<cfif qScheduleValuesCheck.recordCount gt 0>
			<cfset vDivStyle = "">
			<cfset vArrow = "arrowdown.gif">
		</cfif>
		
		<cfset maxCols = 4>
		<cfset vStep = 1>
		
		<cfif lcase(intervalDomain) eq "day">
			<cfset vStep = 0.5>
		</cfif>
		
		<tr>
			<cfoutput>
				<cf_tl id="Click to show/hide the detail" var="1">
				<td class="labelit" style="height:19px; cursor:pointer;" 
					onclick="toggleIntervalDomain('#intervalDomain#');"
					title="#lt_text#">
					<img id="twistieDetail_#intervalDomain#" src="#SESSION.root#/Images/#vArrow#" align="absmiddle">
					<cf_tl id="#Description#" var="1">
					#lt_text#
				</td>
			</cfoutput>
		</tr>
		<tr><td class="line"></td></tr>
	
		<tr>
			<td style="padding-left:8px;">
				<div id="<cfoutput>divDetail_#intervalDomain#</cfoutput>" style="<cfoutput>#vDivStyle#</cfoutput>">
					<table width="100%">
					
						<cfif lcase(intervalDomain) eq "date">
							<tr>
								<td>
									<cfdiv id="divSpecificDate" bind="url:#session.root#/workorder/application/workOrder/serviceDetails/Schedule/ScheduleSpecificDate.cfm?ScheduleId=#url.ScheduleId#">
								</td>
							</tr>
							<tr><td height="10"></td></tr>
							<tr>
								<td>
								
									<cfform name="frmCalendar">
									
										<table height="200">
											<tr>
												<td valign="top" width="100" class="label" style="padding-left:5px;"><cf_tl id="Add specific date">:</td>
												<td width="100" valign="top">
												
													<cf_intelliCalendarDate9
														FieldName="specificDate_date" 
														Default="#dateformat(now(), CLIENT.DateFormatShow)#"
														AllowBlank="false">
														
												</td>
												<td style="padding-left:5px;" valign="top">
												
													<cf_tl id="You may enter a memo for this schedule" var="1">
													
													<cfinput type="Text" 
															name="memo_date" 
															id="memo_date" 
															value="" 
															size="50" 
															maxlength="100" 
															class="regular" 
															title="#lt_text#">
														
												</td>
												<td style="padding-left:5px;" valign="top">
												
													<cf_tl id="Add date" var="1">
													
													<cfoutput>
														<img src="#client.root#/images/add.png" 
															height="20" 
															name="btnDate" 
															id="btnDate" 
															title="#lt_text#" 
															style="cursor:pointer;" 
															align="absmiddle" 
															onclick="submitDateInterval('#url.ScheduleId#');">
													</cfoutput>
													
												</td>
											</tr>
										</table>
										
									</cfform>
									
								</td>
							<tr>
							
						<cfelse>
						
						<tr>
							<cfset cnt = 0>
							
							<cfloop index="p" from="#IntervalMinValue#" to="#IntervalMaxValue#" step="#vStep#">
							
								<cfset cnt = cnt + 1>
								
								<cfset pId = replace(p,".","_","ALL")>
									
								<cfquery name="qScheduleValues" dbtype="query">
									SELECT 	*
									FROM	scheduleValues
									WHERE	IntervalDomain = '#intervalDomain#'
									AND		IntervalValue  = #p#
									AND		Operational    = 1
								</cfquery>
								
								<cfset selected = 0>
								<cfif qScheduleValues.recordCount eq 1>
									<cfset selected = 1>
								</cfif>
								
								<cfset vStyle = "">
								<cfset vStyleMemo = "display:none;">
								<cfif selected eq 1>
									<cfset vStyle = "background-color:FAE4BE;">
									<cfset vStyleMemo = "display:block;">
								</cfif>
								
								<cfoutput>
									<td width="#100/maxCols#%" id="td_#intervalDomain#_#pId#" style="padding-top:2px; padding-bottom:2px; #vStyle#">			
										<table width="100%" align="center">
											<tr>
												<td width="10%">
													<input 
														type="Checkbox" 
														name="val_#intervalDomain#_#pId#" 
														id="val_#intervalDomain#_#pId#" 
														<cfif selected eq 1>checked</cfif> 
														onclick="selectSchedule('#url.ScheduleId#', '#intervalDomain#', '#p#','FAE4BE');"> 
												</td>
												<td width="25%">
													<cfset domainValue = "--" & p>
													
													<cfif lcase(intervalDomain) eq "day">
														<cfset domainValue = Int(Abs(p))>
														<cfif len(domainValue) eq 1>
															<cfset domainValue = "0" & domainValue>
														</cfif>
														
														<cfset vMinutes = "00">
														<cfif (Abs(p) - Int(Abs(p))) eq 0.5>
															<cfset vMinutes = "30">
														</cfif>
														
														<cfset domainValue = domainValue & ":" & vMinutes>
													</cfif>
													
													<cfif lcase(intervalDomain) eq "month">
														<cfset domainValue = "Day " & p>
													</cfif>
													
													<cfif lcase(intervalDomain) eq "week">
													
														<cfswitch expression="#p#">
															<cfcase value="1">
																<cf_tl id="Sunday" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="2">
																<cf_tl id="Monday" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="3">
																<cf_tl id="Tuesday" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="4">
																<cf_tl id="Wednesday" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="5">
																<cf_tl id="Thursday" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="6">
																<cf_tl id="Friday" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="7">
																<cf_tl id="Saturday" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
														</cfswitch>
														
													</cfif>
													
													<cfif lcase(intervalDomain) eq "year">
														<cfswitch expression="#p#">
															<cfcase value="1">
																<cf_tl id="January" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="2">
																<cf_tl id="February" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="3">
																<cf_tl id="March" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="4">
																<cf_tl id="April" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="5">
																<cf_tl id="May" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="6">
																<cf_tl id="June" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="7">
																<cf_tl id="July" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="8">
																<cf_tl id="August" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="9">
																<cf_tl id="September" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="10">
																<cf_tl id="October" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="11">
																<cf_tl id="November" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
															<cfcase value="12">
																<cf_tl id="December" var="1">
																<cfset domainValue = lt_text>
															</cfcase>
														</cfswitch>
													</cfif>
													
													#domainValue#
													
												</td>
												<td width="53%">
													<cf_tl id="You may enter a memo for this schedule" var="1">
													<input 
														type="Text" 
														name="memo_#intervalDomain#_#pId#" 
														id="memo_#intervalDomain#_#pId#" 
														value="#qScheduleValues.memo#" 
														size="22" 
														maxlength="100" 
														class="regular" 
														title="#lt_text#" 
														onblur="saveMemo('#url.ScheduleId#', '#intervalDomain#', '#p#');" 
														style="#vStyleMemo#">
												</td>
												<td width="12%" id="process_#intervalDomain#_#pId#" align="center">&nbsp;</td>
											</tr>
										</table>
									</td>
								</cfoutput>
								
								<cfif cnt eq maxCols>
									</tr>
									<tr>
									<cfset cnt = 0>
								</cfif>
								
							</cfloop>
						</tr>
						</cfif>
					</table>
				</div>
			</td>
		</tr>
		
		
		<tr><td height="10"></td></tr>
	</cfloop>		

</table>

<cfset ajaxOnLoad("doCalendar")>