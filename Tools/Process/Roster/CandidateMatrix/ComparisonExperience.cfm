 
<cfset url.id2 = "Employment">

<cfparam name="CLIENT.Submission" default="Manual"> 
<cfparam name="URL.Status"        default="'0','1'">
<cfparam name="URL.Reviewed"      default="No">
<cfparam name="URL.Owner"         default="">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter
</cfquery>

<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT A.*
	FROM   Applicant A
	WHERE  A.PersonNo = '#URL.ID#'	
</cfquery>

<cfparam name="comparisonApplicantNo" default="">

<cfquery name="qCheck" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 
    SELECT TOP 1 *
	FROM   ApplicantSubmission S

	 <cfif attributes.IDFunction neq "">
	 
	 		INNER JOIN ApplicantFunction AF
				ON S.ApplicantNo = AF.ApplicantNo AND AF.FunctionId = '#Attributes.IDFunction#'
			INNER JOIN ApplicantFunctionSubmission AFS
				ON AF.ApplicantNo = AF.ApplicantNo AND AF.FunctionId = AFS.FunctionId
			WHERE S.PersonNo ='#URL.PersonNo#'
	 <cfelse>
		WHERE 	1=0
	 </cfif>	
	  
</cfquery>

<cfif attributes.IDFunction neq "" and qCheck.recordcount neq 0>
	<cfquery name="Detail" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   S.*,
				 S.SubmissionId as ExperienceId,
				 A.PersonNo, 
		         P.Parent as Parent, 
			     P.KeywordsMinimum, 
			     P.KeywordsMessage, 
			     R.AllowEdit,
			     (SELECT Count(*) FROM ApplicantFunctionSubmissionField ARB 
						WHERE ARB.SubmissionId = S.SubmissionId  AND ARB.Status!=9) as Review,
			     '' as Remarks

		FROM     ApplicantFunctionSubmission S, 
			     Ref_ParameterSkillParent P,
			     ApplicantSubmission A,
			     Ref_Source R
		WHERE    A.PersonNo     = '#URL.PersonNo#'	
		AND      A.Source       = '#SSource#'	   
		AND      S.ApplicantNo  = A.ApplicantNo
		AND      S.FunctionId = '#Attributes.IDFunction#'
		<cfif attributes.applicantNo neq "">
			AND 	 S.ApplicantNo = '#attributes.applicantNo#'
		</cfif>
		AND      R.Source       = A.Source
		AND      S.Status IN (#PreserveSingleQuotes(URL.Status)#)
		AND      S.ExperienceCategory = P.Code
		AND      P.Code               = '#URL.ID2#'  
		<cfif URL.Reviewed eq "Yes">
		AND    EXISTS (SELECT 'X' FROM ApplicantFunctionSubmissionField ARB 
						WHERE ARB.SubmissionId = S.SubmissionId AND ARB.Status!=9)
		</cfif>
		ORDER BY ISNULL(S.ExperienceEnd, '9999-12-31') DESC,
		         S.ExperienceStart DESC, 
		         S.SubmissionId  
	</cfquery>
	
<cfelse>

	<cfquery name="Detail" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   A.*, 
		         S.Source, 
			     P.Parent as Parent, 
			     P.KeywordsMinimum, 
			     P.KeywordsMessage, 
			     R.AllowEdit,
			     (SELECT count(*) FROM ApplicantReviewBackGround WHERE ExperienceId = A.ExperienceId) as Review
		FROM     ApplicantSubmission S, 
		         ApplicantBackground A,
			     Ref_ParameterSkillParent P,
			     Ref_Source R
		WHERE    S.PersonNo     = '#URL.PersonNo#'	
		AND      S.Source       = '#SSource#'	   
		AND      S.ApplicantNo  = A.ApplicantNo
		<cfif comparisonApplicantNo neq "">
			AND 	 S.ApplicantNo = #comparisonApplicantNo#
		</cfif>
		AND      R.Source       = S.Source
		AND      A.Status IN (#PreserveSingleQuotes(URL.Status)#)
		AND      A.ExperienceCategory = '#URL.ID2#'
		AND      A.ExperienceCategory = P.Code
		AND      P.Code               = '#URL.ID2#'  
		<cfif URL.Reviewed eq "Yes">
		AND    EXISTS (SELECT 'X' FROM ApplicantReviewBackground ARB 
						WHERE ARB.ExperienceId = A.ExperienceId)
		</cfif>
		ORDER BY ISNULL(ExperienceEnd, '9999-12-31') DESC,
		         A.ExperienceStart DESC, 
		         A.ExperienceId  
	</cfquery>

</cfif>

<table width="100%" align="center" class="formpadding">

<cfset yr = 0>
<cfset row = 0>

<cfif detail.recordcount eq "0">
	
	<tr>
		<td colspan="8" class="labelmedium" align="center"><cf_tl id="No records found"></td>
	</TR>

<cfelse>

	<tr>
		<td colspan="8" class="labelit" style="padding-left:23px;padding-right:5px">
		
			<cfset years = 0>
			<cfset months = 0>
			
			<cf_PrepareBackgroundCount 
			     personNo="#URL.PersonNo#" 
				 source="#SSource#" 
				 Reviewed="#URL.Reviewed#" 
				 Owner="#URL.Owner#" 
				 IDFunction="#attributes.IDFunction#">		
				 
			<cf_BackgroundCount ApplicantNo = "#ApplicantNo#">	
			
		</td>
	</TR>
	
</cfif>

<cfset prioryear = ""> 

<tr>
	<td colspan="8" class="labelit" style="padding-left:23px;padding-right:5px">
			<cfquery name="qExperience" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT ExperienceClass, Description
				FROM   Ref_ExperienceClass
				WHERE  Candidate = '0'
			</cfquery>				

			<cfoutput>
			<cfloop query="qExperience">
				<cf_backgroundCount ApplicantNo = "#ApplicantNo#" ExperienceClass="#ExperienceClass#" color="EFF8FB" Join="No">
			</cfloop>
			</cfoutput>
	
	</td>
</tr>

<cfif attributes.hideExperience eq "No">	
		 
<cfoutput query="Detail" group="ExperienceId">
	
	  <cfif ExperienceEnd neq "">
		  <cfset yr = year(ExperienceEnd)>
	  <cfelse>
	  	  <cfset yr = year(now())>
	  </cfif>	
	  
   <cfif yr neq prioryear>  	  
   
   	  <cfset prioryear = yr>	 
	  
	  <tr>
	  <td height="20" colspan="8" style="font-size:20;font-weight:200;padding-top:5px" class="labelmedium">
	  #Yr#</td></tr>
	  
	</cfif>
	
	<tr><td height="5" colspan="8" class="linedotted"></td></tr>

	<cfif Status neq "9">
	    <tr bgcolor="ffffff" class="navigation_row">
	<cfelse>	
	    <tr bgcolor="red">
	</cfif>
	
	<cfset row = row + 1>
	<td colspan="8">
		<table width="100%">
			<tr>
			<td colspan="1" class="labelsmall" style="width:25;padding-left:5px">#Row#.</td>			
			<td colspan="7" height="23" class="labelit" style="padding-left:5px">#OrganizationClass# #ExperienceDescription#</td>	 
			</tr>
		</table>		
	</td>
	
	</tr>
	
	<cfif Attributes.HideDetails eq "No">
		<cfset vClass = "Regular">
	<cfelse>
		<cfset vClass = "Hide">	
	</cfif>	
	
	<cfif review gte "1">
				
			<cfquery name="Checking" 
					datasource="appsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    ApplicantReview A, 
					        Ref_ReviewClass R
					WHERE   A.ReviewCode = R.Code
					AND     A.Reviewid IN (SELECT ReviewId 
					                       FROM ApplicantReviewBackGround 
										   WHERE ExperienceId = '#experienceid#')								   
										   
					AND     R.Operational = 1
					ORDER BY Status DESC	
			</cfquery>
			
			<cfif checking.recordcount gte "1">
				
				<tr class="#vClass# labelit navigation_row_child">
								
					    <td colspan="3"><cf_tl id="Description"></td>
						<td><cf_tl id="Owner"></td>
						<!---
						<td><cf_tl id="Priority"></td>
						--->
						<td><cf_tl id="Status"></td>
						<td colspan="2"><cf_tl id="Initiated by"></td>
						<td ><cf_tl id="Date"></td>
				</tr>								
	
				<cfloop query="checking">
					
					<tr class="#vClass# labelmedium2 linedotted navigation_row_child" bgcolor="ffffcf">
						<td style="padding-left:4px" colspan="3">#Description#</td>
						<td>#Owner#</td>
						<!---
						<td>#PriorityCode#</td>
						--->
						<td>
								<cfswitch expression="#Status#">
										<cfcase value="0"> <font color="blue">Pending</font></cfcase>
										<cfcase value="9"><font color="FF0000">Denied</font></cfcase>
										<cfcase value="1">Cleared</cfcase>
								</cfswitch>
						</td>
						<td colspan="2" style="padding-left:4px">#OfficerLastName#</td>
						<td style="padding-left:4px">#DateFormat(Created,CLIENT.DateFormatShow)#</td>
					</tr>											
					
				</cfloop>
			
			</cfif>	
	
	</cfif>
		
	<tr class="labelmedium2 navigation_row_child">
				
		<td colspan="4" style="padding-left:15px"><b>#OrganizationName# <cfif OrganizationCity neq "">- #OrganizationCity#</cfif> #OrganizationCountry#</b></td>
		<td colspan="4" width="40%" align="right" style="padding-right:5px">
		#DateFormat(ExperienceStart,"YYYY/MM")# -		 
		<cfif ExperienceEnd lt "01/01/40" or ExperienceEnd gt "01/01/2020" >todate<cfelse>#DateFormat(ExperienceEnd,"YYYY/MM")#</cfif></b>
		</td>
				
	</tr>
				
	<cfif SalaryCurrency neq "">
	
			<tr class="#vClass# navigation_row_child">			
			<td colspan="8" style="padding-left:15px" class="labelit">		
			    #SalaryCurrency# &nbsp;#NumberFormat(SalaryStart,'_,_')# - &nbsp;#NumberFormat(SalaryEnd,'_,_')#&nbsp;&nbsp;</b>			
			</td>
			</tr>
	
	</cfif>
	
	<cfif Remarks neq "">
		
		<tr class="#vClass# navigation_row_child">				
			<td colspan="8" style="padding-left:15px" class="labelit">#Remarks#</td>
		</tr>
			
	</cfif>
	
	<cfif OrganizationAddress neq "">
		
		<tr class="#vClass# navigation_row_child">				
			<td colspan="8" style="padding-left:15px" class="labelit">#OrganizationAddress#</td>
		</tr>
			
	</cfif>
	
	<cfif len(OrganizationEMail) gte "4" or StaffSupervised neq "0">
			
		<tr class="#vClass# navigation_row_child">		
				
			<td style="padding-left:15px" colspan="8" class="labelit">
			
			<!---
			<cf_tl id="Tel">: <b>#OrganizationTelephone# </b>
			--->
			<cf_tl id="eMail supervisor">: <b>
			<cfif OrganizationEMail neq "">
			<a href="javascript:email('#OrganizationEMail#','#Candidate.FirstName# #Candidate.LastName#','','','','')">
			<font color="0080C0"><u>#OrganizationEMail#</u></font>
			</a>
			<cfelse> N/A</cfif></b>		
			<span style="float:right;">
			<cfif StaffSupervised neq "0"><cf_tl id="Supervised">:&nbsp;#StaffSupervised#</cfif>
			</span>		
			</td>
	
		</tr>
	
	</cfif>
			
	<cfif ExperienceCategory eq "Employment">			
	
				<cfquery name="DetailTopic" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT R.*, D.TopicValue
					FROM   ApplicantBackgroundDetail D, Ref_Topic R
					WHERE  D.ApplicantNo  = '#ApplicantNo#'
					AND    D.ExperienceId = '#ExperienceId#'
					AND    R.Topic = D.Topic
					AND    R.Operational = 1 
					</cfquery>	
						
		   <cfif CLIENT.submission eq "Manual">
						
				<cfloop query="detailTopic">
								
				    <tr class="#vClass#">
						<td colspan="8" style="padding-left:15px;padding-top:4px"  class="labelmedium" style="border-bottom: 1px solid e4e4e4;">
						<b>#Description#</b>
						</td>
					</tr>
					<tr class="#vClass#" style="-ms-word-break:break-all;">
						<td colspan="8" style="padding-left:15px" >
							<table width="100%" cellspacing="0" cellpadding="0" align="center">
								<tr class="labelmedium"><td>#TopicValue#</td></tr>
							</table>
						</td>
					</tr>
										
				</cfloop>
						
			<cfelse>
				
				<tr id="#currentrow#" class="hide">
					<td colspan="8">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">		
							<tr><td>
							<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
							<cfloop query="detailTopic">					
							    <tr class="labelmedium">
									<td style="padding-left:15px; padding-top:4px"><b>#Description#</b></td>
								</tr>
								<tr class="labelmedium">
									<td style="padding-left:15px">#TopicValue#</td>
								</tr>										
							</cfloop>
							</table>
							</td></tr>
						</table>
					</td>
				</tr>
				
			</cfif>
		
		</cfif>	
		
	<tr><td colspan="8" style="padding-left:23px;padding-right:5px">
		<cf_backgroundCount color="yellow" ApplicantNo = "#ApplicantNo#" ExperienceId="#Experienceid#">	
	</td>
	</tr>	
		
		
		<!---
			
		<cfoutput group="Parent"> 
		
				<cfquery name="Key" 
			    datasource="AppsSelection" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT  R.Description, P.Description as ExperienceClassDescription
				FROM    ApplicantBackgroundField A, 
				        Ref_Experience R, 
						Ref_ExperienceClass P
				WHERE   A.ApplicantNo  = '#ApplicantNo#'
				AND     A.ExperienceId = '#ExperienceId#'
				AND     A.ExperienceFieldId = R.ExperienceFieldId	
				AND     R.ExperienceClass = P.ExperienceClass
				AND     P.Parent = '#Parent#'	 
				</cfquery>	
											
				<cfif Key.recordcount gt "0">
					<cfset k = "">
					<tr><td colspan="8">
					
						<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="f9f9f9" class="formpadding">
						<cfloop query = "key">
						<tr>		
							<cfif k neq ExperienceClassDescription>
								<td width="40%">&nbsp;<b><font color="0080C0">#ExperienceClassDescription# .</b></td>
								<cfset k = "#ExperienceClassDescription#">
							<cfelse>
								<td width="40%"></td>
							</cfif>
							<td width="60%">#Description#</b></td>
						</tr>
						
						</cfloop>
						
						<cfif CLIENT.submission eq "Skill">
				 								
						 	<cfif #Key.recordcount# lt #KeyWordsMinimum#>
						 	<tr><td colspan="2" align="center" bgcolor="red"><font color="FFFFFF">&nbsp;#KeywordsMessage#</font>
							 &nbsp;
							  <A href="javascript:bgedit('#ExperienceId#','#ExperienceCategory#','#Source#')">
							  <font color="FFFFFF"><b>.. <cf_tl id="PRESS HERE"> ..</b></font>
							  </a>
							 </td></tr>
							
							 </cfif>
				 
				   	    </cfif>
						</table>
						
						</td>
					</tr>
									
				</cfif>
				
				<!--- disabled 
														
				<cfquery name="Generic" 
			    datasource="AppsSelection" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT A.*, R.Description as TopicDescription 
				    FROM   ApplicantBackgroundClassTopic A, 
					       Ref_ExperienceParentTopic R, 
						   Ref_ExperienceClass C
				    WHERE A.ApplicantNo = '#ApplicantNo#'
					AND   A.ExperienceId = '#ExperienceId#'
					AND   R.FieldTopicId = A.FieldTopicId
					AND   C.ExperienceClass = A.ExperienceClass
					AND   C.Parent = '#Parent#'
				</cfquery>
				
				<cfif Generic.recordcount gt "0">
					<cfset k = "">
					<tr><td colspan="8">
					
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
						<cfloop query = "generic">
						<tr>		
						<cfif k neq "Generic">
								<td width="40%">&nbsp;&nbsp;&nbsp;<cf_tl id="Generic"></b></td>
								<cfset k = "Generic">
						<cfelse>
								<td width="40%"></td>
						</cfif>
						<td width="60%"><i>#TopicDescription#</b></td>
						</tr>
						
						</cfloop>
									
						</table>
						
						</td>
					</tr>
				</cfif>			
				
				--->	
						
		</cfoutput>
		
		--->
		
</cfoutput>
</cfif>

</table>



