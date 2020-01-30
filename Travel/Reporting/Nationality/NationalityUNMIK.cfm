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
FROM   Person INNER JOIN PersonAssignment ON Person.PersonNo = PersonAssignment.PersonNo 
		              INNER JOIN Organization.dbo.Organization ON PersonAssignment.OrgUnitCode = Organization.dbo.Organization.OrgUnitCode 
						  INNER JOIN Ref_Mission ON Organization.dbo.Organization.Mission = Ref_Mission.Mission 
			  LEFT OUTER JOIN Ref_Nationality ON Person.Nationality = Ref_Nationality.Code
WHERE  Organization.dbo.Organization.Mission = 'UNMIK'
GROUP BY Ref_Nationality.Name ORDER BY PersonCount DESC
</cfquery>

<cfloop index="i" from="1" to="#GetData.RecordCount#">
   <cfset GetData.PersonCount[i]=Round(GetData.PersonCount[i]/1)*1>
</cfloop>

<!--- 
<cf_dialogStaffing>
--->

<cfset CLIENT.MailSubject  = "Nationality Statistics - UNMIK">
<cfset CLIENT.MailAttach   = "../../Travel/Reporting/Nationality/NationalityMail.cfm">


<!--- Query returning search results initial approval --->
<table width="100%">
<tr>
  <td><font face="Tahoma" size="4"><b>Nationality Statistics - UNMIK</b></font><font face="Tahoma" size="2"><b>, as at <cfoutput>#Dateformat(now(), "#CLIENT.dateformatshow#")#</cfoutput></b></font></td>
	<a href="javascript:window.print()" class="noprint"><img src="../../../Images/print.jpg" alt="Print" width="25" height="21" border="0" onClick=""><font face="Tahoma" size="1"><b>Print<b></b></font></a>
	<!---<a href = "javascript:eMail()" class="noprint"> <img src="../../../Images/mail.jpg" alt="eMail this report" width="27" height="23" border="0"><font face="Tahoma" size="1"><b>eMail<b></b></font></a>--->
  <td><img src="../../../warehouse.JPG" alt="" width="35" height="35" border="1" align="right"></TD>
</tr>
</table>
<td valign="bottom">
<cfchart xAxisTitle="Nationality" yAxisTitle="Count" chartHeight=400 chartWidth=800 showxgridlines="no" 
	 showygridlines="yes" showborder="no" fontbold="no" fontitalic="no" labelformat="number" labelmask="##" 
	 show3D="yes" rotated="no" sortxaxis="no" showlegend="yes" showmarkers="no">
   <cfchartseries type="bar" query="GetData" valueColumn="PersonCount" itemColumn="Name" seriescolor="olive"/>
</cfchart>
</td>
</tr>
</table>

<hr>
<!---
<input type="submit" value="  Export to Microsoft Excel  " class="noprint">
<hr>--->

</CFFORM>

<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</BODY></HTML>