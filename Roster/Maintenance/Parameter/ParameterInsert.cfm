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

<!--- rules area --->

<cf_insertRule
 Code = "B001" TriggerGroup="Bucket" Description = "Remove applications which have not been processed for">	

<cf_insertRule
 Code = "B002" TriggerGroup="Bucket" Description = "Remove applications for cleared candidates without a shortlisting">	

<cf_insertRule
 Code = "B003" TriggerGroup="Bucket" Description = "Remove applications of which the roster clearance action is older than">	

<cf_insertRule
 Code = "B004" TriggerGroup="Bucket" Description = "Remove unprocessed application if bucket has expired after">	   


<!--- php extrensic --->

<cf_insertExperienceParent 
 Parent   = "Degree"   Area     = "Education" 
 SearchEnable = "1"     SearchOrder = "1">	

<cf_insertExperienceParent 
 Parent   = "Diploma"   Area     = "Education" 
 SearchEnable = "0"     SearchOrder = "99">	
 
 <cf_insertExperienceParent 
 Parent   = "Education" Area     = "Education" 
 SearchEnable = "1"     SearchOrder = "4">	
 
 <cf_insertExperienceParent 
 Parent   = "Experience"   Area     = "Experience" 
 SearchEnable = "1" SearchOrder = "5" PeriodEnable = "1">	
 
 <cf_insertExperienceParent 
 Parent   = "Level"      Area     = "Experience" 
 SearchEnable = "1" SearchOrder = "2" PeriodEnable = "1">	
 
 <cf_insertExperienceParent 
 Parent   = "Organization"   Area     = "Experience" 
 SearchEnable = "1" SearchOrder = "3" PeriodEnable = "1">	
 
 <cf_insertExperienceParent 
 Parent   = "Region"   Area     = "Experience" 
 SearchEnable = "1" SearchOrder = "4" PeriodEnable = "1">	
 
 <!--- php intrinsic --->
 
 <cf_insertExperienceParent 
 Parent   = "Strategy" Description = "Strategy and Architecture"   Area     = "Skills" 
 SearchEnable = "1"     SearchOrder = "11">	
 
 <cf_insertExperienceParent 
 Parent   = "Change"  Description = "Business Change" Area     = "Skills" 
 SearchEnable = "1"     SearchOrder = "12">	
 
 <cf_insertExperienceParent 
 Parent   = "Implementation" Description   = "Solution Development and Implementation"  Area     = "Skills" 
 SearchEnable = "1"     SearchOrder = "13">	
 
 <cf_insertExperienceParent 
 Parent   = "Management" Description   = "Service Management"  Area     = "Skills" 
 SearchEnable = "1"     SearchOrder = "14">	
 
 <cf_insertExperienceParent 
 Parent   = "Support" Description   = "Procurement and Management support"  Area     = "Skills" 
 SearchEnable = "1"     SearchOrder = "15">	
 
 <cf_insertExperienceParent 
 Parent   = "Interface" Description  = "Client Interface"  Area     = "Skills" 
 SearchEnable = "1"     SearchOrder = "16">	
 
 <cf_insertExperienceParent 
 Parent   = "Miscellaneous"   Area     = "Miscellaneous" 
 SearchEnable = "1"     SearchOrder = "99">	
					
<cf_insertSkill    Code="University" 
	               ListingOrder = "1"
				   Description = "University" 
				   Template = "Background/Education.cfm" 
				   Framescrollbar = "1" 
				   CandidateHint ="University">
				   
	<cf_insertSkillParent  Code="university" Parent = "Degree"
						   KeywordsMinimum="0"  KeywordsMaximum="1">	
						   
	<cf_insertSkillParent  Code="university" Parent = "Education"
						   KeywordsMinimum="1"  KeywordsMaximum="5" keywordsMessage="Attention: Choose at least one (1), but no more than five (5) fields of study.">						   					   
				   
<cf_insertSkill    Code="School" 
	               ListingOrder = "2"
				   Description = "School" 
				   Template = "Background/Education.cfm" 
				   Framescrollbar = "1" 
				   CandidateHint ="School">		
				   
	<cf_insertSkillParent  Code="school" Parent = "Diploma"
						   KeywordsMinimum="1"  KeywordsMaximum="1">	
						   
<cf_insertSkill    Code="Training" 
	               ListingOrder = "3"
				   Description = "Training" 
				   Template = "Background/Education.cfm" 
				   Framescrollbar = "1" 
				   CandidateHint ="Training">	
				   
	<cf_insertSkillParent  Code="training" Parent = "Diploma"
						   KeywordsMinimum="1"  KeywordsMaximum="1">						   						   		   
				   
<cf_insertSkill    Code="Language" 
	               ListingOrder = "4"
				   Description = "Language knowledge" 
				   Template = "Language/Language.cfm" 
				   Framescrollbar = "0" 
				   CandidateHint ="Language knowledge">		
				   
<cf_insertSkill    Code="Employment" 
	               ListingOrder = "5"
				   Description = "Employment" 
				   Template = "Background/Background.cfm" 
				   Framescrollbar = "1" 
				   CandidateHint ="Employment">		
				   
	<cf_insertSkillParent  Code="employment" Parent = "Level"
						   KeywordsMinimum="1"  KeywordsMaximum="1">	
						   
	<cf_insertSkillParent  Code="employment" Parent = "Organization"
						   KeywordsMinimum="1"  KeywordsMaximum="1">					   					   					   
					   
	<cf_insertSkillParent  Code="employment" Parent = "Region"
						   KeywordsMinimum="1"  KeywordsMaximum="1">							   
						   
	<cf_insertSkillParent  Code="employment" Parent = "Experience"
						   KeywordsMinimum="3"  KeywordsMaximum="5" KeywordsMessage = "<b>Attention:</b>&nbsp;Choose at least one (3), but no more than five (5) areas of expertise.">							   
		   
<cf_insertSkill    Code="Competence" 
	               ListingOrder = "6"
				   Description = "Competencies" 
				   Template = "Competence/Competence.cfm" 
				   Framescrollbar = "0" 
				   CandidateHint ="Select three core competencies and up to two managerial competencies you feel strongest in">		
				   
	<cf_insertSkillParent  Code="competence" Parent = "Miscellaneous"
						   KeywordsMinimum="0"  KeywordsMaximum="0">					   
				   
<cf_insertSkill    Code="Miscellaneous" 
	               ListingOrder = "7"
				   Description = "Computing skills" 
				   Template = "Computing/Computing.cfm" 
				   Framescrollbar = "0" 
				   CandidateHint ="Computing skills">	
				   
	<cf_insertSkillParent  Code="Miscellaneous" Parent = "Miscellaneous"
						   KeywordsMinimum="0"  KeywordsMaximum="0">					   					   	

<!--- classes --->

<cf_insertClass    Id="0" 
	               Description="External" scope="Applicant">
		
<cf_insertClass    Id="1" 
                   Description="Internal" scope="Applicant">	
				   
<cf_insertClass    Id="3" 
                   Description="Case" scope="CaseFile">					   
				   
<cf_insertClass    Id="4" 
                   Description="Patient" scope="Patient">		
				   
<cf_insertClass    Id="5" 
                   Description="Customer" scope="Customer">					   			   
				   
				   
<!--- action --->

<cf_insertRosterAction   Id="FUN" 
	               Description="Function Assessment">
		
<cf_insertRosterAction   Id="MAIL" 
                   Description="Mail notification">	
				   
<cf_insertRosterAction   Id="PER" 
                   Description="Person amendment">			
				   
<cf_insertRosterAction   Id="MED" 
                   Description="Medical clearance">					   		   
				   				   
				   
<!--- person status --->

<cf_insertPersonStatus    Id="0" 
	               Description="No objection">
		
<cf_insertPersonStatus    Id="1" 
                   Description="Performance issues">		
	
<cf_insertPersonStatus    Id="2" 
	               Description="Discuss with supervisor">
		
<cf_insertPersonStatus    Id="3" 
                   Description="Do not hire">		
	
	

<cf_ParameterInsertSearchClass
	SearchClass="SelfAssessment"
	ListingOrder="19"
	ListingGroup="Topic"
	ListGroupEdit="1"
	Description="SelfAssessment Topics">	
	

<cf_ParameterInsertSearchClass
	SearchClass="SelfAssessmentOperator"
	ListingOrder="19"
	ListingGroup="Topic"
	ListGroupEdit="1"
	Description="SelfAssessment Operator">		
	
<!--- roster search classes --->

<cf_ParameterInsertSearchClass
	SearchClass="Topic"
	ListingOrder="14"
	ListingGroup="Topic"
	ListGroupEdit="1"
	Description="Vacancy topic/questions">

<cf_ParameterInsertSearchClass
	SearchClass="TopicOperator"
	ListingOrder="14"
	ListingGroup="Topic"
	ListGroupEdit="1"
	Description="Search for">
	
<cf_ParameterInsertSearchClass
	SearchClass="OwnerKeyWord"
	ListingOrder="13"
	ListingGroup="Keyword Search"
	ListGroupEdit="1"
	Description="Owner keyword">	

<cfquery name="Parent" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ExperienceParent
</cfquery>

<cfloop query="Parent">

	<cf_ParameterInsertSearchClass
	SearchClass="#Parent#"
	ListingOrder="12"
	ListingGroup="#Area#"
	ListGroupEdit="1"
	Description="#Parent#">
	
	<cf_ParameterInsertSearchClass
	SearchClass="#Parent#Operator"
	ListingOrder="12"
	ListingGroup="#Area#"
	ListGroupEdit="1"
	Description="Search for">

</cfloop>

<cf_ParameterInsertSearchClass
SearchClass="WorkExperience"
ListingOrder="14"
ListingGroup="Experience"
ListGroupEdit="1"
Description="Total work experience">

<cfquery name="Source" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Source
		WHERE    AllowAssessment = 1		
    </cfquery>	
		
	<cf_ParameterInsertSearchClass
	SearchClass="Assessed"
	ListingOrder="15"
	ListingGroup="Skill"
	ListGroupEdit="1"
	Description="Skill Assessment Status">
	
	<cfloop query="Source">	
	
		<cf_ParameterInsertSearchClass
		SearchClass="Assessed#Source#Require"
		ListingOrder="15"
		ListingGroup="Skill"
		ListGroupEdit="1"
		Description="Require Skill Assessment">
	
		<cf_ParameterInsertSearchClass
		SearchClass="Assessed#Source#"
		ListingOrder="15"
		ListingGroup="Skill"
		ListGroupEdit="1"
		Description="Skill Assessment #Description#">
		
		<cf_ParameterInsertSearchClass
		SearchClass="Assessed#Source#Operator"
		ListingOrder="15"
		ListingGroup="Skill"
		ListGroupEdit="1"
		Description="Search For">

	</cfloop>

<cf_ParameterInsertSearchClass
SearchClass="AgeFrom"
ListingOrder="10"
ListingGroup="Age"
ListGroupEdit="1"
Description="Age from">

<cf_ParameterInsertSearchClass
SearchClass="AgeUntil"
ListingOrder="10"
ListingGroup="Age"
ListGroupEdit="1"
Description="Age until">

<cf_ParameterInsertSearchClass
SearchClass="Announcement"
ListingOrder="11"
ListingGroup="Vacancy"
ListGroupEdit="0"
Description="Announcement">

<cf_ParameterInsertSearchClass
SearchClass="VA"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="0"
Description="Limit to VA">

<cf_ParameterInsertSearchClass
SearchClass="Assessment"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="1"
Description="Roster status">

<cf_ParameterInsertSearchClass
SearchClass="ApplicationFrom"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="1"
Description="Application Period Start">

<cf_ParameterInsertSearchClass
SearchClass="ApplicationUntil"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="1"
Description="Application Period End">

<cf_ParameterInsertSearchClass
SearchClass="AssessmentFrom"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="1"
Description="Assessment Period Start">

<cf_ParameterInsertSearchClass
SearchClass="AssessmentUntil"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="1"
Description="Assessment Period End">

<cf_ParameterInsertSearchClass
SearchClass="Interview"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="1"
Description="Interview status">

<cf_ParameterInsertSearchClass
SearchClass="ReviewClass"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="1"
Description="Candidate review status">

<cf_ParameterInsertSearchClass
SearchClass="Background"
ListingOrder="13"
ListingGroup="Keyword Search"
ListGroupEdit="1"
Description="Free text cluster ">

<cf_ParameterInsertSearchClass
SearchClass="Background1"
ListingOrder="13"
ListingGroup="Keyword Search"
ListGroupEdit="1"
Description="Free text cluster 1">

<cf_ParameterInsertSearchClass
SearchClass="Background2"
ListingOrder="13"
ListingGroup="Keyword Search"
ListGroupEdit="1"
Description="Free text cluster 2">

<cf_ParameterInsertSearchClass
SearchClass="Background3"
ListingOrder="13"
ListingGroup="Keyword Search"
ListGroupEdit="1"
Description="Free text cluster 3">


<cf_ParameterInsertSearchClass
SearchClass="BackgroundOperator"
ListingOrder="13"
ListingGroup="Keyword Search"
ListGroupEdit="1"
Description="Free Text Search Mode">


<cf_ParameterInsertSearchClass
SearchClass="CandidateClass"
ListingOrder="4"
ListingGroup="Status"
ListGroupEdit="1"
Description="Candidate Class">

<cf_ParameterInsertSearchClass
SearchClass="Name"
ListingOrder="4"
ListingGroup="Gender"
ListGroupEdit="1"
Description="Name">

<cf_ParameterInsertSearchClass
SearchClass="Edition"
ListingOrder="1"
ListingGroup="Roster"
ListGroupEdit="0"
Description="Roster Edition">

<cf_ParameterInsertSearchClass
SearchClass="Function"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="0"
Description="Function Titles">

<cf_ParameterInsertSearchClass
SearchClass="FunctionOperator"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="0"
Description="Search for">

<cf_ParameterInsertSearchClass
SearchClass="Gender"
ListingOrder="5"
ListingGroup="Gender"
ListGroupEdit="1"
Description="Gender">

<cf_ParameterInsertSearchClass
SearchClass="Language"
ListingOrder="6"
ListingGroup="Language"
ListGroupEdit="1"
Description="Language">

<cf_ParameterInsertSearchClass
SearchClass="LanguageOperator"
ListingOrder="6"
ListingGroup="Language"
ListGroupEdit="1"
Description="Search for">

<cf_ParameterInsertSearchClass
SearchClass="LanguageLevel"
ListingOrder="6"
ListingGroup="Language"
ListGroupEdit="1"
Description="Language level">

<cf_ParameterInsertSearchClass
SearchClass="Mission"
ListingOrder="9"
ListingGroup="Mission"
ListGroupEdit="1"
Description="Mission">

<cf_ParameterInsertSearchClass
SearchClass="MissionOperator"
ListingOrder="9"
ListingGroup="Mission"
ListGroupEdit="1"
Description="Search for">

<cf_ParameterInsertSearchClass
SearchClass="Nationality"
ListingOrder="8"
ListingGroup="Nationality"
ListGroupEdit="1"
Description="Nationality">

<cf_ParameterInsertSearchClass
SearchClass="NationalityOperator"
ListingOrder="8"
ListingGroup="Nationality"
ListGroupEdit="1"
Description="Search for">

<cf_ParameterInsertSearchClass
SearchClass="NationalityMode"
ListingOrder="8"
ListingGroup="Nationality"
ListGroupEdit="1"
Description="Mode">

<cf_ParameterInsertSearchClass
SearchClass="OccGroup"
ListingOrder="3"
ListingGroup="Function"
ListGroupEdit="0"
Description="Occupational group">

<!--- Competencie --->

<cfloop index="itm" list="Core,Managerial">

	<!--- check role --->
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_CompetenceCategory
	WHERE   Code = '#itm#' 
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
	   <cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  Ref_CompetenceCategory
		       (Code, Description)
		VALUES ('#itm#','#itm#') 
	   </cfquery>
		
	</cfif>

</cfloop>

<!--- functional title class --->

<cfloop index="itm" list="Standard">

	<!--- check role --->
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_FunctionClass
	WHERE   FunctionClass = '#itm#' 
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
	   <cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_FunctionClass
		       (FunctionClass)
		VALUES ('#itm#') 
	   </cfquery>
		
	</cfif>

</cfloop>

<!--- sources --->

<cfloop index="itm" list="Manual,Skill">

	<!--- check role --->
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Source
	WHERE   Source = '#itm#' 
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
	   <cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Source
		       (Source)
		VALUES ('#itm#') 
	   </cfquery>
		
	</cfif>

</cfloop>




