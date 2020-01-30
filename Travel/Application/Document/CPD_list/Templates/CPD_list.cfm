<!---
	CPD_list.cfm
	
	CPD Deployment Tracking Form that is executed at the Submit Nominees to TU step
	Modification History:
	051004 - For query "IncomingPersonnel", added to WHERE condition ...DC.Status IN ('0','3')... to prevent stalled personnel from printing
	
--->
<html>

<head>
<title>Deployment Tracking Form</title>

<cfparam name="URL.Word" default="0"> 

<cfif #URL.Word# eq "1">
   <cfcontent type="application/msword">
   <cfheader name="Content-Disposition" value="filename=cpd_list.doc"> 
</cfif>

<style>

	BODY {
		color : 002350;
		font-family : Times New Roman;
		margin-top : 1px;
		margin-left : 1px;
		margin-right : 1px;
	}

	TABLE {
		font-family : Times New Roman;
		background : f6f6f6;
	}

	TD.header {
		font-family : tahoma;
		font-size : 8pt;
		background : f6f6f6;
	}

	TD {
		font-family : Times New Roman;
		color : 002350;
	}

	TD.regular {
		font-family : Times New Roman;
		font-size : 10pt;
		height : 16px;
	}
	
	TD.locregularBig { 
	font-family : Times New Roman; 
	font-size : 18pt; 
	height : 18px; 
	}
	
	HR {
		color: 6688aa;
		height: 1pt;
	}
</style>
</head>


<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<body lang=EN-US style='tab-interval:.5in'>

<cfquery name="DeskOfficer" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT FirstName + ' ' + Upper(LastName) as sFullName FROM SYSTEM.DBO.USERNAMES 
	WHERE Account LIKE '#SESSION.acc#'
</cfquery>

<!---051004 - For query "IncomingPersonnel", added to WHERE condition ...DC.Status IN ('0','3')... to prevent stalled personnel from printing--->
<cfquery name="IncomingPersonnel" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT 	Upper(P.LastName) AS sLastName, 
			Upper(Left(LTrim(P.FirstName),1)) + Substring(LTrim(P.FirstName),2,Len(LTrim(P.FirstName))) AS sFirstName, 
			P.*, DC.SatDate, PD.DocumentReference AS PassNo, PD.DateExpiration AS PassExpiry
    FROM EMPLOYEE.DBO.PERSON P INNER JOIN DocumentCandidate DC ON P.PersonNo = DC.PersonNo
	                           LEFT JOIN EMPLOYEE.DBO.vwMaxPassport PD ON P.PersonNo = PD.PersonNo
    WHERE DC.DocumentNo  = '#URL.ID#'
	AND	  DC.Status IN ('0','3')		
	ORDER BY P.LastName, P.FirstName
</cfquery>

<cfquery name="SearchResult" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Document.*, Upper(Ref_PermanentMission.Description) AS PermanentMission 
	FROM Document INNER JOIN Ref_PermanentMission ON Document.PermanentMissionId = Ref_PermanentMission.PermanentMissionId
	WHERE Document.DocumentNo = '#URL.ID#'
</cfquery>

<table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td align="right"><strong><font size="5">United Nations</font></strong></td>
    <td align="center"><CFOUTPUT><img src="#CLIENT.root#/Images/UN_LOGO_BLUE.gif" alt="" width="77" height="64" border="0"> </CFOUTPUT></td>
    <td align="left"><strong><font size="5">Nations Unies</font></strong></td>
  </tr>
  <tr>
    <td colspan="3" align="center"> <strong><font size="3">Department of Peacekeeping Operations</font></strong> </td>
  </tr>
  <tr>
    <td colspan="3" align="center"> <strong><font size="3">Police Division</font></strong> </td>
  </tr>
  <tr>
    <td colspan="3" align="center">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" align="center" height="60" class="locregularBig"><strong>DEPLOYMENT TRACKING</strong></td>
  </tr>
</table>

<p>&nbsp;</p>  <p>&nbsp;</p>  

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;Country:</td>
	<td valign="middle" class="locregularBig" width"*"><strong>&nbsp;<cfoutput>#SearchResult.PermanentMission#</cfoutput></strong></td>
  </tr>
</table>
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;No. of Officers:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#SearchResult.PersonCount#</cfoutput></strong></td>
  </tr>
</table>  
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
  
	  <!--- Evaluate Person Category value --->
	  <cfoutput>
  	  <cfif #SearchResult.PersonCategory# EQ "CPFU">
	  		<cfset perCat = "POLICE FORMED UNIT">
	  <cfelseif #SearchResult.PersonCategory# EQ "CORR">
  	  		<cfset perCat = "CORRECTIONAL OFFICER">
      <cfelse>
   	  		<cfset perCat = "POLICE">
      </cfif>
	  </cfoutput>
	
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;Category:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#perCat#</cfoutput></strong>
	</td>
  </tr>
</table>  
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;Tour of Duty:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#SearchResult.DutyLength#</cfoutput> Months</strong></td>
  </tr>
</table>  
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
  
  	<!--- Evaluate the Travel Arrangements By value --->
    <cfoutput>
	<cfif #SearchResult.TravelArrangement# EQ "U">
		<cfset tvlArr = "UN">
	<cfelse>
		<cfset tvlArr = #SearchResult.PermanentMission#>
	</cfif>
	</cfoutput>
    
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;Travel Arrangements:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#tvlArr#</cfoutput></strong></td>
  </tr>
</table>  
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;UN Mission:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#SearchResult.Mission#</cfoutput></strong></td>
  </tr>
</table>  
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;Recommended DoA:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#dateformat(SearchResult.PlannedDeployment, "dd mmmm yyyy")#</cfoutput></strong></td>
  </tr>
</table>  
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;Request Number:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#SearchResult.DocumentNo#</cfoutput></strong></td>
  </tr>
</table>
<hr>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
  <tr>
    <td height="60" valign="middle" class="locregularBig" width="50%">&nbsp;Name of Mission Manager:</td>
	<td valign="middle" class="locregularBig"><strong>&nbsp;<cfoutput>#DeskOfficer.sFullName#</cfoutput></strong></td>
  </tr>
</table>


<p>&nbsp;</p>  

<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" bordercolor="#111111" class="locregularBig" style="border-collapse: collapse">
	<td colspan="2" class="locregularBig" align="right">&nbsp;&nbsp;<strong>Signature:
      ________________________ </strong>&nbsp;</td>
</table>

<p>&nbsp;</p>  <p>&nbsp;</p>   <p>&nbsp;</p>  

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <b>
	<tr><td colspan="4" height="20"></td></tr>
	<tr><td colspan="4" height="60" align="center" class="locregularBig"><strong><u>LIST OF CANDIDATES FOR DEPLOYMENT</u></strong></td></tr>		
	<tr><td colspan="4" height="20"></td></tr>
  </b>
  <tr>
 	  <td width="20%" height="20"><font face="Times New Roman, Times, serif" pointsize="12">COUNTRY:</font></td>
	  <td width="25%" height="20"><b><font face="Times New Roman, Times, serif" pointsize="14">&nbsp;<cfoutput>#SearchResult.PermanentMission#</cfoutput></font></b></td>
	  <td width="30%" height="20"><font face="Times New Roman, Times, serif" pointsize="12">UN MISSION:</font></td>
	  <td width="25%" height="20"><b><font face="Times New Roman, Times, serif" pointsize="14">&nbsp;<b><cfoutput>#SearchResult.Mission#</cfoutput></font></b></td>		
  </tr>
  <tr>
	  <!--- Evaluate Person Category value --->
	  <cfoutput>
  	  <cfif #SearchResult.PersonCategory# EQ "CPFU">
	  		<cfset perCat = "POLICE FORMED UNIT">
	  <cfelseif #SearchResult.PersonCategory# EQ "CORR">
  	  		<cfset perCat = "CORRECTIONAL OFFICER">
      <cfelse>
   	  		<cfset perCat = "POLICE">
      </cfif>
	  </cfoutput>

 	  <td width="20%" height="20"><font face="Times New Roman, Times, serif" pointsize="12">TYPE:</font></td>
	  <td width="30%" height="20"><b><font face="Times New Roman, Times, serif" pointsize="14">&nbsp;<cfoutput>#perCat#</cfoutput></font></b>
	  </td>
	  <td width="20%" height="20"><font face="Times New Roman, Times, serif" pointsize="12">LENGTH OF DUTY:</font></td>
	  <td width="30%" height="20"><b><font face="Times New Roman, Times, serif" pointsize="14">&nbsp;<cfoutput>#SearchResult.DutyLength#</cfoutput> MONTHS</font></b></td>
  </tr>	  
  <tr><td colspan="4" height="20"></td></tr>	
</table>
	
<TABLE width="100%" align="center" border="1" cellpadding="1" cellspacing="1" bordercolor="#111111" style="border-collapse: collapse">	
	<tr>
		<td height="15" width="4%" align="center" class="regular"><font face="Times New Roman, Times, serif">&nbsp;</font></td>		
		<td width="13%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>Family Name</strong></font></td>
		<td width="13%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>First Name</strong></font></td>				
		<td width="3%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>Gender</strong></font></td>
		<td width="10%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>Date of Birth</strong></font></td>
		<td width="10%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>Date of enrollment</strong></font></td>		
		<td width="10%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>Passport Number</strong></font></td>				
		<td width="10%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>Passport Expiry Date</strong></font></td>						
		<td width="10%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>Date of SAT Test</strong> <font size="-1">(if any)</font></font></td>
		<td width="9%" align="center" class="regular"><font face="Times New Roman, Times, serif"><strong>IMIS Index</strong> <font size="-1">(UNHQ Only)</font></font></td>
	</tr>
	<cfoutput query="IncomingPersonnel">
	<tr>
		<td height="15" class="regular">&nbsp;#CurrentRow#&nbsp;</td>
		<td class="regular">&nbsp;#sLastName#&nbsp;</td>
		<td class="regular">&nbsp;#sFirstName#&nbsp;</td>				
		<td class="regular" align="center">&nbsp;#Gender#&nbsp;</td>		
		<td class="regular" align="center">&nbsp;#DateFormat(BirthDate,client.dateformatshow)#&nbsp;</td>
		<td class="regular" align="center">&nbsp;#DateFormat(ServiceJoinDate,client.dateformatshow)#&nbsp;</td>
		<td class="regular">&nbsp;#PassNo#&nbsp;</td>
		<td class="regular" align="center">&nbsp;#DateFormat(PassExpiry,client.dateformatshow)#&nbsp;</td>
		<td class="regular" align="center">&nbsp;#DateFormat(SatDate,client.dateformatshow)#&nbsp;</td>		
		<td class="regular" align="center">&nbsp;#IndexNo#&nbsp;</td>
	</tr>	
	</cfoutput>
</TABLE>
	
</body>

</html>