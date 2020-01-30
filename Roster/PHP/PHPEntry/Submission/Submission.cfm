
<cfparam name="URL.Section"      default="">  <!--- section of the navigation framework --->
<cfparam name="URL.Code"         default="">
<cfparam name="URL.Source"       default="">  <!--- PHP source to filter on the topics like we do for the parent --->

<cf_screentop html="No" jquery="yes">

<cfquery name="Section" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     #CLIENT.LanPrefix#Ref_ApplicantSection
	WHERE    Code = '#URL.Section#' 
</cfquery>

<cfquery name="Submission" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ApplicantSubmission
	WHERE    ApplicantNo = '#URL.ApplicantNo#' 
</cfquery>

<cfquery name="getApplicant" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   A.*
	FROM     ApplicantSubmission ASu
			 INNER JOIN Applicant A
			 	ON ASu.PersonNo = A.PersonNo
	WHERE    ASu.ApplicantNo = '#URL.ApplicantNo#' 
</cfquery>

<cfinclude template="../NavigationCheck.cfm">

<cfparam name="edit" default="edit">

<cfform action="SubmissionSubmit.cfm?Code=#URL.Code#&Section=#URL.Section#&ApplicantNo=#URL.ApplicantNo#&Source=#source#&owner=#url.owner#"
        method="POST" style="height:100%" name="topic">		

<table width="94%" height="100%" align="center">

<cfif Submission.actionStatus eq "1">

	<cfoutput>
	<tr><td style="padding:15px;font-size:26px" class="labellarge"><cf_tl id="Thank you, your answers were successfully submitted on"> #dateformat(submission.submissiondate,client.dateformatshow)#</td></tr>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		<tr><td style="padding:14px;font-size:43px" class="labellarge"><b>#Section.Instruction#</td></tr>		
		<tr>
			<td>
				<table width="100%" align="center">
					<tr>
						<td style="padding-left:20px" class="labelmedium"><cf_tl id="Click on the [Submit] button to send your answers"></td>
						<td align="right">
							<cfoutput>
								<div id="printTitle" style="display:none;"><span style="font-size:25px; text-transform:uppercase;">#Section.Instruction#: <cfif trim(getApplicant.IndexNo) neq "">[#getApplicant.IndexNo#]</cfif> #getApplicant.FirstName# #getApplicant.LastName#</span></div>
								<cf_tl id="Print" var="1">
								<cf_button2 
									mode		= "icon"
									type		= "Print"
									title       = "#lt_text#" 
									id          = "Print"					
									height		= "50px"
									width		= "55px"
									printTitle	= "##printTitle"
									printContent = "##divTopicRecapitulation">
							</cfoutput>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfoutput>

</cfif>

<tr><td valign="top" height="100%" style="padding-left:20px;padding-bottom:19px">

	<cf_divscroll id="divTopicRecapitulation">
	
		<cfinclude template="../Topic/TopicRecapitulation.cfm">
		
	</cf_divscroll>

</td></tr>


<tr><td height="20" valign="bottom">
		
			<cfif edit eq "edit">
			
				 <cfparam name="URL.Next" default="Default">
				 <cfparam name="URL.ID" default="">
				 <cfinclude template="../NavigationSet.cfm">
				
				 <cfset vSubmitEnabled = 0>
				 <cfif Submission.actionStatus eq 0>
				 	<cfset vSubmitEnabled = 1>
				 </cfif>				  			
				 <cf_Navigation
					 Alias         = "AppsSelection"
					 TableName     = "ApplicantSubmission"
					 Object        = "Applicant"
					 ObjectId      = "No"
					 Section       = "#URL.Section#"
					 SectionTable  = "Ref_ApplicantSection"
					 Id            = "#URL.ApplicantNo#"
					 Owner         = "#url.owner#"
					 BackEnable    = "#BackEnable#"
					 BackName	   = "<span>Previous</span>"	
					 HomeEnable    = "0"
					 ResetEnable   = "0"
					 ResetDelete   = "0"	
					 ProcessEnable = "0"
					 NextEnable    = "#vSubmitEnabled#"
					 NextName      = "Submit"
					 NextSubmit    = "1"
					 ButtonWidth   = "200px"
					 SetNext       = "0"
					 NextMode      = "#setNext#"
					 IconWidth 	   = "32"
					 IconHeight	   = "32">
				 
			 </cfif>	 
			 
		</td>
		</tr> 
		
</table>	

</cfform>	
