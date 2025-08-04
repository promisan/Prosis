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

<!--- directly record a candidate which was created on the fly --->

<cftry>

<cfquery name="Add" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 INSERT INTO Vacancy.dbo.DocumentCandidate
		 	(DocumentNo, 
			 PersonNo, 			
			 LastName, 
			 FirstName, 
			 OfficerUserid, 
			 OfficerLastName, 
			 OfficerFirstName, 
			 Created)
		 SELECT '#URL.ID#', 
		        '#URL.PersonNo#', 				
				A.LastName, 
				A.FirstName, 
				'#SESSION.acc#', 
				'#SESSION.last#', 
				'#SESSION.first#', 
				getDate()
		 FROM   Applicant A
		 WHERE  A.PersonNo = '#url.personNo#' 		
 </cfquery>
  
 <cfcatch> </cfcatch>
 
 </cftry>
 
 <cfoutput>
 
 <script>
 
		 se = parent.parent.window																						 																
		 try {
			se.opener.document.getElementById('workflowbutton_#URL.ID#').click()
		 } catch(e) {
			alert('not found')
		 }
		 alert("Candidate was shortlisted")
		 window.location = "../../../Roster/Candidate/Details/Applicant/ApplicantEntry.cfm?header=0&next=vacancy&id=#url.id#"
						
 </script>

 
 </cfoutput>
 
 <!--- trigger a refresh of the document candidate of the and re-open the entry screen again --->