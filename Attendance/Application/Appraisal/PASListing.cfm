
<cf_screentop html="No" jquery="Yes">

<cf_dialogStaffing>

<cf_listingscript>

<cfquery name="Period" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT   * 
		 FROM     Ref_ContractPeriod 
		 WHERE    Code  = '#url.Period#' 		 
</cfquery>

<cfsavecontent variable="myquery">
	
		<cfoutput>
		
		    SELECT *
			FROM (
			SELECT     C.PersonNo,
			           E.LastName+','+E.FirstName as Name,	
					   E.FirstName,
					   E.LastName,				  
					   E.Gender,
					   E.IndexNo,
					   E.eMailAddress,
					   E.Nationality,
					   C.ContractClass,
					   C.FunctionNo,
					   C.FunctionDescription,
			      								 
					   C.OrgUnit              as ContractOrgUnit,
					   
				      (SELECT OrgUnitCode
					    FROM  Organization.dbo.Organization
						WHERE OrgUnit = C.OrgUnit) as ContractOrgUnitCode,
						
					  C.OrgUnitName as ContractOrgUnitName,	
						
					  (SELECT P.OrgUnitCode
					    FROM  Organization.dbo.Organization O INNER JOIN 
						      Organization.dbo.Organization P ON O.Mission = P.Mission AND O.Mandateno = P.MandateNo and O.HierarchyRootUnit = P.OrgUnitCode
						WHERE O.OrgUnit = C.OrgUnit	  
						) as ParentOrgUnitCode,
						
					 (SELECT P.OrgUnitName
					    FROM  Organization.dbo.Organization O INNER JOIN 
						      Organization.dbo.Organization P ON O.Mission = P.Mission AND O.Mandateno = P.MandateNo and O.HierarchyRootUnit = P.OrgUnitCode
						WHERE O.OrgUnit = C.OrgUnit	  
						) as ParentOrgUnitName,											
					   
					   E.PostGradeParent,					   					  
					   E.OrgUnit              as AssignmentOrgUnit,
					   (SELECT OrgUnitCode
					    FROM  Organization.dbo.Organization
						WHERE OrgUnit = E.OrgUnit) as AssignmentOrgUnitCode,
					  
					   E.OrgUnitName          as AssignmentOrgUnitName,
					   E.OrgUnitHierarchyCode as AssignmentOrgUnitHierarchy,
					   
					   C.ActionStatus,					  		
                  						  
					   <cfloop index="itm" list="midterm,final">	   
						  
	                       (SELECT COUNT(*)
	                        FROM   ContractEvaluation
	                        WHERE  ContractId = C.ContractId 
						    AND    C.ActionStatus = '2' 
						    AND    EvaluationType = '#itm#') AS #itm#,
							
						</cfloop>
					  C.DateEffective,
					  C.DateExpiration,	
					  FirstOfficerPersonNo,		
					  FirstOfficerIndexNo,	
					  FirstOfficerName,	
					  SecondOfficerPersonNo,		
					  SecondOfficerIndexNo,	
					  SecondOfficerName,	
                     
					 C.ContractId
					
              FROM   Contract AS C INNER JOIN (
		   
		                 <!--- take the LAST entry of incumbecny for this person 
						 in the validity period of the PAS for staff which is onboard  --->
		   
					      SELECT A.*
					      FROM      
						  (  SELECT    PersonNo, MAX(AssignmentNo) AS AssignmentNo
                             FROM      Employee.dbo.vwAssignment
                             WHERE     Mission        = '#url.mission#' 
							 AND       AssignmentStatus IN ('0','1') 
							 AND       AssignmentType = 'Actual' 
							 AND       Incumbency     > 0 
							 <!--- only assignments valid for the ePas period itself. --->
							 AND       DateEffective  <= '#Period.PasPeriodEnd#' 
							 AND       DateExpiration >= '#Period.PasPeriodStart#' 							     
                             GROUP BY  PersonNo) AS D INNER JOIN
                         Employee.dbo.vwAssignment AS A ON A.PersonNo = D.PersonNo AND A.AssignmentNo = D.AssignmentNo) as E					   				    
					  
		             ON C.PersonNo = E.PersonNo 
					 
					 LEFT OUTER JOIN 
					 
						 (SELECT   CA.ContractId, P.PersonNo AS FirstOfficerPersonNo, P.IndexNo AS FirstOfficerIndexNo, P.FullName AS FirstOfficerName
						  FROM     ContractActor AS CA INNER JOIN
	                      		   Employee.dbo.Person AS P ON CA.PersonNo = P.PersonNo
						  WHERE    CA.RoleFunction = 'FirstOfficer' 
						  AND      CA.ActionStatus = '1')as F ON C.Contractid = F.ContractId
					  
					 LEFT OUTER JOIN 
					 
						 (SELECT   CA.ContractId, P.PersonNo AS SecondOfficerPersonNo, P.IndexNo AS SecondOfficerIndexNo, P.FullName AS SecondOfficerName
						  FROM     ContractActor AS CA INNER JOIN
	                      		   Employee.dbo.Person AS P ON CA.PersonNo = P.PersonNo
						  WHERE    CA.RoleFunction = 'SecondOfficer' 
						  AND      CA.ActionStatus = '1')as S ON C.Contractid = S.ContractId
										  
           WHERE     C.Operational = 1 
		   AND       C.ActionStatus IN ('0', '1', '2') 
		   
		   AND       C.Mission   = '#url.mission#'  
		   AND       C.Period    = '#url.period#'							
		
			<cfif getAdministrator("#url.mission#") eq "0">
			
			AND  (
			
			      C.OrgUnit IN (
				  SELECT A.OrgUnit
				  FROM   Organization.dbo.OrganizationAuthorization A, 
				         Organization.dbo.Organization O
		   		  WHERE  A.UserAccount = '#SESSION.acc#' 
				  AND    A.Mission     = '#url.Mission#'
				  AND    O.OrgUnit     = A.OrgUnit
				  AND    O.Mission     = '#url.Mission#'		
				  AND    Role IN ('Timekeeper','HROfficer','ContractManager'))
				 				 
				  OR
				 
				  C.Mission IN ( SELECT A.Mission
				  FROM   Organization.dbo.OrganizationAuthorization A
		   		  WHERE  A.UserAccount = '#SESSION.acc#' 
				  AND    A.Mission     = '#url.Mission#'
				  AND    A.OrgUnit is NULL				 
				  AND    Role IN ('Timekeeper','HROfficer','ContractManager') )
				  
				  )
				  
								  
			</cfif>
			
			) as X
			WHERE 1=1
			
			--condition
			
		</cfoutput>
		
</cfsavecontent>	

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>		
<cfset fields[itm] = {label   	   = "IndexNo",                  
					field   	   = "IndexNo",
					functionscript = "pasdialog",
					functionfield  ="contractid",
					search  	   = "text"}>	
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label   = "Name",                  
					field   = "Name",
					filtermode = "0",
					search  = "text"}>			

			
<cfset itm = itm+1>								
<cfset fields[itm] = {label   = "S", 					
                    labelfilter = "Gender",
					field   = "Gender",					
					filtermode = "3",    
					align = "center",
					search  = "text"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Class",  					
					field         = "ContractClass",
					filtermode    = "2",					
					search        = "text"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Unit",  					
                    labelfilter   = "Unit code",
					field         = "ContractOrgUnitCode",	
					filtermode    = "4",								
					search        = "text"}>							
					
		
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Unit name",  					
					field         = "ContractOrgUnitName",
					filtermode    = "2",					
					search        = "text"}>
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "First Officer",                  
					field         = "FirstOfficerName",
					filtermode    = "0",
					search        = "text"}>								
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Submission Status",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=White,1=Yellow,2=Green"}>								
					
<!---											
					
<cfset itm = itm+1>												
<cfset fields[itm] = {label    = "Effective",					
					field      = "DateEffective",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
--->
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label    = "Expiration",  					
					field      = "DateEffective",
					align      = "center",					
					search        = "date",
					formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	
	

						

<table width="100%" height="100%"><tr><td style="padding:8px;width:100%;height:100%">	
	
	<cf_listing
		    header         = "PAS"
		    box            = "PAS"
			link           = "#SESSION.root#/Attendance/Application/Appraisal/PASListing.cfm?filter=#url.filter#&mission=#url.mission#&period=#url.period#&systemfunctionid=#url.systemfunctionid#"
		    html           = "No"
			show           = "40"
			datasource     = "AppsEPAS"
			listquery      = "#myquery#"			
			listorder      = "LastName"
			listorderdir   = "ASC"
			headercolor    = "ffffff"
			listlayout     = "#fields#"
			filterShow     = "Yes"
			excelShow      = "Yes"
			drillmode      = "tab"
			drillargument  = "940;1190;false;false"	
			drilltemplate  = "Staffing/Application/Employee/PersonView.cfm?id="
			drillkey       = "PersonNo">
	
</td></tr></table>		



