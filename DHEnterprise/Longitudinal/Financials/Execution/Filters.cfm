<cfparam name="URL.pMission" 		default="SCBD">
<cfparam name="URL.pFund" 			default="">
<cfparam name="URL.pYear" 			default="2018">
<cfparam name="URL.pDonor" 			default="">
<cfparam name="URL.showCountry" 	default="0">

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
					FROM     NYVM1618.EnterpriseHub.dbo.FinanceTransaction
					WHERE    CBFund <> '' 
					AND      Source = 'Umoja'
					ORDER BY CBFund 
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
		
		<cfif URL.showCountry eq "1">
			<cf_mobileCell class="col-lg-2 text-center m-t-md">
	
				<cfquery name="qCountry" 
					datasource="appsOrganization">		 
						SELECT   DISTINCT OrgUnitDonorName
						FROM     NYVM1618.EnterpriseHub.dbo.FinanceTransaction
						WHERE	OrgUnitDonorName != '' AND OrgUnitDonorName IS NOT NULL
						ORDER BY 1
				</cfquery>
	
				<select class="form-control" name="pDonor" id="pDonor" 
					onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
					<option value="">-- <cf_tl id="All"> --</option>
					<cfloop query="qCountry">
						<cfset vCountry=Trim(qCountry.OrgUnitDonorName)>		
						<option value="#vCountry#">#vCountry#</option>
					</cfloop>
				</select>
			</cf_mobileCell>
		<cfelse>
			<input type="hidden" name="pDonor" id="pDonor" value="">
		</cfif>
		
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