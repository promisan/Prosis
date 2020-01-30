<!---
	DocumentRotatingPersonList.cfm
	
	List rotating persons that have been selected for association to a new
	Personnel Request document.  Displayed in the lower half of the DocumentEdit.cfm
	and PersonSearch.cfm
	
	Records appear in the Deployed Persons section of the PersonSearch page
	(personsearch.cfm).
	
	Called by: 
	Template\DocumentEdit_Lines.cfm
	PersonSearch.cfm		
	
	Modification History:
	15Oct03 - adapted by MM from DocumentEditCandidate.cfm
--->
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<cfparam name="Action.ActionStatus" default="i">
<cfset rp_linestatus = #Action.ActionStatus#>

<script language="JavaScript">
ie = document.all?1:0
ns4 = document.layers?1:0

function rotatingperson_markitem(itm,fld) {
     if (ie) {
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }
	 else {
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 if (fld != false) {
		 itm.className = "highLight2";
	 }
	 else {
	     itm.className = "regular";		
	 }
}

function rotatingperson_confirmdelete(docno, totrecs)
{
	if (confirm("Do you want to delete the selected person(s)?")) {
	    window.open("DocumentRotatingPersonDeleteSubmit.cfm?DOC=" + docno + "&RPNO=" + totrecs, "actionsubmit", "width=200, height=200, toolbar=no, scrollbars=no, resizable=yes");
	}	
	return false;
}	


function rotatingperson_selectall(chk,val) {
var count=0;
while (count < 99) {
	document.documentedit.deleteRotate[count].checked = val;
   	count++;
   	}	
}

</script>

<!--- this query uses TRAVEL.DBO.vwMaxPersonAssignment to ensure that only the last assignment is joined to the
	  Rotating Person record --->
<cfquery name="qPerson" datasource="#CLIENT.Datasource#" username="#CLIENT.login#" password="#CLIENT.dbpw#">
SELECT DRP.DocumentNo, P.*, Upper(P.LastName) AS sLastName, R.ShortDesc as vRank, PO.Mission, PA.DateArrival,
			PA.DateEffective, PA.DateExpiration, PA.DateDeparture, P2.FirstName + ' ' + P2.LastName as Replacement
FROM   	DocumentRotatingPerson DRP INNER JOIN 
		EMPLOYEE.DBO.Person P ON DRP.PersonNo = P.PersonNo LEFT JOIN 
		EMPLOYEE.DBO.Person P2 ON DRP.ReplacementPersonNo = P2.PersonNo LEFT JOIN 
		Ref_Rank R ON P.Rank = R.Rank LEFT JOIN 
		vwMaxPersonAssignment MPA ON P.PersonNo = MPA.PersonNo LEFT JOIN 
		EMPLOYEE.DBO.PersonAssignment PA 
		  ON (PA.PersonNo = MPA.PersonNo AND
		     CONVERT(Char(10), PA.DateArrival, 20) + CONVERT(Char(10), PA.DateDeparture, 20) = MPA.MaxAssignmentDate) LEFT JOIN 
		EMPLOYEE.DBO.Position PO ON PA.PositionNo = PO.PositionNo			                  		      
WHERE DRP.DocumentNo = '#URL.ID#' 
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

	<input type="hidden" name="doc_num" value="#URL.ID#">
	
	<tr>
   	  <td class="top2">&nbsp;Count</td>
      <td class="top2">FirstName</td>
      <td class="top2">LastName</td>
   	  <td class="top2">Rank</td>
	  <td class="top2">Nat.</td>
      <td class="top2">Gender</td>
   	  <td class="top2">DOB</td>
   	  <td class="top2">IMIS No</td>
	  <td class="top2">Mission</td>
	  <td class="top2">Duty Start</td>
  	  <td class="top2">Duty End</td>
  	  <td class="top2">Replacement</td>	  
  	  <td class="top2">
		<!--- consider this block only if this step is currently pending --->
		<cfif #rp_linestatus# eq "0" or #rp_linestatus# eq "i">
			<!--- display only if NOT called by PersonSearch.cfm --->
			<cfif NOT IsDefined("PersonSearchInd")>
	 			<input class="regular" type="checkbox" name="rp_select" value="All" onClick="javascript:rotatingperson_selectall('document.documentbatch.personno_',this.checked);"> 
				&nbsp;Mark all
			</cfif>
		<cfelse>
			&nbsp;
		</cfif>		
	  </td>	  
    </tr>	
	 
	<!-- print person records -->
	<cfoutput query="qPerson">
	
	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f5f5f5'))#">
<!-- 		<td class="regular">
		<button class="button3" onClick="javascript:showdocumentcandidate('#qPerson.DocumentNo#','#qPerson.PersonNo#')">
		<img src="../../Images/function.JPG" alt="" width="18" height="15" border="0">
		</button>
		</td>
 -->
 		<td class="regular">&nbsp;#qPerson.CurrentRow#</td>
	    <td class="regular">#qPerson.FirstName#</td>
		<td class="regular">#qPerson.sLastName#</td>
		<td class="regular">#qPerson.vRank#</td>
		<td class="regular">#qPerson.Nationality#</td>
		<td class="regular">#qPerson.Gender#</td>		
		<td class="regular">#Dateformat(qPerson.BirthDate, CLIENT.DateFormatShow)#</td>
		<td class="regular">#qPerson.IndexNo#</td>		
		<td class="regular">#qPerson.Mission#</td>				
		<td class="regular">#Dateformat(qPerson.DateArrival, CLIENT.DateFormatShow)#</td>
		<td class="regular">#Dateformat(qPerson.DateDeparture, CLIENT.DateFormatShow)#</td>
		<td class="regular">#qPerson.Replacement#</td>				
		<td class="regular">
			<!--- consider this block only if this step is currently pending --->		
			<cfif #rp_linestatus# eq "0" or #rp_linestatus# eq "i">	
				<!--- display only if NOT called by PersonSearch.cfm --->
				<cfif NOT IsDefined("PersonSearchInd")>  
		      		<input type="checkbox" name="deleteRotate" value="'#qPerson.PersonNo#'" onClick="rotatingperson_markitem(this,this.checked)">
					&nbsp;Mark for delete
					<cfset showProcDelButton = 'True'>
				</cfif>
		  	<cfelse>
		  		&nbsp;
				<cfset showProcDelButton = 'False'>
				<!--- Note: showProcDelButton controls display of the Process Delete button in
					        in DocumentEdit.cfm --->
		  	</cfif>	      
		</td>	
	</tr>

	</cfoutput>	
</table>