
<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter
</cfquery>

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*, 
       F.ExperienceFieldId,
	   F.ExperienceLevel,
	   <!---
	   F.ReviewLastName, 
	   F.ReviewFirstName,
	   F.ReviewDate,
	   --->
	   F.Status as StatusDomain,
       R.Description,
	   R.ExperienceClass,
	   S.Source,
	   C.Description as ClassDescription
    FROM ApplicantSubmission S,
	     ApplicantBackGround A, 
	     ApplicantBackgroundField F, 
		 Ref_Experience R,
		 Ref_ExperienceClass C
    WHERE S.PersonNo = '#URL.ID#'
	AND S.Source IN ('Skill','#Parameter.PHPSource#','Manual')
	AND F.ApplicantNo = S.ApplicantNo
	AND F.ApplicantNo = A.ApplicantNo
	AND R.ExperienceClass = C.ExperienceClass
	AND F.ExperienceId = A.ExperienceId
	AND A.Status < '9'
	AND A.ExperienceCategory = 'Miscellaneous'
	AND F.ExperienceFieldId = R.ExperienceFieldId 
	ORDER BY R.ExperienceClass
</cfquery>

<cfset URL.ID1="#Detail.ExperienceId#">
	
			
			<table width="100%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" frame="all">
								 
			<tr><td width="100%" colspan="2">
			    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" class="formpadding">
				<tr>
				<td colspan="5" height="23" bgcolor="E4E4E4"><b>&nbsp;<cf_tl id="Computing skills"></b></td>
		   		</tr> 
						
			<cfif detail.recordcount eq "0">
				<tr>
				<td colspan="5" align="center" class="regular"><b><cf_tl id="No records found"></b></td>
				</TR>
			
			</cfif>
			
			<cfoutput query="Detail" group="ExperienceClass">
			<TR>
			
			<td colspan="4" class="Regular">&nbsp;<b>#ClassDescription#</td>
			</tr>
			<cfoutput>
			
			<tr><td></td><td colspan="3" bgcolor="f2f2f2"></td></tr>
			
			<TR>
				<td class="Regular"></td>
			    <TD class = "Regular">&nbsp;#Description#</TD>
				<TD class = "Regular">&nbsp;
				<cfswitch expression="#ExperienceLevel#">
					<cfcase value="1"><cf_tl id="Occasional"></cfcase>
					<cfcase value="2">Daily</cfcase>
				</cfswitch>
				</TD>
				<TD class = "Regular">#DateFormat(Created,CLIENT.DateFormatShow)#</TD>
				<TD></TD>
			</TR>
			</CFOUTPUT>
			</CFOUTPUT>
			</table>
			</tr>
			</table>
						