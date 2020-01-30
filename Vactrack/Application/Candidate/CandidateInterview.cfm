
<cfoutput>
	<cf_screentop height="100%" jQuery="Yes" layout="webapp" label="Interview for Track:#URL.DocumentNo#" scroll="Yes">
</cfoutput>

<cf_dialogStaffing>

<script language="JavaScript">

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "";		
	 }
  }

function more(bx,act){

    icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx)
		
	if (act=="show")
	{
	se.className  = "regular";
	icM.className = "regular";
    icE.className = "hide";
	}
	else
	{
	se.className  = "hide";
    icM.className = "hide";
    icE.className = "regular";
	}
}

</script>

<cfquery name="Doc" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#URL.DocumentNo#'
</cfquery>

<!--- Are there competencies defined for the bucket linked to this document --->
<cfquery name="BucketCompetencies" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT FC.CompetenceId
	FROM   Document D 
		   INNER JOIN Applicant.dbo.FunctionOrganization FO
				 ON D.FunctionId = FO.FunctionId
		   INNER JOIN Applicant.dbo.FunctionOrganizationCompetence FC
		   		 ON FO.FunctionId = FC.FunctionId
	WHERE  D.DocumentNo = '#URL.DocumentNo#'

</cfquery>

<cfquery name="Interview" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT C.CompetenceId, C.Description, I.*
	FROM   Applicant.dbo.Ref_Competence C
		   LEFT OUTER JOIN DocumentCandidateInterview I 
		   		ON C.CompetenceId = I.CompetenceId AND I.PersonNo = '#URL.PersonNo#' 
				   AND I.DocumentNo = '#URL.DocumentNo#'
	WHERE  C.Operational = 1
	<!--- Means that competencies applicable for this track have been defined at the bucket level --->
	<cfif BucketCompetencies.recordcount gt 0>
		AND C.CompetenceId IN (
			#QuotedValueList(BucketCompetencies.CompetenceId)#
		)
	</cfif>
 	ORDER BY C.ListingOrder
	
</cfquery>
	
<cfif CLIENT.width lte "1024">
 <cfset col = "120">
<cfelse>
 <cfset col = "130">
</cfif>

<cf_divscroll> 

<cfform action="CandidateInterviewSubmit.cfm?DocumentNo=#URL.DocumentNo#&PersonNo=#URL.PersonNo#&ActionCode=#URL.ActionCode#" method="POST" >
 
<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" id="header" class="formpadding">
   		
	<cfif Interview.recordcount eq 0 or Interview.InterviewId eq "">
		<cf_assignid>
	<cfelse>
		<cfset rowguid = Interview.InterviewId>
	</cfif>
	
	<cfoutput>
		<input type="hidden" name="InterviewId" id="InterviewId" value="#rowguid#">
	</cfoutput>
	
	<tr><td height="8"></td></tr>
    <TR class="labelmedium">
	
    <td height="20" width="20%"> &nbsp;<cf_tl id="Recruitment No">:</td>
	<td width="30%" bgcolor="white">
		<cfoutput>#Doc.DocumentNo#</cfoutput>
	</td>
	<TD width="20%">&nbsp;<cf_tl id="Officer"></td>
    <td width="30%" bgcolor="white">
		<cfoutput>#Doc.OfficerUserFirstName# #Doc.OfficerUserLastName#</cfoutput>
	</td>
	</TR>
	
    <TR class="labelmedium">	
    <td height="20"> &nbsp;<cf_tl id="Unit">:</td>
	<td bgcolor="white">
		<cfoutput>#Doc.OrganizationUnit#</cfoutput>
	</td>
	<TD>&nbsp;<cf_tl id="Due date"></td>
    <td bgcolor="white">
		<cfoutput>#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#</cfoutput>
	</td>
	</TR>
		
	<TR class="labelmedium">
    <TD height="20">&nbsp;<cf_tl id="Functional title">:</TD>
    <TD bgcolor="white">
		<cfoutput>#Doc.FunctionalTitle#</cfoutput>
	</TD>
	<td>&nbsp;<cf_tl id="Grade">:&nbsp;</td>
	<td bgcolor="white">
		<cfoutput>#Doc.PostGrade#</cfoutput>
	</td>
	</TR>	
		
 	<TR class="labelmedium">	
    <td height="20">&nbsp;<cf_tl id="Remarks">:</td>
	<TD bgcolor="white">
		<cfoutput>#Doc.Remarks#</cfoutput> 
	</TD>
	
	<cfif Doc.FunctionId neq "">

		<cfquery name="Bucket" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT *
		    FROM  FunctionOrganization
			WHERE FunctionId = '#Doc.FunctionId#'
		</cfquery>
	
		<td>&nbsp;<cf_tl id="VA No">:&nbsp;</td>
	    <TD bgcolor="white"> 
		   <cfoutput><A href="javascript:va('#Bucket.FunctionId#');"><font color="0080C0">#Bucket.ReferenceNo#</font></a></cfoutput>
		</TD>
		
	</cfif>
	
	</TR>
	
	<cfquery name="Candidate" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	      SELECT   A.IndexNo, A.PersonNo, DC.Status, DC.EntityClass as CandidateClass, 
		           DC.Remarks, DC.OfficerLastName, DC.OfficerFirstName, DC.Created, A.LastName, A.FirstName, 
	               A.Nationality, A.Gender, A.DOB, DC.TsInterviewStart, DC.TsInterviewEnd
	      FROM     DocumentCandidate DC,
		           Applicant.dbo.Applicant A
		  WHERE    DC.DocumentNo = '#URL.DocumentNo#'
		  AND      DC.PersonNo = '#URL.PersonNo#'
		  AND      DC.PersonNo = A.PersonNo
	</cfquery>
	
	<cfquery name="CandidateReview" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	      SELECT   ReviewStatus, ReviewMemo
	      FROM     DocumentCandidateReview
		  WHERE    DocumentNo = '#URL.DocumentNo#'
		  AND      PersonNo = '#URL.PersonNo#'
		  AND      ActionCode = '#URL.ActionCode#'
	</cfquery>
	
	
	<TR class="labelmedium">
	
    <td height="20">&nbsp;<cf_tl id="Index No">:</td>
	<TD bgcolor="white">
		<cfoutput>#Candidate.IndexNo#</cfoutput> 
	</TD>
	<td style="padding-right:5px">&nbsp;<cf_tl id="Name"></td>
    <TD bgcolor="white"> 
	   <cfoutput>#Candidate.FirstName# #Candidate.LastName#</cfoutput>
	</TD>
	</TR>
		
	<tr class="labelmedium"><td height="20">
	&nbsp;<cf_tl id="Interview time">:
	</td>
	
	<td colspan="3">
		
	<cfoutput>
	
	<cf_calendarscript>

	<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "" and url.actioncode neq "view">	
	
		<table cellspacing="0" cellpadding="0">
		<tr class="labelmedium"><td>
		
			<cf_intelliCalendarDate9
				FieldName="DateInterviewStart" 
				Default="#Dateformat(Candidate.TsInterviewStart, '#CLIENT.DateFormatShow#')#"
				AllowBlank="False"
				Class="regularxl">	
		
		</td>
				
		<cfif Timeformat(Candidate.TsInterviewStart, 'HH') eq "">
		   <cfset tah = "12">
		   <cfset tam = "00">
		<cfelse>
		   <cfset tah = "#Timeformat(Candidate.TsInterviewStart, 'HH')#">
		   <cfset tam = "#Timeformat(Candidate.TsInterviewStart, 'MM')#">
		</cfif>
						
		<cfif Timeformat(Candidate.TsInterviewEnd, 'HH') eq "">
		   <cfset teh = "12">
		   <cfset tem = "00">
		<cfelse>
		   <cfset teh = "#Timeformat(Candidate.TsInterviewEnd, 'HH')#">
		   <cfset tem = "#Timeformat(Candidate.TsInterviewEnd, 'MM')#">
		</cfif>
		
		<td class="labelmedium">&nbsp;&nbsp;<cf_tl id="From">:&nbsp;&nbsp;
		</td>
		
		<td>
		
		<cfinput type="Text" 
			name="HourInterviewStart" 
			range="1,23" 
			value="#tah#"
			message="Please enter a valid hour" 
			validate="integer" 
			required="Yes" 
			size="1" 
			maxlength="2" 
			class="regularxl" 
			style="text-align: center;">
		:
		<cfinput type="Text" 
	         name="MinuteInterviewStart" 
			 range="0,59" 
			 value="#tam#"
			 message="Please enter a valid hour" 
			 validate="integer" 
			 required="Yes" 
			 size="1" 
			 maxlength="2" 
			 style="text-align: center;" 
			 class="regularxl">
			 
		</td>
		
		<td>&nbsp;&nbsp;<cf_tl id="Until">:&nbsp;&nbsp;</td>
		
		<td>
				
		<cfinput type="Text" 
			name="HourInterviewEnd" 
			range="1,24" 
			value="#teh#"
			message="Please enter a valid hour" 
			validate="integer" 
			required="Yes" 
			size="1" 
			maxlength="2" 
			class="regularxl" 
			style="text-align: center;">
		:
		<cfinput type="Text" 
	         name="MinuteInterviewEnd" 
			 range="0,60" 
			 value="#tem#"
			 message="Please enter a valid hour" 
			 validate="integer" 
			 required="Yes" 
			 size="1" 
			 maxlength="2" 
			 style="text-align: center;" 
			 class="regularxl">
			 
			 </td>
			 
			 </tr>
			 
			 </table>
					
		<cfelse>
		
			<b>#Dateformat(Candidate.TsInterviewStart, '#CLIENT.DateFormatShow#')# </b>
			&nbsp;<cf_tl id="from">:&nbsp; <b>#Timeformat(Candidate.TsInterviewStart, 'HH:MM')#</b>  
			&nbsp;<cf_tl id="to">:&nbsp; <b>#Timeformat(Candidate.TsInterviewEnd, 'HH:MM')#</b>
		
		</cfif>
					
		</cfoutput>
		
	</td>
		
	</tr>
	
	<tr valign="top">
		<td class="labelmedium">&nbsp;<cf_tl id="Assessment">:</td>
		<td colspan="3">
			<cfoutput>
			<textarea rows="3" 
				name="ReviewMemo" 
				id = "ReviewMemo"
				class="regular" 
				style="border:1px solid silver;width:95%; font-size:13px;padding: 3px; border-radius:4px;background-color: f8f8f8;">#CandidateReview.ReviewMemo#</textarea>
			</cfoutput>
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium">&nbsp;<cf_tl id="Recommended">:</td>
		<td colspan="3">
			<select name="CandidateStatus" id="CandidateStatus" class="regularxl">
				<option value="1" <cfif Candidate.Status lt 2>selected</cfif>  >No</option>
				<option value="2" <cfif Candidate.Status gte 2>selected</cfif> >Yes</option>
			</select>
		</td>
	</tr>
	
	<tr class="labelmedium">
	    <td style="padding-top:4px">&nbsp;<cf_tl id="Attachments">: </td>
		<td colspan="3">
		 <cf_filelibraryN
			DocumentPath="VacDocument"
			SubDirectory="#rowguid#" 			
			Insert="yes"
			Filter=""	
			LoadScript="Yes"
			Box="interview"
			Remove="yes"
			ShowSize="yes">	
		</td>
	</tr>
	
	<cfif url.actioncode neq "view">
	
	    <tr><td height="4"></td></tr>
			
		<tr valign="top">
		<td>&nbsp;<cf_tl id="Interview Panel">:</td>
		<td colspan="3">
		
		<cfajaximport tags="cfWindow,cfdiv">
		
		<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "">	
		
		<cfset link = "#SESSION.root#/vactrack/application/candidate/CandidateReviewPanel.cfm?DocumentNo=#URL.DocumentNo#&PersonNo=#URL.PersonNo#&ActionCode=#URL.ActionCode#">	
		<cfdiv bind="url:#link#" id="member"/>
			
		</cfif>
		
		</td>
		
		</tr>
		
		
		<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "">	
		
		<tr>
		<td></td>
		<td height="30" colspan="3" align="center" class="labelmedium">
		
			Add panel member
		   <cfset link = "#SESSION.root#/vactrack/application/candidate/CandidateReviewPanel.cfm?DocumentNo=#URL.DocumentNo#||PersonNo=#URL.PersonNo#||ActionCode=#URL.ActionCode#">	
		   
		   <cf_selectlookup
		    box        = "member"
			title      = "Add Panel Member"
			link       = "#link#"
			type       = "employee"
			dbtable    = "Vacancy.dbo.DocumentCandidateReviewPanel"			
			des1       = "PanelPersonNo">				
			
			</td>
		</tr>    
		
		 <tr><td colspan="7" class="linedotted" height="1"></td></tr>
		
		
		</cfif>
	
	</cfif>
	
	<tr><td height="4"></td></tr>
		
	<tr><td colspan="4" style="padding-left:2px">
	
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<cfoutput query="Interview">
		
			<tr>
				<td width="20%" valign="top" class="labelmedium" style="padding-top:4px">
				    <font color="0080C0">#Description#</font></b>
				</td>
			    <td width="78%" style="padding-left:20px">
				<cfif ActionCode eq URL.ActionCode or Interview.ActionCode eq "" and url.actioncode neq "view">				
				<textarea style="padding:3px;width:95%;font-size:13px;border-radius:5px" rows="5" name="#CompetenceId#" id="#CompetenceId#" class="regular">#InterviewNotes#</textarea>
				<cfelse>
				
				<cfif InterviewNotes eq ""><font color="FF8080">[no comments]</font>
					                       <cfelse>#ParagraphFormat(InterviewNotes)#
										   </cfif>
				
				</cfif>
				</td>
			</tr>
			<tr><td colspan="4" class="linedotted"></td></tr>
		
		</cfoutput>
		
	</table>
	
	</td></tr>
			
	<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "" and url.actioncode neq "view">	
	
		<tr><td colspan="4" align="center">
			<input type="submit" style="width:200px;height:30px" class="button10g" name="Submit" value="Save">
		</td></tr>
		
	</cfif>
						
</table>	

</cfform>

</cf_divscroll>

<cf_screenbottom layout="webapp">

