<!---
	IncidentPersonList.cfm
	
	List persons associated to a Disciplinary Incident record.
	
	Records appear in the Associated Persons section of the IncidentEdit page
	(incidentedit.cfm).
	
	Included by: IncidentEdit.cfm
	
	Modification History:
	24Oct03 - created by MM
	18Mar04 - added code to allow editing of IncidentPerson record (which now has new fields)
--->
<script language="JavaScript">
function disassociate(incno,persno)
{
	if (confirm("Do you want to disassociate this person?")) {
        window.open("IncidentPersonDeleteSubmit.cfm?ID=" + incno + "&ID1=" + persno, "actionsubmit", "width=200, height=200, toolbar=no, scrollbars=no, resizable=no");
		// opener.location.reload()
	}	
	return false	
}	
</script>

<cfinclude template="Dialog.cfm">

<cfquery name="SearchResult" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT IP.*, P.IndexNo, P.FirstName, P.LastName, P.Gender, P.Nationality, 
	       Upper(P.LastName) AS sLastName, R.ShortDesc as vRank, PA.DateArrival AS DOA, 
		   (CASE WHEN (PA._tsDateActualDeparture IS NULL) THEN PA.DateDeparture ELSE PA._tsDateActualDeparture END) AS DOR, 
		   D.Description AS sDecision
	FROM   IncidentPerson IP INNER JOIN (EMPLOYEE.DBO.Person P LEFT JOIN Ref_Rank R ON P.Rank = R.Rank) ON IP.PersonNo = P.PersonNo	
                             LEFT JOIN EMPLOYEE.DBO.PersonAssignment AS PA ON IP.PersonNo = PA.PersonNo
							 LEFT JOIN Decision D ON IP.Decision = D.Decision                           
	WHERE IP.Incident = #URL.ID#
	ORDER BY P.LastName, P.FirstName
</cfquery>

<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

	<!-- print row title -->
    <tr>
	  <td class="topN">&nbsp;</td>
	  <td class="topN">&nbsp;Count</td>
      <td class="topN">FirstName</td>
      <td class="topN">LastName</td>
   	  <td class="topN">Rank</td>
	  <td class="topN">Nat.</td>
      <td class="topN">Gender</td>
   	  <td class="topN">IMIS No</td>
	  <td class="topN">DOA</td>
  	  <td class="topN">DOR</td>
  	  <td class="topN">Decision</td>	  
  	  <td class="topN">Approved On</td>	  
  	  <td class="topN">&nbsp;</td>	  	  
     </tr>	
	 
	<!-- print person records -->	 	
	<cfoutput query="SearchResult">
	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f5f5f5'))#">
		<td class="regular">
		<button class="button3" onClick="javascript:pm_editincidentperson('#Incident#','#PersonNo#')">
		<img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
		</button>
		</td>
 		<td class="regular">&nbsp;&nbsp;#CurrentRow#</td>
	    <td class="regular">#FirstName#</td>
		<td class="regular">#sLastName#</td>
		<td class="regular">#vRank#</td>
		<td class="regular">#Nationality#</td>
		<td class="regular">#Gender#</td>		
		<td class="regular">#IndexNo#</td>		
		<td class="regular">#Dateformat(DOA, CLIENT.DateFormatShow)#</td>		
		<td class="regular">#Dateformat(DOR, CLIENT.DateFormatShow)#</td>
		<td class="regular">#sDecision#</td>	
		<td class="regular">#Dateformat(ApprovalDate, CLIENT.DateFormatShow)#</td>
		<td>	
		<button class="button3" onClick="javascript:disassociate('#Incident#','#PersonNo#')">
	   	&nbsp;<u>disassociate</u>
    	</button>
		</td>	
	</tr>
	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f5f5f5'))#">
		<td colspan="2">&nbsp;</td>
		<td colspan="10" class="regular">#Remarks#</td>
		<td></td>
	</tr>	
	</cfoutput>	
</table>