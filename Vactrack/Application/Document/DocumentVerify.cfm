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
	 <!--- verify track status --->
 
	 <cfparam name="URL.ID" default="6816">
 
	 <!--- verify if steps are closed --->
 
	 <cfquery name="Check" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT OA.*
		 FROM   OrganizationObjectAction OA, 
		        OrganizationObject O
		 WHERE  OA.ObjectId = O.ObjectId	
		 AND    EntityCode      = 'VacDocument'	
		 AND    ObjectKeyValue1 = '#URL.ID#'
		 AND    ActionStatus    = '0'
	 </cfquery>  
	 
	 <!--- verify if candidates have arrived --->
	 	 
	<cfquery name="GetPost" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM DocumentPost
		WHERE DocumentNo = '#URL.ID#'
	</cfquery>

	<cfquery name="GetCompleted" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM DocumentCandidate
		WHERE DocumentNo = '#URL.ID#'
		AND Status = '3'
	</cfquery>
	
	
 	 <cfif getPost.recordcount lte GetCompleted.recordcount>
	 
	   <cfquery name="CloseDocument" 
			   datasource="AppsVacancy" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   UPDATE Document
			   SET Status                 = '1',
			       StatusDate             = getDate(),
	       		   StatusOfficerUserId    = '#SESSION.acc#',
			       StatusOfficerLastName  = '#SESSION.last#',
			       StatusOfficerFirstName = '#SESSION.first#',
				   Remarks = 'Status set by verification'
			   WHERE DocumentNo      = '#URL.Id#'	
			   AND   Status NOT IN ('1','9')
			 </cfquery>
			 
	 <cfelse>
	 
		  <cfquery name="OpenDocument" 
			   datasource="AppsVacancy" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   UPDATE Document
			   SET Status                 = '0', 
			       StatusDate             = getDate(),
	       		   StatusOfficerUserId    = '#SESSION.acc#',
			       StatusOfficerLastName  = '#SESSION.last#',
			       StatusOfficerFirstName = '#SESSION.first#',
				   Remarks = 'Status reset by verification'
			   WHERE DocumentNo      = '#URL.Id#'	
			   AND   Status NOT IN ('0','9')
			 </cfquery>
	 	
	 </cfif>
	 
	 <cfquery name="Candidate" 
     datasource="AppsVacancy" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   DocumentCandidate 
		 WHERE  DocumentNo = '#URL.ID#'
		 AND    Status = '2s'  
	 </cfquery> 
	 
	 <cfloop query="Candidate">
	 
		 <cfquery name="Check" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT OA.*
			 FROM   OrganizationObjectAction OA, 
			        OrganizationObject O
			 WHERE  OA.ObjectId = O.ObjectId	
			 AND    EntityCode      = 'VacCandidate'	
			 AND    ObjectKeyValue1 = '#URL.ID#'
			 AND    ObjectKeyValue2 = '#PersonNo#'
			 AND    ActionStatus    = '0'
		 </cfquery>  
		 
		 <cfif #Check.recordcount# eq "0">
		 
		    <!--- all actions completed --->
		 
		 	<cfquery name="Assignment" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   PersonAssignment 
			 WHERE  SourceId = '#URL.ID#'
		     AND    SourcePersonNo = '#PersonNo#'
			 </cfquery>  
			 
			 <cfif #Assignment.recordcount# eq "0">

				   <cfset rem = "No record in staffing table">
				   
			 <cfelse>
			 
			 	  <cfset rem = "Recorded in staffing table">
				
				  <cfquery name="CloseCandidate" 
				   datasource="AppsVacancy" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   UPDATE DocumentCandidate
				   SET    Status                 = '3',
				          StatusDate             = getDate(),
		       		      StatusOfficerUserId    = '#SESSION.acc#',
				          StatusOfficerLastName  = '#SESSION.last#',
				          StatusOfficerFirstName = '#SESSION.first#',
					      Remarks                = '#rem#'
				   WHERE  DocumentNo             = '#URL.ID#'	
				   AND    PersonNo               = '#PersonNo#'
				   AND    EntityClass is not NULL
				  </cfquery>
								
			 </cfif>
	 
			  
		 <cfelse>
		 	  
		
	     </cfif>
		 
	  </cfloop>	 
 	