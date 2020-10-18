<cfcomponent>

<cfproperty name="WorkflowTree" type="string" displayname="Org Tree">

	<cffunction name="getNodesV2"
			access="remote"
			returntype="void">

		<cfargument name="path"   type="String" required="false" default=""/>
		<cfargument name="value"  type="String" required="true" default=""/>
		<cfargument name="filter" type="String" required="true" default=""/>

		<cfoutput>
			<cfset client.check = "#cgi.query_string#">
		</cfoutput>

		<!--- set up return array --->

		<cfset var result= arrayNew(1)/>
		<cfset var s =""/>

		<!--- if arguments.value is empty the tree is being built for the first time --->

		<cfif value is "">

			<cfquery name="SystemModule"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT DISTINCT
							A.Code,
							A.Description as Application,
							A.ListingOrder,
							R.SystemModule,
							M.Description,
							M.MenuOrder
							FROM    Ref_AuthorizationRole R,
									System.dbo.Ref_SystemModule M,
									System.dbo.Ref_ApplicationModule AM,
									System.dbo.Ref_Application A
							WHERE   R.SystemModule  = M.SystemModule
							AND     AM.SystemModule = M.SystemModule
							AND     AM.Code = A.Code
							AND     A.Usage = 'System'
							<cfif SESSION.isAdministrator eq "Yes">
							AND     Role IN (SELECT Role FROM Ref_Entity)
							<cfelse>
	
							<!--- show only roles and thus modules to which this system person has access
							through the entity class defined for it
							
							5/7/2014 : Hanno ****** we could limit this further based on Ref_EntityClassMission so we
							only show entities for which one or more classes have the mission of
							this role defined
							
							--->
	
							AND  (
							Role IN (
								SELECT  Role
								FROM    Ref_Entity R INNER JOIN
								        Ref_EntityClass RC ON R.EntityCode = RC.EntityCode
								WHERE   EntityClass IN (SELECT EntityClass
								FROM    Ref_EntityClassOwner
								WHERE   EntityCode = RC.EntityCode
								AND     EntityClassOwner IN (
										SELECT DISTINCT ClassParameter
										FROM   OrganizationAuthorization
										WHERE  Role        = 'AdminSystem'
										AND    UserAccount = '#SESSION.acc#')
									    )
								)
		
							OR
			
							R.SystemModule IN ( SELECT SystemModule
												FROM Ref_MissionModule
												WHERE Mission IN (SELECT Mission
																  FROM  OrganizationAuthorization
																  WHERE Role        = 'OrgUnitManager'
																  AND   AccessLevel = '3'  <!--- local administrator --->
																  AND   UserAccount = '#SESSION.acc#')
						  					)
							)
	

							</cfif>
				
				   ORDER BY A.ListingOrder, M.MenuOrder, R.SystemModule, M.Description
			</cfquery>

			<cfoutput query="SystemModule" group="Code">

				<cfif currentrow neq "1">
					<cfset s = structNew()/>
					<cfset s.value     = "xx#code#">
					<cfset s.img       = "">
					<cfset s.parent    =  "tree">
					<cfset s.leafnode=true/>
					<cfset s.expand    =  "true">
					<cfset s.display   = "">
					<cfset arrayAppend(result,s)/>
				</cfif>

				<cfset s = structNew()/>
				<cfset s.value     = "root#code#">
				<cfset s.img       = "">
				<cfset s.parent    =  "tree">
				<cfset s.expand    =  "true">
				<cfset s.display   = "<span style='font-weight:bold;font-size:18px;text-decoration: underline;' class='labelmedium'>#Application#</span>">

				<cfset arrayAppend(result,s)/>

			</cfoutput>

			<cfelseif find("root", value)>

			<cfset val = mid(value,5,len(value)-4)>

			<cfquery name="Module"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">

					SELECT  DISTINCT
							A.Code,
							A.Description as Application,
							A.ListingOrder,
							R.SystemModule,
							M.Description,
							M.MenuOrder
					FROM    Ref_AuthorizationRole R,
							System.dbo.Ref_SystemModule M,
							System.dbo.Ref_ApplicationModule AM,
							System.dbo.Ref_Application A
					WHERE   R.SystemModule  = M.SystemModule
					AND     AM.SystemModule = M.SystemModule
					AND     AM.Code = A.Code
					AND     A.Usage = 'System'
					<!--- filter on the module --->
					AND     A.Code = '#val#'
					<cfif SESSION.isAdministrator eq "Yes">
					AND     Role IN (SELECT Role FROM Ref_Entity)
					<cfelse>
						
						<!--- show only roles and thus modules to which this system person has access
						through the entity class defined for it --->

						AND (
							Role IN (
									SELECT  Role
									FROM    Ref_Entity R INNER JOIN
											Ref_EntityClass RC ON R.EntityCode = RC.EntityCode
									WHERE   EntityClass IN (SELECT EntityClass
															FROM   Ref_EntityClassOwner
															WHERE  EntityCode = RC.EntityCode
															AND    EntityClassOwner IN (
																		SELECT DISTINCT ClassParameter
																		FROM   OrganizationAuthorization
																		WHERE  Role        = 'AdminSystem'
																		AND    UserAccount = '#SESSION.acc#' )
																	)
									)
	
							OR
	
							R.SystemModule IN (SELECT SystemModule
												FROM   Ref_MissionModule
												WHERE  Mission IN (SELECT Mission
																	FROM   OrganizationAuthorization
																	WHERE  Role        = 'OrgUnitManager'
																	AND    AccessLevel = '3'  <!--- local administrator --->
																	AND    UserAccount = '#SESSION.acc#')
										   	  )
					       )


				</cfif>
				ORDER BY A.ListingOrder, M.MenuOrder, R.SystemModule, M.Description
			</cfquery>

			<cfoutput query="Module">

				<cfset s = structNew()/>
				<cfset s.value     = "#SystemModule#">
				<cfset s.img       = "">
				<cfset s.parent    =  "#Code#">
				<cfset s.display   = "<span class='labelmedium' style='color:0A72AF;font-size:17px;height:15px'>#Description#</span>">
				
				<cfset arrayAppend(result,s)/>

			</cfoutput>

			<cfelseif not find(":", value)>

			<cf_distributer>

			<cfquery name="workflow"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				SELECT   R.*
				FROM     Ref_Entity R INNER JOIN
						 Ref_AuthorizationRole Role ON R.Role = Role.Role
				WHERE    Role.SystemModule = '#Value#'
				AND      Operational = 1
				<cfif master eq "0">
					AND      EntityCode NOT IN ('SysReport','Release')
				</cfif>
				ORDER BY R.ListingOrder
			</cfquery>

			<cfoutput query="workflow">

				<cfset s = structNew()/>
				<cfset s.value     = "#value#:#EntityCode#">
				<cfset s.parent    =  "workflow">
				<cfset s.display   = "<span class='labelmedium' style='font-size:16px'>#EntityDescription#</span>">
				<cfset arrayAppend(result,s)/>

			</cfoutput>

			<cfelseif find(":", value) and not find("@",value)>

<!--- ---------------------------------------------------------------------------------------------- --->
<!--- ONLY visible for full administrator maybe to AdminSystem extend to a systemadministration role --->
<!--- ---------------------------------------------------------------------------------------------- --->

			<cfloop index="itm" list="#value#" delimiters=":">
				<cfset ent = itm>
			</cfloop>

			<cfif getAdministrator("*") eq "1">

				<cfset s = structNew()/>
				<cfset s.value     = "#value#@Configuration">
				<cfset s.img       = "#SESSION.root#/images/Configuration.png">
				<cfset s.parent    = "element">
				<cfset s.display   = "<span class='labelmedium' style='color:gray;font-size:14px;height:15px'>Configuration</span>">
				<cfset arrayAppend(result,s)/>

			</cfif>

			<cfquery name="entity"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Entity
				WHERE    EntityCode = '#ent#'
			</cfquery>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#@Authorization">
			<cfset s.img       = "#SESSION.root#/images/Authorization.png">
			<cfset s.parent    =  "element">
			<cfset s.leafnode=true/>
			<cfset s.display   = "<span class='labelmedium' style='color:gray;font-size:14px;height:15px'>Authorization">
			<cfset s.href      = "../../Access/Global/OrganizationListing.cfm?context=0&ID4=#entity.role#">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfquery name="Class"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_EntityClass R
					WHERE    EntityCode = '#itm#'
					AND      Operational = 1

				<cfif getAdministrator() eq "1">

					<!--- show all classes --->

				<cfelse>

					AND      (
					EXISTS (
					SELECT 'X'
					FROM   Ref_EntityClassOwner
					WHERE  EntityCode  = R.EntityCode
					AND    EntityClass = R.EntityClass

					)
					OR

					EXISTS (
					SELECT 'X'
					FROM   Ref_EntityClassMission
					WHERE  EntityCode  = R.EntityCode
					AND    EntityClass = R.EntityClass
					AND    Mission  IN (		 SELECT Mission
					FROM   OrganizationAuthorization
					WHERE  Role = 'OrgUnitManager'
					AND    AccessLevel = '3'  <!--- local administrator --->
					AND    UserAccount = '#SESSION.acc#'
				)
				)
				)

				</cfif>

			</cfquery>

			<cfoutput query="class">

				<cfquery name="Publish"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
					SELECT   R.*
					FROM     Ref_EntityClassPublish R
					WHERE    EntityCode  = '#ent#'
				AND      EntityClass = '#entityClass#'
				</cfquery>

				<cfset s = structNew()/>
				<cfset s.value     = "#value#@#EntityClass#_flow">
				<cfset s.img       = "#SESSION.root#/images/Workflow-Methods.png">
				<cfset s.parent    =  "element">
				<cfif Publish.recordcount eq "0">
					<cfset s.leafnode=true/>
				</cfif>

				<cfif len(entityClass) gte 6>
					<cfset name = "#entityClass#">
					<cfelseif len(EntityClassName) gt "10">
					<cfset name = "#entityClass#: #left(EntityClassName,10)#..">
				<cfelse>
					<cfset name = "#entityClass#: #EntityClassName#">
				</cfif>
				<cfset s.href      = "ClassAction/FlowView.cfm?connector=init&EntityCode=#ent#&EntityClass=#entityClass#">
				<cfset s.target    = "right">
				<cfset s.alt       = "#EntityClassName#">
				<cfset s.display   = "<span class='labelmedium' style='font-size:14px;height:15px'>#EntityClass#</span>">
				<cfset arrayAppend(result,s)/>

			</cfoutput>

			<cfelseif find(":", value) and find("@",value) and not find("^",value) and not find("_flow",value)>

			<cfset row=1>
			<cfloop index="itm" list="#value#" delimiters=":@">
				<cfif row eq "2">
					<cfset ent = itm>
				</cfif>
				<cfset row=row+1>
			</cfloop>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^step">
			<cfset s.img       = "#SESSION.root#/images/Settings-3.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:14px;height:15px'>General Settings</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityEdit.cfm?mode=default&mission=&id=#ent#">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^step">
			<cfset s.img       = "#SESSION.root#/images/Check.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:14px;height:15px'>Validation Rules</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=rule">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^step">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/WorkflowStep.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:14px;height:15px'>Action Steps</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=step">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^class">
			<cfset s.img       = "#SESSION.root#/images/Workflow-Classes.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:14px;height:15px'>Workflow Class</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=class">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^group">
			<cfset s.img       = "#SESSION.root#/images/User-Group.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:14px;height:15px'>Action Group</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=group">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^object">
			<cfset s.img       = "#SESSION.root#/images/Logos/Modules.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:14px;height:15px'>Reusable Objects</span>">
			<cfset s.leafnode=false/>
			<cfset arrayAppend(result,s)/>

			<cfelseif find(":", value) and find("@",value) and find("^",value) and not find("_flow",value)>

			<cfset row=1>
			<cfloop index="itm" list="#value#" delimiters=":@">
				<cfif row eq "2">
					<cfset ent = itm>
				</cfif>
				<cfset row=row+1>
			</cfloop>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^dialog">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/EntryForm.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;height:15px;color:black;'>Entry : Form</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=dialog">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>
			
			<cfset s = structNew()/>
			<cfset s.value     = "#value#^question">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Questionaire.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Entry : Questionaire</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=question">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>
			
			<cfset s = structNew()/>
			<cfset s.value     = "#value#^session">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Session.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Entry : Web session</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=session">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^field">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/EntryField.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;height:15px;color:black;'>Entry : Field</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=field">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>
			
			<cfset s = structNew()/>
			<cfset s.value     = "#value#^attach">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Attachment.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Entry : Attachment</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=attach">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>
			
			
			<cfset s = structNew()/>
			<cfset s.value     = "#value#^report">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Report.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Output : Report</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=report">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>			
			
			<cfset s = structNew()/>
			<cfset s.value     = "#value#^mail">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Mailout.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Output : eMail</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=mail">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>
		
			<cfset s = structNew()/>
			<cfset s.value     = "#value#^activity">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Subactivity.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Support : Sub Activity</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=activity">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>		
			

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^method">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Script.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Method : Script</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=method">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>

			<cfset s = structNew()/>
			<cfset s.value     = "#value#^document">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Report.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Master : Document</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=document">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>
			
			<!---
			<cfset s = structNew()/>
			<cfset s.value     = "#value#^rule">
			<cfset s.img       = "#SESSION.root#/images/Logos/System/Rule.png">
			<cfset s.parent    = "element">
			<cfset s.display   = "<span class='labelmedium' style='font-size:12px;color:black;'>Master : Business rule</span>">
			<cfset s.leafnode=true/>
			<cfset s.href      = "EntityAction/EntityDetail.cfm?EntityCode=#ent#&option=rule">
			<cfset s.target    = "right">
			<cfset arrayAppend(result,s)/>	
			--->	

			

		<cfelse>

			<cfset val = arrayNew(1)/>
			<cfset t = 1>
			<cfloop index="itm" list="#value#" delimiters=":@_">
				<cfset val[t] = itm>
				<cfset t = t+1>
			</cfloop>

			<cfquery name="Publish"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				SELECT   R.*
				FROM     Ref_EntityClassPublish R
				WHERE    EntityCode  = '#val[2]#'
			AND      EntityClass = '#val[3]#'
			</cfquery>

			<cfoutput query="Publish">

				<cfset s = structNew()/>
				<cfset s.value     = "#ActionPublishNo#">
				<cfset s.img       = "#SESSION.root#/images/Version.png">
				<cfset s.parent    =  "instance">
				<cfset s.leafnode=true/>
				<cfset s.href      = "ClassAction/FlowView.cfm?connector=init&PublishNo=#ActionPublishNo#&EntityCode=#val[2]#&EntityClass=#val[3]#">
				<cfset s.target    = "right">
				<cfset s.display   = "#DateFormat(dateEffective,CLIENT.DateFormatShow)#">
				<cfset arrayAppend(result,s)/>

			</cfoutput>

		</cfif>
		<cfscript>
			threadName = "ws_msg_" & createUUID();
			treenodes = result;

			msg = SerializeJSON(treenodes);

			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis","tree node ");
		}
				writeOutput(msg);
		</cfscript>

	</cffunction>
	

</cfcomponent>

