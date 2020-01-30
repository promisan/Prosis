
<!--- define access to posttype --->

<cfquery name="PostType" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT ClassParameter 
	FROM   OrganizationAuthorization 
	WHERE  UserAccount = '#SESSION.acc#' 
	AND    Mission     = '#URL.Mission#'
	AND    Role IN (SELECT  Role
					FROM    Ref_AuthorizationRole
				    WHERE   SystemModule = 'Staffing' 
					AND     Parameter    = 'PostType')
</cfquery>	

<cfset ptpe = quotedvalueList(PostType.ClassParameter)>
<cfif ptpe eq "">
	<cfset ptpe = "''">
</cfif>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Resource#FileNo#"> 

	<cfif URL.Tree neq "Functional">
	
		<!--- grade view --->
		<cfquery name="ResourceInit" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     DISTINCT P.ViewOrder, 
			           P.Code, 
					   2 as Count,
					   <!---
					   (SELECT  count(*)
					   FROM    Ref_PostGrade
					   WHERE   PostGradeParent = G.PostGradeParent) as Count,					   
					   --->
					   GB.PostOrderBudget, 
					   GB.PostGradeBudget  
			INTO       userQuery.dbo.#SESSION.acc#Resource#FileNo#
			FROM       Ref_PostGrade G, 
			           Ref_PostGradeBudget GB,
			           Ref_PostGradeParent P, 
					   Position Pos
			WHERE      G.PostGradeParent = P.Code
			AND        G.PostGrade = Pos.PostGrade
			AND        G.PostGradeBudget = GB.PostGradeBudget
			
			<cfif url.tree eq "Operational">
			
			   <!--- 27/3/2011
			   enhanced query to show positions for units that belong to this mission/mandate --->
			
		      AND    (  Pos.OrgUnitOperational IN (SELECT OrgUnit
			                                       FROM   Organization.dbo.Organization
											       WHERE  Mission   = '#url.mission#'
											       AND    Mandateno = '#url.mandate#'												
											       AND    OrgUnit   = Pos.OrgUnitOperational )
																
					    OR
						
						    <!--- inter mission loan added 16/1/2014 as otherwise these would not be visible shown --->
					 
						 	(
							
							 Pos.MissionOperational != Pos.Mission	
							 AND  Pos.Mission           = '#URL.Mission#'
						     AND  Pos.MandateNo         = '#URL.Mandate#'
							 
							)		
						
						)																						
			
			<cfelse>
			
			  AND  Pos.Mission           = '#URL.Mission#'
			  AND  Pos.MandateNo         = '#URL.Mandate#'
			  
			</cfif> 
			
				
			
			<!--- only valid positions for the selection data --->
			AND        Pos.DateEffective     <= '#DTE#'				
			AND        Pos.DateExpiration    >= '#DTE#' 
					
			<cfif getAdministrator("*") eq "0">					
			AND        Pos.PostType IN ( #preservesingleQuotes(ptpe)# )													
			</cfif>		
										
			ORDER BY   P.ViewOrder, GB.PostOrderBudget 
		</cfquery>
	
		<cfquery name="Subtotal" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_PostGradeParent P
			WHERE      P.ViewTotal = '1'    
			
			<cfif getAdministrator(mission) eq "0">
			AND        P.PostType IN ( #preservesingleQuotes(ptpe)# )
			</cfif>		
			
			ORDER BY ViewOrder
		</cfquery>
		
	<cfelse>
	
		<!--- grade view --->
		<cfquery name="ResourceInit" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     DISTINCT P.ViewOrder, 
			           P.Code, 
					   2 as count,
					   <!---
					     (SELECT  count(*)
					   FROM    Ref_PostGrade
					   WHERE   PostGradeParent = G.PostGradeParent) as Count,		
					   --->
					   GB.PostOrderBudget, 
					   GB.PostGradeBudget  
			INTO       userQuery.dbo.#SESSION.acc#Resource#FileNo#
			FROM       Ref_PostGrade G, 
			           Ref_PostGradeBudget GB,
			           Ref_PostGradeParent P, 					   
					   Organization.dbo.Ref_Mandate R, 
			    	   vwPosition Pos 
			WHERE      Pos.Mission = R.Mission and Pos.MandateNo = R.MandateNo		   
			AND        R.Mission IN 
		                  (SELECT Mission 
						   FROM   Organization.dbo.Ref_Mission 
						   WHERE  TreeFunctional IS NOT NULL 
						   AND    Operational = 1)
		
			AND   R.DateEffective IN
		
			     ( SELECT MAX(DateEffective)
			               FROM       Organization.dbo.Ref_Mandate 
			               WHERE     DateEffective <= '#dte#'
			               AND Mission = R.Mission
			               GROUP BY Mission
			     )
		
			AND  Pos.OrgUnitFunctional IN (
			                               SELECT OrgUnit 
		                            	   FROM   Organization.dbo.Organization 
		                                   WHERE  MissionAssociation = '#url.mission#'
										   )
			<!--- if just one record for the parent then we suppress --->							   
			
			<!---
			AND    	 EXISTS  (SELECT  'X'
								FROM    Ref_PostGrade
								WHERE   PostGradeParent = G.PostGradeParent
								HAVING count(*) > 1)
								
								--->
													   
					   
					 				 
			AND        G.PostGradeParent = P.Code
			AND        G.PostGrade       = Pos.PostGrade
			AND        G.PostGradeBudget = GB.PostGradeBudget
				
			<cfif getAdministrator(mission) eq "0">
			AND        Pos.PostType IN ( #preservesingleQuotes(ptpe)# )
			</cfif>			
									
			ORDER BY   P.ViewOrder, GB.PostOrderBudget 
		</cfquery>
	
		<cfquery name="Subtotal" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT     *
			FROM       Ref_PostGradeParent P
			WHERE      P.ViewTotal = '1'    
			
			<cfif getAdministrator(mission) eq "0">
			AND        P.PostType IN ( #preservesingleQuotes(ptpe)# )
			</cfif>		
			
			ORDER BY ViewOrder
			
		</cfquery>
	
	</cfif>	
		
	<cfset total = "">
	<cfset tot = "">
	
	<cfloop query="subtotal">
	
		<cfquery name="Subtotal" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO dbo.#SESSION.acc#Resource#FileNo#
					(ViewOrder, Code, count, PostOrderBudget, PostGradeBudget)
			VALUES  ('#vieworder#', '#code#', '99', '99990', 'Subtotal') 
		</cfquery>
		
	</cfloop>
	
	<cfquery name="Total" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		INSERT INTO dbo.#SESSION.acc#Resource#FileNo#
				(ViewOrder, Code, Count,PostOrderBudget, PostGradeBudget)
		VALUES  ('0', 'Total', '99', '0', 'Total') 
	</cfquery>
	
		
	<!--- select resource --->
	<cfquery name="Resource" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     #SESSION.acc#Resource#FileNo# R
		WHERE   EXISTS (
			  	 SELECT 'X'
				 FROM   #SESSION.acc#Resource#FileNo#
				 WHERE  Code             =  R.Code
				 AND    PostGradeBudget != 'SubTotal' )
		AND      Count != 1
		ORDER BY ViewOrder, PostOrderBudget 
	</cfquery>
	
	<!--- put rows in an array for quick reference later> --->
	<cfloop query="Resource">
	   	 <cfset column[currentRow]       = Resource.PostGradeBudget>
		 <cfset columnParent[currentRow] = Resource.Code>
	</cfloop>
	
	<cfset c = "31">
	<cfif Resource.RecordCount gt "0">
	     <cfset c = (CLIENT.width-378)/(Resource.RecordCount+1)>
	</cfif>
	
	<cfset c = int(c - 1)>	
	<cfset cell  = c>
	<cfset tblc  = cell+20+(Resource.RecordCount*cell)>
	<cfset tblw  = 272+tblc>
	<cfset tblw1 = 4+tblw>
	<cfset tblw2 = 2+tblw>
	<cfset tblr  = 3+Resource.RecordCount>
	<cfset subT = "">