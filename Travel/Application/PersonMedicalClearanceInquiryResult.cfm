<!--- 
	PersonMedicalClearanceInquiryResult.cfm
	
    List candidates for whom medical clearance have been requested in PM STARS.
	
	Called by: PersonMedicalClearanceInquiry.cfm
	Calls:
	
	Modification History:	
	
--->

<!---
<script language="JavaScript">
function MedicallyClearPerson(docno, pers)
{
	window.open("PersonMedicalClearanceEdit.cfm?ID=" + docno + "&ID1=" + pers, "IndexWindow", "width=60, height=55, toolbar=yes, scrollbars=yes, resizable=no");
}
</script>
--->
<cfinclude template="../Application/Dialog.cfm">

<cfparam name="Form.Crit1_Value" default="">	

<cfset Criteria = ''>

<!--- 1. Build criteria string based on user input in calling form --->

<!---cfif #Form.Crit1_Value# IS NOT ""> ...Crit1  not used	
	<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
</cfif--->	
<cfif #Form.Crit2_Value# IS NOT "">	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">
</cfif>
<cfif #Form.Crit3_Value# IS NOT "">	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">
</cfif>	

<cfif #Form.exclMission# IS "0">
  <cfif #Form.Mission# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "D.Mission IN (#PreserveSingleQuotes(Form.Mission)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND D.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )" >
     </cfif>
  </cfif> 
</cfif>

<cfif #Form.exclNation# IS "0">
  <cfif #Form.Nationality# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "P.Nationality IN (#PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND P.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
  </cfif> 
</cfif>	
				
<!--- 2. Retrieve candidates awaiting medical clearance who match the search criteria --->
<cfquery name="SearchResult" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  P.*, Upper(P.LastName) AS LastName, P.FirstName, 
	        D.Mission, DC.DocumentNo, DC.ActionId, DC.ActionDateActual
	FROM    DocumentCandidateAction DC INNER JOIN 
	        Document D ON DC.DocumentNo = D.DocumentNo INNER JOIN 
			FlowActionView FA ON DC.ActionId = FA.ActionId INNER JOIN 
			EMPLOYEE.DBO.Person P ON DC.PersonNo = P.PersonNo
    WHERE   DC.ActionStatus = '#Form.CandActionStat#'
	  AND   D.Status IN ('0','1')			<!--- request is 0 - pending or 1 - completed --->
      AND   FA.ConditionForView LIKE 'MedicallyClear'
	  AND   P.Category IN (	SELECT DISTINCT RC.Category
							FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
							WHERE AA.ActionId = FA.ActionID
							AND   FA.ActionClass = RT.TravellerTypeCode
							AND   RT.TravellerType = RC.TravellerType
							AND   AA.AccessLevel <> '9'
							AND   AA.UserAccount = '#SESSION.acc#' )
  <cfif #PreserveSingleQuotes(Criteria)# NEQ "">
	  AND   #PreserveSingleQuotes(Criteria)#
  </cfif>
	ORDER BY P.LastName, P.FirstName
</cfquery>

<!--- 3. Display the results in a list --->
<html><head><title>Persons Awaiting Medical Clearance - Search Results</title></head>
	
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

<body bgcolor="#BFDFFF">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr height="20" valign="middle" bgcolor="002350">
    <td class="label">&nbsp;<b>Persons Awaiting Medical Clearance - Search Results</b></td> 
  </tr>
  
  <tr>
  <td>  
   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

  	<tr bgcolor="#6688aa">
    <td class = "topN">&nbsp;</td>
    <td class = "topN">&nbsp;</td>	
    <td class = "topN">Person No</td>
    <td class = "topN">First Name</td>
    <td class = "topN">Last Name</td>	
    <td class = "topN">Birth Date</td>
    <td class = "topN">Gender</td>	
    <td class = "topN">Nat</td>		
    <td class = "topN">Category</td>
	<td class = "topN">IMIS No</td>
	<td class = "topN">Req No</td>	
	<td class = "topN">Field Mission</td>
	<td class = "topN">Pending Since</td>
	<td class = "topN">&nbsp;</td>			
  	</tr>

	<cfoutput query="SearchResult">
	
	<cfdirectory action="LIST" 
	 directory="#CLIENT.RootDocumentPath#\personnel\#PersonNo#" 
	 name="GetFiles" 
	 filter="MS2*.*">
	
 	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
   		<td class="regular">&nbsp;
	    <a href ="javascript:pm_editpersonmedical('#DocumentNo#','#PersonNo#','#ActionId#')" title="Click to display medical clearance form.">
   	     <img src="#CLIENT.Root#/Images/button.jpg" alt="Click to display medical clearance form." name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
        </a>&nbsp;
		</td>	
		<td class="regular"><font color="black">#CurrentRow#.</font></td>
		<td class="regular"><font color="black">#PersonNo#</font></td>
		<td class="regular"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to edit person record.">#FirstName#</a></td>
		<td class="regular"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to edit person record.">#LastName#</a></td>
		<td class="regular"><font color="black">#DateFormat(BirthDate, CLIENT.DateFormatShow)#</font></td>
		<td class="regular"><font color="black">#Gender#</font></td>
		<td class="regular"><font color="black">#Nationality#</font></td>
		<td class="regular"><font color="black">#Category#</font></td>
		<td class="regular"><font color="black">#IndexNo#</font></td>
		<td class="regular"><font color="black">#DocumentNo#</font></td>		
		<td class="regular"><font color="black">#Mission#</font></td>		
		<td class="regular"><font color="black">#DateFormat(ActionDateActual, CLIENT.DateFormatShow)#</font></td>
		<td class="regular">
		<cfif #GetFiles.RecordCount# GT 0>
			<img src="../../Images/doc.GIF" border="0">
		<cfelse>
			&nbsp;
		</cfif>
		</td>
  	</tr>
	</cfoutput>
   </table>
  </td>
  </tr>
</table>

<hr>
<!---
<input type="button" name="OK"    value="    Close    " onClick="window.close()"> 
--->
</body></html>