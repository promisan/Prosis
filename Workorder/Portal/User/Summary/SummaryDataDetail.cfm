<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.transtype"            default="all">
<cfparam name="url.yearstart"            default="#year(now())#">

<cfset StartDate  = CreateDate(url.yearstart,1,1)>
<cfset startyear  = Year(StartDate)>
<cfset startmonth = Month(StartDate)>
<cfset curyear    = Year(StartDate)>

<cfif startyear eq year(now())>
	<cfset curmonth   = Month(Now())>
<cfelse>
	<cfset curmonth   = "12">
</cfif>


<cfquery name="getUsageLabel"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 						  
	  SELECT   TOP 1 ISNULL(LabelCurrency,'$') as LabelCurrency				
	  FROM     ServiceItemUnit L INNER JOIN
			   Ref_UnitClass C ON L.UnitClass = C.Code	
	  WHERE ServiceItem IN (
	  		SELECT Code 
			FROM ServiceItem 
			WHERE Operational = 1)
	<cfif url.ServiceItem neq "">			    	  	  
	  AND    ServiceItem = '#url.ServiceItem#'			
	</cfif>
</cfquery>	

<table width="100%" cellspacing="1" cellpadding="0" align="center">	
	
	<tr>
		<td colspan="2">
			
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
									
				<tr><td style="padding:0px" id="summarychart">
				
				   <!--- filter on service --->
				
				   <table width="100%" cellspacing="2" cellpadding="0" border="0">
				   
				    <tr>
					   <td align="center" valign="top" width="49%">
					   
					   									
							<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table" navigationhover="##c4e1ff" navigationselected="##cccccc">
								<tr>
									<td colspan="4" >										
											<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
												<tr>
													<td class="labellarge"  bgcolor="e2f0ff"  align="center"><b>Top 5 Calls</b></td>
												</tr>
											</table>
											
									</td>
								</tr>

								<tr>
									<td align="center" colspan="4" height="5"></td>
								</tr>								

								<tr>									
									<td width="25%" class="labelit" style="padding-left:20px" align="left"><b>Number</b></td>
									<td width="34%" class="labelit" align="left"><b>Destination</b></td>
									<td width="20%" class="labelit" align="right"><b>Calls</b></td>									
								</tr>
								
								<tr>
									<td align="center" colspan="4" height="2"></td>
								</tr>
									
									<cfset firstmonth = startmonth>
									<cfset lastmonth = curmonth>
									
									<cfloop index="mt" from="#firstmonth#" to="#lastmonth#">
	
 										<cfset sdate = createDate (startyear,mt,1)>
										<cfset edate = createDate (startyear,mt,DaysInMonth(sdate))>
																				
										<cfquery name="getdata" 
											datasource="AppsWorkOrder" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">						
											
											SELECT TOP 5 A. Reference,Destination, COUNT(1) AS CallCount
											FROM (
												SELECT D.Reference,
														(SELECT TopicValue 
															FROM WorkOrderLineDetailTopic T 
															WHERE D.TransactionId = T.TransactionId  
															<!---T.Topic = 'T031'--->
															AND T.Topic = (SELECT UsageTopicDetail FROM ServiceItem WHERE Code = D.ServiceItem)
															) as Destination
												
												FROM  WorkOrderLineDetail D
													  INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
												WHERE L.PersonNo = '#client.personNo#'
												AND   D.ServiceItem IN (SELECT Code FROM ServiceItem WHERE SelfService=1)
												
												<cfif url.ServiceItem neq "">
													AND D.ServiceItem = '#url.serviceitem#'
												</cfif>												
												
												AND D.Reference IS NOT NULL
												AND D.Reference <> ''
												AND D.Reference <> '0'
												AND	D.ActionStatus != '9'
												AND D.TransactionDate >= #sdate#
												AND D.TransactionDate <= #edate#
												AND NOT Exists (SELECT TopicValue 
															FROM WorkOrderLineDetailTopic T 
															WHERE D.TransactionId = T.TransactionId 
															<!---AND T.Topic = 'T034' --->
															AND T.Topic = (SELECT UsageTopicGroup FROM ServiceItem WHERE Code = D.ServiceItem)
															AND T.TopicValue = 'incoming')
															
												<cfif url.transtype neq "all">

														AND EXISTS (											
															SELECT *
															FROM dbo.WorkOrderLineDetailCharge C
															WHERE C.WorkorderId = D.Workorderid
															AND C.WorkorderLine = D.WorkorderLine
															AND C.ServiceItem = D.ServiceItem
															AND C.ServiceItemUnit = D.ServiceItemUnit
															AND C.Reference = D.Reference
															AND C.TransactionDate = D.TransactionDate
													<cfif url.transtype eq "personal">													
															AND C.Charged='2')
													<cfelse>
															AND C.Charged='1')
													</cfif>
													
												</cfif>

												<cfif url.transtype eq "all">
													<!--- if the Call type is All include the Non-billable usage--->
													UNION ALL
												
													SELECT D.Reference,
															(SELECT TopicValue 
															 FROM WorkOrderLineDetailTopicNonBillable T 
															 WHERE D.TransactionId = T.TransactionId 
															 <!---AND T.Topic = 'T031'--->
															 AND T.Topic = (SELECT UsageTopicDetail FROM ServiceItem WHERE Code = D.ServiceItem)
															 ) as Destination
													FROM WorkOrderLineDetailNonBillable D
														INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
													WHERE L.PersonNo = '#client.personNo#'
													AND D.ServiceItem IN (SELECT Code FROM ServiceItem WHERE SelfService=1)
													
													<cfif url.ServiceItem neq "">
														AND D.ServiceItem = '#url.serviceitem#'
													</cfif>						
																			
													AND D.Reference IS NOT NULL												
													AND D.Reference <> ''
													AND D.TransactionDate >= #sdate#
													AND D.TransactionDate <= #edate#
													AND NOT Exists (SELECT TopicValue 
																FROM WorkOrderLineDetailTopicNonBillable T 
																WHERE D.TransactionId = T.TransactionId 
																<!---AND T.Topic = 'T034' --->
																AND T.Topic = (SELECT UsageTopicGroup FROM ServiceItem WHERE Code = D.ServiceItem)
																AND T.TopicValue = 'incoming')
												
												</cfif>
												) AS A
											GROUP BY A.Reference, A.Destination
											ORDER BY 3 desc
							
										</cfquery>

									
										<cfif getdata.recordcount gt "0">
											<cfoutput>
											<tr>
												<td colspan="3" height="10" ></td>
											</tr>											
											<tr>
												<td colspan="4" align="Left" style="padding-left:10px;border-bottom: 1px solid silver" class="labelmedium">#DateFormat(sdate,"mmmm yyyy")#</b></font></td>
											</tr>
											</cfoutput>
										</cfif>
										
										<cfset cnt = "0">
										<cfoutput query="getdata">
										<cfset cnt = cnt+1>
											<tr class="navigation_row" bgcolor="<cfif cnt mod 2 eq 0>fafafa</cfif>">
												
												<td class="labelit" style="padding-left:20px" style="break-word:break-all;padding-left:2px;padding-right:2px">#Reference#</td>	
												<td class="labelit" style="break-word:break-all;padding-left:2px;padding-right:2px">#Destination#</td>
												<td class="labelit" align="right">#CallCount#</td>												
												
											</tr>										
										</cfoutput>
									</cfloop>
																	
							</table>
							
					   </td>
					   <td width="2%"></td>		   
					   <td align="center" valign="top" width="49%">
					   					   
					   		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table" navigationhover="##c4e1ff" navigationselected="##cccccc">		
												
								<tr>
									<td colspan="4" class="labellarge"  bgcolor="e2f0ff">
																			
											<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
												<tr>
													<td class="labellarge" align="center"><b>Top 5 Destinations</b></td>
												</tr>
											</table>
									
									</td>
								</tr>

								<tr>
									<td align="center" colspan="4" height="2"></td>
								</tr>								
								<tr>
									<td width="25%"></td>
									<td width="45%" align="left" class="labelit"><b>Destination</b></td>
									<td width="25%" align="right" class="labelit"><b>Calls</b></td>									
								</tr>
								
								<tr>
									<td align="center" colspan="4" height="5"></td>
								</tr>	
									
									<cfloop index="mt" from="#firstmonth#" to="#lastmonth#">
																			
 										<cfset sdate = createDate (startyear,mt,1)>
										<cfset edate = createDate (startyear,mt,DaysInMonth(sdate))>
 
										<cfquery name="getLocations" 
											datasource="AppsWorkOrder" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">						
											
											SELECT TOP 5 Destination, COUNT(1) AS CallCount
											FROM (
												SELECT 
														(SELECT TopicValue 
															From WorkOrderLineDetailTopic T 
															WHERE D.TransactionId = T.TransactionId 
															<!---AND T.Topic = 'T031'--->
															AND T.Topic = (SELECT UsageTopicDetail FROM ServiceItem WHERE Code = D.ServiceItem)
															) as Destination

												FROM WorkOrderLineDetail D
													INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
												WHERE L.PersonNo = '#client.personNo#'
												
												<cfif url.ServiceItem neq "">
													AND D.ServiceItem = '#url.serviceitem#'
												</cfif>
												
												AND D.Reference IS NOT NULL
												AND D.Reference <> ''
												AND D.Reference <> '0'
												AND	D.ActionStatus != '9'
												AND D.TransactionDate >= #sdate#
												AND D.TransactionDate <= #edate#
												AND NOT Exists (SELECT TopicValue 
															FROM WorkOrderLineDetailTopic T 
															WHERE D.TransactionId = T.TransactionId 
															<!---AND T.Topic = 'T034' --->
															AND T.Topic = (SELECT UsageTopicGroup FROM ServiceItem WHERE Code = D.ServiceItem)
															AND T.TopicValue = 'incoming')
												
												<cfif url.transtype neq "all">

														AND EXISTS (											
															SELECT *
															FROM dbo.WorkOrderLineDetailCharge C
															WHERE C.WorkorderId = D.Workorderid
															AND C.WorkorderLine = D.WorkorderLine
															AND C.ServiceItem = D.ServiceItem
															AND C.ServiceItemUnit = D.ServiceItemUnit
															AND C.Reference = D.Reference
															AND C.TransactionDate = D.TransactionDate
													<cfif url.transtype eq "personal">													
															AND C.Charged='2')
													<cfelse>
															AND C.Charged='1')
													</cfif>
																										
												</cfif>												

												<cfif url.transtype eq "all">
													<!--- if the Call type is All include the Non-billable usage--->												
													UNION ALL
												
													SELECT 
															(SELECT TopicValue 
																From WorkOrderLineDetailTopicNonBillable T 
																WHERE D.TransactionId = T.TransactionId 
																<!---AND T.Topic = 'T031'--->
																AND T.Topic = (SELECT UsageTopicDetail FROM ServiceItem WHERE Code = D.ServiceItem)
																) as Destination
													
													FROM WorkOrderLineDetailNonBillable D
														INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
													WHERE  L.PersonNo = '#client.personNo#'
													
													<cfif url.ServiceItem neq "">
														AND D.ServiceItem = '#url.serviceitem#'
													</cfif>
													
													AND D.Reference IS NOT NULL
													AND D.Reference <> ''
													AND D.Reference <> '0'
													AND D.TransactionDate >= #sdate#
													AND D.TransactionDate <= #edate#
													AND NOT Exists (SELECT TopicValue 
																FROM WorkOrderLineDetailTopicNonBillable T 
																WHERE D.TransactionId = T.TransactionId 
																<!---AND T.Topic = 'T034' --->
																AND T.Topic = (SELECT UsageTopicGroup FROM ServiceItem WHERE Code = D.ServiceItem)
																AND T.TopicValue = 'incoming')
												
												</cfif>
												) AS A
											WHERE A.Destination <> ''
											GROUP BY A.Destination
											ORDER BY 2 desc											
										</cfquery>
										
										<cfif getLocations.recordcount gt "0">
											<cfoutput>
											<tr>
												<td colspan="3" height="10" ></td>
											</tr>												
											<tr>
											<td colspan="5" align="left" style="padding-left:10px;border-bottom: 1px solid silver" class="labelmedium">#DateFormat(sdate,"mmmm yyyy")#</b></td>
											</tr>
											</cfoutput>
										</cfif>
										<cfset cnt = "0">										
										<cfoutput query="getLocations">
										<cfset cnt = cnt+1>
											<tr class="navigation_row" bgcolor="<cfif cnt mod 2 eq 0>fafafa</cfif>">
												<td></td>
												<td align="left" class="labelit">#Destination#</td>	
												<td align="right" class="labelit">#CallCount#</td>																								
											</tr>										
										</cfoutput>
										
									</cfloop>
																	
							</table>
							
					   </td>					   
				    </tr>

    				</table>		
			
				</td></tr>			
			
				<tr><td style="padding-top:1px; padding-top:4px" >				
										
					<table width="98%" cellspacing="0" cellpadding="0" align="center" class="navigation_table" navigationhover="##c4e1ff" navigationselected="##cccccc">
						<tr><td colspan="6" height="15px" ></td></tr>
				    	<tr><td colspan="6" height="18px" class="labellarge">
							<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
								<tr>
									<td class="labellarge"  bgcolor="e2f0ff" align="center"><b>Most Expensive Calls</b></td>
								</tr>
							</table>													

						</td></tr>
						
						<tr><td height="5" colspan="6"></td></tr>
						<tr>
							<cfoutput>
							<td style="padding-left:30px" class="labelit" height="18"><b>Date</b></td>
							<td class="labelit"><b>Number</b></td>
							<td class="labelit"><b>Destination</b></td>
							<td class="labelit" align="right"><b>Rate (#getUsageLabel.LabelCurrency#)</b></td>
							<td class="labelit" align="right"><b>Minutes</b></td>
							<td class="labelit" align="right"><b>Amount (#getUsageLabel.LabelCurrency#)</b></td>
							</cfoutput>
						</tr>
						
						<tr><td height="5" colspan="6"></td></tr>
									
						<cfloop index="mt" from="#firstmonth#" to="#lastmonth#">
																		
 								<cfset sdate = createDate (startyear,mt,1)>
								<cfset edate = createDate (startyear,mt,DaysInMonth(sdate))>									
			
									<cfquery name="getMostExpensive" 
										datasource="AppsWorkOrder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">						
										
										SELECT TOP 5 D.TransactionDate,
												D.Reference,
												(SELECT TopicValue 
													FROM WorkOrderLineDetailTopic T 
													WHERE D.TransactionId = T.TransactionId 
													<!---AND T.Topic = 'T031'--->
													AND T.Topic = (SELECT UsageTopicDetail FROM ServiceItem WHERE Code = '#url.serviceitem#')
													) as Destination,
												D.Rate,
												D.Quantity,
												D.Amount
										
										FROM WorkOrderLineDetail D
											INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
										WHERE L.PersonNo = '#client.personNo#'
										
										<cfif url.ServiceItem neq "">
											AND D.ServiceItem = '#url.serviceitem#'
										</cfif>
												
										AND D.Reference IS NOT NULL
										AND D.Reference <> ''
										AND D.Reference <> '0'
										AND	D.ActionStatus != '9'
										AND D.TransactionDate >= #sdate#
										AND D.TransactionDate <= #edate#
										AND D.ServiceItem IN (
											SELECT Code FROM ServiceItem 
											WHERE Operational=1
											AND SelfService=1)
										
										<cfif url.transtype neq "all">

												AND EXISTS (											
													SELECT *
													FROM dbo.WorkOrderLineDetailCharge C
													WHERE C.WorkorderId = D.Workorderid
													AND C.WorkorderLine = D.WorkorderLine
													AND C.ServiceItem = D.ServiceItem
													AND C.ServiceItemUnit = D.ServiceItemUnit
													AND C.Reference = D.Reference
													AND C.TransactionDate = D.TransactionDate
											<cfif url.transtype eq "personal">													
													AND C.Charged='2')
											<cfelse>
													AND C.Charged='1')
											</cfif>
																								
										</cfif>
																				
										ORDER BY D.Amount Desc
									</cfquery>
									
					
									<cfif getMostExpensive.recordcount gt "0">
										<cfoutput>
										<tr>
											<td colspan="6" height="10" ></td>
										</tr>											
										<tr>
											<td colspan="6" align="Left" class="labelmedium" style="padding-left:10px;border-bottom: 1px solid silver">#DateFormat(sdate,"mmmm yyyy")#</td>
										</tr>
										</cfoutput>
									</cfif>
											
									<cfset cnt = "0">		
									<cfoutput query="getMostExpensive">																		
										<tr class="navigation_row" <cfif cnt mod 2 eq 0>bgcolor="##fafafa"</cfif>>
											<cfset cnt = cnt+1>
											<td class="labelit" style="padding-left:30px">#DateFormat(TransactionDate,"dd/mm/yyyy")#</font></td>
											<td class="labelit">#Reference#</td>
											<td class="labelit">#Destination#</td>
											<td align="right" class="labelit">#numberformat(rate,"__,__.__")#</td>
											<td align="right" class="labelit">#numberformat(Quantity,",")#</td>
											<td align="right" class="labelit">#numberformat(amount,"__,__.__")#</td>
										</tr>									
									</cfoutput>
																			
								</cfloop>
								
					</table>
					
				</td></tr>			
			</table>			
		</td>	
	</tr>		
	
	<tr><td height="20"></td></tr>
</table>	

<cfset ajaxOnLoad("doHighlight")>
