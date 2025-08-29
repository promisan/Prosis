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
		
		<cfquery name="Mission" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_Mission
			 WHERE  Mission = '#document.Mission#'
	    </cfquery>	 
		  
		<!--- add to short list of vacancy --->
	    	 
		<cfset cnt = 0>
		<cfset prior = "0">
		 
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
			 
			 <!--- we check if the status has to be 0, 1 or 2 based on the workflow for that track --->
			 
			  <cfquery name="Workflow" 
	    	 datasource="AppsOrganization" 
		     username="#SESSION.login#" 
	    	 password="#SESSION.dbpw#">
				 SELECT   TOP (1) ActionDialogParameter
	             FROM     Ref_EntityActionPublish
	             WHERE    ActionPublishNo IN
	                             (SELECT      ActionPublishNo
	                               FROM       OrganizationObjectAction
	                               WHERE      ObjectId = (SELECT ObjectId 
								                          FROM OrganizationObject 
														  WHERE ObjectKeyValue1 = '#docno#' 
														  AND EntityCode = 'Vacdocument' 
														  AND Operational = 1)
								 )						  
				 AND      ActionDialogParameter <> ''
	             ORDER BY ActionOrder
			 </cfquery>
			 
			 <cfif workflow.actionDialogParameter eq "MARK">
			 
			    <cfset status = "0">
			 
			 <cfelseif workflow.actionDialogParameter eq "TEST">
			 
			 	<cfset status = "1">
			 
			 <cfelseif workflow.actionDialogParameter eq "INTERVIEW">
			 
			    <cfset status = "2">
				
			 <cfelse>
			 
			 	<cfset status = "1">	
			 
			 </cfif>
			 
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
							 Status,
							 OfficerUserid, 
							 OfficerLastName, 
							 OfficerFirstName)
					 SELECT '#docno#', 
					        '#Item#', 
							'#URL.ID1#',
							A.LastName, 
							A.FirstName, 
							'#status#',
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#'
					 FROM   RosterSearchResult R INNER JOIN Applicant A ON R.PersonNo = A.PersonNo
					 WHERE  R.PersonNo = '#Item#' 
					 AND    R.SearchId =  '#URL.ID1#'					
			     </cfquery>
				 				 
				 <!--- this is to alert if a candidate has a recently selection : Dev 17/3/2023
				 
					 <cfinvoke component  = "Service.Process.Applicant.Vacancy"  
					   method            = "Candidacy" 
				   	   Owner             = "#Mission.MissionOwner#"
					   DocumentNo        = "#docno#" 
					   PersonNo          = "#item#"	
					   Status            = ""   
					   returnvariable    = "OtherCandidates">	   	 
					 
					  <cfif OtherCandidates.recordcount gte "1"> 
					  
					      <cfset prior = "1">
					   
					  </cfif>		
				  
				  --->	 
			 
			 </cfif>
			 
			 <cfset cnt = cnt+1>
			 			 	 
		 </cfloop>
			
		 <cfif Form.select eq "">
		 		 
			  <script language="javascript">		     
			      alert("Notification, You have not selected any candidates.")			 			 			  	
			 </script>	
			
		 <cfelse>		
		      
						 
			 <cfoutput>	
			 
			 <cfif prior eq "1">
									 
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
						    // se.opener.document.getElementById('workflowbutton_#docno#').click() : Dev
							} catch(e) { 
							
							try { 
							se = parent.parent.parent.parent.window	
							se.document.getElementById('workflowbutton_#docno#').click()															
						    // se.opener.document.getElementById('workflowbutton_#docno#').click() : Dev
							} catch(e) { }
														
							}
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