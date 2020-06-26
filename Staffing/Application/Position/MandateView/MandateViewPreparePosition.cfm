


	<cfquery name="Parameter" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT TOP 1 * 
	 FROM Parameter    
	</cfquery>
		
	<cfquery name="Position" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   Position 
		 WHERE  PositionNo = '#URL.PositionNo#'  
	</cfquery>	 
	
	<cfquery name="ParamMission" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT TOP 1 * 
		 FROM   Ref_ParameterMission    
		 WHERE  Mission = '#Position.Mission#'
	</cfquery>
	
	<cfquery name="Mandate" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   Ref_Mandate 
		 WHERE  Mission   = '#Position.Mission#'
		 AND    MandateNo = '#Position.MandateNo#'		
	</cfquery>	
		          
	<cfif Mandate.DateExpiration lt now() >
    	<CF_DateConvert Value="#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
	<cfelseif Mandate.DateEffective gt now()>   
    	<CF_DateConvert Value="#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
	<cfelse> 
 		<CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
	</cfif>
	
	<cfset incumdate = dateValue>

	<cfquery name="Assignment" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		    SELECT DISTINCT 
			       A.DateEffective       as DateEffectiveAssignment, 
			       A.DateExpiration      as DateExpirationAssignment, 
				   A.FunctionDescription as FunctionDescriptionActual,
				   A.AssignmentStatus,
				   A.Incumbency,
			       P.LastName, 
				   P.FirstName, 
				   P.Reference,
				   P.PersonNo, 
				   P.Nationality, 
				   P.Gender,
				   P.IndexNo, 
				   
				     <!--- retrieve group --->
		  
					  (SELECT count(*) 
					   FROM   PositionGroup
					   WHERE  PositionNo = Po.PositionNo  AND Status != '9') as PositionGroup,
				   
				   (SELECT TOP 1 Contractlevel 
					    FROM PersonContract C 
						WHERE C.PersonNo = P.PersonNo 
						AND  C.ActionStatus != '9' 
						AND  C.DateEffective < #incumdate#
						ORDER BY Created DESC) as ContractLevel,
					
					(SELECT TOP 1 ContractStep 
					    FROM PersonContract C 
						WHERE C.PersonNo = P.PersonNo 
						AND  C.ActionStatus != '9' 
						AND  C.DateEffective < #incumdate#
						ORDER BY Created DESC) as ContractStep,		
						
					  (SELECT  TOP 1 ContractTime 
					    FROM    PersonContract C 
						WHERE   C.PersonNo = P.PersonNo 				
						AND     C.ActionStatus != '9' 
						AND     C.DateEffective < #incumdate#
						ORDER BY Created DESC) as ContractTime,	
					
				   (SELECT TOP 1 PostAdjustmentLevel
					   FROM PersonContractAdjustment SPA 
						WHERE SPA.PersonNo = P.PersonNo 
						AND  SPA.ActionStatus != '9' 
						<!--- pending --->
						 AND  SPA.DateEffective < #incumdate# 
					     AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
						ORDER BY Created DESC) as PostAdjustmentLevel,
						
				  (SELECT TOP 1 PostAdjustmentStep
					    FROM PersonContractAdjustment SPA 
						WHERE SPA.PersonNo = P.PersonNo 
						AND  SPA.ActionStatus != '9' 
						<!--- pending --->
						 AND  SPA.DateEffective < #incumdate# 
					     AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
						ORDER BY Created DESC) as PostAdjustmentStep,					   
				   
				   O.OrgUnitName, 
				   A.OrgUnit, 
				   A.PositionNo, 
				   A.AssignmentNo,
				   Po.Mission,
				   Po.MissionOperational,
				   Po.MandateNo,
				   Po.FunctionNo,
				   Po.OrgUnitAdministrative,
				   Po.PostType,
				   Po.LocationCode,
				   Po.PositionParentId,
				   Po.PostAuthorised,
				   Po.FunctionDescription, 
				   PP.OrgUnitOperational as ParentOrgUnit,
				   Po.PostGrade, 
				   Po.SourcePostNumber, 
				   Po.PostClass,
				   Po.OrgunitOperational,
						   (SELECT ActionStatus 
						    FROM  PersonExtension 
							WHERE Mission   = '#Position.Mission#'
							AND   MandateNo = '#Position.MandateNo#'
							AND   PersonNo  = A.PersonNo 
							) as Extension,	
				   (SELECT LocationName FROM Location WHERE LocationCode = Po.LocationCode) as LocationName, 						  
				   R.PresentationColor
			FROM   PersonAssignment A, 
			       Person P, 
			       Position Po, 
				   PositionParent PP,
			       Organization.dbo.Organization O,				 
     			   Ref_PostClass R
			WHERE  Po.PositionNo       = A.PositionNo
			AND    A.PersonNo          = P.PersonNo
			AND    Po.PositionNo       = '#URL.PositionNo#'
			AND    Po.PositionParentId = PP.PositionParentId						
			AND    A.OrgUnit           = O.OrgUnit
			AND    R.PostClass         = Po.PostClass
			AND    A.AssignmentStatus < '#Parameter.AssignmentShow#'			
			<cfif URL.Lay neq "Advanced">			
			    AND  A.DateEffective  <= #incumdate#
				AND  A.DateExpiration >= #Incumdate#
			</cfif>				
			ORDER BY A.DateExpiration DESC 
			
		</cfquery>
		
		<cfif Assignment.recordcount eq "0">
		
			<cfquery name="Assignment" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			    SELECT DISTINCT 
				       ''     as DateEffectiveAssignment, 
				       ''     as DateExpirationAssignment, 
					   ''     as FunctionDescriptionActual,
					   ''     as AssignmentStatus,
					   ''     as Incumbency,
				       ''     as LastName, 
					   ''     as FirstName, 
					   ''     as PersonNo, 
					   ''     as Nationality, 
					   ''     as Gender,
					   ''     as IndexNo, 
					   '0'    as PositionGroup,
					   ''     as ContractLevel,					       
					   ''     as ContractStep,
					   ''     as ContractTime,
					   ''     as PostAdjustmentLevel,
					   ''     as PostAdjustmentStep,
					   O.OrgUnitName, 
					   O.OrgUnit, 
					   Po.PositionNo, 
					   '' as AssignmentNo,
					   Po.Mission,
					   Po.MissionOperational,
					   Po.MandateNo,
					   Po.FunctionNo,
					   Po.OrgUnitAdministrative,
					   Po.PostType,
					   Po.LocationCode,
					   Po.PositionParentId,
					   Po.PostAuthorised,
					   Po.FunctionDescription, 
					   PP.OrgUnitOperational as ParentOrgUnit,
					   Po.PostGrade, 
					   Po.SourcePostNumber, 
					   Po.PostClass,
					   Po.OrgunitOperational,
					   '' as Extension,
					   (SELECT LocationName FROM Location WHERE LocationCode = Po.LocationCode) as LocationName,
					   R.PresentationColor
				FROM Position Po, 
					 PositionParent PP,
				     Organization.dbo.Organization O,					
	     			 Ref_PostClass R
				WHERE Po.PositionNo          = '#URL.PositionNo#'
				AND   Po.PositionParentId    = PP.PositionParentId							
				AND   PO.OrgUnitOperational  = O.OrgUnit
				AND   R.PostClass = Po.PostClass				
			</cfquery>	
					
		</cfif>
				
		<cfinvoke component="Service.Access"  
		          method="staffing" 
				  orgunit="#Position.OrgUnitOperational#" 
				  posttype="#Position.PostType#"
				  returnvariable="accessStaffing"> 
				  
		<cfinvoke component="Service.Access"  
		          method="position" 
				  orgunit="#Position.OrgUnitOperational#" 
				  posttype="#Position.PostType#"
				  returnvariable="accessPosition"> 	
				  
		<cfinvoke component="Service.Access"  
				  method         = "recruit" 
				  orgunit        = "#Position.OrgUnitOperational#" 
				  posttype       = "#Position.PostType#"
				  returnvariable = "accessRecruit"> 					 		  
				  
	<cfquery name="Vacancy" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				<!--- current mandate --->
				SELECT   MAX(D.DocumentNo) AS DocumentNo, P.PositionNo AS PositionNo, '1' as Mode
				FROM     Document D INNER JOIN
						 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
						 Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
				WHERE    D.Status = '0'
					AND  P.PositionNo = '#URL.PositionNo#'
					AND  D.EntityClass is not NULL
				GROUP BY P.PositionNo 
				UNION
				
				<!--- next mandate --->
				SELECT   MAX(D.DocumentNo) AS DocumentNo, P.PositionNo, '1' AS Mode
				FROM     Document D INNER JOIN
		                 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
		                 Employee.dbo.Position P ON DP.PositionNo = P.SourcePositionNo
				WHERE    D.Status = '0'		 
					AND  P.PositionNo = '#URL.PositionNo#'
					AND  D.EntityClass is not NULL	
				GROUP BY P.PositionNo 	
												  
		</cfquery>			  	  
		
	<cfset documentno = vacancy.documentNo>	
									  				
	<cfoutput query="Assignment">
	
	    <cfset class = "#URL.class#">		
		<cfinclude template="MandateViewOrganizationAssignmentView.cfm">
	
	</cfoutput>	
	