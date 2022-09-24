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
					  ListingOrder, 
					  Operational)
			SELECT    '#URL.EntityCode#' ,
			          '#URL.TargetEntityClass#',
				      ActionCode, 
					  DocumentId, 
					  DocumentLanguageCode,
					  ObjectFilter,
					  ForceDocument,
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