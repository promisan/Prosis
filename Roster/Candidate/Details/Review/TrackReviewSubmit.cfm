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
<cfquery name="Doc" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Document
	WHERE  DocumentNo = '#URL.DocumentNo#'
</cfquery>

<cftransaction>

<cfparam name="Form.PriorityCode" default="0">

<cfquery name="InsertRequest" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO ApplicantReview 
		(ReviewId,
            PersonNo, 
            ReviewCode, 
		 Status, 
		 Owner,
		 DocumentNo,
		 PriorityCode,
		 ReviewRemarks, 
		 OfficerUserId, 
		 OfficerLastName, 
		 OfficerFirstName)
VALUES  ('#url.reviewid#',
         '#URL.Personno#', 
         '#URL.ReviewCode#', 
		 '0', 
		 '#Doc.Owner#',
		 '#Doc.DocumentNo#',
		 '#FORM.PriorityCode#',
		 'Track Requested', 
		 '#SESSION.acc#', 
		 '#SESSION.last#', 
		 '#SESSION.first#')
</cfquery>	
	
<cfif Form.Selected is not ""> 

	<!--- define selected users --->
	
	<cfloop index="Item" 
	           list="#Form.Selected#" 
	           delimiters="' ,">
								   
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
		INSERT INTO ApplicantReviewBackground 
		         (PersonNo, 
				 ReviewId,
				 ExperienceId)
		  VALUES ('#url.Personno#',
				 '#url.reviewid#',
				 '#Item#') 
		</cfquery>		
	
	</cfloop>

</cfif>

</cftransaction>

<!--- workflow create --->

<cfquery name="Topic" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_ReviewClass
		WHERE      Code = '#URL.ReviewCode#'
	</cfquery>
	
<cfquery name="Candidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Applicant
		WHERE PersonNo = '#URL.PersonNo#'	
	</cfquery>	

<cfset link = "Roster/Candidate/Details/General.cfm?ID=#url.PersonNo#&section=general&topic=review&Id1=#URL.ReviewCode#">
		
	<cf_ActionListing 
	    EntityCode       = "Rev#URL.ReviewCode#"
		EntityClass      = "Standard"
		EntityGroup      = "#Doc.Owner#"
		EntityStatus     = ""
		OrgUnit          = ""		
		ObjectReference  = "#Topic.Description#"
		ObjectReference2 = "#Candidate.LastName#, #Candidate.FirstName#"
	    ObjectKey1       = "#URL.PersonNo#"
		ObjectKey4       = "#URL.ReviewId#"
		ObjectURL        = "#link#"
		Show             = "No"
		CompleteFirst    = "Yes">		
	
<cfoutput>

<script>
 
 parent.parent.reviewrefresh('#URL.DocumentNo#')
 parent.parent.ProsisUI.closeWindow('mydialog',true) 
  
</script>	

</cfoutput>	
	