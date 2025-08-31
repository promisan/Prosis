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
<cf_screentop html="no" jquery="yes">

<style>
	html, body {
		margin:0 !important;
		padding:0 !important;
	}
</style>

<cfparam name="url.scope" default="portal">

<!--- -------------------------------------------- --->
<!--- script needs to be loaded from source screen --->
<!--- -------------------------------------------- --->

<cfquery name="Section" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     #CLIENT.LanPrefix#Ref_ApplicantSection
	WHERE    Code = '#URL.Section#' 
</cfquery>

<cfquery name="getAssignedCandidacy" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  AF.*, F.FunctionDescription, R.Meaning AS StatusDescription
			FROM    ApplicantFunction AF 
					INNER JOIN FunctionOrganization FO ON AF.FunctionId = FO.FunctionId 
					INNER JOIN FunctionTitle F ON FO.FunctionNo = F.FunctionNo
					INNER JOIN Ref_StatusCode R ON AF.Status = R.Status 
					INNER JOIN Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition AND R.Owner = S.Owner
			WHERE   R.Id = 'FUN'
			AND		AF.Source = 'Assignment'
			AND     AF.ApplicantNo = '#client.applicantNo#'
</cfquery>

<table width="98%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">

	<tr><td valign="top">
	   
	   <cfinclude template="ApplyScript.cfm">
	   <cfinclude template="../NavigationCheck.cfm">
	  	   
	</td></tr>
	
	<tr><td><cf_navigation_header1 toggle="Yes"></td></tr>
	<tr><td class="linedotted"></td></tr>
	<tr><td height="10"></td></tr>
	
	<tr><td class="labellarge">
		<cf_tl id="Your current functional title is">:
		&nbsp;
		<b> 
		<cfif getAssignedCandidacy.recordcount eq 1>
			<cfoutput>#getAssignedCandidacy.FunctionDescription#</cfoutput>
		<cfelse>
			[N/A]
		</cfif>
		</b>
	</td></tr>
	
	<tr><td id="process"></td></tr>	
	<tr><td height="99%" valign="top">
	<cf_divscroll id="content">
		<cfinclude template="BucketListing.cfm">
	</cf_divscroll>
	</td></tr>
	
	<tr><td id="process"></td></tr>
	
	<cfoutput>
	
	<script>
		function setSkills() {		    
			 ColdFusion.navigate('#session.root#/Roster/PHP/PHPEntry/Application/setSkills.cfm','process');
			 return true;
		}	 
	</script>
	
	</cfoutput>

	<tr><td style="height:70px">
			
		 <cfparam name="URL.Next" default="Default">
		 <cfparam name="URL.ID" default="">
		  <cfinclude template="../NavigationSet.cfm">
		  
			<cfif Section.Obligatory eq "1">
				
				<cfquery name="Check" 
					datasource="appsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  COUNT(1) AS TOTAL
					FROM    ApplicantSubmissionTopic				
					WHERE   ApplicantNo = '#URL.ApplicantNo#'
					AND     Source='#source#'
				</cfquery>
				
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
			 NextEnable    = "#NextEnable#"				
			 NextSubmit    = "0"
			 SetNext       = "0"
			 NextMode      = "#setNext#"
			 NextName	   = "Save and Continue"	
			 ButtonWidth   = "200px"
			 NextScript    = "setSkills()"
			 IconWidth 	  = "32"
			 IconHeight	  = "32">		 
		 
	</td>
	</tr> 

</table>
	

	
