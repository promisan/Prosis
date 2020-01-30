<!--- Query returning detail information for selected item --->

<cfparam name="URL.ID" default="99999"> 

<cfset CLIENT.actionClass     = "Inquiry Applicant">
<cfset CLIENT.actionType      = "View Detail">
<cfset CLIENT.actionReference = "#CLIENT.search#">
<cfset CLIENT.actionScript    = "roster/ApplicantDetail.cfm?ID=#URLEncodedFormat(URL.ID)#">

<!--- <cfinclude template="../control/RegisterAction.cfm"> --->

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Applicant
    WHERE ApplicantNo = '#CLIENT.AppNo#'</cfquery>

<HTML><HEAD>
    <TITLE>Applicant - Detail</TITLE>
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
</HEAD>

<table width="90%">
<CFOUTPUT query="Detail"> 
    <cfset CLIENT.persNo = "#PersonNo#">
    <TD align="left" valign=top><font size="3">#PersonNo# #FirstName# #LastName#</font></TD>
	
<cfif #CandidateStatus# is '0'>

 <cfquery name="Verify" 
   datasource="AppsSelection" 
   dbtype="ODBC" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT ApplicantNo
   FROM  ApplicantOccGroup
   WHERE ApplicantNo = '#CLIENT.AppNo#'
   AND   Status < '9'
   </cfquery>

   <cfif #Verify.recordCount# is 0 > 
<td valign="top"> Enter Occgroup! </td>
    <cfelse>
<td>
	</cfif>
</cfif>	
</CFOUTPUT> 

</table>
<hr>

<table width="100%">
<TR>
<td width="21%" height="38" valign="top">

<table> 
  <cfoutput query="Detail">
  <img src="Photo/#IndexNo#.jpg" alt="" name="Staffmember Picture" id="Staffmember Picture" width="95" height="119" border="0">
  </cfoutput>
  </td>
</td>
</TR>
<TR>
<CFOUTPUT query="Detail">     
    <TD valign=top><font size="1" face="Tahoma">Source:</font></TD>
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#Source#</font></TD>
</CFOUTPUT>	
</TR>
</table>

<td width="79%" height="38">
<table width="90%" border="0" cellspacing="0" cellpadding="0" bordercolor="#6699cc" style="border-collapse: collapse" class="formpadding">
<TR>

<CFOUTPUT query="Detail"> 
<TD valign=top><font size="1" face="Tahoma">Application No:</font></TD>
<td align="center" valign="top" bgcolor="FFFFFF"><font size="2">#ApplicantNo#</font></td>
</CFOUTPUT>
  

<TD valign=top><font size="1" face="Tahoma">Name:</font></TD>
<CFOUTPUT query="Detail"> 
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#FirstName# #LastName#</font></TD>
</CFOUTPUT> 

</TR>

<TD valign=top><font size="1" face="Tahoma">Gender:</font></TD>
<CFOUTPUT query="Detail">    
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">
	<cfif #Gender# IS "M">Male<cfelse>Female</cfif></font></TD>
</CFOUTPUT> 	

<TD valign=top><font size="1" face="Tahoma">Reference:</font></TD>
<CFOUTPUT query="Detail">    
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#DocumentReference#</font></TD>
</CFOUTPUT> 	

</TR>
<TR>

<CFOUTPUT query="Detail"> 
    <TD valign=top><font size="1" face="Tahoma">Nationality:</font></TD>
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#Nationality#</font></TD>
</CFOUTPUT> 

<CFOUTPUT query="Detail">
    <TD valign=top><font size="1" face="Tahoma">IndexNo:</font></TD>
    <td align="center" valign="top" bgcolor="FFFFFF"><font size="2"><a href="../PA/Search_Detail.cfm?ID=#URLEncodedFormat(IndexNo)#">#IndexNo#</A></font></td>
</CFOUTPUT>  

<TR>
<CFOUTPUT query="Detail">    
    <TD valign=top><font size="1" face="Tahoma">Date of Birth:</font></TD>
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#Dateformat(DOB, "CLIENT.DateFormatShow")#</font></TD>
</CFOUTPUT> 
   
<CFOUTPUT query="Detail">    
    <TD valign=top><font size="1" face="Tahoma">Candidate Status:</font></TD>
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#CandidateStatus#</font></TD>
    </TR>
</CFOUTPUT> 	
<TR>

<CFOUTPUT query="Detail">    
    <TD valign=top><font size="1" face="Tahoma">Processed By:</font></TD>
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#OfficerFirstName# #OfficerLastName#</font></TD>
    <TD valign=top><font size="1" face="Tahoma">Entered:</font></TD>
    <TD align="center" valign=top bgcolor="FFFFFF"><font size="2">#DateFormat(Created,"CLIENT.DateFormatShow")#</font></TD>
    </TR>
</CFOUTPUT> 	

<TR>

</font>
</TD></TR>

</TABLE>
</TABLE>
<hr>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr bgcolor="6699cc"><td>
  <p align="center"><font color="FFFFFF" face="Tahoma" size="2">Assessment</font></td></TR>
</TABLE>
<hr>
<cfinclude template="ApplicantAssView.cfm">
<hr>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr bgcolor="6699cc"><td>
  <p align="center"><font color="FFFFFF" face="Tahoma" size="2">Professional Background / Experience</font></td></TR>
</TABLE>
<hr>
<cfinclude template="ApplicantEXPView.cfm">
<cfinclude template="ApplicantLANView.cfm">
<hr>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr bgcolor="6699cc"><td>
  <p align="center"><font color="FFFFFF" face="Tahoma" size="2">Attached Documents</font></td></TR>
</TABLE>
<hr>
<cfinclude template="DocumentFileLibraryView.cfm">
 

</BODY></HTML>