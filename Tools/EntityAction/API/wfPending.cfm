
<!--- Object pending workflow by action

<cf_wfPending EntityCode="aaaa" Table="#answer1#">

0   requires EntityCode to be passed 
1.  Define first pending step with status 0 or 1 (hold) for a document, 
2.	Passes the actioncode and parentcode for the last action 
3.  Result will be answer
--->	

<cfparam name="Attributes.EntityCode"            default="">
<cfparam name="Attributes.EntityCodeIgnoreLast"  default="0">
<cfparam name="Attributes.EntityCode2"           default="">
<cfparam name="Attributes.EntityCode2IgnoreLast" default="0">
<cfparam name="Attributes.Mission"          	 default="">
<cfparam name="Attributes.IncludeCompleted" 	 default="Yes">
<cfparam name="Attributes.MailFields"       	 default="Yes">
<cfparam name="Attributes.Mode"             	 default="Table">
<cfparam name="Attributes.Table"            	 default="tmp">
<cfparam name="Attributes.ActionTable"      	 default="Organization.dbo.OrganizationObjectAction">

<!--- ------------------ NEW feature to speed up the listing ------ --->
<!--- first we check if something has changed recently otherwise
we do not reprocess the workflow status table --------------------- --->
<!--- ------------------------------------------------------------- --->

<cftry>

	<!--- table exists --->

	<cfquery name="dataset"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT TOP 1 TimeStamp
	FROM   #Attributes.Table#
	</cfquery>
	
	<cftransaction isolation="READ_UNCOMMITTED">
	
		<cfquery name="source"
		datasource="AppsOrganization"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT TOP 1 OfficerDate
		FROM   OrganizationObjectAction OA
		WHERE  ObjectId IN (SELECT ObjectId 
		                    FROM   OrganizationObject
						    WHERE  Objectid = OA.Objectid
						    <cfif attributes.Mission neq "">
						    AND    Mission = '#attributes.mission#'
						    </cfif>
						    AND    EntityCode = '#attributes.entitycode#'
						  ) 
		ORDER BY OfficerDate DESC
		</cfquery>
	
	</cftransaction>
	
	<cfif dataset.timestamp lt source.officerdate>	
		<cfset refreshset = "1">
	<cfelse>		
		<cfset refreshset = "0">		
	</cfif>

	<cfcatch>	
		<cfset refreshset = "1">	
	</cfcatch>

</cftry>

<cfif refreshset eq "1" or attributes.mode neq "Table">
	
	<cfset FileNo = round(Rand()*20)>
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf1#fileNo#">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf2#fileNo#">
	<cf_droptable dbname="AppsQuery" tblname="#Attributes.Table#">
	
	   <cfoutput>
	   
	   <cfsavecontent variable="DerivedTable">
			
		SELECT   O.ObjectId, 
		         O.EntityCode, 
				 O.ObjectKeyValue1, 
				 O.ObjectKeyValue2, 
				 O.ObjectKeyValue3, 
				 O.ObjectKeyValue4, 
				 O.ActionPublishNo,
				 MIN(A.ActionFlowOrder) AS ActionFlowOrder,	 <!--- take the lowest open action for reference --->      
				 R1.EntityClass as EntityClassCode,
		         R1.EntityClassName
		
		FROM     Organization.dbo.OrganizationObject O 
				 INNER JOIN #Attributes.ActionTable# A ON O.ObjectId = A.ObjectId 
				 INNER JOIN Organization.dbo.Ref_EntityClassPublish R ON O.ActionPublishNo = R.ActionPublishNo 
				 INNER JOIN Organization.dbo.Ref_EntityClass R1 ON R.EntityCode = R1.EntityCode AND R.EntityClass = R1.EntityClass
		WHERE    O.EntityCode IN ('#Attributes.EntityCode#','#Attributes.EntityCode2#') 
		AND      A.ActionStatus IN ('0','1')
		<cfif attributes.Mission neq "">
	    AND      O.Mission = '#attributes.mission#'
	    </cfif>
		
		<cfif attributes.EntityCodeIgnoreLast eq "1">
		<!--- option to excluded objects that are in the last step of the workflow --->
		AND      A.ActionCode NOT IN (SELECT TOP (1) ActionCode
										FROM   Organization.dbo.Ref_EntityActionPublish
										WHERE  ActionPublishNo = O.ActionPublishNo
										ORDER BY ActionOrder DESC )
		</cfif>								
		
		
		AND      O.Operational  = 1
		GROUP BY O.ObjectId, 
		         O.EntityCode, 
				 O.ObjectKeyValue1, 
				 O.ObjectKeyValue2, 
				 O.ObjectKeyValue3, 
				 O.ObjectKeyValue4, 
				 O.ActionPublishNo,			
				 R1.EntityClass,
				 R1.EntityClassName
				 
		<cfif Attributes.EntityCode2 neq "">
		
			UNION
			
			SELECT   O.ObjectId, 
			         O.EntityCode, 
					 O.ObjectKeyValue1, 
					 O.ObjectKeyValue2, 
					 O.ObjectKeyValue3, 
					 O.ObjectKeyValue4, 
					 O.ActionPublishNo,
					 MIN(A.ActionFlowOrder) AS ActionFlowOrder,	 <!--- take the lowest open action --->      
					 R1.EntityClass as EntityClassCode,
			         R1.EntityClassName
			
			FROM     Organization.dbo.OrganizationObject O 
					 INNER JOIN #Attributes.ActionTable# A ON O.ObjectId = A.ObjectId 
					 INNER JOIN Organization.dbo.Ref_EntityClassPublish R ON O.ActionPublishNo = R.ActionPublishNo 
					 INNER JOIN Organization.dbo.Ref_EntityClass R1 ON R.EntityCode = R1.EntityCode AND R.EntityClass = R1.EntityClass
			WHERE    O.EntityCode IN ('#Attributes.EntityCode2#') 
			AND      A.ActionStatus IN ('0','1')
			<cfif attributes.Mission neq "">
		    AND      O.Mission = '#attributes.mission#'
		    </cfif>
			
			<cfif attributes.EntityCode2IgnoreLast eq "1">
			<!--- option to excluded objects that are in the last step of the workflow --->
			AND      A.ActionCode NOT IN (SELECT   TOP (1) ActionCode
										  FROM     Organization.dbo.Ref_EntityActionPublish
										  WHERE    ActionPublishNo = O.ActionPublishNo
										  ORDER BY ActionOrder DESC )
			</cfif>									
			
			AND      O.Operational  = 1
			GROUP BY O.ObjectId, 
			         O.EntityCode, 
					 O.ObjectKeyValue1, 
					 O.ObjectKeyValue2, 
					 O.ObjectKeyValue3, 
					 O.ObjectKeyValue4, 
					 O.ActionPublishNo,			
					 R1.EntityClass,
					 R1.EntityClassName
				
		</cfif>		 
				 				 				 
		<cfif attributes.includeCompleted eq "Yes">					
		 
			UNION 
			
			<!--- get the last action in case there are no pending actions found for an object --->
			
			SELECT  O.ObjectId, 
			        O.EntityCode, 
					O.ObjectKeyValue1, 
					O.ObjectKeyValue2, 
					O.ObjectKeyValue3, 
					O.ObjectKeyValue4, 
					O.ActionPublishNo,
					MAX(A.ActionFlowOrder) AS ActionFlowOrder,
					R1.EntityClass as EntityClassCode,
			        R1.EntityClassName
						
			FROM    OrganizationObject O INNER JOIN
			        #Attributes.ActionTable# A ON O.ObjectId = A.ObjectId INNER JOIN
			        Ref_EntityClassPublish R ON O.ActionPublishNo = R.ActionPublishNo INNER JOIN
			        Ref_EntityClass R1 ON R.EntityCode = R1.EntityCode AND R.EntityClass = R1.EntityClass
			WHERE   O.EntityCode IN ('#Attributes.EntityCode#','#Attributes.EntityCode2#') 
			AND     O.Objectid NOT IN (SELECT ObjectId 
			                           FROM   #Attributes.ActionTable# 
									   WHERE  ObjectId = O.ObjectId
									   AND    ActionStatus IN ('0','1'))
			AND     O.Operational  = 1
			<cfif attributes.Mission neq "">
	        AND      O.Mission = '#attributes.mission#'
	        </cfif>
			GROUP BY O.ObjectId, 
			         O.EntityCode, 
					 O.ObjectKeyValue1, 
					 O.ObjectKeyValue2, 
					 O.ObjectKeyValue3, 
					 O.ObjectKeyValue4, 
					 O.ActionPublishNo,
					 R1.EntityClass,
				     R1.EntityClassName
				 
		</cfif>		 
				 
		</cfsavecontent>
		
		</cfoutput>
						
		<cftransaction isolation="READ_UNCOMMITTED">
								
			<!--- the parent code for the action --->
			
			<cfif attributes.mode eq "Table">
		
				<cfquery name="step2"
				datasource="AppsOrganization"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT  T.*, 					
							O.ActionCode, 												
							(SELECT   ActionDescription
							 FROM     Organization.dbo.Ref_EntityActionPublish 
							 WHERE    ActionCode = O.ActionCode
							 AND      ActionPublishNo = O.ActionPublishNo) as ActionDescriptionDue,											 
							R.ParentCode,	
							O.ActionMemo,						
							getDate() as TimeStamp							
					<cfif attributes.mailfields eq "No">				
					INTO    userQuery.dbo.#Attributes.Table#
					<cfelse>	
					INTO    userQuery.dbo.#SESSION.acc#wf1#fileNo#
					</cfif>
					FROM    ( #preservesinglequotes(derivedtable)# ) T, 
					        #Attributes.ActionTable# O,
							Ref_EntityAction R
					WHERE   T.ObjectId        = O.ObjectId 
					AND     T.ActionFlowOrder = O.ActionFlowOrder 
					AND     O.ActionCode      = R.ActionCode
					AND     O.ActionPublishNo = T.ActionPublishNo
					
				</cfquery>	
			
			<cfelse>
			
				 <cfsavecontent variable="WorkflowSteps">
					 <cfoutput>							
						SELECT  T.*, 					
								O.ActionCode, 												
								(SELECT   ActionDescription
								 FROM     Organization.dbo.Ref_EntityActionPublish 
								 WHERE    ActionCode = O.ActionCode
								 AND      ActionPublishNo = O.ActionPublishNo) as ActionDescriptionDue,												 
								R.ParentCode,	
								O.ActionMemo,						
								getDate() as TimeStamp							
						
						FROM    ( #preservesinglequotes(derivedtable)# ) T, 
						        #Attributes.ActionTable# O,
								Organization.dbo.Ref_EntityAction R
						WHERE   T.ObjectId        = O.ObjectId 
						AND     T.ActionFlowOrder = O.ActionFlowOrder 
						AND     O.ActionCode      = R.ActionCode
						AND     O.ActionPublishNo = T.ActionPublishNo
					</cfoutput>							
				</cfsavecontent>	
								
				<CFSET Caller.WorkflowSteps = WorkFlowSteps>				
				
			
			</cfif>
			
		</cftransaction>	
		
	    <!---
		<cfoutput>#cfquery.executiontime#</cfoutput>
		--->				
		
		<!--- to make it faster --->
		
		<cfif attributes.mailfields eq "Yes">
		
			<cftransaction isolation="READ_UNCOMMITTED">
			
				<!--- slowing down --->
				<cfquery name="step3"
				datasource="AppsQuery"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT  T.*, 				        
					        O.OrgUnit, 
							O.ActionId, 
							O.OfficerDate, 
							O.TriggerActionType, 
							O.TriggerDate
					INTO    userQuery.dbo.#SESSION.acc#wf2#fileNo#
					FROM    userQuery.dbo.#SESSION.acc#wf1#fileNo# T, 
					        #Attributes.ActionTable# O
					WHERE   T.ObjectId        = O.ObjectId 
					AND     T.ActionFlowOrder = O.ActionFlowOrder 
					AND     T.ActionCode      = O.ActionCode		
					AND     T.ActionPublishNo = O.ActionPublishNo 
				</cfquery>	
				
				<cfquery name="stepFinal"
				datasource="AppsQuery"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				
				SELECT     T.*, 	          
						   AP.ActionOrder,
						   
						     (SELECT   TOP 1 OfficerDate 
							  FROM     #Attributes.ActionTable#
							  WHERE    ObjectId = T.ObjectId
							  AND      ActionStatus IN ('2','2Y','2N') 
							  ORDER BY OfficerDate DESC) AS ActionTakenPrior,
						   
						   AP.ActionLeadTime,
						   AP.EnableNotification,
						   AP.NotificationGlobal,
						   AP.NotificationFly,
						   AP.DueMailCode,
						   P.ListingOrder AS ParentOrder, 
					       P.Description AS ParentDescription
						   
				INTO       dbo.#Attributes.Table#
			    
				FROM       userQuery.dbo.#SESSION.acc#wf2#fileNo# T 	          
						   INNER JOIN Organization.dbo.Ref_EntityActionPublish AP ON T.ActionPublishNo = AP.ActionPublishNo AND T.ActionCode = AP.ActionCode
						   LEFT OUTER JOIN Organization.dbo.Ref_EntityActionParent P ON T.EntityCode = P.EntityCode AND T.ParentCode = P.Code			   			  
				</cfquery>	
			
			</cftransaction>
		
		</cfif>
		
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf1#fileNo#">	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf2#fileNo#">	
	
</cfif>
