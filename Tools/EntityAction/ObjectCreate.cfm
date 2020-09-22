
<!--- provision to clean OrganizationObject records that have no linkage anymore for that document --->

<!--- this was moved to a daily batch to be run API/WorkflowIntegrity

<cfif Entity.EnableIntegrityCheck eq "1">

	<cfset random = round(Rand()*30)>
 
 	<cfif random eq "5">
					
		<cfquery name="Clean" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		
		 <cfif Entity.EntityKeyField1 neq "" 
		     and Entity.EntityKeyField2 eq "" 
			 and Entity.EntityKeyField3 eq "" 
			 and Entity.EntityKeyField4 eq "">
		 
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE EntityCode = '#Entity.EntityCode#'
			 AND   ObjectKeyValue1 NOT IN (SELECT #Entity.EntityKeyField1#  
			                               FROM   #Entity.EntityTableName#
										   WHERE  #Entity.EntityKeyField1# = OO.ObjectKeyValue1)
			 AND   ObjectReference2 <> 'Embedded workflow'	
			 			 
		 </cfif>
		 
		 <cfif Entity.EntityKeyField2 neq "" 
			 and Entity.EntityKeyField3 eq "" 
			 and Entity.EntityKeyField4 eq "">	 
		 
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE  EntityCode = '#Entity.EntityCode#'
			 AND    ObjectKeyValue2 NOT IN
	                          (SELECT     #Entity.EntityKeyField2#
	                            FROM      #Entity.EntityTableName#
	                            WHERE     #Entity.EntityKeyField1# = OO.ObjectKeyValue1
								AND       #Entity.EntityKeyField2# = OO.ObjectKeyValue2)
			 AND    ObjectReference2 <> 'Embedded workflow'					
							
		 </cfif>
		 
		 <cfif Entity.EntityKeyField3 neq "">
		 	 	
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE EntityCode = '#Entity.EntityCode#'
			 AND   ObjectKeyValue3 NOT IN
	                          (SELECT     #Entity.EntityKeyField3#
	                            FROM      #Entity.EntityTableName#
	                            WHERE     #Entity.EntityKeyField1# = OO.ObjectKeyValue1
								AND       #Entity.EntityKeyField2# = OO.ObjectKeyValue2
								AND       #Entity.EntityKeyField3# = OO.ObjectKeyValue3)
			 AND   ObjectReference2 <> 'Embedded workflow'					
							  	
		 	 			 
		 </cfif>
		 
		 <cfif Entity.EntityKeyField4 neq "">
		 	 
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE   EntityCode = '#Entity.EntityCode#'
			 AND     ObjectKeyValue4 NOT IN (SELECT DISTINCT  #Entity.EntityKeyField4# 
			                                 FROM  #Entity.EntityTableName#
											 WHERE #Entity.EntityKeyField4# = OO.ObjectKeyValue4)
			 AND     ObjectReference2 <> 'Embedded workflow' 
					 
					 
		 </cfif>
			  
		</cfquery>	
				
		
	</cfif>	
	
	
	<!--- DISABLED on 25/11/2010 it has bad effects on the regeneration of the flow if the record was opened again for whatever
	reason
	
	<!--- ------------------------------------------------------------------------------------------------------- --->
	<!--- added option to reset the workflow if the master record is deactivated, driven by the contract workflow --->
	<!--- ------------------------------------------------------------------------------------------------------- --->
		
		
	<cftry>
	
		<cfif Entity.EntityKeyField4 neq "">
			
			<cfquery name="Clean" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE OrganizationObject
				 SET    Operational = 0
				 WHERE  ObjectKeyValue4 IN (SELECT DISTINCT #Entity.EntityKeyField4# 
				                            FROM  #Entity.EntityTableName# 
											WHERE ActionStatus = '9')
			 </cfquery>
			
		</cfif>
		
		<cfcatch></cfcatch>
	
	</cftry>
	
	--->
			
</cfif>

--->

<!--- check if object exists --->


<cfquery name="Object" 
 datasource="#attributes.Datasource#"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   Organization.dbo.OrganizationObject O WITH (NOLOCK) 
 WHERE  O.EntityCode   = '#Attributes.EntityCode#' 
 AND    O.Operational  = 1
        #preserveSingleQuotes(condition)#  
</cfquery>

<cfif Object.EntityClass neq "">
	<cfset attributes.EntityClass = Object.EntityClass>
	<cfset actionpublishNo        = Object.ActionPublishNo>
<cfelse>
	<cfset actionpublishNo        = Entity.ActionPublishNo>
	
</cfif>

<cfset objectid = "">

<cfif Entity.RecordCount gt "0">
	
	<cfif Object.Recordcount eq "0">	
	
				<!--- insert --->
			
			<cfif Attributes.Create eq "Yes">
			
				 <cfif Attributes.ObjectKey4 eq "">
				 
					<cf_AssignId>					
					
				<cfelse>
				
				    <cfset rowguid = Attributes.objectKey4>	
					
					<!--- check if this exists as PK in that case we create a new rowguid --->
					
					<cfquery name="Check" 
					 datasource="#attributes.Datasource#"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT *   
						 FROM   Organization.dbo.OrganizationObject WITH (NOLOCK)
						 WHERE  ObjectId = '#rowguid#'
					</cfquery>
					
					<cfif check.recordcount eq "1">
					
						<cf_AssignId>	
						
					</cfif>					
																		
				</cfif>								
				
				<cfquery name="InsertObject" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
				 INSERT INTO Organization.dbo.OrganizationObject 
				           (ObjectId, 
						    EntityCode,  
						    EntityGroup,
							EntityStatus,
							EntityClass,
							<cfif attributes.Owner neq "">
							Owner,
							</cfif>
							<cfif Attributes.Mission neq "">
							Mission,
							</cfif>							
							<cfif Attributes.OrgUnit neq "">
							OrgUnit,
							</cfif>							
							<cfif Attributes.PersonNo neq "">
							PersonNo,
							</cfif>							
							<cfif Attributes.PersonEMail neq "">
							PersonEMail,
							</cfif>
							<cfif Attributes.ProgramCode neq "">
							ProgramCode,
							</cfif>
							ObjectKeyValue1, 
							ObjectKeyValue2, 
							ObjectKeyValue3,
							ObjectKeyValue4,
							ObjectReference,
							ObjectReference2,
							ObjectFilter,
							ObjectURL, 
							ObjectDue,
							ActionPublishNo,
							ParentObjectId,
							OfficerLastName,
							OfficerFirstName,
							OfficerNodeIP,
							OfficerHostName,
							OfficerUserId)
				 VALUES ('#rowguid#', 
				         '#Attributes.EntityCode#',
						 '#Attributes.EntityGroup#',
						 '#Attributes.EntityStatus#', 
						 '#Attributes.EntityClass#',
						 <cfif attributes.Owner neq "">
							 '#Attributes.Owner#',
						 </cfif>
						 <cfif Attributes.Mission neq "">
							 '#Attributes.Mission#',
						 </cfif>
						 <cfif Attributes.OrgUnit neq "">
						     '#Attributes.OrgUnit#',
						 </cfif>						 
						 <cfif #Attributes.PersonNo# neq "">
						     '#Attributes.PersonNo#',
						 </cfif>									 
						 <cfif #Attributes.PersonEMail# neq "">
						     '#Attributes.PersonEMail#',
						 </cfif>
						 <cfif Attributes.ProgramCode neq "">
							 '#Attributes.ProgramCode#',
						 </cfif>
						 <cfif #Attributes.ObjectKey1# neq "">
						     '#Attributes.ObjectKey1#', 
						 <cfelse> NULL,</cfif>
						 <cfif #Attributes.ObjectKey2# neq "">
						     '#Attributes.ObjectKey2#', 
						 <cfelse> NULL,</cfif>
						 <cfif #Attributes.ObjectKey3# neq "">
						    '#Attributes.ObjectKey3#', 
						 <cfelse> NULL,</cfif>
						 <cfif #Attributes.ObjectKey4# neq "">
						    '#Attributes.ObjectKey4#', 
						 <cfelse> NULL,</cfif>
						 '#Attributes.ObjectReference#',
						 '#Attributes.ObjectReference2#',	
						 '#Attributes.ObjectFilter#',
						 <cfif len(Attributes.ObjectURL) lte 200>
						 '#Attributes.ObjectURL#',	
						 <cfelse>
						 '',
						 </cfif>
						 <cfif Attributes.ObjectDue neq "">
						     '#Attributes.ObjectDue#',
						 <cfelse>
						     NULL,
						 </cfif>
						 '#Entity.ActionPublishNo#',
						  <cfif Attributes.ParentObjectId neq "">
						     '#Attributes.ParentObjectId#', 
						  <cfelse> NULL,</cfif>
						 '#SESSION.last#',
						 '#SESSION.first#',						
						 '#CGI.Remote_Addr#', 							
						 '#CGI.HTTP_HOST#', 
						 '#SESSION.acc#') 
				</cfquery>		
				
				<cfif attributes.ParentObjectId neq "">
				
					<cfquery name="SubflowPrior" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT      TOP 1 *
						 FROM        OrganizationObject
						 WHERE       ParentObjectId = '#attributes.ParentObjectId#' 
						 AND         EntityClass = 'sUmoja' 
						 AND         ObjectId <>  '#rowguid#'
						 ORDER BY    Created DESC
					 </cfquery>	 
					 
					 <cfif subflowPrior.recordcount eq "1">
					
						<cfquery name="AddInfo" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							    INSERT INTO OrganizationObjectInformation
								       (ObjectId, DocumentId, DocumentSerialNo, DocumentDescription, DocumentItem, DocumentItemValue, 
									    OfficerUserId, OfficerLastName, OfficerFirstName,Created)
								SELECT '#rowguid#',
								        DocumentId, DocumentSerialNo, DocumentDescription, DocumentItem, DocumentItemValue, 
									    OfficerUserId, OfficerLastName, OfficerFirstName,Created      				   
							 	FROM   OrganizationObjectInformation
								WHERE  ObjectId = '#SubflowPrior.ObjectId#'		
						</cfquery>
					
						<!--- questionaire --->
					
						<cfquery name="ReinstateNewHeader" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							    INSERT INTO OrganizationObjectQuestion
								       ( ObjectId, ActionCode, QuestionId, QuestionScore, QuestionMemo, QuestionAttachment, 
									    OfficerUserId, OfficerLastName, OfficerFirstName, Created )
								SELECT '#rowguid#',ActionCode, QuestionId, QuestionScore, QuestionMemo, QuestionAttachment, 
									    OfficerUserId, OfficerLastName, OfficerFirstName, Created			   
							 	FROM   OrganizationObjectQuestion
								WHERE  ObjectId = '#SubflowPrior.ObjectId#'	
						</cfquery>	
		
					</cfif>
								
				</cfif>		
																							
				<cfset objectid = "#rowguid#">
				<cfset order    = "0">
				<cfset trigger  = "">
				<cfset floword  = "0">
				
				<!--- declare documents to be attached --->
				
				<cfquery name="InsertAttach" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					INSERT INTO Organization.dbo.OrganizationObjectDocument
					        (ObjectId,
						    DocumentId,
							DocumentCode,
							OfficerUserId, 
							OfficerLastName,
							OfficerFirstName)
					SELECT  '#rowguid#',
					        DocumentId,
						    DocumentCode,
						    '#SESSION.acc#',
						    '#SESSION.last#',
						    '#SESSION.first#'
					FROM    Organization.dbo.Ref_EntityDocument
					WHERE   EntityCode   = '#Attributes.EntityCode#' 
					AND     DocumentType = 'attach'
					AND     Operational = 1
					
					<!--- only documents that are enabled in the actions of the flow --->
					
					AND     DocumentId IN (
					
							SELECT     DocumentId
							FROM       Organization.dbo.Ref_EntityActionPublishDocument
							WHERE      ActionPublishNo = '#Entity.ActionPublishNo#'
					
					)
					
										
					
				</cfquery>	
				
				<!--- ---------------------------------------------- --->
				
				<!--- record the initial fly actors from the external definition --->										
																						
				<cfif objectid neq "">
																	
					<cfquery name="firstAction" 
					 datasource="#attributes.Datasource#"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">					 
						 SELECT   TOP 1 OA.*
						 FROM     Organization.dbo.OrganizationObjectAction OA WITH (NOLOCK)
						 WHERE    OA.ObjectId = '#objectid#' 
						 AND      ActionStatus = '0'
						 ORDER BY ActionFlowOrder asc						 
					 </cfquery>	
								
					<cfloop index="itm" list="FlyActor,FlyActor2,FlyActor3">
											
					<cfparam name="attributes.#itm#"       default="">
					<cfparam name="attributes.#itm#Action" default="">
							
					<cfset flyact  = evaluate("attributes.#itm#")>
					<cfset flycde  = evaluate("attributes.#itm#Action")>
																
						<cfif flyact neq "">						
													
						   <cfset setaction = FirstAction.actioncode>
						
						   <cfif flycde neq "">
								
								<cfquery name="CheckAction" 
								 datasource="#attributes.Datasource#"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								    SELECT * 
									FROM   Organization.dbo.Ref_EntityAction
									WHERE  ActionCode   = '#flycde#'						
								</cfquery>
							
							    <cfif CheckAction.recordcount eq "1">							
								    <cfset setaction = flycde>								
								</cfif>
									
							</cfif>
									
							<cfquery name="ActionCodeValid" 
								 datasource="#attributes.Datasource#"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								    SELECT * 
									FROM   Organization.dbo.Ref_EntityAction
									WHERE  ActionCode   = '#setaction#'						
							</cfquery>							
							
							<cfif ActionCodeValid.recordcount eq "1">
						
								<cfquery name="CheckAccess" 
								 datasource="#attributes.Datasource#"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								     SELECT * 
									 FROM   Organization.dbo.OrganizationObjectActionAccess WITH (NOLOCK)
									 WHERE  ObjectId     = '#objectid#'
									 AND    ActionCode   = '#SetAction#'
									 AND    UserAccount  = '#flyact#' 
								</cfquery>
											
								<cfif CheckAccess.recordcount eq "0">																
								
									<cfquery name="InsertFlyAccess" 
									 datasource="#attributes.Datasource#"
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
									 INSERT INTO Organization.dbo.OrganizationObjectActionAccess
						  	                  (ObjectId,
											   ActionCode,
											   UserAccount,
											   AccessLevel,
											   OfficerUserId,
											   OfficerLastName,
											   OfficerFirstName)
									 VALUES ('#objectid#', 
											 '#SetAction#',
											 '#flyact#',
											 '1',
											 '#SESSION.acc#',
											 '#SESSION.last#',
											 '#SESSION.first#' )												 
									</cfquery>
								
								</cfif>
							
							</cfif>
								
						</cfif>	
							
					</cfloop>
					
				</cfif>	
				
				<cfinclude template="ObjectStepNew.cfm">	
																					
		</cfif>	
					
	<cfelse>			
					
		    <!--- remove workflow settings that relate to invalid wf steps --->
	
			<cfquery name="Clean" 
			 datasource="#attributes.Datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   DELETE FROM Organization.dbo.Ref_EntityActionPublishProcess
			   WHERE       ActionPublishNo = '#Object.ActionPublishNo#' 
			   AND         ProcessActionCode NOT IN
			                   (SELECT  ActionCode
			                    FROM    Organization.dbo.Ref_EntityActionPublish
			                    WHERE   ActionPublishNo = '#Object.ActionPublishNo#')
			</cfquery>		
					
			<!--- ---------------------------------------------- --->
			<!--- ----provision to initially record fly actors-- --->
			<!--- ---------------------------------------------- --->
						
			<cfif Attributes.Create eq "Yes">
													
				<cfquery name="firstAction" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT TOP 1 OA.*
					 FROM   Organization.dbo.OrganizationObjectAction OA WITH (NOLOCK)
					 WHERE  OA.ObjectId = '#Object.ObjectId#'  
					 AND    ActionStatus = '0'
					 ORDER BY ActionFlowOrder asc					 					
				 </cfquery>				 
				 					
				<cfloop index="itm" list="FlyActor,FlyActor2,FlyActor3">
				
									
				<cfparam name="attributes.#itm#"       default="">
				<cfparam name="attributes.#itm#Action" default="">
						
				<cfset flyact  = evaluate("attributes.#itm#")>
				<cfset flycde  = evaluate("attributes.#itm#Action")>
															
					<cfif flyact neq "">	
												
					   <cfset setaction = FirstAction.actioncode>
					
					   <cfif flycde neq "">
							
							<cfquery name="CheckAction" 
							 datasource="#attributes.Datasource#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							    SELECT * 
								FROM   Organization.dbo.Ref_EntityAction
								WHERE  ActionCode   = '#flycde#'						
							</cfquery>
						
						    <cfif CheckAction.recordcount eq "1">							
							      <cfset setaction = flycde>								
							</cfif>
								
						</cfif>
					
					    <cfif setAction neq "">
					
							<cfquery name="CheckAccess" 
							 datasource="#attributes.Datasource#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							     SELECT  * 
								 FROM    Organization.dbo.OrganizationObjectActionAccess WITH (NOLOCK)
								 WHERE   ObjectId     = '#Object.objectid#'
								 AND     ActionCode   = '#SetAction#'
								 AND     UserAccount  = '#flyact#' 
							</cfquery>
										
							<cfif CheckAccess.recordcount eq "0">	
							
								<cftry>    	       				
							
								<cfquery name="InsertFlyAccess" 
								 datasource="#attributes.Datasource#"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								 INSERT INTO Organization.dbo.OrganizationObjectActionAccess
						  	                  (ObjectId,
											   ActionCode,
											   UserAccount,
											   AccessLevel,
											   OfficerUserId,
											   OfficerLastName,
											   OfficerFirstName)
								 VALUES  ('#Object.ObjectId#', 
										  '#SetAction#',
										  '#flyact#',
										  '1',
										  '#SESSION.acc#',
										  '#SESSION.last#',
										  '#SESSION.first#' )
								</cfquery>
								
								<cfcatch></cfcatch>
								
								</cftry>
							
							</cfif>
					
						</cfif>
					
					</cfif>	
						
				</cfloop>
				
			</cfif>	
	
			<!--- ---------------------------------------------- --->
						
			<cfquery name="Actions" 
			 datasource="#attributes.Datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT OA.*
				 FROM   Organization.dbo.OrganizationObjectAction OA WITH (NOLOCK)
				 WHERE  OA.ObjectId = '#Object.ObjectId#' 
			 </cfquery>				 
			 
			 <cfquery name="Update" 
			 datasource="#attributes.Datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE Organization.dbo.OrganizationObject 
				 SET    ObjectFilter    = '#Attributes.ObjectFilter#',
						<cfif Attributes.ProgramCode neq "">
						    ProgramCode     = '#Attributes.ProgramCode#', 
					    </cfif> 							
				        <cfif len(Attributes.ObjectURL) lte 200 and len(Attributes.ObjectURL) gte 10>
				            ObjectURL       = '#Attributes.ObjectURL#',
						</cfif>
				  		<cfif Attributes.ParentObjectId neq "">
						    ParentObjectId = '#Attributes.ParentObjectId#', 
					    </cfif> 	
						<cfif Attributes.ObjectDue neq "">
						ObjectDue        = '#Attributes.ObjectDue#',
						</cfif>
						ObjectReference  = '#Attributes.ObjectReference#',
				        ObjectReference2 = '#Attributes.ObjectReference2#'	  
				  WHERE ObjectId    = '#Object.ObjectId#'   
				  AND   Operational  = 1  
			 </cfquery>				 
			 			 
			 <cfset objectid = "#Object.Objectid#">
			 
			 <cfif Actions.RecordCount eq "0">
			 
			     <cfset order     = "0">
				 <cfset trigger   = "">
				 <cfset floword   = "0">
				
				 <cfinclude template="ObjectStepNew.cfm">				 
									 
			 <cfelse>
			 
				 <cfquery name="Object" 
					 datasource="#attributes.Datasource#"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT DISTINCT O.*, R.*
					 FROM   Organization.dbo.OrganizationObject O WITH (NOLOCK),
							Organization.dbo.Ref_Entity R WITH (NOLOCK)
					 WHERE  O.ObjectId = '#Object.Objectid#'
					 AND    O.EntityCode = R.EntityCode
					 AND    O.Operational  = 1
				</cfquery>
						   
			    <cfinclude template="ObjectStep.cfm">  				
					  				 	 
			 </cfif>
			 
			 			 
			 <!--- disable not needed, object should be set to operational = 0
			 
			  <cfif Object.ActionPublishNo neq Entity.ActionPublishNo>			 
			 			
				 <cfquery name="Update" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 UPDATE OrganizationObject 
						 SET    ActionPublishNo = '#Entity.ActionPublishNo#'								
						 WHERE ObjectId    = '#Object.ObjectId#'   
						 AND   Operational  = 1 
					 </cfquery>		
										 
			 </cfif>	
			 
			 --->
		
			 <cfif Object.OrgUnit neq Attributes.OrgUnit and Attributes.OrgUnit neq "">
			 
			 	<cftry>
		
				 <cfquery name="Update" 
					 datasource="#attributes.Datasource#"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 UPDATE Organization.dbo.OrganizationObject 
						 SET    Orgunit      = '#Attributes.OrgUnit#',
						        Mission      = '#Attributes.Mission#'											
						 WHERE  ObjectId     = '#Object.ObjectId#'   
						 AND    Operational  = 1 
					 </cfquery>		
					 
				 <cfcatch></cfcatch>
					 
				 </cftry>
					 
			 </cfif>	
							 
			 <cfif Attributes.PersonEMail neq Object.PersonEMail>

				 <cfquery name="Update" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 UPDATE Organization.dbo.OrganizationObject 
				 SET    PersonEMail = '#Attributes.PersonEMail#'		
				 WHERE  ObjectId    = '#Object.ObjectId#'   
				 AND    Operational  = 1 
			 </cfquery>		 
		 
			 </cfif>
			 						
		</cfif>		
	
</cfif>
