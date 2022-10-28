
<cfoutput>
	<cf_screentop height="100%" html="no" jQuery="Yes" layout="webapp" label="Interview for Track:#URL.DocumentNo#" scroll="Yes">
</cfoutput>

<cf_dialogStaffing>
<cf_textareascript>

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
		
	if (act=="show") {
	se.className  = "regular";
	icM.className = "regular";
    icE.className = "hide";
	} else {
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

<!--- get panel --->

<cfquery name="getPanel" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   DocumentCandidateReviewPanel
		WHERE  DocumentNo = '#url.documentNo#'
		AND    PersonNo   = '#url.personno#'
		AND    ActionCode = '#url.actionCode#'
</cfquery>		

<!--- set the panel members --->

<cfif getPanel.recordcount eq "0">
	
	<cfquery name="Panel" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			INSERT INTO DocumentCandidateReviewPanel
			(DocumentNo, PersonNo, ActionCode, PanelPersonNo)
			
			SELECT       OO.ObjectKeyValue1 AS DocumentNo, 
			             '#url.personno#' AS personNo, 
						 OOA.ActionCode, 
						 U.PersonNo       AS PanelPersonNo
			FROM         Organization.dbo.OrganizationObjectActionAccess AS OOA INNER JOIN
			             System.dbo.UserNames AS U ON OOA.UserAccount = U.Account INNER JOIN
			             Organization.dbo.OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId
			WHERE        OOA.ActionCode = '#url.actionCode#' 
			AND          OO.ObjectKeyValue1 = '#url.documentNo#' 
			AND          U.PersonNo IN
			                             (SELECT    PersonNo
			                               FROM     Employee.dbo.Person
			                               WHERE    PersonNo = U.PersonNo)
								   
	</cfquery>	

</cfif>						   

<cfquery name="Interview" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT C.CompetenceId, C.Description, I.*
	FROM   Applicant.dbo.Ref_Competence C
		   LEFT OUTER JOIN DocumentCandidateInterview I ON C.CompetenceId = I.CompetenceId AND I.PersonNo = '#URL.PersonNo#' 
				   AND I.DocumentNo = '#URL.DocumentNo#'
	WHERE  C.Operational = 1
	<!--- Means that competencies applicable for this track have been defined at the bucket level --->
	<cfif BucketCompetencies.recordcount gt 0>
	AND    C.CompetenceId IN ( #QuotedValueList(BucketCompetencies.CompetenceId)# )
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
 
<table width="94%" align="center" id="header">
   		
	<cfif Interview.recordcount eq 0 or Interview.InterviewId eq "">
		<cf_assignid>
	<cfelse>
		<cfset rowguid = Interview.InterviewId>
	</cfif>
	
	<cfoutput>
		<input type="hidden" name="InterviewId" id="InterviewId" value="#rowguid#">
	</cfoutput>
		
    <TR class="labelmedium" style="height:20px">	
    <td height="20" width="6%" style="min-width:200px"><cf_tl id="Recruitment No">:</td>
	<td width="30%" bgcolor="white">
		<cfoutput>#Doc.DocumentNo#</cfoutput>
	</td>
	<TD width="20%"><cf_tl id="Officer"></td>
    <td width="30%" bgcolor="white">
		<cfoutput>#Doc.OfficerUserFirstName# #Doc.OfficerUserLastName#</cfoutput>
	</td>
	</TR>
	
    <TR class="labelmedium" style="height:20px">	
    <td height="20"><cf_tl id="Unit">:</td>
	<td bgcolor="white">
		<cfoutput>#Doc.OrganizationUnit#</cfoutput>
	</td>
	<TD><cf_tl id="Due date"></td>
    <td bgcolor="white">
		<cfoutput>#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#</cfoutput>
	</td>
	</TR>
		
	<TR class="labelmedium" style="height:20px">
    <TD height="20"><cf_tl id="Functional title">:</TD>
    <TD bgcolor="white">
		<cfoutput>#Doc.FunctionalTitle#</cfoutput>
	</TD>
	<td><cf_tl id="Grade">:&nbsp;</td>
	<td bgcolor="white">
		<cfoutput>#Doc.PostGrade#</cfoutput>
	</td>
	</TR>	
		
 	<TR class="labelmedium" style="height:20px">	
    <td height="20"><cf_tl id="Remarks">:</td>
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
	
		<td><cf_tl id="Job Opening">:&nbsp;</td>
	    <TD bgcolor="white"> 
		   <cfoutput><A href="javascript:va('#Bucket.FunctionId#');">#Bucket.ReferenceNo#</a></cfoutput>
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
	
	<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "" and url.actioncode neq "view">	
	
	<TR class="labelmedium line">
	
    <td height="20" style="font-size:18px;padding-top:5px" colspan="4"><cf_tl id="Interview Minutes and observations"></td>
	
	</TR>
	
	</cfif>
	
	<TR class="labelmedium line">
	
    <td height="20"><cf_tl id="Index No">:</td>
	<TD bgcolor="white">
		<cfoutput>#Candidate.IndexNo#</cfoutput> 
	</TD>
	<td style="padding-right:5px"><cf_tl id="Name"></td>
    <TD bgcolor="white"> 
	   <cfoutput>#Candidate.FirstName# #Candidate.LastName#</cfoutput>
	</TD>
	</TR>
	
	<tr><td style="height:6px"></td></tr>	
	<tr class="labelmedium"><td style="height:30px">
	<cf_tl id="Interview time">:
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
			class="regularxxl" 
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
			 class="regularxxl">
			 
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
			class="regularxxl" 
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
			 class="regularxxl">
			 
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
		
	<tr><td height="4"></td></tr>
			
	<tr valign="top">
		<td style="font-size:17px">
		
			<table>
				<tr>
				<td><cf_tl id="Panel Members"></td>
				
				<cfif url.actioncode neq "view">
				
					<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "">	
					
					   <cf_tl id="Add panel member" var="member">
					   <cfset link = "#SESSION.root#/vactrack/application/candidate/CandidateReviewPanel.cfm?DocumentNo=#URL.DocumentNo#||PersonNo=#URL.PersonNo#||ActionCode=#URL.ActionCode#">	
					   
					   <td style="padding-left:3px">
					   <cf_selectlookup
						    box        = "member"
							title      = "#member#"
							link       = "#link#"
							type       = "employee"
							dbtable    = "Vacancy.dbo.DocumentCandidateReviewPanel"			
							des1       = "PanelPersonNo">	
							
						</td>		
							
					</cfif>			
					
				</cfif>
				
				</tr>
			</table>
			
		</td>
		
		<td colspan="3">		
				
		<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "">	
		
			<cfset link = "#SESSION.root#/vactrack/application/Candidate/CandidateReviewPanel.cfm?DocumentNo=#URL.DocumentNo#&PersonNo=#URL.PersonNo#&ActionCode=#URL.ActionCode#">	
			<cf_securediv bind="url:#link#" id="member"/>
			
		</cfif>
		
		</td>
		
	</tr>
		
		
	<tr><td colspan="4" style="padding-left:0px">
	
	<table width="100%" align="center" class="formpadding">
		
		<cfoutput query="Interview">
		
			<tr class="line">
				<td colspan="1" valign="top" class="labelmedium" style="font-size:17px;min-width:240px;padding-top:4px;padding-right:10px"><cf_tl id="Minutes">: #Description#</td>
			</tr>
			<tr>	
			    <td colspan="2" style="padding-left:0px">
				<cfif (ActionCode eq URL.ActionCode or Interview.ActionCode eq "") and url.actioncode neq "view">			
				
				 <cf_textarea name="#CompetenceId#"	           		 
						 init="Yes"							
						 color="ffffff"	 
						 resize="false"		
						 border="0" 
						 toolbar="Mini"
						 height="140"
						 width="100%">#InterviewNotes#</cf_textarea>
				
				<!---	
				<textarea style="border:0px;border-right:1px solid silver;border-left:1px solid silver;padding:3px;width:100%;font-size:13px" rows="5" name="#CompetenceId#" id="#CompetenceId#" class="regular">#InterviewNotes#</textarea>
				--->
				<cfelse>				
					<cfif InterviewNotes eq ""><font color="FF8080">[no comments]</font><cfelse>#ParagraphFormat(InterviewNotes)#</cfif>				
				</cfif>
				</td>
			</tr>			
		
		</cfoutput>
		
		<!---
		
		<cfif interview.recordcount gte "1">
		
			<tr valign="top" class="line">
			<td style="width:200px" class="labelmedium"><cf_tl id="Assessment">:</td>
			<td colspan="3">
					
			<cfif (ActionCode eq URL.ActionCode or Interview.ActionCode eq "") and url.actioncode neq "view">		
			
			 <cf_textarea name="ReviewMemo"	           		 
							 init="Yes"							
							 color="ffffff"	 
							 resize="false"		
							 border="0" 
							 toolbar="Mini"
							 height="90"
							 width="100%"><cfoutput>#CandidateReview.ReviewMemo#</cfoutput></cf_textarea>		
							 
			 <cfelse>
			 
			 <cfoutput>#CandidateReview.ReviewMemo#</cfoutput>
			 
			 </cfif>				 
				
			</td>
			</tr>	
			
		<cfelse>
		
			<input type="text" name="ReviewMemo" value="">	

		</cfif>
		
		--->
		
		<input type="hidden" name="ReviewMemo" value="">	
	
	<!--- this is now moved out to the screen itself
	
	<tr class="line" style="height:30px">
		<td class="labelmedium"><cf_tl id="Recommended">:</td>
		<td colspan="3">
		   <cfif (ActionCode eq URL.ActionCode or Interview.ActionCode eq "") and url.actioncode neq "view">		
		   
			<select name="CandidateStatus" id="CandidateStatus" style="border:0px;border-left:1px solid silver;border-right:1px solid silver" class="regularxl">
				<option value="1" <cfif Candidate.Status lt 2>selected</cfif>  >No</option>
				<option value="2" <cfif Candidate.Status gte 2>selected</cfif> >Yes</option>
			</select>
			
			<cfelse>
			
			  <cfif Candidate.Status gte 2>Yes<cfelse>No</cfif>
			
			</cfif>
			
		</td>
	</tr>
	
	--->
	
	
			
	</table>
	
	</td></tr>
	
	<tr class="labelmedium line" style="height:30px">
	    <td style="padding-top:4px"><cf_tl id="Attachments">: </td>
		<td colspan="3">
		
		<cfif ActionCode eq URL.ActionCode or Interview.ActionCode eq "" and url.actioncode neq "view">		
		
		 <cf_filelibraryN
			DocumentPath="VacDocument"
			SubDirectory="#rowguid#" 			
			Insert="yes"
			Filter=""	
			LoadScript="Yes"
			Box="interview"
			Remove="yes"
			ShowSize="yes">	
			
		  <cfelse>
		  
		   <cf_filelibraryN
			DocumentPath="VacDocument"
			SubDirectory="#rowguid#" 			
			Insert="yes"
			Filter=""	
			LoadScript="Yes"
			Box="interview"
			Remove="no"
			ShowSize="yes">	
		  
		  </cfif>	
		</td>
	</tr>	
			
	<cfif Interview.ActionCode eq URL.ActionCode or Interview.ActionCode eq "" and url.actioncode neq "view">	
	
		<tr><td colspan="4" align="center" style="height:40px">
			<input type="submit" style="width:200px;height:30px" class="button10g" name="Submit" value="Save">
		</td></tr>
		
	</cfif>
						
</table>	

</cfform>

</cf_divscroll>

<cf_screenbottom layout="webapp">

<cfset ajaxonload("doCalendar")>
<cfset ajaxonload("initTextArea")>


