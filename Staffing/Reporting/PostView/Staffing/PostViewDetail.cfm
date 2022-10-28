
<cfset FileNo = round(Rand()*100)>

<cfparam name="URL.ID1"  default="0">
<cfparam name="URL.Excel" default="No">

<!--- define access rights --->

<cfinvoke component="Service.Access"  
     method="staffing" 
	 mission="#url.mission#"
	 orgunit="#URL.ID1#" 
	 posttype=""
	 returnvariable="accessStaffing">
		  
<cfinvoke component="Service.Access"  
     method="position" 
	 mission="#url.mission#"
     orgunit="#URL.ID1#" 
	 posttype=""
     returnvariable="accessPosition">
		  				 						  
<cfif AccessStaffing eq "NONE" and AccessPosition eq "NONE" and URL.ID1 neq "0">

	 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	   <tr>
		   <td align="center"><font face="Calibri" size="3" color="FF0000">You have <b>NO</b> access to view details of this unit</font></td>
	   </tr>
	</table>	
		
	<script>
	 Prosis.busy('no')
	</script>
	
	<cfabort>   
	
</cfif>

<cfquery name="Mission" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission   = '#URL.Mission#'
</cfquery>	

<cfquery name="Mandate" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mandate
	WHERE  MandateNo = '#URL.Mandate#'
	AND    Mission   = '#URL.Mission#'
</cfquery>	

<cfparam name="SESSION.isAdministrator" default="No">

<cfparam name="URL.Unit"     default="Cumulative">
<cfparam name="URL.Search"   default="0">
<cfparam name="URL.Filter"   default="">
<cfparam name="URL.Org"      default="search">
<cfparam name="URL.Mode"     default="Only">
<cfparam name="URL.Sort"     default="grade">
<cfparam name="URL.Level"    default="1">
<cfparam name="URL.Line"     default="Aut">
<cfparam name="URL.Tree"     default="Operational">
<cfparam name="URL.Id"       default="0">
<cfparam name="URL.FLD"      default="">
<cfparam name="URL.date"     default="today">
<cfparam name="URL.Tpe"      default="">
<cfparam Name="URL.Cell"     default="">
<cfparam name="URL.FilterId" default="{00000000-0000-0000-0000-000000000000}">

<!--- these are the selections you have in the overall filter box --->
<cfinclude template="MandateFilterApply.cfm">

<cfset url.fld = "#Rtrim(LTrim(url.fld))#">

<cfset unit = URL.Unit>

<cfset link = "#CGI.QUERY_STRING#">
<cfloop index="itm" list="grade,postclass,posttype,location" delimiters=",">
   <cfset link = ReplaceNoCase("#link#", "&sort=#itm#","","ALL")>
</cfloop>

<cf_tl id="Vacant" var="1">
<cfset tVacant=#lt_text#>

<cf_tl id="Assigned Title" var="1">
<cfset tAssigned=#lt_text#>

<cf_tl id="Recruitment" var="1">
<cfset tRecruitment=#lt_text#>

<cf_tl id="Incumbent" var="1">
<cfset tIncumbent=#lt_text#>

<cf_tl id="Initiate Recruitment" var="1">
<cfset tInitiateRecruitment=#lt_text#>

<cf_tl id="No candidate information available" var="1" class="message">
<cfset tNoCandidateInfo=#lt_text#>

<cfparam name="URL.ID1" default="1">

<cfquery name="Parameter" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT  * 
    FROM    Parameter
</cfquery>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Tree#FileNo#">

<!--- --------------------------------------------------------------- --->
<!--- functional units are always called from another mission/mandate --->
<!--- retrieve the mission and mandate from the functional orgunit    --->
<!--- --------------------------------------------------------------- --->

<!---
<cftry>
--->


<cfif URL.Org neq "Search">

	<!--- url.org determines the tree with units to be taken with orgunits --->
	
	<cfquery name="OrgUnit" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit  = '#URL.Org#'	
	</cfquery>	
		
	<cfif url.tree eq "Functional">
			
		<!--- now you can set the value back to operational for retrieval --->
		<cfset tree       = "operational">
		<cfset misfun     = url.mission>
			
		<cfif OrgUnit.recordcount gte "1">
			
			<!--- set the value of the mission --->
			<cfset url.mission = orgUnit.mission>
			<cfset url.mandate = orgUnit.mandateno>
		
		</cfif>
			
		<cfquery name="SelectTreeUnits" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			INTO     userQuery.dbo.#SESSION.acc#Tree#FileNo#
			FROM     Organization
			WHERE    Mission   = '#OrgUnit.Mission#' 
			AND      MandateNo = '#OrgUnit.MandateNo#' 
			ORDER By HierarchyCode  
		</cfquery>	
		
	<cfelseif url.tree eq "Administrative">
	
		<cfquery name="SelectTreeUnits" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			INTO     userQuery.dbo.#SESSION.acc#Tree#FileNo#
			FROM     Organization
			WHERE    Mission   = '#OrgUnit.Mission#' 
			AND      MandateNo = '#OrgUnit.MandateNo#' 
			ORDER BY HierarchyCode  
		</cfquery>			
		
	<cfelse>
		
		<cfquery name="SelectTreeUnits" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			INTO    userQuery.dbo.#SESSION.acc#Tree#FileNo#
			FROM    Organization
			WHERE   Mission   = '#url.Mission#' 
			AND     MandateNo = '#url.Mandate#' 
			ORDER BY HierarchyCode  
		</cfquery>		
		
	</cfif>
	
<cfelse>

<!--- filer the output for the role --->
	
<cf_treeUnitList
	 mission   = "#URL.Mission#"
	 mandateno = "#url.Mandate#"
	 role      = "'HROfficer','HRAssistant','HRPosition', 'HRLoaner', 'HRLocator','HRInquiry'"
	 tree      = "0">	

	<cfquery name="SelectTreeUnits" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			INTO    userQuery.dbo.#SESSION.acc#Tree#FileNo#
			FROM    Organization
			WHERE   Mission   = '#url.Mission#' 
			AND     MandateNo = '#url.Mandate#' 
			<cfif accessList neq "" and accesslist neq "full">
			AND    OrgUnit IN (#preservesinglequotes(accesslist)#)	 					  
			</cfif>			
			ORDER BY HierarchyCode  
		</cfquery>	

</cfif>

<!--- ------------------------------------- --->
<!--- define the selection date to be shown --->
<!--- ------------------------------------- --->

<cfif url.date eq "today">

	<cfif Mandate.DateEffective gt now()>
	   <CF_DateConvert Value="#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
	<cfelseif Mandate.DateExpiration lt now()>
	   <CF_DateConvert Value="#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
	<cfelse> 
	   <CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
	</cfif>
	
<cfelse>

	<CF_DateConvert Value="#url.date#">
	
</cfif>

<cfset sel = dateValue>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Grade#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assignment#FileNo#"> 

<!--- ------------------------------------ --->
<!--- define if related modules are in use --->
<!--- ------------------------------------ --->

<cf_verifyOperational 
         datasource= "AppsEmployee"
         module    = "EPas" 
		 mission   = "#url.mission#"
		 Warning   = "No">
		 		 
<cfset ePasOperational = operational>

<cf_verifyOperational 
         datasource= "AppsVacancy"
         module    = "Vacancy" 
		 mission   = "#url.mission#"
		 Warning   = "No">		
		 
<cfset RecruitmentOperational = operational>
    			
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Grade1_#FileNo#">  
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Position#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#View#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ViewDouble#FileNo#">	
	
<!--- feature to clean the results based on the access rights --->

<cfset accesslist = "">	
	  
   <cf_treeUnitList
	 mission   = "#URL.Mission#"
	 mandateno = "#Url.Mandate#"
	 role      = "'HROfficer','HRAssistant','HRPosition', 'HRLoaner', 'HRLocator'"
	 parent    = "0">

	<!--- positions extraction  -------------------------------------------------------- --->
	<!--- 18/12 Query returning search results with relevant positions for that unit 
	      including borrow && loaned positions to other units/mission to be shown         --->
	<!--- ------------------------------------------------------------------------------ --->	
	
<cfoutput>	

	<!--- we need to filter the number of positions upfront --->
		
	<cfquery name="GeneratePositions" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
		SELECT   P.*, 
		         O.Mission as MissionUsed, 
		         O.MandateNo as MandateNoUsed, 
				 O.OrgUnit, 
				 R.PresentationColor,		
				 
				 (SELECT TOP 1 ObjectId 
				  FROM   Organization.dbo.OrganizationObject		 
				  WHERE  ObjectKeyValue1 = P.PositionNo
				  AND    EntityCode     = 'PositionReview') 
				  as PositionReview,
				 
				 <cfif recruitmentOperational eq "0">
				 
				   0 as RecruitmentTrack,				  
				 
				 <cfelse>
				 
				 				 
				 	  <!--- select track occurence this query is heavy and should be tuned Hanno : 4/9/2013 --->
												  
							(
							
							SELECT  TOP 1 DocumentNo 
							
							FROM
														
									(
									
									SELECT    D.DocumentNo						
									FROM      Vacancy.dbo.DocumentPost as Track INNER JOIN
				      			              Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
						                      Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
						                      Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo
									WHERE     SP.PositionNo = P.PositionNo 
									AND       D.EntityClass IS NOT NULL 
									AND       D.Status = '0'
									
									UNION
										
										<!--- position has an upcoming track assignment --->  
										
										SELECT      PA.SourceId
                                        FROM        PersonAssignment AS PA 
                                        WHERE       PA.Source = 'vac' 
										AND         PA.PositionNo = P.PositionNo
										AND         PA.AssignmentStatus IN ('0', '1') 
										AND         PA.AssignmentType = 'Actual' 
										AND         PA.DateEffective >= GETDATE() 
																							
									UNION 
																					
									<!--- also we get a first position in the next mandate --->			
									
									SELECT     D.DocumentNo 
									
									FROM       Vacancy.dbo.DocumentPost as Track INNER JOIN
						                       Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
							                   Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
							                   Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo INNER JOIN
						                       Position PN ON SP.PositionNo = PN.SourcePositionNo
											   
									WHERE      PN.PositionNo = P.PositionNo
									AND        D.EntityClass IS NOT NULL 
									AND        D.Status = '0' 
									
									) as DerrivedTable 
													
							) AS  RecruitmentTrack,  <!--- prior mandate track linked through position source --->						   
				  
				   </cfif>				 
				 
				 'Used' AS Class
				 
		INTO     userQuery.dbo.#SESSION.acc#Position#FileNo#  
			
		FROM     Position P, 
				 Ref_PostClass R,
		         userQuery.dbo.#SESSION.acc#Tree#FileNo# O
				 
		WHERE    P.OrgUnit#Tree# = O.OrgUnit   <!--- which already is a subset for the tree which is selected --->
		AND      R.PostClass     = P.PostClass
				
		<cfif url.tree eq "Functional">		
		
		AND     P.OrgUnitFunctional IN (SELECT OrgUnit 
		                                FROM   Organization.dbo.Organization 
									    WHERE  OrgUnit = P.OrgUnitFunctional
										AND    MissionAssociation = '#Misfun#') 
		
		</cfif>	
		
		AND      MissionOperational   = '#URL.Mission#'
		
		AND      P.DateExpiration    >= #sel#  
		AND      P.DateEffective     <= #sel#  
				
		<!--- -------------------------------------- --->
		<!--- most common searches to make it faster --->
		<!--- -------------------------------------- --->
		
		<cfif url.search neq "1">
		
			<cfif URL.Mode eq "Only" or URL.Unit eq "Unit">			
			    AND  P.OrgUnit#Tree# = '#URL.ID1#'  
			<cfelse>
				AND  O.HierarchyCode LIKE '#OrgUnit.HierarchyCode#%'				
			</cfif>
		
		</cfif>
				
		<cfif AccessList neq "" and 
		      AccessList neq "full" and 
			  getAdministrator(url.mission) eq "0">
		
		AND      P.OrgUnitOperational IN (#preservesingleQuotes(AccessList)#)  
		
		</cfif>
				
		UNION ALL
		
		SELECT   P.*, 
		         PP.Mission   as MissionUsed,
				 PP.MandateNo as MandateUsed,
		         PP.OrgUnit#Tree# AS OrgUnit, 
				 R.PresentationColor,
				 
				 <!--- determine if there is an position action --->
				 
				 (SELECT ObjectId 
				  FROM   Organization.dbo.OrganizationObject		 
				  WHERE  ObjectKeyValue1 = P.PositionNo
				  AND    EntityCode     = 'PositionReview'				      
				  AND    Operational = 1 ) as PositionReview,
				 
				  <cfif recruitmentOperational eq "0">
				  
				   0 as TrackCurrent,
				 				   
				   <cfelse>
				   				 				   
				   		 <!--- select track occurence --->
												  
							(
							
							SELECT  TOP 1 DocumentNo 
							
							FROM
														
									(
									
									SELECT    D.DocumentNo							
									FROM      Vacancy.dbo.DocumentPost as Track INNER JOIN
				      			              Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
						                      Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
						                      Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo
									WHERE     SP.PositionNo = P.PositionNo 
									AND       D.EntityClass IS NOT NULL 
									AND       D.Status = '0'
									
									UNION
										
										<!--- position has an upcoming track assignment --->  
										
										SELECT      PA.SourceId
                                        FROM        PersonAssignment AS PA 
                                        WHERE       PA.Source = 'vac' 
										AND         PA.PositionNo = P.PositionNo
										AND         PA.AssignmentStatus IN ('0', '1') 
										AND         PA.AssignmentType = 'Actual' 
										AND         PA.DateEffective >= GETDATE() 
																							
									UNION 
																					
									<!--- first position in the next mandate --->			
									
									SELECT     D.DocumentNo 
									
									FROM       Vacancy.dbo.DocumentPost as Track INNER JOIN
						                       Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
							                   Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
							                   Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo INNER JOIN
						                       Position PN ON SP.PositionNo = PN.SourcePositionNo
											   
									WHERE      PN.PositionNo = P.PositionNo
									AND        D.EntityClass IS NOT NULL 
									AND        D.Status = '0' 
									
									) as DerrivedTable 
									
									ORDER BY DocumentNo DESC
													
							) AS  RecruitmentTrack,  <!--- prior mandate track linked through position source --->
					  
				  
				   </cfif>
				 				 
				 'Loaned' AS Class  <!--- this position was budgeted under this unit, but its usage is somewhere else --->
				 
		FROM     Position P, 
				 Ref_PostClass R,
		         PositionParent PP
				 
		WHERE    PP.Mission          = '#URL.Mission#'
		AND      PP.MandateNo        = '#URL.Mandate#' 
		AND      P.PositionParentId  = PP.PositionParentId 				
		AND      P.DisableLoan       = 0	<!--- we check for loan situation 20/7/2019 --->		 
					 		
		<!--- the position is loaned ---> 
		AND      (P.OrgUnit#Tree# != PP.OrgUnit#Tree# OR P.MissionOperational != PP.Mission)
		
		<cfif url.tree eq "Functional">
		
		AND      P.OrgUnitFunctional IN (SELECT OrgUnit 
		                                 FROM   Organization.dbo.Organization 
									     WHERE  MissionAssociation = '#misfun#')
		
		</cfif>
		
		AND      R.PostClass         = P.PostClass		
		AND      P.DateExpiration   >= #sel#  
		AND      P.DateEffective    <= #sel# 
		
		<cfif AccessList neq "" and AccessList neq "full" >
		AND      P.OrgUnitOperational IN (#preservesingleQuotes(AccessList)#)
		</cfif>
		
		<!--- most common searches --->
		
		<cfif url.search neq "1">
		
			<cfif URL.Mode eq "Only" or URL.Unit eq "Unit">			
			    AND  PP.OrgUnit#Tree# = '#URL.ID1#'  
			<cfelse>
				AND  PP.OrgUnit#Tree# IN (SELECT OrgUnit 
				                          FROM   userQuery.dbo.#SESSION.acc#Tree#FileNo# 
										  WHERE  HierarchyCode LIKE '#OrgUnit.HierarchyCode#%')				
			</cfif>
		
		</cfif>		
		
		ORDER BY PositionNo  
		
		
	</cfquery>		
	
	<!---
	<cfoutput>#cfquery.executiontime#</cfoutput>
	--->
			
	<!--- now we extract assignments --->

	<cfquery name="Assignment" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT A.DateEffective, 
		       A.DateExpiration, 
			   A.FunctionNo as FunctionNoActual, 
			   A.FunctionDescription as FunctionDescriptionActual,
			   A.Incumbency,
			   P.FullName,
			   P.LastName, 
			   P.MiddleName, 
			   P.MaidenName, 
			   P.FirstName, 
			   P.PersonNo, 
			   P.Nationality, 
			   P.Gender,
			   P.IndexNo, 
			   P.Reference,
			   A.PositionNo, 		  
			   A.AssignmentNo, 
			   A.Source,
			   A.SourceId,
			   A.SourcePersonNo,
			   
			   <!--- --------------------- --->
			   <!--- select ePas occurence --->
			   <!--- --------------------- --->
			   
			   <cfif ePasoperational eq "1">
			   
			   	  (  SELECT count(*) 
					 FROM   EPAS.dbo.Contract E 
					 WHERE  PersonNo = A.PersonNo
					 AND    Mission = PO.Mission
					 AND    ActionStatus != '9') as ContractNo,
			   <cfelse>
			   
				   0 as ContractNo,
			   </cfif>		 
			   
			   <!--- -------------------------- --->
			   <!--- last contract level issued --->
			   <!--- -------------------------- --->
			     
			   (SELECT   TOP 1 Contractlevel 
			    FROM     PersonContract C 
				WHERE    C.PersonNo = P.PersonNo 
				AND      (C.Mission = PO.Mission OR C.Mission = 'UNDEF')
				AND      C.ActionStatus != '9' 
				ORDER BY Created DESC) as ContractLevel,
				
			   (SELECT   TOP 1 ContractStep 
			    FROM     PersonContract C 
				WHERE    C.PersonNo = P.PersonNo 
				AND      (C.Mission = PO.Mission OR C.Mission = 'UNDEF')
				AND      C.ActionStatus != '9' 
				ORDER BY Created DESC) as ContractStep,	
				
			  (SELECT    TOP 1 ContractTime 
			    FROM     PersonContract C 
				WHERE    C.PersonNo = P.PersonNo 
				AND      (C.Mission  = PO.Mission OR C.Mission = 'UNDEF') 
				AND      C.ActionStatus != '9' 
				ORDER BY Created DESC) as ContractTime,
			 
			   A.OrgUnit as OrgUnitActual, 
			   
			   Ext.ActionStatus as Extension,
			   Ext.DateExtension
			   
		INTO   userQuery.dbo.#SESSION.acc#Assignment#FileNo#	 
		
		FROM   PersonAssignment A 
			   INNER JOIN      userQuery.dbo.#SESSION.acc#Position#FileNo# PO ON A.PositionNo = PO.PositionNo 
			   INNER JOIN      Person P ON A.PersonNo = P.PersonNo 
			   LEFT OUTER JOIN PersonExtension Ext ON A.PersonNo = Ext.PersonNo AND Po.Mission = Ext.Mission AND Po.MandateNo = Ext.MandateNo
		
		<!--- show all positions of interest --->      
		WHERE  A.AssignmentStatus < '#Parameter.AssignmentShow#'
		
		AND    A.DateExpiration >= #sel# 
		AND    A.DateEffective  <= #sel#  
	
	</cfquery>
	
	<!---	
	#cfquery.executiontime#
	--->
	
	
	<!--- --------------------------------------------- --->
	<!--- Subtable with position and assignments joined --->
	<!--- --------------------------------------------- --->
				
	<cfsavecontent variable="baseset">
		<cfoutput>
		
		SELECT DISTINCT Post.PresentationColor,
			   Post.PostAuthorised, 
			   Post.PositionNo, 
			   Post.PositionParentId,
			   Post.Remarks, 
			   Post.FunctionNo,
			   Post.FunctionDescription, 
			   Post.PostClass, 
			   Post.PostGrade, 
			   Post.SourcePostNumber, 			   
			   Post.PostType,			   
			   Post.DateEffective as PostEffective, 
			   Post.DateExpiration as PostExpiration,			   
			   Post.Class, 
			   Post.OrgUnitOperational, 
			   Post.OrgUnit, 		
			   Post.PositionReview,	   
			   Post.RecruitmentTrack,			   	   
			   Post.LocationCode,	
			   	
		       Staff.DateEffective, 
		       Staff.DateExpiration, 
			   Staff.FunctionNoActual,
			   Staff.FunctionDescriptionActual, 
			   Staff.OrgUnitActual,
			   Staff.FullName,
		       Staff.LastName, 
			   Staff.MiddleName,
			   Staff.FirstName, 
			   Staff.PersonNo, 
			   Staff.Nationality, 
			   Staff.Gender,  
			   Staff.IndexNo,
			   Staff.Reference, 
			   Staff.Incumbency,
			   Staff.AssignmentNo,
			   Staff.Source,
			   Staff.SourceId,
			   Staff.SourcePersonNo, 
			   Staff.Extension, 
			   Staff.ContractNo,
			   Staff.ContractLevel, 
			   Staff.ContractStep,
			   Staff.ContractTime,
			   
			   L.LocationName,
			   L.ListingOrder as LocationOrder 	
		
		FROM   userQuery.dbo.#SESSION.acc#Position#FileNo# Post LEFT OUTER JOIN 
		       userQuery.dbo.#SESSION.acc#Assignment#FileNo# Staff ON Post.PositionNo = Staff.PositionNo LEFT OUTER JOIN 
			   Location L ON L.LocationCode = Post.LocationCode
			   
		</cfoutput> 
		
	</cfsavecontent>	   
		
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Staffing_#URL.Org#">
  		
	<!--- ------------------------------------------------------- --->		
	<!--- listing query with relevant positions + loaned position --->
	<!--- ------------------------------------------------------- --->
  	
	<cfquery name="getSearchResult" 
	    datasource="AppsEmployee" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">				
					
	    SELECT TOP 750
		       'Assignment' as Search,
			   Staff.*,		    
			     		   
			   G.PostOrder,
			   C.PostInBudget, 			  
			   
			   PT.EnablePAS, 	
			   PT.EnableAssignmentReview,		  
			   
			   G.PostOrderBudget, 
			   P.Code as PostGradeParent,
			   P.ViewOrder, 	
			   
			   <cfif url.sort eq "WorkSchedule">
			   ISNULL(S.Description,'0') as WorkSchedule,
			   </cfif>  
			  
			   Org.OrgUnitName, 			  
			   Org.HierarchyCode, 
			   Org.OrgUnitCode,  
			   PP.OrgUnit#Tree#  as OrgUnitParent, 
			   PP.DateEffective  as ParentEffective, 
			   PP.DateExpiration as ParentExpiration,
				   (
				   SELECT count(1)
				   FROM   (#preservesinglequotes(baseset)#) B
				   WHERE  PersonNo IS NOT NULL
				   AND    PositionNo = Staff.PositionNo
				   AND    Incumbency > 0
				   ) as Total		
				   
				
		INTO     userQuery.dbo.#SESSION.acc#Staffing_#url.org#
					   
		FROM      Ref_PostType PT 
		          INNER JOIN (#preservesinglequotes(baseset)#) Staff ON PT.PostType = Staff.PostType
				  INNER JOIN PositionParent PP             ON Staff.PositionParentId = PP.PositionParentId 					  
				  <cfif url.sort eq "WorkSchedule">
				  LEFT OUTER JOIN WorkSchedulePosition WS  ON Staff.PositionNo = WS.PositionNo AND WS.CalendarDate = #sel#
				  LEFT OUTER JOIN WorkSchedule S                ON S.Code = WS.WorkSchedule					 
				  </cfif>
				  INNER JOIN userQuery.dbo.#SESSION.acc#Tree#FileNo# Org ON Staff.OrgUnit = Org.OrgUnit 
				  INNER JOIN Applicant.dbo.FunctionTitle F ON Staff.FunctionNo = F.FunctionNo  
				  INNER JOIN Applicant.dbo.OccGroup Occ    ON F.OccupationalGroup = Occ.OccupationalGroup 
				  INNER JOIN Ref_PostClass C               ON Staff.PostClass = C.PostClass 
				  INNER JOIN Ref_PostGrade G               ON Staff.PostGrade = G.PostGrade 
				  INNER JOIN Ref_PostGradeParent P         ON G.PostGradeParent = P.Code			   
		  		  			
	  	WHERE  1=1
		
		<!--- overall filtering --->
		
		 <cfif cat neq "">
		    AND   P.Code IN (#PreserveSingleQuotes(cat)#) 
		 </cfif>
		 <cfif occ neq "">
		    AND   Occ.OccupationalGroup IN (#PreserveSingleQuotes(occ)#) 
		 </cfif>
		 <cfif cls neq "">
		    AND   Staff.PostClass IN (#PreserveSingleQuotes(cls)#) 
		 </cfif>
		 <cfif pte neq "">
		    AND   Staff.PostType IN (#PreserveSingleQuotes(pte)#) 
		 </cfif>
		 <cfif aut neq "">
		    AND   Staff.PostAuthorised IN (#PreserveSingleQuotes(aut)#) 
		 </cfif>
					
		<!--- filter positions to be shown --->
		
		<cfif getAdministrator(url.mission) eq "0">
		
		
		AND   Staff.PostType IN (
							 SELECT ClassParameter 
			    	         FROM   Organization.dbo.OrganizationAuthorization 
					         WHERE  Mission        = '#URL.Mission#'
							 AND    UserAccount    = '#SESSION.acc#' 
							 AND    Role IN (SELECT  Role
											FROM    Organization.dbo.Ref_AuthorizationRole
										    WHERE   SystemModule = 'Staffing' 
											AND     Parameter    = 'PostType')							 
					         )
		</cfif>
						
		<cfif Search eq "1">
					
			<cfif URL.opt eq "1">
			   <cfset sp = "">
			<cfelse>
			   <cfset sp = " ">
			</cfif>   
						
			<cfswitch expression="#URL.tpe#">
		  	  <cfcase value="position">
			  
				  AND (Staff.FunctionDescription LIKE '%#sp##URL.fld##sp#%'
					    OR Staff.PositionNo       LIKE '%#sp##URL.fld##sp#%' 
						OR Staff.PositionParentId LIKE '%#sp##URL.fld##sp#%' 
					    OR Staff.SourcePostNumber LIKE '%#sp##URL.fld##sp#%' 
					    
					    <!--- added by hanno to allow searching in the new mandate --->
					    OR Staff.RecruitmentTrack IN (
												
					    						SELECT D.DocumentNo 
						                        FROM   Vacancy.dbo.Document D
						                        WHERE  D.Status != '9'
												AND    D.DocumentNo LIKE '%#sp##URL.fld##sp#%'
												UNION
												SELECT DocumentNo
												FROM   Applicant.dbo.FunctionOrganization 
												WHERE  ReferenceNo LIKE '%#sp##URL.fld##sp#%'											
												<!-----
												SELECT Doc.DocumentNo
												FROM Vacancy.dbo.Document as Doc INNER JOIN Applicant.dbo.FunctionOrganization as FO
													ON Doc.FunctionId	=	Fo.FunctionId
												WHERE 1=1
												AND FO.ReferenceNo LIKE '%#sp##URL.fld##sp#%'
												----->
												)				   
																	    
					    
						
						OR Staff.PositionNo IN (
						                        SELECT DP.PositionNo 
						                        FROM   Vacancy.dbo.DocumentPost DP INNER JOIN Vacancy.dbo.Document D
												       ON D.DocumentNo = DP.DocumentNo
						                        WHERE  DP.PositionNo = Staff.PositionNo												
												AND    D.Status != '9'
												AND    D.DocumentNo LIKE '%#sp##URL.fld##sp#%'
												UNION
												SELECT DP.PositionNo 
						                        FROM   Vacancy.dbo.DocumentPost DP INNER JOIN Vacancy.dbo.Document D
												       ON D.DocumentNo = DP.DocumentNo
						                        WHERE  DP.PositionNo = Staff.PositionNo												
												AND    D.Status != '9'
												AND    D.DocumentNo IN ( SELECT DocumentNo
													                     FROM   Applicant.dbo.FunctionOrganization 
																		 WHERE  DocumentNo = D.DocumentNo 
																		 AND    ReferenceNo LIKE '%#sp##URL.fld##sp#%'
																		 )
													
											    ) 
											    
					)							
			 </cfcase>
			 
			 <cfcase value="project">
			 
			  AND  PP.PositionParentId IN (
			 
							SELECT   PositionParentId
							FROM     PositionParentFunding PF INNER JOIN
							         Program.dbo.Program PR ON PF.ProgramCode = PR.ProgramCode INNER JOIN
							         Program.dbo.ProgramPeriod Pe ON PR.ProgramCode = Pe.ProgramCode
							WHERE    (
							              (PR.ProgramName LIKE '%#sp##URL.fld##sp#%')      OR
							              (PF.ProgramCode LIKE '%#sp##URL.fld##sp#%')      OR
							              (Pe.Reference LIKE '%#sp##URL.fld##sp#%')        OR
										  (Pe.ReferenceBudget1 LIKE '%#sp##URL.fld##sp#%') OR
										  (Pe.ReferenceBudget2 LIKE '%#sp##URL.fld##sp#%') OR
										  (Pe.ReferenceBudget3 LIKE '%#sp##URL.fld##sp#%') OR
										  (Pe.ReferenceBudget4 LIKE '%#sp##URL.fld##sp#%') OR
										  (Pe.ReferenceBudget5 LIKE '%#sp##URL.fld##sp#%') OR
										  (Pe.ReferenceBudget6 LIKE '%#sp##URL.fld##sp#%') 
									 )
							AND      PF.DateEffective <= #sel# 
							AND      (PF.DateExpiration is NULL or PF.DateExpiration >= #sel#)
							AND      PF.PositionParentId = PP.PositionParentId
							
							) 

			 </cfcase>
			 
			  <cfcase value="location">
			  
				  AND (Staff.LocationCode LIKE '%#sp##URL.fld##sp#%'
					    OR Staff.LocationName LIKE '%#sp##URL.fld##sp#%' 
					    OR Staff.LocationOrder LIKE '%#sp##URL.fld##sp#%') 
			 </cfcase>
			 			 
			 <cfcase value="employee">
			 
			 	<!--- employee or future employee --->
			 					 
				 <cfset nmc = "">
				 
				 <cfloop index="itm" list="#URL.fld#" delimiters=", ">
				   <cfif nmc eq "">
				   	<cfset nmc = "Staff.FullName LIKE '%#sp##itm##sp#%'">
				   <cfelse>
				   	<cfset nmc = "#preserveSingleQuotes(nmc)# AND Staff.FullName LIKE '%#sp##itm##sp#%'">
				   </cfif>
				 </cfloop>
											 
				 	AND    
					
					        (
							
							<!--- look for information in the staffing record --->
							<cfif nmc neq "">(#preserveSingleQuotes(nmc)#) OR </cfif>					        
							Staff.FullName       LIKE '%#sp##URL.fld##sp#%' 
						    OR Staff.IndexNo     LIKE '%#sp##URL.fld##sp#%'
						    OR Staff.Nationality LIKE '#URL.fld#%'
						    
						    <!--- added by hanno to allow searching in the new mandate --->
						     
					    	OR Staff.RecruitmentTrack IN (
					    				SELECT D.DocumentNo 
						                FROM   Vacancy.dbo.Document D INNER JOIN Vacancy.dbo.DocumentCandidate DC ON D.DocumentNo = DC.DocumentNo 
						                WHERE  (LastName LIKE '%#sp##URL.fld##sp#%' OR FirstName LIKE '%#sp##URL.fld##sp#%')
										AND    DC.Status IN ('2','2s') 
										AND    D.Status != '9' )              											
					
							<!--- to be tuned Hanno 4/9/2013 to take a wider selection --->
							<!--- look for information in the recruitment record --->			   

							OR (

							       Staff.PositionNo IN 
									     <!--- select positions that have this name as a candidate --->
								        (
										 SELECT DP.PositionNo 
								         FROM   Vacancy.dbo.DocumentCandidate DC INNER JOIN Vacancy.dbo.DocumentPost DP ON  DC.DocumentNo = DP.DocumentNo 
								         WHERE  (LastName LIKE '%#sp##URL.fld##sp#%' OR FirstName LIKE '%#sp##URL.fld##sp#%')
										 AND    DC.Status IN ('2','2s') <!--- DC.Status IN ('0','1','2','2s') --->		 
										   
										 <cfif isNumeric(URL.fld)>
										 UNION
										 SELECT DP.PositionNo 
								         FROM   Vacancy.dbo.Document D, Vacancy.dbo.DocumentPost DP
										 WHERE  D.DocumentNo = DP.DocumentNo 
								           AND  D.DocumentNo = '#URL.fld#'
										   AND  D.Status IN ('0') 
										 </cfif>     
										)								   
								)
						 )					    					
			 </cfcase>	
			 
			 <cfcase value="orgunit">
			 
				 	AND  (Org.OrgUnitCode LIKE '%#sp##URL.fld##sp#%' OR 
					      Org.OrgUnitName LIKE '%#sp##URL.fld##sp#%' OR 
						  Org.OrgUnit LIKE '%#sp##URL.fld##sp#%') 
			 </cfcase>	
			 
		   </cfswitch>
		   
		   		
		<cfelse>
		
			<cfif URL.Mode neq "Only">
				<cfif URL.Level eq "Grade">
					AND   G.PostGradeBudget = '#URL.Filter#'
				<cfelseif URL.Level eq "Subtotal">
					AND   P.Code 			= '#URL.Filter#'
				</cfif>
			</cfif>	
			
			<cfif URL.Mode eq "Only" or URL.Unit eq "Unit">			
			    AND  Staff.OrgUnit = '#URL.ID1#'  
			<cfelse>
				AND  Org.HierarchyCode LIKE '#OrgUnit.HierarchyCode#%'				
			</cfif>
							
		</cfif>
		
		
		AND   Staff.PostExpiration >= #sel#
		AND   Staff.PostEffective <=  #sel#
			
		ORDER BY 
		
		<cfswitch expression="#URL.sort#">
			 <cfcase value="org">
			   <cfif Search neq "1">Org.HierarchyCode,</cfif>
			   ViewOrder, PostOrder
			 </cfcase>
			 <cfcase value="grade">
			   ViewOrder, PostOrder
			 </cfcase>
			  <cfcase value="workschedule">
			   S.ScheduleClass, S.Description
			 </cfcase>
			 <cfcase value="posttype">
			   Staff.PostType, ViewOrder, PostOrderBudget
			 </cfcase>
			 <cfcase value="postclass">
			   Staff.PostClass, ViewOrder, PostOrderBudget
			 </cfcase>
			 <cfcase value="function">
			   Staff.FunctionDescription, ViewOrder, PostOrderBudget
			 </cfcase>
			 <cfcase value="name">
			   Staff.LastName, Staff.FirstName
			 </cfcase>
			  <cfcase value="location">
			   Staff.LocationName, Staff.LocationOrder 
			 </cfcase>	
			 <cfcase value="nationality">
			   Staff.Nationality
			 </cfcase>	
			 <cfdefaultcase>
			    ViewOrder, PostOrder
			 </cfdefaultcase>	
		 </cfswitch>
		 		 					
	   </cfquery> 
		   	   
</cfoutput>	

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>
--->

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Tree#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Grade#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assignment#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#View#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ViewDouble#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Position#FileNo#">

<!--- outputting --->


<cfquery name="Param" 
		datasource="AppsEmployee">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfquery name="SearchResult" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">				   
		SELECT * FROM userquery.dbo.#SESSION.acc#Staffing_#url.org#
</cfquery>	


<!--- --------------------------------------------- --->						   
<!--- filter on the fly based on cell value clicked --->
<!--- --------------------------------------------- --->

<cfif URL.Search eq "1">

	<cfquery name="SearchResult" 
	     dbtype="query">
	   	   SELECT *
		   FROM SearchResult
	   </cfquery>

<cfelseif URL.Line eq "Aut">
  
	<cfquery name="SearchResult" 
	     dbtype="query">
	   	   SELECT *
		   FROM SearchResult
		   WHERE PostAuthorised = 1  
		   <cfif Param.StaffingViewMode eq "Extended">
		   AND PostInBudget = '1'
		  	
		   </cfif>
	   </cfquery>
	   
<cfelseif URL.Line eq "NonAut">
  
	<cfquery name="SearchResult" 
	     dbtype="query">
	   	   SELECT *
		   FROM SearchResult
		   WHERE PostAuthorised = 0
		   <cfif Param.StaffingViewMode eq "Extended">
		   AND PostInBudget = '1'
		   </cfif>  		  
	   </cfquery>	 	   
  
<cfelseif URL.Line eq "Vacancy">
  
	<cfquery name="SearchResult" 
	     dbtype="query">
	   	   SELECT *
		   FROM SearchResult
		   <cfif Param.StaffingViewMode eq "Extended">
		   WHERE PostInBudget = '1'		
		   <cfelse>
		   WHERE 1=1
		   </cfif>
		   AND 
		   (
		   PersonNo is NULL  OR (
		   	   Incumbency=0
			   AND 
			   Total=0  
			   <!---- AND THE ASSIGNMENT CLASS SHOULD BE REGULAR ----> 
			  )
			   
		    )
	   </cfquery>
   
<cfelseif URL.Line eq "IncUsd">	 
  
    <cfquery name="SearchResult" 
	     dbtype="query">
		   SELECT *
		   FROM SearchResult
		   WHERE PersonNo is not NULL 
		   <cfif Param.StaffingViewMode eq "Extended">
		   AND PostInBudget = '1' 		
		   </cfif>  		
	   </cfquery> 
	   
<cfelseif URL.Line eq "GTA">
  
	<cfquery name="SearchResult" 
	     dbtype="query">
	   	   SELECT *
		   FROM   SearchResult
		   WHERE  PostInBudget = '0'		  
	   </cfquery>	 
	      
<cfelseif URL.Line eq "IncumbGTA">
  
	<cfquery name="SearchResult" 
	     dbtype="query">
	   	   SELECT *
		   FROM  SearchResult
		   WHERE PostInBudget = '0'  	
		   AND   PersonNo is not NULL 	
	   </cfquery>		   

<cfelseif URL.Line eq "VacantGTA">
  
	<cfquery name="SearchResult" 
	     dbtype="query">
	   	   SELECT *
		   FROM SearchResult
		   WHERE PostInBudget = '0' 
		   AND ( PersonNo is NULL OR (Incumbency = 0 AND Total = 0)	)			
	   </cfquery>		    
   	   
</cfif>

<!---

	
	 <cfcatch>
	 
		 <table width="100%">
		 
			 <tr><td height="40" align="center" class="labelmedium">
			 	 A query error occurred, please make your selection again
				 <script>
					 Prosis.busy('no')
				 </script>
				 </td>
			 </tr>
		 
		 </table>
		 
	    <cfabort>
	 
	 </cfcatch>

</cftry>

--->

<cfinclude template="PostViewDetailList.cfm">

<script>
 Prosis.busy('no')
</script>
