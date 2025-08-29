<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<HTML>

<HEAD>

<TITLE>Claim category</TITLE>
	
</HEAD>

<body leftmargin="2" topmargin="2" rightmargin="3">

<cfquery name="SearchResult"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     Rate.ClaimCategory, 
           Loc.LocationCountry, 
		   Loc.LocationCity, 
		   Clm.Description AS Claimant, 
		   Ind.Description AS Indicator, 
		   Rate.DateEffective, 
           Rate.Currency, 
		   Rate.Amount, 
		   Loc.Description AS Location,
		   ClaimRateId
FROM       Ref_ClaimRates Rate INNER JOIN
           Ref_PayrollLocation Loc ON Rate.ServiceLocation = Loc.LocationCode LEFT OUTER JOIN
           Ref_Indicator Ind ON Rate.IndicatorCode = Ind.Code LEFT OUTER JOIN
           Ref_Claimant Clm ON Rate.ClaimantType = Clm.Code
WHERE     (Rate.ClaimCategory = 'trM')
ORDER BY Rate.DateEffective DESC, Loc.LocationCity, Claimant, Indicator
</cfquery>


<cfset Header = "">

<cfset add="0">
<cfinclude template="../HeaderTravelClaim.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0" >

<script LANGUAGE = "JavaScript">

	function recordadd(grp)
	{
	          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width=500, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1)
	{
	          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width=500, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	
	<tr><td colspan="2">

		<table width="97%" cellspacing="0" cellpadding="3" align="center">
		 
			<tr style="height:20px;">
			    <td height="21" width="4%" align="center"></td>
			    <td >DSA Location</td>
				<td align="left" >Claimant</td>
				<td >Indicator</td>
				<td >Effective</td>
				<td >Curr.</td>
				<td >Rate&nbsp;</td>
			</tr>
			
			<tr><td colspan="7" class="linedotted"></td></tr>
		
			<cfoutput query="SearchResult" group="DateEffective"> 
				
				<tr><td align="left" colspan="7" class="labellarge">
					<i>#DateFormat(DateEffective, CLIENT.DateFormatShow)#</i>
				</td></tr>
				
					<cfoutput>
					     
					    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f8f8f8'))#">
						<td width="4%" align="center">
						
						</td>
						<td width="30%"><a href="javascript:recordedit('#ClaimRateId#')">#Location#</a></td>
						<td width="20%"><cfif #Claimant# eq "">Default<cfelse>#Claimant#</cfif></td>
						<td width="20%"><cfif #Indicator# eq ""><b>Full</b><cfelse>#Indicator#</cfif></td>
						<td width="15%">#DateFormat(DateEffective, CLIENT.DateFormatShow)#</td>
						<td width="10%">#Currency#</td>
						<td width="15%" align="right">#numberformat(Amount,"__.__")#&nbsp;</td>
						</tr>
						<cfif #currentRow# neq "#SearchResult.recordcount#">
						<tr><td colspan="7" class="linedotted"></td></tr>
						</cfif>
						
					</cfoutput>	
					
			</cfoutput>
		
		</table>

	</td> </tr>

</table>

</BODY></HTML>