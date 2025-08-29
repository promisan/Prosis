<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cfset AccessRoster = "EDIT">
 
<cfquery name="Topic" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_ParameterSkill
  WHERE Code = '#URL.Topic#'
</cfquery>

<cfquery name="Competence" 
datasource="AppsSelection" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
SELECT A.Created as LastUpdated, R.*
FROM ApplicantSubmission S, ApplicantCompetence A, Ref_Competence R
WHERE A.CompetenceId = R.CompetenceId
 AND S.ApplicantNo = A.ApplicantNo
 AND S.PersonNo = '#URL.ID#'
 ORDER BY CompetenceCategory, ListingOrder
</cfquery>

<cfif AccessRoster eq "EDIT"> 

	<cfif Competence.recordcount eq "0">

	    <cfinclude template="CompetenceEntry.cfm">

	 <cfelse>
	   			
			<cfset cnt = 0>
			
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" frame="all">
			
			<cfif #CLIENT.submission# eq "Skill">
						    
				<cfset cnt = cnt + 20>
					<tr><td colspan="2" align="right">
				  <cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
				     <input class="button7" type="submit" name="editcompetence" value="Update competencies">
				  </cfif>	 
				</td></tr>
				
			</cfif>
			
			</table>
			
			<table width="100%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" frame="all">
			
			<tr>
			    <td width="100%" colspan="2">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" style="border-collapse: collapse" class="formpadding">
			 <cfif #URL.Topic# neq "All">
			 <cfset cnt = cnt + 30> 
			 <tr>
			 	<td class="top3n" colspan="5" height="23"><b>&nbsp;Competencies</b></td>
			 </tr>
			 </cfif>
						
			<cfif competence.recordcount eq "0">
			
				<cfset cnt = cnt + 17>
				<tr>
				<td colspan="5" align="center" class="regular"><b>No records found</b></td>
				</TR>
			
			</cfif>
			
			<cfoutput query="Competence">
			<cfif #CurrentRow# neq "1">
			<tr><td colspan="4" bgcolor="f2f2f2"></td></tr>
			</cfif>
			<TR>
				<cfset cnt = cnt + 19>
			    <TD class = "Regular">&nbsp;#CompetenceCategory#</TD>
			    <TD class = "Regular">&nbsp;#Description#</TD>
				<TD class = "Regular">#DateFormat(LastUpdated,CLIENT.DateFormatShow)#</TD>
				<TD></TD>
			</TR>
			
			</CFOUTPUT>
			
			</table>
			
			</tr>
			
			</table>
							
			<!---			
					
			<cfif #URL.Topic# eq "All">
			
			<cfoutput>
			
				<script language="JavaScript">
				
				{
				frm  = parent.document.getElementById("icompetence");
				
				he = #cnt#;
				frm.height = he;
				}
				
				</script>
			
			</cfoutput>
			
			</cfif>
			
			--->
	</cfif>
</cfif>	
</BODY></HTML>