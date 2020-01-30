<!---
	IncidentInquiryResult.cfm
	
	Display results of inquiry for incidents
	
	Called by: IncidentInquiry.cfm  (Post)

	Modification History:
	
--->

<CF_RegisterAction 
SystemFunctionId="1207" 
ActionClass="Incident Inquiry" 
ActionType="Inquire Incidents" 
ActionReference="" 
ActionScript="">  

<!--- tools : make available javascript for quick reference to dialog screens --->

<cf_PreventCache>

<cfinclude template="Dialog.cfm">

<cfparam name="Form.Crit1_Value" default="">	

<cfset Criteria = ''>

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

<cfif #Form.inclNation# EQ "0">
  <cfif #Form.Nationality# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "P.Nationality IN (#PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND P.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
  </cfif> 
</cfif>	

<cfparam name="Form.Mission" default="">

<cfif #Form.inclMission# EQ "0">
  <cfif #Form.Mission# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "I.Mission IN (#PreserveSingleQuotes(Form.Mission)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND I.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )" >
     </cfif>
  </cfif> 
</cfif>	

<!--- Query returning search results --->
<cfquery name="SearchResult" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT I.*, IP.PersonNo, Upper(P.LastName) + ', ' + P.FirstName AS PersonName, P.Nationality,
  		  (CASE WHEN (I.Status = 0) THEN 'Pending' ELSE 'Closed' END) AS sStat, 
       	   IO.Description as sInvestigatingOffice, D.Description as sDecision, PD.DocumentNo AS MissionID
	FROM   IncidentPerson IP INNER JOIN Incident I ON IP.Incident = I.Incident 
	                  INNER JOIN EMPLOYEE.DBO.Person P ON IP.PersonNo = P.PersonNo
	                  INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss AM ON I.Mission = AM.Mission
	   	  			  LEFT JOIN vwMissionID PD ON P.PersonNo = PD.PersonNo
       				  LEFT JOIN InvestigatingOffice IO ON I.InvestigatingOffice = IO.InvestigatingOffice
	   				  LEFT JOIN Decision D ON IP.Decision = D.Decision
	<cfif #PreserveSingleQuotes(Criteria)# NEQ "">
  	WHERE #PreserveSingleQuotes(Criteria)#
	AND P.Category IN (SELECT DISTINCT RC.Category 
                      FROM Ref_Category RC INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType AP ON RC.TravellerType = AP.PostType)
	AND P.Nationality IN (SELECT DISTINCT Code FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat)
  	ORDER BY P.LastName, P.FirstName
 	</cfif>
</cfquery>

<SCRIPT LANGUAGE = "JavaScript">
/*
function Selected(Ind,last,first,nat,sex,dob)
{

	<cfoutput>
	    var form = "#Form.FormName#";
    	var field = "#Form.FieldName#";
		eval("self.opener.document." + form + "." + field + ".value = Ind");			
		eval("self.opener.document." + form + ".LastName.value = last");
		eval("self.opener.document." + form + ".FirstName.value = first");
		eval("self.opener.document." + form + ".Gender.value = sex");
		eval("self.opener.document." + form + ".Nationality.value = nat");	
		eval("self.opener.document." + form + ".DOB.value = dob");			
	    window.close();
	</cfoutput>
}
*/
</SCRIPT>

<!---
<cf_dialogStaffing>
--->

<HTML><HEAD><TITLE>Incidents</TITLE></HEAD>
	
<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body bgcolor="#BFDFFF" class="main" onload="window.focus()" top="0", bottom="0">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr height="20" valign="middle" bgcolor="002350">
    <td class="label">&nbsp;<b>Incident Inquiry Results</b></td> 
  </tr>
  
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<tr bgcolor="#6688aa">
    <td><font size="1" face="Tahoma" color="FFFFFF">&nbsp;</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Ctr</font></td>	
    <td><font size="1" face="Tahoma" color="FFFFFF">Person(s) Involved</font></td>	
    <td><font size="1" face="Tahoma" color="FFFFFF">Nat</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Mission ID</font></td>			
    <td><font size="1" face="Tahoma" color="FFFFFF">Incident</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Mission</font></td>	
    <td><font size="1" face="Tahoma" color="FFFFFF">MissionCaseNumber</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Open Date</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Close Date</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Investigating Office</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Decision</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Stat</font></td>	
</tr>

<cfoutput query="SearchResult">
 <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
	<td rowspan="1" align="center">
	  <button class="button3" onClick="javascript:showincidentview('#SearchResult.Incident#')">
      <img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
    </td>

	<td><font size="1" face="Tahoma" color="000000">#CurrentRow#.</font></td>	  
	<td><font size="1" face="Tahoma" color="000000">#PersonName#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#Nationality#</font></td>	
	<td><font size="1" face="Tahoma" color="000000">#MissionID#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#Incident#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#Mission#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#MissionCaseNumber#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#DateFormat(OpenDate, CLIENT.DateFormatShow)#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#DateFormat(CloseDate, CLIENT.DateFormatShow)#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#sInvestigatingOffice#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#sDecision#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#sStat#</font></td>	
  </tr>
</cfoutput>

</table>

</tr>
</table>

<hr>

</body>
</div>
</html>