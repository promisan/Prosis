
<cfparam name="url.box"  default="1">

<cfif url.box eq "1">

	<!--- global staffing table --->
	
	<cfquery name="Parameter" datasource="AppsEmployee" maxrows=1 username="#SESSION.login#" password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Parameter
	</cfquery>
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assignment">
	
	<cfparam name="url.filterid" default="">
	<cfparam name="url.mode"     default="filter">
	
	<cfif url.mode eq "full">
	
		 <cfset ass = "">
		 <cfset pos = "">
		 
		  <cfquery name="DateSelect" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_Mandate
				WHERE  Mission = '#URL.Mission#'
				AND    MandateNo = '#URL.Mandate#'				
		   </cfquery>	
	
	<cfelse>
	
	    <!--- old mode --->
		
		<cfparam name="client.SelectAssignment" default="">
		<cfparam name="client.SelectPosition"   default="">
		
		<cfset ass = replace(client.SelectAssignment, "-", ",", "ALL")>
		<cfset pos = replace(client.SelectPosition, "-", ",", "ALL")>
			
		<cfif pos eq "">
		    <table align="center"><tr><td height="100"><b>Selected information could not be presented. Try to refresh your view first.</td></tr></table>
			<cf_waitEnd>
			<cfabort>
		</cfif>
		 
	</cfif>
	
	<cfif url.filterid neq "">
	
		<cfinclude template="MandateFilterApply.cfm">
	
	</cfif>
	
	<cfquery name="NationTopic" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_Topic
		WHERE     TopicClass = 'Nation' 
		AND       Operational = 1
	</cfquery>	
	
	<cfquery name="Assignment1" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT A.DateEffective as AssignmentEffective, 
		       A.DateExpiration as AssignmentExpiration, 
			   A.FunctionDescription as FunctionDescriptionActual,
			   P.LastName as NameLast, 
			   P.FirstName as NameFirst, 
			   P.PersonNo, 
			   P.Nationality as NationalityShort,
			   N.Name as Nationality,
			   <cfloop query="nationtopic">
			   
			   (SELECT   TOP (1) TopicValue
			   FROM      System.dbo.Ref_NationTopic
			   WHERE     Code = N.Code 
			   AND       Topic = '#code#'
			   AND       Operational = 1
               ORDER BY  DateEffective DESC) as #TopicLabel#,
			   
			   </cfloop>
			   N.Continent,
			   P.eMailAddress,
			   P.BirthDate,
			   P.Gender,
			   P.IndexNo, 
			   P.OrganizationStart as EOD,
			   A.PositionNo, 
			   A.AssignmentNo, 
			   A.OrgUnit as OrgUnitActual, 
			   Ext.ActionStatus as Extension, 
			   Ext.DateExtension 
			   
		INTO   userQuery.dbo.#SESSION.acc#Assignment 
		
		FROM   PersonAssignment A INNER JOIN
	           Position Po ON A.PositionNo = Po.PositionNo INNER JOIN
	           Person P ON A.PersonNo = P.PersonNo LEFT OUTER JOIN
	           PersonExtension Ext ON A.PersonNo = Ext.PersonNo AND Po.Mission = Ext.Mission AND Po.MandateNo = Ext.MandateNo	 LEFT OUTER JOIN
	           System.dbo.Ref_Nation N ON P.Nationality = N.Code  
	    
		WHERE  1=1	
		
		<cfif ass neq "">
		
		AND    A.AssignmentNo IN (#Ass#) 
		
		<cfelse>
		
		<!---
		AND    Po.Mission   = '#URL.Mission#'
		AND    Po.MandateNo = '#URL.Mandate#'
		--->
		AND    (Po.MissionOperational  = '#URL.Mission#' OR (Po.Mission   = '#URL.Mission#'	AND Po.MandateNo = '#URL.Mandate#'))
		AND    A.AssignmentStatus IN ('0','1')
		
			<cfif URL.mode eq "full">
			
				<cfif DateSelect.dateexpiration lt now()>	
				AND    A.DateEffective  <= '#dateformat(DateSelect.DateExpiration,client.dateSQL)#'
				AND    A.DateExpiration >= '#dateformat(DateSelect.DateExpiration,client.dateSQL)#'
				<cfelseif DateSelect.dateeffective gt now()>
				AND    A.DateEffective  <= '#dateformat(DateSelect.DateEffective,client.dateSQL)#'
				AND    A.DateExpiration >= '#dateformat(DateSelect.DateEffective,client.dateSQL)#'
				<cfelse>
				AND    A.DateEffective  <= '#dateformat(now(),client.dateSQL)#'
				AND    A.DateExpiration >= '#dateformat(now(),client.dateSQL)#'
				</cfif>
			
			<cfelse>
			
				AND    A.DateEffective  <= '#dateformat(now(),client.dateSQL)#'
				AND    A.DateExpiration >= '#dateformat(now(),client.dateSQL)#'
				
			</cfif>
		
		</cfif>
			
	 </cfquery>  
	  
	<cfquery name="CheckVacancy" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_MissionModule
		WHERE  Mission = '#URL.Mission#'
		AND    SystemModule = 'Vacancy'
	</cfquery>
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Vacancy">
	
	<cfif CheckVacancy.recordcount eq "0">
	
			<cfquery name="Vacancy" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   0 AS DocumentNo, 0 AS PositionNo, 
				         1 as Mode
				INTO     userQuery.dbo.#SESSION.acc#Vacancy
				FROM Person
				WHERE PersonNo is NULL
	        </cfquery>
	
	<cfelse>
	  
		<cfquery name="Vacancy" 
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				<!--- current mandate --->
				SELECT   MAX(D.DocumentNo) AS DocumentNo, P.PositionNo AS PositionNo, '1' as Mode
				INTO     userQuery.dbo.#SESSION.acc#Vacancy
				FROM     Document D INNER JOIN
						 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
						 Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
				WHERE    D.Status = '0'
				    <!---
					AND  P.MandateNo = '#URL.Mandate#'
					AND  P.Mission   = '#URL.Mission#'
					---> 
					AND   (P.MissionOperational  = '#URL.Mission#' OR (P.Mission = '#URL.Mission#'	AND P.MandateNo = '#URL.Mandate#'))
					AND  D.EntityClass is not NULL
				GROUP BY P.PositionNo 
				UNION
				<!--- next mandate --->
				SELECT   MAX(D.DocumentNo) AS DocumentNo, P.SourcePositionNo AS PositionNo, '1' AS Mode
				FROM     Document D INNER JOIN
		                 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
		                 Employee.dbo.Position P ON DP.PositionNo = P.SourcePositionNo
				WHERE    D.Status = '0'		
				  <!---
					AND  P.MandateNo = '#URL.Mandate#'
					AND  P.Mission   = '#URL.Mission#'
					---> 
					AND   (P.MissionOperational = '#URL.Mission#' OR (P.Mission = '#URL.Mission#'	AND P.MandateNo = '#URL.Mandate#'))					
					AND  D.EntityClass is not NULL	
				GROUP BY P.SourcePositionNo 							
							  
			</cfquery>
	
	</cfif>
		  
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Position_#url.box#">	
		
		<cfparam name="cat" default="">
		<cfparam name="occ" default="">
		<cfparam name="cls" default="">
		<cfparam name="pte" default="">
		<cfparam name="aut" default="">
			
		<cfquery name="Position" 
	    datasource="AppsEmployee" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT P.PostAuthorised, 
		       P.PositionNo, 
			   P.Remarks, 
			   P.FunctionDescription, 
			   P.PostClass, 
			   P.PostGrade, 
			   PP.Fund,
			   P.SourcePostNumber, 
			   G.PostOrder, 
			   P.PostType,
			   P.DateEffective as PostEffective, 
			   P.DateExpiration as PostExpiration,
			   G.PostOrderBudget, 
			   Par.ViewOrder, 
			   P.OrgUnitOperational, 
			   PP.OrgUnitOperational as OrgUnitOperationalParent, 
			   Org.OrgUnitName, 
			   
		   	   <cfif CheckVacancy.recordcount eq "0">
				   0 as RecruitmentTrack,
				  
			   <cfelse>
				
				  <!--- select track occurence --->
												  
							(
							
							SELECT    count(*) 
							
							FROM
														
									(
									
									SELECT    D.*							
									FROM      Vacancy.dbo.DocumentPost as Track INNER JOIN
				      			              Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
						                      Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
						                      Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo
									WHERE     SP.PositionNo = P.PositionNo 
									AND       D.EntityClass IS NOT NULL 
									AND       D.Status = '0'
																							
									UNION 
																					
									<!--- first position in the next mandate --->			
									
									SELECT     D.* 
									
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
					 			  
			   Org.HierarchyCode, 
			   Org.OrgUnitCode, 
			   PP.DateEffective as ParentEffective, 
			   PP.DateExpiration as ParentExpiration,
			   Loc.LocationName,
			   A.AssignmentEffective, 
			   A.AssignmentExpiration, 
			   A.FunctionDescriptionActual, 
			   A.OrgUnitActual,
		       A.NameLast, 
			   A.NameFirst,
			   A.BirthDate, 
			   A.PersonNo, 
			   A.Nationality, 
			   A.Continent,
			   <cfloop query="nationtopic">
			   A.#TopicLabel#,
			   </cfloop>				
			   A.Gender,  
			   A.IndexNo, 
			   A.eMailAddress,
			   A.EOD,
			   A.AssignmentNo, 
			   A.Extension,
			   
			   <!--- -------------------------- --->
			   <!--- last contract level issued --->
			   <!--- -------------------------- --->
			   
			   (SELECT   TOP 1  R.Description
				FROM     PersonContract PC INNER JOIN Ref_ContractType R ON PC.ContractType = R.ContractType
				WHERE    PC.PersonNo = A.PersonNo 
				AND      PC.ActionStatus != '9' 
				ORDER BY DateEffective DESC) as ContractType,			  
			 			     
			   (SELECT   TOP 1 Contractlevel 
			    FROM     PersonContract C 
				WHERE    C.PersonNo = A.PersonNo 
				AND      C.ActionStatus != '9' 
				ORDER BY DateEffective DESC) as ContractLevel,
				
			   (SELECT   TOP 1 ContractStep 
			    FROM     PersonContract C 
				WHERE    C.PersonNo = A.PersonNo 
				AND      C.ActionStatus != '9' 
				ORDER BY DateEffective DESC) as ContractStep
				
				<!--- rfuentes added on ruys request 13-May-2019 --->
				
				,(
					SELECT TOP 1 PACx.ContactCallSign
					FROM	PersonAddress PAx with (NOLOCK) 
							INNER JOIN PersonAddressContact PACx with (NOLOCK) 
								ON PAx.PersonNo = PACx.PersonNo
								AND	PAx.AddressId = PACx.AddressId
								AND PACx.ContactCode IN ('Extension')
							INNER JOIN System.dbo.Ref_Address ADx with (NOLOCK) 
								ON PACx.AddressId = ADx.AddressId
								AND ADx.AddressScope IN ('Profile','Employee')
					WHERE	PAx.PersonNo = A.PersonNo
					ORDER BY PACx.Created DESC
				) as ContactTelephoneNo
				
				,(
					SELECT TOP 1 AD.AddressRoom 
					FROM 	PersonAddressContact C with (NOLOCK) 
					LEFT OUTER JOIN System.dbo.Ref_Address AD with (NOLOCK) 
						ON 		C.AddressId = AD.AddressId
						AND 	AD.AddressScope IN ('Profile','Employee')
					WHERE 	C.PersonNo	= A.PersonNo
					AND 	C.ContactCode IN ('Office', 'Extension')
				) as AddressRoom
				
				<!-----/rfuentes added on ruys request 13-May-2019 ------>
			   
		INTO  userQuery.dbo.#SESSION.acc#Position_#url.box#	   
		
		FROM  userQuery.dbo.#SESSION.acc#Assignment A RIGHT OUTER JOIN Ref_PostGrade G INNER JOIN
	          Ref_PostGradeParent Par ON G.PostGradeParent = Par.Code INNER JOIN
	          PositionParent PP INNER JOIN
	          Position P ON PP.PositionParentId = P.PositionParentId INNER JOIN
	          Applicant.dbo.FunctionTitle F INNER JOIN
	          Applicant.dbo.OccGroup Occ ON F.OccupationalGroup = Occ.OccupationalGroup ON P.FunctionNo = F.FunctionNo ON 
	          G.PostGrade = P.PostGrade INNER JOIN
	          Organization.dbo.Organization Org ON P.OrgUnitOperational = Org.OrgUnit ON A.PositionNo = P.PositionNo LEFT OUTER JOIN
	          Location Loc ON P.LocationCode = Loc.LocationCode	   
		
		<cfif pos neq "">
		
		WHERE P.PositionNo IN (#pos#)	
		
		<cfelse>
		
		WHERE  (P.MissionOperational  = '#URL.Mission#' OR (P.Mission = '#URL.Mission#' AND P.MandateNo = '#URL.Mandate#'))
		
		<!---		
		WHERE  P.Mission   = '#URL.Mission#'
		AND    P.MandateNo = '#URL.Mandate#'
		--->
		
			<cfif DateSelect.dateexpiration lt now()>	
				AND    P.DateEffective  <= '#dateformat(DateSelect.DateExpiration,client.dateSQL)#'
				AND    P.DateExpiration >= '#dateformat(DateSelect.DateExpiration,client.dateSQL)#'
			<cfelseif DateSelect.dateeffective gt now()>
				AND    P.DateEffective  <= '#dateformat(DateSelect.DateEffective,client.dateSQL)#'
				AND    P.DateExpiration >= '#dateformat(DateSelect.DateEffective,client.dateSQL)#'
			<cfelse>
				AND    P.DateEffective  <= '#dateformat(now(),client.dateSQL)#'
				AND    P.DateExpiration >= '#dateformat(now(),client.dateSQL)#'
			</cfif>
		
		</cfif>
		
		<cfif cat neq "">
		    AND   G.PostGradeParent IN (#PreserveSingleQuotes(cat)#) 
		</cfif>
		<cfif occ neq "">
		    AND   F.OccupationalGroup IN (#PreserveSingleQuotes(occ)#) 
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
	  
		ORDER BY  ViewOrder, PostOrderBudget  
	   </cfquery>     
	   	   
	   <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assignment">
	   <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Vacancy">
		
	   <cfset client.table1   = "#SESSION.acc#Position_#url.box#">	
	   
<cfelse>

	   <!--- we take the table from the memory if it exisits --->
	   
	   <cftry>
	   
	   <cfquery name="check" 
	    datasource="AppsQuery" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">   
		SELECT * FROM #SESSION.acc#Staffing_#url.box#
	   </cfquery>
	   
	   <cfcatch>
	   
	    <table width="100%">
		 
			 <tr><td height="70" align="center" class="labelmedium">
			 	 <i><font color="FF0000">Please make your selection again.</font></i>
				 </td>
			 </tr>
		 
		 </table>
		 
		 <cfabort>
	   
	   </cfcatch>
	   
	   </cftry>

	   <cfset client.table1   = "#SESSION.acc#Staffing_#url.box#">	

</cfif>	   
