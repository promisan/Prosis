<!---- System means all the functions areas that the user has access to --->

<cfparam name="CLIENT.languageId" default="">

<cfif CLIENT.LanguageId eq "">
	<cfset CLIENT.LanguageId = "ENG">	
</cfif>

<cfif isDefined("SESSION.login")>

	<cfif Attributes.Module eq "'System'">
		
		<cfif getAdministrator() eq "1">
				
		    <!--- access to all modules --->
			
			<cfquery name="SearchResult" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   SystemModule,
				         Description as FunctionName, 
					     'left' as FunctionTarget,
					     'System' as FunctionClass,
					     'Main' as MenuClass
				FROM     #client.LanPrefix#Ref_SystemModule 
				WHERE    Operational = 1
				AND      (MenuOrder != '0' and MenuOrder != '99') 
			    ORDER BY MenuOrder DESC
			</cfquery>
						
		<cfelse>	
		
			<cfquery name="Program" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   #client.LanPrefix#Ref_SystemModule 
				WHERE  SystemModule = 'Program'
				AND    Operational = 1
			</cfquery>
				
			<cfquery name="Roster" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   #client.LanPrefix#Ref_SystemModule 
				WHERE  SystemModule = 'Roster'
				AND    Operational = 1
			</cfquery>
			
			<cfquery name="Procurement" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   #client.LanPrefix#Ref_SystemModule 
				WHERE  SystemModule = 'Procurement'
				AND    Operational = 1
			</cfquery>
			
			<cfsavecontent variable="selected">
			       DISTINCT  <!--- M.MenuTemplate AS FunctionPath, --->
				   M.SystemModule, 
				   M.Description AS FunctionName, 
				   'left' AS FunctionTarget, 
				   M.MenuOrder, 
	               'System' AS FunctionClass, 
				   'Main' AS MenuClass			
			</cfsavecontent>
			
			<cftransaction isolation="READ_UNCOMMITTED">
			
			<cfquery name="Searchresult" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
												
			SELECT  #preservesingleQuotes(selected)#
			FROM    System.dbo.Ref_ModuleControl I INNER JOIN
	                System.dbo.Ref_ModuleControlRoleLevel R ON I.SystemFunctionId = R.SystemFunctionId INNER JOIN
	                OrganizationAuthorization A ON R.Role = A.Role INNER JOIN
	                System.dbo.#client.LanPrefix#Ref_SystemModule M ON I.SystemModule = M.SystemModule
			WHERE   A.UserAccount    = '#SESSION.acc#'
			AND     A.Accesslevel = R.AccessLevel
			AND     M.Operational    = 1
			AND     I.Operational    = 1
			AND     I.MainmenuItem   = 1
			AND     I.FunctionClass != 'Manuals'
			AND     M.MenuOrder     != '0' 		
			<!---  NOT MISSION ENABLED --->	
			AND     I.MenuClass     != 'Mission'
			
			UNION
			
			<!--- 2/12/2010 tuning for hiding function that are split by mission/entity 
			and for which the person has certainly no access --->
			
			SELECT  #preservesingleQuotes(selected)#
			FROM    System.dbo.Ref_ModuleControl I INNER JOIN
	                System.dbo.Ref_ModuleControlRoleLevel R ON I.SystemFunctionId = R.SystemFunctionId INNER JOIN
	                OrganizationAuthorization A ON R.Role = A.Role INNER JOIN
	                System.dbo.#client.LanPrefix#Ref_SystemModule M ON I.SystemModule = M.SystemModule
			WHERE   A.UserAccount = '#SESSION.acc#'
			AND     A.Accesslevel = R.AccessLevel
			AND     M.Operational    = 1
			AND     I.Operational    = 1
			AND     I.MainmenuItem   = 1
			AND     I.FunctionClass != 'Manuals'
			AND     M.MenuOrder != '0' 		
			<!---  MISSION ENABLED --->
			AND     I.MenuClass = 'Mission'
			AND     I.SystemModule IN (SELECT SystemModule 
			                           FROM   Ref_MissionModule 
									   WHERE  Mission = A.Mission)
						
			UNION
			
			<!--- NEW check if fly access was granted granted --->
			
			SELECT  #preservesingleQuotes(selected)#
			FROM    System.dbo.Ref_ModuleControl I INNER JOIN
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
			AND     I.MainmenuItem = 1
			AND     I.FunctionClass != 'Manuals'
			AND     M.MenuOrder != '0' 
			
			UNION
			
			<!--- role protected limited access to a user --->
			
			SELECT  #preservesingleQuotes(selected)# 
			FROM    System.dbo.Ref_ReportControl I INNER JOIN
	                System.dbo.Ref_ReportControlRole R ON I.ControlId = R.ControlId INNER JOIN
	                OrganizationAuthorization A ON R.Role = A.Role INNER JOIN
	                System.dbo.#client.LanPrefix#Ref_SystemModule M ON I.SystemModule = M.SystemModule
			WHERE   A.UserAccount    = '#SESSION.acc#'
			AND     M.Operational    = 1
			AND     I.Operational    = '1'		
			AND     I.FunctionClass != 'System'
			AND     M.MenuOrder     != '0' 
			
			AND     (R.ClassParameter is NULL or R.ClassParameter = '')
									
			UNION
			
			<!--- role && owner limited access for a user to a report  --->
			
			SELECT  #preservesingleQuotes(selected)# 
			FROM    System.dbo.Ref_ReportControl I INNER JOIN
	                System.dbo.Ref_ReportControlRole R ON I.ControlId = R.ControlId INNER JOIN
	                OrganizationAuthorization A ON R.Role = A.Role AND R.ClassParameter = A.ClassParameter INNER JOIN
	                System.dbo.#client.LanPrefix#Ref_SystemModule M ON I.SystemModule = M.SystemModule
			WHERE   A.UserAccount    = '#SESSION.acc#'
			AND     M.Operational    = 1
			AND     I.Operational    = '1'		
			AND     I.FunctionClass != 'System'
			AND     M.MenuOrder     != '0' 
			
			AND     (R.ClassParameter is NULL or R.ClassParameter = '')
			
			UNION
			
			SELECT  #preservesingleQuotes(selected)# 
			FROM    System.dbo.Ref_ReportControl I INNER JOIN
	                System.dbo.Ref_ReportControlUserGroup R ON I.ControlId = R.ControlId INNER JOIN
	                System.dbo.UserNamesGroup A ON R.Account = A.AccountGroup INNER JOIN
	                System.dbo.#client.LanPrefix#Ref_SystemModule M ON I.SystemModule = M.SystemModule
			WHERE   A.Account        = '#SESSION.acc#'
			AND     M.Operational    = 1
			AND     I.Operational    = 1 		
			AND     I.FunctionClass  != 'System'
			AND     M.MenuOrder      != '0' 
										
			UNION
			
			<!--- anonymous access disabled for application  --->
			
			SELECT  #preservesingleQuotes(selected)# 
			FROM    System.dbo.Ref_ModuleControl I INNER JOIN
	                System.dbo.#client.LanPrefix#Ref_SystemModule M ON I.SystemModule = M.SystemModule
			WHERE   M.Operational     = 1
			AND     M.MenuOrder      != '0' 
			AND     I.EnableAnonymous = 1	
			AND     I.MainmenuItem = 1
			AND     I.MenuClass      != 'Builder' and FunctionClass != 'Application'
			AND     I.Operational     = '1'
			<!--- added 15/4/2008 --->
			AND     I.FunctionClass  != 'Manuals'
			
			<cfif Program.recordcount eq "1">
			
			UNION
			
				SELECT #preservesingleQuotes(selected)#
				FROM    Ref_AuthorizationRole R INNER JOIN
				        Program.dbo.ProgramAccessAuthorization A ON R.Role = A.Role
						INNER JOIN
				        System.dbo.#client.LanPrefix#Ref_SystemModule M ON R.SystemModule = M.SystemModule
				WHERE   A.UserAccount = '#SESSION.acc#'
				AND     M.Operational = 1
				AND     M.MenuOrder != '0' 
			
			
			</cfif>
																		
			<cfif Roster.recordcount eq "1">
			
				UNION
				SELECT #preservesingleQuotes(selected)#
				FROM    Ref_AuthorizationRole R INNER JOIN
				        Applicant.dbo.RosterAccessAuthorization A ON R.Role = A.Role
						INNER JOIN
				        System.dbo.#client.LanPrefix#Ref_SystemModule M ON R.SystemModule = M.SystemModule
				WHERE   A.UserAccount = '#SESSION.acc#'
				AND     M.Operational = 1
				AND     M.MenuOrder != '0' 
				
			</cfif>
			
			<cfif Procurement.recordcount eq "1">
			
				UNION
				SELECT #preservesingleQuotes(selected)#
				FROM    Ref_AuthorizationRole R INNER JOIN
				        Purchase.dbo.RequisitionLineActor A ON R.Role = A.Role
						INNER JOIN
				        System.dbo.#client.LanPrefix#Ref_SystemModule M ON R.SystemModule = M.SystemModule
				WHERE   A.ActorUserId = '#SESSION.acc#'
				AND     M.Operational = 1
				AND     M.MenuOrder != '0' 
							
			</cfif>
			
			UNION
			
			<!--- show also if allowed through a usergroup --->
			
			SELECT  #preservesingleQuotes(selected)#
			FROM    System.dbo.Ref_ModuleControlUserGroup C INNER JOIN
	                   System.dbo.UserNamesGroup U ON C.Account = U.AccountGroup INNER JOIN
	                   System.dbo.Ref_ModuleControl S ON C.SystemFunctionId = S.SystemFunctionId INNER JOIN
	                   System.dbo.#client.LanPrefix#Ref_SystemModule M ON S.SystemModule = M.SystemModule
			WHERE   U.Account = '#SESSION.acc#'
			AND     M.Operational = 1
			AND     S.Operational = 1
			AND     S.FunctionClass != 'Manuals'
			AND     M.MenuOrder != '0' 
			
			ORDER BY FunctionClass, M.MenuOrder
			
			</cfquery>
			
			</cftransaction>
					
		</cfif>
		
	<cfelse>	
	
		
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_ModuleControl
		   WHERE     SystemModule = #PreserveSingleQuotes(Attributes.module)# 
		   	AND      FunctionClass IN (#PreserveSingleQuotes(Attributes.selection)#)  
			AND      MenuClass != 'Topic'
		   	AND      Operational  = '1'
		   ORDER BY  FunctionClass, MenuOrder 	  
		</cfquery>
		
					
		<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT     *
		   FROM       xl#client.languageId#_Ref_ModuleControl
		   WHERE      SystemModule  = #PreserveSingleQuotes(Attributes.module)# 
		   AND        FunctionClass IN (#PreserveSingleQuotes(Attributes.selection)#) 
		   AND      MenuClass != 'Topic'
		   AND        Operational = '1'
		   ORDER BY   FunctionClass, MenuOrder DESC
		</cfquery>	
							
		<!--- ----------------------------------------- --->	
		<!--- facility to update Ref_ModuleControl only --->
				
		<cfif (SearchResult.recordcount lt "3" or check.recordcount neq searchresult.recordcount or Attributes.Selection eq "'System'") and Attributes.Module eq "'Portal'">
				
			<cfset class = replace(Attributes.selection,"'","","ALL")>
			
			<cfquery name="Path" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_SystemModule
				WHERE  SystemModule = '#class#' 
			</cfquery>
					
			<cfset dir = "">
					
			<cfif Path.recordcount eq "1" and Path.MenuOrder neq "0">
				
				<cfloop index="itm" list="#Path.TemplateRoot#" delimiters="/">			
				  <cfif itm neq ".." and dir eq "">
				     <cfset dir = itm>
				  </cfif>	 		    
				</cfloop>
			
			</cfif>		
			
			<cfif class is "System" or left(class,5) eq "Admin">
			    <cfset lst = "Reports">
				<cfset row = 3>
			<cfelse>
			     <cfset row = 0>
			    <cfset lst = "Application,Inquiry,Maintenance,Reports">
			</cfif>
					
			<cfloop index="cl" list="#lst#" delimiters=",">
					
					<cfset row = row+1>
				
					<cftry>
				
						<cfquery name="Insert" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO  Ref_ModuleControl
							      (SystemModule, 
								  FunctionClass, 
								  FunctionName, 
								  MenuClass, 
								  MenuOrder, 
								  MainMenuItem,
								  FunctionDirectory, 
								  FunctionPath,
								  FunctionCondition)
						VALUES (#PreserveSingleQuotes(Attributes.module)# , 
							  '#class#', 
							  '#cl#', 
							  'Main', 
							  '#row#', 						  
							  <cfif cl eq "Reports">
							  '5', 
							  'CFReports',
							  'Menu.cfm',
							  'id=#class#'
							  <cfelse>
							  '1',
							  '#dir#',
							  '#cl#/Menu.cfm',
							  ''
							  </cfif>) 
					   </cfquery>
					   
					   <cfcatch></cfcatch>
					   
				   </cftry>
			
			</cfloop>
		
			<cfinclude template="../System/Modules/Functions/ModuleControl/ModuleLanguage.cfm">	
			
			<cfquery name="SearchResult" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT   *
				   FROM     xl#client.languageId#_Ref_ModuleControl
				   WHERE    SystemModule    = #PreserveSingleQuotes(Attributes.module)# 
				   AND      FunctionClass IN (#PreserveSingleQuotes(Attributes.selection)#) 
				   AND      Operational     = '1'
				   ORDER BY FunctionClass, MenuOrder DESC				   
			</cfquery>
									
		</cfif>
		
		<!--- ---------------------------------------------------- --->
		<!--- ---------------------------------------------------- --->
		<!--- ---------------------------------------------------- --->	
		      
	</cfif>   
	
<cfelse>

		<!---- Session variables do not exist ---->
	
		<cfquery name="SearchResult" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			SELECT   SystemModule,
			         Description as FunctionName, 
				     'left' as FunctionTarget,
				     'System' as FunctionClass,
				     'Main' as MenuClass
			FROM     #CLIENT.LanPrefix#Ref_SystemModule 
			WHERE    0 = 1
		</cfquery>		
		
</cfif>