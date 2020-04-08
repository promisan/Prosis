
<cfinclude template="SummaryPreparation.cfm">

<cfset vTemplate = "Collection/SummaryDetail.cfm">

<cfquery name="qGetFunds" 
	datasource="martStaffing">		
		SELECT 	DISTINCT CBFund, OrgunitDonor
		FROM    NYVM1617.MartFinance.dbo.Contribution 										
		WHERE 	OrgunitDonor <> ''
		<cfif vFund neq ""> 
		AND      CBFund IN (#preserveSingleQuotes(vFund)#)
		</cfif>
		<cfif url.pDonor neq "">
		AND      OrgunitDonor = '#url.pDonor#'
		</cfif>
</cfquery>

<cf_mobileRow>
	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:70%; max-height:80%; overflow-x:hidden;overflow-y:auto; padding-top:0px;"
		panelClass = "stats hgreen">
			
			<cfoutput>
			
				<cf_mobilerow style="border-top:8px solid ##FFFFFF;">
					<cf_mobileCell class="col-md-12">
						
						<table class="detailContent table table-striped table-bordered table-hover clsNoPrint tableFixHead" style="width:100%">
							<thead>
								<tr style="background-color:##E8E8E8;">
									<th style="text-align:center;">
										<i class="fad fa-sort-<cfif url.sortdirection eq 'ASC'>up<cfelse>down</cfif>"></i>
									</th>
									<th style="cursor:pointer; color:##1F85DE;" onclick="doSorting('country','#vTemplate#','#URL.showdivision#', 'statsDetail');">
										<cf_tl id="Country">
									</th>
									<th style="cursor:pointer; color:##1F85DE;" onclick="doSorting('name','#vTemplate#','#URL.showdivision#', 'statsDetail');">
										<cf_tl id="Donor">
									</th>
									 
									<th style="text-align:center;"><cf_tl id="Fund"></th>
									
									<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
									<th style="text-align:center;"><cf_tl id="Collection"> #yr#</th>
									</cfloop>
									<th style="text-align:center; cursor:pointer; color:##1F85DE;" onclick="doSorting('total','#vTemplate#','#URL.showdivision#', 'statsDetail');">
										#url.pyear-4#-#url.pyear#
									</th>
									
								</tr>
							</thead>							
							
							<tr style="background-color: ##f1f1f1;">
								<td align="center"></td>
								<td align="center"></td>
								<td><cf_tl id="Total"></td>
								
								<td></td>
								
								<cfset tot = 0>		
								<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
								
									<cfquery name="getTotal"  dbtype="query">		
										SELECT   SUM(Collection#yr#) as Total
										FROM     getData										
									</cfquery>
																	
								<td align="center">
									#numberformat(getTotal.Total, ',')#
								</td>
								
								    <cfif getTotal.Total neq "">
										 <cfset tot = tot + getTotal.Total>
									</cfif>
									
								</cfloop>		
								
								<td align="center">										
										<cfif tot eq 0>-<cfelse>#numberformat(tot, ',')#</cfif>
								</td>	
															
							</tr>							
							
							<tbody>		
							
								<cfloop query="getData">
								
									<cfparam name="CBFund" default="">
								
									<tr style="height:20px;!important;">
										<td align="center">#currentrow#.</td>
										<td>#countryname#</td>
										<td><cfif trim(orgUnitName) eq "">#OrgunitDonor#<cfelse>#UCase(OrgUnitName)#</cfif></td>
										<cfif url.pFund eq "" and url.pDonor neq ""> 
										<td align="center">#CBFund#</td>
										<cfelseif url.pFund neq "">
										<td align="center">
											<cfquery name="getFund" dbtype="query">		
												SELECT 	DISTINCT CBFund
												FROM    qGetFunds									
												WHERE 	OrgunitDonor = '#OrgunitDonor#'
											</cfquery>
											<cfset vTheseFunds = "">
											<cfif getFund.recordCount gt 0>
												<cfset vTheseFunds = valueList(getFund.CBFund)>
											</cfif>
											#replace(vTheseFunds, ",", ", ", "ALL")#
										</td>
										<cfelse>
										<td align="center">All</td>
										</cfif>
										
										<cfset tot = 0>		
										<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
											
											<cfset val = evaluate("getData.Collection#yr#")>
											<cfset vThisStyle = "color:##358FDE;cursor:pointer;">
											<cfset vThisScript = "showDrillDetail('Collection #yr#', 'Details', 'Collection/DrillDown.cfm?yr=#yr#&orgUnit=#OrgUnitDonor#&pFund=#url.pFund#');">
											
											<cfif val eq 0 OR val eq "">
												<cfset vThisStyle = "">
												<cfset vThisScript = "">
											</cfif>
											<td 
												align="center" 
												style="#vThisStyle#" 
												onclick="#vThisScript#">
													<cfif val eq 0 OR val eq "">-<cfelse>#numberformat(val, ',')#</cfif>
													<cfif val neq "">
													 <cfset tot = tot + val>
													</cfif>
											</td>
										</cfloop>		
										
										<td align="center" style="min-width:200px;background-color: ##ffffaf;">										 
											<cfif tot eq 0>-<cfelse>#numberformat(tot, ',')#</cfif>
										</td>								
									</tr>								
								</cfloop>
								
							</tbody>
							
							<tfoot>
								<tr style="background-color: ##f1f1f1;">
									<td align="center"></td>
									<td align="center"></td>
									<td><cf_tl id="Total"></td>
									<td></td>
									
										<cfset tot = 0>		
									
										<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
										
											<cfquery name="getTotal"  dbtype="query">		
												SELECT   SUM(Collection#yr#) as Total
												FROM     getData										
											</cfquery>
																			
										<td align="center">
											#numberformat(getTotal.Total, ',')#
										</td>
										
										    <cfif getTotal.Total neq "">
												 <cfset tot = tot + getTotal.Total>
											</cfif>
											
										</cfloop>		
									
									<td align="center">										
										<cfif tot eq 0>-<cfelse>#numberformat(tot, ',')#</cfif>
									</td>	
																
								</tr>
							</tfoot>
							
						</table>

					</cf_mobileCell>
				</cf_mobilerow>
			</cfoutput>

	</cf_MobilePanel>
</cf_mobileRow>