<cfcomponent>

	<cffunction name="getNodesV2" access="remote" returnFormat="json" output="false" secureJSON = "yes" verifyClient = "yes">

		<cfargument name="vpath"             required="true" default="">
		<cfargument name="value"             required="true" default="">
		<cfargument name="systemfunctionid"  required="true" default="">
		
		<cfset result = ArrayNew(1)>

		<cfset vmid = value>
		<cfif vmid eq "">

			<cfquery name="MissionType"
				datasource="AppsOrganization"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT DISTINCT M.MissionType
				FROM   Ref_Mission M, Ref_MissionModule R
				WHERE  M.Mission    = R.Mission
				AND    M.Operational  = 1
<!--- has vacancy enabled --->
				AND    R.SystemModule = 'Vacancy'
<!--- has indeed records --->
				AND    M.Mission IN (SELECT   Mission
									 FROM     Vacancy.dbo.Document
									 WHERE    Mission = M.Mission
									 AND      Status != '9')
									 AND      MissionType != 'Planning'
									 ORDER BY M.MissionType
								 
			</cfquery>

			<cfoutput query="MissionType">

				<cfset s = StructNew()>
				<cfset s.value   = "#MissionType#_type">
				<cfset s.parent  = "">
				<cfset s.display = "<span style='padding-bottom:6px;padding-top:6px;font-size:19px'>#MissionType#</span>">
				<cfset arrayAppend(result,s)/>
				<cfset s.expand="true"/>
				
			</cfoutput>

		<cfelse>

			<cfif find("_type",vmid) neq 0>

				<!--- show the missions --->

				<cfset tpe = replace(vmid,"_type","")>

				<cfquery name="MissionList"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT  M.Mission, (SELECT count(*)
											FROM   Vacancy.dbo.Document D
											WHERE  D.Mission = M.Mission
											AND    EntityClass IS NOT NULL
											<!--- has a track track --->
											AND    D.DocumentNo IN (SELECT ObjectKeyValue1
																	FROM   Organization.dbo.OrganizationObject
																	WHERE  EntityCode = 'VacDocument'
																	AND    Operational = 1)
											<!--- has at least one position associated to it --->
											AND    D.DocumentNo IN (SELECT DocumentNo
																	FROM   Vacancy.dbo.DocumentPost DP
																	WHERE  DP.DocumentNo = D.DocumentNo
																	AND    DP.PositionNo IN (SELECT PositionNo
																							 FROM   Employee.dbo.Position
																							 WHERE  PositionNo = DP.PositionNo)
																	 )
											AND    D.Status IN ('0')
											) as Total
						FROM     Ref_Mission M, Ref_MissionModule R
						WHERE    M.Mission    = R.Mission
						AND      M.MissionType = '#tpe#'
					    AND      M.Operational  = 1
						<!--- has vacancy enabled --->
						AND      R.SystemModule = 'Vacancy'
						<!--- has indeed records --->
						AND      M.Mission IN (SELECT Mission
						    				   FROM   Vacancy.dbo.Document
											   WHERE  Mission = M.Mission
											   AND    Status != '9')
						<!--- we better remove the module access --->					   
						AND    M.Mission IN ('DPPA-DPO','OCT')						   
						ORDER BY M.Mission
				</cfquery>

				<cfloop query="MissionList">

					<cfif MissionList.recordcount lte "4">
						<cfset exp = "true">
					<cfelse>
						<cfset exp = "false">
					</cfif>

						<cfinvoke component="Service.Access"
								method="vacancytree"
								mission="#Mission#"
								returnvariable="accessTree">

					<cfset mis = Mission>

					<cfquery name="Mandate"
							datasource="AppsOrganization"
							maxrows=1
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_Mandate
							WHERE    Mission = '#mis#'
							ORDER BY MandateDefault DESC, MandateNo DESC
					</cfquery>

					<cfif AccessTree eq "READ" or AccessTree eq "EDIT" or AccessTree eq "ALL">

						<cfset s = StructNew()>
						<cfset s.value   = "#mis#">
						<cfset s.parent  = "root">
						<cfset s.display = "<span class='labelit' style='padding-top:3px;padding-bottom:3px;font-size:17px'>#mis# [#total#]</span>">
						<cfset s.href    = "ControlListing.cfm?ID=MIS&Mission=#Mis#&Status=0&Entity=Both&Parent=All">
						<cfset s.target  = "right">
						<cfset arrayAppend(result,s)/>
						<cfset s.expand = exp/>

					</cfif>

				</cfloop>

				<cfelseif find("_status",vmid) eq 0 and
						find("_schedule",vmid) eq 0 and
						find("_org",vmid) eq 0 and
						find("_parent",vmid) eq 0 and
						find("_pending",vmid) eq 0>
					
					<cfoutput>
					
					<cf_tl id="Track status" var="vTrack">	 
				
					<cfset s = StructNew()>
					<cfset s.value   = "#vmid#_status">
					<cfset s.parent  = "root">
					<cfset s.display = "<span class='labelit' style='font-size:15px'>#vTrack#</span>">
					<cfset s.expand   = "true"/>
					<cfset s.leafnode = false/>
					<cfset arrayAppend(result,s)/>
					
					<cf_tl id="Candidate Schedule" var="vSchedule">
					
					<cfset s = StructNew()>
					<cfset s.value   = "#vmid#_schedule">
					<cfset s.parent  = "root">
					<cfset s.display = "<span class='labelit' style='font-size:15px'>#vSchedule#</span>">
					<cfset s.href    =  "../Schedule/ScheduleCalendar.cfm?ID=SCH&Mission=#vmid#&systemfunctionid=#systemfunctionid#">
					<cfset s.target   = "right">
					<cfset s.expand   = "true"/>
					<cfset s.leafnode = true/>
					<cfset arrayAppend(result,s)/>		
					
					<cf_tl id="Organization" var="vOrg">		
	
					<cfset s = StructNew()>
					<cfset s.value   = "#vmid#_org">
					<cfset s.parent  = "root">
					<cfset s.display = "<span class='labelit' style='font-size:15px'>#vOrg#</span>">
					<cfset s.expand="true"/>
					<cfset s.leafnode=false/>
					<cfset arrayAppend(result,s)/>
					
					</cfoutput>

				<cfelseif find("_status",vmid) neq 0>

				<cfset mis = replace(vmid,"_status","")>

				<cfquery name="Status"
						datasource="AppsVacancy"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT  DISTINCT R.*,
								(SELECT count(*)
								 FROM   Vacancy.dbo.Document D
								 WHERE  Status = R.Status
								 <!---
								 AND    D.DocumentNo IN (SELECT ObjectKeyValue1 FROM Organization.dbo.OrganizationObject WHERE EntityCode = 'VacDocument')
								 --->
								 AND    EntityClass IS NOT NULL
								 AND    Mission = '#mis#'
								 <!--- has a track track --->
								 AND    D.DocumentNo IN (SELECT ObjectKeyValue1
														 FROM   Organization.dbo.OrganizationObject
														 WHERE  EntityCode = 'VacDocument')
														 <!--- has at least one position associated to it --->
														 AND    D.DocumentNo IN (SELECT DocumentNo
																				 FROM   Vacancy.dbo.DocumentPost DP
																				 WHERE  DP.DocumentNo = D.DocumentNo
																				 AND    DP.PositionNo IN (SELECT PositionNo
																										  FROM   Employee.dbo.Position
																								  		  WHERE  PositionNo = DP.PositionNo)
																			    )	
								) as Total
						FROM    Ref_Status R
						WHERE   Class = 'Document'
						ORDER BY R.Status
				</cfquery>

				<cfloop query="Status">

					<cfset sta = Status.Status>
					<cfswitch expression="#sta#">
						<cfcase value="9">
							<cfset  vcolor="FF0000">
						</cfcase>
						<cfcase value="1">
							<cfset  vcolor="1EAB1B">
						</cfcase>
						<cfcase value="0">
						</cfcase>
					</cfswitch>

					<cfif sta neq "0">

						<cfset s = StructNew()>
						<cfset s.value   = "#mis#_pending,#sta#">
						<cfset s.parent  = "#mis#_status">
						<cfset s.display = "<span class='labelit' style='font-size:14px;color:#vcolor#'>#Description#&nbsp;:&nbsp;#total#</span>">						
						<cfset s.href    =  "ControlListing.cfm?ID=MIS&Mission=#mis#&Status=#Sta#&Entity=Both&Parent=All">
						<cfset s.expand  = "false"/>
						<cfset s.target  = "right">
						<cfset s.leafnode = true/>
						<cfset arrayAppend(result,s)/>

					<cfelse>

						<cfset s = StructNew()>
						<cfset s.value   = "#mis#_pending,#sta#">
						<cfset s.parent  = "#mis#_status">
						<cfset s.display = "<span class='labelit' style='font-size:14px'>#Description#&nbsp;:&nbsp;#total#</span>">
						<cfset s.href    = "ControlListing.cfm?ID=MIS&Mission=#mis#&Status=#Sta#&Entity=Both&Parent=All">
						<cfset s.target  = "right">
						<cfset s.expand  = "false"/>
						<cfset s.leafnode = false/>
						<cfset arrayAppend(result,s)/>

					</cfif>

				</cfloop>

				<cfelseif find("_pending",vmid) neq 0>

				<cfset clist = replace(vmid,"_pending","")>
				<cfset i="1">

				<cfloop list="#clist#" index="element" delimiters = ",">
					<cfswitch expression="#i#">
						<cfcase value="1">
							<cfset mis = element>
						</cfcase>
						<cfcase value="2">
							<cfset sta = element>
						</cfcase>
					</cfswitch>
					<cfset i = i + 1>
				</cfloop>

				<cfquery name="Parent"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM Organization.dbo.Ref_EntityActionParent RE
						WHERE EntityCode = 'VacDocument'
						AND EXISTS (SELECT *
									FROM   OrganizationObject OO
											INNER JOIN OrganizationObjectAction OA ON OA.ObjectId = OO.ObjectId
											INNER JOIN Ref_EntityAction RA ON OA.ActionCode = RA.ActionCode
									WHERE  OO.Mission = '#mis#'
									AND    RA.ParentCode = RE.Code
									AND    RA.EntityCode = RE.EntityCode
									AND    OO.Owner = RE.Owner
									)
						ORDER BY ListingOrder
						
				</cfquery>

				<cfloop query="Parent">

					<cfset s = StructNew()>
					<cfset s.value   = "#Description#">
					<cfset s.parent  = "#vmid#">
					<cfset s.display = "<span class='labelit' style='font-size:12px'>#Description#</span>">
					<cfset s.href    = "ControlListing.cfm?ID=MIS&Mission=#mis#&Status=#Sta#&Entity=VacDocument&Parent=#Code#">
					<cfset s.target  = "right">
					<cfset s.expand="true"/>
					<cfset s.leafnode=true/>
					<cfset arrayAppend(result,s)/>

				</cfloop>

				<cfquery name="Parent"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM organization.dbo.Ref_EntityActionParent RE
						WHERE EntityCode = 'VacCandidate'
						AND EXISTS (SELECT * 
									FROM OrganizationObject OO 
										INNER JOIN OrganizationObjectAction OA ON OA.ObjectId = OO.ObjectId 
										INNER JOIN Ref_EntityAction RA ON OA.ActionCode = RA.ActionCode
									WHERE OO.Mission = '#mis#'
									AND RA.ParentCode = RE.Code
									AND RA.EntityCode = RE.EntityCode
									AND OO.Owner      = RE.Owner )
					    ORDER BY ListingOrder
				</cfquery>

				<cfloop query="Parent">

					<cfset s = StructNew()>
					<cfset s.value    = "#Description#">
					<cfset s.parent   = "#vmid#">
					<cfset s.display  = "<span class='labelit' style='font-size:12px'>#Description#</span>">
					<cfset s.href     = "ControlListing.cfm?ID=MIS&Mission=#Mis#&Status=#Sta#&Entity=VacCandidate&Parent=#Code#">
					<cfset s.target   = "right">
					<cfset s.expand   = "true"/>
					<cfset s.leafnode = true/>
					<cfset arrayAppend(result,s)/>

				</cfloop>

				<cfelseif find("_org",vmid) neq 0>

				<cfset mis = replace(vmid,"_org","")>

				<cfquery name="Mandate"
						datasource="AppsOrganization"
						maxrows=1
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
					SELECT    *
					FROM     Ref_Mandate
					WHERE    Mission = '#mis#'
				ORDER BY MandateDefault DESC, MandateNo DESC
				</cfquery>

				<cfquery name="Level01"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization O
						WHERE (O.ParentOrgUnit is NULL OR O.ParentOrgUnit = '')
						AND   O.Mission = '#mis#'
						<!---
						AND   EXISTS (SELECT 'X'
									  FROM Vacancy.dbo.Document D 
										   INNER JOIN Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo 
										   INNER JOIN Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
										   INNER JOIN Organization O2 ON O2.OrgUnit = P.OrgUnitOperational
										   INNER JOIN Userquery.dbo.#SESSION.acc#Doc3_#CLIENT.FileNo# T  ON T.ObjectKeyValue1 = D.DocumentNo
									  WHERE D.Mission ='#mis#'
									  AND   O.HierarchyRootUnit = O2.HierarchyRootUnit
									  AND   D.Status != '9' )
									  
									  --->
									  
						AND   O.MandateNo = '#Mandate.MandateNo#'
						ORDER BY TreeOrder, OrgUnitName
				</cfquery>

				<cfloop query="level01">

					<cfif OrgUnitNameShort eq "">
						<cfset desc1 = OrgUnitName>
					<cfelse>
						<cfset desc1 = OrgUnitNameShort>
					</cfif>

					<cfset s = StructNew()>
					<cfset s.value    = "#mis#_parent,#OrgUnitCode#,#HierarchyRootUnit#">
					<cfset s.parent   = "#mis#_org">
					<cfset s.display  = "#desc1#">
					<cfset s.href     = "ControlListing.cfm?ID=MIS&Mission=#Mis#&HierarchyRootUnit=#HierarchyRootUnit#&OrgUnitName=#OrgUnitName#">
					<cfset s.target   = "right">
					<cfset s.expand   = "false"/>
					<cfset arrayAppend(result,s)/>

				</cfloop>

				<cfelseif find("_parent",vmid) neq 0>

				<cfset clist = replace(vmid,"_parent","")>
				<cfset i="1">

				<cfloop list="#clist#" index="element" delimiters = ",">
					<cfswitch expression="#i#">
						<cfcase value="1">
							<cfset mis = element>
						</cfcase>
						<cfcase value="2">
							<cfset ou = element>
						</cfcase>
						<cfcase value="3">
							<cfset hu = element>
						</cfcase>
					</cfswitch>
					<cfset i = i + 1>
				</cfloop>

				<cfquery name="Mandate"
						datasource="AppsOrganization"
						maxrows=1
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM    Ref_Mandate
						WHERE   Mission = '#mis#'
						ORDER BY MandateDefault DESC, MandateNo DESC
				</cfquery>

				<cfquery name="Level02"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization O
					WHERE  ParentOrgUnit = '#hu#'
					AND    O.Mission = '#mis#'
					<!--- show all level 2 units
					AND EXISTS	(
								SELECT 'X'
								FROM Vacancy.dbo.Document D 
									INNER JOIN Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo 
									INNER JOIN Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
									INNER JOIN  Organization O2 ON O2.OrgUnit = P.OrgUnitOperational
									INNER JOIN Userquery.dbo.#SESSION.acc#Doc3_#CLIENT.FileNo# T  ON T.ObjectKeyValue1 = D.DocumentNo
								WHERE D.Mission ='#mis#'
								AND   Left(O2.HierarchyCode,5) = O.HierarchyCode
								AND   O2.ParentOrgUnit = O.ParentOrgUnit
								AND   O2.MandateNo = '#Mandate.MandateNo#'
								AND   O2.HierarchyRootUnit = '#ou#'
								AND   D.Status != '9'
								)
								--->
					AND O.MandateNo = '#Mandate.MandateNo#'
					ORDER BY TreeOrder, OrgUnitName
				</cfquery>

				<cfloop query="level02">

					<cfquery datasource="AppsVacancy" name="qDocument">
						SELECT COUNT(1) as Total
						FROM   Document D 
								INNER JOIN DocumentPost DP ON D.DocumentNo = DP.DocumentNo 
								INNER JOIN Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
								INNER JOIN  Organization.dbo.Organization O2 ON O2.OrgUnit = P.OrgUnitOperational
								INNER JOIN Userquery.dbo.#SESSION.acc#Doc3_#CLIENT.FileNo# T  ON T.ObjectKeyValue1 = D.DocumentNo
						WHERE O2.HierarchyCode like '#Level02.HierarchyCode#%'
						AND   D.Mission        ='#mis#'
						AND   O2.MandateNo     = '#Mandate.MandateNo#'
						AND   D.Status = '0'
					</cfquery>

					<cfset org2 = orgunit>
					<cfif Level02.OrgUnitNameShort eq "">
						<cfset desc2 = Level02.OrgUnitName>
					<cfelse>
						<cfset desc2 = Level02.OrgUnitNameShort>
					</cfif>

					<cfset s2 = StructNew()>
					<cfset s2.value   = "#Level02.OrgUnit#">
					<cfset s2.parent  = "#mis#_parent,#ou#,#hu#">
					<cfset s2.display = "#desc2# (#qDocument.Total#)">
					<cfset s2.img     = "#SESSION.root#/Images/select.png">
					<cfset s2.href    = "ControlListing.cfm?ID=MIS&Mission=#Mis#&HierarchyRootUnit=#Level02.HierarchyRootUnit#&OrgUnitName=#desc2#&HierarchyCode=#Level02.HierarchyCode#">
					<cfset s2.target  = "right">
					<cfset s2.expand  = "false"/>
					<cfset s2.leafnode=true/>
					<cfset arrayAppend(result,s2)/>

				</cfloop>

			</cfif>

		</cfif>

		<cfscript>
			treenodes = result;
			msg = SerializeJSON(treenodes);
		</cfscript>

		<cfreturn msg>


	</cffunction>



</cfcomponent>

