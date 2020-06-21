
<!--- 
   Name : /Component/Employee/Vactrack.cfc
   Description : Execution procedures
   
   1.1.  Define balance lines
   1.2	Calculate the line    
      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Vacancy Action">
	
	<cffunction name="VerifyAccess"
       access="public"
       returntype="any"
       displayname="Verify access to generate">
			 
			 <cfargument name="PositionNo"            type="string"  required="false"  default="">
			 <cfargument name="Mission"               type="string"  required="true"   default="">
			 <cfargument name="Mandate"               type="string"  required="true"   default="">
			 <cfargument name="OrgUnitAdministrative" type="string"  required="true"   default="0">
			 <cfargument name="PostType"              type="string"  required="true"   default="">
			 
			 <cfset result.status = "1">
			 <cfset result.reason = "pass">
			 
			 <cfif PositionNo neq "">
														 
				<cfquery name="Position" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT O.*,
					       P.OrgUnitAdministrative,
						   P.PostType,
						   P.SourcePostNumber,
						   P.PostGrade,
						   P.Positionno,
						   P.FunctionNo,
						   P.FunctionDescription
				    FROM   Position P, 
					       Organization.dbo.Organization O
					WHERE  P.PositionNo         = '#PositionNo#' 
					AND    P.OrgUnitOperational = O.OrgUnit 
				</cfquery>
				
				<cfset orgunitadministrative = Position.OrgUnitAdministrative>
				<cfset mission = Position.Mission>
				<cfset mandate = Position.MandateNo>
				
				<!--- check if the mandate is a current mandate --->
				
				<cfquery name="Mandate" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_Mandate
					WHERE Mission   = '#Position.Mission#' 
					AND   MandateNo = '#Position.MandateNo#'	
				</cfquery>
								
				<cfif Mandate.DateExpiration gte now() or Mandate.MandateDefault eq "1">
								
				<cfelse>
				
					<cfset result.status = "0">
					<cfset result.reason = "Problem, you may not initiate a track for an already closed mandate [#Mandate.MandateNo#].">
									
				</cfif>
			 
			 <cfelse>
			 
			 	<cfquery name="Mandate" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_Mandate
					WHERE Mission   = '#Mission#' 
					AND   MandateNo = '#Mandate#'	
				</cfquery>
				
				<cfif Mandate.DateExpiration gte now() or Mandate.MandateDefault eq "1">
				
				<cfelse>
				
					<cfset result.status = "0">
					<cfset result.reason = "Problem, you may not initiate a track for an already closed mandate [#Mandate.MandateNo#].">
								
				</cfif>		 
			 
			 </cfif>
			 			 							 
			 <cfquery name="getMission" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT DISTINCT M.Mission, M.MissionOwner
				  FROM   Ref_Mission M, Ref_MissionModule R
				  WHERE  M.Mission      = R.Mission
				  AND    R.SystemModule = 'Vacancy'
				  AND    M.Mission = '#mission#'
				  AND    M.Mission IN (SELECT Mission 
				                       FROM   Ref_Mandate 
									   WHERE  DateExpiration > getDate()) 
								
				  <cfif getAdministrator(Mission) eq "0">		  		
				  AND (
				      M.Mission IN   (SELECT   DISTINCT A.Mission
								  	  FROM     OrganizationAuthorization A INNER JOIN
									           Ref_EntityAction R ON A.ClassParameter = R.ActionCode
									  WHERE    A.UserAccount = '#SESSION.acc#' 
									  AND      R.EntityCode = 'VacDocument'
									  AND      R.ActionType = 'Create')  
					  OR 
					  M.Mission IN   (SELECT  DISTINCT Mission 
					                  FROM    OrganizationAuthorization
									  WHERE   UserAccount = '#SESSION.acc#' 
									  AND     Role        = 'VacOfficer')
					   )					               				
				  </cfif>	
				  
				 		
			  </cfquery>
				
			  <cfif getMission.recordcount eq "0">
				
					<cfset result.status = "0">
					<cfset result.reason = "Problem, you are <b>NOT</b> authorised to register recruitment tracks for #mission#">

					<cfset owner = "">
				
			  <cfelseif OrgUnitAdministrative neq "0">
				
					<cfquery name="Admin" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Organization.dbo.Organization Org
						WHERE  OrgUnit = '#OrgUnitAdministrative#' 
					</cfquery>
				
					<cfif Admin.recordcount eq "1">
					
						<cfquery name="Own" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT     R.Mission, 
						           R.MissionOwner as Owner
						FROM       Organization O INNER JOIN
						           Ref_Mission R ON O.Mission = R.Mission
						WHERE      O.OrgUnit = '#OrgUnitAdministrative#'
						</cfquery>
						
						<cfif Own.Owner neq "">
						     <cfset owner = Own.Owner>
							 <cfset miss  = Own.Mission>
						<cfelse>
						     <cfset owner = getMission.MissionOwner>
							 <cfset miss  = getMission.Mission>
						</cfif>
						
					<cfelse>
					
						<cfquery name="Mis" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_Mission
							WHERE  Mission = '#Mission#'
						</cfquery>
					
						<cfset owner = Mis.MissionOwner>	
						<cfset miss  = Mis.Mission>
					
					</cfif>
					
				<cfelse>
				
					<cfset owner = getMission.MissionOwner>	
					<cfset miss  = getMission.Mission>	
					
				</cfif>	
				
				<cfset result.owner = owner>
				
				<cfif result.status eq "1">
				
					<cfquery name="getMissionClass"
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT EntityClass 
					    FROM   Ref_EntityClassMission 
					    WHERE  EntityCode = 'VacDocument' 
					    AND    Mission    = '#Miss#'						
					</cfquery>	
				
					<!--- define the classes to be selected --->
					
					<cfquery name="ClassList"
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   R.*
						FROM     Ref_EntityClass R
						WHERE    R.Operational = '1'
						AND      R.EntityCode = 'VacDocument'	
						AND      R.EmbeddedFlow = 0
						
						
						<cfif session.acc eq "Administrator">
						
						<cfelse>
						AND      R.EntityClass IN (SELECT EntityClass 
						                           FROM   Ref_EntityClassPublish
												   WHERE  EntityCode       = 'VacDocument'
												   AND    EntityClass      = R.EntityClass)						
						
						AND     
						         (
								 
						         R.EntityClass IN (SELECT EntityClass 
						                           FROM   Ref_EntityClassOwner 
												   WHERE  EntityCode       = 'VacDocument'
												   AND    EntityClass      = R.EntityClass
												   AND    EntityClassOwner = '#owner#')
												   
								 OR
								
								  R.EntityClass NOT IN (SELECT EntityClass 
						                                FROM   Ref_EntityClassOwner 
												        WHERE  EntityCode       = 'VacDocument'
												        AND    EntityClass      = R.EntityClass)
												   
								 )				   							   				   
						
						AND     (R.EntityParameter is NULL 
						           or R.EntityParameter = '' 
								   or R.EntityParameter = '#PostType#')		
						
						</cfif>		   
								   
						
						<cfif getMissionClass.recordcount gte "1">
						
						AND     R.EntityClass IN (SELECT EntityClass 
						                          FROM   Ref_EntityClassMission 
										          WHERE  EntityCode = 'VacDocument' 
										          AND    Mission = '#Miss#')
						</cfif>			
							   
						ORDER BY R.ListingOrder	 
						
					</cfquery>
				
					<cfif classList.recordcount eq "0">
										
						<cfset result.status = "0">
						<cfset result.reason = "Problem, no recruitment workflows were published for this track owner: #owner#">
						
					<cfelse>
										
						<cfset result.tracks = classlist>	
										 
					</cfif>
					
				</cfif>					
			 
			<cfreturn result>		 
			 
	</cffunction>
	
</cfcomponent>	

