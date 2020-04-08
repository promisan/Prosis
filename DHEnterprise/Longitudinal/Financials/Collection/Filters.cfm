<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund"    default="">
<cfparam name="URL.pYear"    default="2019">

<cfoutput>
	<cf_mobileRow>

		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qMission" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT Mission
					FROM     Ref_Mission
			</cfquery>

			<select class="form-control" name="pMission" id="pMission" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<cfloop query="qMission">
					<cfset vEntity=Trim(qMission.Mission)>		
					<option value="#vEntity#" <cfif vEntity eq URL.pMission>selected='selected'</cfif>>#vEntity#</option>
				</cfloop>
			</select>
			
		</cf_mobileCell>

		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qFund" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT CBFund as Fund
					FROM     NYVM1617.MartFinance.dbo.Contribution
					ORDER BY CBFund DESC
			</cfquery>

			<select name="pFund" id="pFund" multiple="multiple" onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')" style="width:200px;">
				<cfloop query="qFund">
					<cfset vFund=Trim(qFund.Fund)>		
					<option value="#vFund#" <cfif vFund eq URL.pFund>selected='selected'</cfif>>#vFund#</option>
				</cfloop>
			</select>
			
		</cf_mobileCell>
		
		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qDonor" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT 
							 C.OrgUnitDonor, 
							 LTRIM(RTRIM(C.OrgUnitName)) as OrgUnitName,
							 CASE
								WHEN LTRIM(RTRIM(C.OrgUnitName)) = '' OR OrgUnitName IS NULL THEN ('ZZZZZZ' + OrgunitDonor)
								ELSE LTRIM(RTRIM(C.OrgUnitName))
							 END AS Ordering
					FROM     NYVM1617.MartFinance.dbo.Contribution C
					WHERE ISNULL((
							 SELECT ISNULL(SUM(AmountBase * - 1), 0) AS Expr1
			                 FROM      NYVM1617.MartFinance.dbo.vwContributionContent
			                 WHERE     YEAR(DatePosting) BETWEEN #URL.pYear#-4 AND #URL.pYear#
							 AND       YEAR(DateDue) BETWEEN #URL.pYear#-4 AND #URL.pYear#
							 AND       AmountBase    < 0
							 AND       OrgunitDonor  = C.OrgunitDonor
						), 0) > 0
					ORDER BY 3
			</cfquery>

			<select class="form-control" name="pDonor" id="pDonor" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<option value=""> -- <cf_tl id="All"> --	
				<cfloop query="qDonor">
					<option value="#OrgUnitDonor#"><cfif trim(orgUnitName) eq "">#OrgunitDonor#<cfelse>#UCase(OrgUnitName)#</cfif></option>
				</cfloop>
			</select>
			
		</cf_mobileCell>
		
		<input type="Hidden" name="pYear" id="pYear" value="#url.pYear#">
		
		<!---

		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qYear" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT YEAR(DocumentDate) as [Year]
					FROM     NYVM1617.MartFinance.dbo.Contribution
					ORDER BY 1 DESC
			</cfquery>

			<select class="form-control" name="pYear" id="pYear" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<cfloop query="qYear">
					<cfset vYear=Trim(qYear.Year)>		
					<option value="#vYear#" <cfif vYear eq URL.pYear>selected='selected'</cfif>>#vYear#</option>
				</cfloop>
			</select>
			
		</cf_mobileCell>
		
		--->

	</cf_mobileRow>
	
</cfoutput>
<br>

<cfset ajaxOnload("function(){ $('##pFund').multipleSelect().multipleSelect('checkAll'); }")>