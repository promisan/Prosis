<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund"    default="">
<cfparam name="URL.pYear"    default="2019">
<cfparam name="URL.pPeriod"  default="B19">

<cfoutput>
	<cf_mobileRow>

		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qMission" 
				datasource="HubEnterprise">		 
					SELECT   DISTINCT Mission
					FROM     FinanceTransaction
					ORDER BY 1 ASC
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
				datasource="HubEnterprise">		 
					SELECT   DISTINCT FiscalYear
					FROM     FinanceTransaction 
					ORDER BY 1 DESC
			</cfquery>

			<select class="form-control" name="pYear" id="pYear" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<cfloop query="qYear">	
					<option value="#FiscalYear#" <cfif FiscalYear eq URL.pYear>selected='selected'</cfif>>#FiscalYear#</option>
				</cfloop>
			</select>
			
		</cf_mobileCell>
		
		<cf_mobileCell class="col-lg-8 text-center m-t-md" style="text-align:right;">

			<input type="Radio" name="fltCost" id="fltCost1" style="cursor:pointer;" onclick="ColdFusion.navigate('Expenditure/Class.cfm','mainContainer');"> <label for="fltCost1" style="cursor:pointer;"><cf_tl id="Cost Type"></label>
			<input type="Radio" name="fltCost" id="fltCost2" style="margin-left:15px; cursor:pointer;" checked="checked"> <label for="fltCost2" style="cursor:pointer;"><cf_tl id="Cost Category"></label>
			
		</cf_mobileCell>

	</cf_mobileRow>
	
</cfoutput>
<br>