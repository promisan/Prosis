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


<!--- Pending

0. Control prepare is used by the control tree as per dev assesment 4/16/2011

1.  Define first step with status 0 or 1 (hold) for either candidate or document,      
2.	Identify the actioncode and parentcode for the last action 
3.	Filter on mission and status and selected step
4.  Now combine header and candidates and create a summary	  
5.	Summarize both table by Mission, ParentCode, ListingOrder, Number
    -> graph by parent showing total
	-> listing for expand (parent -> actioncode - temp table
	-> graph by age of the vactrack >90, 60-90, 30-60, 0-30	
6.	Create detail/lookup tables	
--->	
	
<!--- pending : limit on select mission, status document --->

<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cfset pre = mission.missionPrefix>
	
<cfif URL.Parent eq "All" and url.status neq "1">	<!--- show by stage --->	
			
	<cfsavecontent variable="session.selectedtracks_#pre#">
	
		<cfoutput>		
		    SELECT  *		
			FROM    (#preservesingleQuotes(session.SelectTracks)#) as T				
			<!--- added to make sure that some workflow were completed and might not be in the subtable --->									
			WHERE   1=1 
			<cfif vCondition neq "">
			#PreserveSingleQuotes(vCondition)#						
			</cfif>
		</cfoutput>	
	
	</cfsavecontent>
		
	<!--- ---------------------- --->		
	<!--- Summary Workflow stage --->
	<!--- ---------------------- --->
	
	<cfset qryvar = evaluate("session.selectedtracks_#pre#")>
	
	<cfquery name="Summary"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	   SELECT EntityCode,
	          Code,
			  Description, 
			  ListingOrder,
			  SUM(counted) as Counted   
	   
	   FROM   (	  
	
				SELECT    T.EntityCode              as EntityCode, 
						  ISNULL(T.ParentCode,0)    as Code, 
						  ISNULL(R.Description,'PARENT NOT SET')  as Description, 
						  ISNULL(R.ListingOrder,0) as ListingOrder,
						  COUNT(T.DocumentNo)  as Counted 				
				
				FROM      (#preservesingleQuotes(qryvar)#) T LEFT OUTER JOIN Organization.dbo.Ref_EntityActionParent R 
							  ON   T.EntityCode = R.EntityCode 
							  AND  T.ParentCode = R.Code
							  -- AND  R.EntityCode IN ('VacDocument','VacCandidate') <!--- not needed --->
							  AND  T.Owner = R.Owner		
    
				GROUP BY  T.EntityCode, 
				          T.ParentCode, 						  						 
						  R.Description, 
						  R.ListingOrder ) as Embed
						  
		GROUP BY  EntityCode, Code, Description, ListingOrder 				  
		
		ORDER BY  ListingOrder 
				
	</cfquery>	
		
	<cfquery name="DocumentType"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	    SELECT   TypeDescription,	        
			     count(DISTINCT DocumentNo) as Counted   	   
	    FROM     (#preservesingleQuotes(qryvar)#) T     						  
		GROUP BY TypeDescription	
		ORDER BY count(DISTINCT DocumentNo) DESC				
	</cfquery>	
	
	<!--- ---------------------- --->	
	<!--- -----Total documents-- --->
	<!--- ---------------------- --->
	
	<cfquery name="Count"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     COUNT(DISTINCT DocumentNo) as Total
		FROM       (#preservesingleQuotes(qryvar)#) as T
	</cfquery>
		
	<!--- ---------------------- --->	
	<!--- ------Total tracks---- --->
	<!--- ---------------------- --->
						
	<cfquery name="Sum" dbtype="query">
		SELECT     SUM(counted) as Total
		FROM       Summary
	</cfquery>		
			
<cfelse> 
	
	<!--- --------------------------------- --->
	<!--- show for a selected step by grade --->
	<!--- --------------------------------- --->
			
	 <cfsavecontent variable="session.selectedtracks_#pre#">
  
     	<cfoutput>	
			SELECT   T.*, R.PostGradeBudget, R.PostOrderBudget
			FROM     (#preservesingleQuotes(session.SelectTracks)#) as T  INNER JOIN Employee.dbo.Ref_PostGrade R ON  T.PostGrade = R.PostGrade
			WHERE    1=1 		
			<cfif vCondition neq "">
				     #PreserveSingleQuotes(vCondition)#
			</cfif>					
			
		</cfoutput>
		
	 </cfsavecontent>	
		 
	 <cfset qryvar = evaluate("session.selectedtracks_#pre#")>	 
	 	 	
	<!--- summary by grade --->
	
	<cfquery name="Summary"
		datasource="AppsEmployee"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
		SELECT    PostGradeBudget, 
				  PostOrderBudget,
				  COUNT(T.documentNo) AS counted  		
		FROM      (#preserveSingleQuotes(qryvar)#) as T <!--- P.PostGradeVactrack = '1' --->
		WHERE      1=1
		GROUP BY  PostGradeBudget, PostOrderBudget
		ORDER BY  PostOrderBudget 
		
	</cfquery>		
	
	<cfquery name="Count"
	datasource="AppsEmployee"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     COUNT(DISTINCT DocumentNo) as Total
		FROM       (#preservesingleQuotes(qryvar)#) as T
	</cfquery>
	
	<cfquery name="Sum" dbtype="query">
		SELECT     SUM(counted) as Total
		FROM       Summary
	</cfquery>
	
	<cfquery name="DocumentType"
	datasource="AppsEmployee"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	    SELECT   TypeDescription,	        
			     count(DISTINCT DocumentNo) as Counted   	   
	    FROM     (#preservesingleQuotes(qryvar)#) T     						  
		GROUP BY TypeDescription						
	</cfquery>	
					
</cfif>
	
<cfoutput>

	<cfsavecontent variable="subset">
	
		SELECT  *				
		FROM    (#preservesingleQuotes(qryvar)#) as T	
		<!--- is posted --->
		WHERE   DatePosted is not NULL
		<!--- no selected candidate yet --->
		AND     T.DocumentNo NOT IN (SELECT DocumentNo FROM DocumentCandidate WHERE Status IN ('2s','3'))
		
	</cfsavecontent>	
	
</cfoutput>
		
<cfquery name="agingBase"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     stAging
		ORDER BY ListingOrder
</cfquery>
	
<cfquery name="Aging"
		datasource="AppsVacancy"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		
		SELECT *
		FROM (		
										
			<cfloop query="AgingBase">
				SELECT  '#Description#'         as Description, 
						'#ListingOrder#'        as ListingOrder,
						 COUNT(DISTINCT ObjectKeyValue1) as counted 
				FROM    (#preserveSingleQuotes(subset)#) as T
				WHERE   #Condition#
				<cfif recordcount neq currentrow>
				UNION
				</cfif>
			</cfloop>
		 ) as D
			  
		WHERE  counted > 0	  
			  
		ORDER BY ListingOrder	
				
</cfquery>	
	
<!--- ------------------------ --->	
<!--- detail views for vacancy --->
<!--- ------------------------ --->
	
<cfif URL.Parent eq "All">	
	
	<cfquery name="DetailsDocument"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	
		SELECT    D.*, 
	       	      T.TypeDescription,				  
		          T.ParentCode,
				  T.EntityClassName,
	 			  T.ActionCode,
	 			  T.ActionDescription,
				  T.ActionDescriptionStep,
				  
				  (SELECT count(*)
				   FROM   Vacancy.dbo.DocumentCandidate
				   WHERE DocumentNo = D.DocumentNo
				   AND   Status IN ('2s','3')) as Candidates,
				   
				  (SELECT DateEffective
			  	   FROM   Applicant.dbo.FunctionOrganization
				   WHERE  FunctionId = D.FunctionId) as DatePosted,
				  
				  (SELECT F.ReferenceNo 
				   FROM Applicant.dbo.FunctionOrganization F 
				   WHERE D.FunctionId = F.FunctionId) as VAReferenceNo,
				 		 
				  (SELECT O.OrgUnitNameShort
				   FROM   Organization.dbo.Organization O, Employee.dbo.Position P
				   WHERE  P.OrgUnitOperational = O.OrgUnit
				   AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort 
			
		FROM      Vacancy.dbo.Document D 
		          INNER JOIN (#preservesingleQuotes(qryvar)#) as T  ON D.DocumentNo = T.ObjectKeyValue1 
				  
		WHERE     EntityCode = 'VacDocument'
				  <cfif vCondition2 neq "">
					#PreserveSingleQuotes(vCondition2)# 
				  </cfif>
			 
	</cfquery>	
	
	<!---	
	<cfoutput>
	D : #cfquery.executiontime#
	</cfoutput>
	--->
	
	<!--- details candidate --->
	
	<cfquery name="DetailsCandidate"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	
		SELECT    V.*, 
		          V.TypeDescription,
		          A.IndexNo, 
				  A.PersonNo, 
				  A.LastName, 
				  A.FirstName, 
				  A.Gender, 
				  A.Nationality, 
				  			  
				  (SELECT F.ReferenceNo 
				   FROM   Applicant.dbo.FunctionOrganization F 
				   WHERE  V.FunctionId = F.FunctionId) as VAReferenceNo,
				  
				  (SELECT O.OrgUnitNameShort
				   FROM   Organization.dbo.Organization O, Employee.dbo.Position P
				   WHERE  P.OrgUnitOperational = O.OrgUnit
				   AND    P.PositionNo = V.PositionNo) as OrgUnitNameShort 
			
		FROM      Vacancy.dbo.DocumentCandidate D INNER JOIN 
		         (#preservesingleQuotes(qryvar)#) as V  ON D.DocumentNo = V.ObjectKeyValue1 AND D.PersonNo = V.ObjectKeyValue2  INNER JOIN
		          Applicant.dbo.Applicant A  ON D.PersonNo = A.PersonNo 
			  
	</cfquery>	
	
	
<cfelse>

	<!--- details --->
		
	<cfquery name="detailsDocument"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    D.*, 
	          T.TypeDescription,
	          T.EntityClassName, 
			  T.ActionCode,
			  T.PostGradeBudget, 
			  T.PostOrderBudget,
			  F.ReferenceNo as VAReferenceNo,
			  
			    (SELECT count(*)
				   FROM  Vacancy.dbo.DocumentCandidate
				   WHERE DocumentNo = D.DocumentNo
				   AND   Status IN ('2s','3')) as Candidates,
			  
			  (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort 
			
	FROM      Vacancy.dbo.Document D 
	          INNER JOIN (#preservesingleQuotes(qryvar)#) as T ON D.DocumentNo = T.DocumentNo 
			  LEFT OUTER JOIN Applicant.dbo.FunctionOrganization F ON D.FunctionId = F.FunctionId 
			  <cfif vCondition2 neq "">
				#PreserveSingleQuotes(vCondition2)#
			  </cfif>
	WHERE      T.EntityCode = 'VacDocument'		  
	</cfquery>	
		
	<!--- details candidate --->
		
	<cfquery name="detailsCandidate"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    DISTINCT V.*, 
	          T.TypeDescription,
	          A.IndexNo, 
			  A.PersonNo, 
			  A.LastName, 
			  A.FirstName, 
			  A.Gender, 
			  A.Nationality, 
			  T.PostGradeBudget, 
			  T.PostOrderBudget, 
			  T.EntityClassName,
			  F.ReferenceNo as VAReferenceNo,
			  
			  (SELECT O.OrgUnitNameShort
			   FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			   WHERE  P.OrgUnitOperational = O.OrgUnit
			   AND    P.PositionNo = V.PositionNo) as OrgUnitNameShort 			  
	
	FROM      Vacancy.dbo.DocumentCandidate D INNER JOIN  
	          Vacancy.dbo.Document V ON D.DocumentNo = V.DocumentNo         INNER JOIN 
	          (#preservesingleQuotes(qryvar)#) as T  ON T.DocumentNo = V.DocumentNo INNER JOIN
	          Applicant.dbo.Applicant A ON A.PersonNo = D.PersonNo LEFT OUTER JOIN
			  Applicant.dbo.FunctionOrganization F ON V.FunctionId = F.FunctionId	
	
	</cfquery>	
		
</cfif>


