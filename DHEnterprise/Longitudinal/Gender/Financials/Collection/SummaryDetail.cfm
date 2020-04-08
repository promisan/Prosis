<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund" default="">
<cfparam name="URL.pYear" default="2019">
<cfparam name="URL.pDonor" default="">

<cfif trim(URL.pYear) eq "" OR trim(URL.pYear) eq "undefined">
	<cfset URL.pYear = year(now())>
</cfif>

<cfset vThisYear = URL.pYear>

<cfquery name="getData" 
	datasource="martStaffing">

		SELECT 	*
		
		FROM (
				SELECT   <cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
														 
				         ISNULL((
							  SELECT ISNULL(SUM(AmountBase * - 1), 0) 
			                  FROM      NYVM1617.MartFinance.dbo.vwContributionContent
			                  WHERE     YEAR(DatePosting) = '#yr#' 
							  AND       YEAR(DateDue) <= '#yr#'
							  AND       AmountBase    < 0
							  AND       OrgunitDonor  = C.OrgunitDonor
							  <cfif url.pDonor neq "">
							  AND       Fund          = C.CBFund
							  </cfif>
							  <cfif url.pFund neq ""> 
							  AND       Fund = '#url.pFund#' 
							 </cfif>
						  ), 0) AS Collection#yr#,
									   
						 </cfloop>					    
		          
				  	 OrgunitDonor, LTRIM(RTRIM(OrgUnitName)) AS OrgUnitName,
					 <cfif url.pDonor neq "">
					 CBFund,
					 </cfif>					 
					 CASE WHEN OrgUnitName = '' OR OrgUnitName IS NULL 
					      THEN ('ZZZZZZ' + OrgunitDonor) ELSE OrgunitName
					 END AS Ordering
			   
			FROM     NYVM1617.MartFinance.dbo.Contribution AS C
			WHERE    OrgunitDonor <> ''
			
			<cfif url.pFund neq ""> 
			AND      CBFund = '#url.pFund#'
			</cfif>
			
			<cfif url.pDonor neq "">
			AND      OrgunitDonor = '#url.pDonor#'
			</cfif>
		
		    <cfif url.pDonor eq "">
			GROUP BY OrgunitDonor, OrgUnitName
			<cfelse>
			GROUP BY CBFund, OrgunitDonor, OrgUnitName
			</cfif>
			
		     ) AS Data
		WHERE  (	<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
					Collection#yr# +
				</cfloop> 0
			) > 0
	
	    ORDER BY Ordering
		  
</cfquery>

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>
--->

<cf_mobileRow>
	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:80%; max-height:72%; overflow:auto; padding-top:8px;"
		panelClass = "stats hgreen">
			
			<cfoutput>
			
				<cf_mobilerow>
					<cf_mobileCell class="col-md-12">
						
						<table class="detailContent table table-striped table-bordered table-hover clsNoPrint tableFixHead" style="width:100%">
							<thead>
								<tr style="background-color:##E8E8E8;">
									<th></th>
									<th><cf_tl id="Donor"></th>
									 
									<th><cf_tl id="Fund"></th>
									
									<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
									<th style="text-align:center;"><cf_tl id="Collection"> #yr#</th>
									</cfloop>
									<th style="text-align:center;">#url.pyear-4#-#url.pyear#</th>
									
								</tr>
							</thead>							
							
							<tr style="background-color: ##f1f1f1;">
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
										<td><cfif trim(orgUnitName) eq "">#OrgunitDonor#<cfelse>#UCase(OrgUnitName)#</cfif></td>
										<cfif url.pFund eq "" and url.pDonor neq ""> 
										<td align="center">#CBFund#</td>
										<cfelseif url.pFund neq "">
										<td align="center">#url.pFund#</td>
										<cfelse>
										<td align="center">All</td>
										</cfif>
										
										<cfset tot = 0>		
										<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
											
											<cfset val = evaluate("getData.Collection#yr#")>
											<cfset vThisStyle = "color:##358FDE;cursor:pointer;">
											<cfset vThisScript = "showDrillDetail('Collection #yr#', 'Details', 'Collection/DrillDown.cfm?yr=#yr#&orgUnit=#OrgUnitDonor#&pFund=#CBFund#');">
											
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
									<td><cf_tl id="Total"></td>
									<cfif url.pFund eq "">
									<td></td>
									</cfif>
									
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

<!---

<cfset ajaxOnLoad("function(){ $('.detailContent').DataTable({ 'pageLength':100, 'dom':'<\'dataTableWrapper\'f><\'dataTableWrapper\'ip>t<\'dataTableWrapper\'lr>', 'order': [[4, 'asc']], 'columnDefs':[{'orderData':[5], 'targets':[4]},{'targets':[5],'visible':false,'searchable':false}] }); }")>

--->

