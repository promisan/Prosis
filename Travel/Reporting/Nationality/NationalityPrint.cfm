<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE>Staffing by Nationality</TITLE>
</HEAD>

wdqafqwefq2ef
qsdqwdfq
Adjusting needed
	
<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<!--- <cfinclude template="../../Control/VerifyLogin.cfm"> --->
<!--- <cfinclude template="../../Control/PreventCache.cfm"> --->

<cfform action="NationalityExcel" method="POST">

<!--- retrieve assignments --->

<!--- <cfoutput>#Form.Nationality#</cfoutput> --->

<cfif #CLIENT.DateFormatShow# is 'EU'>
   <cfset dte   = "{d '"&#Dateformat(Form.Crit3_Value, "yyyy-dd-mm")#&"'}">
<cfelse>  
   <cfset dte   = "{d '"&#Dateformat(Form.Critt3_Value, "yyyy-mm-dd")#&"'}">
</cfif>

<CFSET Criteria = ''>

<cfset Criteria = " S.Nationality IN ("& #Form.Nationality# &") "> 

<cfset Criteria = Criteria & "AND (W.ContinuousDateStart < " & #dte# &"  OR W.ContinuousDateStart IS NULL) "> 
	
<cfset Criteria = Criteria & "AND (W.AssignmentEnd > "&#dte#&"  OR W.AssignmentEnd IS NULL) "> 

<cfset Criteria = Criteria & "AND (S2.GradeEffectiveDate < "&#dte# &") ">

<cfset Criteria = Criteria & "AND (S2.StepEffectiveDate < "&#dte# &") "> 

<cfset Criteria = Criteria & "AND (W.Source = '"&#Form.Crit4_Value#&"')">  

<!--- Query returning search results initial approval --->

<CF_DropTable dbName="WarehousePMSS" tblName="#SESSION.acc#Assignment">

<cfquery name="Result"
datasource="WarehouseQuery"
username="#SESSION.login#" 
password="#SESSION.dbpw#">

SELECT DISTINCT W.IndexNo, W.Category, 
 W.PostNumber, W.Mission, W.PADocument, W.PAEffective, 
 W.MovementType, W.AssignmentEnd, W.ContinuousDateStart, 
 W.OrganizationUnit, W.OrganizationCode, W.FunctionalTitle, W.FunctionProfileCode, 
 W.FunctionProfileName, W.FunctionGroupCode, W.FunctionGroupName, 
 W.Location, W.Incumbancy, W.RegularPost, W.Installation, 
 W.Assignment, W.MissionDetail, W.Loan, W.DetailDuringAssignment, 
 W.Source, S.LastName, S.FirstName, S.Gender, S.Nationality, 
 S1.Name as NationalityLong, MAX(S2.Grade) as Grade, MAX(S2.Step) as Step 
INTO  #SESSION.acc#Assignment 
FROM WhsStaffAssign W, 
     Staff S, 
	 Ref_Nationality S1,
	 StaffPALineGrade S2,
	 Ref_Mission S3

WHERE  W.Category = 'Assignment'
  AND (S3.MissionType = 'Special' or S3.MissionType = 'Established')
  AND (S.IndexNo = W.IndexNo)
  AND S2.IndexNo =* W.IndexNo
  AND S1.Code = S.Nationality
  AND S3.Mission = W.Mission
  AND #PreserveSingleQuotes(Criteria)#
   
GROUP BY W.Mission, W.IndexNo, W.Category, 
 W.PostNumber, W.PADocument, W.PAEffective, 
 W.MovementType, W.AssignmentEnd, W.ContinuousDateStart, 
 W.OrganizationUnit, W.OrganizationCode, W.FunctionalTitle, W.FunctionProfileCode, 
 W.FunctionProfileName, W.FunctionGroupCode, W.FunctionGroupName, 
 W.Location, W.Incumbancy, W.RegularPost, W.Installation, 
 W.Assignment, W.MissionDetail, W.Loan, W.DetailDuringAssignment, 
 W.Source, S.LastName, S.FirstName, S.Gender, S.Nationality, S1.Name 
  
ORDER BY W.Mission, W.IndexNo, W.Category, 
 W.PostNumber, W.PADocument, W.PAEffective, 
 W.MovementType, W.AssignmentEnd, W.ContinuousDateStart, 
 W.OrganizationUnit, W.OrganizationCode, W.FunctionalTitle, W.FunctionProfileCode, 
 W.FunctionProfileName, W.FunctionGroupCode, W.FunctionGroupName, 
 W.Location, W.Incumbancy, W.RegularPost, W.Installation, 
 W.Assignment, W.MissionDetail, W.Loan, W.DetailDuringAssignment, 
 W.Source, S.LastName, S.FirstName, S.Gender, S.Nationality, S1.Name 

</cfquery>

<!--- combine --->

<SCRIPT LANGUAGE = "JavaScript">
function ShowPerson(Ind)
{
		window.open("../../PA/Search_Detail.cfm?ID=" + Ind, "DialogWindow", "width=700, height=520, toolbar=yes, scrollbars=yes, resizable=no");
}

function ShowPost(Pst)
{
		window.open("../../DWarehouse/InquiryPost/Search_ResultAS.cfm?ID=" + Pst, "WindowBase", "toolbar=yes, width=700, height=520, scrollbars=no, resizable=yes");
}

function eMail()
{
		window.open("../../Tools/Mail/Mail.cfm", "MailDialog", "toolbar=no, width=500, height=420, scrollbars=no, resizable=no");
}
</SCRIPT>

<!--- Query returning search results initial approval --->
<cfquery name="Result3"
datasource="WarehouseQuery"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT NationalityLong
FROM #SESSION.acc#Assignment
</cfquery>

<table width="100%">
<TR>
<TD><font size="4"><b>Summary of Employees</b></font>
</TD>
<TD>
</TD>
<TD><img src="../../../warehouse.JPG" alt="" width="40" height="40" border="1" align="right"></TD>
</TR>
<cfoutput query="Result3">
<TR><TD><font size="4"> - #NationalityLong#</font></TD></TR>
</cfoutput>
</table>

<hr>

<!-- A overall graph --->

<cfquery name="ResultAllNat"
datasource="WarehouseQuery"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT Count(*) as OnBoard
FROM #SESSION.acc#Assignment  
</cfquery>

<cfset CriteriaAll = ''>

<cfoutput>

<cfquery name="ResultAll"
datasource="WarehousePMSS"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT Count(*) as OnBoard
FROM WhsStaffAssign W, Ref_Mission S3 
WHERE S3.Mission = W.Mission
AND  (S3.MissionType = 'Special' or S3.MissionType = 'Established')
AND  (W.Category = 'Assignment')
AND  (W.ContinuousDateStart < #dte# OR W.ContinuousDateStart IS NULL)
AND  (W.AssignmentEnd > #dte# OR W.AssignmentEnd IS NULL) 
AND  (W.Source = '#Form.Crit4_Value#')
</cfquery>

</cfoutput>

<cfoutput query = "ResultAll">
  <cfset All = #OnBoard#>
</cfoutput>

<cfoutput query = "ResultAllNat">
  <cfset Nat = #OnBoard#>
 
</cfoutput>

<!-- B. level graph --->

<!--- Query returning search results initial approval --->
<cfquery name="Result1"
datasource="WarehouseQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT f.Mission, R.GradeGroup, R.GradeOrder, COUNT(*) as OnBoard
FROM #SESSION.acc#Assignment f, #SESSION.acc#Ref_Grade R
WHERE R.Grade =* f.Grade
GROUP BY R.GradeOrder, R.GradeGroup, f.Mission
ORDER BY R.GradeOrder, R.GradeGroup, f.Mission
</cfquery>

<!--- Query returning search results initial approval --->
<cfquery name="Result2"
dbtype="query" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT GradeOrder, GradeGroup, SUM(OnBoard) as OnBoard
FROM Result1
GROUP BY GradeOrder, GradeGroup
ORDER BY GradeOrder, GradeGroup
</cfquery>

<table>
<tr><td>
<cfset tot = 0>
<cfoutput query="Result1" group="GradeOrder">

<!--- Totals by mission --->

<table width="210">
<cfset sub = 0>
<cfset grp = 'zz'>
<cfoutput group="Mission">
<TR>
<td width="70"><font face="Tahoma" size="2"><b><cfif grp is not #GradeGroup#>
<cfif #GradeGroup# EQ "">N/A<cfelse>#GradeGroup#</cfif></cfif></b></font></td>
<TD><font face="Tahoma" size="1">#Mission#</font></TD>
<td width="70" align="right"><font face="Tahoma" size="1">#OnBoard#</font></td>
<cfset sub = sub + #OnBoard#>
<cfset tot = tot + #OnBoard#>
<cfset grp = #GradeGroup#>
</TR>
</CFOUTPUT>
<TR>
<TD></TD>
<TD></TD>
<TD><hr></td>
</TR>
<TR>
<TD></TD>
<TD></TD>
<td width="70" align="right"><font face="Tahoma" size="1"><b>#sub#</b></font></td>
</CFOUTPUT>
<TR>
<td width="70" align="right"><font face="Tahoma" size="2"><b><cfoutput>Total:#tot#</cfoutput></b></font></td>
</TR>
</TABLE>

</td>
<td width="60"></td>

<td valign="top">
<table>
<tr><td>
<cfchart format="flash" 
         chartHeight=200 chartWidth=500 showxgridlines="no" 
		 showygridlines="no" showborder="no" fontbold="no" fontitalic="no" labelformat="number" labelmask="##" 
		 show3D="yes" rotated="no" sortxaxis="no" showlegend="yes" showmarkers="no">
   <cfchartseries type="pie">
     <cfchartdata item="Other Nationalities" value="#All-Nat#">
	 <cfchartdata item="Selected Nationality" value="#Nat#"> 
   </cfchartseries>
</cfchart>
</td></tr>
<tr><td valign="bottom">
<cfchart format="flash" 
         chartHeight=200 chartWidth=500 showxgridlines="no" 
		 showygridlines="no" showborder="no" fontbold="no" fontitalic="no" labelformat="number" labelmask="##" 
		 show3D="yes" rotated="no" sortxaxis="no" showlegend="no" showmarkers="no">
   <cfchartseries type="bar"
   query="Result2" itemColumn="GradeGroup"
   valueColumn="OnBoard" seriescolor="##3399FF" paintstyle="raise" markerstyle="circle"/>
</cfchart>
</td></tr>
</table>
</td>
</tr>
</table>

<!--- Query returning search results initial approval --->
<cfquery name="Result2"
datasource="WarehouseQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM #SESSION.acc#Assignment f1, #SESSION.acc#Ref_Grade S
WHERE f1.Grade *= s.Grade
ORDER BY Source, Mission, GradeOrder, GradeGroup, S.Grade
</cfquery>

<hr>

<!--- Detailed information --->

<cfoutput query="Result2" group="Source">

<table width="100%">
<TR><font face="Tahoma" size="2"><b>#Source#</b></font>
</TR></table>	

<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center" bordercolor="808080">
<tr bgcolor="6688aa">
    <TD align="center"><font face="Tahoma" size="1" color="FFFFFF">PostNo</font></TD>
    <TD align="center"><font face="Tahoma" size="1" color="FFFFFF">Function</font></TD>
    <TD align="center"><font face="Tahoma" size="1" color="FFFFFF">Incum</font></TD>
    <TD align="center"><font face="Tahoma" size="1" color="FFFFFF">Name</font></TD>
    <TD align="center"><font face="Tahoma" size="1" color="FFFFFF">IndexNo</font></TD>
	<TD align="center"><font face="Tahoma" size="1" color="FFFFFF">Gender</font></TD>
	<TD align="center"><font face="Tahoma" size="1" color="FFFFFF">Nationality</font></TD>
	<TD align="center"><font face="Tahoma" size="1" color="FFFFFF">Grade</font></TD>
	<TD align="center"><font face="Tahoma" size="1" color="FFFFFF">Assign. End</font></TD>
</TR>

<cfoutput group="Mission">
<cfset #incumM# = 0>

<TR><TD><hr></TD><TD><hr></TD><TD><hr></TD><TD><hr></TD><TD><hr></TD><TD><hr></TD><TD><hr></TD><TD><hr></TD><TD><hr></TD><TD><hr></TD></TR>
<TR><TD><font face="Tahoma" size="1"><b>#Mission#</b></font></TD></TR>

<cfoutput group="GradeGroup">
<cfset #incum# = 0>
<TR><TD><font face="Tahoma" size="1"><b>#GradeGroup#</b></font></TD></TR>
<CFOUTPUT>
<cfif #Incumbancy# gt 0>
     <cfset #incum# = #incum# + 1>
	 <cfset #incumM# = #incumM# + 1>
</cfif>
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('D6DEE4'))#">
<TD align="left"><font face="Tahoma" size="1"><A HREF ="javascript:ShowPost('#PostNumber#')">&nbsp;&nbsp;#PostNumber#</A></font></TD>
<TD align="left"><font face="Tahoma" size="1">#FunctionalTitle#</font></TD>
<TD align="left"><font face="Tahoma" size="1">#Incumbancy#</font></TD>
<TD align="left"><font face="Tahoma" size="1"><A HREF ="javascript:ShowPerson('#IndexNo#')">#LastName#, #FirstName#</A></font></TD>
<TD align="left"><font face="Tahoma" size="1"><A HREF ="javascript:ShowPerson('#IndexNo#')">#IndexNo#</A></font></TD>	
<TD align="left"><font face="Tahoma" size="1">#Gender#</font></TD>
<TD align="left"><font face="Tahoma" size="1">#Nationality#</font></TD>
<td align="left"><font face="Tahoma" size="1">#Grade#/#Step#</font></td>
<td align="left"><font face="Tahoma" size="1">#Dateformat(AssignmentEnd, CLIENT.DateFormatShow)#</font></td>
</TR>
</CFOUTPUT>
</CFOUTPUT>
<TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD>
<font face="Tahoma" size="1"><b>Subtotal: #IncumM#</b></font>
</TD>
<TR>
</TR></CFOUTPUT>

</TABLE>
<p></p>

</CFOUTPUT>

<hr>

<input type="button" value="      eMail this report      " onClick="javascript:eMail()">
<INPUT type="submit" value="  Export to Microsoft Excel  ">
<hr>

</CFFORM>

<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</BODY></HTML>