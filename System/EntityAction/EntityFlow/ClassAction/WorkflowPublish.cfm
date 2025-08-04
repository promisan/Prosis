<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- 1. entry in EntityClass Publish --->
<!--- 2. populate EntityActionPublish --->

<cftransaction>

	<cfquery name="Last" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT top 1 ActionPublishNo
		FROM  Ref_EntityClassPublish
		ORDER BY ActionPublishNo DESC
	</cfquery>
	
	<cfif Last.Recordcount eq "0">
		 <cfset pub = 1>
	<cfelse> 
		 <cfset pub = Last.ActionPublishNo+1>
	</cfif> 
	
	<cfquery name="InsertNo" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityClassPublish
	(ActionPublishNo, EntityCode, EntityClass, DateEffective, OfficerUserId, OfficerLastName, OfficerFirstName)
	VALUES (#pub#, 
	        '#URL.EntityCode#', 
			'#URL.EntityClass#', 
			getDate(),
		    '#SESSION.acc#', 
			'#SESSION.last#', 
			'#SESSION.first#')
	</cfquery>
	
	<!--- create action steps --->
	
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityActionPublish
		(ActionPublishNo, 
		ActionCode, 
		ActionParent, 
		ActionDescription,
		ActionProcess,
		ActionDateInput,
		ActionCompleted,
		ActionCompletedColor,
		ActionDenied,
		LabelQuestionaire,
		LabelDocument,
		ActionReference,
		ActionType,
		ActionTrigger,
		ActionOrder,
		ActionGoTo,
		ActionGoToYes,
		ActionGoToYESLabel,
		ActionGoToNo,
		ActionGoToNoLabel,
		EmbeddedClass,
		ShowAsBranch,
		ActionDialog,
		ActionDialogParameter,
		ActionSpecification,
		ActionReferenceShow,
		ActionReferenceEntry,
		DisableStandardDialog,
		ActionLeadTime,
		ActionTakeAction,
		ActionViewMemo,
		ActionViewMemoCopy,
		ActionAccess,
		ActionAccessPointer,
		ActionAccessUserGroup,
		ActionAccessUGCollaborate,
		DisableOwner,
		PersonAccess,
		PersonMailAction,
		PersonMailActionAttach,
		PersonMailActionAttachPrior,
		PersonMailObjectAttach,
		PersonMailCode,
		EnableQuickProcess,
		EnableMyClearances,
		EnableHTMLEdit,
		EnableNotification,
		NotificationAttachment,
		NotificationGlobal,
		NotificationFly,
		NotificationDueOnJump,
		NotificationManual,		
		EnableAttachment,
		EnableTextArea,		
		ActionURLDetails,
		DueMailCode,
		DueEntityStatus,
		ConditionValue,
		ConditionField,    
		ConditionMessage,		
		ConditionScript,		
		OfficerUserId,
		OfficerLastName,
		OfficerFirstName)
	SELECT 
		#pub#,
		ActionCode, 
		ActionParent, 
		ActionDescription,
		ActionProcess,
		ActionDateInput,
		ActionCompleted,
		ActionCompletedColor,
		ActionDenied,
		LabelQuestionaire,
		LabelDocument,
		ActionReference,
		ActionType,
		ActionTrigger,
		ActionOrder,
		ActionGoTo,
		ActionGoToYes,
		ActionGoToYESLabel,
		ActionGoToNo,
		ActionGoToNoLabel,
		EmbeddedClass,
		ShowAsBranch,
		ActionDialog,
		ActionDialogParameter,
		ActionSpecification,
		ActionReferenceShow,
		ActionReferenceEntry,
		DisableStandardDialog,
		ActionLeadTime,
		ActionTakeAction,
		ActionViewMemo,
		ActionViewMemoCopy,
		ActionAccess,
		ActionAccessPointer,
		ActionAccessUserGroup,
		ActionAccessUGCollaborate,
		DisableOwner,
		PersonAccess,
		PersonMailAction,
		PersonMailActionAttach,
		PersonMailActionAttachPrior,
		PersonMailObjectAttach,
		PersonMailCode,
		EnableQuickProcess,
		EnableMyClearances,
		EnableHTMLEdit,
		EnableNotification,
		NotificationAttachment,
		NotificationGlobal,
		NotificationFly,
		NotificationDueOnJump,
		NotificationManual,		
		EnableAttachment,
		EnableTextArea,
		ActionURLDetails,
		DueMailCode,
		DueEntityStatus,		
		ConditionValue,
		ConditionField,    
		ConditionMessage,		
		ConditionScript,
		'#SESSION.acc#',
		'#SESSION.last#', 
		'#SESSION.first#'
	FROM  Ref_EntityClassAction
	WHERE EntityCode  = '#URL.EntityCode#'
	AND   EntityClass = '#URL.EntityClass#'
	AND   ActionOrder > '0'
	</cfquery>
		
	<!--- create action document (fields, mail, dialog, function etc.) for elements
	 defined on the STEP/Workflow itself --->
	 	
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_EntityActionPublishDocument
		           (ActionPublishNo, ActionCode, DocumentId,DocumentLanguageCode,ObjectFilter,ForceDocument,UsageParameter,ListingOrder)
		SELECT      DISTINCT #pub#, ActionCode, DocumentId,DocumentLanguageCode,ObjectFilter,ForceDocument,UsageParameter,ListingOrder
		FROM        Ref_EntityClassActionDocument
		WHERE       EntityCode  = '#URL.EntityCode#'
		AND         EntityClass = '#URL.EntityClass#'
		AND         Operational = 1
		AND         ActionCode IN (SELECT ActionCode 
		                           FROM   Ref_EntityActionPublish
								   WHERE  ActionPublishNo = '#pub#')	                            
		AND         DocumentId NOT IN (SELECT DocumentId 
		                           FROM   Ref_EntityActionPublishDocument
								   WHERE  ActionPublishNo = '#pub#')
	</cfquery>
	
	<!--- create action document (fields, mail, dialog, function etc.) for elements 
	defined on the STEP itself --->
	
	<cfquery name="getRecords" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityActionPublishDocument
		WHERE ActionPublishNo = '#pub#'
	</cfquery>	
	
	<cfif getRecords.recordcount eq "0">
	
	    <!--- if we have already record we are not going to add more --->
	
		<cfquery name="Insert" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_EntityActionPublishDocument
		           (ActionPublishNo, ActionCode, DocumentId)
		SELECT      #pub#, ActionCode, DocumentId
		FROM        Ref_EntityActionDocument
		WHERE       ActionCode IN (SELECT ActionCode 
		                           FROM  Ref_EntityActionPublish
								   WHERE  ActionPublishNo = '#pub#')	                            
		AND         DocumentId IN (SELECT DocumentId 
		                           FROM   Ref_EntityDocument
								   WHERE  EntityCode = '#URL.EntityCode#')
								   
		AND         DocumentId NOT IN (SELECT DocumentId 
			                           FROM   Ref_EntityActionPublishDocument
									   WHERE  ActionPublishNo = '#pub#')						   
		</cfquery>
		
	</cfif>
	
	<!--- Labels --->
	
	<cfquery name="Labels" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_EntityActionPublish_Language
					(ActionPublishNo,ActionCode,LanguageCode,ActionCompleted,ActionDescription,ActionGoToLabel,ActionReference,OfficerUserId)
		SELECT 		'#pub#', ActionCode, LanguageCode, ActionCompleted, ActionDescription, ActionGoToLabel, ActionReference, OfficerUserId
		FROM 		Ref_EntityClassAction_Language
		WHERE       EntityCode  = '#URL.EntityCode#'
		AND         EntityClass = '#URL.EntityClass#'
	</cfquery>
	
	<!--- methods --->
	
	<cfquery name="InsertMethod" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityActionPublishScript
			(ActionPublishNo, 
				ActionCode, 
				Method,
				MethodDataSource, 
				MethodEnabled,
				ActorAuthenticate,
				ActorSignature,
				MethodScript,
				DocumentId,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName)
	SELECT      #pub#,
	            ActionCode, 
				Method, 
				MethodDataSource, 
				MethodEnabled,
				ActorAuthenticate,
				ActorSignature,
				MethodScript,
				DocumentId,
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
	FROM        Ref_EntityClassActionScript
	WHERE       EntityCode  = '#URL.EntityCode#'
	AND         EntityClass = '#URL.EntityClass#'
	AND         ActionCode IN (SELECT ActionCode 
	                           FROM   Ref_EntityActionPublish
							   WHERE  ActionPublishNo = '#pub#')	  
	
	</cfquery>
			
	<cfquery name="InsertWFProcess" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityActionPublishProcess
				(ActionPublishNo, 
				 ActionCode, 
				 ProcessClass, 
				 ProcessActionCode,
				 ConditionField,
				 ConditionValue,
				 ConditionScript,
				 ConditionMessage,
				 ConditionShow,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	SELECT      #pub#,
	            ActionCode, 
				ProcessClass, 
				ProcessActionCode,
				ConditionField,
				ConditionValue,
				ConditionScript,
				ConditionMessage,
				ConditionShow,
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
	FROM        Ref_EntityClassActionProcess
	WHERE       EntityCode  = '#URL.EntityCode#'
	AND         EntityClass = '#URL.EntityClass#'
	AND         ActionCode IN (SELECT ActionCode 
	                           FROM  Ref_EntityActionPublish
							   WHERE  ActionPublishNo = '#pub#')	  
	</cfquery>

</cftransaction>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>
	<script language="JavaScript">
		alert("The Workflow configuration was successfully published.")
		window.location = "FlowView.cfm?PublishNo=#pub#&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&mid=#mid#"
	</script>
</cfoutput>