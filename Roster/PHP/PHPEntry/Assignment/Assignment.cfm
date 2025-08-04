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

<cf_screentop html="No" jquery="yes">

<style>
	html, body {
		margin:0 !important;
		padding:0 !important;
	}
</style>

<!--- document to obtain the grade/title from an exercise --->


<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td height="2" valign="top">	
	   <cfinclude template="../NavigationCheck.cfm">	  	   
	</td>
</tr>

<cfparam name="URL.owner"          default="">
<cfparam name="URL.edition"        default="#section.TemplateCondition#">

<tr><td valign="top" height="99%">
	
	<cfform action="AssignmentSubmit.cfm?Code=#URL.Code#&Section=#URL.Section#&ApplicantNo=#URL.ApplicantNo#&edition=#url.edition#&Source=#source#&owner=#url.owner#"
	    method="POST" 
		style="height:100%" 
		name="assignment">		
		
		<table width="100%" height="100%">
		
		<cfoutput>						
			<input type="hidden" id="submissionedition" name="submissionedition" value="#url.edition#">			
		</cfoutput>
		
		<tr><td height="100%">
		
			<table width="96%" align="center" height="100%">
				
			<tr><td height="20"></td></tr>
			<tr><td class="labellarge" style="font-size:30px">
			Your current assignment
			</td></tr>
			
			<tr><td height="20"></td></tr>
			
			<tr>
			<td class="labelmedium" style="font-size:18px;padding-left:20px">
			What is your current staff level or its equivalent ?
			</td>
			<td>
			
			<cfquery name="LastGrade" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     PersonContract
			   WHERE    PersonNo = '#client.personno#'
			   AND      ActionStatus != '9'
			   ORDER BY Created DESC
			 </cfquery> 	
			 
			 <cfquery name="LastAssignment" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT TOP 1  *
			   FROM     PersonAssignment
			   WHERE    PersonNo = '#client.personno#'
			   AND      AssignmentStatus in ('0','1')
			   AND		Incumbency > 0
			   ORDER BY DateEffective DESC
			 </cfquery>
			 			
			 <cfquery name="BucketGrade" 
			   datasource="AppsSelection" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			     
			   SELECT     GradeDeployment, 
			              ListingOrder, 
						  Description				  
						  
			   FROM       Ref_GradeDeployment 
			   WHERE      GradeDeployment IN
			                  (SELECT     GradeDeployment
			                   FROM       Functionorganization
			                   WHERE      SubmissionEdition = '#url.edition#')
			   ORDER BY   Listingorder				   
			  
			 </cfquery>
			 
			 <!--- recruitment grade --->
			 
			 <cfquery name="ContractRecruitmentLevel" 
			   datasource="AppsSelection" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			     
			   SELECT     TOP 1 R.GradeDeployment						  
			   FROM       Ref_GradeDeployment AS R INNER JOIN
			              Employee.dbo.Ref_PostGradeBudget AS PGB ON R.PostGradeBudget = PGB.PostGradeBudget INNER JOIN
			              Employee.dbo.Ref_PostGrade AS PG ON PGB.PostGradeBudget = PG.PostGradeBudget
			   WHERE      PG.PostGrade = '#lastGrade.ContractLevel#'		
			   <cfif BucketGrade.recordcount gte "1">	 
			   AND        R.GradeDeployment IN (#quotedvalueList(BucketGrade.GradeDeployment)#)
			   </cfif>
			   ORDER BY   R.Listingorder				   
			  
			 </cfquery>
			 
			 <select name="gradedeployment" id="gradedeployment" style="font-size:23px;height:33px">
				 <cfoutput query="BucketGrade">
					 <option value="#GradeDeployment#" <cfif ContractRecruitmentLevel.GradeDeployment eq GradeDeployment>selected</cfif>>#GradeDeployment#</option> 
				 </cfoutput> 
			 </select>  	
			
			</td>
			</tr>
			
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" class="labelmedium" style="font-size:18px;padding-left:20px">
			<cfoutput>
				Select the functional title that matches or resembles your current assignment the most:
				<cfif LastAssignment.recordCount eq 1><br><span style="font-size:85%; color:##808080;">(Your most recent assignment: <b>#LastAssignment.FunctionDescription#</b>)</span></cfif>
			</cfoutput>
			</td>
			</tr>
			<tr><td colspan="2" style="padding-left:40px;padding-top:10px" valign="top">
			<cf_divscroll style="width:100%">
			<cf_securediv bind="url:#session.root#/Roster/PHP/PHPEntry/Assignment/AssignmentTitle.cfm?applicantno=#url.applicantno#&submissionedition={submissionedition}&gradedeployment={gradedeployment}" 
			  id="functionaltitle">
			</cf_divscroll>
			</td></tr>
								
			
			</table>
			
		  </td></tr>	
		  
		  <tr><td height="20">
		  
		  <table width="100%" align="center">
		  
		    <tr><td height="30" valign="bottom">
				
				<cf_Navigation
					 Alias         = "AppsSelection"
					 TableName     = "ApplicantSubmission"
					 Object        = "Applicant"
					 ObjectId      = "No"
					 Group         = "PHP"
					 Section       = "#URL.Section#"
					 SectionTable  = "Ref_ApplicantSection"
					 Id            = "#URL.ApplicantNo#"
					 Owner         = "#url.owner#"
					 BackEnable    = "1"
					 BackName	   = "<span>Previous</span>"	
					 HomeEnable    = "1"
					 ResetEnable   = "0"
					 ResetDelete   = "0"	
					 ProcessEnable = "0"
					 NextEnable    = "1"
					 NextSubmit    = "1"
					 NextName	   = "Save and Continue"	
					 ButtonWidth   = "200px"
					 Reload        = "1"
					 OpenDirect    = "0"
					 SetNext       = "0"
					 NextMode      = "0"
					 IconWidth 	  = "32"
					 IconHeight	  = "32">
			
			</td></tr>
		  		  
		  </table>
		  
		  </td></tr>
		  
		</table>  
		
	</cfform>	

</td></tr>

</table>
