
<!---   Name : /Component/Access.cfc Description : Determine authorization rights
   
   1.0.  [Function] General access to module function to be shown
   1.01  [Function] Return the (highest) access level found for a person accessing a module function 
   
   1.05. [System Function] Generic Role
   1.06. [System Function] Generic Role returns a list   
   1.07. Check access to a subfunction of a module   
   1.1.  [Group] access to manage a user group
   
   1.2.  Organization/Tree management
   1.3.  System Management 
   1.4.  User management
   1.5.  Workflow management
     
   Workflow   
   2.0    Entity access verification
   2.01   Workflow fly access
   
   Human Resource
   3.0    [Employee] PA Officer : Contract Manager 
   3.1.   [Employee] HR Officer : Employee record
   3.1.a. Ownership verification
   3.2.   [Position] Position manager
   3.3.   [Employee] HR Officer : Assignments
   3.4.   Attendance
   3.5.   Recruitment officer : create vactrack
   3.6.   [Recruit] Recruitment officer (step) for a posstype : to be disabled old track
   3.7.   [Recruit] Recruitment officer (tree)
   3.8.   Roster bucket access 
   3.8a.  Roster access
   3.9b   Review access
   3.9.   ePas access 
   3.10   Payroll access
   3.11   Candidate Clear access
   
   Travel Claim
   3.40   TravelClaim
            
   Program Management   
   4.1. Program officer : OrgUnit
   4.2  Program officer : Program/Period
   4.3  Progress Officer : Project only
   4.4  Budget Officer
   4.5. Indicator Officer : Program/Period 
      
   Accounting 
   5.1  General accountant
   
   Material Management
   6.0. Requisitioner or Requisition Role
   6.1. Procurement Accountant        : discontinued
   6.2. Procurement Account mananager : discontinued
   6.3. Procurement Approver
   6.4. Receipt Officer 
   6.5. Facilities (returns a list) that have been granted access
    etc. Role defined/checked by application sofar.....
		
   Asset Management
   7.1. Asset Manager
   7.2. Asset Holder
   7.3. Asset Unit manager
   7.4. Warehouse Stock Officer
   
   Insurance
   8.1. Case File Manager
   
   WorkOrder / Service
   9.1. Service Requester
   9.2  Workorder processor
   9.2b  Workorder processor OrgUnit List
   9.3  Workorder Funder Officer
   9.3b  Workorder Billing Officer
   9.4  Diverse WorkOrder process access : passes a list of workorders     
       
--->   

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "User authorization">	
	
	<!--- 1.0 GENERAL ACCESS TO A MENU FUNCTION --->
	
	<cffunction access="public" name="Function" output="true" returntype="string" displayname="Verify Function Access">
	
		<cfargument name="SystemFunctionId" type="string" required="true">
		
		<!--- if Role is "" retrieve role from function otherwise pass from context --->
		
		<cfargument name="Role"      type="string" default="">
		<cfargument name="OrgUnit"   type="string" default="">
		<cfargument name="Mission"   type="string" default="">
		<cfargument name="Warehouse" type="string" default="">				
		
		<cfif getAdministrator(mission) eq "1">
				
			<CFSET AccessRight = "GRANTED">	
							
		<cfelseif not IsValid("GUID", SystemFunctionId)>
					
			<CFSET AccessRight = "DENIED">
												
		<cfelse>
				
			<cfset deny = "No">
			
			<cfif warehouse neq "">
			
				<cftransaction isolation="read_uncommitted">
				<cfquery name="Whs" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Warehouse
					  WHERE  Warehouse = '#warehouse#'	 
				</cfquery>
				</cftransaction>
				
				<cftransaction isolation="read_uncommitted">
				<cfquery name="Org" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
				      SELECT OrgUnit as OrgUnitId
				      FROM   Organization
					  WHERE  MissionOrgUnitId = '#Whs.MissionOrgUnitId#'	
				</cfquery>
				</cftransaction>
				
				<cfset unit = "0">
													
				<cfloop query="Org">								    				
					<cfset unit = "#unit#,'#orgunitid#'">															
				</cfloop>
				
				<cfset OrgUnit = unit>
					
			</cfif>
						
			<cfif mission neq "">
			
			   <cftransaction isolation="read_uncommitted">	
			   
			   <cfquery name="checkenabled" datasource="AppsSystem" 
	             username="#SESSION.login#" password="#SESSION.dbpw#">
			     SELECT   *
			     FROM     Ref_ModuleControlDeny  
			     WHERE    SystemFunctionId = '#SystemFunctionId#' 
			     AND      Mission = '#mission#' 
	           </cfquery>
			   
	           </cftransaction>
			   
			   <cfif checkenabled.recordcount eq "1">
			   
			       <cfset deny = "Yes">
			   
			   </cfif>
					
			</cfif>		
					
			<cfif deny eq "Yes">		
					
				 <CFSET AccessRight = "DENIED">
					
			<cfelse>
			
			 <cftransaction isolation="read_uncommitted">
				 <cfquery name="Module" datasource="AppsSystem" 
		           username="#SESSION.login#" password="#SESSION.dbpw#">
				   SELECT   *
				   FROM     Ref_ModuleControl  
				   WHERE    SystemFunctionId = '#SystemFunctionId#' 
		          </cfquery>
							
				 <cfquery name="FunctionRole" datasource="AppsSystem" 
		           username="#SESSION.login#" password="#SESSION.dbpw#">
				   SELECT   DISTINCT SystemFunctionId 
				   FROM     Ref_ModuleControlRole  
				   WHERE    SystemFunctionId = '#SystemFunctionId#' 
				   AND      Operational = 1
		          </cfquery>
				
				  <cfquery name="FunctionGroup" datasource="AppsSystem" 
		           username="#SESSION.login#" password="#SESSION.dbpw#">
				   SELECT   DISTINCT SystemFunctionId
				   FROM     Ref_ModuleControlUserGroup  
				   WHERE    SystemFunctionId = '#SystemFunctionId#' 
				   AND      Operational = 1 
		          </cfquery>
				  
	          </cftransaction>
			  			  
				<cfif SESSION.isAdministrator eq "Yes" or Module.EnableAnonymous eq "1">
					
		            <CFSET AccessRight = "GRANTED">  
					
				<cfelseif getAdministrator("*") eq "1" and (Module.FunctionClass eq "Maintain" or Module.FunctionClass eq "System")>
				
					<!--- local administrator access to maintenance --->				
					<CFSET AccessRight = "GRANTED">	
				 				
				<cfelseif Role eq "" and 
				        FunctionRole.recordcount eq "0" and FunctionGroup.recordcount eq "0">		
				
					<cfif Module.EnableAnonymous eq "1">
				          <CFSET AccessRight = "GRANTED">
					<cfelse>
					      <CFSET AccessRight = "DENIED">
					</cfif>	  
				
		        <cfelse>								
				
				  <cftransaction isolation="read_uncommitted">
				  
				  <cfquery name="FunctionRoleMission" datasource="AppsSystem" 
	        		   username="#SESSION.login#" password="#SESSION.dbpw#">
					   SELECT   DISTINCT SystemFunctionId 
					   FROM     Ref_ModuleControlRoleMission
					   WHERE    SystemFunctionId = '#SystemFunctionId#' 
		          </cfquery>	
				  
				  <cf_verifyOperational 
        			 datasource= "appsSystem"
			         module    = "Program" 
					 Warning   = "No">
					 
				  <cfset ProgramOperational = operational>
				  
				  <cf_verifyOperational 
        			 datasource= "appsSystem"
			         module    = "Roster" 
					 Warning   = "No">	 
					 
				  <cfset RosterOperational = operational>	 
				 					 		
				  <cfquery name="qAccess" datasource="AppsSystem" 
		           username="#SESSION.login#" password="#SESSION.dbpw#">
				   
				   <cfif Role eq "">
				  			   						
					   SELECT   TOP 1 R.SystemFunctionId 
			   		   FROM     Organization.dbo.OrganizationAuthorization A INNER JOIN
			                    Ref_ModuleControlRoleLevel R ON 
								A.Role             = R.Role AND 
								A.AccessLevel      = R.AccessLevel
					   WHERE    A.UserAccount      = '#SESSION.acc#'
						 AND    R.SystemFunctionId = '#SystemFunctionId#'
						 <cfif FunctionRoleMission.recordcount gte "1" and mission neq "">
						 AND    R.SystemFunctionid IN (SELECT SystemfunctionId
						                               FROM   Ref_ModuleControlRoleMission
													   WHERE  SystemFunctionId = R.SystemFunctionId
													   AND    Role             = R.Role 
													   AND    Mission          = '#mission#')
						 
						 </cfif>
						 
						<cfif ProgramOperational eq "1"> 
						 
							UNION
							
							SELECT   TOP 1 R.SystemFunctionId
				   		    FROM     Program.dbo.ProgramAccessAuthorization A INNER JOIN
				                     Ref_ModuleControlRoleLevel R ON 
									 A.Role             = R.Role AND 
									 A.AccessLevel      = R.AccessLevel
						    WHERE    R.SystemFunctionId = '#SystemFunctionId#' 
							AND      A.UserAccount      = '#SESSION.acc#'    
							<cfif FunctionRoleMission.recordcount gte "1" and mission neq "">
							AND      R.SystemFunctionid IN (SELECT SystemfunctionId
							                               FROM   Ref_ModuleControlRoleMission
														   WHERE  SystemFunctionId = R.SystemFunctionId
														   AND    Role             = R.Role 
														   AND    Mission          = '#mission#')							 
							</cfif> 
						
						</cfif>
						
						<cfif RosterOperational eq "1"> 
						 
							UNION
							
							SELECT   TOP 1 R.SystemFunctionId
				   		    FROM     Applicant.dbo.RosterAccessAuthorization A INNER JOIN
				                     Ref_ModuleControlRoleLevel R ON 
									 A.Role             = R.Role AND 
									 A.AccessLevel      = R.AccessLevel
						    WHERE    R.SystemFunctionId = '#SystemFunctionId#' 
							AND      A.UserAccount      = '#SESSION.acc#'    
							<cfif FunctionRoleMission.recordcount gte "1" and mission neq "">
							AND      R.SystemFunctionid IN (SELECT SystemfunctionId
							                               FROM   Ref_ModuleControlRoleMission
														   WHERE  SystemFunctionId = R.SystemFunctionId
														   AND    Role             = R.Role 
														   AND    Mission          = '#mission#')							 
							</cfif> 
						
						</cfif>
						 
						UNION
						
						SELECT  TOP 1 M.SystemFunctionId
						FROM    Organization.dbo.OrganizationObjectActionAccess OA INNER JOIN
				                Organization.dbo.OrganizationObject O ON OA.ObjectId = O.ObjectId INNER JOIN
		        		        Organization.dbo.Ref_Entity R ON O.EntityCode = R.EntityCode INNER JOIN
		                		Ref_ModuleControlRoleLevel M ON OA.AccessLevel = M.AccessLevel AND R.Role = M.Role
						WHERE   OA.UserAccount = '#SESSION.acc#' 
						<!--- 10/10/2010 by hanno based on monica having too much access --->
						AND     M.SystemFunctionId = '#SystemFunctionId#'					 				 
					 
				   <cfelse>		  			   
				  
					   SELECT   DISTINCT A.ClassParameter as SystemFunctionId
			   		   FROM     Organization.dbo.OrganizationAuthorization A 
					   WHERE    A.UserAccount      = '#SESSION.acc#'
						 AND    A.ClassParameter   = '#SystemFunctionId#'
						 AND    A.Role             = #preservesinglequotes(role)#
						 <cfif orgunit neq "">
						 AND    (
						             A.OrgUnit IN (#preservesinglequotes(orgunit)#) 
						             OR 
								    (A.Mission = '#Mission#' AND A.OrgUnit is NULL)
								)
						 </cfif>						 
				   
				   </cfif>	 
					 
				   UNION
				   SELECT DISTINCT G.SystemFunctionId 
				   FROM     Ref_ModuleControlUserGroup G INNER JOIN
				            UserNamesGroup U ON G.Account = U.AccountGroup
				   WHERE    U.account           = '#SESSION.acc#'								
				   AND      G.SystemFunctionId  = '#SystemFunctionId#'
				   UNION
				   SELECT DISTINCT SystemFunctionId 
				   FROM     Ref_ModuleControlUserGroup
				   WHERE    Account           = '#SESSION.acc#'								
				   AND      SystemFunctionId  = '#SystemFunctionId#' 
				  			  			   
				  </cfquery>
				  		  
				  </cftransaction>
				  				 			   
		          <cfif qAccess.RecordCount eq "0">
				  
				  	 <CFSET AccessRight = "DENIED">					 
									  
		          <cfelse>
				  
		              <CFSET AccessRight = "GRANTED">
					  
			      </cfif>	  
				  		 
				</cfif>
			
			</cfif>
		
		</cfif>		
			
		<cfreturn AccessRight>
		 
	</cffunction>	
	
	<!--- 1.01 Get level of any roles that quality for a systemfunctionid to be accessed --->
	
	<cffunction access="public" name="systemfunctionidaccess" output="true" returntype="string" displayname="Verify Function Access">
	
		<cfargument name="SystemFunctionId" type="string" required="true" default="">
		<cfargument name="Mission"         type="string" required="false" default="">
		<cfargument name="OrgUnit"         type="string" required="false" default="">
		<cfargument name="ClassParameter"  type="string" required="false" default="">
		
		<cfif getAdministrator("*") eq "1">	
		
			 <CFSET AccessLevel = "2">			
		
		<cfelse>
		
			<cfquery name="getaccess" datasource="AppsOrganization">
				SELECT    MAX(AccessLevel) as Accesslevel
				FROM      Organization.dbo.OrganizationAuthorization
				WHERE     UserAccount = '#session.acc#'
				<cfif mission neq "">
				AND       Mission = '#mission#'
				</cfif>
				<cfif orgunit neq "">
				AND       OrgUnit is NULL or OrgUnit = '#orgunit#'
				</cfif>
				<cfif classparameter neq "">
				AND       ClassParameter = '#ClassParameter#'
				</cfif>
				AND      (
				          Role IN (SELECT Role
		                           FROM   System.dbo.Ref_ModuleControlRole
        		                   WHERE  SystemFunctionId = '#SystemFunctionId#')
						  OR
						  
						  UserAccount IN (SELECT    UG.Account
										  FROM      System.dbo.Ref_ModuleControlUserGroup MG INNER JOIN
								                    System.dbo.UserNamesGroup UG ON MG.Account = UG.AccountGroup		   
										  WHERE   	SystemFunctionId = '#SystemFunctionId#')
										  
						 )				  		
						 		   
			</CFQUERY>
						
						
			<cfset accesslevel = getaccess.accesslevel>					   
		
		
		</cfif>
		
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
				 
	</cffunction>	
	
	<!--- 1.05 Access to level of a roles --->
	
	<cffunction access="public" 
	            name="RoleAccess" 
				output="true" 
				returntype="string"  
				displayname="Verify Access for Role">
				
		<cfargument name="Role"              type="string" required="false" default="">
		<cfargument name="datasource"        type="string" required="false" default="AppsOrganization">
		<cfargument name="defaultDSAuth"   	 type="string" required="false" default="0">
		<cfargument name="SystemFunction"    type="string" required="false" default="">
		<cfargument name="Mission"           type="string" required="false" default="">
		<cfargument name="MissionOrgUnitId"  type="string" required="false" default="">
		<cfargument name="AnyUnit"           type="string" required="false" default="Yes">
		<cfargument name="Unit"              type="string" required="false" default="">		
		<cfargument name="Parameter"         type="string" required="false" default="">
		<cfargument name="AccessLevel"       type="string" required="false" default="">		

		<cfset vUserName = "">
		<cfset vPwd = "">
		<cfif defaultDSAuth eq "0">
			<cfset vUserName = SESSION.login>
			<cfset vPwd = SESSION.dbpw>
		</cfif>		
		
		<!--- just to check if this person has activity otherwise 
		   no maybe just directly accessing : NEW --->
		
		<cfinvoke component = "Service.Process.System.UserController"  
		   method           = "ValidateCFCAccess" 
		   sessionId        = "#session.sessionid#" 
		   datasource       = "#datasource#"
		   defaultDSAuth    = "#defaultDSAuth#"
		   account          = "#session.acc#">	
		
		<cftransaction isolation="read_uncommitted">
			
			<cfif mission eq "" and MissionOrgUnitId neq "">
				
				<!--- kherrera(20180521): do not add user and password to the cfquery as this function is used on the mantinsa app --->
				<cfquery name="getMission" datasource="#datasource#" username="#vUserName#" password="#vPwd#">
					SELECT  *
					FROM    Organization.dbo.Organization
					WHERE   MissionOrgUnitId = '#MissionOrgUnitId#'
				</cfquery>
				
				<cfset mission = getMission.Mission>
					
			</cfif>		
			
			<!--- kherrera(20180521): do not add user and password to the cfquery as this function is used on the mantinsa app --->					
			<cfquery name="qAccess" datasource="#datasource#" username="#vUserName#" password="#vPwd#">
				SELECT  *
				FROM    Organization.dbo.OrganizationAuthorization
				WHERE   UserAccount = '#SESSION.acc#'
				<cfif Role neq "">
				AND     Role IN (#preservesingleQuotes(Role)#)
				<cfelseif SystemFunction neq "">
				AND     Role IN (SELECT Role FROM Organization.dbo.Ref_AuthorizationRole WHERE SystemFunction = '#SystemFunction#')
				</cfif>
						
				<cfif mission neq "">
				AND     Mission = '#Mission#' 
				</cfif>
				
				<cfif mission neq "" and unit neq "">						
				AND     (OrgUnit = (#preservesingleQuotes(Unit)#) OR OrgUnit is NULL) 
				<cfelseif missionorgunitid neq "">
				<!--- corrected 7/11 to allow for NULL also to apply for global access --->
				AND     (
				        OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#mission#' AND MissionOrgUnitId = '#MissionOrgUnitId#') 
						  OR 
						OrgUnit is NULL
						) 
				<cfelseif anyUnit eq "No">
				<!--- if unit is "" ensure this is global access --->
				AND     OrgUnit is NULL
				</cfif>
				
				<cfif parameter neq "">
				AND     ClassParameter = '#Parameter#'
				</cfif>
				<cfif accessLevel neq "">
				AND     AccessLevel IN (#preservesingleQuotes(AccessLevel)#)
				</cfif>							
				
			</cfquery>				
		
		</cftransaction>
		
		<cfif getAdministrator(mission) eq "1">	
			
 	         <CFSET AccessRight = "GRANTED">  
		 				
		<cfelseif qAccess.recordcount gte '1'>

		     <CFSET AccessRight = "GRANTED">
		
		<cfelse>

		    <CFSET AccessRight = "DENIED">
			
		</cfif>	  
					
		<cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 1.06 Access to level of a roles returns a query  --->
	
	<cffunction name="RoleAccessList"
             access="public"
             returntype="query"
             displayname="Return a list"
             output="yes">
				
		<cfargument name="Role"              type="string" required="false" default="">
		<cfargument name="SystemFunction"          type="string" required="false" default="">
		<cfargument name="Mission"           type="string" required="false" default="">
		<cfargument name="MissionOrgUnitId"  type="string" required="false" default="">
		<cfargument name="AnyUnit"           type="string" required="false" default="Yes">
		<cfargument name="Unit"              type="string" required="false" default="">		
		<cfargument name="Parameter"         type="string" required="false" default="">
		<cfargument name="AccessLevel"       type="string" required="false" default="">		
		
		<cftransaction isolation="read_uncommitted">		
		<cfif mission eq "" and MissionOrgUnitId neq "">
		
			<cfquery name="getMission" datasource="AppsOrganization" 
	           username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT  *
				FROM   Organization
				WHERE  MissionOrgUnitId = '#MissionOrgUnitId#'
			</cfquery>
		
			
			<cfset mission = getMission.Mission>
				
		</cfif>
		
						
		<cfquery name="qAccess" datasource="AppsOrganization" 
           username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT  *
			FROM    OrganizationAuthorization
			WHERE   UserAccount = '#SESSION.acc#'
			
			<cfif Role neq "">
			AND     Role IN (#preservesingleQuotes(Role)#)
			<cfelse>
			AND     Role IN (SELECT Role FROM Ref_AuthorizationRole WHERE SystemFunction = '#SystemFunction#')
			</cfif>
			
			<cfif mission neq "">
			AND     Mission = '#Mission#' 
			</cfif>
			
			<cfif mission neq "" and unit neq "">			
			AND     (OrgUnit = (#preservesingleQuotes(OrgUnit)#) OR OrgUnit is NULL)			
			<cfelseif missionorgunitid neq "">
			<!--- corrected 7/11 to allow for NULL also to apply for global access --->
			AND     (
			        OrgUnit IN (SELECT OrgUnit FROM Organization WHERE Mission = '#mission#' AND MissionOrgUnitId = '#MissionOrgUnitId#') 
					  OR 
					OrgUnit is NULL
					) 
			<cfelseif anyUnit eq "No">
			<!--- if unit is "" ensure this is global access --->
			AND     OrgUnit is NULL
			</cfif>
			
			<cfif parameter neq "">
			AND     ClassParameter = '#Parameter#'
			</cfif>
			
			<cfif accessLevel neq "">
			AND     AccessLevel IN (#preservesingleQuotes(AccessLevel)#)
			</cfif>		
						
		</cfquery>	
		</cftransaction>
								
		<cfreturn qAccess>
		 
	</cffunction>
	
	<!--- 1.07 Access to subfunction --->
	
	<cffunction access="public" 
	            name="SelectionShow" 
				output="true" 
				returntype="string"  
				displayname="Verify Access for a subfunction">
				
		<cfargument name="Module"         type="string" required="true">
		<cfargument name="FunctionClass"  type="string" required="true">
		
		<cfparam name="client.lanprefix" default="">
		
		<cfif SESSION.isAdministrator eq "Yes">

 	         <CFSET AccessRight = "SHOW">  
			 
		<cfelse>	 
		
			<cfif FunctionClass eq "Reports">
			
				<CFSET AccessRight = "HIDE">  
			 	
			 	<cftransaction isolation="read_uncommitted">
			 		<cfquery name="SearchResult" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   Owner,ControlId 
						FROM     Ref_ReportControl
						WHERE    SystemModule  = '#module#'
						AND      FunctionClass != 'System'
						AND      LanguageCode  = '#Client.LanguageId#'
						AND      Operational   = '1'	
						
						AND      (
							        (TemplateSQL != 'Application') 
									OR
								    (TemplateSQL = 'Application'
										AND ControlId IN (SELECT ControlId 
										                  FROM Ref_ReportControlOutput 
														  WHERE OutputClass = 'Table')
									)
								  ) 
						
						
					</cfquery>
				</cftransaction>
					
					<cfloop query="Searchresult">
					
						<cfif AccessRight eq "HIDE">
												
								<cfinvoke component="Service.AccessReport"  
						          method="report"  
								  ControlId="#ControlId#" 
								  Owner="#Owner#"
								  returnvariable="access">		
								  
								<cfif access eq "GRANTED">
								
									<cfset AccessRight = "SHOW">
																	
								</cfif>		
								
						</cfif>		
													
					</cfloop>
			
			<cfelse>
			
				<cftransaction isolation="read_uncommitted">
				<cfquery name="qAccess" datasource="AppsOrganization" 
		           username="#SESSION.login#" password="#SESSION.dbpw#">	
				  
					SELECT    I.SystemFunctionId
					FROM      System.dbo.Ref_ModuleControl I INNER JOIN
		        	            System.dbo.Ref_ModuleControlRole R ON I.SystemFunctionId = R.SystemFunctionId INNER JOIN
		            	        OrganizationAuthorization A ON R.Role = A.Role INNER JOIN
		                	    System.dbo.Ref_SystemModule M ON I.SystemModule = M.SystemModule
					WHERE   A.UserAccount   = '#SESSION.acc#'
					AND     M.Operational   = 1
					AND     I.Operational   = '1'
					AND     I.SystemModule  = '#Module#'
					AND     I.FunctionClass IN (#preservesinglequotes(FunctionClass)#)
					AND     M.MenuOrder     != '0' 
					--AND     M.MenuTemplate is not NULL 						
					
					<!--- fly granted access like for claims for death access --->
					
					UNION
					
					SELECT    I.SystemFunctionId
					FROM      System.dbo.Ref_ModuleControl I INNER JOIN
			                     System.dbo.Ref_ModuleControlRole R ON I.SystemFunctionId = R.SystemFunctionId INNER JOIN
			                     System.dbo.#client.LanPrefix#Ref_SystemModule M ON I.SystemModule = M.SystemModule
					WHERE   R.Role IN (
					
								SELECT DISTINCT R.Role
								FROM   OrganizationObjectActionAccess AS OA INNER JOIN
						               OrganizationObject AS O ON OA.ObjectId = O.ObjectId INNER JOIN
						               Ref_Entity AS R ON O.EntityCode = R.EntityCode
								WHERE  OA.UserAccount = '#SESSION.acc#'	
							)
				
					AND     M.Operational = 1
					AND     I.Operational = '1'
					AND     I.SystemModule  = '#Module#'			
					AND     M.MenuOrder != '0' 
					--AND     M.MenuTemplate is not NULL 	
										
														
					UNION
			
					SELECT  I.SystemFunctionId
					FROM    System.dbo.Ref_ModuleControl I INNER JOIN
				                  System.dbo.Ref_SystemModule M ON I.SystemModule = M.SystemModule
					WHERE   M.Operational   = 1
					AND     M.MenuOrder    != '0' 
					AND     I.EnableAnonymous = 1 and FunctionClass != 'Application'			
					AND     I.Operational   = '1'	
					AND     I.SystemModule  = '#Module#'
					AND     I.FunctionClass IN (#preservesinglequotes(FunctionClass)#)
					--AND     M.MenuTemplate is not NULL 
					
					UNION
							
					SELECT  S.SystemFunctionId
					FROM    System.dbo.Ref_ModuleControlUserGroup C INNER JOIN
				                  System.dbo.UserNamesGroup U ON C.Account = U.AccountGroup INNER JOIN
				                  System.dbo.Ref_ModuleControl S ON C.SystemFunctionId = S.SystemFunctionId INNER JOIN
				                  System.dbo.Ref_SystemModule M ON S.SystemModule = M.SystemModule
					WHERE   U.Account = '#SESSION.acc#'
					AND     M.Operational = 1
					AND     S.Operational = 1
					AND     S.SystemModule  = '#Module#'
					AND     S.FunctionClass IN (#preservesinglequotes(FunctionClass)#)
					AND     M.MenuOrder != '0' 
					--AND     M.MenuTemplate is not NULL 				
					
				</cfquery>
				</cftransaction>	
												 				
				<cfif qAccess.recordcount gte '1'>			
				     <CFSET AccessRight = "SHOW">		
				<cfelse>		
				    <CFSET AccessRight = "HIDE">			
				</cfif>	  
				
			</cfif>	
			
		</cfif>	
					
		<cfreturn AccessRight>
		
	</cffunction>	
				
	<!--- 1.1 UserGroup --->
	
	<cffunction access="public" name="UserGroup" output="true" returntype="string" displayname="Verify Function Access">
	
		<cfargument name="group"   type="string" required="true">
		<cfargument name="mission" type="string" required="false">
		 			
		<cfif SESSION.isAdministrator eq "Yes">

          <CFSET AccessRight = 'GRANTED'>

        <cfelse>
			<cftransaction isolation="read_uncommitted">
				<cfquery name="qAccess" 
				datasource="AppsSystem">
				SELECT U.Account
				FROM  UserNames U
				WHERE U.AccountType = 'Group'
				AND   U.Account = '#group#'
				AND   (
					    U.AccountOwner IN (SELECT ClassParameter 
									      FROM   Organization.dbo.OrganizationAuthorization
									      WHERE  Role = 'AdminUser' 
									      AND    UserAccount = '#SESSION.acc#')
					    OR
									   
				      U.AccountMission IN (SELECT Mission 
			     					       FROM   Organization.dbo.OrganizationAuthorization 
										   WHERE  UserAccount = '#SESSION.acc#'
										   AND    Role = 'OrgUnitManager')	
										   
					 )					   			 
				</cfquery>
			</cftransaction>
		   
          <cfif qAccess.RecordCount eq "0">
              <CFSET AccessRight = 'DENIED'>
          <cfelse>
              <CFSET AccessRight = 'GRANTED'>
	      </cfif>	  
		  		 
		</cfif>
		

			
		<cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 1.2. ORGANIZATION MANAGER : access to orgunit authorization --->
	
	<cffunction access="public" name="org" output="true" returntype="string" displayname="Verify OrgUnit Access">
	
		<cfargument name="OrgUnit" type="string"   required="true" default="0">		
		<cfargument name="Mission" type="string"   required="true" default="">
		
		<cftransaction isolation="read_uncommitted">
			
		<cfif getAdministrator(mission) eq "1">			
		
          <CFSET AccessLevel = "2">
		  		        
        <cfelse>
		
			<cfif Mission eq "">

					<cfquery name="Unit" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#OrgUnit#'
					</cfquery>
					
					
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT MAX(AccessLevel) as AccessLevel 
						FROM   OrganizationAuthorization PA
						WHERE  PA.UserAccount = '#SESSION.acc#' 
						AND    PA.Role   IN ('OrgUnitManager', 'HRPosition')
						AND    (PA.OrgUnit IN 
									   (SELECT OrgUnit 
										FROM   Organization 
										WHERE  OrgUnitCode = '#Unit.HierarchyRootUnit#'
										  AND  Mission     = '#Unit.Mission#'
										  AND  MandateNo   = '#Unit.MandateNo#')
								OR (PA.Mission = '#Unit.Mission#' AND PA.OrgUnit is NULL)
								)				  
					</cfquery>
				
				
			<cfelse>	
				
					<cfquery name="qAccess" 
	            	datasource="AppsOrganization" 	           
	            	username="#SESSION.login#" 
	            	password="#SESSION.dbpw#">
			            SELECT MAX(AccessLevel) as AccessLevel 
			        	FROM   OrganizationAuthorization PA
						WHERE  PA.UserAccount = '#SESSION.acc#' 
					  	AND  PA.Role    IN ('OrgUnitManager','HRPosition')
					  	AND  PA.Mission = '#Mission#' 
					  	AND  PA.OrgUnit is NULL			  
					</cfquery>
				
															
			</cfif>
					
            <cfif qAccess.AccessLevel eq "">
              <CFSET AccessLevel = "9">
            <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
		 </cfif>
		 
		 </cftransaction>		 	 
			 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 1.3 SYSTEM Manager : access to orgunit authorization --->
	
	<cffunction access="public" name="system" output="true" returntype="string" displayname="Verify System Access">
	
		<cfargument name="Owner" type="string" required="true" default="">
				
		<cfif SESSION.isAdministrator eq "Yes">
		
          <CFSET AccessLevel = "2">
		        
        <cfelse>
			
			<cftransaction isolation="read_uncommitted">																
				<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1>
					SELECT Max(AccessLevel) as AccessLevel 
					FROM   OrganizationAuthorization PA
					WHERE  PA.UserAccount = '#SESSION.acc#' 
				  	AND  PA.Role   IN ('AdminSystem')
				  	<cfif Owner neq "">
				  	AND PA.ClassParameter = '#Owner#'
				  	</cfif>				    
				</cfquery>
			</cftransaction>
										
            <cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = '9'>
            <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 1.4 USER Manager : access to user administration --->
	
	<cffunction access="public" name="UserAdmin" output="true" returntype="string" displayname="Verify OrgUnit Access">
	
		<cfargument name="Owner"        type="string" required="true" default="">
		<cfargument name="AccessLevel"  type="string" required="true" default="">	
		<cfargument name="Mission"      type="string" required="true" default="">			
		<cfargument name="TreeAccess"   type="string" required="true" default="No">
		<cfargument name="SystemModule" type="string" required="true" default="">
			
		<cftransaction isolation="read_uncommitted">
					
		<cfif SESSION.isAdministrator eq "Yes">
		
          <CFSET AccessLevel = '2'>
		        
        <cfelse>
			 													
				 <cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT Max(AccessLevel) as AccessLevel 
					FROM   OrganizationAuthorization PA
					WHERE  PA.UserAccount = '#SESSION.acc#' 
					  AND  PA.Role IN ('AdminUser')
					  
					  <cfif mission neq "">
					  AND  PA.ClassParameter IN (SELECT MissionOwner 
							                      FROM  Ref_Mission 
												  WHERE Mission = '#Mission#')
					  </cfif>							  
					  
					  <cfif Owner neq "">
					  AND PA.ClassParameter = '#Owner#'
					  </cfif>
					  
					  <cfif accessLevel neq "">
					  AND PA.AccessLevel IN (#preservesinglequotes(accessLevel)#) 				  
					  </cfif>								  	    
				</cfquery>
														
            <cfif qAccess.RecordCount eq "0" or qAccess.AccessLevel eq "0" or qAccess.AccessLevel eq "">
									
				<!--- check if user has treerolemanager (useradminmananger) for that role --->
											
			   <cfif treeaccess eq "Yes">			   
				    <cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT MAX(AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization PA 
					WHERE  PA.UserAccount = '#SESSION.acc#' 
					  AND  PA.Role IN ('OrgUnitManager') 
					 
					  <cfif systemModule neq "">
					  AND  PA.Mission IN (SELECT Mission 
					                      FROM Ref_MissionModule
					                      WHERE SystemModule = '#SystemModule#')	
					  </cfif>	
					  
					  <cfif mission neq "">
			 		  AND  PA.Mission = '#Mission#'
				      </cfif>	
					  				  					 	 			 
					  AND PA.AccessLevel IN ('2','3')  
					  				  										  	    
					</cfquery>		  
								   
				   <cfif qAccess.Recordcount eq "0" or qAccess.AccessLevel eq "0" or qAccess.AccessLevel eq "">
				   		<CFSET AccessLevel = '9'>
				   <cfelse>
				   	    <CFSET AccessLevel = qAccess.AccessLevel>
				   </cfif>
			   
			   <cfelse>
			   
				   <CFSET AccessLevel = '9'>
			   
			   </cfif>
			
            <cfelse>
			
              <CFSET AccessLevel = qAccess.AccessLevel>
			  
	        </cfif>	  
			
		 </cfif>
		 
		 </cftransaction>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 1.5 Workflow Manager : access to maintain workflows --->
	
	<cffunction access="public" name="workflowadmin" output="true" returntype="string" displayname="Verify OrgUnit Access">
	
		<cfargument name="EntityCode"  type="string" required="true" default="">
		<cfargument name="EntityClass" type="string" required="true" default="">		
		
		<cftransaction isolation="read_uncommitted">
		<cfif SESSION.isAdministrator eq "Yes">
		
          <CFSET AccessLevel = '2'>
		        
        <cfelse>
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT MAX(AccessLevel) as AccessLevel 
						FROM   OrganizationAuthorization PA
						WHERE  PA.UserAccount = '#SESSION.acc#' 
						  AND  PA.Role IN ('AdminSystem')					  
						  AND  PA.ClassParameter IN (SELECT EntityClassOwner
													 FROM   Ref_EntityClassOwner
													 WHERE  EntityCode  = '#EntityCode#'
													 AND    EntityClass = '#EntityClass#')						
											 
					</cfquery>
								
				<cfif qAccess.AccessLevel lte "0">
				
				    <!--- enable access for the treerolemanager to the workflow --->
						<cfquery name="qAccess" 
						datasource="AppsOrganization" 
						maxrows=1 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">				
						SELECT MAX(AccessLevel) as AccessLevel 
						FROM   OrganizationAuthorization PA
						WHERE  PA.UserAccount = '#SESSION.acc#' 
						AND    PA.Role IN ('OrgUnitManager')					  
						AND    PA.Mission IN (SELECT Mission  <!--- the mission for which the entity is enabled --->
						                  FROM   Ref_MissionModule
										  WHERE  SystemModule = (SELECT A.SystemModule  <!--- module underwhich the entity operates --->
											                     FROM   Ref_Entity R, Ref_AuthorizationRole A 
																 WHERE  R.Role       = A.Role
																 AND    R.EntityCode = '#entityCode#')
											 )						 
						</cfquery>
								
				</cfif>
										
                <cfif qAccess.AccessLevel eq "">
                  <CFSET AccessLevel = '9'>
                <cfelse>
                  <CFSET AccessLevel = qAccess.AccessLevel>
	            </cfif>	  
			
		 </cfif>
		 </cftransaction>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 1.51 Creation of a workflow object using the standard option of a create action --->
	
	<cffunction access="public" name="createwfobject" output="true" returntype="string" displayname="Verify Creation Access">
	    <cfargument name="EntityCode"  type="string" required="true" default="">
		<cfargument name="Mission"     type="string" required="false" default="">
		<cfargument name="OrgUnit"     type="string" required="false" default="0">
		
		 <!--- verify if user has action code linked to create recorded in the authorization table --->
		 <cftransaction isolation="read_uncommitted">
			  <cfquery name="Check" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
		      SELECT  *
			  FROM    Ref_EntityAction E
			  WHERE   E.EntityCode  = '#EntityCode#' 
				AND   E.ActionType  = 'Create'
			 </cfquery>
			 
			 <cfif Check.recordcount eq "1">
				
				 <cfquery name="Create" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
			      SELECT  DISTINCT E.EntityCode
				  FROM    Ref_EntityAction E, OrganizationAuthorization A
				  WHERE   E.ActionCode  = A.ClassParameter
					AND   A.UserAccount = '#SESSION.acc#'
					<cfif mission neq "">
					AND   A.Mission = '#mission#'
					</cfif>
					AND   E.EntityCode  = '#EntityCode#' 
					AND   E.ActionType  = 'Create'
				 </cfquery>
				
				 <cfif SESSION.isAdministrator eq "Yes">
				
		            <CFSET AccessLevel = "1">
				        
		         <cfelseif Create.recordcount gte "1">
				
				    <cfset AccessLevel = "1">
							
				 <cfelse>
				 
				 	<cfset AccessLevel = "0">			
						
				 </cfif>
				 
			 <cfelse>
			 
			 	 <CFSET AccessLevel = "1">
			 
			 </cfif>
		 </cftransaction>
		
	 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>	
	
	<!--- 1.52 View a workflow object in the tree --->
	
	<cffunction access="public" name="ShowEntity" output="true" returntype="string" displayname="Verify Creation Access">
	    
		<cfargument name="EntityCode"   type="string" required="true"  default="">
		<cfargument name="EntityGroup"  type="string" required="false" default="">
		<cfargument name="Owner"        type="string" required="false" default="">		
		
		<cftransaction isolation="read_uncommitted">
			 <cfquery name="Entity" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
			      SELECT *
				  FROM    Ref_Entity
				  WHERE   EntityCode  = '#EntityCode#'
			 </cfquery>
				 
			 <cfif EntityGroup neq "">	 
			
				<cfquery name="Check" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">	
					SELECT   TOP 1 *
					FROM     OrganizationAuthorization
					WHERE    UserAccount    = '#SESSION.acc#' 
					AND      Role           = '#Entity.role#' 
					AND 	 GroupParameter = '#EntityGroup#' 				
				</cfquery>	
				 
			 <cfelseif Owner eq "">
				 		 
			    <cfquery name="Check" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">	
					SELECT   TOP 1 *
					FROM     OrganizationAuthorization 
					WHERE    UserAccount   = '#SESSION.acc#' 
					AND      Role          = '#entity.role#' 						
				 </cfquery>
				 	
		     <cfelse>
			  
			  	<cfquery name="Check" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">	
					SELECT   TOP 1 R.*
					FROM     OrganizationAuthorization AS A INNER JOIN
		    	             Ref_EntityGroup AS R ON A.GroupParameter = R.EntityGroup
					WHERE    A.UserAccount   = '#SESSION.acc#' 
					AND      A.Role          = '#Entity.role#' 
					AND 	 R.EntityCode    = '#EntityCode#' 
					AND 	 R.Owner         = '#Owner#'
				</cfquery>	
				  
			</cfif>		
					
			<cfif SESSION.isAdministrator eq "Yes">
				
		            <CFSET AccessLevel = "1">
				        
		    <cfelseif Check.recordcount gte "1">
				
				    <cfset AccessLevel = "1">	
					
			<cfelse> 
			
					<cfset AccessLevel = "0">		
						
			</cfif>
		
		</cftransaction>
					
		<cfinclude template="AccessSub.cfm">
			 <cfreturn AccessRight>
		 
	</cffunction>		 
	
	<!--- 2.0 EntityWorkflow step access : access to action authorization --->
			
	<cffunction access="public" name="AccessEntity" output="true" returntype="string" displayname="Verify Action Access">
	    <cfargument name="Mission"     type="string" required="true" default="">
		<cfargument name="OrgUnit"     type="string" required="true" default="0">
		<cfargument name="Role"        type="string" required="true" default="ProgramManager">
		<cfargument name="ObjectId"    type="string" required="true" default="">
		<cfargument name="ActionCode"  type="string" required="true" default="0000">
		<cfargument name="User"        type="string" required="true" default="#SESSION.acc#">
		<cfargument name="EntityGroup" type="string" required="true" default="">
		<cfargument name="datasource"  type="string" required="true" default="AppsEmployee">
				
		<cfif getAdministrator(mission) eq "1">
						
             <CFSET AccessLevel = "1">
		        
        <cfelse>		
							
			<cfquery name="Delegate" 
			 datasource="#Datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT    *
			 FROM      System.dbo.UserNames
			 WHERE     AccountDelegate = '#user#' 
			</cfquery>
			
			<cfif Delegate.AccountDelegate neq "">
			  <cfset usr = "'#user#','#Delegate.Account#'">
			<cfelse>
			  <cfset usr = "'#user#'"> 
			</cfif>
			
			<cfquery name="Related" 
			 datasource="#Datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   System.dbo.UserNames
			 WHERE  PersonNo IN (SELECT PersonNo
			          			 FROM      System.dbo.UserNames
							     WHERE     Account = '#user#' )
			 AND    Disabled = 0			
			 AND    Account != '#user#'				
			</cfquery>
			
			<cfif Related.recordcount gte "1">
				<cfset usr = "#usr#,#quotedvalueList(related.account)#">
			</cfif>
		
			<cfquery name="qRole" 
            datasource="#Datasource#" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
            SELECT * 
	        FROM   Organization.dbo.Ref_AuthorizationRole 
			WHERE  Role = '#Role#'
			</cfquery>
			
			<cfif qRole.OrgUnitLevel eq "Global" or OrgUnit eq "0" or OrgUnit eq "">
			
			    <cfquery name="qAccess" 
				datasource="#Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT Max(AccessLevel) as AccessLevel  
				FROM   Organization.dbo.OrganizationAuthorization PA
				WHERE  PA.UserAccount    IN (#preserveSingleQuotes(usr)#)  
				  AND  PA.ClassParameter = '#ActionCode#' 
				  <cfif EntityGroup neq "">
				  AND  PA.GroupParameter = '#EntityGroup#'  
				  </cfif>
				</cfquery>				
					
			<cfelse>
							
				<cfif mission eq "">	
						
					<cfquery name="Unit" 
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization.dbo.Organization
						WHERE  OrgUnit = '#OrgUnit#' 
					</cfquery>
					<cfset mis = Unit.Mission>
				
				<cfelse>
								
					<cfset mis = Mission>
								
				</cfif>
						
			   <cfquery name="qAccess" 
				datasource="#Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MAX(AccessLevel) as AccessLevel 
				FROM   Organization.dbo.OrganizationAuthorization PA
				WHERE  PA.UserAccount   IN (#preserveSingleQuotes(usr)#)  
				  <!--- AND  PA.Role           = '#Role#' --->
				  AND  PA.ClassParameter = '#ActionCode#' 
				  <cfif EntityGroup neq "">
				  AND  PA.GroupParameter = '#EntityGroup#'
				  </cfif>
				  AND  (PA.OrgUnit = '#OrgUnit#'  
					  OR (PA.Mission = '#mis#' AND PA.OrgUnit is NULL) 		
					  OR (PA.Mission is NULL AND PA.OrgUnit is NULL)) 			   
				</cfquery>
			
			</cfif>
															   
            <cfif qAccess.RecordCount eq "0" or qAccess.AccessLevel eq "">		
																		
			   <!--- check for access on the fly --->
			  
			    <cfif ObjectId neq "">
			  
					<cfquery name="qAccess" 
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
					SELECT Max(AccessLevel) as AccessLevel 
					FROM   Organization.dbo.OrganizationObjectActionAccess 
					WHERE  UserAccount    IN (#preserveSingleQuotes(usr)#)  
					AND    ActionCode     = '#ActionCode#' 
					AND    ObjectId       = '#ObjectId#' 					
									
					</cfquery>
				
				</cfif>
				
			</cfif>
									
			<cfif qAccess.RecordCount eq "0" or qAccess.AccessLevel eq "">	
                <CFSET AccessLevel = "9">
            <cfelse>			
	            <CFSET AccessLevel = qAccess.AccessLevel>
				<cfif AccessLevel eq "2">
					  <cfset AccessLevel = "2">
				<cfelse>
					  <cfset AccessLevel = "1">	  
				</cfif>
	        </cfif>	  
					
						
			<!--- NEW a provision to prevent processing your own steps accross the board --->
			
			<cfquery name="Entity" 
				datasource="#Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization.dbo.Ref_Entity R, Organization.dbo.OrganizationObject O
					WHERE  R.EntityCode = O.EntityCode
					AND    O.ObjectId = '#ObjectId#' 
			</cfquery>
									
			<cfif User eq SESSION.acc 
			      AND SESSION.isAdministrator eq "No" 
				  AND ENTITY.enableSelfProcess eq "0">
																					
				<cfif CLIENT.PersonNo eq Entity.PersonNo AND client.personNo neq "">																	
					<CFSET AccessLevel = "9">				
				</cfif>
			
			</cfif>
																				
			<cfif accesslevel neq "1">  <!--- accesslevel eq "0" or accesslevel = "9" --->
			
				<!--- check for access for the person as a subject --->
								  
			    <cfif Entity.PersonClass neq "">
				
					<cfquery name="Enable" 
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT     *
						FROM       Organization.dbo.Ref_EntityActionPublish
						WHERE      ActionCode      = '#ActionCode#'
						AND        ActionPublishNo = '#Entity.ActionPublishNo#' 
					</cfquery>
					
					<cfif Enable.PersonAccess eq "1">
					
					     <!--- person access enabled regardless, now match user with document subject to qualify --->
			  
						<cfswitch expression="#Entity.PersonClass#">
						
							<cfcase value="Employee">
								<cfif CLIENT.PersonNo eq Entity.PersonNo>
									<CFSET AccessLevel = "1">
								</cfif>
							</cfcase>
							
							<cfcase value="Candidate">
								<!--- use indexNo in userNames -> to the IndexNo  
								   to match PersonNo with Object.PersonNo --->													
							</cfcase>
							
							<cfcase value="User">							
								<cfif SESSION.acc eq Entity.PersonNo>
										<CFSET AccessLevel = "1">
								</cfif>							
							</cfcase>
						
						</cfswitch>
					
					<cfelseif Enable.PersonAccess eq "2" and (qAccess.AccessLevel eq "1" or qAccess.AccessLevel eq "2")>
					
					   <!--- person access is only enabled if this person would have been granted access based on his role --->
					   
					   <cfswitch expression="#Entity.PersonClass#">
						
							<cfcase value="Employee">
								<cfif CLIENT.PersonNo eq Entity.PersonNo>
									<CFSET AccessLevel = "1">
								</cfif>
							</cfcase>
							
							<cfcase value="Candidate">
								<!--- use indexNo in userNames -> to the IndexNo  
								   to match PersonNo with Object.PersonNo --->													
							</cfcase>
							
							<cfcase value="User">							
								<cfif SESSION.acc eq Entity.PersonNo>
										<CFSET AccessLevel = "1">
								</cfif>							
							</cfcase>
						
						</cfswitch>					   
					   
					</cfif>
									
				</cfif>
				
			</cfif>							
						
		 </cfif>
		 				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
			
	<cffunction access="public" name="AccessEntityFly" output="true" returntype="string" displayname="Verify Action Access">
	  		
		<cfargument name="ObjectId"      type="string" required="true" default="">
		<cfargument name="ActionCode"    type="string" required="true" default="">
		<cfargument name="ActionStatus"  type="string" required="true" default="0">
		<cfargument name="Role"          type="string" required="false" default="">
		<cfargument name="User"          type="string" required="true" default="#SESSION.acc#">
				
		<cfif SESSION.isAdministrator eq "Yes">
		
          <CFSET AccessLevel = "2">
		        
        <cfelse>
		
			<cftransaction isolation="read_uncommitted">
			<cfquery name="Check" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">					
				SELECT    MAX(OA.AccessLevel) AS UserAccessLevel
				FROM      OrganizationObjectActionAccess OA INNER JOIN
	                      OrganizationObjectAction O 
						       ON OA.ObjectId = O.ObjectId AND OA.ActionCode = O.ActionCode
				WHERE     OA.ObjectId = '#ObjectId#'
				<cfif ActionCode neq "">
				AND       OA.ActionCode = '#ActionCode#'
				</cfif>
				
				<!--- grant only access of the status of the action = open --->
				
				AND       O.ActionStatus = '#ActionStatus#'
				
				AND       OA.UserAccount = '#user#' 
				
			</cfquery>
			</cftransaction>
						
			<cfset AccessLevel = Check.UserAccessLevel>		
						
		 </cfif>		 
		  		 
		 <cfreturn AccessLevel>
		 
	</cffunction>	
	
	<cffunction access="public" name="StaffingTable" output="true" returntype="string" 
	    displayname="Verify ST maintenance">
		
		<cfargument name="Mission" type="string" required="true">
		<cftransaction isolation="read_uncommitted">
			<cfquery name="Check" 
			    datasource="AppsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT top 1 *
					FROM OrganizationAuthorization
					WHERE 
					Mission = '#mission#' 
					AND
					UserAccount = '#SESSION.acc#'
					AND
					(
					(   
						Role   IN ('HROfficer', 'HRAssistant','HRPosition','HRLoaner','HRLocator')
						AND   AccessLevel > '0'
					)
					OR 
					(
						Role   IN ('HRInquiry')
					)
					)
			</cfquery>	
		</cftransaction>
		
		<cfif getAdministrator(mission) eq "1">		
          <CFSET AccessLevel = "2">
		<cfelseif check.recordcount eq "0">
			<cfset accessLevel = "9">		
		<cfelse>
			<cfset accessLevel = "1">
		</cfif>
				
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 		 
	</cffunction>	
			
	<!--- 3.0 Employee PA MANAGER : access to position functions --->
	
	<cffunction access="public" name="Contract" output="true" returntype="string" displayname="Verify Position Access">
		
		<cfargument name="Mission"    type="string" required="false" default="">
		<cfargument name="PersonNo"   type="string" required="false" default="">		
		<cfargument name="Incumbency" type="string" required="false" default="100">
		<cfargument name="Role"       type="string" required="false" default="'ContractManager'">
		<cfargument name="Access"     type="string" required="true"  default="9">
		
		<!--- check the mode --->
				
		<cfif SESSION.isAdministrator eq "Yes">

            <CFSET AccessLevel = "2">
		        
        <cfelse>
					
			<cfif PersonNo neq "" and mission eq "">
			
			    <cf_verifyOperational  module="WorkOrder"  Warning="No">
				<cfset workOrderEnabled = operational>
			
				 <!--- find the last mission of this person --->
				 <cftransaction isolation="read_uncommitted">	
				 
					 <cfquery name="OnBoard" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   TOP 1 P.*
						 FROM     PersonAssignment PA, Position P
						 WHERE    PersonNo           = '#PersonNo#'
						 AND      PA.PositionNo      = P.PositionNo					 
						 AND      PA.AssignmentStatus IN ('0','1')
						 <cfif incumbency neq "">
						 AND      PA.AssignmentClass IN (SELECT AssignmentClass 
						                                 FROM   Ref_AssignmentClass P
														 WHERE  AssignmentClass = PA.AssignmentClass
														 AND    Incumbency = '#incumbency#')
						 </cfif>								 
						 AND      PA.AssignmentType  = 'Actual'		
						 <cfif incumbency neq "">			 
						 AND      PA.Incumbency      = '#incumbency#' 
						 </cfif>
						 ORDER BY PA.DateEffective DESC
					</cfquery>
					
					<cfif onboard.recordcount eq "0">
					<!--- we check of we have a workorder assignment record --->
					
					  	<cfif workOrderEnabled eq 1>
						
							<cfquery name="OnBoard" 
							 datasource="AppsEmployee"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">					
								SELECT     TOP 1 W.Mission
								FROM       WorkOrder.dbo.WorkOrderLine WL INNER JOIN
			                    		   WorkOrder.dbo.WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
								WHERE      WL.PersonNo = '#PersonNo#' 
								AND        WL.Operational = 1
								ORDER BY   WL.DateEffective DESC
							</cfquery>
						
							<cfset mission   = Onboard.Mission>	
							<cfset missionop = Onboard.Mission>		
							
						<cfelse>
						
							<cfset mission   = "">	
							<cfset missionop = 0>
								
						</cfif>
																	
					<cfelse>
					
						<cfset mission   = Onboard.Mission>	
						<cfset missionop = Onboard.MissionOperational>		
					
					</cfif>
				
				</cftransaction>
				
				
			<cfelse>
			
				<cfset missionop = Mission>			    
		
			</cfif>
			
			<cfif getAdministrator(missionOP) eq "1">	
							
				 <CFSET AccessLevel = "2">
			
			<cfelse>			
			
				<cftransaction isolation="read_uncommitted">	
												
					<cfquery name="qAccess" 
		            datasource="AppsOrganization"            
		            username="#SESSION.login#" 
		            password="#SESSION.dbpw#">
			            SELECT   MAX(AccessLevel) as AccessLevel
				        FROM     OrganizationAuthorization
						WHERE	 UserAccount = '#SESSION.acc#' 
						AND      Role IN (#PreserveSingleQuotes(Role)#) 
						<cfif mission neq "">
						AND      (Mission = '#Mission#' or Mission = '#missionop#')
						</cfif>				 				 
						<!---
						   AND    (PA.Mission = '#Mission#' AND PA.OrgUnit is NULL)
						--->				  				 					   
					</cfquery>
										
				</cftransaction>
			   		   
			   <cfif qAccess.RecordCount eq "0">
	                <CFSET AccessLevel = '9'>
	           <cfelse>
	                <CFSET AccessLevel = qAccess.AccessLevel>
		       </cfif>	  
			   
			 </cfif>  
					
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>	
	
	
	<!--- 3.1 HR Officer : access to an employee record --->
	
	<cffunction access="public" name="Employee" output="true" returntype="string" displayname="Verify Employee Access">
		
		<cfargument name="PersonNo" type="string" required="true">
		<cfargument name="Owner"    type="string" required="true" default="No">
		<cfargument name="Mode"     type="string" required="true" default="Assignment">
		<cfargument name="Access"   type="string" required="true" default="9">	
		
		<!--- 
		we first check if the user is an administrator or if some how in the context it was granted in advance			 								   						   
		then we check if the user has access ALL to the last entity (global) of that person
		then we check if the person has access to the assignment incl or excluding latency
		--->
		
		<cfif getAdministrator("*") eq "1" or access eq "GRANTED">						
		
          <CFSET AccessLevel = "2">		  
		        
        <cfelse>
		
			<cfset accessLevel = "0">
		
			<cftransaction isolation="read_uncommitted">
			
				<cfquery name="getParam" 
		            datasource="AppsEmployee" 	           
		            username="#SESSION.login#" 
		            password="#SESSION.dbpw#">
					SELECT * 
					FROM   Parameter
				</cfquery>												
								
				<!--- check for active assignment --->
				
				<cfquery name  = "LastMission" 
		            datasource = "AppsEmployee"
		            username  = "#SESSION.login#" 
		            password  = "#SESSION.dbpw#">
						SELECT    TOP 1 * 
						FROM      PersonAssignment A INNER JOIN Position P ON A.PositionNo = P.PositionNo
						WHERE     PersonNo   = '#PersonNo#' 	
						AND       AssignmentType = 'Actual'					
						AND       AssignmentStatus IN ('0','1')
						AND       Incumbency > 0 					
						ORDER BY  A.DateEffective DESC	
				</cfquery>	
				
				<cfif LastMission.recordcount eq "0">
						
					<cfquery name  = "LastMission" 
			            datasource = "AppsEmployee"
			            username  = "#SESSION.login#" 
			            password  = "#SESSION.dbpw#">
							SELECT   TOP 1 PC.Mission 
							FROM     PersonContract PC 
							WHERE    PC.Personno       = '#PersonNo#' 
							AND      PC.ActionStatus != '9'
							ORDER BY PC.DateEffective DESC  
					</cfquery>		

				</cfif>				
				
				<cfif LastMission.recordcount gte "1">	
				
					<!--- we check if the person has all rights for the mission 
					   no matter when the assignment took place --->
					   
					<cfinvoke component = "Service.Access" 
						datasource      = "AppsEmployee"	 
				   		method          = "RoleAccess" 
				   		Role            = "'HROfficer','HRAssistant','ContractManager','PayrollOfficer','TimeKeeper'"
				   		accesslevel     = "2"			
						mission         = "#LastMission.Mission#"   		
				   		returnvariable  = "Access">
						
					<cfif Access eq "GRANTED">
					
						<cfset AccessLevel = "2">
						
					<cfelse>
					
						<cfset AccessLevel = "0">	
						
					</cfif>	
					
				</cfif>
				
				<cfif AccessLevel neq "2">	
				
					<!--- we check if the person has been recently onboard and then check access for it --->
				
					<cfquery name  = "OnBoardToday" 
			            datasource = "AppsEmployee"
			            username  = "#SESSION.login#" 
			            password  = "#SESSION.dbpw#">
							SELECT TOP 1 * 
							FROM   PersonAssignment 
							WHERE  Personno       = '#PersonNo#' 
							AND    AssignmentType = 'Actual'			
							AND    DateExpiration >= getDate()
							AND    AssignmentStatus IN ('0','1')
							AND    Incumbency > 0 
							
					</cfquery>				
												
					<cfif OnBoardToday.recordcount eq "0">		
						
						<cfset dateValue = "">
						<CF_DateConvert Value="#DateFormat('#now()-getParam.AssignmentLatency#',CLIENT.DateFormatShow)#">
						<cfset date = dateValue>
						
					<cfelse>
							
						<cfset dateValue = "">
						<CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
						<cfset date = dateValue>								
					
					</cfif>
					  
			  		<cfquery name="Check" 
			            datasource="AppsEmployee" 
			            maxrows=1 
			            username="#SESSION.login#" 
			            password="#SESSION.dbpw#">
		
						<cfif Mode neq "Assignment">
		    
						    SELECT MAX(AccessLevel) as AccessLevel
						    FROM   Organization.dbo.OrganizationAuthorization
						    WHERE  UserAccount = '#SESSION.acc#' 
						    AND    Role IN ('HROfficer','HRAssistant','ContractManager','PayrollOfficer','TimeKeeper')	
						    AND    AccessLevel IN ('1','2')
						    
						    UNION 
						    
						</cfif>
		    
						<!--- unit access --->
						
				        SELECT MAX(AccessLevel) as AccessLevel
				        FROM   Organization.dbo.OrganizationAuthorization Aut, 
						       Position Pos, 
							   PersonAssignment Ass
			            WHERE  Aut.UserAccount        = '#SESSION.acc#' 
				        AND    Pos.OrgUnitOperational = Aut.OrgUnit
						AND    Aut.Role IN ('HROfficer','HRAssistant','ContractManager','PayrollOfficer','TimeKeeper')				
						AND    Pos.PositionNo         = Ass.PositionNo
						AND    Ass.PersonNo           = '#PersonNo#'
						AND    Ass.AssignmentStatus IN ('0','1')
						AND    Ass.AssignmentType = 'Actual'			
						AND    Ass.DateExpiration >= #date#
						
						UNION
						
						<!--- mission access --->
						
						SELECT MAX(AccessLevel) as AccessLevel
				        FROM   Organization.dbo.OrganizationAuthorization Aut, 
						       Position Pos, 
							   PersonAssignment Ass
			            WHERE  Aut.UserAccount     = '#SESSION.acc#' 
						<!--- 5/12/2013 we grant access to either operational or owner mission --->
				        AND    (Pos.Mission        = Aut.Mission or Pos.MissionOperational = Aut.Mission)		        
						AND    Aut.OrgUnit is NULL
						AND    Aut.Role IN ('HROfficer','HRAssistant','ContractManager','PayrollOfficer','TimeKeeper')
						AND    Pos.PositionNo      = Ass.PositionNo
						AND    Ass.PersonNo        = '#PersonNo#'
						AND    Ass.AssignmentType = 'Actual'	
						AND    Ass.AssignmentStatus IN ('0','1')
						AND    Ass.DateExpiration >= #date#			
						
						<!--- added 10/11/2015 for personnel events --->
						
						UNION 	
						
						<!--- event access --->
						SELECT MAX(AccessLevel) as AccessLevel
				        FROM   Organization.dbo.OrganizationAuthorization Aut, 					        
							   PersonEvent Ev
			            WHERE  Ev.Mission         = Aut.Mission	
						AND    Aut.UserAccount    = '#SESSION.acc#' 
						<!--- 5/12/2013 we grant access to either operational or owner mission --->			          	        
						AND    Aut.OrgUnit is NULL
						AND    Aut.Role IN ('HROfficer','HRAssistant','ContractManager''PayrollOfficer','TimeKeeper')					
						AND    Ev.PersonNo        = '#PersonNo#'
						AND    Ev.ActionStatus   != '9'
						AND    Ev.DateEvent      >= #date#			
						
						
						<!--- added 24/11/2015 for personnel events --->
						
						UNION 	
						
						<!--- contract access --->
						SELECT MAX(AccessLevel) as AccessLevel
				        FROM   Organization.dbo.OrganizationAuthorization Aut, 					        
							   PersonContract Ev
			            WHERE  Ev.Mission         = Aut.Mission	
						AND    Aut.UserAccount    = '#SESSION.acc#' 
						<!--- 5/12/2013 we grant access to either operational or owner mission --->			          	        
						AND    Aut.OrgUnit is NULL
						AND    Aut.Role IN ('HROfficer','HRAssistant','ContractManager''PayrollOfficer','TimeKeeper')					
						AND    Ev.PersonNo        = '#PersonNo#'
						AND    Ev.ActionStatus   != '9'
						AND    Ev.DateExpiration >= #date#		
																	
						UNION
						
						<!--- inquiry access --->
						
					    SELECT MAX(AccessLevel) as AccessLevel
				        FROM   Organization.dbo.OrganizationAuthorization Aut
			            WHERE  Aut.UserAccount = '#SESSION.acc#' 
				       	AND    Aut.Role IN ('HRInquiry')	
						
						ORDER BY AccessLevel DESC 
											
					</cfquery>
													       		   
				   <cfif Check.AccessLevel eq "" and PersonNo neq "">
				   
				   	   <cftransaction isolation="read_uncommitted">	
						   <cfquery name="Bucket" 
							datasource="AppsEmployee" 
							maxrows=1 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
							SELECT    '0' AS AccessLevel
							FROM      Applicant.dbo.Applicant A INNER JOIN
									  Applicant.dbo.ApplicantSubmission S ON A.PersonNo = S.PersonNo INNER JOIN
									  Applicant.dbo.ApplicantFunction F ON S.ApplicantNo = F.ApplicantNo INNER JOIN
									  Applicant.dbo.FunctionOrganization FO ON F.FunctionId = FO.FunctionId INNER JOIN
									  Applicant.dbo.RosterAccessAuthorization AX ON FO.FunctionId = AX.FunctionId INNER JOIN
									  Employee.dbo.Person P ON A.IndexNo = P.IndexNo
							WHERE     AX.UserAccount = '#SESSION.acc#' 
							AND       P.PersonNo = '#PersonNo#'
							
							</cfquery>
							
						</cftransaction>
						
						<cfif Bucket.RecordCount eq "0">
				            <CFSET AccessLevel = "9">
						<cfelse>
						    <CFSET AccessLevel = "0">
						</cfif>		
						 
		           <cfelse>
				   
		              <CFSET AccessLevel = Check.AccessLevel>
					  
			       </cfif>	
				   
				</cfif>		
				
			</cftransaction>     
					
		 </cfif>
		 
		 <!--- wildcard --->
		 		  
		 <cfif AccessLevel neq "2" and CLIENT.personno eq PersonNo and Owner eq "Yes">
		 		 
			  <CFSET AccessLevel = "2">
		 
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
			
	<!--- 3.1.a Verify Mission Ownership --->
	
	<cffunction access="public" name="Owner" output="true" returntype="string" displayname="Verify Position Access">
		<cfargument name="Owner" type="string" required="true" default="">
				
		<!--- check the mode --->
				
		<cfif SESSION.isAdministrator eq "Yes">

          <CFSET AccessLevel = '2'>
		        
        <cfelse>

			<cftransaction isolation="read_uncommitted">						
				<cfquery name="qAccess" 
	            datasource="AppsOrganization" 
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
				SELECT  MAX(AccessLevel) as AccessLevel
				FROM    OrganizationAuthorization A INNER JOIN
	                    Ref_Mission ON A.Mission = Ref_Mission.Mission
				WHERE   A.UserAccount = '#SESSION.acc#'
				AND     MissionOwner = '#Owner#'
				AND     A.Role IN  ('HRPosition','HROfficer','HRAssistant','TimeKeeper')
				</cfquery>
			</cftransaction>
						   		   
		   <cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = '9'>
           <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	       </cfif>	  
					
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 3.2 POSITION MANAGER : access to position functions --->
	
	<cffunction access="public" name="Position" output="true" returntype="string" displayname="Verify Position Access">
		<cfargument name="OrgUnit"  type="string" required="false" default="">
		<cfargument name="Mission"  type="string" required="false" default="">
		<cfargument name="Mandate"  type="string" required="false" default="">
		<cfargument name="Role"     type="string" required="false" default="'HRPosition','HRLoaner','HRLocator'">
		<cfargument name="PostType" type="string" required="true"  default="">
		<cfargument name="Access"   type="string" required="true"  default="9">
		
		<!--- check the mode --->
		<cftransaction isolation="read_uncommitted">
		 <cfif orgunit neq "" and mission eq "">
			
			<cfquery name="Unit" 
            datasource="AppsOrganization"  
	        username="#SESSION.login#" 
       	    password="#SESSION.dbpw#">
	            SELECT *
		        FROM   Organization
				WHERE  OrgUnit = '#OrgUnit#'
			</cfquery>
			
			<cfset mission = unit.mission>
			
		</cfif>
		
		<cfif getAdministrator(mission) eq "1">	
			
          	<CFSET AccessLevel = "2">
		        
        <cfelse>
				
			 <cfif orgunit neq "" and orgunit neq "0">
		
				<cfquery name="Unit" 
	            datasource="AppsOrganization"
	            username="#SESSION.login#" 
    	        password="#SESSION.dbpw#">
		            SELECT *
			        FROM   Organization
					WHERE  OrgUnit = '#OrgUnit#'
				</cfquery>
			
			</cfif>
			
			<cfquery name="qAccess" 
            datasource="AppsOrganization" 
            maxrows=1 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
	            SELECT   MAX(AccessLevel) as AccessLevel
		        FROM     OrganizationAuthorization PA
				WHERE	 PA.UserAccount = '#SESSION.acc#' 
				  AND    PA.Role  IN (#PreserveSingleQuotes(Role)#)
				  
				  <cfif mandate neq "">
				    AND ( 
				         PA.OrgUnit IN (SELECT OrgUnit
				                        FROM   Organization
								        WHERE  Mission   = '#mission#'
								        AND    MandateNo = '#mandate#')
					     OR 
					    (PA.Mission = '#Mission#' AND PA.OrgUnit is NULL)
					  )		   
				  </cfif>    
				               				  
				  <cfif orgunit neq "" and orgunit neq "0">
				   AND    (PA.OrgUnit = '#OrgUnit#'
				  		   OR (PA.Mission = '#Unit.Mission#' AND PA.OrgUnit is NULL))
				  <cfelse>
				   AND    (PA.Mission = '#Mission#' AND PA.OrgUnit is NULL)
				  </cfif>		
				   
				 <cfif PostType neq "">		   				  
		  		  AND 	ClassParameter = '#PostType#'		 
				 </cfif> 						   
			</cfquery>
		   		   
		   <cfif qAccess.RecordCount eq "0">
                <CFSET AccessLevel = '9'>
           <cfelse>
                <CFSET AccessLevel = qAccess.AccessLevel>
	       </cfif>	  
					
		 </cfif>
		  </cftransaction>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
		
	<!--- 3.3 HR Officer : access to an employee post assignment assignments --->
	
	<cffunction access="public" name="Staffing" output="true" returntype="string" displayname="Verify Staffing Access">
	
		<cfargument name="OrgUnit"  type="string" required="false" default="0">
		<cfargument name="Mission"  type="string" required="false" default="">
		<cfargument name="Mandate"  type="string" required="false" default="">
		<cfargument name="Role"     type="string" required="false" default="'HROfficer','HRAssistant','HRInquiry'">
		<cfargument name="PostType" type="string" required="false" default="">
		<cfargument name="Access"   type="string" required="true"  default="9">
		
		<!--- check the mode --->
		 <cftransaction isolation="read_uncommitted">
			 <cfif orgunit neq "" and mission eq "">
			
				<cfquery name="Unit" 
	            datasource="AppsOrganization"  
		        username="#SESSION.login#" 
	       	    password="#SESSION.dbpw#">
		            SELECT *
			        FROM   Organization
					WHERE  OrgUnit = '#OrgUnit#'
				</cfquery>
				
				<cfset mission = unit.mission>
				
			</cfif>
			
			<cfif getAdministrator(mission) eq "1">	
					
	          <CFSET AccessLevel = "2">
			        
	        <cfelse>
			
			    <cfif orgunit neq "">
			
					<cfquery name="Unit" 
		            datasource="AppsOrganization"  
			        username="#SESSION.login#" 
	        	    password="#SESSION.dbpw#">
			            SELECT *
				        FROM   Organization
						WHERE  OrgUnit = '#OrgUnit#'
					</cfquery>
				
				</cfif>
				
				<cfquery name="qAccess" 
		            datasource="AppsOrganization" 			 
		            username="#SESSION.login#" 
		            password="#SESSION.dbpw#"
		            maxrows=1>
				
		            SELECT MAX(AccessLevel) as AccessLevel
					
			        FROM   OrganizationAuthorization PA
					
					WHERE  PA.UserAccount = '#SESSION.acc#' 
					AND    PA.Role  IN (#PreserveSingleQuotes(Role)#)
					   
					  <cfif orgunit neq "" and orgunit neq "0">
					   
					 	  AND    (PA.OrgUnit = '#orgunit#'
					  		   OR (
							   		<cfif Mission neq ""> <!--- We only validate Mission if it is passed --->
										PA.Mission = '#unit.mission#' AND 
									</cfif> 
									PA.OrgUnit is NULL)
								  )
					   <cfelseif mandate neq "">
					   
					      AND ( 
						
					         PA.OrgUnit IN (SELECT OrgUnit
					                        FROM   Organization
									        WHERE  Mission   = '#mission#'
									        AND    MandateNo = '#mandate#')
						      OR 
							 
						      (PA.Mission = '#mission#' AND PA.OrgUnit is NULL)
							  
						    )	
					   
					   <cfelse>				   
					   
					   	  <cfif Mission neq ""> <!--- We only validate Mission if it is passed --->
						     AND    PA.Mission = '#mission#'
						  </cfif>						
					   	  AND    PA.OrgUnit is NULL					
													
					   </cfif>		
					      
					   <cfif PostType neq "">		   				  
			  		    AND 	ClassParameter = '#PostType#'  		   
					  </cfif> 
					  
				</cfquery>
						   		   
			   <cfif qAccess.RecordCount eq "0">
	              <CFSET AccessLevel = '9'>
	           <cfelse>
	              <CFSET AccessLevel = qAccess.AccessLevel>
		       </cfif>	  
						
			 </cfif>
		 </cftransaction>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
		
	<!--- 3.4 HR Attendance Officer : access to timesheet information --->
		
	<cffunction access="public" name="timesheet" output="true" returntype="string" displayname="Verify Timesheet Access">
		
		<cfargument name="PersonNo" type="string" required="true">
		<cfargument name="Date"     type="date"   required="true"  default="#now()#">
		<cfargument name="Class"    type="string" required="false" default="Timekeeper">
		<cfargument name="Access"   type="string" required="true"  default="9">
		
		<cfif SESSION.isAdministrator eq "Yes">

          <CFSET AccessLevel = '2'>
         
        <cfelse>
		
			<cftransaction isolation="read_uncommitted">
			
				<cfquery name="units" 
	            datasource="AppsOrganization"
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
					SELECT    P.MissionOperational, P.OrgUnitOperational
					FROM      Employee.dbo.PersonAssignment AS PA INNER JOIN
	                          Employee.dbo.Position AS P ON PA.PositionNo = P.PositionNo
					AND       PA.PersonNo        = '#PersonNo#'		
					AND       PA.DateEffective  <= #Date#
					AND       PA.DateExpiration >= #Date#  
				    AND       PA.Incumbency     > '0'
					AND       PA.AssignmentStatus IN ('0','1')
				</cfquery>	
				
				<cfif units.recordcount eq "0">
				
					<cfquery name="qAccess" 
		            datasource="AppsOrganization" 
		            maxrows=1 
		            username="#SESSION.login#" 
		            password="#SESSION.dbpw#">
										
			            SELECT AccessLevel
				        FROM   OrganizationAuthorization PA
			            WHERE  PA.UserAccount    = '#SESSION.acc#' 
						AND    PA.Role           = '#Class#'
						AND    1=0
												
					</cfquery>
				
				<cfelse>
							
		     		<cfquery name="qAccess" 
		            datasource="AppsOrganization" 
		            maxrows=1 
		            username="#SESSION.login#" 
		            password="#SESSION.dbpw#">
					
					SELECT MAX(AccessLevel) as AccessLevel
					
					FROM (
			            SELECT AccessLevel
				        FROM   OrganizationAuthorization PA
			            WHERE  PA.UserAccount    = '#SESSION.acc#' 
						AND    PA.Role           = '#Class#'
						AND    PA.OrgUnit IN (#quotedvaluelist(units.OrgUnitOperational)#) 
						
						UNION ALL
						
						SELECT AccessLevel
				        FROM   OrganizationAuthorization PA
			            WHERE  PA.UserAccount    = '#SESSION.acc#' 
						AND    PA.Role           = '#Class#'
						AND    PA.OrgUnit is NULL 
						AND    PA.Mission IN (#quotedvaluelist(units.MissionOperational)#)
						
						) as B						
						
					</cfquery>
				
				</cfif>
				
			</cftransaction>	
   
            <cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = '9'>
            <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 3.5 Recruitment Officer : access to create + remeakrs --->
		
	<cffunction access="public" name="Recruit" output="true" returntype="string" displayname="Verify Recruitment Access">
		
		<cfargument name="OrgUnit"  type="string" required="true">
		<cfargument name="PostType" type="string" required="false" default="">
		<cfargument name="Access"   type="string" required="true" default="9">
		
		<cftransaction isolation="read_uncommitted">
		  <cfquery name="Unit" 
            datasource="AppsOrganization" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
	            SELECT *
		        FROM   Organization
				WHERE  OrgUnit = '#OrgUnit#'
		   </cfquery>
		   
		<cfif getAdministrator(unit.mission) eq "1">	  
		
          <CFSET AccessLevel = '2'>
         
        <cfelse>
		
          <cfquery name="Unit" 
            datasource="AppsOrganization" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
	            SELECT *
		        FROM   Organization
				WHERE  OrgUnit = '#OrgUnit#'
		   </cfquery>
			
		   <cfquery name="qAccess" 
            datasource="AppsOrganization" 
            maxrows=1 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
            SELECT Max(AccessLevel) as AccessLevel
	        FROM   OrganizationAuthorization PA
			WHERE  PA.UserAccount = '#SESSION.acc#' 
			  AND  PA.Role    = 'VacOfficer'
			  AND  (PA.OrgUnit IN 
			               (SELECT OrgUnit 
				            FROM   Organization 
					        WHERE  OrgUnitCode = '#Unit.HierarchyRootUnit#'
                            AND    Mission     = '#Unit.Mission#'
         	                AND    MandateNo   = '#Unit.MandateNo#')
			  		   OR (PA.Mission = '#Unit.Mission#' AND PA.OrgUnit is NULL))
			 <cfif PostType neq "">		   				  
	  		  AND 	ClassParameter = '#PostType#'		   
			 </cfif>  
			</cfquery>
   
            <cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = '9'>
            <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
		 </cfif>
		 </cftransaction>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
				
	<!--- ATTENTION 3.6 and 3.6B : these ones can be disabled once old track is no longer valid : Hanno 01/04/06 --->
				
	<!--- 3.6 Recruitment officer : access to an vacancy record --->
	
	<cffunction access="public" name="Vacancy" output="true" returntype="string" displayname="Verify Document Access">
		<cfargument name="Document" type="string" required="true">
		<cfargument name="Source"   type="string" required="true" default="AppsVacancy">
		<cfargument name="ActionId" type="string" required="true" default="0">
		<cfargument name="Check"    type="string" required="true" default="ActionId">
		
		<cftransaction isolation="read_uncommitted">
			<cfquery name="Document" 
				datasource="#source#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Document
				WHERE  DocumentNo      = '#Document#'					
			</cfquery>
		</cftransaction>
		
			<cfif getAdministrator(Document.mission) eq "1">	
			
	          <CFSET AccessLevel = '2'>
			  
			<cfelse>  		
				
					<cfif Check eq "ActionId">
						<cftransaction isolation="read_uncommitted">
							<cfquery name="qAccess" 
							datasource="#source#" 
							maxrows=1 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
								SELECT   AccessLevel
								FROM     ActionAuthorization A, Document V
								WHERE    V.DocumentNo   = '#Document#'
								AND      (V.Mission     = A.Mission OR A.Mission = 'All Missions')
								AND      A.ActionId     = '#ActionId#'
								AND      A.UserAccount  = '#SESSION.acc#'
				
							UNION
							
								SELECT   AccessLevel
								FROM     DocumentAccess
								WHERE    DocumentNo = '#Document#'
								AND      ActionId     = '#ActionId#'
								AND      UserAccount  = '#SESSION.acc#' 
								ORDER BY AccessLevel DESC
								
							</cfquery>
						</cftransaction>	
																									
					<cfelseif Check eq "Order">
					
						<cftransaction isolation="read_uncommitted">
							<cfquery name="qAccess" 
							datasource="#source#" 
							maxrows=1 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT A.AccessLevel
							FROM   ActionAuthorization A, DocumentFlow VA, Document V
							WHERE  VA.DocumentNo      = '#Document#'
							AND    V.DocumentNo       = VA.DocumentNo
							AND    (V.Mission = A.Mission OR A.Mission = 'All Missions')
							AND    VA.ActionId        = A.ActionId
							AND    VA.ActionOrderSub  = '#ActionId#'
							AND    A.UserAccount      = '#SESSION.acc#'
							</cfquery>
						</cftransaction>	
					
					<cfelse>
						<cftransaction isolation="read_uncommitted">
							<cfquery name="qAccess" 
							datasource="#source#" 
							maxrows=1 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT Max(AccessLevel) as AccessLevel
							FROM   ActionAuthorization A, DocumentFlow VA, Document V
							WHERE  VA.DocumentNo      = '#Document#'
							AND    V.DocumentNo       = VA.DocumentNo
							AND   (V.Mission = A.Mission OR A.Mission = 'All Missions')
							AND    VA.ActionId        = A.ActionId
							AND    VA.ActionOrder     = '#ActionId#'
							AND    A.UserAccount      = '#SESSION.acc#'
							</cfquery>
						</cftransaction>	
											
					</cfif>
									   
					<cfif qAccess.RecordCount eq "0">
					
					    <CFSET AccessLevel = '9'>
					  	<cftransaction isolation="read_uncommitted">
					 		<cfquery name="Roster" 
							datasource="appsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT  AccessLevel
							FROM    RosterAccessAuthorization A INNER JOIN
									FunctionOrganization FO ON A.FunctionId = FO.FunctionId
							WHERE   FO.DocumentNo = '#Document#' 
							AND     A.UserAccount = '#SESSION.acc#' 
							</cfquery>
						</cftransaction>
							
							<cfif Roster.recordcount gt "0">
								<cfset AccessLevel = "0">
							</cfif>
														  
					<cfelse>
					
					  <CFSET AccessLevel = qAccess.AccessLevel>
					  
					</cfif>	  
								 
			 </cfif>	 
		
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 3.6b Recruitment officer : old vacancy candidate access  --->
		
	<cffunction access="public" 
	            name="VacancyHeader" 
				output="true" 
				returntype="string" 
				displayname="Verify Document Access">
				
		<cfargument name="Mission" type="string" required="true">
		<cfargument name="Source" type="string" required="true" default="AppsVacancy">

		<cftransaction isolation="read_uncommitted">						
	   		<cfquery name="qAccess" 
	            datasource="#source#" 
	            maxrows=1 
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
				SELECT Max(AccessLevel) as AccessLevel
	            FROM   ActionAuthorization A
		        WHERE  A.UserAccount  = '#SESSION.acc#'
				AND    (A.Mission       = '#Mission#' OR A.Mission = 'All Missions') 
			</cfquery>
		</cftransaction>
		
		<cfif getAdministrator(mission) eq "1">	
		
	          <CFSET AccessLevel = "2">
		
		<cfelseif qAccess.AccessLevel eq '1' or qAccess.AccessLevel eq '2'>

	          <CFSET AccessLevel = '2'>
		  
		<cfelseif qAccess.AccessLevel eq '0'> 
		
		      <CFSET AccessLevel = '0'>
		 		 		        
        <cfelse>
		
		      <CFSET AccessLevel = '9'>
		
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
		
		
	<!--- 3.7 Recruitment officer : vacancy tree access --->
		
	<cffunction access="public" 
	            name="VacancyTree" 
				output="true" 
				returntype="string" 
				displayname="Verify Document Access">
				
		<cfargument name="Mission"  type="string" required="false" default="">
		<cfargument name="PostType" type="string" required="false" default="">
		
		<cfif getAdministrator(mission) eq "1">			
		
	        <CFSET AccessLevel = "2">
        
		<cfelse>
			<cftransaction isolation="read_uncommitted">
		   		<cfquery name="qAccess" 
		            datasource="appsOrganization" 
		            maxrows=1 
		            username="#SESSION.login#" 
		            password="#SESSION.dbpw#">
					SELECT DISTINCT Mission
		            FROM  OrganizationAuthorization A
			        WHERE A.UserAccount    = '#SESSION.acc#'
					<cfif Mission neq "">
					AND  (A.Mission         = '#Mission#' OR A.Mission is NULL)
					</cfif>
					<!--- this role works in conjunction, does not replace VacProcess here
					AND (A.Role IN ('VacProcess','VacOfficer','HROfficer')) 
					--->
					AND  A.Role IN ('VacOfficer','HROfficer')
					<cfif PostType neq "">
					AND  A.ClassParameter = '#PostType#' 
					</cfif>
				</cfquery>
			</cftransaction>
			
			<cfif qAccess.recordcount gte '1'>
	
	          <CFSET AccessLevel = "1">
			 		 		        
	        <cfelse>
			
			  <CFSET AccessLevel = "9">
			
			 </cfif>
		 
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 3.8a Roster officer officer : roster access --->
		
	<cffunction access="public" name="Roster" output="true" returntype="string" displayname="Bucket Access">
	
		<cfargument name="Owner"        type="string" default="" required="false">
		<cfargument name="AccessLevel"  type="string" default="" required="false">
		<cfargument name="FunctionId"   type="string" default="" required="false"> <!--- only for deeper level --->
		<cfargument name="BucketCheck"  type="string" default="1" required="false">
		<cfargument name="Role"         type="string" required="true" default="'AdminRoster', 'RosterClear'">
		
		<cfif SESSION.isAdministrator eq "Yes" or (owner neq "" and findNoCase(owner,SESSION.isOwnerAdministrator))>
		
          <CFSET AccessLevel = '1'>
        
		<cfelse>
			<cftransaction isolation="read_uncommitted">						
			<cfquery name="qAccess" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    TOP 1 * 
				FROM      OrganizationAuthorization
				WHERE     UserAccount = '#SESSION.acc#' 
				AND       Role IN (#preserveSingleQuotes(role)#) 
				<cfif Owner neq "">
				AND       ClassParameter = '#Owner#'
				</cfif>
				<cfif AccessLevel neq "">
				AND       AccessLevel = '#AccessLevel#'
				<!--- before was AccessLevel >= '#AccessLevel#' --->
				</cfif>
				ORDER BY AccessLevel DESC
			</cfquery>
			</cftransaction>
									
			<cfif qAccess.recordcount gte '1'>
	
			  <CFSET AccessLevel = qAccess.AccessLevel>
			  <cfif AccessLevel eq "2">
			       <!--- set ALL to EDIT here 10/6/06 --->
				   <cfset AccessLevel = "1">
			  </cfif>
									
			<cfelseif functionId neq "" and bucketcheck eq "1">
				<cftransaction isolation="read_uncommitted">
				<cfquery name="qAccess" 
					datasource="appsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    RosterAccessAuthorization
					WHERE   FunctionId = '#FunctionId#'
					AND     UserAccount = '#SESSION.acc#'
					AND     Role IN (#preserveSingleQuotes(role)#) 
					<cfif  AccessLevel neq "">
					AND       AccessLevel = '#AccessLevel#'
					</cfif>
				 </cfquery>
				 </cftransaction>	
				 
				 <cfif qAccess.recordcount gte "1">
				 
					 <CFSET AccessLevel = qAccess.AccessLevel>
				 
				 <cfelse>
				
					 <CFSET AccessLevel = "9">
				
				 </cfif>
				 
			<cfelse>
			
				 <CFSET AccessLevel = "9">
				 
			</cfif> 
		 
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 3.8b Candidate Review officer : clearance --->
	
	<cffunction access="public" name="CandidateReview" output="true" returntype="string" displayname="Candidate Review">
		<cfargument name="Owner" type="string" default="" required="false">
		<cfargument name="Class" type="string" default="" required="false">
		<cfargument name="AccessLevel" type="string" default="" required="false">
		<cfargument name="Role" type="string" required="true" default="'CandidateReview'">
		
		<cfif SESSION.isAdministrator eq "Yes" or (owner neq "" and findNoCase(owner,SESSION.isOwnerAdministrator))>
		
          <CFSET AccessLevel = "1">
        
		<cfelse>
			<cftransaction isolation="read_uncommitted">			
				<cfquery name="qAccess" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    TOP 1 * 
					FROM      OrganizationAuthorization
					WHERE     UserAccount = '#SESSION.acc#' 
					AND       Role IN (#preserveSingleQuotes(role)#) 
					<cfif Owner neq "">
					AND       GroupParameter = '#Owner#'
					</cfif>
					<cfif Class neq "">
					AND       ClassParameter IN (SELECT ActionCode 
					                             FROM Ref_EntityAction 
												 WHERE EntityCode = 'Rev#Class#')
					</cfif>
					<cfif AccessLevel neq "">
					AND       AccessLevel = '#AccessLevel#'				
					</cfif>
					ORDER BY AccessLevel DESC
				</cfquery>
			</cftransaction>
									
			<cfif qAccess.recordcount gte '1'>
	
			  <CFSET AccessLevel = qAccess.AccessLevel>
			  <cfif AccessLevel eq "2">
			       <!--- set ALL to EDIT here 10/6/06 --->
				   <cfset AccessLevel = "1">
			  </cfif>		
				 
			<cfelse>
			
				 <CFSET AccessLevel = '9'>
				 
			</cfif> 
		 
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>		
	
	<!--- 3.8 Bucket officer : roster access --->
		
	<cffunction access="public" name="Bucket" output="true" returntype="string" displayname="Bucket Access">
	
		<cfargument name="FunctionId" type="string" required="true">
		<cfargument name="Level"      type="string" default="">
		<cfargument name="Source"     type="string" required="false" default="">
		
		<cftransaction isolation="read_uncommitted">
			<cfquery name="get" 
					datasource="appsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   FunctionOrganization FO, Ref_SubmissionEdition S
					WHERE  FO.SubmissionEdition = S.SubmissionEdition
					AND    FunctionId     = '#FunctionId#' 								
			</cfquery>
			
			<cfif SESSION.isAdministrator eq "Yes" or findNoCase(get.owner,SESSION.isOwnerAdministrator)>
			
	          <CFSET AccessLevel = '1'>
	        
			<cfelse>
							
				<cfquery name="qAccess" 
					datasource="appsSelection" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM  RosterAccessAuthorization A
					WHERE A.FunctionId     = '#FunctionId#' 				
					<cfif Level neq "All">
					AND   A.AccessLevel    = '#Level#'
					</cfif>
					<cfif Source neq "">
					AND   A.Source = '#Source#'
					</cfif>
					AND   A.UserAccount    = '#SESSION.acc#' 
				</cfquery>
				
				<cfif qAccess.recordcount gte '1'>
		
				  <CFSET AccessLevel = '1'>
										
				<cfelse>
				
				  <CFSET AccessLevel = '9'>
				
				 </cfif>
			 
			 </cfif>
		</cftransaction>
					 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- ------------------------------------ --->	
	<!--- 3.9 ePass officer : very old for SAT --->
	<!--- ------------------------------------ --->
		
	<cffunction access="public" name="ePas" output="true" returntype="string" displayname="Bucket Access">
		<cfargument name="ContractId" type="string" required="true">
		<cfargument name="PersonNo"   type="string" required="true">
		
		<cftransaction isolation="read_uncommitted">										
	   		<cfquery name="qAccess" 
	            datasource="appsePas" 
	            maxrows=1 
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
				SELECT *
	            FROM  ContractActor A
		        WHERE A.Contract     = '#ContractId#' 
				AND   A.PersonNo     = '#PersonNo#' 
			</cfquery>
		</cftransaction>
		
		<cfif qAccess.recordcount gte '1'>

          <CFSET AccessLevel = '1'>
		 		 		        
        <cfelse>
		
		  <CFSET AccessLevel = '9'>
		
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 3.10 Payroll Admin --->
		
	<cffunction access="public" 
	            name="PayrollOfficer" 
				output="true" 
				returntype="string" 
				displayname="Verify Document Access">
				
		<cfargument name="Mission" type="string" required="true" default="BONUCA">
				
		<cfif getAdministrator("#mission#") eq "1">
		
	        <CFSET AccessLevel = "2">
        
		<cfelse>
			<cftransaction>
		   		<cfquery name="qAccess" 
		            datasource="appsOrganization" 
	            	maxrows=1 
	            	username="#SESSION.login#" 
	            	password="#SESSION.dbpw#">
					SELECT Max(AccessLevel) as AccessLevel
	            	FROM  OrganizationAuthorization A
		        	WHERE A.UserAccount    = '#SESSION.acc#'
					AND (A.Mission         = '#Mission#' OR A.Mission is NULL)
					AND (A.Role IN ('PayrollOfficer')) 
				</cfquery>
			</cftransaction>	
			
			<CFSET AccessLevel = qAccess.AccessLevel>  
					 
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- 3.11 Candidate Clear Access --->
		
	<cffunction access="public" 
	            name="CandidateClear" 
				output="true" 
				returntype="string" 
				displayname="Verify Candidate Clear/Event Access">
		
		<cfargument name="Owner" type="string" required="true" default="">		
				
		<cfif SESSION.isAdministrator eq "Yes">
		
	        <CFSET AccessLevel = "2">
        
		<cfelse>
			<cftransaction isolation="read_uncommitted">
		   		<cfquery name="qAccess" 
		            datasource="appsOrganization" 
		            maxrows=1 
		            username="#SESSION.login#" 
		            password="#SESSION.dbpw#">
					SELECT Max(AccessLevel) as AccessLevel
		            FROM  OrganizationAuthorization A
			        WHERE A.UserAccount    = '#SESSION.acc#'
					<cfif owner neq "">
					AND  A.GroupParameter     = '#Owner#'
					</cfif>
					AND A.Role IN ('CandidateClear') 
				</cfquery>
			</cftransaction>
			
			<CFSET AccessLevel = qAccess.AccessLevel>  
					 
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
	<cffunction access="public" 
	            name="TravelClaimOfficer" 
				output="false" 
				returntype="string" 
				displayname="Verify Access">
		
		<cfargument name="OrgUnit" type="string" required="false" default="0">		
		<cfargument name="Role" type="string" required="true" default="'SSTravelClaim'">
		
		<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminTravelClaim" 
		  returnvariable="ManagerAccess">
								
		<cfif ManagerAccess is "EDIT" or ManagerAccess is "ALL" or SESSION.isAdministrator eq "Yes">
		
	   		<cfset AccessLevel = "2">		        
			
        <cfelse>
				<cftransaction isolation="read_uncommitted">    		
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#"> 
					SELECT Max(AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization  
					WHERE  UserAccount = '#SESSION.acc#' 
					AND    Role    IN (#preserveSingleQuotes(Role)#) 
					AND    Mission IN (SELECT Mission
									   FROM Organization 
									   WHERE  OrgUnit = '#OrgUnit#') 
	   				AND    OrgUnit is NULL				
					</cfquery>
				
					<cfif qAccess.AccessLevel eq "">
				
						<cfquery name="qAccess" 
						datasource="AppsOrganization" 
						maxrows=1 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT Max(AccessLevel) as AccessLevel 
						FROM OrganizationAuthorization
						WHERE  UserAccount = '#SESSION.acc#' 
						AND    OrgUnit = #OrgUnit# 
						AND    Role    IN (#preserveSingleQuotes(Role)#) 
						</cfquery>
					
					</cfif>
				</cftransaction>			

         	<cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = "9">
            <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
		 </cfif>
		 
		  <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 		 		
	</cffunction>	
			
	<!--- 4.1 Program Officer : access to program information based on orgunit, to be redefined --->
		
	<cffunction access="public" 
	            name="Organization" 
				output="true" 
				returntype="string" 
				displayname="Verify Program Access">
		
		<cfargument name="Mission"        type="string" required="false" default="">
		<cfargument name="OrgUnit"        type="string" required="false" default="0">		
		<cfargument name="Period"         type="string" required="false" default="FY 03/04">
		<cfargument name="Access"         type="string" required="true"  default="9">
		<cfargument name="Role"           type="string" required="true"  default="ProgramOfficer">
		<cfargument name="ClassParameter" type="string" required="false" default="">
				
        <!--- determine if user has manager access for particular role based on function code --->	
		<!--- to be adjusted through global roles --->
		
		<cfif mission eq "" and (OrgUnit neq "" and orgUnit neq "some")>
		
			<cftransaction isolation="read_uncommitted">
		
				<cfquery name="Org" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT *
					   FROM   Organization
					   WHERE  OrgUnit = '#OrgUnit#'						
				 </cfquery>
				 
			 </cftransaction>
			 
			 <cfset mission = org.mission>
					
		</cfif>
					
		<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="ManagerAccess">
								
		<cfif ManagerAccess is "EDIT" or 
		      ManagerAccess is "ALL" or 
			  getAdministrator(mission) eq "1">	
	   		
			 <cfset AccessLevel = '2'>
			
        <cfelse>
		
		    <cfif OrgUnit neq "0" and OrgUnit neq "" and orgUnit neq "some">
			
				<cftransaction isolation="read_uncommitted">
				
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#"> 
						SELECT MAX(AccessLevel) as AccessLevel
						FROM   OrganizationAuthorization  
						WHERE  UserAccount = '#SESSION.acc#' 
						AND    Role    IN ('#preserveSingleQuotes(Role)#') 
						<cfif classParameter neq "">
						AND    ClassParameter IN ('#classparameter#','default')  <!--- default was added to have backward support --->
						</cfif>
						AND    Mission = '#mission#'						
		   				AND    OrgUnit is NULL				
					</cfquery>
				
					<cfif qAccess.AccessLevel eq "">
				
						<cfquery name="qAccess" 
						datasource="AppsOrganization" 
						maxrows=1 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  Max(AccessLevel) as AccessLevel 
							FROM    OrganizationAuthorization
							WHERE   UserAccount = '#SESSION.acc#' 
							AND     OrgUnit = #OrgUnit# 							
							AND     Role    IN ('#preserveSingleQuotes(Role)#') 
							<cfif classParameter neq "">
							AND     ClassParameter = '#classparameter#'
							</cfif>
						</cfquery>
					
					</cfif>
					
				</cftransaction>		
				
			<cfelse>
			
				<cftransaction isolation="read_uncommitted">
				
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT MAX(AccessLevel) as AccessLevel
						FROM   OrganizationAuthorization
						WHERE  Mission     = '#Mission#' 
						AND    UserAccount = '#SESSION.acc#' 
						AND    Role  IN ('#preserveSingleQuotes(Role)#') 
						<cfif classParameter neq "">
						AND    ClassParameter = '#classparameter#'
						</cfif>						
						<cfif OrgUnit neq "some">
						AND    OrgUnit is NULL	
						</cfif>
					</cfquery>
					
				</cftransaction>
									
			</cfif>

         <cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = "9">
            <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
		 </cfif>
		 
		 <cfswitch expression="#AccessLevel#">
		 
		 <cfcase value="0">
		      <CFSET AccessRight = "READ">
		 </cfcase>
		 
		 <cfcase value="1">			<!--- extent of edit rights depend on period and if enabled --->
		 
		 	<cftransaction isolation="read_uncommitted">
			
	     		<cfquery name="ExpandRights" 
	            datasource="AppsProgram" 
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
	            SELECT MAX(Status) as Status
				FROM   ProgramPeriod Pe, Program P
				WHERE  Pe.Period      = '#Period#'
				AND    Pe.ProgramCode = P.ProgramCode
				<cfif OrgUnit neq "some">
					AND    Pe.OrgUnit = '#OrgUnit#'
				</cfif>
				</cfquery>
				
			</cftransaction>
		 
			<cfif ExpandRights.Status eq "0" or ExpandRights.Status eq "">
		      <CFSET AccessRight = "ALL">
			<cfelse>		 
		      <CFSET AccessRight = "EDIT">
			</cfif>		
			 
		 </cfcase>
		 
		 <cfcase value="2">
		      <CFSET AccessRight = 'ALL'>
		 </cfcase>
		 <cfcase value="8">
		      <CFSET AccessRight = 'NONE'>
		 </cfcase>
		 <cfcase value="9">
		      <CFSET AccessRight = 'NONE'>
		 </cfcase>
		 <cfdefaultcase>
		      <CFSET AccessRight = 'NONE'>
		 </cfdefaultcase>
		 </cfswitch>
						
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 4.2 Program Officer : access to program information --->
		
	<cffunction access="public" name="Program" output="true" returntype="string" displayname="Verify Program Access">
		
		<cfargument name="ProgramCode" type="string" required="true">
		<cfargument name="Period"      type="string" required="true"  default="FY 03/04">
		<cfargument name="Access"      type="string" required="true"  default="9">
		
		<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="ManagerAccess">
		  
		<cftransaction isolation="read_uncommitted">  		
			<cfquery name="Organization" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT *
			   FROM   Organization
			   WHERE  OrgUnit IN (SELECT OrgUnit
								  FROM   Program.dbo.ProgramPeriod
								  WHERE  ProgramCode = '#ProgramCode#'						
								  AND    Period      = '#Period#')						
			</cfquery>
		</cftransaction>	
		 
		<cfset mission = Organization.Mission>
			 							
		<cfif ManagerAccess is "EDIT" or ManagerAccess is "ALL">
		
	   		<cfset AccessLevel = "2">
			
		<cfelseif getAdministrator(mission) eq "1">		

          <CFSET AccessLevel = "2">
         
        <cfelse>
		
			<cftransaction isolation="read_uncommitted">
			    <!--- mission level --->
				<cfquery name="qAccess" 
	            datasource="AppsOrganization"            
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
		            SELECT MAX(AccessLevel) as AccessLevel
			        FROM   OrganizationAuthorization PA
		            WHERE  PA.UserAccount = '#SESSION.acc#' 
					AND    PA.OrgUnit is NULL
					AND    PA.Mission = '#mission#'			
					AND    PA.Role    = 'ProgramOfficer' 
				</cfquery>
				
												
				<!--- unit level --->
				
				<cfif qAccess.AccessLevel eq "">
			
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 				
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT MAX(AccessLevel) as AccessLevel
						FROM   OrganizationAuthorization PA, Program.dbo.ProgramPeriod PP
						WHERE  PA.UserAccount = '#SESSION.acc#' 
						AND    PP.ProgramCode = '#ProgramCode#'
						AND    PP.Period      = '#Period#'
						AND    PA.OrgUnit     = PP.OrgUnit
						AND    PA.Role       = 'ProgramOfficer'
					</cfquery>
				
				</cfif>
			</cftransaction>			
			 
            <cfif qAccess.AccessLevel eq "">
			
                <CFSET AccessLevel = "9">
				
            <cfelse>
                <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
			<cfif qAccess.AccessLevel lt "1">
			
				<cftransaction isolation="read_uncommitted">
					<cfquery name="qAccess" 
					datasource="AppsProgram"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   ProgramAccessAuthorization
						WHERE  UserAccount = '#SESSION.acc#' 
						AND    ProgramCode = '#ProgramCode#'
						AND    Role        = 'ProgramOfficer'					
					</cfquery>		
				</cftransaction>
					
				<cfif qAccess.recordcount eq "1">				
					<cfset AccessLevel = "1">					
				</cfif>
			
			</cfif>			
			
		 </cfif>
		 
		 <cfswitch expression="#AccessLevel#">
		 
		 <cfcase value="0">
		      <CFSET AccessRight = "READ">
		 </cfcase>
		 
		 <cfcase value="1">    <!--- extent of edit rights depend on program period and if enabled --->
		 
			<cftransaction isolation="read_uncommitted">
				<cfquery name="ExpandRights" 
            	datasource="AppsProgram" 
            	username="#SESSION.login#" 
            	password="#SESSION.dbpw#">
		            SELECT  Status
		        	FROM    ProgramPeriod Pe
					WHERE   Pe.Period      = '#Period#'	
					AND     Pe.ProgramCode = '#ProgramCode#'
				</cfquery>
			</cftransaction>
		 
			<cfif ExpandRights.Status eq "0" or ExpandRights.Status eq "">
		      <CFSET AccessRight = "ALL">
			<cfelse>		 
		      <CFSET AccessRight = "EDIT">
			</cfif>		
			 
		 </cfcase>
		 
		 <cfcase value="2">
		 
		      <CFSET AccessRight = "ALL">
			  
		 </cfcase>
		 
		 <cfcase value="9">
		 
		      <CFSET AccessRight = "NONE">
			  
		 </cfcase>
		 
		 <cfdefaultcase>
		      <CFSET AccessRight = "NONE">
		 </cfdefaultcase>
		 
		 </cfswitch>
						
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 4.3 Progress Officer : access to progress information, to be redefined --->
		
	<cffunction access="public" name="ProgramProgress" output="true" returntype="string" displayname="Verify Program Access">
		
		<cfargument name="ProgramCode" type="string" required="false" default="">
		<cfargument name="Period"      type="string" required="false" default="">
		<cfargument name="OrgUnit"     type="string" required="false" default="0">
		<cfargument name="Access"      type="string" required="true"  default="9">
		<cfargument name="Role"        type="string" required="true"  default="ProgressOfficer">
		
        <!--- determine if user has manager access for particular role based on function code --->	
		<!--- to be adjusted through global roles --->
							  
		<cfif ProgramCode neq "">
		  
		  	  <cftransaction isolation="read_uncommitted">
				  	<cfquery name="Prg" 
				  	datasource="AppsProgram" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
			      	SELECT *
			      	FROM   Program
			      	WHERE  Mission = '#ProgramCode#'						
		        	</cfquery>
				</cftransaction>
				
				<cfset mission = prg.mission> 
		  
		<cfelse>
		 		<cftransaction isolation="read_uncommitted">
					<cfquery name="Org" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Organization
				      WHERE  OrgUnit = '#OrgUnit#'						
			        </cfquery>
			     </cftransaction>
				
				<cfset mission = org.mission> 
				
		</cfif>		
		
		<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="ManagerAccess">				  
								
		<cfif ManagerAccess is "EDIT" or ManagerAccess is "ALL">
		
	   	   <cfset AccessLevel = "2">

		<cfelseif getAdministrator(mission) eq "1">	
			
           <cfset AccessLevel = "2">
        
        <cfelse>
			<cftransaction isolation="read_uncommitted">
	     		<cfquery name="qAccess" 
	            datasource="AppsOrganization"             
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
		            SELECT MAX(AccessLevel) as AccessLevel
			        FROM   OrganizationAuthorization
		            WHERE  UserAccount = '#SESSION.acc#' 
			        AND    OrgUnit     = '#OrgUnit#'
					AND    Role        = '#Role#'
				</cfquery>
	
		         <cfif qAccess.AccessLevel eq "">
				 	
			   		<cfquery name="qAccess" 
			            datasource="AppsOrganization" 		           
			            username="#SESSION.login#" 
			            password="#SESSION.dbpw#">
			            SELECT MAX(AccessLevel) as AccessLevel
				        FROM   OrganizationAuthorization
			            WHERE  UserAccount = '#SESSION.acc#' 
				        AND    OrgUnit is null
						AND    Role    = '#Role#'
						AND    Mission = '#mission#'				
				    </cfquery>
					
			 	 </cfif>
		 	 </cftransaction>
			 			 
			 <cfif qAccess.AccessLevel eq "" or qAccess.AccessLevel eq "0">
                <CFSET AccessLevel = "9">
             <cfelse>
                <CFSET AccessLevel = qAccess.AccessLevel>
	         </cfif>	  
			
			 <cfif qAccess.AccessLevel lt "1" and ProgramCode neq "">
			 
				<cftransaction isolation="read_uncommitted">		
					 			
					<cfquery name="qAccess" 
					datasource="AppsProgram"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   ProgramAccessAuthorization
						WHERE  UserAccount = '#SESSION.acc#' 
						
						AND    (
						        ProgramCode = '#ProgramCode#'
						
							    <cfif period neq "">
								
						         or ProgramCode IN ( SELECT PeriodParentCode 
						                             FROM   ProgramPeriod 
												     WHERE  ProgramCode = '#ProgramCode#'
													 AND    Period      = '#Period#'
													)
							    </cfif>						
							   )
						AND    Role        = '#Role#'		
								
					</cfquery>		
					
				</cftransaction>			
				
									
				<cfif qAccess.recordcount eq "1">							
					<cfset AccessLevel = "1">					
				</cfif>
					
			 </cfif>				
			
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 4.4. BUDGET Officer : access to program information --->
	
	<cffunction access="public" name="Budget" output="true" returntype="string" displayname="Verify Budget Access">
		
		<cfargument name="ProgramCode" type="string" required="true"  default="">
		<cfargument name="Period"      type="string" required="true"  default="">
		<cfargument name="Mission"     type="string" required="false" default="">
		<cfargument name="EditionId"   type="string" required="false" default="">
		<cfargument name="Role"        type="string" required="false" default="'BudgetOfficer','BudgetManager'">
		<cfargument name="Scope"       type="string" required="false" default="Unit">
		<cfargument name="Access"      type="string" required="true"  default="9">
				
		<cfif not find("'",editionid)>		
		   <cfset editionlist = "">		   
		   <cfloop index="itm" list="#editionid#">		  
		     <cfif editionlist eq "">
			    <cfset editionlist = "'#itm#'">
			 <cfelse>
			    <cfset editionlist = "#editionlist#,'#itm#'">
			 </cfif>
		   </cfloop>	
		   <cfset editionid = editionlist>			
		</cfif>
				
		
		<cfif mission eq "">
			<cftransaction isolation="read_uncommitted">
				<cfquery name="Organization" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT *
				   FROM   Organization
				   WHERE  OrgUnit IN (SELECT OrgUnit
									  FROM   Program.dbo.ProgramPeriod
									  WHERE  ProgramCode = '#ProgramCode#'						
									  AND    Period      = '#Period#')						
				</cfquery>
			</cftransaction>
			 
			<cfset mission = Organization.Mission>
						
		</cfif>
		
		<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="ManagerAccess">		  		  
								
		<cfif ManagerAccess is "EDIT" or ManagerAccess is "ALL">
		
	   		<cfset AccessLevel = '2'>
			
		<cfelseif getAdministrator(mission) eq "1">		

            <CFSET AccessLevel = '2'>
				         
        <cfelse>
				
		
			<!--- mission level --->
			<cftransaction isolation="read_uncommitted">		
					
				<cfquery name="qAccess" 
	            datasource="AppsOrganization" 
	            maxrows=1 
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
	            SELECT MAX(AccessLevel) as AccessLevel
		        FROM   OrganizationAuthorization
	            WHERE  UserAccount = '#SESSION.acc#' 			
				<cfif EditionId neq "">			
					AND    ClassParameter IN (#preservesinglequotes(editionid)#)  
				</cfif>
				AND    Mission = '#Mission#' 
				<cfif Scope is "Unit">					  
				AND    OrgUnit is NULL
				</cfif>
				AND    Role    IN (#preservesinglequotes(role)#) 		
				</cfquery>
			</cftransaction>
											
			<!--- unit level --->
			
			<cfif qAccess.AccessLevel eq "" or qAccess.AccessLevel eq "READ">
			
				<cftransaction isolation="read_uncommitted">	
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT ISNULL(Max(AccessLevel),0) as AccessLevel
					FROM   OrganizationAuthorization PA, Program.dbo.ProgramPeriod PP
					WHERE  PA.UserAccount    = '#SESSION.acc#' 
					AND    PP.ProgramCode    = '#ProgramCode#'
					AND    PP.Period         = '#Period#'				
					AND    PA.OrgUnit = PP.OrgUnit
					AND    PA.Role IN (#preservesinglequotes(role)#)  
					<cfif editionid neq "">
					AND    PA.ClassParameter IN (#preservesinglequotes(editionid)#)
					</cfif>
					</cfquery>
				</cftransaction>	
								
				<cfif qAccess.AccessLevel eq "0" or qAccess.AccessLevel eq "READ">
					<cftransaction isolation="read_uncommitted">			
						<cfquery name="qAccess" 
						datasource="AppsProgram" 
						maxrows=1 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT ISNULL(max(AccessLevel),0) as AccessLevel
						FROM   ProgramAccessAuthorization PA
						WHERE  PA.UserAccount    = '#SESSION.acc#' 
						AND    PA.ProgramCode    = '#ProgramCode#'
						AND    PA.Role IN (#preservesinglequotes(role)#)
						</cfquery>
					</cftransaction>
													
				</cfif>
			
			</cfif>
			   
            <cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = '9'>
            <cfelse>
              <CFSET AccessLevel = qAccess.AccessLevel>
	        </cfif>	  
			
		 </cfif>
	   		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>	
	
	<!--- 4.5 Indicator Officer : access to program information based on orgunit, to be redefined --->
		
	<cffunction access="public" name="Indicator" output="true" returntype="string" displayname="Verify Program Access">
		
		<cfargument name="OrgUnit"   type="string" required="false" default="0">
		<cfargument name="Indicator" type="string" required="false" default="">
		<cfargument name="Role"      type="string" required="true"  default="ProgramAuditor">
				
        <!--- determine if user has manager access for particular role based on function code --->	
		<!--- to be adjusted through global roles --->
					
		<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="ManagerAccess">
		
		<cftransaction isolation="read_uncommitted">  
			<cfquery name="Org" 
		   	datasource="AppsOrganization" 
		   	username="#SESSION.login#" 
		   	password="#SESSION.dbpw#">
			   	SELECT *
			   	FROM Organization
			   	WHERE OrgUnit = '#OrgUnit#'						
			</cfquery>
		
		
			 
		<cfset mission = org.mission> 		  
								
		<cfif ManagerAccess is "EDIT" or ManagerAccess is "ALL">
		
	   		<cfset AccessLevel = '2'>

		<cfelseif getAdministrator(mission) eq "1">	
		
            <CFSET AccessLevel = '2'>  		
		        
        <cfelse>
		
		    <cfif OrgUnit neq "0">
				
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT MAX(AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization  
					WHERE  UserAccount = '#SESSION.acc#' 
					<cfif indicator neq "">
					AND    ClassParameter IN (#preserveSingleQuotes(Indicator)#) 
					</cfif>
					AND    Role    IN ('#preserveSingleQuotes(Role)#') 
					AND    Mission = '#mission#'				
	   				AND    OrgUnit is not NULL			
					</cfquery>
				
					<cfif qAccess.AccessLevel eq "">
				
						<cfquery name="qAccess" 
						datasource="AppsOrganization" 
						maxrows=1 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  Max(AccessLevel) as AccessLevel 
							FROM    OrganizationAuthorization
							WHERE   UserAccount = '#SESSION.acc#' 
							<cfif indicator neq "">
							AND     ClassParameter IN (#preserveSingleQuotes(Indicator)#) 
							</cfif>
							AND     (OrgUnit = '#OrgUnit#' or OrgUnit is null)
							AND     Role    IN ('#preserveSingleQuotes(Role)#') 
						</cfquery>
					
					</cfif>
				
							
			<cfelse>
			
				<cfquery name="qAccess" 
				datasource="AppsOrganization" 
				maxrows=1 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT Max(AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization
					WHERE  UserAccount = '#SESSION.acc#' 
					AND    Role  IN ('#preserveSingleQuotes(Role)#')
					<cfif indicator neq "">
					AND    ClassParameter = '#Indicator#' 
					</cfif>
					AND    Mission = '#Mission#' 
					AND    OrgUnit is NULL				   
				</cfquery>
					
			</cfif>

           <cfif qAccess.RecordCount eq "0">
              <CFSET AccessLevel = '9'>
           <cfelse>
              <CFSET AccessLevel = '#qAccess.AccessLevel#'>
	        </cfif>	  
			
		 </cfif>
		 </cftransaction>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>		 
		
	</cffunction>
	
	<!--- 5.1 General accountant : access to GL Information --->
	
	<cffunction access="public" name="Journal" output="true" returntype="string" displayname="Verify Journal Access">
		
		<cfargument name="Journal" type="string" required="true">
		<cfargument name="OrgUnit" type="string" required="true" default="0">
		
			<cftransaction isolation="read_uncommitted">
			<cfquery name="get" 
				datasource="AppsLedger" 				
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Journal
				WHERE  Journal = '#Journal#'				
			</cfquery>
			</cftransaction>		    
			
			<cfif getAdministrator(get.mission) eq "1">	
    		
		        <CFSET AccessLevel = '2'>
         
            <cfelse>	
				<cftransaction isolation="read_uncommitted">
					<cfquery name="Org" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization
					WHERE  OrgUnit = '#OrgUnit#'				
					</cfquery>
					
					<cfquery name="qAccess" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT MAX(AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization PA
					WHERE  PA.UserAccount    = '#SESSION.acc#' 
					<cfif orgunit neq "0" and orgunit neq "">
					AND    (PA.OrgUnit        = '#OrgUnit#' OR (PA.OrgUnit is NULL and PA.Mission = '#Org.Mission#'))
					</cfif>
					
					<cfif Journal neq "0">
					AND    PA.ClassParameter = '#Journal#'
					</cfif>
					AND    PA.Role           = 'Accountant' 
					</cfquery>					
		   
					<cfif qAccess.RecordCount eq "0">
					  <CFSET AccessLevel = '9'>
					<cfelse>
					  <CFSET AccessLevel = '#qAccess.AccessLevel#'>
					</cfif>	  
					
				</cftransaction>				
			</cfif>
				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 6.0 Requistion role --->
	
	<cffunction access="public" name="ProcRole" output="true" returntype="string" displayname="Verify Procurement account">
				
		<cfargument name="Mission" type="string" required="true" default="">
		<cfargument name="Role"    type="string" required="true" default="ProcReqReview">
		<cfargument name="OrgUnit" type="string" required="true" default="0">
			
		<cftransaction isolation="read_uncommitted">
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessLevel = '2'>
         
            <cfelse>
						
			    <cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
		         SELECT * FROM Organization
		         WHERE OrgUnit = '#OrgUnit#'
		        </cfquery>
		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT max(A.AccessLevel) as AccessLevel
				FROM OrganizationAuthorization A
				WHERE UserAccount = '#SESSION.acc#'
				AND  ((Mission = '#Mission#' AND OrgUnit is NULL)
					  OR
					 (OrgUnit IN (SELECT OrgUnit 
					              FROM Organization 
								  WHERE  Mission           = '#Org.Mission#'
								    AND  MandateNo         = '#Org.MandateNo#'  
								    AND  OrgUnitCode       = '#Org.HierarchyRootUnit#'))
					  OR
					 (OrgUnit = '#OrgUnit#'))			  
				AND  UserAccount = '#SESSION.acc#'
				AND  Role IN (#preservesinglequotes(Role)#)   
			   </cfquery>	
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = '#qAccess.AccessLevel#'>
				</cfif>	  
				
				</cfif>
		 </cftransaction>		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
		
	
	<!--- 6.3 Procurement approver--->
	
	<cffunction access="public" name="ProcApprover" output="true" returntype="string" displayname="Verify Procurement account">
		
		<cfargument name="Mission"    type="string" required="false" default="0">
		<cfargument name="OrgUnit"    type="string" required="true" default="0">
		<cfargument name="OrderClass" type="string" required="true" default="">
		
		<cftransaction isolation="read_uncommitted">	
			<cfif getAdministrator(mission) eq "1">	
    		
		        <CFSET AccessLevel = "2">
         
            <cfelse>
			
				<cfif orgunit neq "0">
			
				    <cfquery name="Org" 
		             datasource="AppsOrganization" 
		             username="#SESSION.login#" 
		             password="#SESSION.dbpw#">
				         SELECT * 
						 FROM   Organization
				         WHERE  OrgUnit = '#OrgUnit#'
			        </cfquery>
											
			        <cfquery name="qAccess" 
	           	    datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT MAX(A.AccessLevel) as AccessLevel
						FROM   OrganizationAuthorization A
						WHERE  UserAccount = '#SESSION.acc#'
						AND    (
						       
							   	(Mission = '#Org.Mission#' AND OrgUnit is NULL)
							    OR
							    (OrgUnit IN (SELECT OrgUnit 
							                 FROM   Organization 
										     WHERE  Mission           = '#Org.Mission#'
										     AND    MandateNo         = '#Org.MandateNo#'  
										     AND    OrgUnitCode       = '#Org.HierarchyRootUnit#'))
							    OR
							   (OrgUnit = '#OrgUnit#')
							  )			  						
						AND   Role = 'ProcApprover'
						<cfif orderclass neq "">
						AND   ClassParameter = '#OrderClass#'
						</cfif>
				   </cfquery>		
			   
			   	<cfelse>
				
				  <cfquery name="qAccess" 
	           	    datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT MAX(A.AccessLevel) as AccessLevel
						FROM   OrganizationAuthorization A
						WHERE  UserAccount = '#SESSION.acc#'
						AND    Mission     = '#Mission#'						
						AND    Role        = 'ProcApprover'
						<cfif orderclass neq "">
						AND    ClassParameter = '#OrderClass#'
						</cfif>
				   </cfquery>					
				
				</cfif>	   
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
			</cfif>
		 
		 </cftransaction>		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<cffunction access="public" name="ProcJob" output="true" returntype="string" displayname="Verify Procurement receipt">
		
		<cfargument name="JobNo" type="string" required="true" default="0">
			
			<cftransaction isolation="read_uncommitted">	    
			<cfquery name="get" 
           	    datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT *
				  FROM   Job 
				  WHERE  JobNo  = '#JobNo#'
		    </cfquery>
		    </cftransaction>	
			
			<cfif getAdministrator(get.mission) eq "1">	
    		
		        <CFSET AccessLevel = '2'>
         
            <cfelse>
				<cftransaction isolation="read_uncommitted">
		        <cfquery name="qAccess" 
           	    datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT *
				  FROM   JobActor J 
				  WHERE  J.JobNo  = '#JobNo#'		
				  AND    ActorUserId = '#SESSION.acc#'
			    </cfquery>	
			    </cftransaction>
				   
				<cfif qAccess.recordcount gte "1">
				  
				  <CFSET AccessLevel = '2'>
				  
				<cfelse>
				
					<!--- included the purchase approver to have job rights to edit and cancel the job --->
					<cftransaction isolation="read_uncommitted">								
						<cfquery name="qAccess" 
			             datasource="AppsOrganization" 
			             username="#SESSION.login#" 
			             password="#SESSION.dbpw#">
						    SELECT *
					        FROM  OrganizationAuthorization
							WHERE UserAccount    = '#SESSION.acc#'
							AND   Role           = 'ProcApprover'
							AND   ClassParameter = '#get.OrderClass#'
							AND   Mission        = '#get.Mission#'
							AND   AccessLevel IN ('1','2')
				        </cfquery>
			        </cftransaction>
					
					<cfif qAccess.recordcount gte "1">
					
						 <CFSET AccessLevel = '2'>
						 
					<cfelse>
					
						 <CFSET AccessLevel = '0'>	 
					
					</cfif>
					  
				  
				</cfif>	  
				
			</cfif>
				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 6.4 Receipt officer--->
	
	<cffunction access="public" name="ProcRI" output="true" returntype="string" displayname="Verify Procurement receipt">
				
		<cfargument name="OrgUnit"           type="string" required="true"  default="0">
		<cfargument name="MissionOrgUnitId"  type="string" required="false" default="">
		<cfargument name="OrderClass"        type="string" required="false" default="">
		
			<cftransaction isolation="read_uncommitted">
			
		 	<cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
		        	SELECT * 
					 FROM   Organization
			         WHERE  OrgUnit = '#OrgUnit#'
		    </cfquery>
							
			<cfif Org.recordcount eq "0" and MissionOrgUnitId neq "">
				
				  <cfquery name="Org" 
		             datasource="AppsOrganization" 
		             username="#SESSION.login#" 
		             password="#SESSION.dbpw#">
			        	 SELECT * 
						 FROM   Organization
				         WHERE  MissionOrgUnitId = '#MissionOrgUnitId#'
			        </cfquery>
				
			</cfif>		
			
			<cfif getAdministrator(org.mission) eq "1">	    
			
		        <CFSET AccessLevel = '2'>
         
            <cfelse>		   
		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MAX(A.AccessLevel) as AccessLevel
				FROM   OrganizationAuthorization A
				WHERE  UserAccount = '#SESSION.acc#'
				AND   (
				
				      (Mission = '#Org.Mission#' AND OrgUnit is NULL)
					 
					  OR
					  OrgUnit IN (SELECT OrgUnit 
					              FROM   Organization 
								  WHERE  Mission           = '#Org.Mission#'
								    AND  MandateNo         = '#Org.MandateNo#'  
								    AND  OrgUnitCode       = '#Org.HierarchyRootUnit#') 
					  OR
					  OrgUnit = '#OrgUnit#' 
					  
					  <cfif missionorgunitid neq "">
					  OR
					  OrgUnit IN (SELECT OrgUnit
					              FROM   Organization
								  WHERE  MissionOrgUnitId = '#MissionOrgunitId#')
					  </cfif>
					 					 
					 )			  
				AND  UserAccount = '#SESSION.acc#'
				AND  Role = 'ProcRI'
				<cfif orderclass neq "">
				AND  ClassParameter = '#OrderClass#'
				</cfif>
			   </cfquery>	
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
				</cfif>
		 </cftransaction> 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 6.5 List of facilities that have been granted access --->
	
	<cffunction access="public" name="WarehouseAccessList" output="true" returntype="string" displayname="Facility access list">
				
		<cfargument name="Mission"       type="string" required="true" default="">
		<cfargument name="AccessLevel"   type="string" required="true" default="">
		<cfargument name="Role"          type="string" required="true" default="'WhsPick'">
		<cfargument name="FunctionName"  type="string" required="true" default="">
		<cfargument name="FunctionClass" type="string" required="true" default="StockTask">
				
		<cftransaction isolation="read_uncommitted">
		
		<cfif getAdministrator(mission) eq "1">	
		
			<cfquery name="qWarehouse" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Warehouse
				WHERE 	Mission = '#mission#' 							
		   	</cfquery>
        		              
        <cfelse>		
		
			<cfquery name="qWarehouse" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Warehouse
				WHERE 	Mission = '#mission#' 								

				AND     MissionOrgUnitId IN
				
				           (
						   
			                  SELECT DISTINCT O.MissionOrgUnitId 
			                  FROM   Organization.dbo.Organization O, 
							         Organization.dbo.OrganizationAuthorization OA
							  WHERE  O.Mission      = '#Mission#'
							  AND    O.OrgUnit      = OA.OrgUnit
							  AND    OA.UserAccount = '#SESSION.acc#'											  
							  AND    OA.Role        IN (#preservesinglequotes(role)#)  
							  <cfif accesslevel neq "">
							  AND    OA.AccessLevel IN (#preservesinglequotes(accesslevel)#) 
							  </cfif>
							  <cfif FunctionName neq "">
							  AND   ClassParameter IN (							  						   
									   SELECT SystemFunctionId 
			                           FROM   System.dbo.Ref_ModuleControl
									   WHERE  FunctionClass = '#FunctionClass#'
									   AND    FunctionName  = '#FunctionName#'													   
									)
							  </cfif>
							 			
							  UNION
							  
							  SELECT DISTINCT O.MissionOrgUnitId 
			                  FROM   Organization.dbo.Organization O, 
							         Organization.dbo.OrganizationAuthorization OA
							  WHERE  O.Mission  = '#Mission#'
							  AND    O.Mission = OA.Mission
							  AND    (OA.OrgUnit is NULL or OA.OrgUnit = 0)
							  AND    OA.UserAccount = '#SESSION.acc#'											  
							  AND    OA.Role        IN (#preservesinglequotes(role)#)  
							   <cfif accesslevel neq "">
							  AND    OA.AccessLevel IN (#preservesinglequotes(accesslevel)#) 
							  </cfif>
							  <cfif FunctionName neq "">
							  AND   ClassParameter IN (							  						   
									   SELECT SystemFunctionId 
			                           FROM   System.dbo.Ref_ModuleControl
									   WHERE  FunctionClass = '#FunctionClass#'
									   AND    FunctionName  = '#FunctionName#'													   
									   )
							  </cfif>
																				  
						   )	
		   
				</cfquery>
			
		</cfif>
		</cftransaction>
		
		<cfset AccessRight = quotedValueList(qWarehouse.warehouse)>
		<cfreturn AccessRight>
	
	</cffunction>
				
	<!--- 7.1 Asset manager--->
	
	<cffunction access="public" name="AssetManager" output="true" returntype="string" displayname="Property Management">
		
		<cfargument name="OrgUnit"    type="string" required="true" default="0">
		<cfargument name="Mission"    type="string" required="true" default="">
		<cfargument name="AssetClass" type="string" required="true" default="">
			<cftransaction isolation="read_uncommitted">
			
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessLevel = '2'>
         
            <cfelse>
			
			    <cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
		         SELECT * FROM Organization
		         WHERE OrgUnit = '#OrgUnit#'
		        </cfquery>
		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT max(A.AccessLevel) as AccessLevel
				FROM OrganizationAuthorization A
				WHERE UserAccount = '#SESSION.acc#'
				AND  (
					     (Mission = '#Mission#' AND OrgUnit is NULL)
						  OR
						 (OrgUnit IN (SELECT OrgUnit 
						              FROM Organization 
									  WHERE  Mission           = '#Org.Mission#'
									    AND  MandateNo         = '#Org.MandateNo#'  
									    AND  OrgUnitCode       = '#Org.HierarchyRootUnit#'))
						  OR
						 (OrgUnit = '#OrgUnit#')
					 )			  
				AND  UserAccount    = '#SESSION.acc#'
				AND  Role           = 'AssetManager'
				AND  ClassParameter = '#AssetClass#'
			   </cfquery>	
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = '#qAccess.AccessLevel#'>
				</cfif>	  
				
		 </cfif>
		 </cftransaction>
				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<cffunction access="public" name="AssetManagerMission" output="true" returntype="string" displayname="Property Management">
		
		<cfargument name="Mission" type="string" required="true" default="0">
			
		<cftransaction isolation="read_uncommitted">
			<cfif getAdministrator(mission) eq "1">			
    		
		        <CFSET AccessLevel = '2'>
         
            <cfelse>
						  		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  max(A.AccessLevel) as AccessLevel
				FROM    OrganizationAuthorization A
				WHERE   UserAccount = '#SESSION.acc#'
				AND     (Mission = '#Mission#' AND OrgUnit is NULL)
				AND     UserAccount = '#SESSION.acc#'
				AND     Role = 'AssetManager'
				</cfquery>	
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = '#qAccess.AccessLevel#'>
				</cfif>	  
				
				</cfif>
		 
		 </cftransaction>
		 		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 7.2 Asset holder--->
	
	<cffunction access="public" name="AssetHolder" output="true" returntype="string" displayname="Movement and maintenance property Management">
		
		<cfargument name="OrgUnit"    type="string" required="true" default="0">
		<cfargument name="Mission"    type="string" required="true" default="">
		<cfargument name="AssetClass" type="string" required="true" default="">
		<cftransaction isolation="read_uncommitted">
			
			<cfif getAdministrator(mission) eq "1">	
    		
		        <CFSET AccessLevel = '2'>
         
            <cfelse>
			
			    <cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
			         SELECT * 
					 FROM   Organization
			         WHERE  OrgUnit = '#OrgUnit#'
		        </cfquery>
		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT MAX(A.AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization A
					WHERE  UserAccount = '#SESSION.acc#'
					AND    (
						     (Mission = '#Mission#' AND OrgUnit is NULL)
							  OR
							 (OrgUnit IN (SELECT OrgUnit 
							              FROM   Organization 
										  WHERE  Mission        = '#Org.Mission#'
										    AND  MandateNo      = '#Org.MandateNo#'  
										    AND  OrgUnitCode    = '#Org.HierarchyRootUnit#'))
							  OR
							 (OrgUnit = '#OrgUnit#')
						   )					  
					AND    UserAccount = '#SESSION.acc#'
					AND    Role = 'AssetHolder'
					AND    ClassParameter = '#AssetClass#'
			   </cfquery>	
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
			</cfif>
		 </cftransaction>
				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 7.4 warehouse processor --->
	
	<cffunction access="public" name="WarehouseProcessor" output="true" returntype="string" displayname="Warehouse Access">
		
		<cfargument name="Warehouse"  type="string" required="true" default="">
		<cfargument name="Mission"    type="string" required="true" default="">
		<cfargument name="SystemFunctionId"  type="string" required="true" default="">
			
			<cftransaction isolation="read_uncommitted">		
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessLevel = '2'>
         
            <cfelse>
			
			    <cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
		         SELECT * 
				 FROM   Organization
		         WHERE  OrgUnit = '#OrgUnit#'
		        </cfquery>
		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT MAX(A.AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization A
					WHERE  UserAccount = '#SESSION.acc#'
					
					<cfif warehouse eq "">
					
					AND    Mission = '#Mission#'
					
					<cfelse>
					
					AND  (
					
						     (Mission = '#Mission#' AND OrgUnit is NULL)
							  OR
							 (OrgUnit IN (
							 						 
											SELECT   O.OrgUnit
											FROM     Organization.dbo.Organization O INNER JOIN
											         Materials.dbo.Warehouse W ON O.MissionOrgUnitId = W.MissionOrgUnitId
											WHERE    W.Warehouse = '#warehouse#'
											)
							 
							 )
						 )		
						 
					</cfif>	 	  				
					  
					AND  UserAccount  = '#SESSION.acc#'					
					AND  Role         = 'WhsPick'		
					<cfif systemfunctionid neq "">		
					AND  ClassParameter = '#systemFunctionId#'
					</cfif>
			   </cfquery>	
				   
				   
				<cfif qAccess.RecordCount eq "0">
				  	<CFSET AccessLevel = '9'>
				<cfelse>
				  	<CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
			</cfif>
		</cftransaction>
				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>	
	
	
	<!--- 7.4 warehouse processor --->
	
	<cffunction access="public" name="WarehouseShipper" 
	    output="true" returntype="string" 
		displayname="Warehouse Access">
		
		<cfargument name="Warehouse"   type="string" required="true" default="">
		<cfargument name="Mission"     type="string" required="true" default="">
		<cfargument name="TaskType"    type="string" required="true" default="">
			
			<cftransaction isolation="read_uncommitted">	
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessLevel = '2'>
         
            <cfelse>
			
			    <cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
		         SELECT * FROM Organization
		         WHERE OrgUnit = '#OrgUnit#'
		        </cfquery>
		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT MAX(A.AccessLevel) as AccessLevel
					FROM OrganizationAuthorization A
					WHERE UserAccount = '#SESSION.acc#'
					
					<cfif warehouse eq "">
					AND    Mission = '#Mission#'
					<cfelse>
					AND  (
						     (Mission = '#Mission#' AND OrgUnit is NULL)
							  OR
							 (OrgUnit IN (
							 						 
											SELECT   O.OrgUnit
											FROM     Organization.dbo.Organization O INNER JOIN
											         Materials.dbo.Warehouse W ON O.MissionOrgUnitId = W.MissionOrgUnitId
											WHERE    W.Warehouse = '#warehouse#'
											)
							 
							 )
						 )		
						 
					</cfif>	 	  				
					  
					AND  UserAccount = '#SESSION.acc#'				
					AND  Role           = 'WhsShip'		
					<cfif tasktype neq "">		
					AND  ClassParameter = '#tasktype#'
					</cfif>					
			   </cfquery>	

				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
			</cfif>
		 
		 </cftransaction>
		 		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>	
			
				
	<!--- 8.1 Insurance--->
	
	<cffunction access="public" name="CaseFileManager" 
	    output="true" returntype="string" 
		displayname="Casefile Manager">
		
		<cfargument name="Mission"   type="string" required="true" default="">
		<cfargument name="ClaimType" type="string" required="true" default="">
		<cfargument name="OrgUnit"   type="string" required="true" default="0">
			
		<cftransaction isolation="read_uncommitted">	
    		<cfif SESSION.isAdministrator eq "Yes">
        
		        <CFSET AccessLevel = "2">
         
            <cfelse>
			
			    <cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
			         SELECT * 
					 FROM   Organization
			         WHERE  OrgUnit = '#OrgUnit#'
		        </cfquery>
		
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT max(A.AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization A
					WHERE  UserAccount = '#SESSION.acc#'
					<cfif OrgUnit neq "0">
					AND  ((Mission = '#Mission#' AND OrgUnit is NULL)
						  OR
						 (OrgUnit IN (SELECT OrgUnit 
						              FROM Organization 
									  WHERE  Mission           = '#Org.Mission#'
									    AND  MandateNo         = '#Org.MandateNo#'  
									    AND  OrgUnitCode       = '#Org.HierarchyRootUnit#'))
						  OR
						 (OrgUnit = '#OrgUnit#'))			  
					<cfelse>
					AND  Mission = '#Mission#'
					</cfif>		
					<cfif Claimtype neq "">
					AND  ClassParameter = '#claimtype#'			 				
					</cfif>
					AND  Role IN ('InsuranceManager','CaseFileManager')				
			   </cfquery>	
			   
			   <cfif qAccess.recordcount eq "0">
			   
				   <cfquery name="qAccess" 
	           	    datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT max(A.AccessLevel) as AccessLevel
					FROM OrganizationAuthorization A
					WHERE UserAccount = '#SESSION.acc#'
					<cfif OrgUnit neq "0">
					AND  ((Mission = '#Mission#' AND OrgUnit is NULL)
						  OR
						 (OrgUnit IN (SELECT OrgUnit 
						              FROM Organization 
									  WHERE  Mission           = '#Org.Mission#'
									    AND  MandateNo         = '#Org.MandateNo#'  
									    AND  OrgUnitCode       = '#Org.HierarchyRootUnit#'))
						  OR
						 (OrgUnit = '#OrgUnit#'))			  
					<cfelse>
					AND Mission = '#Mission#'
					</cfif>			
					AND ClassParameter IN (SELECT ActionCode 
					                       FROM   Ref_EntityAction A
										   WHERE  ActionCode = A.ClassParameter
										   AND    ActionType = 'Create')					
					AND  Role In ('InsuranceOfficer','CaseFileOfficer')				
				   </cfquery>			   
			   
			   </cfif>			   
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
			</cfif>
		 
		 </cftransaction>
		 		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
	<!--- 9.0 WorkOrder Manager --->
	
	<cffunction access="public" name="WorkOrderManager" 
	    output="true" returntype="string" 
		displayname="WorkOrder Manager">
		
		<cfargument name="Mission"   type="string" required="true" default="">
		<cfargument name="OrgUnit"   type="string" required="true" default="0">
		<cfargument name="Mode"      type="string" required="true" default="Create">
			
			
		<cftransaction isolation="read_uncommitted">
    		<cfif SESSION.isAdministrator eq "Yes">
        
		        <CFSET AccessLevel = "2">
         
            <cfelse>
			
			    <cfquery name="Org" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
			         SELECT * 
					 FROM   Organization
			         WHERE  OrgUnit = '#OrgUnit#'
		        </cfquery>		
		       			   
				<cfquery name="qAccess" 
	           	    datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT MAX(A.AccessLevel) as AccessLevel
					FROM   OrganizationAuthorization A
					WHERE  UserAccount = '#SESSION.acc#'
					<cfif OrgUnit neq "0">
					AND  ((Mission = '#Mission#' AND OrgUnit is NULL)
						  OR
						 (OrgUnit IN (SELECT  OrgUnit 
						              FROM    Organization 
									  WHERE   Mission           = '#Org.Mission#'
									    AND   MandateNo         = '#Org.MandateNo#'  
									    AND   OrgUnitCode       = '#Org.HierarchyRootUnit#'))
						  OR
						 (OrgUnit = '#OrgUnit#'))			  
					<cfelse>
					AND  Mission = '#Mission#'
					</cfif>		
					<cfif Mode eq "Create">	
					AND  ClassParameter IN (SELECT ActionCode 
					                        FROM   Ref_EntityAction 
										    WHERE  ActionCode = A.ClassParameter
										    AND    ActionType = 'Create')					
					</cfif>						
					AND  Role In ('WorkOrderManager')				
				   </cfquery>			   
			   			   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
				</cfif>
		 
		 </cftransaction>
		 		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>
	
		
	<!--- 9.1 Service requester role --->
	
	<cffunction access="public" name="ServiceRequester" 
	    output="true" returntype="string" 
		displayname="Service Requester">
		
		<cfargument name="Mission"     type="string" required="false" default="">
		<cfargument name="OrgUnit"     type="string" required="false" default="0">
		<cfargument name="ServiceItem" type="string" required="false" default="">
		
		<cftransaction isolation="read_uncommitted">
			<cfif getAdministrator(mission) eq "1">			
    		
		        <CFSET AccessLevel = "2">
         
            <cfelse>					
						
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MAX(A.AccessLevel) as AccessLevel
				FROM   OrganizationAuthorization A
				WHERE  UserAccount = '#SESSION.acc#'
				<cfif OrgUnit neq "0">
				AND  (
				     
					 (Mission = '#Mission#' AND OrgUnit is NULL)
					         OR
					 OrgUnit = '#OrgUnit#'
					 )
								
				<cfelse>
								
				AND Mission = '#Mission#'
				
				</cfif>					 				
				AND  Role = 'ServiceRequester'	
								
				<cfif serviceitem neq "">	
				  AND  ClassParameter = '#serviceitem#'
				</cfif>	
								
				<!---
				<cfif serviceitem neq "">	
				  AND  ClassParameter IN (SELECT ServiceClass 
				                          FROM Workorder.dbo.ServiceItem 
										  WHERE Code = '#serviceitem#')
				</cfif>	
				--->
			   </cfquery>	
			     
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
				</cfif>
		 
		 </cftransaction>
		 		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>		
	
	<!--- 9.2 Workorder Processor --->
	
	<cffunction access="public" name="WorkorderProcessor" 
	    output="true" returntype="string" 
		displayname="WorkOrder processor">
		
		<cfargument name="Mission"       type="string" required="false" default="">
		<cfargument name="OrgUnit"       type="string" required="false" default="0">
		<cfargument name="Manager"       type="string" required="false" default="No">
		<cfargument name="ServiceDomain" type="string" required="false" default="">
		<cfargument name="ServiceItem"   type="string" required="false" default="">
		
		<cftransaction isolation="read_uncommitted">
		
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessLevel = "2">
         
            <cfelse>					
						
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MAX(A.AccessLevel) as AccessLevel
				FROM   OrganizationAuthorization A
				WHERE  UserAccount = '#SESSION.acc#'
				<cfif  OrgUnit neq "0">				
				AND  ((Mission = '#Mission#' AND OrgUnit is NULL) OR OrgUnit = '#OrgUnit#')								
				<cfelseif mission neq "">
				AND   Mission = '#Mission#'
				</cfif>					 								
				AND   Role = 'WorkOrderProcessor'									
				<cfif serviceitem neq "">	
				AND   ClassParameter = '#serviceitem#'
				</cfif>					
				<cfif servicedomain neq "">
				  AND ClassParameter IN (SELECT Code
				                         FROM   Workorder.dbo.Serviceitem
										 WHERE  ServiceDomain = '#servicedomain#')				
				</cfif>
								
				<!---
				<cfif serviceitem neq "">	
				  AND  ClassParameter IN (SELECT ServiceClass 
				                          FROM Workorder.dbo.ServiceItem 
										  WHERE Code = '#serviceitem#')
				</cfif>	
				--->
			   </cfquery>	
			     
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
				</cfif>
		 </cftransaction>
		 		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>	
	
	<!--- 9.2b Workorder Processor OrgUnit --->
	
	<cffunction access="public" name="WorkorderProcessorUnit" 
	    output="true" returntype="string" 
		displayname="WorkOrder processor unit">
		
		<cfargument name="Mission"       type="string" required="false" default="">		
		<cfargument name="Manager"       type="string" required="false" default="No">
		<cfargument name="ServiceDomain" type="string" required="false" default="">
		<cfargument name="ServiceItem"   type="string" required="false" default="">
		
		<cftransaction isolation="read_uncommitted">
		
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessOrgUnit = "ALL">
         
            <cfelse>					
						
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT OrgUnit
				FROM   OrganizationAuthorization A
				WHERE  UserAccount = '#SESSION.acc#'						
				AND    Mission = '#Mission#' 													 								
				AND    Role    = 'WorkOrderProcessor'	
				---AND    AccessLevel 								
				<cfif serviceitem neq "">	
				AND   ClassParameter = '#serviceitem#'
				</cfif>					
				<cfif servicedomain neq "">
				AND   ClassParameter IN (SELECT Code
				                         FROM   Workorder.dbo.Serviceitem
										 WHERE  ServiceDomain = '#servicedomain#')				
				</cfif>
				
			   </cfquery>	
			   
			   <cfif qAccess.recordcount eq "0">		   
			   	   <cfset AccessOrgUnit = "NONE">
			   <cfelse>
				   <cfset AccessOrgUnit = ValueList(qAccess.OrgUnit)>
			   </cfif>	   
			  
			</cfif>
			
		 </cftransaction>
		 		 
		
		 <cfreturn AccessOrgUnit>
		
	</cffunction>	
	
	<!--- 9.3 Workorder Finance Funder --->
	
	<cffunction access="public" name="WorkorderFunder" 
	    output="true" returntype="string" 
		displayname="WorkOrder Financer">
		
		<cfargument name="Mission"       type="string" required="false" default="">
		<cfargument name="OrgUnit"       type="string" required="false" default="0">
		<cfargument name="ServiceDomain" type="string" required="false" default="">
		<cfargument name="ServiceItem"   type="string" required="false" default="">
			
			<cftransaction isolation="read_uncommitted">
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessLevel = "2">
         
            <cfelse>					
						
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MAX(A.AccessLevel) as AccessLevel
				FROM   OrganizationAuthorization A
				WHERE  UserAccount = '#SESSION.acc#'
				<cfif OrgUnit neq "0">
				AND  (
				     
					 (Mission = '#Mission#' AND OrgUnit is NULL)
					         OR
					 OrgUnit = '#OrgUnit#'
					 )
								
				<cfelse>
				
				AND Mission = '#Mission#'
				</cfif>					 				
				AND  Role = 'WorkOrderFunder'	
								
				<cfif serviceitem neq "">	
				  AND  ClassParameter = '#serviceitem#'
				</cfif>	
				
				<cfif servicedomain neq "">
				  AND ClassParameter IN (SELECT Code
				                         FROM Workorder.dbo.Serviceitem
										 WHERE ServiceDomain = '#servicedomain#')				
				</cfif>
				
			   </cfquery>	
			     
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
			</cfif>
		 </cftransaction>
				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>	
	
	<!--- 9.3b Workorder Finance Biller --->
	
	<cffunction access="public" name="WorkorderBiller" 
	    output="true" returntype="string" 
		displayname="WorkOrder Financer">
		
		<cfargument name="Mission"       type="string" required="false" default="">
		<cfargument name="OrgUnit"       type="string" required="false" default="0">
		<cfargument name="ServiceDomain" type="string" required="false" default="">
		<cfargument name="ServiceItem"   type="string" required="false" default="">
			
			<cftransaction isolation="read_uncommitted">
			<cfif getAdministrator(mission) eq "1">	
			
		        <CFSET AccessLevel = "2">
         
            <cfelse>					
						
		        <cfquery name="qAccess" 
           	    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MAX(A.AccessLevel) as AccessLevel
				FROM   OrganizationAuthorization A
				WHERE  UserAccount = '#SESSION.acc#'
				<cfif OrgUnit neq "0">
				AND  (
				     
					 (Mission = '#Mission#' AND OrgUnit is NULL)
					         OR
					 OrgUnit = '#OrgUnit#'
					 )
								
				<cfelse>
				
				AND Mission = '#Mission#'
				</cfif>					 				
				AND  Role = 'WorkOrderBiller'	
								
				<cfif serviceitem neq "">	
				  AND  ClassParameter = '#serviceitem#'
				</cfif>	
				
				<cfif servicedomain neq "">
				  AND ClassParameter IN (SELECT Code
				                         FROM Workorder.dbo.Serviceitem
										 WHERE ServiceDomain = '#servicedomain#')				
				</cfif>
				
			   </cfquery>	
			     
				   
				<cfif qAccess.RecordCount eq "0">
				  <CFSET AccessLevel = '9'>
				<cfelse>
				  <CFSET AccessLevel = qAccess.AccessLevel>
				</cfif>	  
				
			</cfif>
		 </cftransaction>
				 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		
	</cffunction>	
	
	<!--- 9.4 Workorder List --->
	
	<cffunction access="public" name="WorkorderAccessList" 
	    output="true" returntype="string" 
		displayname="WorkOrder Access List">
		
		<cfargument name="Mission"       type="string" required="false" default="">
		<cfargument name="Role"          type="string" required="false" default="">
		<cfargument name="ServiceItem"   type="string" required="false" default="">				
		<cfargument name="AccessLevel"   type="string" required="false" default="">
		
		<cfif getAdministrator(mission) eq "1">		
				
    			<cftransaction isolation="read_uncommitted">				
		
		        <cfquery name="qAccess" 
           	    datasource="AppsWorkOrder">
				SELECT DISTINCT W.WorkOrderId
				FROM   Customer C INNER JOIN
		                  WorkOrder W ON C.CustomerId = W.CustomerId
				WHERE     C.Mission = '#mission#'
				<!--- kherrera(20150703): take only the operational customers and workorders --->
				AND		C.Operational = '1'
				AND		W.ActionStatus = '1'
				</cfquery>
				</cftransaction>
        
		       <cfset AccessRight = quotedValueList(qAccess.workorderid)>
         
         <cfelse>						
			
			<cfset accessRight = "">
				
				<cftransaction isolation="read_uncommitted">					
				<cfquery name="Param" 
					datasource="appsWorkOrder"> 
					SELECT    *
					FROM      Ref_ParameterMission
					WHERE     Mission = '#mission#'	
				</cfquery>									
						
				<cfquery name="qAccess" 
	           	    datasource="AppsWorkOrder">
						SELECT DISTINCT 
								C.OrgUnit, 
								W.WorkOrderId
						FROM   	Customer C INNER JOIN WorkOrder W ON C.CustomerId = W.CustomerId
						WHERE  	C.Mission = '#mission#'	
						<!--- kherrera(20150703): take only the operational customers and workorders --->
						AND		C.Operational = '1'
						AND		W.ActionStatus = '1'						
			    </cfquery>				
				</cftransaction>			
							
				<cfloop query="qAccess">		
																	
					<cfinvoke component = "Service.Access"  
						   method           = "RoleAccess" 
						   mission          = "#Param.TreeCustomer#" 					   					 
						   Role             = "#preservesingleQuotes(role)#"
						   accesslevel      = "#accesslevel#" 
						   Parameter        = "#serviceitem#"
						   defaultDSAuth    = "1"
						   unit             = "#orgunit#"	
						   anyunit          = "No"
						   returnvariable   = "Access">								   						   
						  					  					  					  					  					   
						   <cfif access eq "GRANTED">	 
							    <cfif accessRight eq "">
									<cfset accessRight =  "'#workorderid#'">
								<cfelse>
								 	<cfset accessRight =  accessRight & ",'#workorderid#'">
								</cfif>	
						   </cfif>
					   			
				</cfloop>
									
		 </cfif>
				 
		 <cfreturn AccessRight>
		
	</cffunction>					
			
</cfcomponent>