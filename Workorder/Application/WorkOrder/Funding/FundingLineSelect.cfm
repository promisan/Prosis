
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
	<table width="90%" cellspacing="0" cellpadding="0">
		<input type="hidden" name="FundingId#url.tabno#_#url.row#" id="FundingId#url.tabno#_#url.row#" value="#url.fundingid#">
		<tr>
		<td style="width:35">
		<input type="input" name="FundingType" id="FundingType" readonly style="text-align:center;width:50" value="#Funding.FundingType#" class="regularxl">		
		</td>
		<td align="center">&nbsp;</td>
		<td>
		<input type="input" name="reference" id="reference" style="text-align:center;width:100%" value="#Funding.Reference#" class="regularxl">		
		</td>
		<td align="center">&nbsp;</td>
<!---
		<td style="width:35">
		<input type="input" name="Period" id="Period" style="text-align:center;height:19px;width:35" value="#Funding.Period#" class="regular">		
		</td>
--->		
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" name="Fund" id="Fund" readonly style="text-align:center;width:45" value="#Funding.Fund#" class="regularxl">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" name="OrgUnitCode" readonly id="OrgUnitCode" style="text-align:center;width:45" value="#Funding.OrgUnitCode#" class="regularxl">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" name="ProjectCode" readonly id="ProjectCode" style="text-align:center;width:45" value="#Funding.ProjectCode#" class="regularxl">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" name="ProgramCode" readonly id="ProgramCode" style="text-align:center;width:45" value="#Funding.ProgramCode#" class="regularxl">		
		</td>
		<td align="center">-</td>
		<td style="width:35">
		<input type="input" name="ObjectCode" readonly id="ObjectCode" style="text-align:center;width:45" value="#Funding.ObjectCode#" class="regularxl">		
		</td>
		
		</tr>
	</table>
</cfoutput>


