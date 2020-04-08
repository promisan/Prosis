<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund" 	 default="">
<cfparam name="URL.pYear"    default="2018">

<cfset vThisYear = URL.pYear>

<cfset vPrefixServer = "NYVM1618.EnterpriseHub.dbo.">
<cfset vPrefixServer = "">

<cfquery name="getData" 
	datasource="HubEnterprise">
		SELECT     OrgUnitDonorName, YEAR(DatePosting) AS year, LEFT(CBWBSe, 12) AS CBWBSe, CBWBSeName, CBGrant AS CBGrantIncoming, 0 AS Budget,
		
                    (SELECT     ISNULL(ROUND(SUM(BaseAmount), 0), 0) AS Expr1
                     FROM       #vPrefixServer#FinanceTransaction
                     WHERE      GLAccount <> '78201010'  
					 AND        YEAR(DatePosting) = YEAR(B.DatePosting) 
					 AND        OrgUnitDonorName = B.OrgUnitDonorName 
					 AND        TransactionClass = 'Commitment' 
					 AND        LEFT(CBWBSe, 12) = LEFT(B.CBWBSe, 12) 
					 <cfif trim(url.pfund) neq "">AND (CBFund = '#url.pfund#')</cfif> 
					 AND        Mission = '#url.pmission#') AS Obligation,
                                                  
                    (SELECT     ISNULL(ROUND(SUM(BaseAmount), 0), 0) AS Expr1
                     FROM       #vPrefixServer#FinanceTransaction AS FinanceTransaction_1
                     WHERE      GLAccount <> '78201010'   
					 AND        YEAR(DatePosting) = YEAR(B.DatePosting) 
					 AND        OrgUnitDonorName = B.OrgUnitDonorName 
					 AND        TransactionClass = 'Actual' 
					 AND        LEFT(CBWBSe, 12) = LEFT(B.CBWBSe, 12) 
					 <cfif trim(url.pfund) neq "">AND (CBFund = '#url.pfund#')</cfif> 
					 AND        Mission = '#url.pmission#') AS Disbursement,
           			
           			(SELECT    ISNULL(ROUND(SUM(BaseAmount), 0), 0) AS Expr1
                     FROM    #vPrefixServer#FinanceTransaction AS FinanceTransaction_1
                     WHERE   GLAccount = '78201010'   
					 AND     YEAR(DatePosting) = YEAR(B.DatePosting) 
					 AND     OrgUnitDonorName = B.OrgUnitDonorName 
					 AND     TransactionClass = 'Actual' 
					 AND     LEFT(CBWBSe, 12) = LEFT(B.CBWBSe, 12)
					 <cfif trim(url.pfund) neq "">AND (CBFund = '#url.pfund#')</cfif> 
					 AND     Mission = '#url.pmission#') AS Support,                                       
                                                  
					( SELECT MAX(Created)
				      FROM    #vPrefixServer#FinanceTransaction
				      WHERE  GLAccount <> '78201010'
					  AND    Mission = '#url.pmission#' 
		              AND    OrgUnitDonorName = B.OrgUnitDonorName
					  AND    TransactionClass = 'Actual'	
					  AND    LEFT(CBWBSe, 12) = LEFT(B.CBWBSe, 12)				  
		              <cfif trim(url.pfund) neq "">AND (CBFund = '#url.pfund#')</cfif>
		              AND    Mission = '#url.pmission#' ) as LastPosted	
						 
		FROM       #vPrefixServer#FinanceTransaction AS B
		WHERE      GLAccount <> '78201010'  AND (OrgUnitDonorName IS NOT NULL) 
		<cfif trim(url.pfund) neq "">
		AND        CBFund = '#url.pfund#' 
		</cfif>
		<cfif trim(url.pdonor) neq "">
		AND        OrgUnitDonorName = '#url.pdonor#' 
		</cfif>
		AND        Mission = '#url.pmission#'
		GROUP BY   LEFT(CBWBSe, 12), CBWBSeName, OrgUnitDonorName, CBGrant, YEAR(DatePosting)
		ORDER BY   OrgUnitDonorName, CBWBSe, [year]
				  
</cfquery>

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>
--->

<cf_tl id="Commitment Detail" var="lbsComDetail">
<cf_tl id="Disbursement Detail" var="lbsDisDetail">

<cf_mobileRow>
	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:80%; max-height:72%; overflow:auto; padding-top:10px;"
		panelClass = "stats hgreen">
			
				<cf_mobilerow>
					<cf_mobileCell class="col-md-12">
						
						<table class="table table-striped table-bordered table-hover table-responsive tableFixHead">
							<thead>
								<tr style="background-color:##E8E8E8;">
									<th style="width:1%;"></th>									
									<th style="min-width:150px;text-align:center;"><cf_tl id="Project UmojaId"></th>
									<th style="width:30%;text-align:center;"><cf_tl id="Activity"></th>
									<th style="width:20%;text-align:center;"><cf_tl id="Grant"></th>
									<th style="width:9%;text-align:center;"><cf_tl id="Last Posted"></th>
									<th style="width:5%;text-align:center;"><cf_tl id="Budget"></th>
									<th style="width:5%;text-align:center;"><cf_tl id="Committed"></th>
									<th style="width:5%;text-align:center;"><cf_tl id="Disbursed"></th>
									<th style="width:5%;text-align:center;"><cf_tl id="Support"></th>
									<th style="width:5%;text-align:center;"><cf_tl id="Expenditure"></th>
									<th style="width:5%;text-align:center;"><cf_tl id="Balance"></th>
								</tr>
							</thead>
							
							<tbody>
																	
								<cfoutput query="getData" group="OrgUnitDonorName">
								
								    <tr>										
										<td colspan="11" style="font-weight:200;font-size:28px">#OrgUnitDonorName#</td>										
									</tr>		
									
									<cfset vCnt = 1>	
									<cfset vObligation = 0>
									<cfset vDisbursement = 0>	
									<cfset vSupport = 0>
								
									<cfoutput group="CBWBSe">
									
										<cfquery name="getWBSE" dbtype="query">
											SELECT 	SUM(Obligation) as Obligation, SUM(Disbursement) as Disbursement, SUM(Support) as Support
											FROM 	GetData
											WHERE 	OrgUnitDonorName = '#OrgUnitDonorName#'
											AND 	CBWBSe = '#CBWBSe#'
										</cfquery>
										
										<cfset vWBSEObligation = 0>
										<cfset vWBSEDisbursement = 0>
										<cfset vWBSESupport = 0>
										
										<cfif getWBSE.recordCount gt 0>
											<cfif getWBSE.Obligation neq "">
												<cfset vWBSEObligation = getWBSE.Obligation>
											</cfif>
											<cfif getWBSE.Disbursement neq "">
												<cfset vWBSEDisbursement = getWBSE.Disbursement>
											</cfif>
											<cfif getWBSE.Support neq "">
												<cfset vWBSESupport = getWBSE.Support>
											</cfif>
										</cfif>
										
										<cfset vId = replace(CBWBSe, '-', '', 'ALL')>
										<cfset vId = replace(vId, '.', '', 'ALL')>
										<cfset vId = trim(vId)>
												
										<tr>
											<td align="center">#vCnt#.</td>
											
											<td align="center" style="color:##49AAFE; cursor:pointer;" onclick="toggleFinancialsDetail('#vId#');">
												#CBWBSe#
											</td>
											<td align="left" style="padding-left:5px">
											     #CBWBseName#
											</td>
											<td align="center">
												#CBGrantIncoming#
											</td>
											<td align="center">
												#dateformat(LastPosted,client.dateformatshow)#
											</td>
											<td align="center">
												-
											</td>
											<td align="center" style="color:##49AAFE; cursor:pointer;" onclick="showCommitmentDetail('#lbsComDetail#', '', '#url.pfund#', '#url.pmission#', '#OrgUnitDonorName#', '#CBWBSe#')">
												#numberformat(vWBSEObligation, ',')#
											</td>
											<td align="center" style="color:##49AAFE; cursor:pointer;" onclick="showDisbursementDetail('#lbsDisDetail#', '', '#url.pfund#', '#url.pmission#', '#OrgUnitDonorName#', '#CBWBSe#')">
												#numberformat(vWBSEDisbursement, ',')#
											</td>
											<td align="center">
												#numberformat(vWBSESupport, ',')#
											</td>
											<td align="center">
												#numberformat(vWBSEObligation+vWBSEDisbursement+(vWBSESupport), ',')#
											</td>
											<td align="center">
												--
											</td>
										</tr>	
										
										<cfoutput>
											<tr class="clsDetailContainer_#vId#" style="display:none;">
												<td></td>
												<td></td>
												<td style="font-size:80%;">#Year#</td>
												<td></td>
												<td></td>
												<td style="font-size:80%;" align="center">-</td>
												<td style="font-size:80%;" align="center">#numberformat(obligation, ',')#</td>
												<td style="font-size:80%;" align="center">#numberformat(Disbursement, ',')#</td>
												<td style="font-size:80%;" align="center">#numberformat(Support, ',')#</td>
												<td style="font-size:80%;" align="center">#numberformat(Obligation+Disbursement+Support, ',')#</td>
												<td style="font-size:80%;" align="center">--</td>
											</tr>	
											<cfset vSupport      = vSupport      + Support>
											<cfset vObligation   = vObligation   + Obligation>
											<cfset vDisbursement = vDisbursement + Disbursement>
										</cfoutput>
										
										<cfset vCnt = vCnt+1>				
									</cfoutput>
									
									<tr style="background-color: e1e1e1;">
									
										<td align="center"></td>
										<td align="center">	</td>
										<td align="center">	</td>
										<td align="center">
											<cf_tl id="Total">
										</td>
										<td align="center">	</td>
										<td align="center">
											-
										</td>
										<td align="center">
											#numberformat(vObligation, ',')#
										</td>
										<td align="center">
											#numberformat(vDisbursement, ',')#
										</td>
										<td align="center">
											#numberformat(vSupport, ',')#
										</td>
										<td align="center">
											#numberformat(vObligation+vDisbursement+vSupport, ',')#
										</td>
										<td align="center">
											--
										</td>
									</tr>										
									
								</cfoutput>
								
							</tbody>
							
						</table>

					</cf_mobileCell>
				</cf_mobilerow>
			
	</cf_MobilePanel>
</cf_mobileRow>