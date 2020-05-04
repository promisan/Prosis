
<HTML><HEAD>
<TITLE>Saving</TITLE>
</HEAD><body leftmargin="0" topmargin="5" rightmargin="0" bottommargin="0">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<!--- url.save 
	1. save
	2. save and close
	3. verify
	5. text only
	9. delete 
--->


<cfparam name="Form.enableAttachment"          default="0">
<cfparam name="Form.enableTextArea"            default="0">
<cfparam name="Form.enableSendBack"            default="0">
<cfparam name="Form.enableHTMLEdit"            default="0">
<cfparam name="Form.EnableQuickProcess"        default="0">
<cfparam name="Form.DisableStandardDialog"     default="0">
<cfparam name="Form.enableNotification"        default="0">
<cfparam name="Form.GoToNext"                  default="">
<cfparam name="Form.ShowAsBranch"              default="0">
<cfparam name="Form.NotificationFly"           default="0">
<cfparam name="Form.NotificationOnDue"         default="0">
<cfparam name="Form.NotificationAttachment"    default="0">
<cfparam name="Form.NotificationGlobal"        default="0">
<cfparam name="Form.NotificationManual"        default="0">
<cfparam name="Form.EnableMyClearances"        default="0">
<cfparam name="Form.ActionReferenceShow"       default="0">
<cfparam name="Form.ActionReferenceEntry"      default="0">
<cfparam name="Form.PersonAccess"              default="0">
<cfparam name="Form.PersonMail"                default="0">
<cfparam name="Form.PersonMail2"               default="0">
<cfparam name="Form.PersonMailActionAttach"    default="0">
<cfparam name="Form.PersonMailObjectAttach"    default="0">
<cfparam name="Form.ActionAccess"              default="">
<cfparam name="Form.ActionAccessUserGroup"     default="">
<cfparam name="Form.ActionAccessUGCollaborate" default="">
<cfparam name="Form.EntityAccessPointer"       default="">
<cfparam name="Form.ActionTrigger"             default="">
<cfparam name="Form.ActionDateInput"           default="0">
<cfparam name="Form.ActionCompletedColorDefault" default="0">
<cfparam name="Form.ActionProcess"             default="Doit">
<cfparam name="Form.ActionDenied"              default="">
<cfparam name="Form.ActionViewMemoCopy"        default="0">
<cfparam name="Form.PersonMailCode"            default="">
<cfparam name="Form.PersonMailAction"          default="">
<cfparam name="Form.EmbeddedClass"             default="">
<cfparam name="Form.DisableOwner"              default="0">
<cfparam name="Form.ActionAccessPointer"       default="0">
<cfparam name="Form.ActionReference"           default="">

<!--- alert --->
<cfparam name="Form.ActionDialog"              default="">
<cfparam name="Form.ActionDialogParameter"     default="">
<cfparam name="url.save"                       default="0">


<cfquery name="qLanguage"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Code as LanguageCode
	FROM   Ref_SystemLanguage
	WHERE  (Operational = '2') AND (SystemDefault = '0')
</cfquery>
	
<cfif url.save eq "1" or url.save eq "2" or url.save eq "3">

	<cfif Form.ActionCodeOld eq "">
		       			
			<cfquery name="Register" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT Ref_EntityClassAction
				(ActionCode, EntityCode, EntityClass)
				VALUES ('#Form.ActionCode#',
				        '#URL.EntityCode#',
						'#URL.EntityClass#') 
			</cfquery>
			
	</cfif>		
			
	<cfquery name="GetDescription" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_EntityAction A, Ref_Entity R
		WHERE  ActionCode = '#Form.ActionCode#' 
		AND    A.EntityCode = R.EntityCode 
	</cfquery>
		
    <cfif URL.PublishNo eq "">
		<cfset list = "Ref_EntityClassAction,Ref_EntityClassAction_Language">
	<cfelse>
		<cfset list = "Ref_EntityActionPublish,Ref_EntityClassAction,Ref_EntityActionPublish_Language">
	</cfif>	
	
	<cfloop index="tbl" list="#list#" delimiters=",">

		<cfif Find("_Language",tbl) eq 0>
				
		    <!--- It is not a language table --->
			
			<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE #tbl#
				SET  
								 	 
				 <cfif tbl eq "Ref_EntityClassAction">
				
				      ActionParent             = '#Form.ActionParent#',
					 
					  <cfif Form.ActionType eq "Decision">
					     ActionDialog             = '#Form.ActionDialog#', 
						 ActionDialogParameter    = '#Form.ActionDialogParameter#',
						 ActionGoToYes            = '#Form.ActionGoToYes#',
						 ActionGoToNo             = '#Form.ActionGoToNo#',
						 ActionGoToYesLabel       = '#Form.ActionGoToYesLabel#',
						 ActionGoToNoLabel        = '#Form.ActionGoToNoLabel#',
						 ShowAsBranch             = '#Form.ShowAsBranch#',
						 
					 <cfelse>
					 
						 ActionGoToYes            = NULL,
						 ActionGoToNo             = NULL,
						 ActionGoToYesLabel       = NULL,
						 ActionGoToNoLabel        = NULL,
						 ActionDialog             = '#Form.ActionDialog#', 
						 ActionDialogParameter    = '#Form.ActionDialogParameter#',
						 DisableStandardDialog    = '#Form.DisableStandardDialog#',
						 EnableQuickProcess       = '#Form.EnableQuickProcess#', 
						 ShowAsBranch             = '0',
						 
					 </cfif>
					 
				 <cfelse>
				 
				 	<cfif Form.ActionType eq "Decision">
					
						 ActionDialog             = '#Form.ActionDialog#',
						 ActionDialogParameter    = '#Form.ActionDialogParameter#',
						 ActionGoToYesLabel       = '#Form.ActionGoToYesLabel#',
						 ActionGoToNoLabel        = '#Form.ActionGoToNoLabel#', 
						 EnableQuickProcess       = '#Form.EnableQuickProcess#', 
						 ShowAsBranch             = '#Form.ShowAsBranch#',
						 
					<cfelse>
					
						 ActionDialog             = '#Form.ActionDialog#', 
						 ActionDialogParameter    = '#Form.ActionDialogParameter#',
						 ActionGoToYesLabel       = '#Form.ActionGoToYesLabel#',
						 DisableStandardDialog    = '#Form.DisableStandardDialog#',
						 EnableQuickProcess       = '#Form.EnableQuickProcess#', 
						 ShowAsBranch             = '0',
						 
					</cfif>
				 
				 </cfif>
				 ActionTrigger             = '#Form.ActionTrigger#',
				 ActionReferenceShow       = '#Form.ActionReferenceShow#',
				 ActionReferenceEntry      = '#Form.ActionReferenceEntry#',
				 ActionAccess              = '#Form.ActionAccess#',
				 ActionAccessPointer       = '#Form.ActionAccessPointer#',
				 ActionAccessUserGroup     = '#Form.ActionAccessUserGroup#',
				 ActionAccessUGCollaborate = '#Form.ActionAccessUGCollaborate#',
				 EntityAccessPointer       = '#Form.EntityAccessPointer#',
				 DisableOwner              = '#Form.DisableOwner#',
				 PersonAccess              = '#Form.PersonAccess#',
				 <cfif Form.PersonMail eq "1">
				 	 PersonMailCode           = '#Form.PersonMailCode#',
				 <cfelse>
					 PersonMailCode           = '',
				 </cfif>
				 <cfif Form.PersonMail2 eq "1">
					 PersonMailAction         = '#Form.PersonMailAction#',
					 PersonMailActionAttach   = '#Form.PersonMailActionAttach#',
					 PersonMailObjectAttach   = '#Form.PersonMailObjectAttach#',
				 <cfelse>
					 PersonMailAction         = '',
					 PersonMailActionAttach   = '0',
					 PersonMailObjectAttach   = '0',
				 </cfif>
				 
				 ActionViewMemo           = '#Form.ActionViewMemo#',
				 ActionViewMemoCopy       = '#Form.ActionViewMemoCopy#',
				 <cfif url.PublishNo eq "">
				 ActionDescription        = '#Form.ActionDescription#',
				 <!--- ActionDescription        = '#GetDescription.ActionDescription#', --->
				 <cfelse>
				 ActionDescription        = '#Form.ActionDescription#',
				 </cfif>				 
				 ActionCompleted          = '#Form.ActionCompleted#',
				 ActionDenied             = '#Form.ActionDenied#',
				 ActionProcess            = '#Form.ActionProcess#',
				 <cfif Form.ActionCompletedColorDefault eq "1">
				 		ActionCompletedColor     = 'default',
				 <cfelse>
					 	ActionCompletedColor     = '#Form.ActionCompletedColor#',
				 </cfif>
				 ActionReference          = '#Form.ActionReference#', 
				 ActionDateInput          = '#Form.ActionDateInput#',
				 ActionLeadtime           = '#ListFirst(Form.ActionLeadTime)#',
				 ActionTakeAction         = '#ListFirst(Form.ActionTakeAction)#',
				 ActionURLDetails         = '#Form.ActionURLDetails#',
				 EnableHTMLEdit           = '#Form.EnableHTMLEdit#',
				 EmbeddedClass            = '#Form.EmbeddedClass#',				 
				 EnableNotification       = '#Form.EnableNotification#',
				 NotificationAttachment   = '#Form.NotificationAttachment#',
				 NotificationGlobal       = '#Form.NotificationGlobal#',
				 NotificationFly          = '#Form.NotificationFly#',
				 NotificationDueOnJump    = '#Form.NotificationOnDue#',
				 NotificationManual       = '#Form.NotificationManual#',
				 EnableMyClearances       = '#Form.EnableMyClearances#',
				 EnableAttachment         = '#Form.EnableAttachment#',
				 EnableTextArea           = '#Form.EnableTextArea#',
				 DueMailCode              = '#Form.DueMailCode#',
				 <!--- removed 
				 DueScript                = '#Form.DueScript#', 
				 --->
				 DueEntityStatus          = '#Form.DueEntityStatus#',
				
				 <!--- removedd
				 <cfif Form.ActionType eq "Decision">								 
				 ResetEnable              = '#Form.DenyEnable#',
				 ResetScript              = '#Form.DenyScript#',
				 </cfif>		
				 --->	 
				 
				 ConditionField           = '#Form.ConditionField#',
				 ConditionValue           = '#Form.ConditionValue#',
				 ConditionScript          = '#Form.ConditionScript#',
				 ConditionMessage         = '#Form.ConditionMessage#',
				 
				 <!---
				 SubmissionScript         = '#Form.SubmissionScript#',
				 SubmissionEnable         = '#Form.SubmissionEnable#',
				 --->
				 				 
				 OfficerUserId            = '#SESSION.acc#',
				 OfficerLastName          = '#SESSION.last#',
				 OfficerFirstName         = '#SESSION.first#',
				 Created                  = getDate()
				 WHERE ActionCode = '#Form.ActionCode#'
				 <cfif tbl eq "Ref_EntityActionPublish">
			       	AND ActionPublishNo = '#URL.PublishNo#' 
				 <cfelse>
				   	AND EntityCode  = '#URL.EntityCode#' 
				   	AND EntityClass = '#URL.EntityClass#'  
				 </cfif>
			 </cfquery>		
			 			
			 			 
			<!--- ----------------------------------- --->
			<!--- Saving default scripts in the table --->
			<!--- ----------------------------------- --->
			
			<cfquery name="ResetMethod" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM #tbl#Script
			 WHERE ActionCode = '#Form.ActionCode#' 
				 <cfif tbl eq "Ref_EntityActionPublish">
			       AND ActionPublishNo = '#URL.PublishNo#'
				 <cfelse>
				   AND EntityCode  = '#URL.EntityCode#' 
				   AND EntityClass = '#URL.EntityClass#'  
				 </cfif>
		    </cfquery>
			
			<cfloop index="itm" list="Due,Submission,Deny,Condition,Embed" delimiters=",">
			
			     <cfparam name="Form.Method#Itm#" default="">
			     <cfset scriptfile  = evaluate("Form.Method#itm#")>
				 
				 <cfparam name="Form.Method#Itm#DataSource" default="">
			     <cfset datasource  = evaluate("Form.Method#Itm#Datasource")>
				 
				 <cfparam name="Form.#Itm#Script" default="">
			     <cfset scripttext  = evaluate("Form.#Itm#Script")>
				 				 
				 <cfif len(scripttext) gt 4000>
					 <cfset scripttext = left(scripttext,4000)>
				 </cfif>
				 				 
				 <cfparam name="Form.#Itm#ActorAuthenticate" default="0">
			     <cfset authenticate  = evaluate("Form.#Itm#ActorAuthenticate")>	
				 
				 <cfparam name="Form.#Itm#Enable" default="1">
			     <cfset enable      = evaluate("Form.#Itm#Enable")>				 															 
				 
				 	<cfif scriptfile eq "">
					   <cfset scriptfile = "NULL">
					<cfelse>
					   <cfset scriptfile = "'#Scriptfile#'">
					</cfif>
					
					<cfif tbl eq "Ref_EntityActionPublish">
					
						 <cfquery name="Insert" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
							INSERT INTO #tbl#Script
							(ActionPublishNo, 
							 ActionCode,
							 ActorAuthenticate,
							 Method,
							 MethodDataSource,
							 DocumentId,
							 MethodScript,
							 MethodEnabled)
							VALUES 
							('#URL.PublishNo#',
							'#Form.ActionCode#',
							'#authenticate#',
							'#itm#',
							'#datasource#',
							#preservesingleQuotes(scriptfile)#, 
							'#scripttext#',
							'#enable#')
						</cfquery>
						
					<cfelse>
					
					  <!--- check if draft still exists --->
					  
					    <cfquery name="Check" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT * FROM #tbl#
							WHERE ActionCode  = '#Form.ActionCode#' 
						    AND   EntityCode  = '#URL.EntityCode#' 
	     				    AND   EntityClass = '#URL.EntityClass#'  
						</cfquery>
						
						<cfif Check.recordcount eq "1">
					  				 
						    <cfquery name="Insert" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
								INSERT INTO #tbl#Script
								(EntityCode, 
								 EntityClass,
								 ActionCode,
								 ActorAuthenticate,
								 Method,
								 MethodDataSource,
								 DocumentId,
								 MethodScript,
								 MethodEnabled)
								VALUES 
								('#URL.EntityCode#',
								 '#URL.EntityClass#',
								 '#Form.ActionCode#',
								 '#authenticate#',
								 '#Itm#',
								 '#datasource#',
								 #preservesingleQuotes(scriptfile)#,
								 '#scripttext#',
								 '#enable#')
							</cfquery>		
						
						</cfif>	  
					  
					</cfif>				  
							  			
			</cfloop> 	
			
			<cfelse>
			
					<!---- added by Armin on 4/10/2012 --->
			
					 <cfquery name="CLng" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   #tbl#
					 	<cfif tbl eq "Ref_EntityClassAction_Language">
						WHERE  EntityCode    = '#URL.EntityCode#'
					    AND    EntityClass   = '#URL.EntityClass#'   
					    <cfelse>
						WHERE  ActionPublishNo = '#URL.PublishNo#' 
						</cfif> 
						AND   ActionCode = '#Form.ActionCode#' 							   
					 </cfquery>				
			
					 <cfif CLng.recordcount neq 0>
					 	  
						  <cfloop query="qLanguage">
						  
								<cfparam name   = "Form.#LanguageCode#_ActionDescription" default="">						  
								<cfparam name   = "Form.#LanguageCode#_ActionCompleted"   default="">		
								<cfparam name   = "Form.#LanguageCode#_ActionDenied"      default="">				  
								<cfparam name   = "Form.#LanguageCode#_ActionProcess"     default="">
								<cfparam name   = "Form.#LanguageCode#_ActionGoToLabel"   default="">						  
								<cfparam name   = "Form.#LanguageCode#_ActionReference"   default="">									
								
								<cfset vDescription = evaluate("Form.#LanguageCode#_ActionDescription")>
								<cfset vCompleted   = evaluate("Form.#LanguageCode#_ActionCompleted")>
								<cfset vDenied      = evaluate("Form.#LanguageCode#_ActionDenied")>
								<cfset vProcess     = evaluate("Form.#LanguageCode#_ActionProcess")>
								<cfset vGoTo        = evaluate("Form.#LanguageCode#_ActionGoToLabel")>
								<cfset vReference   = evaluate("Form.#LanguageCode#_ActionReference")>								
									
							    <cfquery name="ULng" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE #tbl#
								 	SET    ActionDescription = '#vDescription#',
										   ActionProcess     = '#vProcess#',
									 	   ActionCompleted   = '#vCompleted#',
										   ActionDenied      = '#vDenied#',										   
										   ActionGoToLabel   = '#vGoto#',
										   ActionReference   = '#vReference#'										  
								 	<cfif tbl eq "Ref_EntityClassAction_Language">
									WHERE  EntityCode        = '#URL.EntityCode#'
								    AND    EntityClass  = '#URL.EntityClass#'   
								   <cfelse>
									WHERE  ActionPublishNo = '#URL.PublishNo#' 
								   </cfif> 
								 	AND    ActionCode = '#Form.ActionCode#' 		
									AND    LanguageCode = '#LanguageCode#'
								 </cfquery>			
								 	
						 </cfloop>
						 
					<cfelse>
					
						  <cfloop query="qLanguage">
						  
								<cfparam name   = "Form.#LanguageCode#_ActionDescription" default="">						  
								<cfparam name   = "Form.#LanguageCode#_ActionCompleted"   default="">		
								<cfparam name   = "Form.#LanguageCode#_ActionDenied"      default="">				  
								<cfparam name   = "Form.#LanguageCode#_ActionProcess"     default="">				  
								<cfparam name   = "Form.#LanguageCode#_ActionGoToLabel"   default="">						  
								<cfparam name   = "Form.#LanguageCode#_ActionReference"   default="">									
								
								<cfset vDescription = evaluate("Form.#LanguageCode#_ActionDescription")>
								<cfset vCompleted   = evaluate("Form.#LanguageCode#_ActionCompleted")>
								<cfset vDenied      = evaluate("Form.#LanguageCode#_ActionDenied")>
								<cfset vProcess     = evaluate("Form.#LanguageCode#_ActionProcess")>
								<cfset vGoTo        = evaluate("Form.#LanguageCode#_ActionGoToLabel")>
								<cfset vReference   = evaluate("Form.#LanguageCode#_ActionReference")>	
								
								<!--- check if the parent exisits --->						
								
							    <cfquery name="ILng" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									INSERT INTO #tbl# (
										<cfif tbl eq "Ref_EntityClassAction_Language">
										EntityCode,
										EntityClass,
										<cfelse>
										ActionPublishNo,
										</cfif>
								        ActionCode,
								        LanguageCode,
										ActionDescription,
										ActionProcess,
									    ActionCompleted,
										ActionDenied,								        
								        ActionGoToLabel,
							            ActionReference,
								        OfficerUserId )
									VALUES (
									  <cfif tbl eq "Ref_EntityClassAction_Language">
									   '#URL.EntityCode#',
									   '#URL.EntityClass#',
									  <cfelse>
									   '#URL.PublishNo#',
									  </cfif>
									  '#Form.ActionCode#', 
									  '#LanguageCode#',
							 	      '#vDescription#',
								 	  '#vCompleted#',
									  '#vDenied#',
									  '#vProcess#',
									  '#vGoto#',
									  '#vReference#',
									  '#SESSION.acc#'										  
									)
								 </cfquery>				
						 </cfloop>					
					 
					 </cfif>			
			
			</cfif>								
	 </cfloop>
	 
	 <cfif URL.PublishNo eq "">
		  <cfset tbl = "Ref_EntityClassAction">
	 <cfelse>
		  <cfset tbl = "Ref_EntityActionPublish">
	 </cfif>
	 
	 <cfif tbl eq "Ref_EntityClassAction">
	 
	     <!--- verify all decision objects --->
		 
		 <cfquery name="Reset" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_EntityClassAction
		 	 SET  ActionParent = '9999'
		 	WHERE ActionParent = '' or ActionParent is NULL
			 AND  EntityCode  = '#Form.EntityCode#' 
		     AND  EntityClass = '#Form.EntityClass#' 
		 </cfquery>
		 
		 <cfquery name="ResetAgain" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_EntityClassAction
		 	 SET ActionParent = NULL,
			     OfficerUserId            = '#SESSION.acc#',
			     OfficerLastName          = '#SESSION.last#',
			     OfficerFirstName         = '#SESSION.first#',
			     Created                  = getDate()
			 WHERE ActionCode IN (SELECT ActionGoToYes
			                     FROM Ref_EntityClassAction
								 WHERE EntityCode  = '#Form.EntityCode#' 
                      		       AND EntityClass = '#Form.EntityClass#' 
								 UNION
								 SELECT ActionGoToNo
			                     FROM Ref_EntityClassAction
								 WHERE EntityCode  = '#Form.EntityCode#' 
								   AND EntityClass = '#Form.EntityClass#')
			 AND ActionParent NOT IN (SELECT ActionCode 
			                          FROM Ref_EntityClassAction 
									  WHERE	ActionOrder > '0'
									  AND EntityCode  = '#Form.EntityCode#' 
									  AND EntityClass = '#Form.EntityClass#')		
			 AND ActionParent != 'INIT'		
			 AND EntityCode  = '#Form.EntityCode#' 
		     AND EntityClass = '#Form.EntityClass#' 
			 <!--- AND    ActionType != 'Decision' --->				  		 
		 </cfquery>
		
		 <cfif Form.ActionType eq "Decision">
			 	 
			 <cfquery name="Update" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_EntityClassAction
			  SET    ActionParent = NULL
			  WHERE  ActionCode IN ('#Form.ActionGoToYes#','#Form.ActionGoToNo#') 
			  AND    ActionParent NOT IN (SELECT ActionCode 
			                           FROM Ref_EntityClassAction 
								       WHERE ActionOrder > '0') 
			  AND    ActionParent != 'INIT'
			  AND    ActionType != 'Decision' 
			  AND    EntityCode  = '#Form.EntityCode#' 
			  AND    EntityClass = '#Form.EntityClass#' 
			 </cfquery>
		 
		 </cfif>
		
	 </cfif>
	 <font color="00A600"><b>Applied</font>
		 				
</cfif>

<cfif url.save eq "9">

		<cfquery name="Prior" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_EntityClassAction
			WHERE 	ActionCode  = '#url.ActionCode#'
			  AND 	EntityCode  = '#url.EntityCode#' 
		      AND 	EntityClass = '#url.EntityClass#' 
		</cfquery>
	
		<cfif Prior.ActionParent neq "#Form.ActionParent#">
	
		<!--- try to keep the link --->
		
			<cfif Prior.ActionOrder neq "" and Prior.ActionParent neq "">
			
				<cfquery name="Update" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE	Ref_EntityClassAction
					SET 	ActionParent = '#Prior.ActionParent#'
					WHERE 	ActionOrder = '#Prior.ActionOrder+1#' 
					 AND 	EntityCode  = '#url.EntityCode#' 
		    	     AND 	EntityClass = '#url.EntityClass#' 
				</cfquery>
			
			</cfif>
			
	    </cfif>
		
		<cfquery name="Delete" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_EntityClassAction 
		WHERE ActionCode   = '#url.ActionCode#'
		  AND EntityCode  = '#url.EntityCode#' 
		  AND EntityClass = '#url.EntityClass#' 
		</cfquery>

</cfif>	

<cfoutput>

<cfif url.save eq "3">
   	
	 <table width="96%"
       border="0"
       cellspacing="0"
       cellpadding="0"
       align="center"
	   class="formpadding"
       bordercolor="C0C0C0"
       bgcolor="FFFFFF">
	 
	 <cfparam name="Form.ActionStatus" default="0">
	 
	 <cfset keyname1 = "#GetDescription.EntityKeyField1#">
	 <cfset keyname2 = "#GetDescription.EntityKeyField2#">
	 <cfset keyname3 = "#GetDescription.EntityKeyField3#">
	 <cfset keyname4 = "#GetDescription.EntityKeyField4#">
			 
	  <cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM #tbl#Script
			WHERE ActionCode = '#Form.ActionCode#' 
		    <cfif tbl eq "Ref_EntityActionPublish">
			    AND ActionPublishNo = '#URL.PublishNo#' 
			<cfelse>
			    AND EntityCode  = '#url.EntityCode#' 
				AND EntityClass = '#url.EntityClass#' 	
			</cfif>		
	</cfquery>
	 	 	 
	 <cfset key1   = "0">
	 <cfset key2   = "0">
	 <cfset key3   = "0">
	 <cfset key4   = "{00000000-0000-0000-0000-000000000000}">
	 <cfset action = "{00000000-0000-0000-0000-000000000000}">
	 <cfset object = "{00000000-0000-0000-0000-000000000000}">
	 
	 <cfset s = 0>
	 
	 <cfloop query="Get">
	 
		 	 <cfif len(Get.Methodscript) gte 10>
		 	 
			 <cfset val = Get.MethodScript>
			 
			 <cfset val = replaceNoCase("#val#", "@key1",   "#key1#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@key2",   "#key2#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@key3",   "#key3#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@key4",   "#key4#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@object", "#object#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@action", "#action#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@acc",    "#SESSION.acc#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@last",   "#SESSION.last#" , "ALL")>
			 <cfset val = replaceNoCase("#val#", "@first",  "#SESSION.first#" , "ALL")>
										 
			 <!--- runtime conversion of custom object fields --->
					
				<cfquery name="Fields" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">	 
				     SELECT     R.EntityCode, R.DocumentCode, R.DocumentDescription, R.FieldType, I.DocumentItem, I.DocumentItemValue, R.DocumentId
				        FROM    Ref_EntityDocument AS R LEFT OUTER JOIN
				                OrganizationObjectInformation AS I ON R.DocumentId = I.DocumentId AND I.Objectid = '#Object#'
				        WHERE   R.EntityCode = '#url.EntityCode#' 
					 AND        R.DocumentType = 'field'
				</cfquery>	       
				
				<cfloop query="fields">
				
				    <cfif fieldtype eq "date">
					
						<cfset val = replaceNoCase("#val#", "@#documentcode#","01/01/1900", "ALL")>
					    	
					<cfelse>
					
					   	<cfset val = replaceNoCase("#val#", "@#documentcode#","customvalue", "ALL")>
					
					</cfif>
					    		
				</cfloop>			 
			  
				 <cfif val neq "">
				 
				 	<cfset s = 1>
				 	
					   <tr><td height="5"></td></tr>					 
				       <tr><td height="22"><font face="Verdana" size="3"><b>#Method#</font></td></tr> 
					   <tr><td>#ParagraphFormat(val)#</td></tr>
					  
					   <cftry>
					  					  					 									 				
						<cfquery name="SQL" 
						 datasource="#Get.MethodDatasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">	  	
						    <cfoutput>
							#preserveSingleQuotes(val)# 
							</cfoutput>
						 </cfquery>				 
							 <tr><td bgcolor="EAFAAB" align="center">Good, your #Method# syntax is correct!</b></td></tr>
									 
						 <cfcatch>
						 	<tr><td align="center" bgcolor="FF8080">Problem, your #Method# syntax is NOT correct!</b></td></tr>
							<tr><td align="center" bgcolor="ffffcf">#CFCatch.Message# - #CFCATCH.Detail#</td></tr>
						 </cfcatch>				 
				 	   		 
						</cftry> 
						 						 
				 </cfif>
			
			</cfif> 
 	 
	 </cfloop>	
	 
	 <cfif s eq "0">
	 
	 		<tr><td height="5"></td></tr>
	 		 <tr><td bgcolor="d3d3d3" align="center">&nbsp;<b>No scripts were found.</b></td></tr>				
	 
	 </cfif>
	
	 </table>	
		
<cfelseif url.save eq "2" or url.save eq "9"> 

    <script language="JavaScript">
        window.close()
		try {opener.history.go() } catch(e) {}
	</script>  
	
<cfelseif url.save eq "5"> 

	<cfinclude template="ActionStepEditAction.cfm">	
	
</cfif>	

</cfoutput>

