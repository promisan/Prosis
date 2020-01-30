
<cfparam name="URL.Sel"         default="#dateFormat(now(), CLIENT.DateFormatShow)#">

<CF_DateConvert Value="#URL.sel#">
<cfparam name="Date" default="#dateValue#">
<cfparam name="DTE" default="#dateFormat(date, client.dateSQL)#">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assignment"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Position"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Staffing"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Vacancy"> 
		
<cfquery name="Parameter" 
 datasource="AppsEmployee" 
 maxrows=1 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT * 
    FROM Parameter
</cfquery>

<cfquery name="Group" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT  * 
    FROM    Ref_Group
	WHERE   GroupCode IN (SELECT GroupCode FROM 
	                      Ref_GroupMission 
						  WHERE Mission = '#url.mission#')
	AND     GroupDomain = 'Position'
</cfquery>
 			             
<cfquery name="Position" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT  newid() as FactTableId, 
	        MandateNo AS Mandate_dim, 
			ParentHierarchyCode AS ParentUnit_dim,
			ParentNameShort AS ParentUnit_nme,
			OrgUnitClass AS OrgUnitClass_dim, 
			OrgUnitOperational AS OrgUnit_dim, 
			OrgUnitName AS OrgUnit_nme, 
            HierarchyCode AS OrgUnit_ord, 
			FunctionNo AS Function_dim, 
			FunctionDescription AS Function_nme, 
			OccupationalGroup AS OccGroup_dim, 
            OccGroupDescription AS OccGroup_nme, 
			OccGroupOrder AS OccGroup_ord, 
			PostType AS PostType_dim, 
			PostClass AS PostClass_dim, 
			LocationCode AS Location_dim,
			Fund AS Fund_dim,
			CASE WHEN Pos.PostAuthorised = 1 THEN 'Authorised' ELSE 'Not Authorised' END as PostAuthorised_dim,
			<cfloop query="Group">
			(SELECT CASE WHEN count(*) >0 THEN 'Yes' ELSE 'No' END
			FROM PositionGroup
			WHERE PositionNo = Pos.PositionNo
			AND   PositionGroup = '#GroupCode#'
			AND   Status != '9') as TAG_#groupCode#_dim,
			</cfloop>			
            SourcePostNumber, 
			PostGradeBudget AS PostGrade_dim, 
			PostOrderBudget AS PostGrade_ord, 			
			PositionNo, 
			DateEffective, 
			DateExpiration, 
			#date# as SelectionDate 
    INTO    userQuery.dbo.#SESSION.acc#Position
    FROM    vwPosition Pos
    WHERE   Pos.DateExpiration      >= #date#
	 AND    Pos.DateEffective       <= #date#	
	 
	 <!--- 27/3/2011
		   enhanced query to show all positions for units that beling to this mission/mandate --->
		
	    AND (		
				   
					   (   Pos.OperationalMission = '#url.mission#'
				           AND Pos.OperationalOrgUnit IN (SELECT OrgUnit
				                                  FROM   Organization.dbo.Organization
												  WHERE  Mission   = '#URL.Mission#'
												  AND    OrgUnit   = Pos.OperationalOrgUnit )
												  
					   )						  
			   														  
			      	   OR
			   
					   (  Pos.Mission      = '#URL.Mission#'  )
			   
			   )	
			   
	    <!--- only show positions if they are to be shown based on the vacancy class set for them  --->
		
		 AND    (CASE Pos.ShowVacancy WHEN 0 THEN Pos.PositionNo ELSE 1 END ) IN
				 
			    (CASE Pos.ShowVacancy WHEN 0 THEN 
				 
				   (SELECT PositionNo
				    FROM   PersonAssignment 
					WHERE  PositionNo = Pos.PositionNo
					AND    AssignmentStatus IN ('0','1')
					AND    Incumbency > 0
					AND    DateEffective <= #date# 
					AND    DateExpiration > #date#) 
					
		           ELSE (1) END )   		   						  

	 ORDER BY Pos.Mission, Pos.HierarchyCode 
</cfquery>


<!--- Check if there is data to present retirment ages as a dimension--->
<cfquery name="Retirement" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT COUNT(*) AS Total
	 	FROM   vwAssignment Ass
		WHERE  Ass.PositionNo IN 
		(
			SELECT PositionNo 
			FROM   userQuery.dbo.#SESSION.acc#Position
			WHERE  PositionNo = Ass.PositionNo
			AND    SelectionDate = #date#
		)
		AND    Ass.PersonNo IN (
			SELECT PersonNo
			FROM   PersonEvent
			WHERE  EventCode = 'Pension'
			AND    Mission = Ass.Mission
		)
		AND    Ass.AssignmentStatus < '#Parameter.AssignmentShow#'
		AND    Ass.DateEffective    <= #date#
		AND    Ass.DateExpiration   >= #date# 
		AND    Ass.Incumbency > 0
</cfquery>

<!--- Get PersonEvent associated to the subject mission --->
<cfquery name="getPersonEvent" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT PE.Code, PE.Description AS EventDescription, B.*
		FROM   Ref_PersonEvent PE
			   INNER JOIN Ref_PersonEventMission PEM
			   		ON    PE.Code = PEM.PersonEvent 
			   		AND   PEM.Mission = '#URL.Mission#'
			   INNER JOIN Ref_PersonEventMissionBracket B
					ON    PEM.PersonEvent = B.PersonEvent
		    		AND   PEM.Mission = B.Mission
		ORDER BY PE.Code, B.ListingOrder
</cfquery>

<cfquery name="Assignment" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT newid()              AS FactTableId,
		
		       -- Ass.Mission          AS Entity_dim,
			   
			   PostType             AS PostType_dim,
			   PostClass            AS PostClass_dim,
			   
			   PostGradeBudget      AS PostGrade_dim, 
			   PostOrderBudget      AS PostGrade_ord, 			 
			   
		       PostGradeParent      AS StaffCategory_dim, 
			   ViewOrder            AS StaffCategory_ord, 
			   
			   OP.OrgUnitCode       AS OrgParent_dim,
			   OP.OrgUnitName       AS OrgParent_nme,
			   
			   ass.OrgUnitClass     AS OrgUnitClass_dim, 
			   ass.OrgUnitClassName AS OrgUnitClass_nme, 
			   
			   ass.OrgUnit          AS OrgUnit_dim, 
			   ass.OrgUnitName      AS OrgUnit_nme, 
			   ass.OrgUnitHierarchyCode AS OrgUnit_ord, 
			   
			   OccGroup             AS OccGroup_dim, 
			   OccGroupName         AS OccGroup_nme, 
			   OccGroupOrder        AS OccGroup_ord,
			   
			   ass.LocationCode     AS Location_dim,			  
			   
			   Gender               AS Gender_dim, 
			   
			   N.Nationality        AS Nationality_dim, 
			   N.Name               AS Nationality_nme,
		       
			   N.Continent          AS Continent_dim,			   
			   
			   FullName             AS EmployeeName, 
			   
			   CASE 
					WHEN DATEDIFF(year,birthdate,GETDATE()) >= 20 AND DATEDIFF(year,birthdate,GETDATE()) <=30 THEN '20-30'
					WHEN DATEDIFF(year,birthdate,GETDATE()) >= 31 AND DATEDIFF(year,birthdate,GETDATE()) <=40 THEN '31-40'
					WHEN DATEDIFF(year,birthdate,GETDATE()) >= 41 AND DATEDIFF(year,birthdate,GETDATE()) <=50 THEN '41-50'
					WHEN DATEDIFF(year,birthdate,GETDATE()) >= 51 AND DATEDIFF(year,birthdate,GETDATE()) <=60 THEN '51-60'
					WHEN DATEDIFF(year,birthdate,GETDATE()) >= 61 THEN '61+'
			   ELSE 'Undetermined'
			   END AS AgeGroup_dim,
			   
			   <!--- generate PersonEvent dimensions --->
			   <cfoutput query="getPersonEvent" group="PersonEvent">
			   		
			   		<cfset dimensionName = REReplace(EventDescription,"[^A-Za-z]","","all")> <!--- remove special characters or numbers --->
			   		
			   		CASE
			   		
			   		<cfoutput>
			   			WHEN
			   			
			   			<cfif BracketStart eq  BracketEnd>
			   				DATEDIFF(#BracketMode#,GETDATE(),#PersonEvent#.DateEvent) = #BracketStart#
			   			<cfelse>
			   				DATEDIFF(#BracketMode#,GETDATE(),#PersonEvent#.DateEvent) >= #BracketStart# AND DATEDIFF(#BracketMode#,GETDATE(),#PersonEvent#.DateEvent) <= #BracketEnd#
			   			</cfif>
			   			
			   			THEN	'#Description#'
			   		</cfoutput>
			   		
			   		ELSE 'Undetermined'
			   		END  AS #dimensionName#_dim,
			   		
			   </cfoutput>
			   
  			   <!--- generate PersonEvent listing order --->
			   <cfoutput query="getPersonEvent" group="PersonEvent">
			   		
			   		<cfset dimensionName = REReplace(EventDescription,"[^A-Za-z]","","all")> <!--- remove special characters or numbers --->
			   		
			   		CASE
			   		
			   		<cfoutput>
			   			WHEN
			   			
			   			<cfif BracketStart eq  BracketEnd>
			   				DATEDIFF(#BracketMode#,GETDATE(),#PersonEvent#.DateEvent) = #BracketStart#
			   			<cfelse>
			   				DATEDIFF(#BracketMode#,GETDATE(),#PersonEvent#.DateEvent) >= #BracketStart# AND DATEDIFF(#BracketMode#,GETDATE(),#PersonEvent#.DateEvent) <= #BracketEnd#
			   			</cfif>
			   			
			   			THEN	#ListingOrder#
			   		</cfoutput>
			   		
			   		ELSE -1
			   		END  AS #dimensionName#_ord,
			   		
			   </cfoutput>
			   
			   FunctionDescription AS FunctionTitle, 
			   SourcePostNumber AS PostNumber, 
			   IndexNo, 
			   Ass.PersonNo, 
			   Ass.PositionNo,
	           BirthDate, 
			   eMailAddress,
			   AssignmentNo,
			   AssignmentClass	
			   
	   	INTO   userQuery.dbo.#SESSION.acc#Assignment
		
		FROM   vwAssignment Ass
			   INNER JOIN System.dbo.Ref_Nation N               ON Ass.Nationality     = N.Code
					 
			   INNER JOIN Organization.dbo.Organization O	    ON   Ass.OrgUnit         = O.OrgUnit
								
			   INNER JOIN Organization.dbo.Organization OP		ON  O.HierarchyRootUnit = OP.OrgUnitCode
												AND O.Mission     = OP.Mission
												AND O.MandateNo   = OP.MandateNo			 
			   		 
			   <cfif getPersonEvent.RecordCount gt 0>
			   
			   	  <cfoutput query="getPersonEvent" group="PersonEvent">
					LEFT JOIN PersonEvent #PersonEvent#
						ON    #PersonEvent#.PersonNo    = Ass.PersonNo  
					    AND   #PersonEvent#.Mission     = Ass.Mission
					    AND   #PersonEvent#.EventCode   = '#PersonEvent#'
			   	  </cfoutput>
				  
			   </cfif>
			   
		WHERE  Ass.PositionNo IN (SELECT PositionNo 
		                          FROM   userQuery.dbo.#SESSION.acc#Position
								  WHERE  PositionNo = Ass.PositionNo
								  AND    SelectionDate = #date#)
								  
		AND    Ass.AssignmentStatus < '#Parameter.AssignmentShow#'
		AND    Ass.DateEffective    <= #date#
		AND    Ass.DateExpiration   >= #date# 
		AND    Ass.Incumbency > 0
		
</cfquery>

<cfquery name="Vacancy" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT  newid()             AS FactTableId, 
	        MandateNo           AS Mandate_dim, 
			ParentHierarchyCode AS ParentUnit_dim,
			ParentNameShort     AS ParentUnit_nme,
			OrgUnitClass        AS OrgUnitClass_dim, 
			OrgUnitOperational  AS OrgUnit_dim, 
			OrgUnitName         AS OrgUnit_nme, 
            HierarchyCode       AS OrgUnit_ord, 
			FunctionNo          AS Function_dim, 
			Fund                AS Fund_dim,
			LocationCode        AS Location_dim,
			FunctionDescription AS Function_nme, 
			OccupationalGroup   AS OccGroup_dim, 
            OccGroupDescription AS OccGroup_nme, 
			OccGroupOrder       AS OccGroup_ord, 
			PostType            AS PostType_dim, 
			PostClass           AS PostClass_dim, 
			CASE WHEN Pos.PostAuthorised = 1 THEN 'Authorised' ELSE 'Not Authorised' END as PostAuthorised_dim,           
			<cfloop query="Group">
			(SELECT CASE WHEN count(*) >0 THEN 'Yes' ELSE 'No' END
			FROM PositionGroup
			WHERE PositionNo = Pos.PositionNo
			AND   PositionGroup = '#GroupCode#'
			AND   Status != '9') as TAG_#groupCode#_dim,
			</cfloop>		
            SourcePostNumber, 
			PostGradeBudget     AS PostGrade_dim, 
			PostOrderBudget     AS PostGrade_ord, 			
			PositionNo, 
			DateEffective, 
			DateExpiration, 
			#date# as SelectionDate 
			
    INTO    userQuery.dbo.#SESSION.acc#Vacancy
    FROM    vwPosition Pos
	WHERE   Pos.DateExpiration      >= #date#
	 AND    Pos.DateEffective       <= #date#
	 
	 AND    Pos.OperationalOrgUnit IN (SELECT OrgUnit
		                               FROM   Organization.dbo.Organization
									   WHERE  Mission   = '#URL.Mission#'									   
									   AND    OrgUnit = Pos.OperationalOrgUnit )
	 
	 <!--- vacant --->	 
	 AND    Pos.PositionNo NOT IN (SELECT PositionNo 
	                               FROM   userQuery.dbo.#SESSION.acc#Assignment 
								   WHERE  PositionNo = Pos.PositionNo)	
								   
	  <!--- only show positions if they are to be shown based on the vacancy class set for them  --->
		
		 AND    (CASE Pos.ShowVacancy WHEN 0 THEN Pos.PositionNo ELSE 1 END ) IN
				 
			    (CASE Pos.ShowVacancy WHEN 0 THEN 
				 
				   (SELECT PositionNo
				    FROM   PersonAssignment 
					WHERE  PositionNo = Pos.PositionNo
					AND    AssignmentStatus IN ('0','1')
					AND    Incumbency > 0
					AND    DateEffective <= #date# 
					AND    DateExpiration > #date#) 
					
		           ELSE (1) END )   									   
	
	 ORDER BY Pos.Mission, Pos.HierarchyCode 
</cfquery>

<cfset session.table1_ds = "#SESSION.acc#Position">
<cfset session.table2_ds = "#SESSION.acc#Assignment">
<cfset session.table3_ds = "#SESSION.acc#Vacancy">
