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

<cfparam name="URL.header"        		default="Yes">
<cfparam name="URL.OrgUnitCode"    		default="">
<cfparam name="client.org"        		default="#URL.OrgUnitCode#">
<cfparam name="URL.Org"           		default="#client.org#">
<cfparam name="URL.ID1"           		default="">
<cfparam name="URL.PostClass"     		default="">
<cfparam name="URL.ID2"           		default="">
<cfparam name="URL.ID3"           		default="">
<cfparam name="URL.Act"           		default="0">
<cfparam name="URL.Mission"       		default="#URL.ID2#">
<cfparam name="URL.Mandate"       		default="#URL.ID3#">
<cfparam name="URL.SelectionDate" 		default="">
<cfparam name="AccessStaffing"    		default="NONE">
<cfparam name="CLIENT.lay"        		default="Listing">
<cfparam name="URL.ShowAllRecords"   	default="0">
<cfparam name="CLIENT.OldPageRecords"   default="40">

<cfif url.selectiondate eq "undefined">
	<cfset url.selectiondate = "">
</cfif>

<cfif url.org neq "">
	<cfset client.org = url.org>
</cfif>

<cfif url.orgUnitcode neq "">
    <cfset client.org = url.orgUnitcode>
</cfif>

<cfif Client.Lay eq "Current">
     <cfset Client.lay = "Maintain">
</cfif>

<cfparam name="URL.Lay" default="#CLIENT.lay#">
<cfparam name="URL.PDF" default="0">

<!--- print all records, no breaks --->
<cfif URL.PDF eq 1 OR URL.ShowAllRecords eq "1">	
	<cfset OldPageRecords = Client.PageRecords>
	<cfset Client.OldPageRecords = Client.PageRecords>
	<cfset Client.PageRecords = 9999>
<cfelse>
	<cfset Client.PageRecords = Client.OldPageRecords>
</cfif>

<cfif url.header eq "requisition">

   <cfset url.lay = "listing">

<cfelseif url.lay eq "Maintain">

	<cfif url.id eq "ORG">
		<cfinclude template="MandateViewMaintain.cfm">
		<cfabort>
	<cfelse>
		<cfset url.lay = "Listing">
	</cfif>
		
</cfif>

<cfif url.org eq "tree">

	<cfset url.org = "">
	
<cfelseif left(url.org,4) eq "node">

    <cfset cnt = len(url.org)-4>
	<cfset url.org = mid(url.org,5,cnt)>

</cfif>

<!--- --------- --->
<!--- Labelling --->
<!--- --------- --->

<cf_tl id="Recruitment" var="1">
<cfset tRecruitment=lt_text>

<cf_tl id="No candidate information available" var="1" class="message">
<cfset tNoCandidateInfo=lt_text>

<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 * 
	FROM Parameter   
</cfquery>

<cfquery name="ParamMission" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   Ref_Mandate
	WHERE  Mission   = '#URL.Mission#'
	AND    MandateNo = '#URL.Mandate#' 
</cfquery>
           
<cfif Mandate.DateExpiration eq "">
     <cf_message Message="Problem, please define a mandate enddate under <u>Maintain Staffing Period</u>" return="no">
     <cfabort>
</cfif>

<cfif url.selectiondate neq "">
       <CF_DateConvert Value="#url.selectiondate#">    
<cfelseif Mandate.DateExpiration lt now() >
       <CF_DateConvert Value="#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
<cfelseif Mandate.DateEffective gt now()>   
       <CF_DateConvert Value="#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
<cfelse> 
 	   <CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
</cfif>
	
<cfset sel       = dateValue>
<cfset incumdate = dateValue>

<cfif url.header eq "requisition">
	<cfset selend    = sel+90>
<cfelse>
	<cfset selend    = sel>
</cfif>

<cfset HStart = "">
<cfset HEnd = "9999999999999">

<cfset cond = "">

<cfset orgaccess = "NONE">

<cfif url.org neq "">
	 		  
	  <cf_OrganizationSelect
			    Mission = "#URL.Mission#"
				Mandate = "#URL.Mandate#"					
				Enforce = "1"		
				OrgUnitCode = "#URL.ORG#">  	
							  
</cfif>


<cfswitch expression="#URL.ID#">

	<cfcase value="Locate">
	
	  <cfif URL.Act eq "0">
	 	
		  <cfif URL.SelectionDate neq "">
		  
		        <CF_DateConvert Value="#URL.SelectionDate#">
				
				<cfif dateValue gt Mandate.DateExpiration or dateValue lt Mandate.DateEffective>
				
					<cf_message message="Your selection date (#URL.SelectionDate#) lies outside the staffing period" return="no">
					<cfabort>
				
				</cfif>				
				<cfset sel = dateValue>				
				<cfset incumdate = dateValue>
				
		  </cfif>
		  
		  
		  <cfif URL.OrgUnitCode neq "">		  
		  
	  			<cf_OrganizationSelect
				    Mission = "#URL.Mission#"
					Mandate = "#URL.Mandate#"
					OrgUnitCode = "#URL.OrgUnitCode#">  
					
		  </cfif>	
		  		  		  
		  <cfif URL.OrgUnit1 neq "">
		            <cfif cond eq "">
					   <cfset cond = " AND Post.OrgUnitAdministrative = '#URL.OrgUnit1#'">
					<cfelse>
					   <cfset cond = "#Cond# AND Post.OrgUnitAdministrative = '#URL.OrgUnit1#'">
					</cfif>
		  </cfif>	
		  
		  <cfif URL.LocationCode neq "">
		            <cfif cond eq "">
					   <cfset cond = " AND Post.LocationCode = '#URL.LocationCode#'">
					<cfelse>
					  <cfset cond = "#Cond# AND Post.LocationCode = '#URL.LocationCode#'">
					</cfif>
		  </cfif>	
		  
		  <cfif URL.SourcePostNumber neq "">
		  
		  			<cfoutput>
		  
		  			<cfsavecontent variable="c">
		  
		              (Post.SourcePostNumber LIKE '#URL.SourcePostNumber#%' 
					   OR CONVERT(varchar, Post.PositionNo)  = '#url.SourcePostNumber#' 
					   
					   OR Post.FunctionDescription LIKE '%#URL.SourcePostNumber#%'
					   
					   OR Post.PositionParentId IN (
			 
							SELECT   PositionParentId
							FROM     Employee.dbo.PositionParentFunding PFT INNER JOIN
							         Program.dbo.Program PRT ON PFT.ProgramCode = PRT.ProgramCode INNER JOIN
							         Program.dbo.ProgramPeriod Pe ON PRT.ProgramCode = Pe.ProgramCode
							WHERE    (
							               (PRT.ProgramName LIKE '%#URL.SourcePostNumber#%') OR
							               (PFT.ProgramCode LIKE '%#URL.SourcePostNumber#%') OR
							               (Pe.Reference   LIKE '%#URL.SourcePostNumber#%')
									 )
							AND      PFT.DateEffective <= #selend# 
							AND      (PFT.DateExpiration is NULL or PFT.DateExpiration >= #sel#)
							AND      PFT.PositionParentId = Post.PositionParentId
							
							) 
		        
					)
									
				   </cfsavecontent>
				   
				   </cfoutput>
				   
		            <cfif cond eq "">
					   <cfset cond = " AND #c#">
					<cfelse>
					  <cfset cond = "#Cond# AND #c#">
					</cfif>
										
		  </cfif>	
		  
		  <cfif URL.Name neq "">
		  
		   <cfset nmc = "">
				 
				 <cfloop index="itm" list="#URL.Name#" delimiters=", ">
				   <cfif nmc eq "">
				   	<cfset nmc = " (P.FullName LIKE '%#itm#%' OR P.IndexNo LIKE '#itm#%')">
				   <cfelse>
				   	<cfset nmc = "#preserveSingleQuotes(nmc)# AND (P.FullName LIKE '%#itm#%' OR P.IndexNo LIKE '#itm#%')">
				   </cfif>
				 </cfloop>
		  				  
		         <cfset c = "Post.PositionNo IN (SELECT PositionNo FROM Employee.dbo.PersonAssignment A, Employee.dbo.Person P WHERE A.AssignmentStatus IN ('0','1') and A.PersonNo = P.PersonNo AND (#nmc#))"> 
		         <cfif cond eq "">
					 <cfset cond = "AND #c#">
				 <cfelse>
					 <cfset cond = "#Cond# AND #c#">
				 </cfif>
		  </cfif>	
		  		  			  
		  <cfif URL.OccGroup neq "">
		            <cfset c = "F.OccupationalGroup = '#URL.OccGroup#'">
		            <cfif cond eq "">
					   <cfset cond = "AND #c#">
					<cfelse>
					  <cfset cond = "#Cond# AND #c#">
					</cfif>
		  </cfif>	
		 	 	  
		  <cfif URL.Parent neq "">
		            <cfif cond eq "">
					   <cfset cond = " AND PostGradeParent = '#URL.Parent#'">
					<cfelse>
					  <cfset cond = "#Cond# AND PostGradeParent = '#URL.Parent#'">
					</cfif>
		  </cfif>	
	  
	  </cfif>
	  
	</cfcase>
	
	<cfcase value="ORG">	

	   <cfif URL.ID1 neq "">
	   
	      <cfset cond = "AND Org.OrgUnitCode = '#URL.ID1#'">
		  
		  <cf_OrganizationSelect
			    Mission = "#URL.Mission#"
				Mandate = "#URL.Mandate#"					
				Enforce = "1"		
				OrgUnitCode = "#URL.ID1#">  	
						  
	   <cfelse>
	   
	      <cfset cond = "">
		  
	   </cfif>	
	   	   
	   <cfquery name="OrgUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Organization O
			WHERE Mission     = '#URL.Mission#'
			AND   MandateNo   = '#URL.Mandate#'
			AND   OrgUnitCode = '#URL.ID1#'   			
	   </cfquery>
	   
	   
	   <cfinvoke component="Service.Access"  
	        method="org" 
		    orgunit="#OrgUnit.OrgUnit#" 
			returnvariable="orgaccess">
							 	  		    
	</cfcase>
		
	<cfcase value="GRP">	
		<cfset cond   = "AND PostGradeParent = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="VCL">
		<cfset cond   = "AND Post.VacancyActionClass = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="GRD">
		<cfset cond   = "AND Post.PostGrade = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="LOC">
		<cfset cond   = "AND Post.LocationCode = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="PGP">
		<cfset cond   = "PositionGroup = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="PTP">
		<cfset cond   = "AND Post.PostType = '#URL.ID1#'">
	</cfcase>
		
	<cfcase value="ADM">
		<cfset cond   = "AND Post.PostType = '#URL.ID1#' AND Post.OrgUnitAdministrative = '#URL.ID1A#'">
	</cfcase>
		
	<cfcase value="OCG">
		<cfset cond   = "AND F.OccupationalGroup = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="ORA">
		<cfset cond   = "AND Post.OrgUnitAdministrative = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="ORF">
		<cfset cond   = "AND Post.OrgUnitFunctional = '#URL.ID1#'">
	</cfcase>
		
	<cfcase value="FUN">
		<cfset cond   = "AND Post.FunctionNo = '#URL.ID1#'">
	</cfcase>
		
	<cfcase value="BOR">
		<cfset cond = "AND Post.PostGrade = '#URL.ID1#' AND Post.MissionOperational = '#URL.ID4#'">
	</cfcase>

</cfswitch>

<cfset batch = "0">
<cfparam name="CLIENT.Sort" default="OrgUnit">

<cfif CLIENT.Sort neq "PostOrder" and
      CLIENT.Sort neq "PostClass" and
      CLIENT.Sort neq "Posttype" and
	  CLIENT.Sort neq "OrgUnit" and
	  CLIENT.Sort neq "DateExpiration">
	  <cfset deleted = deleteClientVariable("Sort")>
</cfif>   

<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfparam name="URL.Sort"    default="#CLIENT.Sort#">

<cfif URL.ID eq "BOR" and URL.Sort eq "OrgUnit">
  <cfset URL.Sort = "PostType">
</cfif>

<cfif URL.ID eq "ORG">
   <cfset URL.Sort = "OrgUnit">
</cfif>

<cfset condA = "">
<cfparam name="URL.ID4"  default="">   
  
<cfparam name="URL.page" default="1">
<cfset CLIENT.sort = URL.Sort>
<cfset CLIENT.lay  = URL.Lay>

<cfset currrow = 0>
<cfset header = 0>
		    
<cfif Mandate.DateExpiration lt now()>
    <cfparam name="URL.Lay" default="All">
</cfif>
		   
<cfif URL.Sort eq "DateExpiration">
     <cfset orderby = "Post.DateExpiration DESC">
<cfelseif URL.Sort eq "LocationCode">
     <cfset orderby = "Post.LocationOrder, Post.LocationName">	 
<cfelseif URL.Sort eq "Print">
     <cfset orderby = "Post.DateExpiration DESC">
<cfelse>
     <cfset orderby = "Post.#URL.Sort#">	
</cfif> 


<!--- create a temp table for later repeated usage in the template --->

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Post#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Position#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Assignment#FileNo#">
	
<cftransaction isolation="READ_UNCOMMITTED">
		
	<cfif URL.ID eq "BOR">
		
		<!--- Query returning search results in temp table--->
		<cfquery name="SearchResultX" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		  SELECT Post.*, 
		         Post.OrgUnitOperational as OrgUnit, 
				 Org.OrgUnitName, 
				 G.PostGradeParent, 
				 P.Description as ParentDescription, 
		  		 P.ViewOrder, 
				 G.PostOrder, 
				 G.PostGradeBudget,
				 G.PostOrderBudget,		
				 O.OccupationalGroup, 
				 O.Description as OccGroupDescription,
				 NULL as DocumentNo,
				 L.LocationName,
				 L.ListingOrder as LocationOrder,
				 1 as Occurence,
				 0 as TrackCurrent,
				 0 as TrackPrior,
				  (SELECT TOP 1 RequisitionNo FROM PositionParentFunding WHERE PositionParentId = Post.PositionParentId) as Funding, 
				 'Used' as Class 
				 
		  INTO    userQuery.dbo.#SESSION.acc#Post#FileNo#
		  
		  FROM    Ref_PostGrade G INNER JOIN
	              Position Post ON G.PostGrade = Post.PostGrade INNER JOIN
	              Ref_PostGradeParent P ON G.PostGradeParent = P.Code INNER JOIN
	              Applicant.dbo.FunctionTitle F INNER JOIN
	              Applicant.dbo.OccGroup O ON F.OccupationalGroup = O.OccupationalGroup ON Post.FunctionNo = F.FunctionNo INNER JOIN
	              Organization.dbo.Organization Org ON Post.OrgUnitOperational = Org.OrgUnit LEFT OUTER JOIN
	              Location L ON Post.LocationCode = L.LocationCode	  
		 
		  WHERE   Post.Mission             = '#URL.Mission#'
		  AND     Post.MandateNo           = '#URL.Mandate#' 
		  
		  <cfif url.postclass neq "">	  
		  AND Post.PostClass = '#URL.PostClass#'	  
		  </cfif>	
		  	  
		  <cfif url.header eq "requisition"> 	  
		  AND Post.PostType IN (SELECT PostType 
		                        FROM   Ref_PostType 
								WHERE  Procurement = 1)	  
		  </cfif>
		   
		  <!---
		  AND Post.DateExpiration >= #sel#
		  AND Post.DateEffective  <= #sel#
		  --->
	
		  <cfif getAdministrator("*") eq "0">
		  
		  AND Post.PostType IN (SELECT ClassParameter 
								FROM   Organization.dbo.OrganizationAuthorization 
								WHERE  UserAccount = '#SESSION.acc#' 
								AND    Mission     = '#URL.Mission#'
								AND    ClassParameter = Post.PostType)
		  </cfif>	
		  	
		  <cfif URL.ID eq "ORG">				
		  AND Org.HierarchyCode    >= '#HStart#' 
		  AND Org.HierarchyCode    < '#HEnd#'
		  <cfelse>
		  #PreserveSingleQuotes(cond)# 
		  </cfif>
		      
		</cfquery>
			
	<cfelse>
				
		  <!--- the first section can be cancelled at some point when UN is on supertrack --->
		  	 				
		  <cfquery name="CheckVacancy" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization.dbo.Ref_MissionModule
					WHERE  Mission = '#URL.Mission#'
					AND    SystemModule = 'Vacancy' 
		  </cfquery>				
				 	
		  <!--- returning search results with relevant positions --->
		  
		 		  				 		
		  <cfquery name="Position" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT   O.Mission              as MissionUsed, 
				         O.MandateNo            as MandateNoUsed,
						 O.OrgUnit, 
		                 O.OrgUnitName, 
						 O.OrgUnitCode, 
						 O.HierarchyCode, 
						 O.DateExpiration       as OrgExpiration,
						 P.*, 
						 
						 (CASE WHEN P.DisableLoan = 0 THEN PP.OrgUnitOperational ELSE P.OrgUnitOperational END)   as ParentOrgUnit,
						 (CASE WHEN P.DisableLoan = 0 THEN PP.FunctionDescription ELSE P.FunctionDescription END) as ParentFunctionDescription,
				       						
						  <cfif CheckVacancy.recordcount eq "0">
						  
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
										
										SELECT    D.DocumentNo 
										
										FROM      Vacancy.dbo.DocumentPost as Track INNER JOIN
							                      Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
								                  Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
								                  Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo INNER JOIN
							                      Position PN ON SP.PositionNo = PN.SourcePositionNo
												   
										WHERE     PN.PositionNo = P.PositionNo
										AND       D.EntityClass IS NOT NULL 
										AND       D.Status = '0' 
										
										) as DerrivedTable 
														
								) AS  RecruitmentTrack,  
						  
						   </cfif>	
						   
						 <!--- position operational unit sets the used --->  			 
						 
		                 'Used' AS Class
						 
				INTO     userQuery.dbo.#SESSION.acc#Position#FileNo#
				
				FROM     Position P, 
				         PositionParent PP, 
						 Organization.dbo.Organization O
						 
				WHERE    P.PositionParentId = PP.PositionParentId 
				AND      P.OrgUnitOperational = O.OrgUnit
				AND      O.Mission        = '#URL.Mission#'
				AND      O.MandateNo      = '#URL.Mandate#' 
				AND      P.DateExpiration >= #sel#  
				AND      P.DateEffective  <= #selend# 
				AND      O.HierarchyCode  >= '#HStart#' 
		        AND      O.HierarchyCode  < '#HEnd#'   
				
				<cfif url.header eq "requisition"> 	  
				AND      PP.PostType IN (SELECT PostType FROM Ref_PostType WHERE Procurement = 1)	  
				</cfif>
								
				<cfif url.postclass neq "">	  
				AND      P.PostClass = '#URL.PostClass#'	  
				</cfif>	  
				
				UNION ALL
				
				SELECT   PP.Mission    as MissionUsed,
				         PP.MandateNo  as MandateNoUsed,
						 O.OrgUnit, 
		                 O.OrgUnitName, 
						 O.OrgUnitCode, 
						 O.HierarchyCode, 
						 O.DateExpiration as OrgExpiration,
				         P.*,  
				         PP.OrgUnitOperational   as ParentOrgUnit,
						 PP.FunctionDescription  as ParentFunctionDescription,						 
						 <cfif CheckVacancy.recordcount eq "0">						 
						 	    0 as RecruitmentTrack,							 					 
						 <cfelse>		
						 
						      <!--- check if the position has an active recruitment track --->				
						 					 												  
								(
								
								SELECT  TOP 1 DocumentNo 
								
								FROM															
										(
										
										<!--- current mandate ---> 
										
										SELECT      D.DocumentNo						
										FROM        Vacancy.dbo.DocumentPost as Track INNER JOIN
					      			                Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
							                        Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
							                        Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo
										WHERE       SP.PositionNo = P.PositionNo 
										AND         D.EntityClass IS NOT NULL 
										AND         D.Status = '0'
										
										UNION
										
										<!--- position has a upcoming track assignment --->  
										
										SELECT      PA.SourceId
                                        FROM        PersonAssignment AS PA 
                                        WHERE       PA.Source = 'vac' 
										AND         PA.PositionNo = P.PositionNo
										AND         PA.AssignmentStatus IN ('0', '1') 
										AND         PA.AssignmentType = 'Actual' 
										AND         PA.DateEffective >= GETDATE() 
																																												
										UNION 
																						
										<!--- also we get a first position in the next mandate --->			
										
										SELECT      D.DocumentNo 
										
										FROM        Vacancy.dbo.DocumentPost as Track INNER JOIN
							                        Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
								                    Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
								                    Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo INNER JOIN
							                        Position PN ON SP.PositionNo = PN.SourcePositionNo
												   
										WHERE       PN.PositionNo = P.PositionNo
										AND         D.EntityClass IS NOT NULL 
										AND         D.Status = '0' 
										
										) as D
														
								) AS  RecruitmentTrack,  
						  
						   </cfif>				
						
						 <!--- position parent operational unit determines the loan --->  	
						  
						 'Loaned' AS Class
						 
				FROM     Position P, 
				         PositionParent PP, 
						 Organization.dbo.Organization O
						 
				WHERE    P.PositionParentId    = PP.PositionParentId 
				AND      P.OrgUnitOperational != PP.OrgUnitOperational
				AND      PP.OrgUnitOperational = O.OrgUnit
				AND      PP.Mission            = '#URL.Mission#'
				AND      PP.MandateNo          = '#URL.Mandate#' 
				AND      P.DateExpiration     >= #sel#  
				AND      P.DateEffective      <= #selend#  
				AND      O.HierarchyCode      >= '#HStart#' 
		        AND      O.HierarchyCode      < '#HEnd#'  	
				AND      P.DisableLoan         = 0			
				
				<cfif url.header eq "requisition"> 	 
				
				AND      PP.PostType IN (SELECT PostType FROM   Ref_PostType WHERE  Procurement = 1)	  
				</cfif>
				
				<cfif url.postclass neq "">	  
				AND      P.PostClass = '#URL.PostClass#'	  
				</cfif>	 
												
				UNION ALL    <!--- add positions that are actually used in another unit --->
				
				SELECT   PP.Mission    as MissionUsed,
				         PP.MandateNo  as MandateNoUsed,
						 O.OrgUnit, 
		                 O.OrgUnitName, 
						 O.OrgUnitCode, 
						 O.HierarchyCode, 
						 O.DateExpiration as OrgExpiration,
				         P.*,  
				         PP.OrgUnitOperational   as ParentOrgUnit,
						 PP.FunctionDescription  as ParentFunctionDescription,						 
						 <cfif CheckVacancy.recordcount eq "0">						 
						 	    0 as RecruitmentTrack,							 					 
						 <cfelse>						
						 					 												  
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
														
								) AS  RecruitmentTrack,  
						  
						   </cfif>				
						
						 <!--- position parent operational unit determines the loan --->  	
						  
						 'Floated' AS Class
						 
				FROM     Position P, 
				         PositionParent PP, 
						 PersonAssignment PA,
						 Organization.dbo.Organization O
						 
				WHERE    P.PositionParentId    = PP.PositionParentId 
				<!--- assignment unit is not the same as position parent --->
				AND      PA.OrgUnit           != PP.OrgUnitOperational
				AND      P.PositionNo          = PA.PositionNo
				<!--- cross mission correction to it will take the budget unit --->
				AND  	 (CASE WHEN P.MissionOperational = P.Mission THEN PA.OrgUnit ELSE PP.OrgUnitOperational END) = O.OrgUnit
								
				AND      PP.Mission            = '#URL.Mission#'
				AND      PP.MandateNo          = '#URL.Mandate#'
				 
				AND      P.DateExpiration     >= #sel#  
				AND      P.DateEffective      <= #selend#  
				
				AND      PA.DateExpiration    >= #sel#  
				AND      PA.DateEffective     <= #selend#  
				AND      PA.AssignmentStatus  IN ('0','1')
				
				AND      O.HierarchyCode      >= '#HStart#' 
		        AND      O.HierarchyCode      < '#HEnd#'  							
				
				<cfif url.header eq "requisition"> 	 
				
				AND      PP.PostType IN (SELECT PostType FROM   Ref_PostType WHERE  Procurement = 1)	  
				</cfif>
				
				<cfif url.postclass neq "">	  
				AND      P.PostClass = '#URL.PostClass#'	  
				</cfif>	  
																			
				ORDER BY PositionNo 	
				
			</cfquery>		
							
			<!---
			<cfoutput>1. #cfquery.executiontime#</cfoutput>
			--->
											
			<!--- Now prepare base dataset with all relevant fields  --->		
					
			<cfquery name="SearchResultX" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			  SELECT Post.*, 
			         O.OrgUnit          as OrgUnitOwner,
					 O.OrgUnitName      as OrgUnitOwnerName,
			         O.OrgUnitNameShort as OrgUnitOwnerNameShort,
			         G.PostGradeParent, 
					 P.ViewOrder, 
					 V.ShowVacancy,
					 P.Description as ParentDescription, 
					 G.PostOrder, 
			         Occ.OccupationalGroup, 
					 Occ.Description as OccGroupDescription,
					 G.PostGradeBudget,
					 G.PostOrderBudget,		
					 
					 (SELECT count(*)            FROM userQuery.dbo.#SESSION.acc#Position#FileNo# WHERE PositionNo = Post.PositionNo) as Occurence,				 		
					 (SELECT LocationName        FROM Location WHERE LocationCode = Post.LocationCode) as LocationName, 
					 (SELECT ListingOrder        FROM Location WHERE LocationCode = Post.LocationCode) as LocationOrder, 
					 (SELECT TOP 1 RequisitionNo FROM PositionParentFunding WHERE PositionParentId = Post.PositionParentId) as Funding 
					
			  INTO   userQuery.dbo.#SESSION.acc#Post#FileNo#
			  
			  FROM   userQuery.dbo.#SESSION.acc#Position#FileNo# Post, 
			         Applicant.dbo.Occgroup Occ, 
			         Applicant.dbo.FunctionTitle F, 
					 PositionParent PP,
					 Organization.dbo.Organization O,
					 Ref_PostGrade G,  
					 Ref_PostGradeParent P,
					 Ref_VacancyActionClass V
			  WHERE  Occ.OccupationalGroup = F.OccupationalGroup 		   
			    AND  G.PostGrade           = Post.PostGrade
				AND  P.Code                = G.PostGradeParent		
				AND  Post.PositionParentId = PP.PositionParentId
				AND  PP.OrgunitOperational = O.OrgUnit	
			    AND  F.FunctionNo          = Post.FunctionNo 
				AND  Post.VacancyActionClass  = V.Code 
						
				<cfif URL.Act eq "1" and URL.ID eq "Locate">			
				
					 AND Post.PositionNo IN (SELECT PositionNo FROM userQuery.dbo.#SESSION.acc#Staffing WHERE PositionNo = Post.PositionNo) 
					 
				<cfelse>
						
					<cfif URL.ID eq "PGP">
			    		AND Post.PositionNo IN (SELECT PositionNo FROM PositionGroup WHERE #PreserveSingleQuotes(cond)#) 
					<cfelse>
						<cfif URL.ID neq "ORG">
					    #PreserveSingleQuotes(cond)#  
						</cfif>
					</cfif>
				
				</cfif>
							
					<cfif URL.ID4 neq "">
					
					  AND Post.MissionOperational = '#URL.ID4#'
					  AND Post.MandateNo = '#URL.Mandate#'
					  AND Post.Mission   = '#URL.Mission#' 
					  
					<cfelse>
					 
					  AND Post.DateExpiration >= #sel#  
					  AND Post.DateEffective  <= #selend# 
					  
					  <cfif getAdministrator(url.mission) eq "0">
					  AND Post.PostType IN (SELECT ClassParameter 
								            FROM    Organization.dbo.OrganizationAuthorization 
								            WHERE   UserAccount    = '#SESSION.acc#' 
								            AND     Mission        = '#URL.Mission#'
										    AND     ClassParameter = Post.PostType) 
					  </cfif>	
					  
			     </cfif>				 	
					  
			</cfquery>
			
			
			
			<!---
			<cfoutput>2.#cfquery.executiontime#</cfoutput>
			--->
						
	</cfif>
		
		<!--- remove positions that are on-demans and have no incumbecny today --->
		
		<cfquery name="DeleteOnDemand" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 DELETE userQuery.dbo.#SESSION.acc#Post#FileNo#
		 FROM   userQuery.dbo.#SESSION.acc#Post#FileNo# P
		 WHERE  ShowVacancy = '0'
		 AND    PositionNo NOT IN
		 
		   (SELECT PositionNo
				    FROM   PersonAssignment 
					WHERE  PositionNo = P.PositionNo
					AND    AssignmentStatus IN ('0','1')
					AND    Incumbency > 0
					AND    DateEffective <= #selend# 
					AND    DateExpiration >= #sel#) 
		</cfquery> 
		
					
		<!--- create assignment table for quicker listinng query later --->
	
		<cfquery name="Assignment" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		    SELECT <!--- DISTINCT --->
			 
			       A.DateEffective       as DateEffectiveAssignment, 
			       A.DateExpiration      as DateExpirationAssignment, 
				   A.FunctionDescription as FunctionDescriptionActual,
				   A.AssignmentStatus,
				   A.Incumbency,
			       P.LastName, 
				   P.FirstName, 
				   P.PersonNo, 
				   P.Reference,
				   P.Nationality, 
				   P.Gender,
				   P.IndexNo, 
				   (SELECT OrgUnitName 
				    FROM Organization.dbo.Organization
					WHERE OrgUnit = A.OrgUnit) as AssignmentOrgUnitName,			  
				   A.OrgUnit as AssignmentOrgUnit, 
				   A.PositionNo, 
				   A.AssignmentNo,
				  				   
				    (SELECT   TOP 1 Contractlevel 
				     FROM     PersonContract C 
					 WHERE    C.PersonNo = P.PersonNo 
					 AND      C.ActionStatus != '9' 
					 AND      C.DateEffective < #incumdate#
					 ORDER BY Created DESC) as ContractLevel,
					
					(SELECT   TOP 1 ContractStep 
				     FROM     PersonContract C 
					 WHERE    C.PersonNo = P.PersonNo 
					 AND      C.ActionStatus != '9' 
					 AND      C.DateEffective < #incumdate# 
					 ORDER BY Created DESC) as ContractStep,	
					 
					  (SELECT  TOP 1 ContractTime 
				    FROM    PersonContract C 
					WHERE   C.PersonNo = P.PersonNo 					
					AND     C.ActionStatus != '9' 
					ORDER BY Created DESC) as ContractTime,
					
				    (SELECT TOP 1 PostAdjustmentLevel
				     FROM    PersonContractAdjustment SPA 
					 WHERE   SPA.PersonNo = P.PersonNo 
					 AND     SPA.ActionStatus != '9' 
					 <!--- pending --->
					 AND  SPA.DateEffective < #incumdate# 
					 AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
					 ORDER BY Created DESC) as PostAdjustmentLevel,
					
			        (SELECT TOP 1 PostAdjustmentStep
				     FROM   PersonContractAdjustment SPA 
					 WHERE  SPA.PersonNo = P.PersonNo 
					 AND    SPA.ActionStatus != '9' 
					<!--- pending --->
					 AND  SPA.DateEffective < #incumdate# 
					 AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
					 ORDER BY Created DESC) as PostAdjustmentStep,			
				   
				   A.AssignmentClass,	
				   
					   (SELECT ActionStatus 
					    FROM  PersonExtension 
						WHERE PersonNo  = A.PersonNo 
						AND   MandateNo = '#URL.Mandate#'
						AND   Mission   = '#URL.Mission#') as Extension	
					
			INTO   userQuery.dbo.#SESSION.acc#Assignment#FileNo#	   
			
		    FROM   PersonAssignment A INNER JOIN Person P ON A.PersonNo    = P.PersonNo
				   
			WHERE  A.PositionNo IN (SELECT PositionNo 
			                        FROM   userQuery.dbo.#SESSION.acc#Post#FileNo# 
									WHERE  PositionNo = A.PositionNo)
								
			AND    A.AssignmentStatus IN ('0','1')
			
			<cfif URL.Lay eq "Listing">		
			    AND  A.DateEffective  <= #incumdate#
				AND  A.DateExpiration >= #incumdate#
			</cfif>	
			
			ORDER BY A.DateExpiration DESC 
		</cfquery>
		
		<!---	
		<cfoutput>3. #cfquery.executiontime#</cfoutput>
		--->			
	
</cftransaction>	

				
<cfif URL.ID eq "Locate" and URL.Act eq "0">

		<cfif URL.Vacant eq "1">
		
			<cfquery name="Clean" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM userQuery.dbo.#SESSION.acc#Post#FileNo#
			WHERE  PositionNo IN (SELECT PositionNo FROM #SESSION.acc#Assignment#FileNo#)
			</cfquery>	
			
		<cfelseif URL.Vacant eq "0">
			
			<cfquery name="Clean" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM userQuery.dbo.#SESSION.acc#Post#FileNo#
			WHERE  PositionNo NOT IN (SELECT PositionNo FROM #SESSION.acc#Assignment#FileNo#)
			</cfquery>	
		
		</cfif>
	
</cfif>
			
<!--- reset condition for count query --->
<cfset cond = ReplaceNoCase("#cond#", "Post.", "P.", "ALL")> 
<cfset cond = ReplaceNoCase("#cond#", "F.", "P.", "ALL")> 

<cfif URL.Sort eq "OrgUnit">

  <cfinclude template="MandateViewOrganizationCount.cfm"> 
 
  <cfquery name="Check" 
  datasource="AppsQuery"   
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT SUM(Post) as Post, 
	         SUM(Staff) as Staff, 
			 COUNT(*) as Count, 
			 COUNT(OrgUnit) as OrgUnit
	  FROM   #SESSION.acc#PositionSum#FileNo# P
  </cfquery>
   
   <cfset counted = check.post>
	
<cfelse>

	<cfquery name="SearchResult" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT count(*) as Number
		FROM   userQuery.dbo.#SESSION.acc#Post#FileNo#
	</cfquery>

	<cfset counted = SearchResult.number>
   
</cfif>  

<cfswitch expression="#URL.ID#">

   <cfcase value="ORG">
	   <cfif URL.ID1 neq "">
	    <cfset cond = "AND Org.OrgUnitCode = '#URL.ID1#'">
	   <cfelse>
	     <cfset cond = "">
	   </cfif>	 
   </cfcase>

   <cfcase value="GRP"><cfset cond = "AND PostGradeParent = '#URL.ID1#'"></cfcase>
   <cfcase value="GRD"><cfset cond = "AND Post.PostGrade = '#URL.ID1#'"></cfcase>
   <cfcase value="LOC"><cfset cond = "AND Post.LocationCode = '#URL.ID1#'"></cfcase>
   <cfcase value="PTP"><cfset cond = "AND Post.Posttype = '#URL.ID1#'"></cfcase>
   <cfcase value="OCG"><cfset cond = "AND Post.OccupationalGroup = '#URL.ID1#'"></cfcase>
   <cfcase value="FUN"><cfset cond = "AND Post.FunctionNo = '#URL.ID1#'"></cfcase>
   
</cfswitch>  

<cf_tl id="Export Excel"  var="vExcel">
<cf_tl id="Add Unit"      var="vAddUnit">
<cf_tl id="Add Position"  var="vAddPosition">
<cf_tl id="Print" 		  var="vPrint">
<cf_tl id="Refresh"		  var="vRefresh">
 
<cfsavecontent Variable = "StaffListing">
		
	<cfoutput>
		<input type="hidden" name="mission" id="mission" value="#URL.Mission#">
		<input type="hidden" name="id"  id="id"          value="#URL.ID#">
		<input type="hidden" name="id1" id="id1"         value="#URL.ID1#">
		<input type="hidden" name="PDF" id="PDF"         value="#URL.PDF#">
	</cfoutput>
	
	<!--- use to pass the new position no for a box to be presented --->
	<input type="hidden" name="reloadpos" id="reloadpos" value="">
	
	<table height="100%" style="width:100%;padding-left:3px">
		
		  <!--- ---- facility for moving/removing--- --->	 
		  
		  <tr class="hide"><td id="process"></td></tr>	 
		  <tr class="hide"><td id="processbatchaction"></td></tr>	
		  
		  <cfif URL.ID neq "Locate" and url.header eq "Yes">
		  		  	 
			 <tr class="line">
			   
			    <td style="padding-left:7px;height:49;font-size:22px" class="labelmedium clsNoPrint"> 
				 
				    <cfif URL.ID eq "BOR">
						<font size="2"><cf_tl id="Borrowed from">:</font> <cfoutput>#URL.Mission#</b></cfoutput>&nbsp;
					</cfif>
					
			    	<cfoutput>
			    		<font size="2"><cf_tl id="Staffing period">:</font> #Mandate.Description#</b></font> #DateFormat(Mandate.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow)# <b><font size="2">[<cf_tl id="Status">:<cfif Mandate.MandateStatus eq "1"><font color="green"><cf_tl id="Locked"><cfelse><font size="2" color="red"><cf_tl id="Draft"></cfif></font>]</b>
					</cfoutput>
				   		
				</td>
				
				<td align="right" style="padding-right:8px" class="labellarge">
				
				<table><tr><td class="labelit"><cf_tl id="Selection date">:</td>
				<td class="labellarge" style="padding-left:7px;height:49;font-size:25px;padding-right:4px">
				
				<cfoutput>
					#dateformat(sel,client.dateformatshow)#				
					<input type="hidden" name="selectiondate" id="selectiondate" value="#dateformat(sel,client.dateformatshow)#">
				</cfoutput>
				
				</td></tr></table>
											
				</td>	
						
			  </tr>
			  		  
		  </cfif>
	  
	  	  <!--- navigation line --->
		  
		  <cfif counted eq "">
			    <cfset counted = "0">
		  </cfif>	
		   <!--- drop down to select only a number of record per page using a tag in tools --->	
		  <cf_PageCountN count="#counted#">
		  		  		 	  		  
		  <cfparam name="URL.PDF" default="0">
			 					 			   
			  <tr style="height:40px" class="line">
			   
			  <td colspan="2" style="padding-left:7px;padding-right:7px">
			  
			  <table width="100%" class="clsNoPrint">
			    
			  <tr>
			  <td style="padding:1px">
			  
			  <cfoutput>  
			  
			  	 <cfif url.id eq "Org">
			  
					    <cfinvoke component = "Service.Access"  
							    method          = "staffing" 
							    mission         = "#URL.Mission#"
								orgunit        = "#OrgUnit.OrgUnit#" 
							    returnvariable  = "accessStaffing"> 
								
					    <cfinvoke component = "Service.Access"  
							    method          = "position" 
							    mission         = "#URL.Mission#"
								orgunit        = "#OrgUnit.OrgUnit#" 
							    returnvariable  = "accessPosition"> 	
							
				 <cfelse>
				
						<cfinvoke component = "Service.Access"  
							    method          = "staffing" 
							    mission         = "#URL.Mission#"							
							    returnvariable  = "accessStaffing"> 
								
					  	<cfinvoke component = "Service.Access"  
							    method          = "position" 
							    mission         = "#URL.Mission#"							
							    returnvariable  = "accessPosition"> 	
								
				  </cfif>					  		  			
				  
				  <cfif URL.PDF eq 0 and URL.header neq "requisition">		
				  
				    <table class="formspacing">  
															
					  <tr>
				  
				  	  <cfif accessPosition eq "ALL" or accessPosition eq "EDIT"> 				  
				  	  	<td>
						  	<input type="button" class="button10g" style="height:25;font-size:13px;width:140px" name="Export" id="Export" value="#vExcel#" onClick="staffingexcel()">
					  	</td>					  	
					  </cfif>
					  
					  <!---
								  
					  <cfif URL.ID eq "ORG" AND OrgAccess eq "ALL">
						<td>
						   <input type="button" value="#vAddUnit#" class="button10g" style="height:25;font-size:13px;width:140px" onClick="addOrgUnit('#URL.Mission#',mandate.value,'#URL.ID1#')">
						</td> 
					  </cfif>	
					  
					  --->
											  					   
					  <cfif accessPosition eq "ALL" or accessPosition eq "EDIT"> 							    
						 <td>
					 	    <input type="button" value="#vAddPosition#" class="button10g" style="height:25;font-size:13px;width:140px" onClick="AddPosition('#URL.Mission#',mandate.value,unit.value,'','','','#URL.ID1#','','','')">
						 </td>						 
					  </cfif>			  			  
					  
					  <td><input type="button" id="refresh" name="refresh" value="#vRefresh#" class="button10g" style="height:25;font-size:13px;width:140px" 
					  onClick="_cf_loadingtexthtml='';Prosis.busy('yes');reloadForm(1,sort.value,mandate.value,layout.value,'1',0,'#url.header#')">
					  </td>					  
					  
					  </tr>
					</table>	
				   
				  </cfif>				  
			    
			  </cfoutput>
			   
			  </td>
			    
			  <td align="right" style="padding:2px">
			    
			  <cfif URL.PDF eq 0 and URL.header neq "requisition">		
			  	
				   <cfoutput>
				   
				   <select name="sort" id="sort" size="1" class="regularxl" onChange="_cf_loadingtexthtml='';Prosis.busy('yes');reloadForm(page.value,this.value,mandate.value,layout.value,'1',0,'#url.header#')">
					<cfif URL.ID neq "ORG">
					     <option value="PostOrder"    <cfif URL.Sort eq "PostOrder">selected</cfif>><cf_tl id="by Post grade">
					     <option value="PostClass"    <cfif URL.Sort eq "PostClass">selected</cfif>><cf_tl id="by Post class">
						 <option value="Posttype"     <cfif URL.Sort eq "Posttype">selected</cfif>><cf_tl id="by Posttype">
						 <option value="LocationCode" <cfif URL.Sort eq "LocationCode">selected</cfif>><cf_tl id="by Location">
					</cfif>
					<cfif URL.ID neq "BOR" and URL.ID neq "ORA" and URL.ID neq "ORF">
					     <option value="OrgUnit" <cfif URL.Sort eq "OrgUnit">selected</cfif>><cf_tl id="by Unit">
					</cfif>
					<cfif URL.ID neq "ORG">
						 <option value="DateExpiration" <cfif URL.Sort eq "DateExpiration">selected</cfif>><cf_tl id="by Expiration date">
					
					</cfif>
					
				   </select>					
				
				   <select name="layout" id="layout" size="1" class="regularxl"
					onChange="_cf_loadingtexthtml='';Prosis.busy('yes');reloadForm(page.value,sort.value,mandate.value,this.value,'1',0,'#url.header#','#url.selectiondate#')">
					 <!---
					 <cfif URL.ID eq "ORG" and URL.Header eq "Yes">
					    <OPTION value="Maintain" <cfif URL.Lay eq "Maintain">selected</cfif>><cf_tl id="Maintenance">
					 </cfif>
					 --->
				     <OPTION value="Listing"  <cfif URL.Lay eq "Listing">selected</cfif>><cf_tl id="Listing">:<cf_tl id="Basic">
					 <option value="Advanced" <cfif URL.Lay eq "Advanced">selected</cfif>><cf_tl id="Listing">:<cf_tl id="Extended">
										    
				  </select>
				  
				  </cfoutput>
				  
			   <cfelse>
			   
			   
			   	<input type="hidden" name="layout" id="layout" value="#url.lay#">
				<input type="hidden" name="sort" id="sort" value="#url.sort#">	  
				  
			   </cfif>		    
			     
			  </td>
			  
			  <!--- navigation --->
			  
			  <td align="right" style="padding:2px">
					 	  
					<input type="hidden" name="mandate" id="mandate" value="<cfoutput>#URL.Mandate#</cfoutput>">
					
					<cfif counted eq "">
						<cfset counted = "0">
					</cfif>	
				      <!--- drop down to select only a number of record per page using a tag in tools --->	

				 	<cf_PageCountN count="#counted#">

					<cfif URL.PDF eq 0>
					      <select name="page" 
						   id="page" 
						   size="1" 
						   class="regularxl" 
					       onChange="reloadForm(this.value,document.getElementById('sort').value,document.getElementById('mandate').value,document.getElementById('layout').value,'1',0,'<cfoutput>#url.header#</cfoutput>')">
						       <cfif url.showAllRecords neq 1>
						       		<option value="0"> - <cf_tl id="Show all"> -
						       <cfelse>
						       		<option value="-1"> - <cf_tl id="Paging"> -
						       </cfif>
						       
						      <cfloop index="Item" from="1" to="#pages#" step="1">
						        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
						      </cfloop>	 
					      </SELECT>
					</cfif>
					  	
				 </TD>

				 <td style="width:40px;" align="center">							 
					  		
					<span class="clsPrintTitle" style="display:none;">
						<cfoutput>
			    		<font size="2" color="808080"><cf_tl id="Staffing period">:</font> #Mandate.Description#</b> <font size="2" color="808080"><cf_tl id="Status">:</font> #DateFormat(Mandate.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow)# <b><font size="2">[<cfif Mandate.MandateStatus eq "1"><font color="green"><cf_tl id="Locked"><cfelse><font size="2" color="red"><cf_tl id="Draft"></cfif></font>]</b>
						</cfoutput>
					</span>
					
				  	<cf_tl id="Print" var="1">
					<cf_button2 
						mode		= "icon"
						type		= "Print"
						title       = "#lt_text#" 
						id          = "Print"					
						height		= "35px"
						width		= "35px"
						imageHeight = "25px"
						printTitle	= ".clsPrintTitle"
						printContent= ".clsPrintContent"
						printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
							
				  </td>  
				   
				</tr>
				</table>
		  
		  	  </td>
		  
	   </tr>
	     	  	 		   		  	    
	  <tr>
	  
	  <td valign="top" colspan="2" style="min-width:1000px;height:100%;padding-left:7px;padding-right:7px;padding-bottom:4px" class="clsPrintContent">
	  
	  	<cf_divscroll overflowy="scroll">
	        
		<table style="width:97%" align="left" class="navigation_table">
						
			<cfif URL.Sort eq "OrgUnit">
			  
			   <cfif URL.ID eq "Org">
			      <input type="hidden" name="unit" id="unit" value="<cfoutput>#OrgUnit.OrgUnit#</cfoutput>">
			   <cfelse>
			      <input type="hidden" name="unit" id="unit" value="">
			    </cfif>			
								
				<cfinclude template="MandateViewOrganization.cfm">
					        
			<cfelse>
			
				<cftransaction isolation="READ_UNCOMMITTED">
					    
					<cfquery name="PostShow" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT   DISTINCT Org.OrgUnit, 
						         Org.OrgUnitName, 
								 Org.OrgUnitCode, 
								 Org.HierarchyCode, 
								 Post.*,  
							     A.FunctionDescription as ParentFunctionDescription,
						         A.OrgUnitOperational as ParentOrgUnit, 
								 Ass.*,
								 R.PresentationColor,
								 
								 (  SELECT count(*) 
									FROM   Employee.dbo.PositionGroup
									WHERE  PositionNo = Post.PositionNo 
									AND    Status != '9') as PositionGroup							 
								 
						FROM     Employee.dbo.Ref_PostClass R INNER JOIN
					             userQuery.dbo.#SESSION.acc#Post#FileNo# Post ON R.PostClass = Post.PostClass INNER JOIN
					             Employee.dbo.PositionParent A ON Post.PositionParentId = A.PositionParentId INNER JOIN
					             Organization Org ON Post.OrgUnitOperational = Org.OrgUnit LEFT OUTER JOIN
					             userQuery.dbo.#SESSION.acc#Assignment#FileNo# Ass ON Post.PositionNo = Ass.PositionNo			
						   	 
					 	WHERE    Org.HierarchyCode >= '#HStart#' 
				        AND      Org.HierarchyCode < '#HEnd#'		 
						ORDER BY #orderby#, Post.ViewOrder, <cfif URL.Sort neq "PostOrder">Post.PostOrder,</cfif> Post.PositionNo
					
					</cfquery>
				
				</cftransaction>
					
				<cfquery name="PostType" dbtype="query">
						SELECT DISTINCT PostType FROM PostShow		 
				</cfquery>
				
				<cfloop query="PostType">
					
					<cfinvoke component = "Service.Access"  
					    method          = "staffing" 
					    mission         = "#URL.Mission#" 
					    posttype        = "#PostType#"
					    returnvariable  = "accessStaffing#PostType#"> 
						
					<cfinvoke component = "Service.Access"  
					    method          = "position" 
					    mission         = "#URL.Mission#" 
					    posttype        = "#PostType#"
					    returnvariable  = "accessPosition#PostType#"> 	
					
				</cfloop>				
				
				<input type="hidden" name="unit" id="unit" value="<cfoutput>#PostShow.OrgUnit#</cfoutput>">
				
				<cfquery name="total" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    #URL.Sort#, 
					          COUNT(DISTINCT PositionNo) as Total
					FROM      userQuery.dbo.#SESSION.acc#Post#FileNo# Post 
					GROUP BY  #URL.Sort# 
				</cfquery>
								   
				<cfoutput query="PostShow" group="#URL.Sort#">
				
				   <cfif (currrow gte first and currrow lte last) or currrow eq "0">
				          
				   <tr bgcolor="EEF3E2" class="line">
				
				   <cfswitch expression = "#URL.Sort#">
	
				     <cfcase value = "SourcePostNumber"></cfcase>
					 <cfcase value = "PostClass">
					 
					 <cfquery name="subtotal" 
						dbtype="Query">
							SELECT *
							FROM   Total
							WHERE  PostClass = '#PostClass#'
					 </cfquery>
					 
				     <td colspan="7" style="padding-left:3px" class="labellarge">#PostClass# (#Subtotal.total#)</td>
					 				 
				   </tr>
									  
				     </cfcase>
					 
					  <cfcase value = "LocationCode">
					  
					     <tr>
						 
						    <cfquery name="subtotal" 
							dbtype="Query">
								SELECT *
								FROM   Total
								WHERE LocationCode = '#LocationCode#'
							</cfquery>
					 
					     <td style="padding-left:3px" class="labellarge"><cfif LocationName eq "">Undefined<cfelse>#LocationName#</cfif> (#Subtotal.total#)</td>
						 
						</tr>
						 			 
					 </cfcase>
					 
					 <cfcase value = "PostOrder">
					 
					 	<tr>
					 
						    <cfquery name="subtotal" 
								dbtype="Query">
									SELECT  *
									FROM    Total
									WHERE   PostOrder = #PostOrder#
								</cfquery>			
								
						     <td style="padding-left:3px" class="labellarge">#PostGrade# (#Subtotal.total#)</td>
						  					
						 </tr>
									 
					 </cfcase>
					 
					 <cfcase value = "Posttype">
					 
					 	<tr>
						
						    <cfquery name="subtotal" 
							dbtype="Query">
								SELECT *
								FROM   Total
								WHERE  PostType = '#PostType#'
							</cfquery>
					 
					        <td style="padding-left:3px" class="labellarge">#Posttype# (#Subtotal.total#)</td>
						 				
						 </tr>
									 
				     </cfcase>
					 
					 <cfcase value = "DateExpiration">
				    
						 <td style="padding-left:3px" class="labellarge">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</td>
						
						    <cfquery name="subtotal" dbtype="Query">
								SELECT *
								FROM   Total
								WHERE DateExpiration = '#DateFormat(DateExpiration, CLIENT.DateSQL)#'
							</cfquery>
						 
						 <td align="right" style="padding-right:4px">(#Subtotal.total#)</td>
						 </tr>
						
				     </cfcase>
					 
				   </cfswitch>
				   
				   </cfif>
					      
				   	  <cfset pte = "">
				     
					  <cfoutput group="ViewOrder">
					  
					 		<cfif PostType neq "#pte#">
						   
						   	   <!--- staffing --->
							   <cfif evaluate("accessStaffing#PostType#") neq "EDIT" and evaluate("accessStaffing#PostType#") neq "ALL">
							   		   			  			  		
									<cfinvoke component="Service.Access"  
							          method         = "staffing" 
									  orgunit        = "#PostShow.OrgUnit#" 
									  posttype       = "#PostType#"
									  returnvariable = "accessStaffing"> 					  
														  
								<cfelse>
								
									<cfset accessStaffing = evaluate("accessStaffing#PostType#")>  
								  
								</cfif>  
								
								<!--- recruit --->
								<cfif accessStaffing eq "NONE" or accessStaffing eq "READ">
								  
									  <cfinvoke component="Service.Access"  
								          method         = "recruit" 
										  orgunit        = "#Postshow.OrgUnit#" 
										  posttype       = "#PostType#"
										  returnvariable = "accessRecruit"> 						  
									 
								<cfelse>
								  
								  	<cfset accessRecruit = "EDIT">
								  
								</cfif>
								
								<!--- position --->
								<cfif evaluate("accessPosition#PostType#") neq "EDIT" and evaluate("accessPosition#PostType#") neq "ALL">  
												  
									<cfinvoke component="Service.Access"  
							          method         = "position" 
									  orgunit        = "#PostShow.OrgUnit#" 
									  role           = "'HRPosition'"
									  posttype       = "#PostType#"
									  returnvariable = "accessPosition"> 
															  
								 <cfelse> 
								 
								    <cfset accessPosition = evaluate("accessPosition#PostType#")>
								 
								</cfif> 
								  							  										  				  
								<cfset pte = "#PostType#">
							  
							</cfif>					  
									  
					  <cfoutput group="PositionNo">
					  					  					  					  					  				
						<cfset currrow = currrow + 1>
						
						<cfif currrow gte first and currrow lte last>
						
							<cfif URL.Lay eq "Advanced">
								
							  <cfif currrow gte first and currrow lte last>
							   <tr class="navigation_row">
								 <td colspan="10"><cfinclude template="MandateViewOrganizationPosition.cfm"></td>
							   </tr>	 																								
								
							   <cfoutput group="AssignmentNo"> <!--- loop of assignments --->
								<tr class="navigation_row">
									<td></td>
								    <td colspan="9"><cfinclude template="MandateViewOrganizationAssignment.cfm"></td>
								</tr>								
							   </cfoutput>										
									
							  </cfif>
									
							<cfelse>	
												
						        <cfif currrow gte first and currrow lte last>
								 <tr class="navigation_row">
								     <td></td>
								     <td colspan="9"><cfinclude template="MandateViewOrganizationAssignmentView.cfm"></td>
								 </tr>	  
						        </cfif>									
								
							</cfif>
									 	
					     <cfelseif currrow gt last>
						 
							 <tr><td colspan="10">
							   <cfinclude template="Navigation.cfm">
							 </td></tr>
							 													 
							 <cfinclude template="MandateViewExit.cfm">
							 
								<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Position#FileNo#">	
								<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Post#FileNo#"> 
								<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Assignment#FileNo#">
								<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionSum#FileNo#">
								<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Vacancy#FileNo#">
							 
							 <cfabort> 
							 
						 </cfif> 	
								 								 
					  </cfoutput>
					 				  
				 </cfoutput>
					  
				 </cfoutput>				
					
			</cfif>	
			
		</TABLE>		
		
		</cf_divscroll>	
		
		</td></tr>					
					
	</table>
		
</cfsavecontent>

<!--- Restore client.PageRecords--->
<cfif URL.PDF eq 1 OR URL.ShowAllRecords eq "1">	
	<cfset Client.PageRecords = OldPageRecords>
	<cfset Client.PageRecords = Client.OldPageRecords>
</cfif>

<cfinclude template="MandateViewExit.cfm">

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Position#FileNo#">	
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Post#FileNo#"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Assignment#FileNo#">

<cfoutput>

<cfform style="height:100%" action="../PositionBatch.cfm?Mission=<cfoutput>#URL.ID2#</cfoutput>&mandate=<cfoutput>#URL.ID3#</cfoutput>" method="post" name="result" id="result">
	
<cfif URL.PDF eq 0>
	<!--- outputting the view on screen --->	
	#StaffListing#	
	
<cfelse>
	
	<cfoutput>	
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/print.css" media="print">
	</cfoutput>
		
	#StaffListing# 
	
	<script>window.print()</script>
		
</cfif>	

</cfform>

</cfoutput>

<cfparam name="url.lay" default="">

<cfif url.lay neq "listing">
	<cfset AjaxOnLoad("doHighlight")>	
</cfif>	

<script>
	Prosis.busy('no')
</script>
