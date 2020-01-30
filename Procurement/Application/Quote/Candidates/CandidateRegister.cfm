
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