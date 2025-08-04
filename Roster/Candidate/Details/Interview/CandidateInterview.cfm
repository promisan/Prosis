<!--
    Copyright © 2025 Promisan

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

<cf_dialogStaffing>
<cf_textareascript>

<cf_screentop height="100%" layout="webapp" jquery="Yes" line="no" banner="blue" scroll="Yes" label="Interview Record" systemmodule="Roster" 
			  functionclass="Window" 
			  functionName="Interview Candidate">
   
<cfparam name="URL.InterviewId" default="new">	

<cfquery name="Init" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ApplicantInterview 
	WHERE InterviewStatus = '0'
	AND   Owner = '#URL.Owner#'
	AND   OfficerUserId   = '#SESSION.acc#'
</cfquery>

<cfif URL.InterviewId eq "new">
	<!--- assign a unique identifier --->
	<cf_AssignId>
	<cfset URL.InterviewId = RowGuid>
	
	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ApplicantInterview 
		(PersonNo, 
		 InterviewId,
		 Owner,
		 InterviewStatus,
		 TsInterviewStart,
		 TsInterviewEnd,
		 OfficerUserId, 
		 OfficerLastName, 
		 OfficerFirstName)
		VALUES
		('#URL.PersonNo#',
		 '#URL.InterviewId#',
		 '#URL.Owner#',
		 '0',
		 getDate(),
		 getDate(),
		 '#SESSION.acc#',
		 '#SESSION.last#',
		 '#SESSION.first#')
	</cfquery>
		
</cfif>

<cfparam name="URL.Domain" default="Preliminary">	
   
<cfquery name="Doc" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       ApplicantInterview I LEFT OUTER JOIN FunctionOrganization F ON I.FunctionId = F.FunctionId
	WHERE      I.InterviewId = '#URL.InterviewID#'
	AND        I.Owner = '#URL.Owner#'
</cfquery>
	
<cfif CLIENT.width lte "1024">
 <cfset col = "120">
<cfelse>
 <cfset col = "130">
</cfif> 

<cf_divscroll>

<cfform action="CandidateInterviewSubmit.cfm?PersonNo=#URL.PersonNo#&InterviewId=#URL.InterviewId#&domain=#URL.Domain#" method="POST" >
  
<table width="95%" cellspacing="0" cellpadding="0" align="center" id="header" class="formpadding">
		  
	<tr><td height="9"></td></tr>	  
	<cfif doc.functionId neq "">  
	
    <TR>
	
	    <td height="20" width="20%" class="labelmedium"><cf_tl id="Vacancy no">:</td>
		<td width="30%" bgcolor="white" class="labelmedium">
			<cfoutput><b>#Doc.ReferenceNo#</cfoutput>
		</td>
		<TD width="20%"></td>
	    <td width="30%" bgcolor="white">
		</td>
		</TR>
   	
	<cfquery name="Function" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       FunctionTitle 
		WHERE      FunctionNo = '#doc.FunctionNo#'
	</cfquery>
			
	<TR>
    <TD height="20" class="labelmedium"><cf_tl id="Functional title">:</TD>
    <TD bgcolor="white" class="labelmedium">
		<cfoutput><b>#Function.FunctionDescription#</cfoutput>
	</TD>
	<td class="labelmedium"><cf_tl id="Grade">:&nbsp;</td>
	<td bgcolor="white" class="labelmedium">
		<cfoutput><b>#Doc.GradeDeployment#</cfoutput>
	</td>
	</TR>	
	
	</cfif>
		
	<cfquery name="Candidate" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	      SELECT   *
		  FROM     Applicant
		  WHERE    PersonNo = '#Doc.PersonNo#'
	</cfquery>
	
	<TR>	
	    <td width="20%" height="25" class="labelmedium"><cfoutput>#client.IndexNoName#:</cfoutput></td>
		<TD width="20%" bgcolor="white" class="labelmedium">
			<cfoutput><b><cfif Candidate.IndexNo eq ""><cf_tl id="Not defined"><cfelse>#Candidate.IndexNo#</cfif></cfoutput> 
		</TD>
		<td class="labelmedium"><cf_tl id="Name">:&nbsp;</td>
	    <TD class="labelmedium" bgcolor="white"> 
		   <cfoutput><b>#Candidate.FirstName# #Candidate.LastName#</cfoutput>
		</TD>
	</TR>
		
	<cfif SESSION.isAdministrator eq "Yes" or SESSION.isOwnerAdministrator neq "No" or SESSION.acc eq doc.OfficerUserid or doc.recordcount eq "0">	
	    <cfset mode = "edit">
	<cfelse>
	    <cfset mode = "view">
	</cfif>
		
	<cfoutput>
	
	<tr><td height="20" class="labelmedium"><cf_tl id="Mode">:</td>	
		<td colspan="3" bgcolor="white" class="labelit">

		  <cfif mode eq "edit">
		  <select name="InterviewMode" class="regularxl enterastab">
			<option value="Telephone" <cfif doc.InterviewMode eq "Telephone" or doc.InterviewMode eq "">selected</cfif>SELECTED><cf_tl id="Telephone"></option>
			<option value="Meeting"   <cfif doc.InterviewMode eq "Meeting">selected</cfif>><cf_tl id="Meeting"></option>
		  </select>	
		  <cfelse>
			  #doc.InterviewMode#
		  </cfif>
					
		</td>
	</tr>
	
	<tr><td height="20" class="labelmedium"><cf_tl id="Owner">:
	</td>
	
	<td colspan="3" bgcolor="white" class="labelmedium">
	  <cfif mode eq "edit">	  
		  <input type="text" class="regularxl enterastab" name="Owner" value="#URL.Owner#" READONLY>	  
	  <cfelse>
		  #doc.Owner#
	  </cfif>
					
	</td>
	</tr>
	
	</cfoutput>
		
	<tr><td height="20" class="labelmedium"><cf_tl id="Interview time">:
	</td>
	
	<td colspan="3" bgcolor="white" class="labelit">
	
	<!--- define access --->
			
	<cfoutput>
	
	<cf_calendarscript>

	<cfif mode eq "edit">	
	
		<table cellspacing="0" cellpadding="0"><tr><td>
	
		<cf_intelliCalendarDate9
			FieldName="DateInterviewStart" 
			Default="#Dateformat(doc.TsInterviewStart, '#CLIENT.DateFormatShow#')#"
			AllowBlank="false"
			class="regularxl enterastab">	
		
		</td>
		
		<cfif Timeformat(doc.TsInterviewStart, 'HH') eq "">
		   <cfset tah = "12">
		   <cfset tam = "00">
		<cfelse>
		   <cfset tah = "#Timeformat(doc.TsInterviewStart, 'HH')#">
		   <cfset tam = "#Timeformat(doc.TsInterviewStart, 'MM')#">
		</cfif>
						
		<cfif Timeformat(doc.TsInterviewEnd, 'HH') eq "">
		   <cfset teh = "12">
		   <cfset tem = "00">
		<cfelse>
		   <cfset teh = "#Timeformat(doc.TsInterviewEnd, 'HH')#">
		   <cfset tem = "#Timeformat(doc.TsInterviewEnd, 'MM')#">
		</cfif>
			
		<td style="padding-left:4px" class="labelmedium">		
		<cf_tl id="From">:
		</td>
		<td style="padding-left:4px">	
		<cf_tl id="Please enter a valid hour" var="1" class="message">
		
		<cfinput type="Text" 
			name="HourInterviewStart" 
			range="1,24" 
			value="#tah#"
			message="#lt_text#" 
			validate="integer" 
			required="Yes" 
			size="1" 
			maxlength="2" 
			class="regularxl enterastab" 
			style="text-align: center;">
			
		</td>
		<td style="padding-left:4px" class="labelmedium">		
		:
		</td>
		<td style="padding-left:4px" class="labelmedium">	
		<cf_tl id ="Please enter a valid hour" var="1" class="message">
		
		<cfinput type="Text" 
	         name="MinuteInterviewStart" 
			 range="0,60" 
			 value="#tam#"
			 message="#lt_text#" 
			 validate="integer" 
			 required="Yes" 
			 size="1" 
			 maxlength="2" 
			 style="text-align: center;" 
			 class="regularxl enterastab">
			 
		</td>
		<td style="padding-left:9px" class="labelmedium">		 
			 
		<cf_tl id="Until">:
		</td>
		<td style="padding:left:4px">	
				
		<cf_tl id="Please enter a valid hour" var="1" class="message">
		<cfinput type="Text" 
			name="HourInterviewEnd" 
			range="1,24" 
			value="#teh#"
			message="#lt_text#"
			validate="integer" 
			required="Yes" 
			size="1" 
			maxlength="2" 
			class="regularxl enterastab" 
			style="text-align: center;">
			
		</td>
		<td style="padding-left:4px">		
		:
		</td>
		<td style="padding-left:4px" class="labelmedium">	
		<cf_tl id="Please enter a valid hour" var="1" class="message">
		<cfinput type="Text" 
	         name="MinuteInterviewEnd" 
			 range="0,60" 
			 value="#tem#"
			 message="#lt_text#" 
			 validate="integer" 
			 required="Yes" 
			 size="1" 
			 maxlength="2" 
			 style="text-align: center;" 
			 class="regularxl enterastab">
			 
			 </td></tr></table>
					
		<cfelse>
		
			<b>#Dateformat(doc.TsInterviewStart, '#CLIENT.DateFormatShow#')# </b>
			&nbsp;<cf_tl id="from">:&nbsp; <b>#Timeformat(doc.TsInterviewStart, 'HH:MM')#</b>  
			&nbsp;<cf_tl id="to">:&nbsp; <b>#Timeformat(doc.TsInterviewEnd, 'HH:MM')#</b>
		
		</cfif>
					
		</cfoutput>
		
	</td>
		
	</tr>
			
	<tr>
	<td height="20" class="labelmedium"><cf_tl id="Panel members">:</td>
	<td colspan="3">
	
	<cfif mode eq "edit">	
	
		<cfoutput>
		<iframe src="CandidateInterviewPanel.cfm?dialog=1&PersonNo=#URL.PersonNo#&InterviewId=#URL.InterviewId#" name="panel" id="panel" width="100%" height="100" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></iframe>
		</cfoutput>
	
	<cfelse>	
		<cfinclude template="CandidateInterviewPanel.cfm">	
	</cfif>
	
	</td>
	
	</tr>
	
	<tr>
	<td class="labelmedium"><cf_tl id="Language">:</td>
	<td colspan="3" class="labelit">
		
	<cfquery name="Language" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Language
	WHERE  LanguageClass = 'Official' 
	</cfquery>
	
	<cfoutput query="Language">
	
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT A.Languageid
			FROM   ApplicantLanguage A, ApplicantSubmission S
			WHERE  S.ApplicantNo = A.ApplicantNo
			AND    S.PersonNo   = '#URL.PersonNo#'
			AND    A.Languageid = '#LanguageId#'
			AND    A.Status = '1'
		</cfquery>
		
		<input type="checkbox" class="radiol"
		   name="Select_#CurrentRow#" 
		   value="1" 
		   <cfif #Check.recordcount# eq "1">checked</cfif>>
		   &nbsp;#LanguageName#&nbsp;
	
	</cfoutput>
		
	</td></tr>
			
	<tr><td colspan="4">
		
	 <cf_ApplicantTextArea
		Table           = "ApplicantInterviewNotes" 
		Domain          = "#URL.Domain#"
		Format          = "Mini"
		Height          = "90"
		FieldOutput     = "InterviewNotes"
		Mode            = "#Mode#"
		Key01           = "InterviewId"
		Key01Value      = "#URL.InterviewId#">
							
	</td></tr>
			
	<cfif mode eq "edit">	
	   
		<tr>
		<td colspan="2" class="labelit"><cf_tl id="Status"> :<input class="radiol" type="radio" name="InterviewStatus" value="9" <cfif Doc.InterviewStatus eq "9">checked</cfif>><cf_tl id="Denied">
		    <input type="radio" class="radiol" name="InterviewStatus" value="1" <cfif #Doc.InterviewStatus# neq "9">checked</cfif>><cf_tl id="Cleared"></td>
		<td colspan="2" align="right" style="padding-right:10px">
		<input type="submit" class="button10g" name="Submit" value="Save">
		</td></tr>
		<tr><td style="height:20px"></td></tr>
	</cfif>
				
</table>	

</cfform>

</cf_divscroll>

<cf_screenbottom layout="innerbox">

