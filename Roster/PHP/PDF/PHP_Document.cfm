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

	<!--- main person data taken from Applicant --->
	<cfquery name="Applicant" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT A.*, S.ApplicantNo   
		    FROM Applicant A, ApplicantSubmission S, Parameter P
		    WHERE A.PersonNo = S.PersonNo
			AND A.PersonNo = '#PHPPersonNo#' 
			AND (S.SourceOrigin = P.PHPSource or S.Source = P.PHPSource) 
	</cfquery>
		
	<cfif Applicant.RecordCount eq "0">
	  <cf_message message = "NO PHP online" return = "back">
    </cfif>
	
	<cftry>
	
		<!--- galapplicant -- information not available yet in table structure  13/jun/06  --->
		
		<cfquery name="GALApplicant" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			    FROM GALApplicant 
			    WHERE PersonNo = '#PHPPersonNo#'
		</cfquery>
		<cfset UN = "1">	
				
		<cfcatch>
		  <cfset UN = "0">	 
		</cfcatch>
	
	</cftry>

	<cfquery name="Experience" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT A.*
		    FROM ApplicantBackGround A 
		    WHERE A.ApplicantNo = '#Applicant.ApplicantNo#' 
			AND A.Status < '9'
			ORDER BY ExperienceCategory, ExperienceStart DESC 
	</cfquery>
	
    <cfdocumentsection
	    name="#Applicant.firstName# #Applicant.LastName#"
		margintop = "0.4"   
		marginbottom = "0.4">		
		
		<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		<style>
		  TD {font-size : 9pt; }
		</style>

		<!--- PAGE FOOTER --->
		<!--- ************************************************************ --->
	    <cfdocumentitem type="footer">	
		    <cfinclude template="PHP_Footer.cfm">
		</cfdocumentitem>		
	
		<cfinclude template="PHP_Header.cfm"> 
		<cfinclude template="PHP_Sec_General.cfm">
		<cfif un eq "1">
		<cfinclude template="PHP_Sec_Relations.cfm">
		</cfif>
		<cfinclude template="PHP_Sec_Education.cfm">
		<cfif un eq "1">
		<cfinclude template="PHP_Sec_Professional_Societies.cfm">
		</cfif>
		<cfinclude template="PHP_Sec_Employment.cfm">
		<cfinclude template="PHP_Sec_Language.cfm">
		<cfinclude template="PHP_Sec_Address.cfm">
		<cfinclude template="PHP_Sec_References.cfm">  
		
	</cfdocumentsection>	
	

