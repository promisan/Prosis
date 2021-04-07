
<!--- 1.  removing access specific   --->
<!--- 1b. removing access request    --->
<!--- 2.  removing acess id          --->
<!--- 3.  removing access global     --->
<!--- 4.  resync warehouse access    --->
<!--- 5.  Resync group access        --->

<cfcomponent>
	
<!--- ------------------------- --->

<cfproperty name="name" type="string">
<cfset this.name = "Access logging">
			
<cffunction access      = "public" 
        name        = "DeleteAccess"
		output      = "true" 
		returntype  = "string" 
		displayname = "Delete Access">
		
		<cfargument name="Logging"          type="string"  required="false" default="0">				
		<cfargument name="ActionId"         type="string"  required="true">
		<cfargument name="ActionStatus"     type="string"  required="true">
		<cfargument name="ActionStep"       type="string"  required="true">
		<cfargument name="userAccount"      type="string"  required="true">
		<cfargument name="Condition"        type="string"  required="true">
		<cfargument name="ConditionGroup"   type="string"  required="false" default="">
		<cfargument name="DeleteCondition"  type="string"  required="false" default="">
		<cfargument name="AddDeny"          type="string"  default="0"      required="yes">
		<cfargument name="AddDenyCondition" type="string"  required="no"    default="">
						
		<!--- this only applies for group inherited access in order to revert this --->
		
		<cfif AddDeny eq "1">
		
			<cfquery name="getOverrule" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   OrganizationAuthorization O
				WHERE  #preserveSingleQuotes(condition)#
				<cfif adddenycondition neq "">
				AND    #preserveSingleQuotes(addDenyCondition)#
				</cfif>  
				AND    O.AccessId NOT IN (SELECT AccessId 
				                          FROM   OrganizationAuthorizationDeny
									      WHERE  AccessId = O.AccessId)
				AND    O.Mission IN (SELECT  Mission 
				                     FROM    Ref_Mission
							    	 WHERE   Mission = O.Mission)
			</cfquery>						 
						
			<cfif getOverrule.recordcount gte "1">					 
			
					<!--- special logging to capture the group overrule action --->
					
					<cf_assignId>
					
					<cfquery name="Instance" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO UserAuthorizationAction
						        (ProfileActionId, 
								 UserAccount, 
								 Memo,
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
						VALUES  ('#rowguid#',
						         '#UserAccount#',
								 'Overrule Group Access',
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#')
					</cfquery>
					
					<cfquery name="Log" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						INSERT INTO UserAuthorizationActionLog
						        (ProfileActionId, 
								 ActionStatus, 
								 AccessId, 
								 Mission, 
								 OrgUnit, 
								 UserAccount, 
								 Role, 
								 ClassParameter, 
								 GroupParameter, 
								 ClassisAction, 
								 AccessLevel, 
								 Source, 
						         OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName, 
								 Created)								 
								 
						SELECT   '#rowguid#',
						         '9',
						         AccessId,
								 Mission, 
								 OrgUnit, 
								 UserAccount,
								 Role, 
								 ClassParameter, 
								 GroupParameter, 
								 ClassIsAction, 
						         AccessLevel, 
								 Source, 
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName, 
								 getDate()
								 
						FROM   OrganizationAuthorization O
						WHERE  #preserveSingleQuotes(condition)#
						<cfif adddenycondition neq "">
						AND    #preserveSingleQuotes(addDenyCondition)#
						</cfif>  
						AND    O.AccessId NOT IN (SELECT AccessId 
						                          FROM OrganizationAuthorizationDeny
											      WHERE AccessId = O.AccessId)
						AND    O.Mission IN (SELECT Mission 
						                     FROM   Ref_Mission
									    	 WHERE  Mission = O.Mission)							 
											 							 		 
						
					</cfquery>
					
					<!--- apply --->
					
					<cfquery name="AddDeny" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO OrganizationAuthorizationDeny
						
						SELECT * 
						FROM   OrganizationAuthorization O
						WHERE  #preserveSingleQuotes(condition)#
						<cfif adddenycondition neq "">
						AND    #preserveSingleQuotes(addDenyCondition)#
						</cfif>  
						AND    O.AccessId NOT IN (SELECT AccessId 
						                          FROM OrganizationAuthorizationDeny
											      WHERE AccessId = O.AccessId)
						AND    O.Mission IN (SELECT Mission 
						                     FROM   Ref_Mission
									    	 WHERE  Mission = O.Mission)
											 
											
					</cfquery>
															
				</cfif>	
		
		</cfif>		
				
		<cf_assignId>
		
		<cfif logging eq "1">
		
			<cfquery name="ProfileAction" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO UserAuthorizationAction
					        (ProfileActionId, 
							 UserAccount, 
							 Memo,
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
					VALUES  ('#rowguid#',
					         '#UserAccount#',
							 '#ActionStep#',
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#')
			</cfquery>
	
			<!--- -------------------------- --->
			<!--- log removed/revised access --->
			<!--- -------------------------- --->
				
			<cfquery name="LogOld" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO UserAuthorizationActionLog
				
						(ProfileActionId,
						 ActionStatus, 
						 AccessId, 
						 Mission, 
						 OrgUnit, 
						 UserAccount, 
						 Role, 
						 ClassParameter, 
						 GroupParameter, 
						 AccessLevel, 
						 Source,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,
						 Created)
					
				 SELECT  '#rowguid#',
					     '#actionStatus#',
						 AccessId,
						 Mission,
						 OrgUnit,
						 UserAccount,
						 Role,
						 ClassParameter,
						 GroupParameter,
						 AccessLevel,
						 Source,
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#',	
					     getDate()
						 							
					FROM       OrganizationAuthorization
					WHERE      #preservesinglequotes(condition)#
					<cfif deletecondition neq "">
			    	AND  #preserveSingleQuotes(deletecondition)# 
	    		   </cfif>		
																		   
		       </cfquery>				
		
		</cfif>
						
		<!--- remove entries selected account --->
				
		<cfquery name="Delete" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM OrganizationAuthorization
		WHERE    #preserveSingleQuotes(condition)#		
		   <cfif deletecondition neq "">
	    	AND  #preserveSingleQuotes(deletecondition)# 
    	   </cfif>		   		  
		</cfquery>
								
		<!--- remove entries inherited by group access --->
		
		<cfif conditiongroup neq "">
						
			<cfquery name="Delete" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM OrganizationAuthorization
			WHERE    #preserveSingleQuotes(conditiongroup)#		
			   <cfif deletecondition neq "">
		    	AND  #preserveSingleQuotes(deletecondition)# 
	    	   </cfif>
			</cfquery>
						
			<cfquery name="Delete" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM OrganizationAuthorizationDeny
			WHERE    #preserveSingleQuotes(conditiongroup)#		
			<cfif deletecondition neq "">
		    	AND  #preserveSingleQuotes(deletecondition)# 
	    	</cfif>
			</cfquery>
					
		</cfif>
				
</cffunction>

<cffunction access  = "public" 
      name          = "RevertAccessRequest"
	  output        = "true" 
	  returntype    = "string" 
   	  displayname   = "Reverting Access for a request">
	  
	  <cfargument name="requestId" type="GUID" required="yes">	
	  
	  <cftransaction>
	  
		  <!--- For Nery 26/1/2012 
		     1. go to all userAuthorizationAction records with this id
			 2. sort all applied transactions of userAuthorizationActionLog in the reverse order
			 3. loop
			 if 9 : add combination in OrganizationAuthorization
			 if 1 : remove combinaton from OrganizationAuthorization
			 4. clear userAuthorizationActionLog records
			 5. clear userAuthorizationAction  records
		  --->
		  
			<cfquery name="AccessActionLog" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   UserAuthorizationActionLog
				WHERE  ProfileActionId IN 
				(
					SELECT ProfileActionId 
					FROM   UserAuthorizationAction
					WHERE  RequestId = '#requestId#'
				)
				ORDER  BY ProfileActionSerialNo DESC
			</cfquery>
			
			<cfloop query="AccessActionLog">
			
				<cfif ActionStatus eq "1">
				
					<cfquery name="RevertAccessGranted" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">  
						
						DELETE
						FROM    OrganizationAuthorization
						WHERE   AccessId = '#AccessId#'
					
					</cfquery>
				
				<cfelseif ActionStatus eq "9">
				
					<!--- Provision to prevent UniqueKey violation ---->
					<cfquery name="Validate" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">  
						SELECT *
						FROM   OrganizationAuthorization
						WHERE  Mission  = '#Mission#' AND OrgUnit        = '#OrgUnit#'        AND UserAccount = '#UserAccount#' 
							   AND Role = '#Role#'    AND ClassParameter = '#ClassParameter#' AND Source      = '#Source#'      
							   AND GroupParameter = '#GroupParameter#'
					</cfquery>
				
					<cfif Validate.RecordCount eq 0>
				
						<cfquery name="GrantAccessRevoked" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">  
					
							INSERT 
							INTO  Organization.dbo.OrganizationAuthorization
							( 
							  AccessId,
					          Mission,
					          OrgUnit,
					          UserAccount,
					          Role,
					          ClassParameter,
					          GroupParameter,
					          ClassisAction,
					          AccessLevel,
					          Source,
					          OfficerUserId,
					          OfficerLastName,
					          OfficerFirstName,
					          Created 
							 )
							 VALUES (
							  '#AccessId#',
							  '#Mission#',
							  '#OrgUnit#',
							  '#UserAccount#',
							  '#Role#',
							  '#ClassParameter#',
							  '#GroupParameter#',
							  '#ClassIsAction#',
							  '#AccessLevel#',
							  '#Source#',
							  '#OfficerUserId#',
							  '#OfficerLastName#',
							  '#OfficerFirstName#',
							  '#Created#'
							 )
						</cfquery>
					
					</cfif>
				
				</cfif>
			
			</cfloop>
			
			<cfquery name="Clean" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				DELETE FROM
				UserAuthorizationAction
				WHERE RequestId = '#requestId#'
			
			</cfquery>
	  
	  </cftransaction>
	  	  
</cffunction>	  

<!--- ------------------------- --->
<!--- remove single access      --->
<!--- ------------------------- --->
	
<cffunction access      = "public" 
            name        = "DeleteAccessId"
			output      = "false" 
			returntype  = "string" 
			displayname = "Delete single">
						
		<cfargument name="accessid" type="GUID" required="yes">	
		
		<cf_AssignId>

		<cftransaction>
		
		<cfquery name="Get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT * 
			FROM OrganizationAuthorization			
			WHERE AccessId = '#Accessid#'									 
		</cfquery>	
		
		 <!--- move to log file --->

		<cfquery name="Instance" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserAuthorizationAction
			        (ProfileActionId, UserAccount, Memo,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES  ('#rowguid#','#get.Useraccount#','Clear user access','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>
			
		<cfquery name="Log" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO UserAuthorizationActionLog
			        (ProfileActionId, 
					 ActionStatus, 
					 AccessId, 
					 Mission, 
					 OrgUnit, 
					 UserAccount, 
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassisAction, 
					 AccessLevel, 
					 Source, 
			         OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created)
		SELECT   '#rowguid#',
		         '9',
		         AccessId,
				 Mission, 
				 OrgUnit, 
				 UserAccount,
				 Role, 
				 ClassParameter, 
				 GroupParameter, 
				 ClassIsAction, 
		         AccessLevel, 
				 Source, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName, 
				 getDate()
		FROM     OrganizationAuthorization
		WHERE    AccessId = '#AccessId#'		
		</cfquery>	
		
		<!--- end of logging --->
		
		<cfquery name="Account" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT * 
			FROM   System.dbo.UserNames
			WHERE  Account = '#get.UserAccount#'									 
		</cfquery>	
		
		<cfif Account.AccountType eq "Group">
		
			<!--- remove also the membership if this record if the account is a group first --->	
									
			<cfquery name="DeleteMembership" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				DELETE FROM OrganizationAuthorization			
				WHERE 1 = 1
				<cfif get.Mission neq "">
				AND  Mission = '#get.Mission#'
				</cfif>
				<cfif get.OrgUnit neq "">
				AND  (OrgUnit = '#get.OrgUnit#' or OrgUnitInherit = '#get.OrgUnit#') 
				</cfif>
				<!---
				AND  UserAccount    = '#get.UserAccount#'
				--->
				AND  Role           = '#get.Role#'
				AND  ClassParameter = '#get.ClassParameter#'
				AND  GroupParameter = '#get.GroupParameter#'
				AND  AccessLevel    = '#get.AccessLevel#'
				AND  Source         = '#get.UserAccount#'														 
			</cfquery>	
			
			<!--- only used for inherited records --->
			
			<cfquery name="DeleteDeny"
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				DELETE FROM OrganizationAuthorizationDeny
				WHERE 1 = 1
				<cfif get.Mission neq "">
				AND  Mission = '#get.Mission#'
				</cfif>
				<cfif get.OrgUnit neq "">
				AND  (OrgUnit = '#get.OrgUnit#' or OrgUnitInherit = '#get.OrgUnit#')
				</cfif>
				AND  Role           = '#get.Role#'
				AND  ClassParameter = '#get.ClassParameter#'
				AND  GroupParameter = '#get.GroupParameter#'
				AND  AccessLevel    = '#get.AccessLevel#'
				AND  Source         = '#get.UserAccount#'														 
			</cfquery>	
		
		</cfif>
		
		<!--- delete the actual access record to be removed --->
		
		<cfquery name="DeleteManual" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			DELETE FROM OrganizationAuthorization			
			WHERE 1 = 1
			<cfif get.Mission neq "">
			AND  Mission = '#get.Mission#'
			</cfif>
			<cfif get.OrgUnit neq "">
			AND  (OrgUnit = '#get.OrgUnit#' or OrgUnitInherit = '#get.OrgUnit#') 
			</cfif>
			AND  UserAccount    = '#get.UserAccount#'
			AND  Role           = '#get.Role#'
			AND  ClassParameter = '#get.ClassParameter#'
			AND  GroupParameter = '#get.GroupParameter#'
			AND  AccessLevel    = '#get.AccessLevel#'	
			AND  Source         = 'Manual'												 
		</cfquery>	
				
		<cfif Account.AccountType eq "Group">	
		
			<!--- sync the group as well --->
			<!--- ---------------------- --->
			 
			 <cfinvoke component="Service.Access.AccessLog"  
			  method       = "SyncGroup"
			  UserGroup    = "#get.UserAccount#"
			  UserAccount  = ""
			  Role         = "">	
		  
		</cfif>  		
						
	</cftransaction>
				  		
</cffunction>	


<!--- ------------------------------------------ --->
<!--- ------------ 3. CLEAR ALL ACCESS---------- --->
<!--- ------------------------------------------ --->	
	
<cffunction access      = "public" 
        name        = "DeleteAccessAll"
		output      = "false" 
		returntype  = "string" 
		displayname = "Delete All">		
					
		<cfargument name="userAccount"   type="string" required="true">	
		<cfargument name="officeruserid" type="string" default="" required="yes">	
			
		<cf_AssignId>
	
		<cftransaction>
	
		<cfquery name="Instance" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserAuthorizationAction
			        (ProfileActionId, UserAccount, Memo,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES  ('#rowguid#','#useraccount#','Clear user access','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>
		
		<!--- move to log file --->
			
			<cfquery name="Log" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserAuthorizationActionLog
			        (ProfileActionId, 
					 ActionStatus, 
					 AccessId, 
					 Mission, 
					 OrgUnit, 
					 UserAccount, 
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassisAction, 
					 AccessLevel, 
					 Source, 
			         OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created)
			SELECT   '#rowguid#',
			         '9',
			         AccessId,
					 Mission, 
					 OrgUnit, 
					 UserAccount,
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassIsAction, 
			         AccessLevel, 
					 Source, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 getDate()
			FROM     OrganizationAuthorization
			WHERE    (UserAccount  = '#UserAccount#' or Source = '#UserAccount#')
			 AND     userAccount  != '#SESSION.acc#'
			 <cfif OfficerUserId neq "">
			 AND     OfficerUserId = '#OfficerUserid#'		
			 </cfif>	
			</cfquery>
			
			<cfquery name="Get" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT * 
				FROM   System.dbo.UserNames
				WHERE  Account = '#UserAccount#'									 
			</cfquery>	
			
			<cfif Get.AccountType eq "Individual">
			
				<!--- remove membership from user groups that have a representation in the user access
				which were granted through the selected administrator --->
				
				<cfquery name="DeleteMembership" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
						DELETE FROM System.dbo.UserNamesGroup			
						WHERE Account = '#UserAccount#' 
						 AND  Account != '#SESSION.acc#'
						 AND  AccountGroup IN (SELECT DISTINCT Source
						                       FROM OrganizationAuthorization
											   <cfif OfficerUserId neq "">
											   WHERE  OfficerUserId = '#OfficerUserid#'		
											   </cfif>	
											   )
			   	</cfquery>				
				
				<!--- delete all authorization records --->
						
				<cfquery name="Delete" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					DELETE FROM OrganizationAuthorization			
					WHERE UserAccount = '#UserAccount#'			
					 AND  UserAccount != '#SESSION.acc#'			
					 <cfif OfficerUserId neq "">
					 AND     OfficerUserId = '#OfficerUserid#'		
					 </cfif>											 
				</cfquery>		
				
			<cfelse>	
			
				<!--- delete member authorization in case the account is a usergroup --->	
				
				<cfquery name="DeleteMember" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					DELETE FROM OrganizationAuthorization			
					WHERE Source = '#UserAccount#'			
					 AND  UserAccount != '#SESSION.acc#'			
					 <cfif OfficerUserId neq "">
					 AND     OfficerUserId = '#OfficerUserid#'		
					 </cfif>											 
				</cfquery>	
				
			</cfif>	
			
			<cfquery name="DeleteDW" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				DELETE FROM System.dbo.skUserGrant			
				WHERE UserAccount = '#UserAccount#' 
				 AND  UserAccount != '#SESSION.acc#'
				 <cfif OfficerUserId neq "">
				 AND     OfficerUserId = '#OfficerUserid#'		
				 </cfif>											 
			</cfquery>			
			
			<cfquery name="DeleteDeny" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				DELETE FROM OrganizationAuthorizationDeny		
				WHERE (UserAccount = '#UserAccount#' or Source = '#UserAccount#') 			
				 AND  UserAccount != '#SESSION.acc#'			
				 <cfif OfficerUserId neq "">
				 AND     OfficerUserId = '#OfficerUserid#'		
				 </cfif>											 
			</cfquery>	
			
			<cfif OfficerUserId neq "">
			
				<!--- no further action --->
						
			<cfelse>
			
				<!--- more thorough cleaning in case it is global --->
			
				<!--- select this user from membership records --->
				
				<cfquery name="DeleteMembership" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					DELETE FROM System.dbo.UserNamesGroup			
					WHERE Account = '#UserAccount#' 
					 AND  Account != '#SESSION.acc#'
					 AND  AccountGroup IN (SELECT Account 
					                       FROM System.dbo.UserNames 
										   WHERE AccountType = 'Group'
										   AND   AccountOwner IN (SELECT ClassParameter 
			                       					  			  FROM   OrganizationAuthorization
																  WHERE  Role        = 'AdminUser'
																  AND    AccessLevel = '2'
																  AND    UserAccount = '#SESSION.acc#')) 
		    	</cfquery>	
			
				<!--- in additional get rid of local defined access --->
			
				<!--- clean document access --->
			
				<cfquery name="Delete" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					DELETE FROM OrganizationObjectActionAccess			
					WHERE UserAccount = '#UserAccount#' 									 
				</cfquery>	
					
				<!--- clean roster bucket access --->
				
				<cfquery name="RosterServer" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
				    SELECT DISTINCT *
					FROM      Ref_MissionModule
					WHERE     SystemModule = 'Roster' 
					AND DataSource IS NOT NULL	
				</cfquery>
				
				<cfif RosterServer.recordcount eq "0">
				
						<cfset svr = "default">
							
				<cfelse>
				
						<cfset svr = "">
						<cfloop query="RosterServer">
						
							<!--- cfcode pending --->
						    <cfset server = "">
												
						    <cfif srv eq "">
								<cfset svr = "#server#">
							<cfelse>
								<cfset svr = "#srv#,#server#">
							</cfif>
						</cfloop>
						
				</cfif>	
				
				<cf_verifyOperational 
	            datasource= "appsOrganization"
	            module    = "Roster" 
	            Warning   = "No">
	        
	            <cfif Operational eq "1">
						
				<cfloop index="dbserver" list="#svr#" delimiters=",">
				
					<cfquery name="DeleteRoster" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
						DELETE FROM <cfif dbserver neq "default">[#dbserver#].</cfif>Applicant.dbo.RosterAccessAuthorization			
						WHERE  UserAccount = '#UserAccount#' 
						 AND   UserAccount != '#SESSION.acc#'
						 <!---
						 <cfif SESSION.isAdministrator eq "No"> 
						 AND   Role IN (SELECT Role FROM Ref_AuthorizationRole 
						                WHERE  RoleOwner IN (SELECT ClassParameter 
				                       					       FROM  OrganizationAuthorization
														      WHERE  Role = 'AdminUser'
														        AND  AccessLevel = '2'
															    AND  UserAccount = '#SESSION.acc#'))
						 </cfif>	
						 --->	
					</cfquery>	
										
				</cfloop>
				
				</cfif>
			
				<!--- clean program access --->
				
				<cfquery name="RosterServer" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
				    SELECT DISTINCT *
					FROM      Ref_MissionModule
					WHERE     SystemModule = 'Program' 
					AND DataSource IS NOT NULL	
				</cfquery>
				
				<cfif RosterServer.recordcount eq "0">
				
						<cfset svr = "default">
							
				<cfelse>
				
						<cfset svr = "">
						<cfloop query="RosterServer">
						
						<!---
						<CFOBJECT ACTION="CREATE" TYPE="JAVA" CLASS="coldfusion.server.ServiceFactory" NAME="factory">
						<!--- Get datasource service --->
						<CFSET dsService=factory.getDataSourceService()>
						<!--- Get datasources --->
						<CFSET dsFull=dsService.getDatasources()>
						--->			
								
							<!--- cfcode pending --->
						    <cfset server = "">
												
						    <cfif srv eq "">
								<cfset svr = "#server#">
							<cfelse>
								<cfset svr = "#srv#,#server#">
							</cfif>
						</cfloop>
						
				</cfif>	
				
				<cf_verifyOperational 
	            datasource= "appsOrganization"
	            module    = "Program" 
	            Warning   = "No">
	        
	            <cfif Operational eq "1">
							
				<cfloop index="dbserver" list="#svr#" delimiters=",">
				
					<cfquery name="DeleteRoster" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
						DELETE FROM <cfif dbserver neq "default">[#dbserver#].</cfif>Program.dbo.ProgramAccessAuthorization			
						WHERE  UserAccount = '#UserAccount#' 
						 AND   UserAccount != '#SESSION.acc#'
						 <!---
						 <cfif SESSION.isAdministrator eq "No"> 
						 AND   Role IN (SELECT Role FROM Ref_AuthorizationRole 
						                WHERE  RoleOwner IN (SELECT ClassParameter 
				                       					       FROM  OrganizationAuthorization
														      WHERE  Role = 'AdminUser'
														        AND  AccessLevel = '2'
															    AND  UserAccount = '#SESSION.acc#'))
						 </cfif>		
						 --->
					</cfquery>	
										
				</cfloop>
				
				</cfif>
				
			</cfif>	
					
			</cftransaction>
			
			<cfif Get.AccountType eq "Group">
			
				<!--- sync the group as well --->
				 
				 <cfinvoke component="Service.Access.AccessLog"  
				  method       = "SyncGroup"
				  UserGroup    = "#UserAccount#"
				  UserAccount  = ""
				  Role         = "">	
			  
			</cfif>  			  
			  		
</cffunction>	
			
<!--- ------------------------------------------ --->
<!--- ------- 4. RESYNC WAREHOUSE ACCESS-------- --->
<!--- ------------------------------------------ --->
	
<cffunction access      = "public" 
            name        = "SyncWarehouseAccess"
			output      = "true" 
			returntype  = "string" 
			displayname = "Warehouse access is to be grouped by missionorgunitid which transcends the orgunit/mandate">		
			
<cfargument name="role"          type="string" required="true">	
<cfargument name="warehouse"     type="string" default="" required="yes">		

<cfquery name="CurrentMandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   TOP 1 *
      FROM     Ref_Mandate
   	  WHERE    Mission = '#Mission#' 
	  ORDER BY MandateDefault DESC
</cfquery>		

<!--- Hanno this is tricky once a mandate which is set as default is removed, as it will remove the access as well  but this
is an SOP action as it is not new for other access as well --->

<!--- --------------------------------------- --->
<!--- PENDING : OrganizationAuthorizationDeny --->
<!--- --------------------------------------- --->
		
<cfquery name="getResetRecords" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">	  
	  <!--- we get the current unit based on the linkage, this means orgunits from prior mandate that do not have a linkage to the current mandate will not be touched 
	  and should be deleted --->
	  SELECT  OA.Role, 
	          OA.UserAccount, 
			  OA.Mission, 
			  OA.ClassParameter, 
			  OA.Source, 
			  OA.GroupParameter, 
			  OA.OrgUnit, 
			  OrgCurrent.OrgUnit as OrgCurrent
	  FROM    OrganizationAuthorization OA INNER JOIN
	          Organization O ON OA.OrgUnit = O.OrgUnit INNER JOIN
	          Organization OrgCurrent ON O.MissionOrgUnitId = OrgCurrent.MissionOrgUnitId AND OrgCurrent.Mission = '#Mission#' AND OrgCurrent.MandateNo = '#CurrentMandate.MandateNo#'
	  WHERE   OA.Role = '#role#'
	  AND     OA.Mission = '#Mission#'
	
	  <!--- access has an existing orgunit defined ---> 
	  AND     OA.OrgUnit IN (SELECT   OrgUnit
	                         FROM     Organization
	                         WHERE    OrgUnit = OA.OrgUnit) 
	  
	  <!--- and access does not have an orgunit of the current mandate --->						 
	  AND     OA.OrgUnit NOT IN
	                        (SELECT   OrgUnit
	                         FROM     Organization
	                         WHERE    OrgUnit = OA.OrgUnit AND Mission = '#Mission#' AND MandateNo = '#CurrentMandate.MandateNo#') 
	  AND     OA.Mission = '#Mission#'
	 
  
</cfquery>


<cfloop query="getResetRecords">

	<cfquery name="check" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   OrganizationAuthorization
	  WHERE  Role           = '#role#'
	  AND    Mission        = '#Mission#'
	  AND    OrgUnit        = '#OrgCurrent#'
	  AND    UserAccount    = '#userAccount#'
	  AND    ClassParameter = '#ClassParameter#'
	  AND    Source         = '#Source#'
	  AND    GroupParameter = '#GroupParameter#' 	 
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="resetUnitToCurrent" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE OrganizationAuthorization
		  SET    OrgUnit        = '#OrgCurrent#'
		  WHERE  Role           = '#url.id4#'
		  AND    Mission        = '#Mission#'
		  AND    OrgUnit        = '#OrgUnit#'
		  AND    UserAccount    = '#userAccount#'
		  AND    ClassParameter = '#ClassParameter#'
		  AND    Source         = '#Source#'
		  AND    GroupParameter = '#GroupParameter#' 	 
		</cfquery>
		
	</cfif>

</cfloop>

<!--- ------------------------------------------------------------------------------------------------------------------- --->
<!--- and lastly we remove access entries linked to an orgunit of which the mandate is not equal than the current mandate --->

<cf_assignid>

<cfquery name="check" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * FROM OrganizationAuthorization
	  WHERE  Role    = '#url.id4#'
	  AND    Mission = '#Mission#'
	  AND    OrgUnit NOT IN (SELECT OrgUnit
	                         FROM   Organization 
							 WHERE  Mission = '#Mission#' 
							 AND    MandateNo = '#CurrentMandate.MandateNo#')       
	 
</cfquery>
	
<cfif check.recordcount gte "1">
	
		<cfquery name="Instance" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserAuthorizationAction
			        (ProfileActionId, UserAccount, Memo,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES  ('#rowguid#','#SESSION.acc#','Sync Warehouse Unit Access','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>
			
		<cfquery name="Log" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO UserAuthorizationActionLog
		        (ProfileActionId, 
				 ActionStatus, 
				 AccessId, 
				 Mission, 
				 OrgUnit, 
				 UserAccount, 
				 Role, 
				 ClassParameter, 
				 GroupParameter, 
				 ClassisAction, 
				 AccessLevel, 
				 Source, 
		         OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName, 
				 Created)
		SELECT   '#rowguid#',
		         '9',
		         AccessId,
				 Mission, 
				 OrgUnit, 
				 UserAccount,
				 Role, 
				 ClassParameter, 
				 GroupParameter, 
				 ClassIsAction, 
		         AccessLevel, 
				 Source, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName, 
				 getDate()
		FROM     OrganizationAuthorization
		WHERE    Role    = '#url.id4#'
		AND      Mission = '#Mission#'
		AND      OrgUnit NOT IN (SELECT OrgUnit
		                         FROM   Organization 
						         WHERE  Mission = '#Mission#' 
						         AND    MandateNo = '#CurrentMandate.MandateNo#')       			
		</cfquery>	
		
		<cfquery name="resetCurrentMandate" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  DELETE FROM OrganizationAuthorization
		  WHERE  Role    = '#url.id4#'
		  AND    Mission = '#Mission#'
		  AND    OrgUnit NOT IN (SELECT OrgUnit
		                         FROM   Organization 
								 WHERE  Mission = '#Mission#' 
								 AND    MandateNo = '#CurrentMandate.MandateNo#')       
		 
		</cfquery>
		
</cfif>	
	
	
</cffunction>	
		
<!--- -------------------------------------- --->
<!--- ------- 5. RESYNC GROUP ACCESS-------- --->
<!--- -------------------------------------- --->
	
	<cffunction access      = "public" 
	            name        = "SyncGroup"
				output      = "true" 
				returntype  = "string" 
				displayname = "Delete All">	
			
	  <cfargument name="userGroup"   type="string" required="true">	
	  <cfargument name="userAccount" type="string" required="true">		
	  <cfargument name="Role"        type="string" default=""         required="no">	
	  <cfargument name="Mode"        type="string" default="Standard" required="no">
	  	  	 
	  <!--- remove any group access of people that have no membership (anymore) : provision --->
	  
	  <cfif userAccount eq "">
	  
	  	  <!--- perform a clearance if case the whole group is synced --->
	  	
		  <cfquery name="Clean1" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE FROM OrganizationAuthorization
			  WHERE  UserAccount NOT IN (SELECT DISTINCT Account
									     FROM   System.dbo.UserNamesGroup
									     WHERE  AccountGroup = '#usergroup#')
			  AND    UserAccount != '#usergroup#'						
			  <cfif role neq "">
			  AND Role        = '#role#' 
			  </cfif>
			  AND Source      = '#usergroup#'	 
		   </cfquery>
			
		   <cfquery name="Clean2" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   DELETE FROM OrganizationAuthorizationDeny
			   WHERE  UserAccount NOT IN (SELECT DISTINCT Account
									      FROM   System.dbo.UserNamesGroup
									      WHERE  AccountGroup = '#usergroup#')
			   AND    UserAccount != '#usergroup#'						
			   <cfif role neq "">
			   AND Role        = '#role#' 
			   </cfif>
			   AND Source      = '#usergroup#'
			</cfquery>
		
		</cfif>
			
			
		<!--- 2. add access for each group member that is the same as for the group on this role --->
		
		<!--- Insert only access that did not exist before for the users --->
		
		<cfset FileNo = round(Rand()*50)>
		
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GroupProposed_#fileno#">	
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GroupExist_#fileno#">		
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GroupMatched_#fileno#">	
		
		<!--- make an action log of the linking --->
		
		<cf_assignid>
				
		<cfquery name="Instance" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserAuthorizationAction
			        (ProfileActionId, UserAccount, Memo,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES  ('#rowguid#','#usergroup#','Sync user group','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>
		
		<cfset timestamp = now()>
				
		<cfif Mode eq "Enforce">		
			
			 <!--- move to log file --->
			
			<cfquery name="Log" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserAuthorizationActionLog
			       (ProfileActionId, 
					 ActionStatus, 
					 AccessId, 
					 Mission, 
					 OrgUnit, 
					 UserAccount, 
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassisAction, 
					 AccessLevel, 
					 Source, 
			         OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created)
					 
			SELECT   '#rowguid#',
			         '9',
			         AccessId,
					 Mission, 
					 OrgUnit, 
					 UserAccount,
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassIsAction, 
			         AccessLevel, 
					 Source, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 #timestamp#
					 
			FROM     OrganizationAuthorization
			WHERE    Source   = '#UserGroup#'				
		  </cfquery>
		  
		  <!--- resets all access --->
					
			<cfquery name="reset" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM OrganizationAuthorization 
				WHERE Source      = '#usergroup#'						
			</cfquery>					
				
		</cfif>
				
		<!--- generate access records for all users in this user group --->
				
		<cfquery name="Generated" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT    DISTINCT A.Mission, 
			          A.OrgUnit, 
					  A.OrgUnitInherit,
					  G.Account as UserAccount, 
					  A.Role, 
					  A.ClassParameter, 
					  A.GroupParameter, 
					  '#usergroup#' as Source,
					  A.ClassIsAction,
					  A.AccessLevel
			INTO      userQuery.dbo.#SESSION.acc#GroupProposed_#fileno#
			FROM      OrganizationAuthorization A INNER JOIN
		              System.dbo.UserNamesGroup G ON A.UserAccount = G.AccountGroup 
			WHERE     G.AccountGroup = '#UserGroup#'
			AND       G.Account     != '#UserGroup#'	
			<cfif userAccount neq "">
			AND       G.Account      = '#UserAccount#'
			</cfif>
			<cfif role neq "">
			AND       A.Role         = '#role#' 
			</cfif>
			AND       Source = 'Manual'  
			
		</cfquery>
				
		<!--- retrieve already existing access records for these users in this user group --->
			
		<cfquery name="Existing" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT    A.AccessId,
			          A.Mission, 
			          A.OrgUnit, 
					  A.OrgUnitInherit, 
					  A.UserAccount, 
					  A.Role, 
					  A.ClassParameter, 
					  A.GroupParameter, 
					  A.Source,
					  A.ClassIsAction,
					  A.AccessLevel
			INTO      userQuery.dbo.#SESSION.acc#GroupExist_#fileno#
			FROM      OrganizationAuthorization A 
			WHERE     A.Source    = '#UserGroup#'
			AND       UserAccount != '#UserGroup#'	
			<cfif userAccount neq "">
			AND       UserAccount  = '#UserAccount#'
			</cfif>
			<cfif role neq "">
			AND       A.Role        = '#role#' 
			</cfif>
			
		</cfquery>
					
		<!--- match existing versus correct access --->
		
		<cfquery name="Matched" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
			SELECT   E.AccessId, 
			         P.Mission, 
					 P.OrgUnit, 
					 P.OrgUnitInherit,
					 P.UserAccount, 
					 P.Role, 
					 P.ClassParameter, 
					 P.GroupParameter, 
					 P.ClassIsAction, 
					 P.AccessLevel, 
					 P.Source
					 
			INTO     userQuery.dbo.#SESSION.acc#GroupMatched_#fileno#
			FROM     userQuery.dbo.#SESSION.acc#GroupProposed_#fileno# P LEFT OUTER JOIN
			         userQuery.dbo.#SESSION.acc#GroupExist_#fileno# E ON P.Mission = E.Mission 
								              AND P.OrgUnit        = E.OrgUnit 
											  AND P.OrgUnitInherit = E.OrgUnitInherit 
											  AND P.UserAccount    = E.UserAccount 
											  AND P.Role           = E.Role 
											  AND P.ClassParameter = E.ClassParameter 
											  AND P.GroupParameter = E.GroupParameter 
											  AND P.Source         = E.Source  
											  AND P.AccessLevel    = E.AccessLevel
											  
			WHERE     P.Mission IS NOT NULL AND P.OrgUnit IS NOT NULL
			
			UNION ALL
			
			SELECT   E.AccessId,
			         P.Mission, 
					 P.OrgUnit, 
					 P.OrgUnitInherit, 
					 P.UserAccount, 
					 P.Role, 
					 P.ClassParameter, 
					 P.GroupParameter, 
					 P.ClassIsAction, 
					 P.AccessLevel, 
					 P.Source
					 
			FROM     userQuery.dbo.#SESSION.acc#GroupProposed_#fileno# P LEFT OUTER JOIN
			         userQuery.dbo.#SESSION.acc#GroupExist_#fileno# E ON P.Mission = E.Mission 
					                          AND P.UserAccount    = E.UserAccount 
											  AND P.Role           = E.Role 
											  AND P.ClassParameter = E.ClassParameter 
											  AND P.GroupParameter = E.GroupParameter 
											  AND P.Source         = E.Source  
											  AND P.AccessLevel    = E.AccessLevel
											  
			WHERE    P.Mission IS NOT NULL AND P.OrgUnit IS NULL 
			
			UNION ALL
			
			SELECT   E.AccessId,
			         P.Mission, 
					 P.OrgUnit, 
					 P.OrgUnitInherit, 
					 P.UserAccount, 
					 P.Role, 
					 P.ClassParameter, 
					 P.GroupParameter, 
					 P.ClassIsAction, 
					 P.AccessLevel, 
					 P.Source
					 
			FROM     userQuery.dbo.#SESSION.acc#GroupProposed_#fileno# P LEFT OUTER JOIN
			         userQuery.dbo.#SESSION.acc#GroupExist_#fileno# E ON P.UserAccount = E.UserAccount 
					                          AND P.Role           = E.Role 
											  AND P.ClassParameter = E.ClassParameter 
											  AND P.GroupParameter = E.GroupParameter 
											  AND P.Source         = E.Source 
											  AND P.AccessLevel    = E.AccessLevel
											  
			WHERE    P.Mission IS NULL AND P.OrgUnit IS NULL
			
			ORDER BY P.UserAccount,
			         P.Role,
					 P.ClassParameter 
				 
		</cfquery>
						
		<!--- log exist that are not in matched --->
		
		<!--- remove existing access that are not in matched, it is not relvant anymore --->
		
		<cfquery name="Clean" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM OrganizationAuthorization  
			WHERE  AccessId IN (SELECT AccessId  
			                    FROM   userQuery.dbo.#SESSION.acc#GroupExist_#fileno# R
			                    WHERE  AccessId NOT IN (SELECT AccessId 
							                            FROM   userQuery.dbo.#SESSION.acc#GroupMatched_#fileno#
													    WHERE  AccessId is not NULL
													    AND    AccessId = R.AccessId
													    )
							   )    
	    </cfquery>
		
						
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GroupProposed_#fileNo#">	
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GroupExist_#fileNo#">		
				
		<!--- provision added  17/2/2009 remove any records in denied that are not valid
		as they exist in the master master authorization table because of the group sync --->
		
		<cfquery name="CleanGlobal" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
			DELETE OrganizationAuthorizationDeny
			FROM   OrganizationAuthorizationDeny D
			WHERE  UserAccount NOT IN (
			
		                           SELECT    G.Account
		                            FROM     OrganizationAuthorization AS A INNER JOIN
		                                     System.dbo.UserNamesGroup AS G ON A.UserAccount = G.AccountGroup
		                            WHERE    A.Source         = 'Manual' 
									AND      A.Role           = D.Role 
									AND      A.ClassParameter = D.ClassParameter
								  )
									 
			AND      Mission IS NULL	
			AND      OrgUnit IS NULL		
			AND      Source = '#UserGroup#' 
			
			
		</cfquery>
									
		<cfquery name="CleanMission" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
		
			<!--- remove access denial only if the person has manual entries for this role/parameter other we
			will remove his/her access which is synced from this role  --->	
		
			DELETE OrganizationAuthorizationDeny  	
			FROM   OrganizationAuthorizationDeny D		
			WHERE  UserAccount NOT IN (
			
								
		
	                           SELECT    G.Account
	                            FROM     OrganizationAuthorization AS A INNER JOIN
	                                     System.dbo.UserNamesGroup AS G ON A.UserAccount = G.AccountGroup
	                            WHERE    A.Mission        = D.Mission 
								AND      A.Source         = 'Manual' 
								AND      A.Role           = D.Role 
								AND      A.ClassParameter = D.ClassParameter
							  )
								 
			AND      Mission IS NOT NULL	
			AND      OrgUnit IS NULL		
			AND      Source = '#UserGroup#' 
						
		</cfquery>
					
		<cfquery name="CleanUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
			DELETE   OrganizationAuthorizationDeny 
			FROM     OrganizationAuthorizationDeny D
			WHERE    UserAccount NOT IN (
		
	                           SELECT    G.Account
	                            FROM     OrganizationAuthorization AS A INNER JOIN
	                                     System.dbo.UserNamesGroup AS G ON A.UserAccount = G.AccountGroup
	                            WHERE    A.Mission   = D.Mission 
								AND      A.OrgUnit   = D.OrgUnit
								AND      A.Source    = 'Manual' 
								AND      A.Role      = D.Role 
								AND      A.ClassParameter = D.ClassParameter
							  )
								 
			AND      Mission is NOT NULL	
			AND      OrgUnit is NOT NULL	
			AND      Source = '#UserGroup#'
			
		</cfquery>
				
				
		<!--- insert new access which is not matched yet --->
		
		<cfquery name="Insert" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO OrganizationAuthorization  
				      (Mission, 
					   OrgUnit, 
					   OrgUnitInherit,
					   UserAccount,
					   Role,
					   ClassParameter,
					   GroupParameter,
					   ClassIsAction,
					   AccessLevel,
					   Source,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName,
					   Created)
				SELECT DISTINCT 
				       Mission, 
				       OrgUnit, 
					   OrgUnitInherit,
					   UserAccount, 
					   Role, 
					   ClassParameter, 
					   GroupParameter, 
					   ClassIsAction, 
					   AccessLevel, 
					   Source,
				       '#SESSION.acc#', 
					   '#SESSION.last#',
					   '#SESSION.first#',
					   #timestamp#			  
			FROM   userQuery.dbo.#SESSION.acc#GroupMatched_#fileno#
			WHERE  AccessId is NULL	
			
		</cfquery>
						
		<!--- 3. Correction : remove access that was previously 
		specifically denied for the user (OrganizationAccessDeny) --->
		
		<cfif userAccount eq "">
	
			<cfquery name="Correction" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM OrganizationAuthorization 
				
			    WHERE    AccessId IN
				
		    	         	 (
							 
							   SELECT  Aut.AccessId
			        	       FROM    OrganizationAuthorizationDeny D, 
		    	        	           OrganizationAuthorization Aut 
							   WHERE   D.UserAccount = Aut.UserAccount 
								   AND D.Role        = Aut.Role 
								   AND D.Mission     = Aut.Mission 
								   AND D.OrgUnit     = Aut.OrgUnit 
								   AND D.ClassParameter = Aut.ClassParameter 
								   AND D.Source      = Aut.Source
								   AND Aut.AccessId  = OrganizationAuthorization.Accessid 
								   AND Aut.Mission IS not NULL
								   AND Aut.OrgUnit IS not NULL
								
							  UNION ALL
								   
							  SELECT  Aut.AccessId
			        	       FROM    OrganizationAuthorizationDeny D, 
		    	        	           OrganizationAuthorization Aut 
							   WHERE   D.UserAccount  = Aut.UserAccount 
								   AND D.Role         = Aut.Role 
								   AND D.Mission      = Aut.Mission 
								   AND D.ClassParameter = Aut.ClassParameter 
								   AND D.Source       = Aut.Source
								   AND Aut.AccessId   = OrganizationAuthorization.Accessid 
								   AND Aut.Mission IS not NULL
								   AND Aut.OrgUnit IS NULL  
								   
							  UNION ALL
								   
							  SELECT  Aut.AccessId
			        	       FROM    OrganizationAuthorizationDeny D, 
		    	        	           OrganizationAuthorization Aut 
							   WHERE   D.UserAccount = Aut.UserAccount 
								   AND D.Role = Aut.Role 
								   AND D.ClassParameter = Aut.ClassParameter 
								   AND D.Source = Aut.Source
								   AND Aut.AccessId   = OrganizationAuthorization.Accessid 
								   AND Aut.Mission is NULL
								   AND Aut.OrgUnit is NULL  
								   
						   )								   
								   	
		     </cfquery>		
			 		 
		</cfif> 		
		
		  <!--- move to log file --->
			
			<cfquery name="Log" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserAuthorizationActionLog
			       ( ProfileActionId, 				     
					 ActionStatus, 
					 AccessId, 
					 Mission, 
					 OrgUnit, 
					 UserAccount, 
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassisAction, 
					 AccessLevel, 
					 Source, 
			         OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created)
					 
			SELECT   '#rowguid#',			        
			         '1',
			         AccessId,
					 Mission, 
					 OrgUnit, 
					 UserAccount,
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassIsAction, 
			         AccessLevel, 
					 Source, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 #timestamp#
					 
			FROM     OrganizationAuthorization
			WHERE    Source = '#UserGroup#'
			 AND     Created = #timestamp#			
		  </cfquery>	
		  		 
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GroupMatched_#fileNo#">	
									 
	</cffunction>	 	
		
</cfcomponent>		