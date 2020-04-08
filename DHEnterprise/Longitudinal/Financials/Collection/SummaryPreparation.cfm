<cfparam name="URL.pMission" 		default="SCBD">
<cfparam name="URL.pFund" 			default="">
<cfparam name="URL.pYear" 			default="2019">
<cfparam name="URL.pDonor" 			default="">
<cfparam name="url.sortdirection" 	default="ASC">
<cfparam name="url.sortfield" 		default="name">
<cfparam name="url.showDivision" 	default="0">
<cfparam name="url.country" 		default="">

<cfif trim(URL.pYear) eq "" OR trim(URL.pYear) eq "undefined">
	<cfset URL.pYear = year(now())>
</cfif>

<cfset vFund = "">

<cfif vFund neq "null">
	<cfset vFund = ListQualify(url.pFund, "'", ",", "all", false)>
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
							  <cfif vFund neq ""> 
							  AND       Fund IN (#preserveSingleQuotes(vFund)#)
							  </cfif>
						  ), 0) AS Collection#yr#,
									   
						 </cfloop>					    
		          
				  	 OrgunitDonor, LTRIM(RTRIM(OrgUnitName)) AS OrgUnitName,
					 <cfif url.pDonor neq "">
					 CBFund,
					 </cfif>					 
					 CASE WHEN OrgUnitName = '' OR OrgUnitName IS NULL 
					      THEN ('ZZZZZZ' + ISNULL(OrgunitDonor,'')) ELSE OrgunitName
					 END AS Ordering,
					 CASE WHEN N.Name = '' OR N.Name IS NULL 
					      THEN ('ZZZZZZ' + ISNULL(N.Name,'')) ELSE N.Name
					 END AS OrderingCountry,
					 R.CountryCode,
					 N.Name as CountryName
			   
			FROM     NYVM1617.MartFinance.dbo.Contribution AS C
					LEFT OUTER JOIN NYVM1618.EnterpriseHub.dbo.Ref_Relation R
						ON C.OrgUnitDonor = R.RelationId
					LEFT OUTER JOIN NYVM1613.System.dbo.Ref_Nation N
						ON R.CountryCode = N.ISOCode2
			WHERE    OrgunitDonor <> ''
			
			<cfif vFund neq ""> 
			AND      CBFund IN (#preserveSingleQuotes(vFund)#)
			</cfif>
			
			<cfif url.pDonor neq "">
			AND      OrgunitDonor = '#url.pDonor#'
			</cfif>
			
			<cfif url.country neq "">
			AND      R.CountryCode = '#url.country#'
			</cfif>
		
		    <cfif url.pDonor eq "">
			GROUP BY OrgunitDonor, OrgUnitName, R.CountryCode, N.Name 
			<cfelse>
			GROUP BY CBFund, OrgunitDonor, OrgUnitName, R.CountryCode, N.Name 
			</cfif>
			
		     ) AS Data
		WHERE  (	<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
					Collection#yr# +
				</cfloop> 0
			) > 0
	
	    ORDER BY 
			<cfif url.sortfield eq "total">
				(	<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
					Collection#yr# +
				</cfloop> 0
			) #url.sortdirection#
			</cfif> 
			<cfif url.sortfield eq "name">
			Ordering #url.sortdirection#
			</cfif>
			<cfif url.sortfield eq "country">
			OrderingCountry #url.sortdirection#
			</cfif>
		  
</cfquery>