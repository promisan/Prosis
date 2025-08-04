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

<cfquery name="Add" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 INSERT INTO JobPerson
		 	(JobNo,
			 PersonClass, 
			 PersonNo, 						
			 OfficerUserid, 
			 OfficerLastName, 
			 OfficerFirstName, 
			 Created)
		 SELECT '#URL.ID#', 
		        'Applicant',
		        '#URL.PersonNo#', 								
				'#SESSION.acc#', 
				'#SESSION.last#', 
				'#SESSION.first#', 
				getDate()
		 FROM   Applicant.dbo.Applicant A
		 WHERE  A.PersonNo = '#url.personNo#' 		
 </cfquery>
 
 <cfoutput>
 
 <script>
 
		 se = parent.parent.window																						 																
		 try {
			se.opener.document.getElementById('workflowbutton_#URL.ID#').click()
		 } catch(e) {
			alert('not found')
		 }
		 alert("Candidate was shortlisted")
		 window.location = "../../../../Roster/Candidate/Details/Applicant/ApplicantEntry.cfm?header=0&next=ssa&id=#url.id#"
						
 </script>

 
 </cfoutput>