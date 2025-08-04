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
<!--- Query returning detail information for selected item --->    
    <cfset CLIENT.DateFormatShow   = "dd/mm/yyyy">
    <cfparam name="URL.ID1" default="Galaxy">
    <cfset UN_English = "U N I T E D    N A T I O N S">    
    <cfset UN_French = "N A T I O N S    U N I E S">    
    <cfset Q1 = "1. Family name">    
    <cfset Q2 = "First Name">    
    <cfset Q3 = "Middle Name">    
    <cfset Q4 = "Maiden Name, (if any)">    
    <cfset Q5 = "2. Date of Birth">    
    <cfset Q6 = "3. City of Birth">    
    <cfset Q7 = "Country of Birth">    
    <cfset Q8 = "Index No">    
    <cfset Q9 = "4. Country of Nationality at Birth">    
    <cfset Q10 = "Second Nationality (if any)">    
    <cfset Q11= "5. Country of Present Nationality">    
    <cfset Q12 = "Second Nationality (if any)">    
    <cfset Q13 = "6. Gender">    
    <cfset Q14 = "7. Height [cm]">    
    <cfset Q15 = "8. Weight [kg]">    
    <cfset Q16 = "9. Maritial Status">    
    <cfset Q17 = "10. Entry into the United Nations service might require assignment to any area of he world in which the United Nations might have responsibilities.">    
    <cfset Q18 = "Are there any limitations on your ability to engage in all travel?">    
    <cfset Q19 = "Are there any limitations on your ability to perform in your prospective field of work?">    
    <cfset Q20 = "11. Have you taken up legal permanent residence status in any country other than that of your nationality?">    
    <cfset Q21 = "12. If you have taken any legal steps towards changing your present nationality, explain the circumstances:">    
    <cfset Q22 = "13. What is your preferred field of work?">    
    <cfset Q23 = "14. Would you accept employment for less than six months?">    
    <cfset Q24 = "15. If you have previously submitted an application for employment and/or undergone any tests with the United Nations, indicate when?">    
    <cfset Q25 = "16. Have you ever been arrested, indicted, or summoned into court as a defendant in a criminal proceeding, or convicted, fined or imprisoned for the violation of any law (excluding minor traffic violations)?">    
    <cfset Q26 = "Give an explanation of each">    
    <cfset Q27 = "17. State any other relevant facts, include information regarding any residence outside the country of your nationality.">    
    <cfset Q28 = "18. Email Address:"><!--- get current roster list from temporary table  with at least one field, PersonNo --->

	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
				<style>
				  TD {font-size : 9pt; }
				</style>
	
	<cfquery 
	name="Candidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM IMP_GALApplicant
		WHERE PersonNo = '#PHPPersonNo#'
	</cfquery>

	<cfquery 
	name="Applicant" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		    FROM GALApplicant 
		    WHERE PersonNo = '#PHPPersonNo#'
	</cfquery>

	<cfquery name="Experience" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT A.*
		FROM ApplicantBackGround A 
		WHERE A.ApplicantNo = '#Candidate.ApplicantNo#'
		AND A.Status < '9'
		ORDER BY ExperienceCategory, ExperienceStart DESC
	</cfquery>
    <cfinclude template="PHP_Header.cfm">
    <cfinclude template="PHP_Sec_General.cfm">
    <cfinclude template="PHP_Sec_Relations.cfm">
    <cfinclude template="PHP_Sec_Education.cfm">
    <cfinclude template="PHP_Sec_Professional_Societies.cfm">
    <cfinclude template="PHP_Sec_Employment.cfm">
    <cfinclude template="PHP_Sec_Language.cfm">
    <cfinclude template="PHP_Sec_Address.cfm">
    <cfinclude template="PHP_Sec_References.cfm">
    <cfinclude template="PHP_Footer.cfm">
</BODY>
</HTML>
