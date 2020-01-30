<!---
	DeploymentSummaryInquiryResult.cfm
	
	Display results of inquiry.
	
	Called by: DeploymentSummaryInquiry.cfm  (Post)

	Modification History:
	
--->
<!--- tools : make available javascript for quick reference to dialog screens --->

<cf_PreventCache>

<cfinclude template="Dialog.cfm">

<cfset Criteria = ''>

<cfparam name="Form.Nationality" default="">

<cfif #Form.inclNation# EQ "0">
  <cfif #Form.Nationality# IS NOT "">
	 <cfset #Criteria# = #Criteria#&"DS.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
  </cfif> 
</cfif>	

<cfparam name="Form.Mission" default="">

<cfif #Form.inclMission# EQ "0">
  <cfif #Form.Mission# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "DS.Mission IN (#PreserveSingleQuotes(Form.Mission)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND DS.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )" >
     </cfif>
  </cfif> 
</cfif>	

<!--- Query returning search results --->
<cfquery name="SearchResult" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DS.*
	FROM   DeploymentSummary DS INNER JOIN
		   userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss AM ON DS.Mission = AM.Mission
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
	
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

<body bgcolor="#BFDFFF">

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
	  <img src="../../Images/function.JPG" alt="" width="18" height="15" border="0"></button></td>
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

<!--- 
<input type="button" name="Print" value="    Print    " onClick="window.print()">
<input type="button" name="OK"    value="    Close    " onClick="window.close()"> --->

</BODY></HTML>