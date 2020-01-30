

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
	<cfelseif #Mandate.DateEffective# gt now()>   
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
				   A.AssignmentClass,
				   A.Incumbency,
				   R.PresentationColor,
				   
				     <!--- retrieve group --->
		  
					  (SELECT count(*) 
					   FROM   PositionGroup
					   WHERE  PositionNo = Po.PositionNo  AND Status != '9' ) as PositionGroup,									   
				   
			       P.LastName, 
				   P.FirstName, 
				   P.PersonNo, 
				   P.Nationality, 
				   P.Gender,
				   
				     <!--- retrieve contract latest --->
		  
					  (SELECT TOP 1 Contractlevel 
						   FROM PersonContract C 
							WHERE C.PersonNo = P.PersonNo 
							AND  C.ActionStatus != '9' 
							<!--- pending --->
							<!--- AND  C.DateEffective < #incumdate# --->
							ORDER BY C.Created DESC) as ContractLevel,
							
					  (SELECT TOP 1 ContractStep 
						    FROM PersonContract C 
							WHERE C.PersonNo = P.PersonNo 
							AND  C.ActionStatus != '9' 
							<!--- pending --->
							<!--- AND  C.DateEffective < #incumdate# --->
							ORDER BY C.Created DESC) as ContractStep,		
							
					  (SELECT  TOP 1 ContractTime 
						    FROM    PersonContract C 
							WHERE   C.PersonNo = P.PersonNo 							
							AND     C.ActionStatus != '9' 
							ORDER BY Created DESC) as ContractTime,		
							
					  (SELECT TOP 1 PostAdjustmentLevel
						   FROM PersonContractAdjustment SPA 
							WHERE SPA.PersonNo = P.PersonNo 
							AND  SPA.ActionStatus != '9' 
							<!--- pending --->
							<!--- AND  SPA.DateEffective < #incumdate# --->
							ORDER BY SPA.Created DESC) as PostAdjustmentLevel,
							
					  (SELECT TOP 1 PostAdjustmentStep
						    FROM PersonContractAdjustment SPA 
							WHERE SPA.PersonNo = P.PersonNo 
							AND  SPA.ActionStatus != '9' 
							<!--- pending --->
							<!--- AND  SPA.DateEffective < #incumdate# --->
							ORDER BY SPA.Created DESC) as PostAdjustmentStep, 				  
				   
				   
				   P.IndexNo, 
				   P.Reference,
				   O.OrgUnitName, 
				   A.OrgUnit, 
				   A.PositionNo, 
				   A.AssignmentNo,
				   Po.FunctionDescription, 
				   Po.PostGrade, 
				   Po.SourcePostNumber, 
				   Po.PostClass,
				   Po.OrgunitOperational,
				   Ext.ActionStatus as Extension
			FROM   PersonAssignment A INNER JOIN
                   Position Po ON A.PositionNo = Po.PositionNo INNER JOIN
                   Person P ON A.PersonNo = P.PersonNo INNER JOIN
                   Ref_AssignmentClass R ON A.AssignmentClass = R.AssignmentClass INNER JOIN
                   Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit LEFT OUTER JOIN
                   PersonExtension Ext ON A.PersonNo = Ext.PersonNo AND Ext.Mission = '#Position.Mission#' AND Ext.MandateNo = '#Position.MandateNo#'
			WHERE  Po.PositionNo = '#URL.PositionNo#'
			AND    A.AssignmentStatus < '#Parameter.AssignmentShow#'
			<cfif URL.Lay neq "Advanced">
			    AND  A.DateEffective  <= #incumdate#
				AND  A.DateExpiration >= #Incumdate#
			</cfif>				
			ORDER BY A.DateExpiration DESC 
		</cfquery>
		
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
								  		
	
	<cfset url.pdf = "0">
		
	<cfoutput query="Assignment">
			
		<cfinclude template="MandateViewOrganizationAssignment.cfm">
	
	</cfoutput>	
	
		
	