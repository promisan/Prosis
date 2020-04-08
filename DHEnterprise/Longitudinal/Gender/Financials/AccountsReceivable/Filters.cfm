<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund" default="">
<cfparam name="URL.pYear" default="2019">

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

			<cfquery name="qYear" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT YEAR(DocumentDate) as [Year]
					FROM     NYVM1617.MartFinance.dbo.Contribution
					WHERE YEAR(DocumentDate) >= 2015 and YEAR(DocumentDate) < 2023
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
		
		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qDonor" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT 
							OrgUnitDonor, 
							OrgUnitName,
							CASE
								WHEN LTRIM(RTRIM(C.OrgUnitName)) = '' OR OrgUnitName IS NULL THEN ('ZZZZZZ' + OrgunitDonor)
								ELSE LTRIM(RTRIM(C.OrgUnitName))
							 END AS Ordering
					FROM     NYVM1617.MartFinance.dbo.Contribution C
					ORDER BY 3 ASC
			</cfquery>

			<select class="form-control" name="pDonor" id="pDonor" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<option value=""> -- <cf_tl id="All"> --	
				<cfloop query="qDonor">
					<option value="#OrgUnitDonor#"><cfif trim(orgUnitName) eq "">#OrgunitDonor#<cfelse>#UCase(OrgUnitName)#</cfif></option>
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

			<select class="form-control" name="pFund" id="pFund" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<option value=""> -- <cf_tl id="All"> --
				<cfloop query="qFund">
					<cfset vFund=Trim(qFund.Fund)>		
					<option value="#vFund#" <cfif vFund eq URL.pFund>selected='selected'</cfif>>#vFund#</option>
				</cfloop>
			</select>
			
		</cf_mobileCell>

	</cf_mobileRow>
	
</cfoutput>
<br>