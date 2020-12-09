  	 
  
	 <cfquery name="Select" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
	 FROM   RosterSearch 
	 WHERE  SearchId = '#URL.ID1#' 
     </cfquery>

     <cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     UPDATE RosterSearch 
		 SET    Status      = '1', 
		        Description = 'Vacancy Search', 
			    Access      = 'Shared'
		 WHERE  SearchId    = '#URL.ID1#'
     </cfquery>
	 
	 <cfif url.docno neq "">
	 
	 	<cfset docno = url.docno>
	 
	 <cfelse>
	 
	 	<cfset docno = Select.SearchCategoryId>
	 	 
	 </cfif>
	 		 	 
	 <cfif url.mode eq "vacancy">
	 	 	 
		<cfquery name="Document" 
	     datasource="AppsVacancy" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Document
			 WHERE  DocumentNo = '#Select.SearchCategoryId#'
	    </cfquery>	 
		  
		<!--- add to short list of vacancy --->
	    	 
		<cfset cnt = 0>
		 
		<cfparam name="Form.Select" default="">
			  
		 	 
		 <cfloop index="Item" list="#Form.Select#" delimiters="' ,">
		 
			 <cfquery name="Check" 
	    	 datasource="AppsVacancy" 
		     username="#SESSION.login#" 
	    	 password="#SESSION.dbpw#">
				 SELECT * 
				 FROM   DocumentCandidate
				 WHERE  PersonNo   = '#Item#' 
				 AND    DocumentNo = '#docno#'
	    	 </cfquery>
			 
			 <cfif Check.recordcount eq "0">
		 
				 <cfquery name="Add" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 INSERT INTO Vacancy.dbo.DocumentCandidate
						 	(DocumentNo, 
							 PersonNo, 
							 SearchId, 
							 LastName, 
							 FirstName, 
							 OfficerUserid, 
							 OfficerLastName, 
							 OfficerFirstName, 
							 Created)
					 SELECT '#docno#', 
					        '#Item#', 
							'#URL.ID1#',
							A.LastName, 
							A.FirstName, 
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#', 
							getDate()
					 FROM   RosterSearchResult R, Applicant A
					 WHERE  R.PersonNo = '#Item#' 
					 AND    R.SearchId =  '#URL.ID1#'
					 AND    R.PersonNo = A.PersonNo
			     </cfquery>
			 
			 </cfif>
			 
			 <cfset cnt = cnt+1>
			 			 	 
		 </cfloop>
		 
		
		 
		
		 <cfif Form.select eq "">
		 		 
			  <script language="javascript">		     
			      alert("Notification, You have not selected any candidates.")			 			 			  	
			 </script>	
			
		 <cfelse>			 
		 				 
			 <cfquery name="Check" 
		     datasource="AppsVacancy" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 SELECT DISTINCT DocumentNo
				 FROM   DocumentCandidate
				 WHERE  PersonNo IN (#PreserveSingleQuotes(FORM.Select)#)
				 AND    DocumentNo IN (SELECT DocumentNo 
				  		               FROM   Document 
								   	   WHERE  Status = '0')
				 AND    DocumentNo != '#docno#'
				 AND    Status = '2s'
			 </cfquery>		
			 		 
						 
			 <cfoutput>	
			 
			 <cfif Check.recordCount gt "0">
									 
				 <script language="javascript">		
				      				     
					    alert("Notification, You have listed one or more candidates that are already SELECTED for another recruitment request.")			 			 			  						  
					  
					    se = parent.parent.window																						 																
						try {
						se.opener.document.getElementById('workflowbutton_#docno#').click()
						} catch(e) {
							try { 
							se = parent.parent.parent.window		
						    se.opener.document.getElementById('workflowbutton_#docno#').click()
							} catch(e) {}
						}
					 
				 </script>	
				 
			 <cfelse>	
			 			 
			    <cfif cnt neq "0">
		
				 	<script language="javascript">
					    alert("Recruitment track : <cfoutput>#cnt#</cfoutput> candidate<cfif #cnt# eq '1'> has<cfelse>s have</cfif> been listed.")
																								 					 
						se = parent.parent.window																						 																
						try {
						se.opener.document.getElementById('workflowbutton_#docno#').click()						
						} catch(e) {
							try { 
							se = parent.parent.parent.window	
							se.document.getElementById('workflowbutton_#docno#').click()															
						    // se.opener.document.getElementById('workflowbutton_#docno#').click() : hanno							
							} catch(e) {}
						}
												
						
				  	</script>	
					
				</cfif>	
							
		     </cfif>
			 
			  </cfoutput>
			 
		 </cfif>	
		 
<cfelseif url.mode eq "ssa">

	 <cfset cnt = 0>
		 
	 <cfparam name="Form.Select" default="">
	 	 
	 <cfloop index="Item" list="#Form.Select#" delimiters="' ,">
	 
		 <cfquery name="Check" 
    	 datasource="AppsPurchase" 
	     username="#SESSION.login#" 
    	 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   JobPerson
			 WHERE  PersonNo    = '#Item#' 
			 AND    JobNo       = '#docno#'
			 AND    PersonClass = 'Applicant'
    	 </cfquery>
		 
		 <cfif Check.recordcount eq "0">
	 
			 <cfquery name="Add" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 INSERT INTO JobPerson
					 	(JobNo, 
						 PersonClass,
						 PersonNo, 
						 SearchId, 						
						 OfficerUserid, 
						 OfficerLastName, 
						 OfficerFirstName, 
						 Created)
				 SELECT '#docno#', 
				        'Applicant',
				        '#Item#', 				
						'#URL.ID1#',			
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#', 
						getDate()
				 FROM   Applicant.dbo.RosterSearchResult R, Applicant.dbo.Applicant A
				 WHERE  R.PersonNo = '#Item#' 
				 AND    R.SearchId =  '#URL.ID1#'
				 AND    R.PersonNo = A.PersonNo
		     </cfquery>
		 
		 </cfif>
		 
		 <cfset cnt = cnt+1>
		 			 	 
	 </cfloop>
 
	 <cfif Form.select eq "">
	 
		  <script language="javascript">		     
		      alert("Notification, no candidates selected.")			 			 			  	
		  </script>	
		
	 <cfelse>	
									 
		  <cfif cnt neq "0">
		  
		    <cfoutput>
	
			<script language="javascript">
			   alert("Sofar #cnt# candidate<cfif #cnt# eq '1'> has<cfelse>s have</cfif> were listed for your track.")			   
			   se = parent.parent.window				  																				 																
			   try {				
				se.opener.document.getElementById('workflowbutton_#docno#').click()
				} catch(e) { 	}						
			</script>	
			
			</cfoutput>
				
		  </cfif>	
						 
	 </cfif>	

</cfif>		  