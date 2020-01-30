<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE>Deployed Personnel by Nationality</TITLE>
</HEAD>

<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<link href="../../../print.css" rel="stylesheet" type="text/css" media="print">

<cfform action="NationalityExcel" method="POST">

<cfquery name="GetData"
datasource="AppsTravel"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT Ref_Nationality.Name, Count(Person.PersonNo) AS PersonCount
FROM (Person LEFT JOIN Ref_Nationality 
ON Person.Nationality = Ref_Nationality.Code) INNER JOIN 
    ((Organization INNER JOIN PersonAssignment 
ON Organization.OrgUnitCode = PersonAssignment.OrgUnitCode) INNER JOIN 
      Ref_Mission ON Organization.Mission = Ref_Mission.Mission) 
ON Person.PersonNo = PersonAssignment.PersonNo
WHERE Organization.Mission='UNMIK'
GROUP BY Ref_Nationality.Name ORDER BY PersonCount DESC
</cfquery>

<!--- combine --->

<cf_dialogStaffing>

<cfset CLIENT.MailSubject  = "Nationality Statistics - UNMIK">
<cfset CLIENT.MailAttach   = "../../Travel/Reporting/Nationality/NationalityMail.cfm">

<!--- Query returning search results initial approval --->
<table width="100%">
<TR>
<TD><font size="4"><b>Nationality Statistics</b></font>
</TD>
<a href="javascript:window.print()" class="noprint"><img src="../../../Images/print.jpg" alt="Print" width="25" height="21" border="0" onClick=""><font face="Tahoma" size="1"><b>Print<b></b></font></a>
<a href = "javascript:eMail()" class="noprint"> <img src="../../../Images/mail.jpg" alt="eMail this report" width="27" height="23" border="0"><font face="Tahoma" size="1"><b>eMail<b></b></font></a>
<TD><img src="../../../warehouse.JPG" alt="" width="35" height="35" border="1" align="right"></TD>
</TR>
</table>
<td valign="bottom">
<cfchart xAxisTitle="Personnel by Nationality" chartHeight=400 chartWidth=800 showxgridlines="no" 
	 showygridlines="yes" showborder="no" fontbold="no" fontitalic="no" labelformat="number" labelmask="##" 
	 show3D="yes" rotated="no" sortxaxis="no" showlegend="yes" showmarkers="no">
   <cfchartseries type="bar" query="GetData" valueColumn="PersonCount" itemColumn="Name"/>
</cfchart>
</td>
</tr>
</table>

<hr>
<input type="submit" value="  Export to Microsoft Excel  " class="noprint">
<hr>

</CFFORM>

<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</BODY></HTML>