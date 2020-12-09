<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_WhsStaffingPosition#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_WhsStaffingAssignment#FileNo#">

<cfinclude template="MandateFilterApply.cfm">

<!--- take all positions that are found --->

<cfif URL.Tree neq "Functional">


	<cftransaction isolation="read_uncommitted">
 			             
	<cfquery name="Position" 
    datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	    SELECT *
		INTO   userQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
	    FROM   vwPosition Pos
		
		<cfif url.tree eq "Operational">
		
			<!--- 27/3/2011
		   enhanced query to show all positions for units that being loaned to
	       this mission/mandate --->
		
	    WHERE  1=1  AND (		
				   
					   (   Pos.OperationalMission = '#url.mission#'
					   
					       <!--- Hanno 25/5/2014 I dropped this requirement as i made the query 2 seconds slower 
				           AND Pos.OperationalOrgUnit IN (SELECT OrgUnit
				                                  FROM   Organization.dbo.Organization
												  WHERE  Mission   = '#URL.Mission#'
												  AND    Mandateno = '#URL.Mandate#'
												  AND    OrgUnit   = Pos.OperationalOrgUnit )												  
						   --->
						   
					   ) OR (  
					      Pos.Mission        = '#URL.Mission#'
					      AND Pos.MandateNo  = '#URL.Mandate#'				   
					      )			   
			   )						  
		
		<cfelse>
		WHERE  Pos.Mission           = '#URL.Mission#'
		 AND   Pos.MandateNo         = '#URL.Mandate#'
		</cfif> 
		
		 AND   Pos.DateExpiration    >= '#DTE#' 
		 AND   Pos.DateEffective     <= '#DTE#'
		 		 
		 <cfif cat neq "">
		 AND   Pos.PostGradeParent IN (#PreserveSingleQuotes(cat)#) 
		 </cfif>
		 
		 <cfif occ neq "">
		 AND   Pos.OccupationalGroup IN (#PreserveSingleQuotes(occ)#) 
		 </cfif>
		 
		 <cfif cls neq "">
		 AND   Pos.PostClass IN (#PreserveSingleQuotes(cls)#) 
		 </cfif>
		 
		 <cfif pte neq "">
		 AND   Pos.PostType IN (#PreserveSingleQuotes(pte)#) 
		 </cfif>
		 
		 <cfif aut neq "">
		 AND   Pos.PostAuthorised IN (#PreserveSingleQuotes(aut)#) 
		 </cfif>
		 
		 <cfif getAdministrator("#url.mission#") eq "0">		 		 
		 AND   Pos.PostType IN (#preservesingleQuotes(ptpe)#)		  
		 </cfif> 
		 
		 <!--- remove vacant posts to be shown that qualify : save 3 seconds
		
		 AND    (CASE Pos.ShowVacancy WHEN 0 THEN Pos.PositionNo ELSE 1 END ) IN
				 
			    (CASE Pos.ShowVacancy WHEN 0 THEN 
				 
				   (SELECT PositionNo
				    FROM   PersonAssignment 
					WHERE  PositionNo = Pos.PositionNo
					AND    AssignmentStatus IN ('0','1')
					AND    Incumbency > 0
					AND    DateEffective <= '#dte#' 
					AND    DateExpiration > '#dte#') 
					
		           ELSE (1) END )   
				   
		 --->
		 		 
		 ORDER BY Pos.Mission, Pos.HierarchyCode  		  
						 
	</cfquery>	
	
	</cftransaction>
	
	<!---	
	<cfoutput>1. #cfquery.executionTime#</cfoutput>		
	--->
		
<cfelse>

    <!--- retrieve functional relationships in other trees for last valid mandate --->
	
	<cftransaction isolation="read_uncommitted">

	<cfquery name="Position" 
    datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			
		SELECT P.*
		INTO   userQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
		FROM   Ref_Mandate R INNER JOIN 
	    	   Employee.dbo.vwPosition P ON P.Mission = R.Mission and P.MandateNo = R.MandateNo
		WHERE  R.Mission IN 
	                  (SELECT Mission 
					   FROM   Ref_Mission 
					   WHERE  TreeFunctional IS NOT NULL 
					   AND    Operational = 1)
	
		AND    R.DateEffective IN (
	
		         SELECT   MAX(DateEffective)
                 FROM     Ref_Mandate 
                 WHERE    DateEffective <= '#dte#'
		         AND      Mission = R.Mission
		         GROUP BY Mission
		       )
	
		AND    P.OrgUnitFunctional IN (SELECT OrgUnit 
	                                   FROM   Organization 
	                                   WHERE  MissionAssociation = '#url.mission#')
									   
		 AND   P.DateExpiration    >= '#DTE#' 
		 AND   P.DateEffective     <= '#DTE#'		
		 
		 <cfif cat neq "">
		    AND   P.PostGradeParent IN (#PreserveSingleQuotes(cat)#) 
		 </cfif>
		 <cfif occ neq "">
		    AND   P.OccupationalGroup IN (#PreserveSingleQuotes(occ)#) 
		 </cfif>
		 <cfif cls neq "">
		    AND   P.PostClass IN (#PreserveSingleQuotes(cls)#) 
		 </cfif>
		 <cfif pte neq "">
		    AND   P.PostType IN (#PreserveSingleQuotes(pte)#) 
		 </cfif>
		 <cfif aut neq "">
		    AND   P.PostAuthorised IN (#PreserveSingleQuotes(aut)#) 
		 </cfif>	
		
		 <cfif getAdministrator("#url.mission#") eq "0">
		 AND   P.PostType IN (#preservesingleQuotes(ptpe)#)
		 </cfif>

	</cfquery>		
	
	</cftransaction>
		
	<cfquery name="Reset" 
    datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE #SESSION.acc#_WhsStaffingPosition#FileNo#
		SET    Mission                 = '#URL.Mission#', 
		       MandateNo               = '#URL.Mandate#'
	</cfquery>	

</cfif>

<!--- remove positions that have show vaqcancy = 0 and without active assignment --->

<cfquery name="ResetVacancy0" 
    datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE #SESSION.acc#_WhsStaffingPosition#FileNo#
		FROM   #SESSION.acc#_WhsStaffingPosition#FileNo# P
		WHERE  ShowVacancy = 0
		AND    PositionNo NOT IN (SELECT PositionNo
				                  FROM   Employee.dbo.PersonAssignment 
								  WHERE  PositionNo = P.PositionNo
					              AND    AssignmentStatus IN ('0','1')
					              AND    Incumbency > 0
					              AND    DateEffective <= '#dte#' 
					              AND    DateExpiration > '#dte#')
		
</cfquery>	

<!---	
<cfoutput>2. #cfquery.executionTime#</cfoutput>	
--->


<cfif URL.Tree eq "Operational">
	
	<cfset mis = URL.Mission>
	<cfset man = URL.Mandate>		
	
	<!--- Hanno correction for inter entity loans, positions loaned to other missions are counted
	 as authorised / non authorised in the mission that receives the loan now and inherit in the 
	 view all the attributes as if this was a post in that mission  --->	
	
	<cfquery name="ResetMissionTransfer" 
	    datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		UPDATE   #SESSION.acc#_WhsStaffingPosition#FileNo#
		SET      Mission            = '#URL.Mission#', 
		         MandateNo          = '#URL.Mandate#',
				 OrgExpiration      = (SELECT DateExpiration FROM Organization.dbo.Organization WHERE OrgUnit = S.OperationalOrgUnit),				 
				 OrgEffective       = (SELECT DateEffective  FROM Organization.dbo.Organization WHERE OrgUnit = S.OperationalOrgUnit),
				 OrgUnitName        = OperationalOrgUnitName,
				 OrgUnitNameShort   = OperationalOrgUnitNameShort,
				 OrgUnitClass       = OperationalOrgUnitClass,
				 OrgUnitCode        = OperationalOrgUnitCode,
				 HierarchyCode      = OperationalHierarchyCode,				  
			     OrgUnitOperational = OperationalOrgUnit  <!--- was first taken from the parent --->
		FROM     #SESSION.acc#_WhsStaffingPosition#FileNo# S		
		WHERE    Mission != OperationalMission	 
		AND      OperationalMission = '#URL.Mission#'		
		
	</cfquery>		
						
<cfelse>
	
    <!--- determine the tree name --->
	
	<cfquery name="Tree" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_Mission
		WHERE    Mission = '#URL.Mission#'
	</cfquery>
	
	<cfset mis = evaluate("Tree.Tree#URL.Tree#")>
	<cfset man = "P001">	
		
</cfif>	


<cftransaction isolation="read_uncommitted">

<cfquery name="MissingUnits" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	INSERT INTO dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
			( Mission,
			  MissionOwner,
			  MandateNo, 
			  OrgUnitOperational,
			  OrgUnitName,
			  OrgUnitClass,
			  OrgUnitCode,
			  HierarchyCode,
			  PositionParentId,
			  PositionNo,
			  OperationalMission,
			  OperationalMandateNo,
			  OperationalOrgUnit,
			  OperationalOrgUnitName,
			  OperationalOrgUnitClass,
			  OperationalHierarchyCode,
			  <cfif URL.Tree neq "Operational">
			      OrgUnit#URL.Tree#,
				  #URL.Tree#Mission,
				  #URL.Tree#OrgUnitName,
				  #URL.Tree#OrgUnitCode,
				  #URL.Tree#OrgUnitClass,
				  #URL.Tree#HierarchyCode,
			  </cfif>
			  FunctionNo,
			  FunctionDescription,
			  OccGroupOrder,
			  OccupationalGroup,
			  PostType,
			  PostAuthorised,
			  PostGrade, 
			  VacancyActionClass,
			  ShowVacancy,
			  PostOrder,
			  PostGradeParent,
			  OccGroupDescription,
			  PostClass,
			  PostClassGroup,
			  PostInBudget,
			  DateEffective,
			  DateExpiration,
			  OrgEffective,
			  OrgExpiration,
			  Created )
	 SELECT   '#URL.Mission#', 
		      '',
		      MandateNo, 
		      OrgUnit, 
		      OrgUnitName, 
		      OrgUnitClass, 
			  OrgUnitCode,
		      HierarchyCode,
			  '',
			  '0',
			  '#URL.Mission#', 
		      MandateNo, 
		      OrgUnit, 
		      OrgUnitName, 
		      OrgUnitClass, 
		      HierarchyCode,
			  <cfif URL.Tree neq "Operational">
					OrgUnit, 
					Mission,
			        OrgUnitName, 
					OrgUnitCode,
			        OrgUnitClass, 
			        HierarchyCode,
			  </cfif>
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',			  
			  'occ',
			  'postclass',
			  '',
			  '1',
			  '#dateformat(now(),client.DateSQL)#',
			  '#dateformat(now(),client.DateSQL)#',
			  DateEffective,
			  DateExpiration,
			  '#dateformat(now(),client.DateSQL)#'
	 FROM  Organization.dbo.Organization Org
	 WHERE Mission   = '#Mis#' 
	 AND   MandateNo = '#Man#'
	 AND   OrgUnit NOT IN (SELECT OrgUnit#URL.Tree# 
	                       FROM   #SESSION.acc#_WhsStaffingPosition#FileNo#
						   WHERE  OrgUnit#URL.Tree# = Org.OrgUnit) 
						   
</cfquery>


</cftransaction>
	
<cfif URL.Tree eq "Administrative">

   <cfquery name="MissingUnits" 
    datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM userQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
		WHERE  #URL.Tree#Mission is NULL or #URL.Tree#Mission != '#Tree.TreeAdministrative#'
	</cfquery>
	
	<!--- correction of the orgunitdates --->
	
	 <cfquery name="ResetDates" 
    datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE userQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
		SET    OrgEffective = O.DateEffective,
		       OrgExpiration = O.DateExpiration
		FROM   userQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo# P, Organization.dbo.Organization O
		WHERE  P.OrgUnitAdministrative = O.OrgUnit			
	</cfquery>	
		
<!--- --------------- --->
<!--- added 20/3/2010 --->
<!--- --------------- --->		
	
<cfelseif URL.Tree eq "Functional">
	
	<cfquery name="Listing" 
    datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT 
		         OperationalMission, 
			     OperationalMandateNo,
			     HierarchyCode, 
			     OrgUnitOperational
		FROM     UserQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
		ORDER BY OperationalMission, 
		         HierarchyCode				
	</cfquery>
		
	<cfset level0 = 70>
	
	<cfoutput query="Listing" group="OperationalMission">
	
		<cfset level0 = level0+1>
				
		<!--- complement a mission level record to summarize the totals on the fly --->
			
		<cfquery name="InsertMission" 
		    datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
						( Mission,
						  MissionOwner,
						  MandateNo, 
						  OrgUnitOperational,
						  OrgUnitCode,
						  OrgUnitName,
						  OrgUnitClass,
						  HierarchyCode,
						  PositionNo,
						  OperationalMission,
						  OperationalMandateNo,
						  OperationalOrgUnit,
						  OperationalOrgUnitName,
						  OperationalOrgUnitClass,
						  OperationalHierarchyCode,						  
						  FunctionNo,
						  OccGroupOrder,
						  OccupationalGroup,
						  PostType,
						  PostAuthorised,
						  PostGrade, 
						  PostOrder,
						  FunctionDescription,
						  PostGradeParent,
						  OccGroupDescription,
						  PostClass,
						  PostClassGroup,
						  PostInBudget,
						  DateEffective,
						  DateExpiration,
						  Created)
				 VALUES ('#mis#','',
				        '#man#',
						'#currentrow#',
						'Tree',
						'#OperationalMission#',
						'Administrative',
						'#level0#',
						'0',
						'#OperationalMission#', 
				        '#OperationalMandateNo#', 
				        '0', 							
				        '#OperationalMission#', 
				        'Mission', 
				        '#level0#',						
						'','','','','','','','','',
						'occ','postclass',
						'',
						'1',
						getDate(),
						getDate(),
						getDate())					 
			</cfquery>
							
			<cfset level_1 = 0>
			<cfset level_2 = 0>
												
			<cfoutput>
			
			   	<cfquery name="UpdateHierarchy" 
				    datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
						SET    HierarchyCode      = '#level0#.'+HierarchyCode
						WHERE  OrgUnitOperational = '#OrgUnitOperational#'	 
				</cfquery>
											
				<!--- check if the hierarchy matches the prior hierarchy --->
				
				<!---
														
				<cfif not find(HierarchyCode,level1)>
				
					<cfset level_1 = level_1+1>
					
					<cfif level_1 lt 10>
	     				<cfset level_1 = "0#level_1#">			
					</cfif>
																										
					<cfquery name="UpdateHierarchy" 
				    datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
						SET    HierarchyCode = '#level0#.#Level_1#'
						WHERE  OrgUnitOperational = '#OrgUnitOperational#'	 
					</cfquery>
								
										
				<cfelse>									
				
					<cfset level_2 = level_2+1>
					<cfif level_2 lt 10>
	     				<cfset level_2 = "0#level_2#">			
					</cfif>
												
					<cfquery name="UpdateHierarchy" 
				    datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						UPDATE dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
						SET    HierarchyCode      = '#level0#.#Level_1#.#level_2#'
						WHERE  PositionNo         = '#PositionNo#' 
						AND    OrgUnitOperational = '#OrgUnitOperational#'	 
					</cfquery>
													
				</cfif>
				
				--->
								
				
			</cfoutput>
			
	</cfoutput>
							
</cfif>

<cfquery name="Index" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	CREATE INDEX [PsitionInd] 
	    ON dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#([PositionNo]) ON [PRIMARY]
</cfquery>		
		
<!--- retrieve all assignments for the selected positions --->

<cftransaction isolation="read_uncommitted">
			
	<cfquery name="Assignment" 
	    datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
		   	INTO   userQuery.dbo.#SESSION.acc#_WhsStaffingAssignment#FileNo#
			FROM   vwAssignment Ass
			WHERE  EXISTS (SELECT PositionNo 
			               FROM   userQuery.dbo.#SESSION.acc#_WhsStaffingPosition#FileNo#
						   WHERE  PositionNo = Ass.PositionNo)
			AND    Ass.AssignmentStatus   < '#Parameter.AssignmentShow#' <!--- 0,1 --->
			AND    Ass.DateExpiration     >= '#DTE#'
			AND    Ass.DateEffective      <= '#DTE#' 
			AND    Ass.Incumbency > 0 <!--- exclude 0 incumbency --->
	</cfquery>

</cftransaction>
