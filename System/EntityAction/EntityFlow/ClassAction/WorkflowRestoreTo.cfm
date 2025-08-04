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
<cfparam name="url.EntityCode"  default="">
<cfparam name="url.TargetEntityClass" default="">
<cfparam name="url.PublishNo" default="">

<cfoutput>

<cfquery name="DeleteOld" 			<!--- draft version --->
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE 
	FROM    Ref_EntityClassAction
	WHERE   EntityCode  = '#URL.EntityCode#' 
	AND     EntityClass = '#URL.TargetEntityClass#'
	</cfquery>

<cftransaction>

	<cfquery name="InsertAction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_EntityClassAction
				(EntityCode, 
				EntityClass,
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
				ActionGoToLabel,
				ActionGoToYes,
				ActionGoToYESLabel,
				ActionGoToNo,
				ActionGoToNoLabel,
				ActionBranch,
				EmbeddedClass,
				ShowAsBranch,
				ActionDialog,
				ActionDialogParameter,
				ActionDialogOpen,
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
				NotificationFly,
				NotificationTarget,
				NotificationDueOnJump,
				NotificationGlobal,
				NotificationManual,	
				NotificationEmbed,	
				EnableAttachment,
				EnableTextArea,
				ActionURLDetails,
				DueMailCode,
				DueEntityStatus,		
				ConditionValue,
				ConditionField,    
				ConditionMessage,
				ConditionScript,
				OfficerUserID,
				OfficerLastName,
				OfficerFirstName)
		SELECT '#URL.EntityCode#' ,'#URL.TargetEntityClass#',
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
				ActionGoToLabel,
				ActionGoToYes,
				ActionGoToYESLabel,
				ActionGoToNo,
				ActionGoToNoLabel,
				ActionBranch,
				EmbeddedClass,
				ShowAsBranch,
				ActionDialog,
				ActionDialogParameter,
				ActionDialogOpen,
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
				NotificationFly,
				NotificationTarget,
				NotificationDueOnJump,
				NotificationGlobal,
				NotificationManual,	
				NotificationEmbed,	
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
		FROM    Ref_EntityActionPublish
		WHERE   ActionPublishNo = '#Url.PublishNo#'
		</cfquery>
		
	<cfquery name="InsertLanguage" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_EntityClassAction_Language	
		       (EntityCode, 
				EntityClass,
				ActionCode, 
				LanguageCode, 
				ActionCompleted, 
				ActionDescription, 
				ActionGoToLabel, 
				ActionReference, 
				ActionDenied, 
				ActionProcess, 
				OfficerUserId)
		SELECT	'#URL.EntityCode#' ,'#URL.TargetEntityClass#',
				ActionCode, 
				LanguageCode, 
				ActionCompleted, 
				ActionDescription, 
				ActionGoToLabel, 
				ActionReference, 
				ActionDenied, 
				ActionProcess, 
				'#SESSION.acc#'	
		FROM    Ref_EntityActionPublish_Language
		WHERE   ActionPublishNo = '#Url.PublishNo#'		
				
	</cfquery>	
		
		
	<cfquery name="InsertDocument" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO Ref_EntityClassActionDocument
				     (EntityCode, 
					  EntityClass,
				      ActionCode, 
					  DocumentId, 
					  DocumentLanguageCode,
					  ObjectFilter,
					  ForceDocument,
					  UsageParameter,
					  ListingOrder, 
					  Operational)
			SELECT    '#URL.EntityCode#' ,
			          '#URL.TargetEntityClass#',
				      ActionCode, 
					  DocumentId, 
					  DocumentLanguageCode,
					  ObjectFilter,
					  ForceDocument,
					  UsageParameter,
					  ListingOrder, 
					  Operational
			FROM      Ref_EntityActionPublishDocument	
			WHERE     ActionPublishNo = '#Url.PublishNo#'
			
		</cfquery>
		
	<cfquery name="InsertProcess" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		INSERT INTO Ref_EntityClassActionProcess
				 
				(EntityCode, 
				 EntityClass,
				 ActionCode, 
				 ProcessClass, 
				 ProcessActionCode,
				 ProcessDefault,
				 DocumentId,
				 ConditionShow,
				 ConditionMemo,
				 ConditionMemoSize,
				 ConditionField,
				 ConditionValue,
				 ConditionScript,
				 ConditionMessage,				 
				 ConditionDataSource,
				 MailCode,
				 Operational,
				 OfficerUserID,
				 OfficerLastName,
				 OfficerFirstName)
					
		SELECT    '#URL.EntityCode#',
			      '#URL.TargetEntityClass#',
				  ActionCode, 
				  ProcessClass, 
				  ProcessActionCode,
				  ProcessDefault,
				  DocumentId,
				  ConditionShow,
				  ConditionMemo,
				  ConditionMemoSize,
				  ConditionField,
				  ConditionValue,
				  ConditionScript,
				  ConditionMessage,				 
				  ConditionDataSource,
				  MailCode,
				  Operational,
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#' 
					
		FROM      Ref_EntityActionPublishProcess	
		WHERE     ActionPublishNo = '#Url.PublishNo#'
		
	</cfquery>
		
	<cfquery name="InsertDocument" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO Ref_EntityClassActionScript
				   (EntityCode, 
				    EntityClass,
		            ActionCode, 
					Method, 
					MethodDataSource, 
					MethodEnabled,
					ActorAuthenticate,
					ActorSignature,
					MethodScript,
					DocumentId,
					OfficerUserID,
					OfficerLastName,
					OfficerFirstName)
			SELECT  '#URL.EntityCode#', 
			        '#URL.TargetEntityClass#',
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
			FROM     Ref_EntityActionPublishScript
			WHERE    ActionPublishNo = '#Url.PublishNo#'
		
		</cfquery>
		
</cftransaction>

</cfoutput>		

<cfoutput>
	<script language="JavaScript">
		alert("The Workflow configuration was successfully copied.")
		ptoken.location('FlowView.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.TargetEntityClass#')
	</script>
</cfoutput>

</body>