
<cfquery name="Parameter" 
  datasource="AppsVacancy" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Parameter 
</cfquery>

<cfquery name="Param" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_ParameterOwner
</cfquery>

<cfset fileNo = 1>

<cfloop query="Param">
	
	<cfset days   = "#SelectionDays#">
	<cfset filter = "#SelectionFilterScript#">
				
	<CF_DropTable dbName="AppsVacancy" full="1" tblName="skCandidateSelected_#Owner#"> 
	
	<cfif Parameter.mode eq "1">
	
		<!--- n/a --->
		
	<cfelse>
	
	    <cfset seldate = dateformat(now()-days,client.dateSQL)>
		    		
		<cfquery name="Selection" 
		  datasource="AppsVacancy">
		  
			  SELECT  DISTINCT D.DocumentNo, 
			          DC.PersonNo, 
					  D.PostGrade, 
					  D.Mission, 
			          D.FunctionalTitle, 
					  (  SELECT MAX(ReviewDate)
						 FROM   DocumentCandidateReview
						 WHERE  DocumentNo = DC.DocumentNo
						 AND    PersonNo   = DC.PersonNo) as ActionDate, 
					  'Selected' as Status, 
					  getDate() as Created
					  
			  INTO    dbo.skCandidateSelected_#Owner#
			  
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
							  
			   AND     D.Owner = '#Owner#'
			   <cfif filter neq "">
			   #preservesingleQuotes(filter)#			   
			   </cfif>
			   
			  UNION
			   
			  SELECT  DISTINCT D.DocumentNo, 
			                   DC.PersonNo, 
							   D.PostGrade, 
							   D.Mission, 
			                   D.FunctionalTitle, 					  
							   ( SELECT MAX(ReviewDate)
								 FROM   DocumentCandidateReview
								 WHERE  DocumentNo = DC.DocumentNo
								 AND    PersonNo   = DC.PersonNo
							   ) as ActionDate, 
							   'Short-listed' as Status, 
							   getDate() as Created
					  
			  FROM    Document D INNER JOIN
	                  DocumentCandidate DC ON D.DocumentNo = DC.DocumentNo INNER JOIN
					  Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo
					  
			  WHERE   DC.Status IN ('0','1','2')
			  AND     D.Status = '0'
			  AND     D.Owner = '#Owner#'
			  
			  <cfif filter neq "">
			   #preservesingleQuotes(filter)#			   
			  </cfif>
			  
			  <!--- shortlisted for a track that has no selected candudate or less candidates than positions --->
			
			  AND     D.DocumentNo IN (SELECT DocumentNo 
			  
			                           FROM 
									   
									   <!--- derrived table --->
			                           
									   (	
									   
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
									   
									  ) as DerrivedTable
									   
									   <!--- end derrived table --->									   
									   
									  WHERE  DocumentNo = D.DocumentNo
									  AND    Candidates < Positions)
		</cfquery>
	
	</cfif>
		
</cfloop>	
