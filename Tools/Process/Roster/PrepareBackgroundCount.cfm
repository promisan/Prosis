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
<cfparam name="Attributes.PersonNo"	      	default="">
<cfparam name="Attributes.ApplicantNo"	  	default="">
<cfparam name="Attributes.Source"	      	default="">
<cfparam name="Attributes.ExperienceClass"  default="">
<cfparam name="Attributes.Reviewed"  		default="">
<cfparam name="Attributes.Owner"  			default="">
<cfparam name="Attributes.IDFunction"     default="">

<cfif Attributes.ApplicantNo eq "">

	<cfquery name="getSubmission" 
	     datasource="AppsSelection" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT   *
			 FROM     ApplicantSubmission S
			 WHERE    PersonNo  = '#Attributes.PersonNo#'
			 AND      Source	= '#Attributes.Source#' 
			 ORDER    BY Created DESC
	</cfquery>	

	<cfset Attributes.ApplicantNo = getSubmission.ApplicantNo>
	
<cfelse>

	<cfquery name="getSubmission" 
	     datasource="AppsSelection" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT   *
			 FROM     ApplicantSubmission S
			 WHERE    ApplicantNo  = '#Attributes.ApplicantNo#'
			 ORDER    BY Created DESC
	</cfquery>	

</cfif>

 <cfquery name="qDelete" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	DELETE skBackgroundCount
     	WHERE ApplicantNo 	 = '#Attributes.ApplicantNo#'
 </cfquery>

<cfif getSubmission.recordcount eq 0>

	<cfset Caller.years  = 0>
	<cfset Caller.months = 0>
	
<cfelse>

	<cfif Attributes.Reviewed eq "Yes">
		<!---Take the most recent reviewed experience --->
		 <cfquery name="qReview" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		
				SELECT ReviewId FROM ApplicantReviewBackground
				WHERE PersonNo='#Attributes.PersonNo#'		
				<cfif Attributes.Owner neq "">
					AND   ReviewId IN (
						SELECT ReviewId
						FROM   ApplicantReview
						WHERE  Owner = '#Attributes.Owner#'
					)
				</cfif>
				ORDER BY Created Desc
		 </cfquery>
		 		
		 <cfif qReview.recordcount neq 0>
			 <cfset vReviewId = qReview.ReviewId>
		 <cfelse>	 
			  <cfset vReviewId = "">
		 </cfif>	 
		
	</cfif>
		
	<cfquery name="qCheck" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 
	    SELECT TOP 1 *
		FROM   ApplicantSubmission S
	
		 <cfif attributes.IDFunction neq "">
		 
		 		INNER JOIN ApplicantFunction AF
					ON S.ApplicantNo = AF.ApplicantNo AND AF.FunctionId = '#Attributes.IDFunction#'
				INNER JOIN ApplicantFunctionSubmission AFS
					ON AF.ApplicantNo = AF.ApplicantNo AND AF.FunctionId = AFS.FunctionId
				WHERE S.PersonNo ='#URL.PersonNo#'
		 <cfelse>
			WHERE 	1=0
		 </cfif>	
		  
	</cfquery>
	
	<cfif Attributes.IDFunction neq "" and qCheck.recordcount neq 0>
	
		<cfquery name="Work" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   E.ExperienceClass, S.SubmissionId AS ExperienceId, AFSF.ExperienceFieldId, AFS.ExperienceStart, AFS.ExperienceEnd
		FROM     ApplicantFunctionSubmission AFS INNER JOIN ApplicantFunctionSubmission S ON AFS.SubmissionId = S.SubmissionId 
					INNER JOIN ApplicantFunctionSubmissionField AFSF ON AFSF.SubmissionId = S.SubmissionId
					LEFT OUTER JOIN Ref_Experience E ON E.ExperienceFieldId = AFSF.ExperienceFieldId
		WHERE    S.ApplicantNo  = '#Attributes.ApplicantNo#'
		AND      AFS.ExperienceCategory       = 'Employment'
		AND      AFS.Status IN (0,1)
		AND      AFSF.Status != 9
		AND      AFS.FunctionId = '#Attributes.IDFunction#'
		<cfif Attributes.ExperienceClass neq "">
				AND    E.ExperienceClass     = '#Attributes.ExperienceClass#'
		</cfif>
		
		<cfif Attributes.Reviewed eq "Yes">
		AND    EXISTS (SELECT 'X' FROM ApplicantFunctionSubmissionField ARB 
						WHERE ARB.SubmissionId = S.SubmissionId AND ARB.Status!=9)
		</cfif>
		ORDER BY ISNULL(S.ExperienceEnd, '9999-12-31') DESC,
		         S.ExperienceStart DESC, 
		         S.SubmissionId  

	    </cfquery>
				
	<cfelse>
		
		<cfquery name="Work" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT E.ExperienceClass, B.ExperienceId, E.ExperienceFieldId, B.ExperienceStart, B.ExperienceEnd
			FROM   ApplicantBackground B 
			       LEFT OUTER JOIN ApplicantBackgroundField BF ON B.ApplicantNo = BF.ApplicantNo AND B.ExperienceId      = BF.ExperienceId 
				   LEFT OUTER JOIN Ref_Experience E            ON E.ExperienceFieldId = BF.ExperienceFieldId
			WHERE  B.ApplicantNo         = '#Attributes.ApplicantNo#'
			AND    B.ExperienceCategory  = 'Employment'
			AND    B.Status IN ('0','1')
			<cfif Attributes.ExperienceClass neq "">
			AND    E.ExperienceClass     = '#Attributes.ExperienceClass#'
			</cfif>
			<cfif Attributes.Reviewed eq "Yes">
			AND    EXISTS (SELECT 'X' FROM ApplicantReviewBackground ARB 
					WHERE ARB.ExperienceId = B.ExperienceId <cfif vReviewId neq "">AND ARB.ReviewId = '#vReviewId#'</cfif>)
			</cfif>	
			ORDER  BY ExperienceStart DESC
	   </cfquery>	
	
	</cfif>
		
	
	<cfset durT = 0>
	
	<cfloop query = "Work">
	 	 
	  <cfif ExperienceStart neq "" and (ExperienceEnd gt ExperienceStart or ExperienceEnd eq "")>
	  
	    <cfif ExperienceEnd eq "">
		  <cfset end = now()>		  
		<cfelse>
		  <cfset end = ExperienceEnd>
		</cfif>
			
		<!--- KRW 10/11/06: adding in case days are part of dates: 
		Business rule: 20 days over a whole month counts as extra month
		Less than 20 days remainder counts as one less month --->
		  
		  <cfset dayDiff = Day(end)-Day(ExperienceStart)>
		  <cfif dayDiff gte 20>
		   	<cfset MonthPart = 1>
		  <cfelse>
		 	<cfset MonthPart = 0>		  		
		  </cfif>
		  
	      <cfset st   = year(ExperienceStart)*12>
		  <cfset st   = st+month(ExperienceStart)>
		  
		  <cfset ed   = year(end)*12>
		  <cfset ed   = ed+month(end)>
		  <cfset dur  = (ed-st+MonthPart)>		  
		  <cfset span = (st+dur-1)>
		  
	          <!---  <cfloop index="m" from="#st#" to="#ed#">   --->
	          <!---  KRW 10/11/06: eliminates the adding of 1 extra month per history record --->			  
			  
		   
		   <cfloop index="m" from="#st#" to="#span#">	
		   
		   		<cfif ExperienceFieldId neq "">
				
					<cflock scope="Session" timeout="10" type ="Exclusive">		
					
		    			<cfif Attributes.IDFunction neq "" and qCheck.recordcount neq 0>
												
						  <cfquery name="Insert" 
					       	datasource="AppsSelection" 
					       	username="#SESSION.login#" 
					       	password="#SESSION.dbpw#">
					       	INSERT INTO skBackgroundCount
						   	(ApplicantNo, ExperienceId, ExperienceFieldId, ExperienceClass, MonthNo)
							
						   	SELECT 	ApplicantNo,
						   			AFS.SubmissionId,
						   			ExperienceFieldId,
						   			'#ExperienceClass#',#m#
									
						   	FROM    ApplicantFunctionSubmissionField ABF INNER JOIN ApplicantFunctionSubmission AFS ON ABF.SubmissionId = AFS.SubmissionId

						    WHERE   AFS.ApplicantNo 	 = '#Attributes.ApplicantNo#'
				       		AND     AFS.SubmissionId 	 = '#ExperienceId#' 
				       		AND     ExperienceFieldId    = '#ExperienceFieldId#'
							
				       		AND NOT EXISTS (
				       			
				       			SELECT 'X'
							    FROM  skBackgroundCount
							    WHERE ApplicantNo 	  = AFS.ApplicantNo
							    AND   ExperienceId 	  = ABF.SubmissionId
							    AND   ExperienceFieldId = ABF.ExperienceFieldId
							    AND   MonthNo           = '#m#'   
				       		)
							
					      </cfquery>

					     <cfelse>
						 						 						 
						  <cfquery name="Insert" 
					       	datasource="AppsSelection" 
					       	username="#SESSION.login#" 
					       	password="#SESSION.dbpw#">
					       	INSERT INTO skBackgroundCount
						         	(ApplicantNo, ExperienceId, ExperienceFieldId, ExperienceClass, MonthNo)
						   	SELECT 	ApplicantNo,
						   			ExperienceId,
						   			ExperienceFieldId,
						   			'#ExperienceClass#',	
						   			#m#
						   	FROM   ApplicantBackgroundField ABF
						    WHERE  ApplicantNo 	     = '#Attributes.ApplicantNo#'
				       		AND    ExperienceId 	 = '#ExperienceId#' 
				       		AND    ExperienceFieldId = '#ExperienceFieldId#'
							
				       		AND NOT EXISTS (
				       			
				       			SELECT 'X'
							    FROM   skBackgroundCount
							    WHERE  ApplicantNo 	     = ABF.ApplicantNo
							    AND    ExperienceId 	 = ABF.ExperienceId
							    AND    ExperienceFieldId = ABF.ExperienceFieldId
							    AND    MonthNo           = '#m#'  
								 
				       		)
							
							
					      </cfquery>

					     </cfif>
						    
					</cflock>	
				
				<cfelse>
								
					  <cfquery name="qCheck" 
				       datasource="AppsSelection" 
				       username="#SESSION.login#" 
				       password="#SESSION.dbpw#">
					       SELECT * 
					       FROM  skBackgroundCount
					       WHERE ApplicantNo 	   = '#Attributes.ApplicantNo#'
					       AND   ExperienceId 	   = '#ExperienceId#'
					       AND   ExperienceFieldId = '#ExperienceFieldId#'
					       AND   MonthNo           = '#m#'   
					  </cfquery>
					  
					  <cfif qCheck.recordCount eq 0> 
					  
							  <cfquery name="Insert" 
					       	datasource="AppsSelection" 
					       	username="#SESSION.login#" 
					       	password="#SESSION.dbpw#">
					       	INSERT INTO skBackgroundCount
						   	(ApplicantNo, ExperienceId, ExperienceFieldId, ExperienceClass, MonthNo) 
						   			VALUES (
							   			'#Attributes.ApplicantNo#',
						   				'#ExperienceId#',
						   				'#ExperienceFieldId#',
						   				'#ExperienceClass#',	
						   				#m#
						   			)  
					      	</cfquery>
				      </cfif>	
				
				</cfif>
		   	     
		  </cfloop>
		  
	  <cfelse>	 
	   	  <cfset dur = 0> 
	  </cfif>	  
	  
	
	</cfloop>
	
	<cfset caller.ApplicantNo = Attributes.ApplicantNo>

</cfif>

