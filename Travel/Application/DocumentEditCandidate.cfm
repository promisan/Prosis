<!---
	Travel/Application/DocumentEditCandidate.cfm
	
	List of nominees show under the Enter Nominee data step.
	
	Included in: Travel/Application/Template/DocumentEdit_Lines.cfm

	Modification History:
	2dec04 - added DocumentNo field in LEFT JOIN fields between DocumentCandidate and 
			 DocumentRotatingPerson in SelectCandidate query 
		   - this is to prevent stalled nominees for rotating persons that have been copied
		     onto a new request from showing multiple times in the list
--->

<cfparam name="Action.ActionStatus" default="i">
<cfparam name="ActionCurrent.ActionOrder" default="0">

<cfset linestatus = #Action.ActionStatus#>

<script language="JavaScript">
function reinstate(vacno,persno)
{
	if (confirm("Do you want to reinstate this person ?")) {
		window.open("Template/DocumentCandidateReinstateSubmit.cfm?ID=" + vacno + "&ID1=" + persno, "actionsubmit", "width=200, height=200, toolbar=no, scrollbars=no, resizable=no");
	}
	return false	
}	

function cancel(vacno,persno)
{
	if (confirm("Do you want to cancel this person ?")) {
        window.open("Template/DocumentCandidateDeleteSubmit.cfm?ID=" + vacno + "&ID1=" + persno, "actionsubmit", "width=200, height=200, toolbar=no, scrollbars=no, resizable=no");
	}	
	return false	
}	
</script>

<cfquery name="SelectCandidate" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT DC.PersonNo, DC.Status, S.Description, DC.Remarks, DC.Created, DC.PlannedDeployment,
       P.FirstName + ' ' + P.LastName AS PersonName
FROM  DocumentCandidate DC INNER JOIN 
      Ref_Status S ON DC.Status = S.Status LEFT JOIN 
	  (DocumentRotatingPerson RP LEFT JOIN EMPLOYEE.DBO.Person P ON RP.PersonNo = P.PersonNo)
 	      ON DC.PersonNo = RP.ReplacementPersonNo AND
		     DC.DocumentNo = RP.DocumentNo				<!--- added 2Dec04 --->
WHERE DC.DocumentNo = '#URL.ID#'
AND   S.Class = 'Candidate'
</cfquery>

<!--- build string containing candidate index numbers --->
<cfset can = "">
<cfoutput query="SelectCandidate">
   <cfif #can# is "">
      <cfset can = "'#PersonNo#'"> 
   <cfelse>
      <cfset can = "#can#,'#PersonNo#'"> 
   </cfif>
</cfoutput>

<cfif #can# eq "">
	<cfquery name="GetCandidateA" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
    	SELECT PersonNo AS Pno, Upper(LastName) as LastName, FirstName, Nationality, Gender, BirthDate FROM Person
		WHERE PersonNo IN ('0')
	</cfquery>
<cfelse>
	<cfquery name="GetCandidateA" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
    	SELECT PersonNo AS Pno, Upper(LastName) as LastName, FirstName, Nationality, Gender, BirthDate, IndexNo FROM Person
		WHERE PersonNo IN (#PreserveSingleQuotes(can)#)
	</cfquery>
</cfif>

<cfquery name="GetCandidate" dbtype="query">
    SELECT *
    FROM   SelectCandidate, GetCandidateA
	WHERE  SelectCandidate.PersonNo = GetCandidateA.Pno
	ORDER BY GetCandidateA.LastName, GetCandidateA.FirstName
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

  <!-- print column hdrs -->
  <tr>
   	  <TD class="top2"></TD>
   	  <TD class="top2">Count</TD>
      <TD class="top2">FirstName</TD>
      <TD class="top2">LastName</TD>
	  <TD class="top2">Nat.</TD>
      <TD class="top2">Gender</TD>
   	  <TD class="top2">DOB</TD>
   	  <TD class="top2">IMIS No</TD>
   	  <TD class="top2">Exp Deploy</TD>
   	  <TD class="top2">Status</TD>
	  <TD class="top2">Replacing</TD>
  	  <TD class="top2">Action</TD>
  </tr>	
	 
  <!-- print detail row -->	
  <cfoutput query="GetCandidate">		
  <tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f5f5f5'))#">
	<td class="regular">
		<button class="button3" onClick="javascript:showdocumentcandidate('#Get.DocumentNo#','#PersonNo#')">
		<img src="../../Images/function.JPG" alt="" width="18" height="15" border="0"></button></td>
	<td class="regular">#CurrentRow#</a></td>
    <td class="regular">#FirstName#</td>
	<td class="regular">#LastName#</td>
	<td class="regular">#Nationality#</td>
	<td class="regular">#Gender#</td>
	<td class="regular">#Dateformat(BirthDate, CLIENT.DateFormatShow)#</td>	
	<td class="regular">#IndexNo#</td>
	<td class="regular">#Dateformat(PlannedDeployment, CLIENT.DateFormatShow)#</td>	
	<td class="regular"><cfif #Status# gte "6">#Description#</cfif></td>
	<td class="regular">#PersonName#</td>
	
	<!-- process Cancel/Reinstate links -->
	<td>
	<cfif #Status# eq "0">		<!-- status: Identified -->
		
	  <cfif #linestatus# eq "0" or #linestatus# eq "i">
	    <button class="button3" onClick="javascript:cancel('#Get.DocumentNo#','#GetCandidate.PersonNo#')">
   		<u>cancel</u></button>
	  </cfif>
	
	<cfelseif #Status# eq "3">	<!-- status: Selected -->
	
		<!-- no option here --->
		
	<cfelse>	<!-- status: Stalled or Revoked -->
	
	  <button class="button3" onClick="javascript:reinstate('#Get.DocumentNo#','#PersonNo#')">
   	  <u>reinstate</u></button>
			
	</cfif>
	</td>
  </tr>
  </cfoutput>
</table>