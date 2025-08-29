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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Vacancy">
	
	<cffunction name="Candidacy"
             access="public"
             returntype="any"
             displayname="Record Position Extension based on the funding">
		
		<cfargument name="Owner"              type="string" required="true"   default="">
		<cfargument name="DocumentNo"         type="string" required="false"  default="">
		<cfargument name="PersonNo"           type="string" required="false"  default="">		
		<cfargument name="Status"             type="string" required="false"  default="">	
		
		<cfif documentNo neq "">
		
			<cfquery name="get" 
			  datasource="AppsVacancy" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    Document
			  WHERE   DocumentNo = '#documentno#'
			</cfquery>		
			
			<cfquery name="Param" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    Ref_ParameterOwner
			  WHERE   Owner = '#get.owner#'
			</cfquery>		
		
		<cfelse>
		
			<cfquery name="Param" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    Ref_ParameterOwner
			  WHERE   Owner = '#owner#'
			</cfquery>		
				
		</cfif>	
		
		<cfquery name="Person" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    Applicant
			  WHERE   PersonNo = '#personno#'
			</cfquery>		
		
		<cfset days   = "#Param.SelectionDays#">
		<cfset filter = "#Param.SelectionFilterScript#">
		
				
		<cfset seldate = dateformat(now()-days,client.dateSQL)>
		
		<cfquery name="get" 
		  datasource="AppsVacancy"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  		  
			  SELECT  DISTINCT D.DocumentNo, 
			          DC.PersonNo, 
					  D.PostGrade, 
					  D.Mission, 
			          D.FunctionalTitle, 
					  DC.Status as ActionStatus,
					  (  SELECT MAX(ReviewDate)
						 FROM   DocumentCandidateReview
						 WHERE  DocumentNo = DC.DocumentNo
						 AND    PersonNo   = DC.PersonNo) as ActionDate, 
					  'Selected' as Status
							  			  
			  FROM    Document D INNER JOIN
	                  DocumentCandidate DC ON D.DocumentNo = DC.DocumentNo INNER JOIN
					  Applicant.dbo.Applicant A ON DC.Personno = A.PersonNo
					  
			  WHERE   (
			           <!--- pending selection --->
			           (DC.Status IN ('2s','3') and D.Status = '0') 
	          	          OR 
					   <!--- prior selection but not expired yet --->	  
					   (DC.Status = '3' AND D.Status = '1' AND DC.StatusDate > '#seldate#')
					   )
					   
			   AND     D.DocumentType IN (SELECT Code FROM Ref_DocumentType WHERE SelectionDays = 1)

			   <cfif Owner neq "">							  
			   AND     D.Owner = '#Owner#'
			   </cfif>
			   
			   AND     D.Mission IN (SELECT Mission FROM  Organization.dbo.Ref_Mission WHERE Operational = 1)
			   
			   <cfif documentNo neq "">
			   AND     D.DocumentNo != '#documentno#'
			   </cfif>
			   
			   <cfif PersonNo neq "">
			   AND    (
			          DC.PersonNo  = '#PersonNo#' <cfif Person.IndexNo neq "">or A.IndexNo = '#Person.IndexNo#'</cfif>
					  )
			   </cfif>
			   
			   <cfif filter neq "">
			   #preservesingleQuotes(filter)#			   
			   </cfif>
			   
			   			   
			   <!--- also include the shortlisted candidacy --->  
			   
			  <cfif Status neq "selected"> 
			   
				  UNION
				   
				  SELECT  DISTINCT D.DocumentNo, 
		                  DC.PersonNo, 
						  D.PostGrade, 
						  D.Mission, 
				          D.FunctionalTitle, 	
						  DC.Status as ActionStatus,				  
						  ( SELECT MAX(ReviewDate)
						    FROM   DocumentCandidateReview
						    WHERE  DocumentNo = DC.DocumentNo
							AND    PersonNo   = DC.PersonNo
						  ) as ActionDate, 
						  'Short-listed' as Status
						  
				  FROM    Document D INNER JOIN
		                  DocumentCandidate DC ON D.DocumentNo = DC.DocumentNo INNER JOIN
						  Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo
						  
				  WHERE   D.Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
				  
				  AND     D.DocumentType IN (SELECT Code FROM Ref_DocumentType WHERE SelectionDays = 1)
			  				    
				  <cfif documentNo neq "">
				   AND     D.DocumentNo != '#documentno#'
				  </cfif>
				   
				  <cfif PersonNo neq "">
			      AND     (
			          DC.PersonNo  = '#PersonNo#' <cfif Person.IndexNo neq "">or A.IndexNo = '#Person.IndexNo#'</cfif>
					  )
			      </cfif>	  
				  
				  AND     DC.Status IN ('0','1','2')
				  AND     D.Status = '0'
				  AND     D.Owner = '#Owner#'
				  
				  <cfif filter neq "">
				     #preservesingleQuotes(filter)#			   
				  </cfif>
				  
				  <!--- shortlisted for a track that has no selected candudate or less candidates than positions --->
				
				  AND     D.DocumentNo IN (SELECT DocumentNo 
				  
				                           FROM  (	
												   
												    <!--- get runtime table with number of selections made for a track --->							   
												   
												    SELECT   D.DocumentNo, 
				  
													          COUNT(*) AS Positions,
															   
															  ( SELECT COUNT(*)
															     FROM      DocumentCandidate P 
													             WHERE     P.Status IN ('2s','3')
													             AND       P.EntityClass is not NULL
																 AND       P.DocumentNo = D.DocumentNo
															  ) as Candidates	 												   
													
													  
												      FROM    Document D INNER JOIN
												              DocumentPost P ON D.DocumentNo = P.DocumentNo
												      
													  WHERE   D.Status = '0'	  
													  AND     D.EntityClass is not NULL <!--- UN condition, can be removed --->
													  AND     D.Owner = '#Owner#'
													  
													  GROUP BY D.DocumentNo
													  
													   <!--- end derrived table --->			
												   
												  ) as DerrivedTable
										   				 						   
										   
										  WHERE  DocumentNo = D.DocumentNo
										  AND    Candidates < Positions)
										  
			  </cfif>
									  
		</cfquery>
				
		<cfreturn get>
							
	</cffunction>	
	
</cfcomponent>