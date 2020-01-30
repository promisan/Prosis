
<cfparam name="url.find" default="">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentProgramView#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentProgramViewTmp_#FileNo#">

<!--- identify object of expenditure structure --->

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#URL.Mission#'
</cfquery>

<cfquery name="EditionCheck" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E, 
	         Ref_AllotmentVersion R
	WHERE    EditionId = '#url.Edition#' 
	AND      E.Version = R.Code	
</cfquery>

<cfquery name="Resource" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     #CLIENT.LanPrefix#Ref_Resource 
	WHERE    Code IN (
				SELECT     Obj.Resource
				FROM        Ref_Object Obj 
							INNER JOIN ProgramAllotmentDetail Allotment 
								ON Obj.Code = Allotment.ObjectCode 
				            INNER JOIN Ref_AllotmentEdition Edition 
								ON Allotment.EditionId = Edition.EditionId
							INNER JOIN ProgramPeriod PP 
								ON PP.ProgramCode = Allotment.ProgramCode AND PP.Period = Allotment.Period
							INNER JOIN Program P 
								ON P.ProgramCode = PP.ProgramCode 
				WHERE    Edition.EditionId = '#EditionCheck.EditionId#'
				AND		 PP.RecordStatus  != 9
				AND	     PP.Period         = '#URL.Period#'				
				AND	     Obj.ObjectUsage   = '#EditionCheck.ObjectUsage#' 	
				AND      Allotment.Status != '9'
				)
				
	ORDER BY ListingOrder 
		
</cfquery>


<cfif URL.ID1 neq "Tree" and URL.mode eq "PRG">
   
    <!--- defines the hierarchy code --->
	<cf_OrganizationSelect OrgUnit = "#URL.ID1#">
	
	<cfif URL.View eq "Only">	
	    
		<cfset HEnd = "#HStart#.">
		<cfset OEnd = "#HStart#.">		
		
    <cfelseif URL.View eq "Prg">	
	
		<cfset HEnd = "#HEnd#">		
		<cfset OEnd = "#HStart#.">
						
    <cfelse>
   
   		<cfset HEnd = "#HEnd#">	
	   	<cfset OEnd = "#HEnd#">		
		
    </cfif>
	
</cfif>	

<!--- create a container for the budget amounts to be reworked --->

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#AllotmentProgramView#FileNo# (
    	[ProgramCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,		
		[EditionId] [integer],
		[LockEntry] [integer],
	    <cfloop query="resource">
			 [Ceiling_#currentRow#] [float] NULL CONSTRAINT [DF_#SESSION.acc#Allotment#currentrow#_Ceiling#FileNo#] DEFAULT (0),  
		     [Resource_#currentRow#] [float] NULL CONSTRAINT [DF_#SESSION.acc#Allotment#currentrow#_Resource#FileNo#] DEFAULT (0), 
	    </cfloop>
		[Total] [float] NULL CONSTRAINT [DF_#SESSION.acc#Allotment_Total#FileNo#] DEFAULT (0))
</cfquery>

<!---
<cfoutput>BB:#cfquery.executionTime#<br></cfoutput>		
--->

<!--- -------------------------------------- --->
<!--- define totals per program per resource --->
<!--- -------------------------------------- --->



<cfloop query="resource">

	     <!--- insert entry table per edition from the source tables for each resource --->
		  
		<cfquery name="Allotment" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
			INSERT INTO userQuery.dbo.#SESSION.acc#AllotmentProgramView#FileNo# (
					  ProgramCode, 						 
					  EditionId, 
					  LockEntry,
					  Ceiling_#currentrow#, 
					  Resource_#currentRow#  )
						  
			SELECT    AD.ProgramCode, 			         
			          AD.EditionId, 
					  A.LockEntry,
					  CASE WHEN (Par.Ceiling = 1)  THEN C.Amount ELSE 0 END as Ceiling,					
					  -- CASE WHEN (SUM(AD.Amount)>0) THEN SUM(AD.Amount) ELSE 0 END AS Amount
					   CASE WHEN (SUM(AD.Amount)>0) THEN SUM(AD.Amount) ELSE SUM(AD.Amount) END AS Amount
					  
			FROM      Ref_Object Obj INNER JOIN
                      ProgramAllotmentDetail AD ON Obj.Code = AD.ObjectCode INNER JOIN
					  ProgramAllotment A ON AD.ProgramCode = A.ProgramCode AND AD.Period = A.Period AND AD.EditionId = A.EditionId INNER JOIN
                      Ref_AllotmentEdition Edition ON AD.EditionId = Edition.EditionId INNER JOIN
                      ProgramPeriod PP ON PP.ProgramCode = AD.ProgramCode AND PP.Period = AD.Period INNER JOIN
                      Program P ON P.ProgramCode = PP.ProgramCode LEFT OUTER JOIN
                      ProgramAllotmentCeiling C ON Obj.Resource = C.Resource AND AD.ProgramCode = C.ProgramCode AND AD.Period = C.Period AND 
                      AD.EditionId = C.EditionId LEFT OUTER JOIN Ref_ParameterMissionResource Par ON Obj.Resource = Par.Resource AND Par.Mission = '#URL.Mission#'		 	 			
					  
			WHERE     Edition.EditionId = '#url.Edition#'
			AND		  PP.RecordStatus  != 9
			AND	      PP.Period         = '#URL.Period#'
						
			<cfif URL.ProgramGroup neq "All" and URL.ProgramGroup neq "">	
			
			AND       P.ProgramCode IN (SELECT ProgramCode 
			                            FROM   ProgramGroup 
										WHERE  ProgramGroup = '#URL.ProgramGroup#'
										AND    ProgramCode  = P.ProgramCode) 
			</cfif>
						
			<cfif url.mode neq "PRG">		
			
			<!--- nada --->	
						                         
			<cfelse>
			
				<cfif url.id1 neq "Tree">		
				
				AND PP.OrgUnit IN (SELECT OrgUnit 
			                       FROM   Organization.dbo.Organization Org 
								   WHERE  Mission = '#URL.Mission#'
							       AND    Org.HierarchyCode >= '#HStart#' 
							       AND    Org.HierarchyCode < '#HEnd#' 
							  )	
				</cfif>			
				
			</cfif>	
			AND       Obj.Resource      = '#Code#'
			AND	      Obj.ObjectUsage   = '#EditionCheck.ObjectUsage#' 
			
			<cfif EditionCheck.ProgramClass neq "">				
			
			AND      P.ProgramClass IN ('#EditionCheck.ProgramClass#','Program') 
											
			</cfif>			
			
			<cfif url.filter eq "due">		
				
			AND       AD.Status IN ('0','1')	
			<cfelseif url.filter eq "transfer">				
			AND       AD.Status IN ('1') AND EXISTS (SELECT 'X' 
			                                         FROM   ProgramAllotmentAction 
			                                         WHERE  ActionId = AD.ActionId 
													 AND    ActionClass = 'Transfer' )
			<cfelse>
			AND       AD.Status IN ('P','0','1')
			</cfif>
			
			GROUP BY  AD.ProgramCode, AD.EditionId, C.Amount, Par.ceiling, A.LockEntry  		
			
						
		</cfquery>	
		
		<!---
		<cfoutput>3:#cfquery.executionTime#<br></cfoutput>		
		--->
		
</cfloop>


<!--- --------------------------------------------------- --->
<!--- aggregate the base table with allotment information --->
<!--- --------------------------------------------------- --->

<cfquery name="Allotment" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   ProgramCode, EditionId, LockEntry, <cfloop query="resource">
	         SUM(Ceiling_#currentrow#)  as Ceiling_#currentrow#,
	         SUM(Resource_#currentRow#) as Resource_#currentRow#, 
	         </cfloop>CONVERT(float, 0) as Total
	INTO     dbo.#SESSION.acc#AllotmentProgramViewTmp_#FileNo#	
	FROM     #SESSION.acc#AllotmentProgramView#FileNo#	 
	GROUP BY ProgramCode,EditionId,LockEntry 
</cfquery>



<!--- ---------------------------------------- --->
<!--- ----and then update the total column---- --->
<!--- --------------------------------------- --->
	
<cfquery name="Allotment" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   UPDATE #SESSION.acc#AllotmentProgramViewTmp_#FileNo#	
	   SET    Total = 0<cfloop query="resource">+  Resource_#currentRow#</cfloop>	 
</cfquery>


<!--- roll-up to program code level if case the selection is by program or this units only --->
	
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentProgramView#FileNo#"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentOrgView#FileNo#"> 

<cfif URL.Mode eq "STA">

	<!--- ------------------------------------------------------------------------ --->
	<!--- --limit access to user with unit access or which fly access------------- --->
	<!--- ------------------------------------------------------------------------ --->
					
	<!--- nada for now --->

<cfelseif URL.Mode eq "PRG">

	    <!--- ------------------------------------------------------------------------ --->
		<!--- 	
		Create a base table with the reponsible unit to be then rolled up for units later		
		--->
		<!--- ------------------------------------------------------------------------ --->
						
		<cfquery name="UnitBaseAllotment" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT    Org.OrgUnit, 
			          Org.HierarchyCode, 
					  Org.HierarchyCode as Grouping,	
			    	  <cfloop query="resource">
					  	  SUM(Ceiling_#currentrow#)  as Ceiling_#currentrow#,
				          SUM(Resource_#currentRow#) as Resource_#currentRow#, 
			          </cfloop>
					  SUM(Total) as Total				  
			INTO 	  userQuery.dbo.#SESSION.acc#AllotmentOrgView#FileNo#
			FROM      Organization.dbo.Organization Org 
			          LEFT OUTER JOIN ProgramPeriod Pe ON Pe.OrgUnit  = Org.OrgUnit AND Pe.Period = '#URL.Period#' AND Pe.RecordStatus  != 9
					  LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#AllotmentProgramViewTmp_#FileNo# A ON Pe.ProgramCode = A.ProgramCode 					  		  
			WHERE     Org.Mission       = '#URL.Mission#'					  
			AND       Org.MandateNo     = '#URL.Mandate#'
								
			<cfif URL.ProgramGroup neq "All" and URL.ProgramGroup neq "">	
			AND       Pe.ProgramCode IN (SELECT ProgramCode 
			                            FROM   ProgramGroup 
										WHERE  ProgramGroup = '#URL.ProgramGroup#'
										AND    ProgramCode  = Pe.ProgramCode) 
			</cfif>
			
			<cfif url.id1 neq "Tree">			
			AND       Org.HierarchyCode >= '#HStart#' 
			AND       Org.HierarchyCode < '#HEnd#' 
			</cfif>
			
			<cfif url.find neq "">
						 
			 	AND Org.Orgunit IN (SELECT OrgUnit 
				                    FROM   ProgramPeriod PP INNER JOIN 
									       Program P ON PP.programCode = P.ProgramCode 
									WHERE  P.Mission = '#URL.Mission#'
									AND   ( PP.Reference LIKE '%#url.find#%' OR P.ProgramCode LIKE '%#url.find#%' OR P.ProgramName LIKE '%#url.find#%'))
			 
		 	</cfif>
			
			GROUP BY  Org.OrgUnit, 
			          Org.HierarchyCode 
					  
	  	</cfquery>				
										
		<cfloop index="lvl" from="6" to="2" step="-1"> <!--- loops through the levels --->
			    
			<!--- define picture of levels --->
			
			<cfswitch expression="#lvl#">
				<cfcase value="6">
				   <cfset No = "14">
				   <cfset hierarchyP = "__.__.__.__.__.__">
				   <cfset hierarchyN = "__.__.__.__.__">
				</cfcase>
				<cfcase value="5">
				   <cfset No = "11">
				   <cfset hierarchyP = "__.__.__.__.__">
				   <cfset hierarchyN = "__.__.__.__">
				</cfcase>
				<cfcase value="4">
				   <cfset No = "8">
				   <cfset hierarchyP = "__.__.__.__">
				   <cfset hierarchyN = "__.__.__">
				</cfcase>
				<cfcase value="3">
				   <cfset No = "5">
				   <cfset hierarchyP = "__.__.__">
				   <cfset hierarchyN = "__.__">
				</cfcase>
				<cfcase value="2">
				   <cfset No = "2">
				   <cfset hierarchyP = "__.__">
				   <cfset hierarchyN = "__">
				</cfcase>		
			</cfswitch>
					
			<!--- -------------------cumulate on the unit level---------------------------- --->			
			<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentOrgViewTmp_#FileNo#">
			<!--- ------------------------------------------------------------------------- ---> 
								 		 
			<cfquery name="Allotment" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						   		
					SELECT    LEFT(HierarchyCode,#No#) as Grouping,
					          <cfloop query="resource">					      
						          Sum(Resource_#currentRow#) as Resource_#currentRow#, 
					          </cfloop>Sum(Total) as Total
					INTO 	  #SESSION.acc#AllotmentOrgViewTmp_#FileNo#
					FROM      #SESSION.acc#AllotmentOrgView#FileNo#
					WHERE     HierarchyCode LIKE '#HierarchyP#' OR HierarchyCode LIKE '#HierarchyN#'								
					GROUP BY  LEFT(HierarchyCode,#No#)		
													
			</cfquery>		
									
			<cfquery name="Allotment" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					<!--- apply the result for each unit to have a summed total --->
					
				    UPDATE  #SESSION.acc#AllotmentOrgView#FileNo#
					SET		<cfloop query="resource">Resource_#currentRow# = New.Resource_#currentRow#,</cfloop>
							Total = New.Total
					FROM    #SESSION.acc#AllotmentOrgView#FileNo# V, 
					        #SESSION.acc#AllotmentOrgViewTmp_#FileNo# New
					WHERE   V.HierarchyCode = New.Grouping 
								
			</cfquery>		
			
																					
			<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentOrgViewTmp_#FileNo#"> 
						
		</cfloop>
								
<cfelse>

<!--- summarize --->

</cfif>	

