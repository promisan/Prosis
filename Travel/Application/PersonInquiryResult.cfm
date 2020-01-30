<!--- 
	PersonInquirySearch.cfm
	
	Create Criteria string for query from data entered thru Person search form 
	
	Called by: PersonInquiry.cfm
	Calls:
	
	Modification History:
	
	
--->
<!--- NOT NEEDED AT THIS TIME
<CF_RegisterAction 
SystemFunctionId="0101" 
ActionClass="Search" 
ActionType="Submit" 
ActionReference="Search" 
ActionScript="">   --->

<script language="JavaScript">
function AddIncidentPerson(inc, pers)
{
	window.open("IncidentPersonSubmit.cfm?ID=" + inc + "&ID1=" + pers, "IndexWindow", "width=60, height=55, toolbar=yes, scrollbars=yes, resizable=no");
}
</script>

<!---cfinclude template="Dialog.cfm"--->

<cfparam name="Form.Crit1_Value" default="">	

<cfset Criteria = ''>
<cfset vIncident = #Form.IncidentNo#>

<!--- 1. Build criteria string based on user input in calling form --->
<cfif #Form.Crit1_Value# IS NOT "">	
	<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
</cfif>	
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

<cfparam name="Form.Nationality" default="">

<cfif #Form.Nation# IS "0">
  <cfif #Form.Nationality# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "P.Nationality IN (#PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND P.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
  </cfif> 
</cfif>	

<!--- 2a. Retrieve all persons from Person table. --->
<cfquery name="SearchResult" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT P.*, PD.DocumentNo AS MissionID,
	    (CASE WHEN (DC.PersonNo IS NULL) THEN Upper(P.LastName) ELSE P.LastName + '*' END) AS sLastName		
		FROM   Person P LEFT JOIN vwMissionID PD ON P.PersonNo = PD.PersonNo
						LEFT JOIN TRAVEL.DBO.DocumentCandidate DC ON P.PersonNo = DC.PersonNo
		<cfif #PreserveSingleQuotes(Criteria)# NEQ "">
		  WHERE #PreserveSingleQuotes(Criteria)#
		  ORDER BY P.LastName, P.FirstName
	 	</cfif>
</cfquery>

<!--- 3. Display the results in a list --->
<html><head><title>Persons Inquiry - Search Results</title></head>

<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<body bgcolor="#BFDFFF">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr height="20" valign="middle">
    <td class="label">&nbsp;<b>Person Inquiry - Search Results</b></td> 
  </tr>
  
  <tr>
  <td>  
   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

  	<tr>
    <td>&nbsp;</td>
    <td>Person No</td>	
    <td>Index No</td>
    <td>First Name</td>	
    <td>Last Name</td>
    <td>Birth Date</td>
    <td>Gender</td>	
    <td>Nat</td>		
    <td>Category</td>	
    <td>Mission Id</td>		
  	</tr>

	<cfoutput query="SearchResult">
 	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
   		<td>&nbsp;
	    <a href ="javascript:AddIncidentPerson(#vIncident#,'#PersonNo#')">
    	     <img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
        </a>&nbsp;
		</td>	
		<td>#PersonNo#</td>
		<td>#IndexNo#</td>
		<td>#FirstName#</font></td>			
		<td>#sLastName#</font></td>	
		<td>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</font></td>
		<td>#Gender#</font></td>
		<td>#Nationality#</font></td>
		<td>#Category#</font></td>
		<td>#MissionId#</font></td>
  	</tr>
	</cfoutput>
   </table>
  </td>
  </tr>
</table>

<hr>

<input type="button" name="OK"    value="    Close    " onClick="window.close()"> 

</body></html>