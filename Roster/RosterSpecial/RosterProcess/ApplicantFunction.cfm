
<cf_screentop height="100%" 
   label="Process Roster Candidacy" layout="webapp" banner="gray" line="no" jQuery="Yes" bannerheight="55" scroll="Yes">

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Applicant a, ApplicantSubmission b
    WHERE b.ApplicantNo = '#URL.ID#'
	AND a.PersonNo = b.PersonNo
</cfquery>
	
<cfquery name="Employee" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT PersonNo
FROM   Person
WHERE IndexNo = '#Detail.IndexNo#'
</cfquery>	

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT F1.FunctionId, 
       F.FunctionDescription, 
	   R.OrganizationCode, 
       R.OrganizationDescription, 
	   R.HierarchyOrder, 
	   R1.ListingOrder, 
	   R1.Description as GradeDeployment,
       A.Status, 
	   A.FunctionJustification, 
	   R2.Meaning, 
	   F1.DocumentNo, 
	   F1.ReferenceNo, 
	   R3.Owner
FROM   ApplicantFunction A, 
       FunctionTitle F, 
	   FunctionOrganization F1, 
	   Ref_Organization R, 
	   Ref_GradeDeployment R1,
	   Ref_StatusCode R2,
	   Ref_SubmissionEdition R3
WHERE  A.ApplicantNo = '#URL.ID#'
 AND   A.FunctionId = F1.FunctionId
 AND   F1.FunctionNo = F.FunctionNo
 AND   R.OrganizationCode = F1.OrganizationCode
 AND   R1.GradeDeployment = F1.GradeDeployment
 AND   R3.SubmissionEdition = F1.SubmissionEdition
 AND   R3.Owner = R2.Owner
 AND   R2.Id = 'FUN'
 AND   R2.Status = A.Status
ORDER BY R.HierarchyOrder, 
         R1.ListingOrder, 
		 F1.FunctionId, 
		 F.FunctionDescription, 
		 F1.GradeDeployment, 
         R.OrganizationCode, 
		 R.OrganizationDescription 
</cfquery>

<cfquery name="Clearance" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ApplicantReview C, 
	         Ref_ReviewClass R
	WHERE    C.PersonNo = '#Detail.PersonNo#'
	AND      C.ReviewCode = R.Code
	ORDER BY C.Created DESC
</cfquery>

<cf_DialogStaffing>

<cfparam name="URL.Mode"       default="generic">
<cfparam name="URL.Caller"     default="Substantive">
<cfparam name="URL.IDFunction" default="">
<cfset URL.IDTemplate = "reload">
<!--- Entry form --->

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR><td valign="top" colspan="7" height="20">

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="formpadding">

  <!--- Field: Applicant.Applicantion --->
    
	<cfoutput query = "Detail">
	<td rowspan=4">
		<A HREF ="javascript:ShowCandidate('#PersonNo#')"><img src="#SESSION.root#/Images/folder.JPG" alt="" name="Process" id="Process" border="0" align="middle"></b></A>
    </td>
	</cfoutput>
		
    <!--- Field: Applicant.IndexNo --->
   
    <td height="13">Employee IndexNo:</td>
    <TD>
		<cfoutput query = "Detail">
			<cfif #Employee.PersonNo# neq "">
			<A HREF ="javascript:EditPerson('#Employee.PersonNo#')">#IndexNo#</a>
			<cfelse>
			#IndexNo#
			</cfif>
		</cfoutput>
	</TD>
	
    <td height="13">Source:</td>
    <TD>	
		<cfoutput query = "Detail">#Source# #SourceOrigin#</cfoutput>
	</TD>		
	</TR>	
	
    <!--- Field: Applicant.LastName --->
    <TR>
    <TD>Name:</TD>
    <TD>
	<cfoutput query = "Detail">#FirstName# #LastName#</cfoutput>
	</TD>
	<TR>
	<td height="13">DOB:</td>
	<TD>
	<cfoutput query = "Detail">#Dateformat(DOB, CLIENT.DateFormatShow)#</cfoutput>
	</TD>
    <td height="13">Submission:</td>
    <TD>
  	<cfoutput query = "Detail">#Dateformat(SubmissionDate, CLIENT.DateFormatShow)#</cfoutput>
	</TD>	
	</TR>
	
    <!--- Field: Applicant.Nationality --->
    <TR>
    <td height="13" class="regular">Nationality</td>
    <TD class="regular">
 	<cfoutput query = "Detail">#Nationality#</cfoutput>
			
    <!--- Field: Applicant.EmailAddress --->
   
    <td height="13" class="regular">E-mail Address:</td>
    <TD class="regular">
	
		<cfoutput query = "Detail">#eMailAddress#</cfoutput>
		
	</TD>
	</TR>
	
	<cfoutput query = "Clearance">
	<TR>
	<td></td>
	<td class="labelit">#Description# :</td>
	<td></td>
	<td class="labelit">Processed by:</td>
	<td class="labelit">#OfficerFirstName# #OfficerLastName# &nbsp;on: #DateFormat(Created, CLIENT.DateFormatShow)#</td>	
	</TR>
    </cfoutput>
	
	</table>
</tr>

<tr><td height="4"></td></tr>
	
<tr><td colspan="7" class="linedotted"></td></tr>
<TR height="20">
    <TD class="labelit">Area</TD>
    <TD class="labelit">Function</TD>
	<TD class="labelit">Owner</TD>
    <TD class="labelit">Deployment Level</TD>
	<TD class="labelit">Vacancy</TD>
	<TD class="labelit">Status</TD>	
	<TD></TD>
</TR>
<tr><td colspan="7" height="1" class="linedotted"></td></tr>
<cfoutput query="FunctionAll" group="HierarchyOrder">

<CFOUTPUT>

<TR <cfif Status is '9'>bgcolor="D6DFF4"<cfelse>bgcolor="ffffff"</cfif>>
    <TD height="24">#OrganizationDescription#</TD>
	<TD>#FunctionDescription#</TD>
	<TD>#Owner#</TD>
    <TD>#GradeDeployment#</TD>
	<TD>#ReferenceNo#</TD>
	<td align="left">#Meaning# [#Status#]</td>
	
	<!--- verify if person has access to review this function --->
	
	<cfquery name="FunctionAccess" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM RosterAccessAuthorization A
    WHERE A.UserAccount = '#SESSION.acc#'
	AND A.FunctionId    = '#FunctionId#'
	AND A.AccessLevel >= '#Status#'
	</cfquery>
     
	<TD class="regular">
	<CFIF FunctionAccess.recordCount gt 1><a href="javascript:ShowFunction('#URL.ID#','#FunctionId#','#URL.Mode#')">[process]</a>
	</cfif>
	</TD>

</TR>

<CFIF FunctionJustification neq "">
	<TR><td></td><td colspan="4">#ParagraphFormat(FunctionJustification)#</td></TR>
</CFIF>


</CFOUTPUT>
</CFOUTPUT>

</table>

<cf_screenbottom layout="webapp">