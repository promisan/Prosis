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
<cfoutput>
<script language="JavaScript">

	function interview(id) {
	   w = #CLIENT.width# - 100;
	   h = #CLIENT.height# - 160;
	   ptoken.open("Interview/CandidateInterview.cfm?Owner=#URL.Owner#&PersonNo=#URL.ID#&InterviewId="+id, "_blank", "left=30, top=30, width=" +w+ ", height=" +h+ ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");
	}

</script>
</cfoutput>
	
	<cfquery name="detail" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT     *
	FROM       ApplicantInterview I LEFT OUTER JOIN FunctionOrganization F ON I.FunctionId = F.FunctionId	
	WHERE      I.PersonNo = '#URL.ID#'	
	AND        I.Owner = '#URL.Owner#'
	AND        I.InterviewStatus IN ('1','9')
	ORDER BY tsInterviewStart
	</cfquery>
										
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					 
<tr><td width="100%" colspan="2">

    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfif URL.Topic neq "All">
	
		<tr>
		    <td width="30"></td>
			<td class="labelit"><cf_tl id="Mode"></td>
			<td class="labelit"><cf_tl id="Date"></td>
			<td class="labelit"><cf_tl id="Time"></td>
			<td class="labelit"><cf_tl id="Vacancy"></td>
			<td class="labelit"><cf_tl id="Function"></td>
			<td class="labelit"><cf_tl id="Registered by"></td>
			<td class="labelit"><cf_tl id="Status"></td>
		</tr>
		
	</cfif>
	
	<cfif detail.recordcount eq "0">
	
	<tr><td colspan="8" style="padding-top:10px" class="labelmedium" align="center"><font color="808080"><cf_tl id="No records to show in this view"></td></tr>
		
	<cfinvoke component="Service.Access"  
	   method="roster" 
	   role="'AdminRoster'"
	   returnvariable="Access">	
				
	<cfif Access eq "EDIT">
								
		<tr>
			<td colspan="8" align="left" class="labellarge" style="padding-right:10px">			
			<a href="javascript:interview('new')">[<font color="0080C0"><cf_tl id="Register a new Interview"></b>]</a></td>
		</TR>
	
	</cfif>
	
	<cfelse>
	
	<cfinvoke component="Service.Access"  
		   method="roster" 
		   role="'AdminRoster'"
		   returnvariable="Access">	
	
	<cfif Access eq "EDIT">
	
		<tr>
			<td colspan="8" height="20" align="left" class="labellarge" style="padding-left:10px">			
			<a href="javascript:interview('new')"><font color="0080C0">[<cf_tl id="Register a new Interview">]</a></td>
		</TR>
	
	</cfif>
				
	<cfoutput query="Detail">
		
	<TR class="line labelmedium">
		<td align="center" HEIGHT="25">
			<cf_tl id="View/Edit interview notes" var="1">			
			<cf_img icon="edit" onClick="interview('#InterviewId#')">
		</td>
		<td>#InterviewMode#</td>
		<td>#DateFormat(tsInterviewStart,CLIENT.DateFormatShow)#</td>
		<td>#timeFormat(tsInterviewStart,"HH:MM")# - #timeFormat(tsInterviewEnd,"HH:MM")#</td>
		<td>#ReferenceNo#</td>
		<td>
		<cfif FunctionId neq "">
		
				<cfquery name="Function" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     *
				FROM       FunctionTitle 
				WHERE      FunctionNo = '#FunctionNo#'
				</cfquery>
				#Function.FunctionDescription# #GradeDeployment#
	
		</cfif>
		</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td><cfif InterviewStatus eq "1"><cf_tl id="Cleared"><cfelse><font color="FF5555"><cf_tl id="Denied"></cfif></td>
	</tr>
		
	<tr class="labelit"><td></td>
	    <td class="labelit"><cf_tl id="Languages"></td>
		<td colspan="6" class="labelit"><b>
					
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT LanguageName
			FROM   ApplicantLanguage A, 
			       ApplicantSubmission S,
				   Ref_Language R
			WHERE  S.ApplicantNo = A.ApplicantNo
			AND    S.PersonNo = '#URL.ID#'
			AND    R.Languageid = A.Languageid
			AND    A.Status = '1'
		</cfquery>
	
		<cfloop query="Check">#LanguageName#;&nbsp;</cfloop>
			
		</td>
		</tr>
				
		<tr><td colspan="8" style="padding-left:40px">
			
			<cfquery name="Notes" 
			datasource="appsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   T.*, S.InterviewNotes
			    FROM     ApplicantInterviewNotes S, Ref_TextArea T
				WHERE    S.InterviewId = '#InterviewId#'
				AND      T.Code = S.TextAreaCode
				ORDER BY ListingOrder
			</cfquery>
					
			<table width="99%" cellspacing="0" cellpadding="0" align="center">
			
				<cfloop query="Notes">
								
				<tr class="labelit">
				    <td width="30" align="center">
					   <img src="#SESSION.root#/Images/pointer.gif" alt="" border="0">
					<td>
					<td width="25%" class="labelit">
					    #Description#
					</td>
				    <td bgcolor="f9f9f9" width="70%">
					   <cfif InterviewNotes eq ""><font color="FF8080">[<cf_tl id="no comments">]</font>
			           <cfelse>#ParagraphFormat(InterviewNotes)#
					   </cfif>
				   </td>
				</tr>
							
				</cfloop>
				
			</table>
	
		</td></tr>
					
	</cfoutput>
	
	</cfif>
				
	</table>
</tr>
</table>
	