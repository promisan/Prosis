
<cfparam name="url.fundingid" default="">

<cfquery name="Funding" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Funding
	<cfif url.fundingid neq "">
	WHERE FundingId = '#url.FundingId#'	
	<cfelse>
	WHERE 1=0
	</cfif>
</cfquery>

<cfoutput>
	<table width="95%" cellspacing="0" cellpadding="0">
		<input type="hidden" class="regularxl" name="FundingId" id="FundingId" value="#url.fundingid#">
		<tr class="labelit">
		<td style="width:35">
		<input type="input" class="regularxl" name="FundingType" id="FundingType" style="text-align:center;height:19px;width:55" value="#Funding.FundingType#" class="regular">		
		</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="Reference" id="Reference" style="text-align:center;height:19px;width:55" value="#Funding.Reference#" class="regular">		
		</td>
<!---		
		<td style="width:35">
		<input type="input" name="Period" id="Period" style="text-align:center;height:19px;width:35" value="#Funding.Period#" class="regular">		
		</td>
--->		
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="Fund" id="Fund" style="text-align:center;height:19px;width:35" value="#Funding.Fund#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="ProjectCode" id="ProjectCode" style="text-align:center;height:19px;width:35" value="#Funding.ProjectCode#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="ProgramCode" id="ProgramCode" style="text-align:center;height:19px;width:35" value="#Funding.ProgramCode#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="OrgUnitCode" id="OrgUnitCode" style="text-align:center;height:19px;width:35" value="#Funding.OrgUnitCode#" class="regular">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" class="regularxl" name="ObjectCode" id="ObjectCode" style="text-align:center;height:19px;width:35" value="#Funding.ObjectCode#" class="regular">		
		</td>
		
		</tr>
	</table>
</cfoutput>
