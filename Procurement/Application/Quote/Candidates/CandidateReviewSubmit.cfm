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

<cfparam name="Form.row" default="0">

<!--- don't save if user selects the workflow send back option --->

<cfif Form.actionStatus neq "1">

    <cfif Form.Dialog neq "Interview">
	
	<!--- do not anything is this is the interview step --->

		<cftransaction action="BEGIN">
		
		<!--- reset the candidates that have reached the step priorly, they will be	set again --->
		<cfquery name="SearchResult" 
			datasource="appsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE JobPerson
			SET    Status     = '#Form.ReviewReset#'  
			WHERE  JobNo      = '#Key1#'
			 AND   Status    >= '#Form.ReviewStatus#' 			
		</cfquery>	
		
			<!--- reset the candidates that have reached the step priorly, they will be	set again --->
			<cfquery name="Reset" 
				datasource="appsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE RequisitionLineQuote
				SET    selected   = 0  
				WHERE  JobNo      = '#Key1#'
				 AND   selected   = 1 			
			</cfquery>	
								
			<cfif Form.ReviewStatus neq "2s">	
			
				<cfloop index="Rec" from="1" to="#Form.Row#">
							
					<cfparam name="FORM.ReviewStatus_#rec#" default="">			
					<cfparam name="FORM.ReviewMemo_#rec#"  default="">
					
					<cfset memo      = Evaluate("FORM.ReviewMemo_" & #Rec#)>			
				    <cfset status    = Evaluate("FORM.ReviewStatus_" & #Rec#)>			 
				    <cfset personNo  = Evaluate("FORM.PersonNo_" & #Rec#)>
					<cfset class     = Evaluate("FORM.PersonClass_" & #Rec#)>
						
					<cfif status neq "">
										
						<cfquery name="SearchResult" 
						datasource="appsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE JobPerson
						SET   Status                 = '#Form.ReviewStatus#',
						      StatusDate             = getDate(),
							  StatusOfficerUserId    = '#SESSION.acc#',
							  StatusOfficerLastName  = '#SESSION.last#',
							  StatusOfficerFirstName = '#SESSION.first#'
						WHERE JobNo        =  '#Key1#'
						  AND PersonNo     =  '#PersonNo#' 
						  AND PersonClass  =  '#class#' 
						  AND Status < '3' 
					    </cfquery>	
					
					</cfif>
				
				</cfloop>
				
			<cfelse>	
			
				<cfparam name="FORM.Selected" default="0">		
				
				<cfset rec = form.selected>							
				<cfparam name="FORM.ReviewMemo_#rec#"  default="">						
				<cfset memo      = Evaluate("FORM.ReviewMemo_#Rec#")>						    	   
			    <cfset personNo  = Evaluate("FORM.PersonNo_#Rec#")>
				<cfset class     = Evaluate("FORM.PersonClass_#Rec#")>
							
				<cfquery name="SearchResult" 
				datasource="appsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE JobPerson
					SET   Status                 = '2s',
					      StatusDate             = getDate(),
						  StatusOfficerUserId    = '#SESSION.acc#',
						  StatusOfficerLastName  = '#SESSION.last#',
						  StatusOfficerFirstName = '#SESSION.first#'
					WHERE JobNo        =  '#Key1#'
					  AND PersonNo     =  '#PersonNo#' 
					  AND PersonClass  =  '#class#' 
					  AND Status < '3' 
			    </cfquery>	
				
				<cfquery name="SetLine" 
					datasource="appsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE RequisitionLineQuote
						SET    selected   = 1  
						WHERE  JobNo        =  '#Key1#'
					    AND    PersonNo     =  '#PersonNo#' 
					    AND    PersonClass  =  '#class#' 		
				</cfquery>	
				
								
			 </cfif> 
			 
			 <!--- entry in the review table --->
			 
			 <cfquery name="Check" 
			 datasource="appsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM  JobPersonReview
				WHERE JobNo        = '#Key1#'
				AND   PersonNo     = '#PersonNo#'	 
				AND   PersonClass  =  '#Class#' 
				AND   ActionCode   = '#ActionCode#'  
			 </cfquery>	
			 
			 <cfif Check.Recordcount eq "1">
			 
				 <cfquery name="Update" 
					datasource="appsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE JobPersonReview
					SET    ReviewMemo    = '#memo#',
					       ReviewDate    = #now()#,
						   ActionStatus  = '1'
					WHERE JobNo       = '#Key1#'
					AND   PersonClass = '#Class#'
					AND   PersonNo    = '#PersonNo#'	 
					AND   ActionCode  = '#ActionCode#'	
					</cfquery>
			 
			 <cfelse>
			 
			 	 <cfquery name="Insert" 
					datasource="appsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO JobPersonReview
						 (JobNo,
						  PersonClass,
						  PersonNo,		  
						  ActionCode,
						  ReviewMemo,
						  ReviewDate,
						  ActionStatus,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
					  VALUES ('#Key1#', 
					          '#Class#',
							  '#PersonNo#',		  
							  '#ActionCode#',
							  '#memo#',
							  getdate(),
							  '1',
							  '#SESSION.acc#',
							  '#SESSION.last#',		  
							  '#SESSION.first#')
				</cfquery>			
						 				
		</cfif>
					
	</cftransaction>
			
	<cfelse>

		<cfloop index="Rec" from="1" to="#Form.Row#">
				
		    <cfset personNo  = Evaluate("FORM.PersonNo_" & #Rec#)>
			<cfset class     = Evaluate("FORM.PersonClass_" & #Rec#)>
			
		   <cf_ApplicantTextArea
				Table           = "Purchase.dbo.JobPersonInterview" 
				Domain          = "JobProfile"
				FieldOutput     = "ProfileNotes"
				Mode            = "save"
				Format          = "text"				
				Key01           = "JobNo"
				Key01Value      = "#key1#"
				Key02           = "PersonClass"
				Key02Value      = "#Class#"
				Key03           = "PersonNo"
				Key03Value      = "#PersonNo#">
	
		</cfloop>
			
	</cfif>		

				
</cfif>





