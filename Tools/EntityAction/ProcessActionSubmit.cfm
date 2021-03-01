
<html><head><title>Process step</title>
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
</head>


<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
      SELECT OA.ActionId,
	         O.*, 
		     R.*, 
			 C.EnableEMail as ClassMail
	  FROM   OrganizationObjectAction OA
	         INNER JOIN OrganizationObject O ON OA.ObjectId = O.ObjectId
			 INNER JOIN Ref_Entity R    ON O.EntityCode  = R.EntityCode
			 INNER JOIN Ref_EntityClass C ON O.EntityCode  = C.EntityCode AND O.EntityClass = C.EntityClass      
      WHERE  ActionId = '#url.id#'  	   
</cfquery>

<cfquery name="Parameter" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM Parameter
</cfquery>

<cfif SESSION.acc eq Parameter.AnonymousUserId>

	  <cf_message message = "Action can not be processed as your identity could not be determined. Please logon again!">
	  <cfabort>

</cfif>

<!--- process step : Custom Process Mail --->
<cfparam name="FORM.ActionMemo"             default="">
<cfparam name="FORM.ActionReferenceDate"    default="">
<cfparam name="FORM.ActionReferenceNo"      default="">
<cfparam name="FORM.ActionStatus"           default="0">
<cfparam name="text"                        default="">
<cfparam name="stop"                        default="0">
<cfparam name="url.wf"                      default="1">
<cfparam name="url.windowmode"              default="window">
<cfparam name="url.submitaction"            default="">
<cfparam name="processmailexecuted"         default="0">

<cfif url.submitaction eq "saveaction">
	 <cfparam name="Form.SaveAction" default="Save">
</cfif>

<cfif url.submitaction eq "embedsave">
	 <cfparam name="Form.EmbedSave" default="Save">
</cfif>


<cfif url.wfmode eq "7">

	<cfparam name="loc"  default="">
	<cfparam name="ret"  default="back">

<cfelse>

	<cfparam name="loc" default="ProcessAction8Step.cfm?process=#URL.process#&id=#url.id#&ajaxid=#url.ajaxid#">
	<cfparam name="ret" default="ajax">
	
</cfif>	

<cfparam name="url.reload"        default="0">

<cfif Form.actionStatus eq "">

	<cf_alert message = "Action could not be determined. Please contact your administrator">	  
	<cfabort>

</cfif>

<cfif (ParameterExists(Form.Upload) or ParameterExists(Form.EmbedSave)) and url.submitaction neq "saveaction"> 

    <!--- saves the custom fields from embedded classical dialog  --->
			
	<cfset t = URL.ID>
	    <cfif Form.SaveCustom neq "">
	        <cfinclude template="../../#Form.SaveCustom#">
		</cfif>
	<cfset url.id = t>	
			
	<!--- ------------------------------------------------------------------------------------------ --->			
	<!--- conventional mode upload document text into the framework used if variable text is defined --->
	<!--- ------------------------------------------------------------------------------------------ --->
				
	<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	UPDATE OrganizationObjectAction 		
		SET    ActionMemo = '#text#' 
		WHERE  ActionId   = '#URL.ID#' 
	</cfquery>
				
	<!--- reload the action form --->
				
	<cfif url.wfmode eq "8">	
			
		<cfoutput>		     
		
			<table width="99%" align="center">
				<tr class="line"><td height="30" align="center" class="labelmedium"><font color="gray"><cf_tl id="Information was submitted"> <b>#timeformat(now(),"HH:MM")#</td></tr>				
			</table>
						
			<cfif url.submitaction eq "embedsave">
			
				<cfparam name="#client.processtab#" default="2">
				<script>				 				  			  
				  document.getElementById('menu#client.processtab#').click()				  			 		  
				</script>			
			
			<cfelse>
			
									
				<script>	
			
				   custo  = document.getElementById("formcustomfield");		
				   				  				   				   				  				  				   
				   if (custo) {
				   				      
				      document.formcustomfield.onsubmit()
					   					
					   if( _CF_error_messages.length == 0 ) {
					    	try { ptoken.navigate('ProcessActionSubmitCustom.cfm?closemode=1&windowmode=#url.windowmode#&wfmode=#url.wfmode#&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#','actionprocessbox',mycallBack(),'','POST','formcustomfield')  } catch (e) {}
					   } else {
					   	Prosis.busy('no')
					   }
					    	
				   } else {  
				   				       					
					     try { 						 
						 ptoken.navigate('ProcessActionSubmit.cfm?myentity=#url.myentity#&windowmode=#url.windowmode#&submitaction=saveaction&wfmode=#url.wfmode#&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#','actionprocessbox','','','POST','processaction') 					
						 } catch (e) {}								 
						      				   				   
				   }
				   
				</script>
		
						
			</cfif>
						
		</cfoutput>				
			
	<cfelse>
	
		<!--- refresh the screen --->
					
		<cfoutput>
			<script language="JavaScript">						   
				ptoken.location('ProcessAction.cfm?wfmode=#url.wfmode#&ajaxid=#url.ajaxid#&ID=#URL.ID#')								
			</script>
		</cfoutput>
		
	</cfif>
					
<cfelseif ParameterExists(Form.CustomDocument)> 
 		
	<!--- creates the report with the text --->
    <cfinclude template="Report/DocumentSubmit.cfm">
			
	<cfif url.wfmode eq "8">	
		
		<cfoutput>
			<script language="JavaScript">
				ptoken.location('ProcessAction.cfm?ajaxid=#url.ajaxid#&ID=#URL.ID#')
			</script>
		</cfoutput>
				
	<cfelse>
		
		<cfoutput>
			<script language="JavaScript">
				ptoken.location('ProcessAction.cfm?ajaxid=#url.ajaxid#&ID=#URL.ID#')
			</script>
		</cfoutput>
		
	</cfif>
	
<cfelseif ParameterExists(Form.SaveAction) or url.submitaction eq "saveaction">
  
	
	 <!--- 10/11/2009 correction based on invoice testing --->
	<!--- added this safe guard, that if a workflow has 
	  an auto complete first step but if the first step is not processed the step will now be reopened ---> 
		
	<!--- ----------------------------------------- --->
    <!--- check if action was not already processed --->
	<!--- ----------------------------------------- --->
				
	<cfquery name="Action" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT *
		   FROM   OrganizationObjectAction OA, 
		          Ref_EntityActionPublish P		
		   WHERE  ActionId = '#URL.ID#' 
		   AND    OA.ActionPublishNo = P.ActionPublishNo
		   AND    OA.ActionCode = P.ActionCode 		 
		 ORDER BY OfficerDate DESC 		 
	</cfquery>	
	
	<cfparam name="CLIENT.Preps" default="#now()#">
	
	<cfset actiondialog = action.actiondialog>
	<cfset actiondialogparameter = action.actiondialogparameter>
					
    <cfif Action.OfficerDate gte CLIENT.Preps and Action.ActionStatus neq "0">
	
		<cf_alert 
		   message="This document was ALREADY processed by #Action.OfficerFirstName# #Action.OfficerLastName# on #DateFormat(Action.OfficerDate,CLIENT.DateFormatShow)# at #TimeFormat(Action.OfficerDate,'HH:MM:SS')#.Document does NOT require action by you anymore."
		   align="left">
	
	      <cfabort>

	</cfif>	
		
	<cfif action.ObjectId eq "">
	
		<cf_alert 
		   message="Problem, document object does no longer exist. Please contact administrator"
		   align="left">
		
		   <cfabort>
		
	</cfif>	
	
	
	
		
	<!--- --------------------------------------- --->
	<!--- Perform general validation requirements --->
	<!--- --------------------------------------- --->
	<!--- -------- Added 28/4/2011 -------------- --->
	
	<cfinclude template="ProcessActionSubmitRules.cfm">

    <!--- --------------------------------------------- --->
    <!--- ------Save standard reference action fields-- --->
	<!--- --------------------------------------------- --->
			
	<cfif form.ActionReferenceDate neq "">
		
			<CF_DateConvert Value="#Form.ActionReferenceDate#">
			<cfset DTE = dateValue>
						
			<cfquery name="UpdateStatus" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE OrganizationObjectAction 		
			 SET    ActionReferenceDate = #DTE#  
			 WHERE  ActionId            = '#URL.ID#' 
			</cfquery>
	
	</cfif>
	
	<cfquery name="UpdateStatus" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE OrganizationObjectAction 		
		 SET    ActionReferenceNo = '#form.actionReferenceNo#' 
		 WHERE  ActionId = '#URL.ID#' 
	</cfquery>
	
	<!--- temp
	<cfoutput>			
	<input type="text" value="#URL.ID#">
	</cfoutput>
	<cfabort>
	--->
		
	<!--- --------------------------------- --->
    <!--- require reasons in case of denial --->
	<!--- --------------------------------- --->
	
    <cfif Action.EnableTextArea eq "2" and len(Form.ActionMemo) lte "5"> 

	   	<cf_alert 
		   message="You must provide a written explanation for your decision. [#len(Form.ActionMemo)# chars]"
		   return="#ret#">				   
		  
		   <cfabort>

	</cfif>	
				
	<cfif wfmode eq "7">
	
		<!--- ------------------------------------------------------------------------------------- --->
		<!--- customs defined field will be submitted as part of the submit method under the 7 mode --->
		<!--- ------------------------------------------------------------------------------------- --->	
	
		<cfinclude template="ProcessActionSubmitCustom.cfm">
	
	<cfelse>
	
		<!---  -- Tabbed mode (8): fields are saved by a separate button on the form --- --->
	
	</cfif>		
	
	<!--- --------------------------------------- --->
	<!--- Perform attachment requirements ------- --->
	<!--- --------------------------------------- --->
	<!--- -------- Added 28/4/2011 -------------- --->
	
	<cfinclude template="ProcessActionSubmitCustomAttachment.cfm">
	
	<cfquery name="Object" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#"> 
	      SELECT OA.ActionId,
		         O.*, 
			     R.*, 
				 C.EnableEMail as ClassMail
		  FROM   OrganizationObjectAction OA
		         INNER JOIN OrganizationObject O ON OA.ObjectId = O.ObjectId
				 INNER JOIN Ref_Entity R    ON O.EntityCode  = R.EntityCode
				 INNER JOIN Ref_EntityClass C ON O.EntityCode  = C.EntityCode AND O.EntityClass = C.EntityClass      
	      WHERE  ActionId = '#url.id#'  	   
	</cfquery>
			
	<cfif FORM.ActionMemo eq "" or FORM.ActionMemo eq "<p>&nbsp;</p>">						
			<cfset memotext = "">	
	</cfif>		
	
	<!--- --------------------------------- --->
    <!--- ----------custom form------------ --->
	<!--- --------------------------------- --->
			
	<cfparam name="Form.SaveCustom" default="">
	<cfparam name="Form.SaveText"   default="">
			
	<cfset Process = "1">
	
	<!--- ------------------------------------------------------------------------------------- --->
	<!--- ---custom dialog is saved but is only relevant under the 7 single screen mode ------ ---->
	<!--- ------------------------------------------------------------------------------------- --->	
				
	<cfif wfmode eq "7">
					
			<cfif Form.SaveCustom neq "">
				<cfset saveId = URL.ID>
				<cfinclude template="../../#Form.SaveCustom#">				
				<cfset url.id = saveId>
			</cfif>		
							
			<cfif Process eq "0">
				<cfabort>
			</cfif>
									
			<cfif Form.SaveText eq "1">
			
					<!--- = legacy code prior to cf8 reports catching, 
					uploads the generated text (document) as entered in a costom dialog
					which is passed a text into framework --->		
					
					<!--- example custom/dpko/vactrack/higherlevelfax/DocumentSubmit.cfm --->
			
			        <cfset memotext = text>
												
			<cfelseif FORM.ActionMemo eq "" or FORM.ActionMemo eq "<p>&nbsp;</p>">
						
					<cfset memotext = "">
														
			<cfelse>
			
					<cfset memotext = FORM.ActionMemo>					
				
			</cfif>		
			
	<cfelse>
	
		<!--- this form in in the 8 mode no longer part of the context 
		
		<cfif form.actionStatus neq "0">
		  		
			<cfset t = URL.ID>
		    <cfif Form.SaveCustom neq "">
					 
		        <cfinclude template="../../#Form.SaveCustom#">
			</cfif>
			<cfset url.id = t>				
			
		</cfif>		
		
		--->
							
	</cfif>			
	
		
	<cfparam name="memotext" default="#FORM.ActionMemo#">
		
	<!--- ---------------------------------------------------------- --->
    <!--- ----------------custom reports/documents------------------ --->
	<!--- ---------------------------------------------------------- --->		
	<!--- REFRESH the fully embedded documents that are defined ASIS ---> 
	<!--- ---------------------------------------------------------- --->
					
	<cfquery name="Documents" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionReport O INNER JOIN
               Ref_EntityDocument R ON O.DocumentId = R.DocumentId
		WHERE  ActionId   = '#URL.ID#' 
		AND    DocumentMode = 'AsIs' and DocumentLayout <> 'PDF'
		AND    Operational = 1
	</cfquery>
		
	<cfloop query="documents">
		
		<cfquery name="Signature" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityDocumentSignature
			WHERE  EntityCode = '#Object.EntityCode#'
			AND    Code       = '#Documents.SignatureBlock#' 
			AND	   Operational = 1  
		</cfquery>	
				
		<!--- parse the document 				   
		    
		  <cfquery name="Language" 
			datasource="AppsSystem">
			 	SELECT  *
			 	FROM    Ref_SystemLanguage
			 	WHERE   Code = '#documents.DocumentLanguageCode#'  
		  </cfquery> 
			
		  <cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
			   <cfset vLanguagecode = "">
		  <cfelseif documents.DocumentLanguageCode eq "">
		  	   <cfset vLanguagecode = "">
		  <cfelse>   
			   <cfset vLanguagecode  = "xl#documents.DocumentLanguageCode#_">
		  </cfif>	
		  
		  --->	
		 
		<cfset URL.Signature         = "#signature.blockline1#<br>#signature.blockline2#<br>#signature.blockline3#<br>#signature.blockline4#<br>#signature.blockline5#">
		<cfset URL.Description       = "">
		<cfset URL.DocumentFramework = "#DocumentFramework#">
		<cfset URL.DocumentTemplate  = "#DocumentTemplate#">
		<cfset URL.Language          = "#DocumentLanguageCode#">
		<cfset URL.Format            = "#DocumentFormat#">
					
		<cfsavecontent variable="text">
		
		    <cfset url.WParam = DocumentStringList>
		    <cfset URL.actionId = "#URL.ID#">
			<cfinclude template="Report/DocumentFramework.cfm"> 
						
		</cfsavecontent>	
		
		<!--- we add the custom signature block --->
		
		<cfset path = left(DocumentTemplate,len(DocumentTemplate)-4)>						
				
		<cfif FileExists("#SESSION.rootpath#\#path#_Signature.cfm")>	
										
			<cfsavecontent variable="thesignatureblock">			
				<cfinclude template="../../#path#_Signature.cfm">					
			</cfsavecontent>
												
			<cfif signatureblock neq "">			
					
					<cfset start = findNoCase("<sign>",text)> 
					<cfset start = start>
					<cfset end   = findNoCase("</sign>",text)> 
					<cfset cnt   = end-start+7>
					<cfif start gt "1" and cnt gt "1">
						<cfset prior = mid(text,start,cnt)>									
						<cfset text = replace("#text#", "#prior#", "<sign>#thesignatureblock#</sign>")>
					</cfif>
																			
			</cfif>									
					
		</cfif>		
		
		<cfif documents.DocumentStringList neq "norefresh" and len(text) gte "10">   
					
			<cfquery name="UpdateMemo" 
			 	datasource="AppsOrganization"
			 	username="#SESSION.login#" 
			 	password="#SESSION.dbpw#">
			 	UPDATE OrganizationObjectActionReport 		
			 	SET    DocumentContent = '#text#' 
			 	WHERE  ActionId        = '#URL.ID#' 
			 	AND    DocumentId      = '#DocumentId#' 
			</cfquery>
						
		</cfif>	
					
	</cfloop>	
			
	<cfset ObjectId = "#Object.ObjectId#">
	
	<cfset keyname1 = "#Object.EntityKeyField1#">
	<cfset keyname2 = "#Object.EntityKeyField2#">
	<cfset keyname3 = "#Object.EntityKeyField3#">
	<cfset keyname4 = "#Object.EntityKeyField4#">	
		
	<!--- --------screen capture feature ---------- --->
	<!--- ----- capture content of custom dialog -- --->
	<!--- ----------------------------------------- --->
		
	<cfquery name="Embed" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT D.*
	   FROM   Ref_EntityDocument D		
	   WHERE  D.DocumentCode   = '#ActionDialog#'
	   AND    D.EntityCode     = '#Object.EntityCode#'
	   AND    D.DocumentType   = 'dialog'
	   AND    D.DocumentMode   = 'Embed'  
	</cfquery>	
	
	<cfif Embed.DocumentTemplate neq "" and Embed.LogActionContent eq "1">
	    
		  <cfset url.WParam = ActionDialogParameter>
		  <!--- in case the ID value is changed in the template (req) --->
 		  <cfset tid = URL.ID>
	    
		  <cfsavecontent variable="dialogcontent">
				     
			 <cfset actionlogging = 1>
			 <cfform>
			 
			    <cfset cnt = len(Embed.DocumentTemplate)-4>
			    <cfset myfile = left(Embed.DocumentTemplate,cnt)>
			
				 <cftry>
				    <cfinclude template="../../#myfile#View.cfm"> 
				 <cfcatch>
				  	 <cfinclude template="../../#Embed.DocumentTemplate#"> 							
				 </cfcatch>
				 </cftry>				    
			 </cfform>
					 
		   </cfsavecontent>	
		   
		   <cfset url.id = tid>
		  
		 <cfset dialogcontent = "<script>$(document).ready(function() {$('input, select').attr('disabled',true);}); </script> #dialogcontent#">
		   		   
		   <cfquery name="UpdateMemo" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE OrganizationObjectAction 		
			 SET    ActionDialogContent = '#dialogcontent#' 
			 WHERE  ActionId = '#URL.ID#' 
			</cfquery>
					   		  	   
	</cfif>		
			
	<!--- ensure changes are made consistently 
	
		change of the master tables in the scripting
		change of the action status tables in OrganizationObjectAction
		adding new records to the flow --->			
	
		<cfif Form.actionStatus eq "2" or Form.actionStatus eq "2Y">
		
			    <!--- verify if access was granted on the fly --->
					   	   
			   <cfquery name="GrantAccess" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			     SELECT    ActionCode, ActionDescription, ActionAccessUsergroup
				 FROM      Ref_EntityActionPublish
				 WHERE     ActionAccess    = '#Action.ActionCode#'
				 AND       ActionPublishNo = '#Action.ActionPublishNo#'
			   </cfquery>
			  			   
		   	   <cfloop query="GrantAccess">
		   
				   <cfquery name="Prevent" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
				     SELECT *
					 FROM    OrganizationObjectActionAccess 
					 WHERE   ObjectId      = '#Object.ObjectId#'
				     AND     ActionCode    = '#ActionCode#'					
				   </cfquery>					   
				   			   
				   <cfif Prevent.recordcount eq "0">
				   
					   	<cfquery name="Check" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
					     SELECT  *
						 FROM    OrganizationAuthorization 
						 WHERE   ClassParameter = '#ActionCode#'
						 AND     Mission        = '#Object.Mission#'
						  AND     (OrgUnit      = '#Object.OrgUnit#' or OrgUnit is NULL)
						 AND     ClassIsAction = 1
						 <cfif Object.EntityGroup neq "">
						  AND     GroupParameter = '#Object.EntityGroup#' 
						</cfif>
					    </cfquery>	 
												   
					    <cfif check.recordcount eq "0">					   
						   	<cf_alert message="Problem, you must grant access to one or more users for #GrantAccess.ActionDescription# in order to proceed to the next step.">
							 <script>
							   Prosis.busy('No')
						   </script>
						    <cfabort>
						</cfif>
					
				   </cfif>	
				   
				</cfloop> 				
			   
			    <!--- define if the method condition for forwarding was met --->
			   
			    <cf_ProcessActionMethod
				    methodname       = "condition"
					location         = "text"
					ObjectId         = "#Object.ObjectId#"
					ActionId         = "#Action.ActionId#"
					actioncode       = "#Action.ActionCode#"
					actionpublishno  = "#Action.ActionPublishNo#"					
					wfmode           = "#url.wfmode#">	
			   		   
			   <cf_ProcessActionMethod
				    methodname       = "condition"
					location         = "file"
					ObjectId         = "#Object.ObjectId#"
					ActionId         = "#Action.ActionId#"
					actioncode       = "#Action.ActionCode#"
					actionpublishno  = "#Action.ActionPublishNo#"					
					wfmode           = "#url.wfmode#">	
					
			   <!--- process the submit/approve method --->								
			 			
			   <cf_ProcessActionMethod
				    methodname       = "submission"
					location         = "file"
					ObjectId         = "#Object.ObjectId#"
					ActionId         = "#Action.ActionId#"
					actioncode       = "#Action.ActionCode#"
					actionpublishno  = "#Action.ActionPublishNo#"					
					wfmode           = "#url.wfmode#">							
			 							
		</cfif>	
		
		<cfif Form.actionStatus eq "2N">	
		
				<!--- process the deny method --->		
		
				<cf_ProcessActionMethod
				    methodname       = "Deny"
					Location         = "File"
					ObjectId         = "#Object.ObjectId#"
					actioncode       = "#Action.ActionCode#"
					actionpublishno  = "#Action.ActionPublishNo#"						
					wfmode           = "#url.wfmode#">	
		
		</cfif>
		
		<!---		
		<cftry>
		--->
		
		<!--- ------------------------------------------------------------- --->
		<!--- enforce transaction only if all methods have appsOrganization --->
		<!--- redefine the object before the call 							--->
		<!--- ------------------------------------------------------------- --->

		<cfquery name="Object" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#"> 
		      SELECT O.*, 
				     R.*, 
					 C.EnableEMail as ClassMail
			  FROM   OrganizationObject O, 
				     Ref_Entity R, 
				     Ref_EntityClass C
		      WHERE  ObjectId IN ( SELECT ObjectId FROM   OrganizationObjectAction WHERE  ActionId = '#url.id#' ) 
			  AND    O.EntityCode  = R.EntityCode
			  AND    O.EntityCode  = C.EntityCode 
			  AND    O.EntityClass = C.EntityClass      
		</cfquery>
		
		<cfquery name="Check" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT DISTINCT ConditionDataSource AS DataSource
				FROM      Ref_EntityActionPublishProcess
				WHERE     ConditionDataSource <> 'AppsOrganization'
				AND       ActionPublishNo  = '#Action.ActionPublishNo#'
				UNION
				SELECT DISTINCT MethodDatasource AS DataSource
				FROM      Ref_EntityActionPublishScript
				WHERE     MethodDataSource <> 'AppsOrganization'
				AND       ActionPublishNo  = '#Action.ActionPublishNo#' 
		</cfquery>	
				
		<cfif Check.DataSource neq "" or Check.recordcount gte "2">
		
				<!--- different datasource used, preventing a transaction --->
				<cfinclude template="ProcessActionSubmitStatus.cfm">
			
		<cfelse>
		
		    <!--- only apps organization used, so you can use transaction  --->
			<cftransaction action = "begin">
				<cfinclude template="ProcessActionSubmitStatus.cfm">
			</cftransaction>
		
		</cfif>	
									
			
		<!---	
			<cfcatch>
			
		    	<cftransaction action = "rollback"/>
											    		
					 <cf_ErrorInsert
						 ErrorSource      = "CFCATCH"
						 ErrorReferer     = ""
						 ErrorDiagnostics = "#CFCatch.Message# - #CFCATCH.Detail#"
						 Email = "1">
											 								   			
					<cf_message message="An internal error has occurred and was sent to the administrator for review. <br><br><b>Your action was NOT processed!">
					
					<cfabort>
								
			</cfcatch>
							
	</cftry>
	--->	
	
	<cfquery name="NextStep" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    TOP 1 A.ActionFlowOrder 
		 FROM      OrganizationObject O INNER JOIN
		           OrganizationObjectAction A ON O.ObjectId = A.ObjectId
		 WHERE     O.ObjectId = '#Object.Objectid#' 
		 AND       A.ActionStatus = '0' 
		 AND       O.Operational  = 1  
		 ORDER BY  A.ActionFlowOrder  
	 </cfquery>	
	 
     <cfquery name="NextAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT    A.ActionCode, 
	           A.ActionPublishNo, 
			   A.OrgUnit, 
			   A.ActionFlowOrder,
			   A.ActionId
	 FROM      OrganizationObject O INNER JOIN
	           OrganizationObjectAction A ON O.ObjectId = A.ObjectId
	 WHERE     O.ObjectId        = '#Object.Objectid#' 
	 AND       A.ActionStatus    = '0' 
	 AND       A.ActionFlowOrder = '#NextStep.ActionFlowOrder#'
	 AND       O.Operational     = 1  	
	 </cfquery>	
	 
	 <cfset vDueOnJump = 0>
	 
	 <cfloop query="NextAction">	
		   
		     <cfquery name="NextCheck" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    TOP 1 *
				 FROM      Ref_EntityActionPublish
				 WHERE     ActionPublishNo = '#ActionPublishNo#' 
				 AND       ActionCode      = '#ActionCode#' 
				 ORDER BY  Created DESC 
			    </cfquery>
			    
			    <cfif NextCheck.NotificationDueOnJump eq 1>
					<cfset vDueOnJump = 1>
					<cfbreak>	
				</cfif>	
	 
	 </cfloop>
	
	<cfif Form.actionStatus eq "2" or Form.actionStatus eq "2Y" or Form.actionStatus eq "2N" or vDueOnJump eq "1">

	    <!--- define next action and send emails --->
		
		<cfif processmailexecuted eq "0">
			<cfinclude template="ProcessActionMailTrigger.cfm">
		</cfif>	
		
	<cfelse>
					
		<!--- clear if a record already exists --->
		
		<cfquery name="Clear" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM OrganizationObjectActionMail
			WHERE ObjectId      = '#Object.ObjectId#'
			AND   ActionCode    = '#Action.ActionCode#'
			AND   ActionStatus  = '9'			
		</cfquery>	
		
		<cfparam name="form.sendto"             default="">
		<cfparam name="form.sendcc"             default="">
		<cfparam name="form.actionmailsubject"  default="">
		<cfparam name="form.actionmailbody"     default="">
		<cfparam name="form.actionmailpriority" default="">
		<cfparam name="form.actionmailfrom"     default="">
		
		<cfif form.actionmailsubject neq "" or form.sendto neq "">
		
			<!--- save mail info --->
			<cfquery name="MailCheck"
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   OrganizationObjectActionMail
						WHERE  ThreadId = '#URL.ID#'
						AND    SerialNo = '1' 
			</cfquery>			
			
			<cfif MailCheck.recordcount eq 1>
				<!--- Remove --->
				<cfquery name="DeleteExistingMail"
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							DELETE FROM OrganizationObjectActionMail
							WHERE ThreadId = '#URL.ID#'
							AND   SerialNo = '1' 
				</cfquery>			
			</cfif>
			
			<cfquery name="Insert" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO OrganizationObjectActionMail (
							ThreadId, 
							SerialNo,
							ObjectId,
							ActionCode,
							ActionId, 
							MailFrom,
							MailType,
							MailTo, 
							MailCc,
							MailSubject, 
							MailBody, 
							Priority,	
							ActionStatus,					
							OfficerUserId, 
							OfficerLastName, 
							OfficerFirstName)
						VALUES (
						   '#URL.ID#',
						   '1', 
						   '#Object.ObjectId#',
						   '#Action.ActionCode#',
						   '#url.id#', 	
						   '#form.actionMailFrom#',
						   'generated',			   
						   '#form.sendto#',
						   '#form.sendcc#',
						   '#form.actionmailsubject#',
						   '#form.actionmailbody#',
						   '#form.actionmailpriority#',		
						   '8',			
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#') 
			    </cfquery>					
						
		   </cfif>
		
	</cfif>		
					
	<cfif url.ajaxid neq "">		
		
		<cfif windowmode eq "embed">
		
		  <cfoutput>
		  	<script language="JavaScript">		
				try { parent.workflowreload('#url.ajaxid#','0') } 
			    catch(e) {}			      
			   	parent.ProsisUI.closeWindow('workflowstep')
			</script>	
			 </cfoutput>	
		
		<cfelse>
		
		   <cfoutput>
		   <script language="JavaScript">
		   		   			
			try { opener.workflowreload('#url.ajaxid#','0') } 
			   catch(e) { 
			   
			  	 try { opener.history.go() }
				catch(e) {
					try {
					opener.location.reload()
					 	} catch(e) {}			
					}	
			   
			   }			
			window.close()
		   </script>
		   </cfoutput>	
		
		</cfif>				
		
	<cfelse>
	
			<script language="JavaScript">
		 		   
			  	try { opener.history.go() }
				catch(e) {
					try {
					opener.location.reload()
					 	} catch(e) {}			
					}	
			 	window.close()
				
		   </script>
		
	</cfif>
	

<!--- moved 7/7/2010 for TCP compatibility on 7 as under ajax this action was always performed
in the new code --->


<cfelseif ParameterExists(Form.EmbedSaveClose)>

	<!--- saves the custom fields from embedded classical dialog  --->
    <cfinclude template="../../#Form.SaveCustom#">
	
    <script>
		window.close() 
		try {opener.history.go()} catch(e) {}	
	</script>

<!--- please disable for cf8/9/10 full steps --->
	
<cfelseif ParameterExists(Form.Print)> 

	<!--- cf7 only --->

	<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE OrganizationObjectAction 		
		 SET    ActionMemo = '#FORM.ActionMemo#'
		 WHERE  ActionId = '#URL.ID#' 
	</cfquery>
	
	<cfoutput>
	
    	<script language="JavaScript">
	    	ptoken.location('ProcessAction.cfm?ajaxid=#url.ajaxid#&ID=#URL.ID#&Mode=Print')
    	</script>
	
	</cfoutput>

<cfelseif ParameterExists(Form.Mail)> 

	<!--- cf7 only --->

	<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE OrganizationObjectAction 		
		 SET    ActionMemo = '#FORM.ActionMemo#'
		 WHERE  ActionId = '#URL.ID#' 
	</cfquery>
	
	<cfoutput>
	
    	<script language="JavaScript">
	    	ptoken.location('ProcessAction.cfm?ajaxid=#url.ajaxid#&ID=#URL.ID#&Mode=Mail')
    	</script>
	
	</cfoutput>	

</cfif>

<!--- refresh of the [my clearances] in a none modal setup --->

<cfparam name="url.myentity" default="">

<cfif url.myentity neq "">
	<cfoutput>
		<script>			    		
			try {			   
				opener.parent.opener.document.getElementById('#url.myentity#ref').click()
				<!--- does not work properly opener.parent.close() --->
			} catch(e) {}
		</script>			
	</cfoutput>
</cfif>

