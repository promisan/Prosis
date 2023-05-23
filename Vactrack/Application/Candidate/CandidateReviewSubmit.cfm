
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 
<cfparam name="Form.row" default="0">
<cfparam name="url.actionstatus" default="0">

<!--- url.action comes from the workflow to control if sumit is to be applied upon save or
upon the descision : workflow create --->

<cfif url.actionstatus eq "0" and form.Dialog neq "Interview">

		<cftransaction action="BEGIN">
		
		<!--- reset the candidates that have reached the step priorly, they will be	set again --->
		<cfquery name="UpdateCandidate" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE DocumentCandidate
				SET    Status      = '#Form.ReviewReset#'  
				WHERE  DocumentNo  = '#Key1#'
				AND    Status     >= '#Form.ReviewStatus#' 
				AND    EntityClass is NULL
		</cfquery>	
		
		<cfloop index="Rec" from="1" to="#Form.Row#">		
					
			<cfparam name="FORM.ReviewStatus_#Rec#"   default="">
			<cfparam name="FORM.EntityClass_#Rec#"    default="">
			<cfparam name="FORM.ReviewDate_#Rec#"     default="">
			<cfparam name="FORM.ReviewMemo_#Rec#"     default="">
			<cfparam name="FORM.ReviewScore_#Rec#"    default="">
			<cfparam name="FORM.ReviewId_#Rec#"       default="">
			<cfparam name="FORM.CandidateClass_#Rec#" default="">
			
			<cfset memo        = Evaluate("FORM.ReviewMemo_" & #Rec#)>
			<cfset class       = Evaluate("FORM.EntityClass_" & #Rec#)>
		    <cfset status      = Evaluate("FORM.ReviewStatus_" & #Rec#)>
		    <cfset memo        = Evaluate("FORM.ReviewMemo_" & #Rec#)>
			<cfset reviewScore = Evaluate("FORM.ReviewScore_" & #Rec#)>
		    <cfset personNo    = Evaluate("FORM.PersonNo_" & #Rec#)>
		    <cfset reviewId    = Evaluate("FORM.ReviewId_" & #Rec#)>
			<cfset revdate     = Evaluate("FORM.ReviewDate_" & #Rec#)>
			<cfset canclass    = Evaluate("FORM.CandidateClass_" & #Rec#)>
			
			<cfif revdate eq "">
			
				<cfset dte = now()>
				
			<cfelse>
			
				 <CF_DateConvert Value="#revdate#">
				 <cfset dte = dateValue>
						
			</cfif>
														
			<cfif status neq "" OR class neq "">
					
				<cfset s = "1">	
					
				<!--- candidate was checked, so the candidate status can change --->	
			
			    <cfif class eq ""> 
					
					<cfquery name="UpdateCandidate" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE DocumentCandidate
						SET   Status                 = '#Form.ReviewStatus#',
						      StatusDate             = #dte#,
							  <cfif canclass neq "">
							  CandidateClass         = '#canclass#', 
							  </cfif>
							  StatusOfficerUserId    = '#SESSION.acc#',
							  StatusOfficerLastName  = '#SESSION.last#',
							  StatusOfficerFirstName = '#SESSION.first#'     
						WHERE DocumentNo   =  '#Key1#'
						  AND PersonNo     =  '#PersonNo#'  
						  AND Status < '3' or Status = '9' 
						  
				    </cfquery>	
				
				<cfelse>
				  
				    <!--- check if track has changed, reset candidate track --->
									
					<cfquery name="Check" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT TOP 1 ObjectId, EntityClass
						FROM Organization.dbo.OrganizationObject
						WHERE ObjectKeyValue1 = '#Key1#'
						  AND ObjectKeyValue2 = '#PersonNo#'
						  AND Operational  = 1
						  AND EntityCode = 'VacCandidate' 						 
					</cfquery>	
					
					<cfif Check.entityClass neq "#Class#" 
					      and Class neq "" 
						  and Check.recordcount neq "0">
					
						<cfquery name="Reset" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							DELETE FROM Organization.dbo.OrganizationObject
							WHERE  ObjectId = '#Check.ObjectId#'
							AND    Operational  = 1
						</cfquery>	
									
					</cfif>
									
					<!--- update record --->
					<cfquery name="SearchResult" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE DocumentCandidate
						SET    EntityClass = '#class#'
						WHERE  DocumentNo  = '#Key1#'
						  AND  PersonNo    = '#PersonNo#'
					</cfquery>	
								
				</cfif>
				
			 <cfelse>
			
				<cfset s = "0">		
							
			 </cfif> 
			 
			 <!--- entry in the review table --->
			 
			 <cfquery name="Check" 
			 datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM  DocumentCandidateReview
				WHERE DocumentNo = '#Key1#'
				AND   PersonNo   = '#PersonNo#'	 
				AND   ActionCode = '#ActionCode#'  
			 </cfquery>	
			 
			 <cfif Check.Recordcount eq "1">
			 
			    <cfquery name="Update" 
				  datasource="AppsVacancy" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
						UPDATE DocumentCandidateReview
						SET   ReviewMemo = '#memo#',
							  <cfif reviewScore neq "">
							  ReviewScore = '#reviewScore#',
							  </cfif>
						      ReviewDate    = #dte#,
							  ReviewStatus = '#Form.ReviewStatus#',
							  ActionStatus = '#s#'
						WHERE DocumentNo = '#Key1#'
						AND   PersonNo   = '#PersonNo#'	 
						AND   ActionCode = '#ActionCode#'	
				</cfquery>
			 
			 <cfelse>
			 
				 <cfquery name="Insert" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO DocumentCandidateReview
							  (DocumentNo,
							   PersonNo,		  
							   ActionCode,
							   <cfif ReviewScore neq "">
							   ReviewScore,
							   </cfif>
							   ReviewMemo,
							   ReviewDate, 
							   ReviewStatus,
							   ActionStatus,
							   <cfif Form.Dialog neq "Interview">
							   ReviewId,
							   </cfif>
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName)
					  VALUES ('#Key1#', 
							  '#PersonNo#',		  
							  '#ActionCode#',
							  <cfif ReviewScore neq "">
							  '#reviewSCore#',
							  </cfif>
							  '#memo#',
							  #dte#,
							  '#Form.ReviewStatus#',
							  '#s#',
							  <cfif Form.Dialog neq "Interview">
							  '#reviewId#',
							  </cfif>
							  '#SESSION.acc#',
							  '#SESSION.last#',		  
							  '#SESSION.first#')
					</cfquery>
				
				</cfif>
			
			</cfloop>	
		
		</cftransaction>
		
</cfif>		
			
<!--- generate canddiate track if this action indeed comes from the workflow progress step  --->	
				
<cfif url.submitaction eq "process" and url.actionstatus eq "2" and Form.ReviewStatus eq "Track">	
			
	<cfloop index="Rec" from="1" to="#Form.Row#">
		
		<cfparam name="FORM.ReviewStatus_#Rec#" default="">
		<cfparam name="FORM.EntityClass_#Rec#"  default="">
		<cfset class     = Evaluate("FORM.EntityClass_" & #Rec#)>
	    <cfset status    = Evaluate("FORM.ReviewStatus_" & #Rec#)>
	    <cfset personNo  = Evaluate("FORM.PersonNo_" & #Rec#)>
			
		<cfquery name="Doc" 
			 datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *  
			 FROM   Document
			 WHERE  DocumentNo  = '#Key1#' 
			</cfquery>
			
			<!--- define orgunit --->
	
			<cfquery name="Position" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Employee.dbo.Position
				WHERE PositionNo = '#Doc.PositionNo#'
			</cfquery>

			<cfquery name="GetCandidate" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Applicant
					WHERE PersonNo = '#PersonNo#' 
			</cfquery>
			
			<cfif GetCandidate.Gender eq "M">
	    		  <cfset Pre = "Mr.">
	 		<cfelse>
			      <cfset Pre = "Mrs."> 
			</cfif>
	   				
			<cfset link = "Vactrack/Application/Candidate/CandidateEdit.cfm?ID=#key1#&ID1=#PersonNo#">
			
			<cfquery name="Check" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 *
			    FROM   OrganizationObject
				WHERE  ObjectKeyValue1 = '#Key1#'		
				AND    EntityCode = 'VacDocument'  
				AND    Operational     = 1
				
			</cfquery>
		
			<cf_ActionListing 
			    EntityCode       = "VacCandidate"
				EntityClass      = "#Class#"
				EntityGroup      = "#Doc.Owner#"	
				Mission          = "#Doc.Mission#"			
				OrgUnit          = "#Position.OrgUnitOperational#"
				PersonNo         = "#GetCandidate.PersonNo#"
				ObjectReference  = "#Pre# #GetCandidate.FirstName# #GetCandidate.LastName#"
				ObjectReference2 = "#Doc.Mission#, #Doc.PostGrade# - #Doc.FunctionalTitle#"
				ObjectKey1       = "#Key1#"
				ObjectKey2       = "#PersonNo#"
			  	ObjectURL        = "#link#"
				ParentObjectId   = "#Check.ObjectId#"
				Show             = "No">					
				
	</cfloop>	
	
</cfif>		
	
<!--- checking of last document step can be closed --->
	
<cfif url.submitaction eq "process" and url.actionstatus eq "2" AND Form.ReviewStatus eq "Track">
				
		<cfquery name="Selected" 
		 datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT count(*) as Candidates
			 FROM   DocumentCandidate
			 WHERE  DocumentNo  = '#Key1#' 
			 AND    Status = '2s'
			 <cfif Form.ReviewStatus eq "Track">
				 AND    EntityClass != ''
		 	</cfif>
		</cfquery>
						
		<cfquery name="Post" 
		 datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT COUNT(*) as Posts
			 FROM DocumentPost
			 WHERE  DocumentNo  = '#Key1#' 
		</cfquery>
								
		<cfif Selected.Candidates lt Post.Posts>
		
			<cfset keepopen = "Track will be kept open to facilitate selection of additional candidates">		
			<!--- disabled based on discussion 1/2/2006 
		
			<cf_message 
		    	message="You must select at least <cfoutput>#Check2.Posts#</cfoutput> candidates" 
				return="back">
					
				<cfset Process = "0">
			
			--->	
			
		<cfelseif Selected.Candidates gt Post.Posts>	
		
			<cf_message 
		    	message="You may not select more candidates than the No. of positions <cfoutput>#Post.Posts#</cfoutput> associated to this track." 
				return="back">
					
				<cfset Process = "0">
		
		</cfif>
							
</cfif>

