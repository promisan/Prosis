<!---
	FaxRequestToPm.cfm
	
	Rotation Fax body and rotating personnel list
	
	Modification History:

--->
<html>
<head>
<title>Request to Permanent Missions for Nominees</title>

<cfparam name="URL.Word" default="0"> 

<cfif #URL.Word# eq "1">
   <cfcontent type="application/msword">
   <cfheader name="Content-Disposition" value="filename=faxtopm.doc"> 
</cfif>

<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

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
		font-size : 11pt; 
		color : 002350;
	}

	TD.regular {
		font-family : tahoma;
		font-size : 8pt;
		height : 15px;
	}

	TD.regularBig { 
	font-size : 10pt; 
	height : 13px; 
	}
	
	TD.regularBig1 { 
	font-size : 10pt; 
	height : 13px; 
	}
	
	HR {
		color: 6688aa;
		height: 1pt;
	}
</style>
</head>

<body lang=EN-US style='tab-interval:.5in'>

<!--- Query for the rotating fax body (page 1-2) --->
<cfquery name="SearchResult" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT Document.*,  
	Upper(Ref_PermanentMission.Description) AS PermanentMission,  
	Ref_PermanentMission.NationalityCode, 
	Ref_PermanentMission.FaxNo, 
	MissionSeniorOfficial.SeniorOfficial, 
	MissionSeniorOfficial.Title, 
	DATEADD("m",-1,(Document.PlannedDeployment-4)) AS sReplyDeadline, sQtrYr = 
	CASE WHEN DATEPART("qq",GetDate()) = 1 THEN 'FIRST QUARTER 2004'
             WHEN DATEPART("qq",GetDate()) = 2 THEN 'SECOND QUARTER 2004'
             WHEN DATEPART("qq",GetDate()) = 3 THEN 'THIRD QUARTER 2004'
             ELSE 'FOURTH QUARTER 2004'
        END
FROM Document INNER JOIN Ref_PermanentMission ON Document.PermanentMissionId = Ref_PermanentMission.PermanentMissionId
              INNER JOIN MissionSeniorOfficial ON Document.Mission = MissionSeniorOfficial.Mission
WHERE Document.DocumentNo = '#URL.ID#'
</cfquery>

<!--- Query for the rotating personnel list (page 3) --->
<cfquery name="RotatingPersonnel" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Upper(P.LastName) AS sLastName, P.FirstName, PA.DateArrival, PA.DateExpiration, PA.DateDeparture, R.ShortDesc AS sRank, P.Category,
	       DateAdd("m",-1,(PA.DateDeparture-4)) AS NominationDeadline
    FROM DocumentRotatingPerson DRP INNER JOIN 
		 EMPLOYEE.DBO.Person P ON DRP.PersonNo = P.PersonNo INNER JOIN 
		 vwMaxPersonAssignment MPA ON DRP.PersonNo = MPA.PersonNo INNER JOIN 
		 EMPLOYEE.DBO.PersonAssignment PA ON PA.PersonNo = MPA.PersonNo
				AND CONVERT(Char(10), PA.DateArrival, 20) + CONVERT(Char(10), PA.DateDeparture, 20) + CONVERT(Char(10), PA.Created, 20) = MPA.MaxAssignmentDate INNER JOIN 
		 EMPLOYEE.DBO.Position PO ON PA.PositionNo = PO.PositionNo LEFT JOIN 
 		 Ref_Rank R ON P.Rank = R.Rank
    WHERE 	DRP.DocumentNo = '#URL.ID#'
	ORDER BY PA.DateDeparture, P.Nationality, P.LastName, P.FirstName
</cfquery>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right"><strong><font size="5">United Nations</font></strong></td>
    <td align="center"><CFOUTPUT><img src="#CLIENT.root#/Images/UN_LOGO_BLUE.gif" alt="" width="77" height="64" border="0"> </CFOUTPUT></td>
    <td align="left"><strong><font size="5">Nations Unies</font></strong></td>
  </tr>
  <tr>
    <td colspan="3" align="center"> <strong><font size="3">Department of Peacekeeping Operations</font></strong> </td>
  </tr>
  <tr>
    <td colspan="3" align="center"><font size="2">Military Adviser's Office</font></td>
  </tr>
  <tr>
    <td colspan="3" align="center">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" align="center"><strong><font size="3">FACSIMILE TRANSMISSION</font></strong> </td>
  </tr>
</table>
<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#111111" class="regularBig2" style="border-collapse: collapse">
  <tr>
    <td valign="top" class="regularBig1" colspan="2">&nbsp;Outgoing Fax Req.:&nbsp;
	          <cfoutput>#SearchResult.NationalityCode#</cfoutput>-<cfoutput>#dateformat(Now(),client.dateformatshow)#-(#URL.ID#)</cfoutput></td>
    <td align="right" valign="top" class="regularBig1">Date:&nbsp;<cfoutput>#dateformat(Now(),client.dateformatshow)#</cfoutput>&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" valign="top">
	   <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="16%" valign="top" class="regularBig1">&nbsp;TO /<br>&nbsp;A:</td>
          <td width="*" valign="top" class="regularBig1"><cfoutput>PERMANENT MISSION OF #SearchResult.PermanentMission# TO THE UNITED NATIONS</cfoutput></td>
        </tr>
        <tr>
          <td valign="top" class="regularBig1">&nbsp;FAX:</td>
          <td valign="top" class="regularBig1"><cfoutput>#SearchResult.FaxNo#</cfoutput></td>
        </tr>
      </table>
    </td>
    <td valign="top">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="20%" valign="top" class="regularBig1">&nbsp;FROM /<br>&nbsp;DE:</td>
          <td width="*" valign="top" class="regularBig1">Lt.Gen. Chikadibia I.
            Obiakor<br>
          Military Adviser for</td>
		 </tr>
        <tr>
          <td valign="top" class="regularBig1">&nbsp;</td>		  		  
          <td valign="top" class="regularBig1">Peacekeeping Operations</td>
</tr>
<tr>	
          <td valign="top" class="regularBig1">&nbsp;</td>		  		  
          <td valign="top" class="regularBig1">DPKO, UNHQ, New York</td>		  		  
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="8%" valign="top" class="regularBig1">&nbsp;INFO:</td>
	<td width="40%" valign="top" class="regularBig1"><cfoutput>													&nbsp;#SearchResult.Title#,<br> 
		#SearchResult.Mission#
	</cfoutput></td>
    <td width="*" valign="top" class="regularBig1">&nbsp;ORIGINATOR:<br>
										 &nbsp;MAJ FLORIN STANCIU<br>
										 &nbsp;FORCE GENERATION SERVICE</td>
  </tr>
  <tr>
    <td valign="top" class="regularBig1">&nbsp;<strong>ATTN</strong>:<br>&nbsp;FAX:</td>
	<td valign="top" class="regularBig1">&nbsp;<strong>CMPO</strong></td>
    <td valign="top" class="regularBig1">&nbsp;FAX: 1-212-963-1356,<br>&nbsp;TEL: 1-917-367-5008</td>
  </tr>  
  <tr>
    <td colspan="2" valign="top" class="regularBig1">&nbsp;NUMBER OF TRANSMITTED
      PAGES :  3</td>
    <td valign="top" class="regularBig1">&nbsp;FILE REF:  <cfoutput>#SearchResult.Mission#&nbsp;/&nbsp;#SearchResult.PermanentMission#</cfoutput></td>
  </tr>
  <tr>
    <td valign="top" class="regularBig1">&nbsp;SUBJ:</td>
    <td colspan="2" valign="top" class="regularBig1">&nbsp;ROTATION OF <cfoutput>#SearchResult.PersonCategory# - REQUEST FOR REPLACEMENTS</cfoutput></td>
  </tr>
</table>

<TABLE width="100%" align="center" style="page-break-after: always;">
	<tr><td colspan="4" height="5"></td></tr>
	<TR>
	<TD colspan="4" class="regularBig2">
	
	<p align="justify">
	1.  THE PRESENT TOUR OF DUTY (TOD) OF THE ATTACHED LIST OF MILITARY OFFICERS IS DUE TO EXPIRE AS INDICATED AND WILL REQUIRE REPLACEMENTS.</p>
	<p align="justify">
	2.  THE NOMINATED OFFICERS SHOULD BE:</p>
	<p align="justify">	
	(a) CURRENTLY ON ACTIVE DUTY WITH A MINIMUM OF FIVE YEARS REGULAR MILITARY
	  SERVICE EXPERIENCE;</p>
	<p align="justify">	
	(b) ) IN THE RANK OF CAPTAIN/MAJOR.  <b><u>(UNMOS MUST BE
	BETWEEN THE AGE OF 25 AND 55)</u></b>;</p>
	<cfif #SearchResult.NationalityCode# NEQ "UK" AND
	  	  #SearchResult.NationalityCode# NEQ "USA" AND 
		  #SearchResult.NationalityCode# NEQ "AUL" AND
		  #SearchResult.NationalityCode# NEQ "NZE">
		<p align="justify">		
		(c)  PROFICIENT IN BOTH SPOKEN AND WRITTEN ENGLISH (THE WORKING LANGUAGE OF THE MISSION) AND SHOULD BE ABLE TO WRITE/TYPE HIS/HER OWN REPORTS;</p>
		<p align="justify">	
		(d)  IN POSSESSION OF A NATIONAL OR INTERNATIONAL DRIVING LICENSE, ABLE TO DRIVE A STANDARD SHIFT/4X4 VEHICLE IN RUGGED TERRAIN, HAVE AT LEAST TWO YEARS OF RECENT DRIVING EXPERIENCE, AND BE CAPABLE OF CONDUCTING THE DAILY MAINTENANCE ON LIGHT MILITARY VEHICLES;</p>
		<p align="justify">	
		(e)  BE PHYSICALLY FIT AND ABLE TO WORK IN VERY HARSH/ADVERSE WEATHER CONDITIONS.</p>
     <cfelse>		
		<p align="justify">&nbsp;</p>		
		<p align="justify">&nbsp;</p>		
		<p align="justify">&nbsp;</p>				
		<p align="justify">	
		(c)  IN POSSESSION OF A NATIONAL OR INTERNATIONAL DRIVING LICENSE, ABLE TO DRIVE A STANDARD SHIFT/4X4 VEHICLE IN RUGGED TERRAIN, HAVE AT LEAST TWO YEARS OF RECENT DRIVING EXPERIENCE, AND BE CAPABLE OF CONDUCTING THE DAILY MAINTENANCE ON LIGHT MILITARY VEHICLES;</p>
		<p align="justify">	
		(d)  BE PHYSICALLY FIT AND ABLE TO WORK IN VERY HARSH/ADVERSE WEATHER CONDITIONS.</p>	 
	 </cfif>
 	<p>&nbsp;</p>
	<p>&nbsp;</p>
	</TD>
	</TR>
</TABLE>

<!--- page break --->
<p class=MsoNormal>&nbsp;</p>
	
<table width="100%" border="0" cellpadding="0" cellspacing="0">	
  	<tr>
    <td align="right"><strong><font size="5">United Nations</font></strong></td>
    <td align="center"><CFOUTPUT><img src="#CLIENT.root#/Images/UN_LOGO_BLUE.gif" alt="" width="77" height="64" border="0"> </CFOUTPUT></td>
    <td align="left"><strong><font size="5">Nations Unies</font></strong></td>
 	</tr>
	<tr><td colspan="3" height="5"></td></tr>
	<tr><td colspan="3" align="centre"><div align="center"><font size="2" face="Times New Roman, Times, serif">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 2 - </font></div></td></tr>
	<tr><td colspan="3" height="5"></td></tr>
</table>
	
<TABLE width="100%" align="center" style="page-break-after: always;">
  	<tr><td colspan="4" height="5"></td></tr>

	<TR>
	<TD colspan="4" class="regularBig2">

	<p align="justify">
	3.  NOMINATION OF <strong><u>FEMALE OFFICERS</u></strong> TO PEACEKEEPING OPERATIONS IS ENCOURAGED.
	<p align="justify">
	4.  IN ADDITION, KNOWLEDGE OF FRENCH AND STAFF TRAINING OR STAFF EXPERIENCE IS DESIRABLE, BUT NOT ESSENTIAL.
	<p align="justify">
	5.  THE REPLACEMENT OFFICER IS REQUIRED TO ARRIVE IN THE MISSION AREA FOUR (4) DAYS PRIOR TO DEPARTURE OF HIS/HER PREDECESSOR.
	<p align="justify">
	6.  IT WOULD BE APPRECIATED IF A REPLY, INCLUDING THE FOLLOWING COMPLETED FORMS/DOCUMENTS COULD BE RECEIVED AT THE FORCE GENERATION SERVICE (ROOM U-200, 801 U.N. PLAZA, FAX 212-963-1356) AS EARLY AS POSSIBLE, BUT NOT LATER THAN  <strong><u><cfoutput>#dateformat(SearchResult.sReplyDeadline, CLIENT.dateformatshow)#</cfoutput></u></strong>;

	<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td width="2%">&nbsp;</td>
	<td width="2%">&nbsp;</td>
	<td width="*" colspan="2" class="regularBig2">- UNITED NATIONS ENTRY MEDICAL EXAMINATION (MS-2 FORM). MEDICAL EXAMINATION SHOULD HAVE BEEN CONDUCTED WITHIN THE LAST SIX MONTHS TO BE VALID.</td>
	</tr>	
	<tr>
	<td width="2%">&nbsp;</td>
	<td width="2%">&nbsp;</td>
	<td width="*" colspan="2" class="regularBig2">-PERSONAL HISTORY FORM FOR MILITARY
	  PERSONNEL- 01 Feb 06</td>
	</tr>	
	<tr>
	<td width="2%">&nbsp;</td>
	<td width="2%">&nbsp;</td>
	<td width="*" colspan="2" class="regularBig2">&nbsp;</td>
	</tr>
	</table>

	<p align="justify">	
	7.  PLEASE BE ADVISED THAT ALL MILITARY OFFICERS REPORTING TO FIELD MISSIONS ARE TESTED FOR THE ABILITY TO DRIVE A STANDARD SHIFT MOTOR VEHICLE.  IN ACCORDANCE WITH THE STANDARD UNITED NATIONS PROCEDURES AND THE MISSION'S GUIDELINES, ANY OFFICER FAILING TO DEMONSTRATE ADEQUATE PROFICIENCY WILL BE PROCESSED FOR REPATRIATION AT THE EXPENSE OF THE CONTRIBUTING GOVERNMENT.
	<p align="justify">
	8.  BEST REGARDS.
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>		
	</TD>
	</TR>	
</TABLE>

<!--- page break --->
<p class=MsoNormal>&nbsp;</p>

<table width="100%" border="0" cellpadding="0" cellspacing="0">	
  	<tr>
    <td align="right"><strong><font size="5">United Nations</font></strong></td>
    <td align="center"><CFOUTPUT><img src="#CLIENT.root#/Images/UN_LOGO_BLUE.gif" alt="" width="77" height="64" border="0"> </CFOUTPUT></td>
    <td align="left"><strong><font size="5">Nations Unies</font></strong></td>
 	</tr>
	<tr><td colspan="3" height="5"></td></tr>
	<tr><td colspan="3" align="centre"><div align="center"><font size="2" face="Times New Roman, Times, serif">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 3 - </font></div></td></tr>
	<tr><td colspan="3" height="20"></td></tr>
	<tr><td colspan="3" height="5" align="center"><u><b>ROTATION OF MILITARY PERSONNEL (<cfoutput>#SearchResult.PermanentMission#)</cfoutput></b></u></td></tr>		
	<tr><td colspan="3" height="20"></td></tr>
</table>
	
<TABLE width="100%" align="center" border="1" cellpadding="1" cellspacing="1" bordercolor="#111111" style="border-collapse: collapse">	
	<tr>
		<td class="regularBig1">&nbsp;</td>
		<td class="regularBig1" align="center">Rank</td>
		<td class="regularBig1" align="center">First Name</td>
		<td class="regularBig1" align="center">Last Name</td>				
		<td class="regularBig1" align="center">Appointment</td>
		<td class="regularBig1" align="center">Tour of Duty End</td>
		<td class="regularBig1" align="center">Nomination Deadline</td>		
	</tr>
	<cfoutput query="RotatingPersonnel">
	<tr>
		<td class="regularBig1">#CurrentRow#.</td>
		<td class="regularBig1">&nbsp;#sRank#&nbsp;</td>
		<td class="regularBig1">&nbsp;#FirstName#&nbsp;</td>
		<td class="regularBig1">&nbsp;#sLastName#&nbsp;</td>				
		<td class="regularBig1" align="center">&nbsp;#Category#&nbsp;</td>
		<td class="regularBig1" align="center">&nbsp;#DateFormat(DateDeparture,client.dateformatshow)#&nbsp;</td>
		<td class="regularBig1" align="center">&nbsp;#DateFormat(NominationDeadline,client.dateformatshow)#&nbsp;</td>		
	</tr>	
	</cfoutput>
</TABLE>
</body>
</html>