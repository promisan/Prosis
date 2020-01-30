<!-- 
	Travel/Application/DocumentExpDeployment.cfm
	
	Included in: DocumentListing.cfm
	
	Display candidate expected deployment dates and person counts
	
	Modification history:
	
-->
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

  <cfoutput>
  <tr>
  	<td width="4%"></td>
	<td width="6%"></td>
    <td width="17%"></td>
	<td width="11%"></td>
	<td width="6%"></td>	
	<td width="9%"></td>
	<td width="5%"></td>	
	<td width="2%"></td>
    <td width="7%" class="regular">#Dateformat(GetCandidateDate.PlannedDeployment, "#CLIENT.dateformatshow#")#</td>
	<td width="4%" class="regular">#GetCandidateDate.PersCount#</td>
	<td width="4%"></td>
    <td width="10%"></td>
    <td width="15%"></td>
  </tr>
  </cfoutput>

</table>