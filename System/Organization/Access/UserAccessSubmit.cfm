

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.misrow" default="1">
<cfparam name="Form.grantalltrees" default="0">

<cfif Form.MisRow eq "0">

	<script>
	parent.ColdFusion.Window.hide('progress')
	alert("You must select one or more trees/missions for this role. Operation not allowed.")
	</script>
	<cfabort>
	
</cfif>

<cfset session.status = 0.0>  

<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_AuthorizationRole
	   WHERE  Role  = '#URL.ID#' 
	</cfquery>

<!--- remove role --->

<!--- define a id for the user action log --->	
<cf_AssignId>

<cfif url.id2 eq "0">
     <cfset url.id2 = "">
</cfif>
										   
<cfif url.id2 eq "" and url.id4 eq "">

	<cfset orgunit = "">	<!--- mission --->

<cfelseif url.id2 eq "" and url.id4 neq "">

    <!--- -------------------------------------------------------------------------------------- ---> 
	<!--- get the first unit to set as the root unit to be assigned from the mandate = root unit --->
	<!--- -------------------------------------------------------------------------------------- --->
		
	<cfquery name="orgunit"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT OrgUnit 			
		FROM   Organization 
		WHERE  Mission    = '#url.Mission#'
		AND    MandateNo  = '#url.id4#' 
		ORDER BY HierarchyCode 
	</cfquery>	
			
	<cfset orgunit = orgunit.orgunit>	<!--- mandate --->
	
<cfelse>
	
	<cfset orgunit = url.id2>  <!--- orgunit --->	
	
</cfif>	

<!--- create a list of current entries in the database for this user --->

<cfquery name="SelectBase" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT	ClassParameter+'-'+GroupParameter+'-'+Mission as ListBase,
	        ClassParameter+'-'+GroupParameter+'-'+Mission+'-'+AccessLevel+'-'+RecordStatus as ListAccess			
	FROM    OrganizationAuthorization A
	WHERE   A.UserAccount   = '#URL.ACC#' 
	AND     A.Role          = '#URL.ID#' 
	<cfif  orgunit neq "">
	AND     A.OrgUnit       = '#orgunit#'   
	<cfelse>
	AND     A.OrgUnit is NULL
	</cfif>				
	AND     Mission is not NULL
	
	UNION
	
	SELECT	ClassParameter+'-'+GroupParameter as ListBase,
			ClassParameter+'-'+GroupParameter+'-'+Mission+'-'+AccessLevel+'-'+RecordStatus as ListAccess			
	FROM    OrganizationAuthorization A
	WHERE   A.UserAccount   = '#URL.ACC#' 
	AND     A.Role          = '#URL.ID#' 
	<cfif  orgunit neq "">
	AND     A.OrgUnit       = '#orgunit#'   
	<cfelse>
	AND     A.OrgUnit is NULL
	</cfif>				
	AND     Mission is NULL 
	
</cfquery>


<!--- store existing entries in a list --->
<cfset base   = ValueList(SelectBase.ListBase)>
<cfset access = ValueList(SelectBase.ListAccess)>

<cfset st = "0">

<!--- -- progress bar -- --->
<cfset session.status = "0.2">  

<!--- ------------------ --->
<!--- get prior entries- --->

<CF_DropTable dbName="AppsQuery"  tblName="access#SESSION.acc#Before">
<CF_DropTable dbName="AppsQuery"  tblName="access#SESSION.acc#After">

<cfquery name="getPrior" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     UserAccount, 
	           Role, 
			   AccessId,
			   ISNULL(Mission, '') AS Mission, 
			   ISNULL(OrgUnit, '') AS OrgUnit, 
			   ClassParameter, 
			   GroupParameter, 
			   AccessLevel, 
			   Source, 
               RecordStatus
	INTO       userQuery.dbo.access#SESSION.acc#Before	   
	FROM       OrganizationAuthorization
	WHERE      UserAccount = '#URL.ACC#' 
	AND        Role        = '#URL.ID#'
</cfquery>	

<cftransaction>

<!--- define the subset of access for this user prior --->

<!--- ------------------ --->

<cfloop index="ms" from="1" to="#form.misrow#">  		

		<!--- -------------------------------- --->
        <!--- loop through the entity/missions --->
		<!--- -------------------------------- --->

    	<cfparam name="FORM.#ms#_Mission" default="">		
		<cfset URL.Mission = Evaluate("FORM.#ms#_Mission")>
				
		<cfparam name="FORM.#ms#_MissionCheck" default="">		
		<cfset MissionSel = Evaluate("FORM.#ms#_MissionCheck")>
		
		<cfset classparam = "">
		
		<cfif form.grantalltrees eq "0">
			<cfset ser = ms>
		<cfelse>
			<!--- repeated for all missions --->
		    <cfset ser = "1">			
		</cfif>
		
		<cfparam name="form.row" default="0">
		
		<cfloop index="itm" from="1" to="#form.row#">

				<cfif classparam eq "">
				
					<cfparam name="FORM.#ser#_classparameter_#itm#" default="">					
					<cfif Evaluate("FORM.#ser#_classparameter_#itm#") neq "">
					    <!--- has settings --->
					    <cfset classparam = evaluate("FORM.#ser#_classparameter_#itm#")>
					</cfif>
					
				</cfif>
				
		</cfloop>	
									
		<cfif classparam neq "">	
										
			<cfloop index="cl" from="1" to="#form.row#">				   
			   						
			   <cfparam name="FORM.#ser#_classparameter_#cl#"  default="">
			   <cfparam name="FORM.#ser#_groupparameter_#cl#"  default="">
			   <cfparam name="FORM.#ser#_accesslevel_#cl#"     default="">
			   <cfparam name="FORM.#ser#_mission_#cl#"         default="">
			   				  				   				
			   <cfset classparameter = evaluate("FORM.#ser#_classparameter_#cl#")>
			   <cfset groupparameter = evaluate("FORM.#ser#_groupparameter_#cl#")>
			   <cfset accesslevel    = evaluate("FORM.#ser#_accesslevel_#cl#")>				     				  		 
										   
			   <cfif MissionSel eq "">
			      <cfset accesslevel = "">
			   </cfif>
						  			   
			   <!--- provision to set the status to be overwritable by external structure, ET --->
			   <cfset status         = FORM.recordstatus>
			   
			   <!--- mission as a parameter --->			  					
			   <cfset accessmission  = evaluate("FORM.#ser#_mission_#cl#")>		
			   				    	  
			   <!--- only record an insert/delete if there is a change --->	  
			   <!--- field accessmission is the parameter for mission for the roster, to add as an attributes --->
			   
			   <cfif url.mission neq "" and mission neq "undefined">
			      <cfset sub = "#ClassParameter#-#GroupParameter#-#Mission#">
			   <cfelse>
			      <cfset sub = "#ClassParameter#-#GroupParameter#">
			   </cfif>
			   			  	
			    <!--- check if combination class,group, mission exists in db table --->
								
			   <cfif ListFind("#base#", "#sub#")>				   	   
				   <cfset exist = "1">							   
			   <cfelse>			   								   
				   <cfset exist = "0">	   							   
			   </cfif>	 
			   
			   <cfoutput>#exist#</cfoutput>
			  	  		   
			  			   			   
			   <!--- 
			      AccessLevel eq "" and exist eq "0" : user did not select and account has no entry 
				  AccessLevel neq "" and missionSel eq "" : user did select but not for that mission and has no entries 				  
				--->		
													
				<cfif (AccessLevel eq "" and exist eq "0")>				
								
				       <!---  No selected, no exist, skip --->
				
				<cfelseif (AccessLevel neq "" and missionSel eq "" and exist eq "0")>
								
				       <!---  selected, but not for that mission and not exist --->
						
				<cfelse>
											
					 <cfif url.mission neq "" and mission neq "undefined">					    			
					     <cfset acc = "#ClassParameter#-#GroupParameter#-#Mission#-#accesslevel#-#status#">												
					<cfelse>
					     <cfset acc = "#ClassParameter#-#GroupParameter#-#accesslevel#-#status#">
					</cfif>		
					
																											
					<cfif ListFind("#access#", "#acc#")>						
					   <!--- combination found already, so no action to be taken --->					   
					   <cfset diff = "0">						   				  		   					  
				    <cfelse>							 			     
					   <cfset diff = "1">	   				   					  					   
				    </cfif>	
					
					<!--- enforce refresh --->
					<cfif form.Rolldown eq "1">
						<cfset diff = "1">
					</cfif>								
								
																									    			   			   			   
				    <cfif diff eq "1" or accessmission neq "">		
										
					   <cfoutput>
					      <br><font size="1">#sub#</font>
					   </cfoutput>													
										        
					   <cfset st = "1">
					  					   
					   <!--- if GLOBAL, CLEAN the unit as you want to give it globally now --->					   
					   <!--- ----------Hanno Info : id2 = unit \ id4= mandate------------- --->
																	   
					   <cfif orgunit eq "">
					   
					   					   
					   	   <!--- when global access we can safely clean unit access --->	
					   							   
						   <cfquery name="Delete" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
								DELETE  FROM OrganizationAuthorization							
								WHERE   UserAccount   = '#URL.ACC#' 
								AND     Role          = '#URL.ID#' 							
								<cfif Mission neq "undefined">
									AND  OrgUnit is not NULL
									AND  Mission   = '#mission#'
								<cfelse>
									AND  Mission is NULL
									AND  OrgUnit is NULL
								</cfif>
								AND     Source         = 'Manual' 
								AND     ClassParameter = '#ClassParameter#'							
								<cfif GroupParameter neq "">
								AND     GroupParameter = '#GroupParameter#' 							
								</cfif>
							
							</cfquery>	
							
					   <cfelseif orgunit neq "">
					   					   
					   	    <!--- global mandate level access is then to be removed --->	
					   														   
						   <cfquery name="Delete" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
								DELETE  FROM OrganizationAuthorization							
								WHERE   UserAccount    = '#URL.ACC#' 
								AND     Role           = '#URL.ID#' 							
								AND     Mission        = '#mission#'
								AND     ( OrgUnit = '#orgunit#' or OrgUnitInherit = '#orgunit#' )								
								AND     Source         = 'Manual' 
								AND     ClassParameter = '#ClassParameter#'							
								<cfif GroupParameter neq "">
								AND     GroupParameter = '#GroupParameter#' 							
								</cfif>
								
							
							</cfquery>						   						   					   
					   
					   </cfif>							  
															  
					   <cfinclude template="UserAccessSubmitAction.cfm">
					   																				
				    </cfif>		
								   
				 </cfif>  
				 
				 <cfset prg = ms/form.misrow>
				 <cfset session.status = "#0.2+prg*0.6#">  
				 			   					  		
			</cfloop>		
			
		<cfelse>
		
		<!--- nada --->
										
		</cfif>
							
</cfloop>	

</cftransaction>


<!--- ----------------------------------------------- --->
<!--- define the subset of access for this user after --->
<!--- apply the differences to the log table          --->
<!--- ----------------------------------------------- --->

<cfquery name="getAfter" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     UserAccount, 
	           Role, 
			   AccessId,
			   ISNULL(Mission, '') AS Mission, 
			   ISNULL(OrgUnit, '') AS OrgUnit, 
			   ClassParameter, 
			   GroupParameter, 
			   AccessLevel, 
			   Source, 
               RecordStatus
	INTO       userQuery.dbo.access#SESSION.acc#After		   
	FROM       OrganizationAuthorization
	WHERE      UserAccount = '#URL.ACC#' 
	AND        Role        = '#URL.ID#'
</cfquery>	

<!--- compare the before and after and write the results into the logging table --->


<!--- log the action --->

<cf_assignid>

<cfparam name="URL.RequestId" default="">

<cfquery name="ProfileAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO UserAuthorizationAction
	        (ProfileActionId, 
			 UserAccount, 			
			 <cfif url.requestId neq "">
			 	RequestId,
				Memo,
			 <cfelse>
			 	Memo,
			 </cfif>
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
	VALUES  ('#rowguid#',
	         '#URL.ACC#',			
			 <cfif url.requestId neq "">
			  	'#URL.RequestId#',
			  	'Apply Request',
			 <cfelse>
			 	'Amendment', 
			 </cfif>
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
	
			(ProfileActionId,ActionStatus, 
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
		     '9',
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
				
		FROM   userQuery.dbo.access#SESSION.acc#Before
		
		WHERE  AccessId IN (
			
						    SELECT    Before.AccessId 
						    FROM      userQuery.dbo.access#SESSION.acc#Before Before LEFT OUTER JOIN
		                              userQuery.dbo.access#SESSION.acc#After After ON 
									          Before.Mission = After.Mission AND 
											  Before.OrgUnit = After.OrgUnit AND 
		                                      Before.ClassParameter = After.ClassParameter AND 
											  Before.GroupParameter = After.GroupParameter AND 
											  Before.AccessLevel = After.AccessLevel AND 
		                                      Before.Source = After.Source AND 
											  Before.RecordStatus = After.RecordStatus										  
		                    GROUP BY  After.AccessId, Before.AccessId
		                    HAVING    After.AccessId IS NULL
							
						   )	
				   
</cfquery>				   

<!--- -------------------------- --->
<!--- --log NEW/REVISED access-- --->
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
	        '1',
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
			
	FROM    userQuery.dbo.access#SESSION.acc#After
	
	WHERE   AccessId IN (	
						SELECT    After.AccessId 
						FROM      userQuery.dbo.access#SESSION.acc#After After LEFT OUTER JOIN
	                              userQuery.dbo.access#SESSION.acc#Before Before ON 
								             Before.Mission = After.Mission AND 
											 Before.OrgUnit = After.OrgUnit AND 
	                                         Before.ClassParameter = After.ClassParameter AND 
											 Before.GroupParameter = After.GroupParameter AND 
											 Before.AccessLevel = After.AccessLevel AND 
	                                         Before.Source = After.Source AND 
											 Before.RecordStatus = After.RecordStatus
	                    GROUP BY  After.AccessId, Before.AccessId
	                    HAVING    Before.AccessId IS NULL
					   )	

</cfquery>

<!--- check if indeed records were added --->

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 * 
	FROM   UserAuthorizationActionLog
	WHERE  ProfileActionId = '#rowguid#'
</cfquery>	

<cfif Check.recordcount eq "0">

	<cfquery name="clear" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM UserAuthorizationAction
		WHERE  ProfileActionId = '#rowguid#'
	</cfquery>
		
</cfif>

<CF_DropTable dbName="AppsQuery"  tblName="access#SESSION.acc#Before">
<CF_DropTable dbName="AppsQuery"  tblName="access#SESSION.acc#After">

<!--- ------------ --->
<!--- progress bar --->
<!--- ------------ --->

<cfset session.status = "0.8">

<!--- ------------ --->
		
<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  System.dbo.UserNames
	WHERE Account = '#URL.ACC#'
</cfquery>

<cfif Check.AccountType eq "Group">

    <!--- ----------------------------- --->
	<!--- ----sync access to members--- --->
	<!--- ----------------------------- --->			   
	
	<cfinvoke component="Service.Access.AccessLog"  
		  method       = "SyncGroup"
		  UserGroup    = "#URL.Acc#"
		  UserAccount  = ""
		  Role         = "#URL.ID#">	 
		  
<cfelse>

    <!--- SPECIAL PROVISION --->
    <!--- --------------------------------------------------------------------------- --->
	<!--- A. 10/12/2010 special action to clean missions are no longer valid -------- --->

	<cfquery name="CleanMission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		DELETE OrganizationAuthorization 
		FROM  OrganizationAuthorization O
		WHERE    O.Mission IS NOT NULL AND 
		         (
				 O.Mission NOT IN (SELECT Mission 
				                   FROM   Ref_Mission
							   	   WHERE  Mission = O.Mission)	
				 OR
				 O.Mission IN (SELECT Mission 
				               FROM   Ref_Mission 
							   WHERE  Mission = O.Mission
							   AND    Operational = 0)
				 )			  
		AND      UserAccount = '#URL.ACC#'
	</cfquery>
	
	<cfquery name="CleanMission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		DELETE  OrganizationAuthorizationDeny
		FROM     OrganizationAuthorizationDeny O
		WHERE    O.Mission IS NOT NULL AND 
		         (
				 O.Mission NOT IN (SELECT Mission 
				                   FROM Ref_Mission
							   	   WHERE Mission = O.Mission)	
				 OR
				 O.Mission IN (
				              SELECT Mission 
				              FROM    Ref_Mission 
							  WHERE   Mission = O.Mission
							  AND     Operational = 0)
				 )			  
		AND      UserAccount = '#URL.ACC#'		
	</cfquery>
	
	<!--- B. 10/12/2010 Hanno special action to clean missions that are no longer valid for this role 
	driven by account of alex sokol --->
	
	<cfquery name="CleanMission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		DELETE   OrganizationAuthorization
		FROM     OrganizationAuthorization A			
		WHERE    A.Role = 'OrgUnitManager'
		AND      A.ClassParameter !=  ( SELECT MissionOwner
		                                FROM   Ref_Mission 
										WHERE  Mission = A.Mission)	
		AND      A.UserAccount = '#URL.acc#'
	</cfquery>
	
	<!--- -------------------------------------------------------------- --->
	<!--- C. provision added to clean possible orphaned records DENY --- --->
	<!--- -------------------------------------------------------------- --->

	<!--- Note added  17/2/2009 remove any records in denied that are not valid because of the 
	fact that the group does not have the records anymore in authorization --->
			
	<cfquery name="CleanGlobal" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		DELETE   OrganizationAuthorizationDeny
		FROM     OrganizationAuthorizationDeny D
		WHERE    UserAccount NOT IN (
	
                            SELECT   G.Account
                            FROM     OrganizationAuthorization AS A INNER JOIN
                                     System.dbo.UserNamesGroup AS G ON A.UserAccount = G.AccountGroup
                            WHERE    A.Source         = 'Manual' 
							AND      A.Role           = D.Role 
							AND      A.GroupParameter = D.GroupParameter 
							AND      A.ClassParameter = D.ClassParameter
						  )
							 
		AND      Mission IS NULL		
		AND      OrgUnit is NULL	
		AND      UserAccount = '#Url.acc#'
	</cfquery>
	
	<cfset session.status = "0.9">
	  
	<cfquery name="CleanMission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		DELETE OrganizationAuthorizationDeny
		FROM   OrganizationAuthorizationDeny D
		WHERE   D.UserAccount NOT IN
	                          (SELECT     G.Account
	                            FROM      OrganizationAuthorization AS A INNER JOIN
	                                      System.dbo.UserNamesGroup AS G ON A.UserAccount = G.AccountGroup
	                            WHERE      (A.Mission = D.Mission) 
	                            AND (A.Source = 'Manual') 
	                            AND (A.Role = D.Role) 
	                            AND (A.GroupParameter = D.GroupParameter) 
	                            AND (A.ClassParameter = D.ClassParameter)
	                           ) 
		AND D.Mission IS NOT NULL 
		AND D.OrgUnit IS NULL 
		AND D.UserAccount = '#URL.acc#' 
	</cfquery>
	
	<cfquery name="CleanUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		DELETE 	OrganizationAuthorizationDeny
		FROM    OrganizationAuthorizationDeny D
		WHERE   UserAccount NOT IN (
	
                           SELECT    G.Account
                            FROM     OrganizationAuthorization AS A INNER JOIN
                                     System.dbo.UserNamesGroup AS G ON A.UserAccount = G.AccountGroup
                            WHERE    A.Mission = D.Mission 
							AND      A.OrgUnit = D.OrgUnit
							AND      A.Source = 'Manual' 
							AND      A.Role = D.Role 
							AND      A.GroupParameter = D.GroupParameter 
							AND      A.ClassParameter = D.ClassParameter
						  )
							 
		AND      D.Mission IS NOT NULL	
		AND      D.OrgUnit is not NULL	
		AND      D.UserAccount = '#URL.acc#'
	</cfquery>
	
	<!--- -------------------------------------------------------------- --->
	
</cfif>

<cfset session.status = "1.0">

<cfoutput>

<cfif url.box neq "">

	<!--- below is relevant from user profile edit --->
	
	<script language="JavaScript">	  
	    parent.parent.refreshaccess('#url.acc#')
		parent.parent.ProsisUI.closeWindow('myaccess',true)					
	</script>

<cfelse>

	<script language="JavaScript"> 	    
	    parent.parent.history.go()	
	    parent.parent.ProsisUI.closeWindow('myaccess',true)	    
	</script>

</cfif>
</cfoutput>

