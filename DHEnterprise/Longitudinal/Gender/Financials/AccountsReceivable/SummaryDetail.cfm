<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund" default="">
<cfparam name="URL.pYear" default="2019">
<cfparam name="URL.pDonor" default="">

<cfif trim(URL.pYear) eq "" OR trim(URL.pYear) eq "undefined">
	<cfset URL.pYear = year(now())>
</cfif>

<cfset vThisYear = URL.pYear>
<cfset vLastYear = vThisYear-1>

<cfif url.pDonor eq "">
 <cfset connect = "OrgunitDonor = C.OrgunitDonor">
<cfelse>
 <cfset connect = "Fund = C.CBFund AND OrgunitDonor = C.OrgunitDonor">
</cfif>

<cfquery name="getData" 
	datasource="martStaffing">

		SELECT        
		              OrgunitDonor, OrgUnitName,
					  
					   <cfif url.pDonor neq "">
					   CBFund,
					   </cfif>
		
                       (SELECT        ISNULL(ROUND(SUM(AmountBase), 2), 0) 
                        FROM          NYVM1617.MartFinance.dbo.vwContributionContent
                        WHERE         (YEAR(DatePosting) < '#URL.pYear#') AND (YEAR(DateDue) < '#URL.pYear#') AND #connect#) AS Prior_1,
	   
                       (SELECT        ISNULL(ROUND(SUM(AmountBase), 2), 0) 
                        FROM          NYVM1617.MartFinance.dbo.vwContributionContent 
                        WHERE         (YEAR(DateDue) = '#URL.pYear#')  AND (AmountBase > 0) AND #connect#) AS ThisPledge_2,
	   
                       (SELECT        ISNULL(ROUND(SUM(AmountBase * - 1), 2), 0) 
                        FROM          NYVM1617.MartFinance.dbo.vwContributionContent 
                        WHERE         (YEAR(DateDue) >= '#URL.pYear#') AND (YEAR(DatePosting) < '#URL.pYear#') AND #connect#) AS PriorAdvance_3,
	   
                       (SELECT       ISNULL(ROUND(SUM(AmountBase * - 1), 2), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent 
                        WHERE        (YEAR(DateDue) <= '#vLastYear#') AND (YEAR(DatePosting) = '#URL.pYear#') AND (AmountBase < 0) AND #connect#) AS CollectionPrior_4,
		   
                       (SELECT       ISNULL(SUM(AmountBase * - 1), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent 
                        WHERE        (YEAR(DateDue) = '#URL.pYear#')  AND (YEAR(DatePosting) = '#URL.pYear#') AND (AmountBase < 0) AND #connect#) AS CollectionThis_5,
		   
                       (SELECT       ISNULL(SUM(AmountBase * - 1), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent 
                        WHERE        (YEAR(DateDue) >= '#URL.pYear#') AND (YEAR(DatePosting) < YEAR(DateDue)) AND #connect#) AS CollectionFuture_6,
	   
                       (SELECT       ISNULL(SUM(AmountBase * - 1), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent
                        WHERE        (YEAR(DatePosting) = '#URL.pYear#') AND (YEAR(DateDue) <= '#URL.pYear#') AND (AmountBase < 0) AND #connect#) AS CollectionThis_6X,
	   
                       (SELECT       ISNULL(SUM(AmountBase), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent
                        WHERE        (YEAR(DateDue) < '#URL.pYear#') AND (YEAR(DatePosting) <= '#URL.pYear#') AND #connect#) AS UnpaidPrior_7,
		   
                       (SELECT       ISNULL(SUM(AmountBase), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent 
                        WHERE        (YEAR(DateDue) = '#URL.pYear#') AND (YEAR(DatePosting) = '#URL.pYear#') AND #connect#) AS UnpaidThis_8,
	   
                       (SELECT       ISNULL(SUM(AmountBase), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent
                        WHERE        (YEAR(DateDue) <= '#URL.pYear#') AND (YEAR(DatePosting) <= '#URL.pYear#') AND #connect#) AS UnpaidTotal_9,
	   
                       (SELECT       ISNULL(SUM(AmountBase), 0) 
                        FROM         NYVM1617.MartFinance.dbo.vwContributionContent
                        WHERE        1=1 AND #connect#) AS Balance_Due_Today,
						 
						CASE WHEN OrgUnitName = '' OR OrgUnitName IS NULL THEN ('ZZZZZZ' + OrgunitDonor) ELSE OrgunitName END AS Ordering
	   
	FROM     NYVM1617.MartFinance.dbo.Contribution AS C
	WHERE    OrgunitDonor <> ''
	<cfif url.pFund neq ""> 
	AND      CBFund = '#url.pFund#'
	</cfif>
	
	<cfif url.pDonor neq "">
	AND      OrgunitDonor = '#url.pDonor#'
	</cfif>
	
	<cfif url.pDonor neq "">
	GROUP BY CBFund, OrgunitDonor, OrgUnitName
	<cfelse>
	GROUP BY OrgunitDonor, OrgUnitName
	</cfif>
		
				  
</cfquery>


<cf_mobileRow>
	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:80%; max-height:72%; overflow:auto; padding-top:10px;"
		panelClass = "stats hgreen">
			
			<cfoutput>
				<cf_mobilerow>
					<cf_mobileCell class="col-md-12">
						
						<table class="table table-striped table-bordered table-hover table-responsive tableFixHead">
							<thead>
								<tr style="background-color:##E8E8E8;">
									<th></th>
									<th><cf_tl id="Country"></th>
									<th style="width:50px;text-align:center;"><cf_tl id="Fund"></th>
									<th style="width:130px;text-align:center;"><cf_tl id="Unpaid"> #url.pYear-1#</th>
									<th style="width:130px;text-align:center;"><cf_tl id="Pledges"> #url.pYear#</th>
									<th style="width:130px;text-align:center;"><cf_tl id="Advances"> #url.pYear-1#</th>
									<th style="width:140px;text-align:center;"><cf_tl id="Collections"> #url.pYear#</th>
									<th style="width:150px;text-align:center;"><cf_tl id="Outstanding"> #url.pYear#</th>
									<!---
									<th style="text-align:center;"><cf_tl id="Total Due"> <cf_tl id="Today"></th>
									--->
								</tr>
							</thead>
							<tbody>
							
								<cfset Total_Prior_1           = 0>
								<cfset Total_ThisPledge_2      = 0>
								<cfset Total_PriorAdvance_3    = 0>
								<cfset Total_CollectionThis_6x = 0>
								<cfset Total_UnpaidTotal_9     = 0>
								<cfset Total_Balance_Due_Today = 0>
								
								<cfset vCnt = 1>
								<cfparam name="CBFund" default="All">
								<cfloop query="getData">
									<tr>
										<td align="center">#vCnt#.</td>
										
										<td><cfif trim(orgUnitName) eq "">#OrgunitDonor#<cfelse>#UCase(OrgUnitName)#</cfif></td>
										<td align="center">#CBFund#</td>
										<td align="center">
											<cfif Prior_1 eq 0>-<cfelse>#numberformat(Prior_1, ',')#</cfif>
										</td>
										<td align="center">
											<cfif ThisPledge_2 eq 0>-<cfelse>#numberformat(ThisPledge_2, ',')#</cfif>
										</td>
										<td align="center">
											<cfif PriorAdvance_3 eq 0>-<cfelse>#numberformat(PriorAdvance_3, ',')#</cfif>
										</td>
										<td align="center">
											<cfif CollectionThis_6x eq "">-<cfelse>#numberformat(CollectionThis_6x, ',')#</cfif>
										</td>
										<td align="center">
											<cfif UnpaidTotal_9 eq "0">-<cfelse>#numberformat(UnpaidTotal_9, ',')#</cfif>
										</td>
										<!---
										<td align="center">
											#numberformat(Balance_Due_Today, ',')#
										</td>
										--->
									</tr>
									<cfset Total_Prior_1           = Total_Prior_1           + Prior_1>
									<cfset Total_ThisPledge_2      = Total_ThisPledge_2      + ThisPledge_2>
									<cfset Total_PriorAdvance_3    = Total_PriorAdvance_3    + PriorAdvance_3>
									<cfif CollectionThis_6x neq "">
										<cfset Total_CollectionThis_6x  = Total_CollectionThis_6x  + CollectionThis_6x>
									</cfif>
									<cfif UnpaidTotal_9 neq "">
										<cfset Total_UnpaidTotal_9     = Total_UnpaidTotal_9     + UnpaidTotal_9>
									</cfif>
									<cfset Total_Balance_Due_Today = Total_Balance_Due_Today + Balance_Due_Today>
									<cfset vCnt = vCnt + 1>
								</cfloop>
							</tbody>

							<tfoot>
								<tr style="background-color: ##E1E1E1;">
									<td align="center"></td>
									<td></td>
									<td><cf_tl id="Total"></td>									
									<td align="center">
										#numberformat(Total_Prior_1, ',')#
									</td>
									<td align="center">
										#numberformat(Total_ThisPledge_2, ',')#
									</td>
									<td align="center">
										#numberformat(Total_PriorAdvance_3, ',')#
									</td>
									<td align="center">
										#numberformat(Total_CollectionThis_6x, ',')#
									</td>
									<td align="center">
										#numberformat(Total_UnpaidTotal_9, ',')#
									</td>
									<!---
									<td align="center">
										#numberformat(Total_Balance_Due_Today, ',')#
									</td>
									--->
								</tr>
							</tfoot>
						</table>

					</cf_mobileCell>
				</cf_mobilerow>
			</cfoutput>

	</cf_MobilePanel>
</cf_mobileRow>