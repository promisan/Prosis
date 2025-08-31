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
<cfparam name="url.submissionedition" default="">
<cfparam name="url.owner"             default="">
<cfparam name="url.exerciseclass"     default="">

<cfoutput>

	<cfsavecontent variable="myquery">		
	
	   SELECT *
	   FROM (
	
		SELECT A.PersonNo, 
		       A.LastName, 
			   A.FirstName, 
			   A.DOB, 
			   A.Gender, 
			   A.EMailAddress,
			   A.MobileNumber,
			   A.Nationality, 
			   A.Nationality AS NationalityCode, 
			   N.Name        AS Country, 			   
			   N.CountryGroup, 
			   N.Continent,
		  	   COUNT(*) AS Applications
			   
		FROM   Applicant A
		
		INNER JOIN System.dbo.Ref_Nation N 
			ON A.Nationality = N.Code
			
		INNER JOIN ApplicantSubmission S
			ON A.PersonNo = S.PersonNo 
			
		INNER JOIN ApplicantFunction AF
			ON S.ApplicantNo = AF.ApplicantNo 
			
			<cfif url.submissionedition neq "all">
			
				AND AF.FunctionId IN (
					SELECT FunctionId
					FROM   FunctionOrganization
					WHERE  SubmissionEdition = '#url.submissionedition#' 
					)
			
			<cfelse>
			
				AND AF.FunctionId IN (
						SELECT FunctionId
						FROM   FunctionOrganization FO, Ref_SubmissionEdition S
						WHERE  FO.SubmissionEdition = S.SubmissionEdition
						AND    S.Owner         = '#url.Owner#'
						AND    S.ExerciseClass = '#url.ExerciseClass#'				 
				)
			
			</cfif>
			
		GROUP BY A.PersonNo, 
		         A.LastName, 
				 A.FirstName, 
			     A.DOB, 
				 A.Gender, 
				 A.eMailAddress,
				 A.MobileNumber,
				 A.Nationality, 
				 N.Name, 
				 N.CountryGroup,
				 N.Continent
				 
			) as D
			
		WHERE 1=1		
					 
		--condition
		
	</cfsavecontent>
	
</cfoutput>

<cfsavecontent variable="continentScript">
	
	<cfoutput>
	
  			SELECT @code, @fld, Continent
			FROM System.dbo.Ref_Nation WHERE Operational = 1 AND Code IN 
			( 
				SELECT NationalityCode
				FROM (#myquery#) AS S1
			) ORDER BY Continent 
	</cfoutput>
	
	<!---
	  lookupgroup="Continent", 
	  lookupscript="#continentScript#", 
	  
	  --->
	
</cfsavecontent>

<cfset fields = ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm + 1>
<cfset fields[itm] = {label="LastName", 
                      field="LastName", 
					  alias="D", 
					  searchfield="LastName", 
                      filtermode="3",
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>
<cfset fields[itm] = {label="FirstName", 
                      field="FirstName", 
					  alias="D", 
					  searchfield="FirstName", 
                      filtermode="2",
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>
<cfset fields[itm] = {label="DOB", 
                      field="DOB", 
					  formatted="DateFormat(DOB,client.dateformatshow)", 
                      alias="D",
					  searchfield="DOB", 
					  filtermode="0", 
					  displayfilter="Yes", 
                      search="date"}>

<cfset itm = itm + 1>
<cfset fields[itm] = {label="Gender", 
                      field="Gender", 
					  alias="D", 
					  searchfield="Gender", 
					  column="common",
                      filtermode="3",
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>
<cfset fields[itm] = {label="CountryGroup", 
                      field="CountryGroup", 
					  alias="D", 
					  searchfield="CountryGroup", 
					  column="common",
                      filtermode="2",
					  display="No", 
					  displayfilter="No", 
					  search="text"}>
					  
<cfset itm = itm + 1>
<cfset fields[itm] = {label="eMail", 
                      field="eMailAddress", 
					  alias="D", 					 					 
					  displayfilter="Yes", 
					  search="text"}>					  


<cfset itm = itm + 1>
<cfset fields[itm] = {label="Country", 
                      field="Country", 
					  alias="D", 
					  searchfield="Country", 
                    
					  filtermode="3", 
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>
<cfset fields[itm] = {label="Submitted", 
                      field="Applications", 
					  searchfield="Applications", 
					  displayfilter="No",  
					  aggregate  = "sum"}>

<cfset menu = ArrayNew(1)>

<cfinvoke component="Service.Access"  
		 method="roster" 
		 returnvariable="Access"
		 role="'AdminRoster','CandidateProfile'">
			 
<cfif access eq "EDIT" or access eq "ALL">				 

	<cf_tl id="Record a new candidate" var="1">
	<cfset menu[1] = {label="#lt_text#", script="addCandidate('#url.submissionedition#','')"}>

</cfif>

<cf_listing header="Candidate" 
            menu="#menu#" 
			box="#url.submissionedition#_candidatelisting" 
            link="#session.root#/Roster/Maintenance/RosterEdition/Candidate/CandidateListingContent.cfm?systemfunctionid=#url.systemfunctionid#&SubmissionEdition=#url.submissionedition#&ExerciseClass=#url.exerciseclass#&owner=#url.Owner#" 
            html="No" 
			show="40" 
			width="98%"
			datasource="AppsSelection" 
			listquery="#myquery#"
            listorder="LastName" 
			listorderfield="LastName" 
			listorderalias="D" 
			listorderdir="ASC"
            listgroup="NationalityCode" 
			listgroupdir="ASC" 
			headercolor="ffffff" 
			listlayout="#fields#"
            filtershow="Show" 
			excelshow="Yes" 
			drillmode="tab" 
			drillargument="930;1290;true;true"
            drilltemplate="Roster/Candidate/Details/PHPView.cfm?ID=" 
			drillkey="PersonNo">
			