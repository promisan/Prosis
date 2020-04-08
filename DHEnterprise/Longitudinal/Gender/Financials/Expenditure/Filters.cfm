<cfparam name="URL.pMission" default="SCBD">
<cfparam name="URL.pFund"    default="">
<cfparam name="URL.pYear"    default="2019">
<cfparam name="URL.pPeriod"  default="B19">

<cfoutput>
	<cf_mobileRow>

		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qPeriod" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT CBPeriod
					FROM     [NYVM1618].UMOJA.dbo.IMP_CoreFundsCBD
			</cfquery>

			<select class="form-control" name="pPeriod" id="pPeriod" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<cfloop query="qPeriod">
					<cfset vEntity=Trim(qPeriod.CBPeriod)>		
					<option value="#CBPeriod#" <cfif CBPeriod eq URL.pPeriod>selected='selected'</cfif>>#CBPeriod#</option>
				</cfloop>
			</select>
			
		</cf_mobileCell>

	</cf_mobileRow>
	
</cfoutput>
<br>