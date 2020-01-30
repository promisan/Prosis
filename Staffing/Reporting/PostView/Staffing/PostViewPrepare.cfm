
<!--- create a container for the budget amounts --->

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionView#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionViewT#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionViewC#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionView1#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionView2#FileNo#"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Vacants#FileNo#"> 

<cfinclude template="../../../Application/Assignment/AssignmentVerify.cfm">

<cfquery name="Parameter" 
 datasource="AppsEmployee" 
 maxrows=1 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfif URL.Tree eq "Operational">
	
	<cfquery name="Param" 
	 datasource="AppsEmployee" 
	 maxrows=1 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>

<cfelse>

	<!--- we always apply the standard view --->

	<cfparam name="Param.StaffingViewMode" default="Standard">

</cfif>

<!--- check mandate --->
<cfquery name="Mandate" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT *, getDate() as Today
		FROM   Ref_Mandate
		WHERE  MandateNo = '#URL.Mandate#'
		AND    Mission   = '#URL.Mission#' 
</cfquery>	
	
	<cfset st = "date">

		<cfif URL.Snap eq "">
				
			<cfif Mandate.DateExpiration lt Mandate.Today>
			   <cfset DTE = "#DateFormat(Mandate.DateExpiration,CLIENT.DateSQL)#">
			   <cfset DT  = "#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
			<cfelseif Mandate.DateEffective gt Mandate.Today>   
               <cfset DTE = "#DateFormat(Mandate.DateEffective,CLIENT.DateSQL)#">
			   <cfset DT  = "#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
			<cfelse> 
			   <cfset DTE = "#DateFormat(Mandate.Today,CLIENT.DateSQL)#">
			   <cfset DT  = "#DateFormat(Mandate.Today,CLIENT.DateFormatShow)#">
			   <cfset st  = "today">
			</cfif>
			
		<cfelse>
		
    		<CF_DateConvert Value="#URL.Snap#">
			<cfset DTE = "#DateFormat(dateValue,CLIENT.DateSQL)#">
    		<cfset DT = "#URL.Snap#">
			
		</cfif>	
				
		<CF_DateConvert Value="#DT#">
		<cfset Date = dateValue>
				
		<!--- check if view exists, if not create view --->		
		<cfinclude template="PostViewResource.cfm">		
					
		<!--- ----------------------------------------------------------------------------------- --->
		<!--- get the positions and assignments data for this mission, mandate and selection date --->
		<!--- ----------------------------------------------------------------------------------- --->										
		<cfinclude template="FactTable.cfm">
		<!--- ----------------------------------------------------------------------------------- --->
				
	    <!--- get the fact tables into a variable --->
		
		<cfset ass = "userQuery.dbo.#SESSION.acc#_WhsStaffingAssignment#FileNo#"> 
		<cfset pos = "userQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#">  
		
		<cfquery name="Source" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT TOP 1 Created
		    FROM  #pos# 
		</cfquery>
										
		<!--- insert/generate all cross tab entries ---->
						
		<cfif url.tree eq "Administrative">
		   
		      <cfset unitfield = "OrgUnitAdministrative">
			  <cfset orgsel = "P.AdministrativeOrgUnitName as OrgUnitName,P.AdministrativeOrgUnitClass as OrgUnitClass,P.AdministrativeHierarchyCode as HierarchyCode,P.AdministrativeOrgUnitCode as OrgunitCode,P.OperationaLMission,P.OperationalMandateNo"> 			
			  
		<cfelse>
		
			  <cfset unitfield = "OrgUnitOperational">
			  <!--- problem with operational mission which caused duplication, I solved it by puttin the operational mission from the mission field --->		
			  <cfset orgsel = "P.OrgUnitName,P.OrgUnitClass,P.HierarchyCode,P.OrgUnitCode,P.Mission as OperationalMission,P.MandateNo as OperationalMandateNo"> 		
			  
		</cfif>		
		
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Grade2_#FileNo#"> 
		
		<!--- generate a temp table to populate --->
				
		<cfquery name="Generate" 
		 datasource="AppsQuery" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
	 		<cfset cnt = 0>
			
			<cfif Param.StaffingViewMode eq "Extended">
			    <cfset list = "Aut,NonAut,IncUsd,Vacancy,GTA,IncumbGTA,VacantGTA">		
			<cfelse>				
				<cfset list = "Aut,NonAut,IncUsd,Vacancy">				 
			</cfif>		
			
				 
	 
	        <cfloop index="itm" list="#list#">
			
				 <cfset cnt = cnt+1>
				 
				 <cfif cnt gt "1">
				 	UNION
				 </cfif>
			 
				 SELECT DISTINCT P.Mission,
				                 #orgsel#,
				                 P.#unitfield# as OrgUnit,
								 #date# as SelectionDate,
								 P.OrgExpiration,
				                 '#itm#' as Class,
				                 S.PostGradeBudget, 
								 S.PostOrderBudget, 
								 S.ViewOrder, 
								 S.Code,
								 S.Count,
								 #cnt# as ListOrder,		
								 0 as Total,
								 0 as TotalCum
				
				 <cfif cnt eq "1">				 
				 INTO         dbo.#SESSION.acc#Grade2_#FileNo#
				 </cfif>
				 
				 FROM         #pos# P CROSS JOIN
		                      #SESSION.acc#Resource#FileNo# S
				 WHERE		  P.#unitfield# is not NULL	
				 
			</cfloop>				
			 	 		 			  		  			  		  
			 ORDER BY P.#unitfield#, Class, S.ViewOrder, S.PostOrderBudget 
			 							
		</cfquery>
																		
		<cfquery name="Index" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE CLUSTERED INDEX [HierarchyInd] 
		   ON dbo.#SESSION.acc#Grade2_#FileNo#([HierarchyCode]) ON [PRIMARY]
		   
		 CREATE INDEX [GroupingInd] 
		   ON dbo.#SESSION.acc#Grade2_#FileNo#([HierarchyCode],[Class],[PostGradeBudget],[Code]) ON [PRIMARY]  
		</cfquery>			
										
		<!--- calculate cell total to be merged --->
								 
		 <cfsavecontent variable="Base">
		 
		 <cfoutput>
		 
		        SELECT    P.#unitfield#, 
		                  'Aut' as Class,
				          PostGradeBudget,
				          COUNT(DISTINCT P.PositionNo) AS Total
						  					
				FROM      #pos# P
				WHERE     1 = 1
				<cfif Param.StaffingViewMode eq "Extended">		
				AND       P.PostInBudget = '1'						
				</cfif>
				AND       P.PostAuthorised = 1		
				GROUP BY  P.#unitfield#, 
				          P.PostGradeBudget						 
				
		UNION		
		
		        SELECT    P.#unitfield#, 
		                  'NonAut' as Class,
				          PostGradeBudget,
				          COUNT(DISTINCT P.PositionNo) AS Total			
				FROM      #pos# P
				WHERE     1 = 1
				<cfif Param.StaffingViewMode eq "Extended">		
				AND       P.PostInBudget = '1'								
				</cfif>
				AND       P.PostAuthorised = 0
				GROUP BY  P.#unitfield#, 
				          P.PostGradeBudget		
					
		UNION
		
		 		SELECT   P.#unitfield#, 
		                 'Vacancy' as Class,
      				     P.PostGradeBudget,
				         COUNT(DISTINCT P.PositionNo) - COUNT(DISTINCT A.AssignmentNo) AS Total 
			    FROM     #Pos# P LEFT OUTER JOIN #ass# A ON P.PositionNo = A.PositionNo AND A.Incumbency > 0
				WHERE    1=1	
				<cfif Param.StaffingViewMode eq "Extended">		
				AND      P.PostInBudget = '1'	
				</cfif>
				GROUP BY P.#unitfield#, P.PostGradeBudget		
				
		<cfif Param.StaffingViewMode eq "Extended">		
				
		UNION	
			
				SELECT   P.#unitfield#, 
				         'GTA' as Class,
						 PostGradeBudget,
						 COUNT(DISTINCT P.PositionNo) AS Total
				FROM     #pos# P
				WHERE    P.PostInBudget = '0'	
				GROUP BY P.#unitfield#, 
				         P.PostGradeBudget		
						 	
		UNION		
		
				SELECT   P.#unitfield#, 
				         'VacantGTA' as Class,
						 P.PostGradeBudget,
						 COUNT(DISTINCT P.PositionNo) - COUNT(DISTINCT A.AssignmentNo) AS Total 
				FROM     #Pos# P LEFT OUTER JOIN #ass# A ON P.PositionNo = A.PositionNo	AND A.Incumbency > 0
				WHERE    P.PostInBudget = '0'	
				GROUP BY P.#unitfield#, 
				         P.PostGradeBudget		
				
		</cfif>			
									
		UNION	
		
		<cfif URL.Tree eq "Operational">
		
       		    SELECT  A.OrgUnitOperational, 
		                'IncUsd' as Class,
				        A.PostGradeBudget,
				        COUNT(DISTINCT A.AssignmentNo) AS Total 
			    FROM   #pos# P, #ass# A 
				WHERE   P.PositionNo = A.PositionNo			
				AND     A.Incumbency > '0' 
				<cfif Param.StaffingViewMode eq "Extended">		
				AND     P.PostInBudget = '1'	
				</cfif>
				AND    NOT A.LastName is NULL				
				GROUP BY A.OrgUnitOperational, 
				         A.PostGradeBudget
				
			<cfif Param.StaffingViewMode eq "Extended">		
					
				UNION
				
				SELECT   A.OrgUnitOperational, 
				         'IncumbGTA' as Class,
						 A.PostGradeBudget,
						 COUNT(DISTINCT A.AssignmentNo) AS Total 
				FROM     #pos# P, #ass# A
				WHERE    P.PositionNo = A.PositionNo				
				AND      A.Incumbency > '0' 
				AND NOT  A.LastName is NULL				
				AND      P.PostInBudget = '0'	
				GROUP BY A.OrgUnitOperational, 
				         A.PostGradeBudget					
					
			</cfif>		
				
		<cfelse>
		
			SELECT  P.#unitfield#, 
			        'IncUsd' as Class,
					A.PostGradeBudget,
					COUNT(DISTINCT A.AssignmentNo) AS Total 
			FROM    #pos# P, #ass# A
					WHERE  P.PositionNo = A.PositionNo				
					AND    NOT A.LastName is NULL		
					<cfif Param.StaffingViewMode eq "Extended">		
					AND    P.PostInBudget = '1'	
					</cfif>
			GROUP BY P.#unitfield#, 
			         A.PostGradeBudget		
			
				<cfif Param.StaffingViewMode eq "Extended">		
				
				UNION 
				
				SELECT  P.#unitfield#, 
				        'IncumbGTA' as Class,
						A.PostGradeBudget,
						COUNT(DISTINCT A.AssignmentNo) AS Total 
				FROM    #pos# P, #ass# A
				WHERE   P.PositionNo = A.PositionNo						
					AND NOT A.LastName is NULL		
					AND P.PostInBudget = '0'	
				GROUP BY P.#unitfield#, A.PostGradeBudget							
				
				</cfif>
								
		</cfif>		
		
		<!---
		ORDER BY P.#unitfield#
		--->
		
		</cfoutput>
		
		</cfsavecontent>
				
		<!---				
		</cfquery>
		--->
		
		<!---
		<cfoutput>c. #cfquery.executionTime#</cfoutput>			
		--->
							
		<!--- update counted CELL values --->
						
		<cfquery name="Position" 
		 datasource="AppsQuery" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE #SESSION.acc#Grade2_#FileNo#	
			 SET    TotalCum = C.Total
			 FROM   #SESSION.acc#Grade2_#FileNo# D,
			        (#preservesingleQuotes(base)#) as C  
			 WHERE  C.#unitfield#       = D.OrgUnit  
			 AND    C.Class             = D.Class
			 AND    C.PostGradeBudget   = D.PostGradeBudget  
			 			
		</cfquery>
	
		<!---
		<cfoutput>d. #cfquery.executionTime#</cfoutput>
		--->
								
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Grade1_#FileNo#">
		
		<!--- ------------ --->
		<!--- update TOTAL --->
		<!--- ------------ --->
				
		<cfquery name="Position" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   OrgUnit, 
			          Class, 
					  SUM(TotalCum) AS Total  
			 INTO     userQuery.dbo.#SESSION.acc#Grade1_#FileNo#
			 FROM     userQuery.dbo.#SESSION.acc#Grade2_#FileNo#
			 GROUP BY OrgUnit, Class
		</cfquery>
		
		<!---			
		<cfoutput>e. #cfquery.executionTime#</cfoutput>
		--->
		
		<cftransaction isolation="READ_UNCOMMITTED">	
				
		<cfquery name="Position" 
		 datasource="AppsQuery" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE #SESSION.acc#Grade2_#FileNo#	
			 SET    TotalCum = C.Total
			 FROM   #SESSION.acc#Grade2_#FileNo# D,
			        #SESSION.acc#Grade1_#FileNo# C
			 WHERE  C.OrgUnit = D.OrgUnit  
			 AND    C.Class = D.Class
			 AND    D.PostGradeBudget = 'Total' 
		</cfquery>
								
		<!--- ------------ --->
		<!--- update SUB   --->
		<!--- ------------ --->
							
		<!--- calculate subtotals from the cell totals --->
				 
		 <cfsavecontent variable="Grade1">
		    <cfoutput>
			 SELECT   G.OrgUnit, 
			          G.Class, 
					  G.Code, 
					  T.ViewOrder, 
					  SUM(G.TotalCum) AS Total			 
			 FROM     #SESSION.acc#Resource#FileNo# R INNER JOIN
	                  Employee.dbo.Ref_PostGradeParent T ON R.Code = T.Code INNER JOIN
	                  #SESSION.acc#Grade2_#FileNo# G ON R.PostGradeBudget = G.PostGradeBudget
			 WHERE    T.ViewTotal = '1'
			 GROUP BY G.OrgUnit, G.Class, G.Code, T.ViewOrder 	
			</cfoutput> 
		</cfsavecontent>				
						
		<cfquery name="Position" 
		 datasource="AppsQuery" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE #SESSION.acc#Grade2_#FileNo#	
			 SET    TotalCum = C.Total
			 FROM   #SESSION.acc#Grade2_#FileNo# D,
			        (#preserveSingleQuotes(Grade1)#) C
			 WHERE  C.OrgUnit         = D.OrgUnit     
			 AND    C.Class           = D.Class
			 AND    C.ViewOrder       = D.ViewOrder
			 AND    C.Code            = D.Code
			 AND    D.PostGradeBudget = 'Subtotal' 
		</cfquery>
		
		<!---			
		<cfoutput>2.#cfquery.executionTime#</cfoutput>
		--->
						
		<cfif URL.Unit neq "Cum">
		
			<cfquery name="Position" 
			 datasource="AppsQuery" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE #SESSION.acc#Grade2_#FileNo#	
				 SET    Total = TotalCum 
			</cfquery>
							
		<cfelse>		
		
		<!--- define the number of levels --->
		
		<cfquery name="Check" 
			 datasource="AppsQuery" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">			 
			 SELECT MAX(Len(HierarchyCode)) as Levels
			 FROM #SESSION.acc#Grade2_#FileNo#	
			</cfquery>
			
			<cfif check.levels eq "2">
			  <cfset fr = 1>
			<cfelseif check.levels eq "5">
			  <cfset fr = 2>
			<cfelseif check.levels eq "8">
			  <cfset fr = 3>  
			<cfelseif check.levels eq "11">
			  <cfset fr = 4>  
			<cfelseif check.levels eq "14">
			  <cfset fr = 5>  
			<cfelse>
			  <cfset fr = 6>    
			</cfif>
																				
			<cfloop index="lvl" from="#fr#" to="1" step="-1"> <!--- loops through the levels --->
				
				<!--- define picture of levels --->
				<cfswitch expression="#lvl#">
				
						<cfcase value="6">
						   <cfset No = "17">
						   <cfset hierarchyN = "__.__.__.__.__.__">
						</cfcase>
				
						<cfcase value="5">
						   <cfset No = "14">
						   <cfset hierarchyN = "__.__.__.__.__">
						</cfcase>
						
						<cfcase value="4">
						   <cfset No = "11">
						   <cfset hierarchyN = "__.__.__.__">
						</cfcase>
						
						<cfcase value="3">
						   <cfset No = "8">
						   <cfset hierarchyN = "__.__.__">
						</cfcase>
						
						<cfcase value="2">
						   <cfset No = "5">
						   <cfset hierarchyN = "__.__">
						</cfcase>
				       
						<cfcase value="1">						 
						   <cfset No = "2">
						   <cfset hierarchyN = "__">
						</cfcase>
													
				</cfswitch>
				
				<!--- lump deeper lever to higher level --->
																								
				<!--- update mater table --->
				
				<cfquery name="DefineTotal2" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE #SESSION.acc#Grade2_#FileNo#	
						SET    Total = C.Total
						FROM   dbo.#SESSION.acc#Grade2_#FileNo# D,
						       (
							   
							   SELECT    LEFT(HierarchyCode, #No#) as Grouping, 
						          Class, 
								  Code, 
								  PostGradeBudget, 
								  sum(totalCum) as Total							
								FROM      #SESSION.acc#Grade2_#FileNo#	
								WHERE     LEFT(HierarchyCode, #No#) LIKE '#HierarchyN#' 					
								GROUP BY  LEFT(HierarchyCode, #No#), Class, Code, PostGradeBudget 
								
								) as C
							  
						WHERE  C.Grouping        = D.HierarchyCode
						AND    C.Class           = D.Class
						AND    C.PostGradeBudget = D.PostGradeBudget 
						AND    C.Code            = D.Code 
						
						
				</cfquery>
				
				<!---				
				<cfoutput>3. #cfquery.executiontime#</cfoutput>							
				--->
							
			</cfloop>	
				
						
		</cfif>			
	
	<cfquery name="ResultRows"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT DISTINCT Class 
		FROM #SESSION.acc#Grade2_#FileNo# 
	</cfquery>	
	
	</cftransaction>	
	
<cfset strows = ResultRows.RecordCount>
			
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Resource#FileNo#"> 