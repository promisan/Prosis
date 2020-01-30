
<cfparam name="Form.PriorityCode" default="0">
<cfparam name="Form.Selected"     default="">
<cfparam name="Form.fApplicantNo" default="">


<!--- remove prior background --->

<cftry>

	<cfquery name="Record" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Priority
		(Code,Description)
		VALUES ('0','Standard') 
	</cfquery>

<cfcatch></cfcatch>

</cftry>
	
	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ApplicantReview 
		SET    PriorityCode = '#Form.PriorityCode#'
		WHERE  ReviewId     = '#Form.Key4#' 
	</cfquery>

	<cfquery name="Remove" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ApplicantReviewBackground 
	WHERE  PersonNo   = '#Form.Key1#'
	AND    ReviewId   = '#Form.Key4#' 
    </cfquery>

<cfif Form.Selected is not ""> 

	<!--- define selected users --->
	
	<cfloop index="Item" 
	           list="#Form.Selected#" 
	           delimiters="' ,">
			   
		<cftry> 	   
								   
			<cfquery name="Insert" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ApplicantReviewBackground 
			          (PersonNo, 
				  	   ReviewId,
					   ExperienceId)
			VALUES   ('#Form.Key1#',
					  '#Form.Key4#',
					  '#Item#') 
			</cfquery>		
		
		<cfcatch></cfcatch>
		
		</cftry>
		
		<!--- posting the results of the review on the level of the owenr in ApplicantBackgroundField and ApplicantBackgroundFieldOwner --->
		
		<cfset suf = replaceNoCase(item,"-","","ALL")>	
		<cfparam name="form.fieldid_#suf#" default="">	
		<cfset fields = evaluate("form.fieldid_#suf#")>
				 			 			  
		<!--- 			  
		  a.	we remove any assessment of the same owner in ApplicantBackgroundFieldOwner.			  
		  b.	we populate the list and also populate the owner table			  
		--->
		
		<cfquery name="get" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ApplicantBackground
				WHERE  ExperienceId = '#item#'  			
		</cfquery>	
				
		<cfquery name="deactiveAll" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE ApplicantBackgroundField
				SET    Status         = '9'
				WHERE  ApplicantNo    = '#get.ApplicantNo#'
				AND    ExperienceId   = '#get.ExperienceId#'  			
			    AND    ExperienceFieldId in
				(
					SELECT E.ExperienceFieldId
					FROM Ref_Experience as E INNER JOIN Ref_ExperienceClass C
						ON E.ExperienceClass = C.ExperienceClass
						 INNER JOIN Ref_ExperienceClassOwner CO ON CO.ExperienceClass= C.ExperienceClass
						WHERE CO.Owner = '#FORM.Owner#'
				)	
				<!--- we need to scope this for the keywords that are shown --->
				
		</cfquery>							
		
		<cfloop index="fieldid" list="#fields#" delimiters="',">		 
				
			  <cfquery name="check" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   ApplicantBackgroundField
					WHERE  ApplicantNo       = '#get.ApplicantNo#'
					AND    ExperienceId      = '#get.ExperienceId#'  			
					AND    ExperienceFieldId = '#fieldid#' 
			   </cfquery>		
				
			   <cfif check.recordcount eq "0">
				
					<cfquery name="Insert" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO ApplicantBackgroundField
						          (ApplicantNo,
								   ExperienceId,
								   ExperienceFieldId,
								   Candidate,
								   OfficerUserId,
								   OfficerLastName,
								   OfficerFirstName)
						VALUES ('#get.ApplicantNo#',
						        '#get.ExperienceId#',
								'#fieldid#',
								'0',
								'#session.acc#',
								'#session.last#',
								'#session.first#') 			
					</cfquery>		
									
						<cfquery name="Insert" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO ApplicantBackgroundFieldOwner
								          (ApplicantNo,
										   ExperienceId,
										   ExperienceFieldId,
										   Owner,
										   ReviewId,								   
										   OfficerUserId,
										   OfficerLastName,
										   OfficerFirstName)
							VALUES ('#get.ApplicantNo#',
							        '#get.ExperienceId#',
									'#fieldid#',
									'#form.owner#',		
									'#form.key4#',						
									'#session.acc#',
									'#session.last#',
									'#session.first#') 			
						</cfquery>		
										
				<cfelse>
				
					 <cfquery name="check" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE ApplicantBackgroundField
						SET    Status = '1'
						WHERE  ApplicantNo       = '#get.ApplicantNo#'
						AND    ExperienceId      = '#get.ExperienceId#'  			
						AND    ExperienceFieldId = '#fieldid#' 
				   </cfquery>		
				   
				   <!--- record the owner --->
				   							   
					<cfquery name="check" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   ApplicantBackgroundFieldOwner
						WHERE  ApplicantNo       = '#get.ApplicantNo#'			
						AND    ExperienceId      = '#get.ExperienceId#'  			
						AND    ExperienceFieldId = '#fieldid#' 
						AND    Owner             = '#form.owner#'
					</cfquery>
					
					<cfif check.recordcount eq "0">
										
						<cfquery name="Insert" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO ApplicantBackgroundFieldOwner
								          (ApplicantNo,
										   ExperienceId,
										   ExperienceFieldId,
										   Owner,
										   ReviewId,								   
										   OfficerUserId,
										   OfficerLastName,
										   OfficerFirstName)
							VALUES ('#get.ApplicantNo#',
							        '#get.ExperienceId#',
									'#fieldid#',
									'#form.owner#',		
									'#form.key4#',						
									'#session.acc#',
									'#session.last#',
									'#session.first#') 			
						  </cfquery>	
						
					 </cfif>
														
				</cfif>
							   
		</cfloop>	   
	
	</cfloop>

</cfif>


<cfif Form.fApplicantNo neq "">

<!--- Topics --->

<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ApplicantSubmissionTopic
		WHERE ApplicantNo = '#FORM.fApplicantNo#'
		AND   Topic IN (SELECT Topic 
		                FROM   Ref_TopicOwner 
					    WHERE  Owner = '#Form.Owner#' 
						AND    Operational = 1)
</cfquery>


<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 	  SELECT   *
		  FROM     Ref_Topic
		  WHERE    Operational = 1
		  AND Topic IN (SELECT Topic 
		  	            FROM Ref_TopicOwner 
					  	WHERE Owner = '#Form.Owner#'
							  AND Operational = 1)
		  ORDER BY ListingOrder 
</cfquery>

	<cfloop query="Master">
		
		<cfparam name="FORM.value_#Topic#" default="">
	    <cfset value     = Evaluate("FORM.value_" & #Topic#)>
		
		<cfif value neq "">
				
			<cfquery name="InsertTopic" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ApplicantSubmissionTopic 
			         (ApplicantNo,
					 Topic,
					 TopicValue,
					 Source,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#Form.fApplicantNo#', 
			          '#Topic#',
			      	  '#Value#',
					  '#Source#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
	    	  </cfquery>
					  
	  	</cfif>			  
		
		
	</cfloop>	
</cfif>

<cfoutput>
<script>
	try {
		ColdFusion.navigate("#client.root#/Roster/Candidate/Details/Review/BackgroundSummary.cfm?owner=#Form.owner#&applicantNo=#form.fApplicantNo#","ExperienceSummary")
	}
	catch(ex)
	{	}		
</script>	
</cfoutput>