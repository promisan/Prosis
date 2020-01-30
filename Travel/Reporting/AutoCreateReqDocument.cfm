<!---
	AutoCreateReqDocument.cfm
	
	Automate creation of Request Document and pre-process Identify Rotating Personnel and Send Request to PM Steps
	
	Called by: RotationList.cfm
	
	Modification History:
	040506 - created by MM
--->

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_Replacements">

<cfset tmpTblFlag = 0>

<!--- Log through each person in batch submit page --->
<cfloop index="Rec" from="1" to="#Form.No#">

	<!--- create reference to checkbox control of current person in loop: Form.Select_n, where n is an integer --->
	<cfset field = "Form.Select_"&#Rec#>
	<cfparam name="#field#" default="0">

	<!--- evaluate if checkbox of current person --->
	<cfset x = Evaluate("Form.Select_" & #Rec#)>
	
	<!--- IF checkbox is checked --->
	<cfif #x# eq "1">

	   	<cfset Assign = Evaluate("Form.AssignNo_" & #Rec#)>
   
		<!--- Use first valid person to create temp table.  Set flag to true so you do not do this again --->
		<cfif #tmpTblFlag# NEQ 0>
			<cfquery name="CreateTmpTbl" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
			    SELECT #Assign# INTO userQuery.dbo.tmp#SESSION.acc#PM_Replacements
			</cfquery>
			<cfset tmpTblFlag = 1>
	    <cfelse>
			<cfquery name="CreateTmpTbl" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
			    INSERT #Assign# INTO userQuery.dbo.tmp#SESSION.acc#PM_Replacements
			</cfquery>		
		</cfif>
		
	</cfif>
	
</cfloop>    
		   	<!--- Get name of (submit) processing template to use from FlowActionRule table 
			<cfquery name="Rule" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
			   	SELECT * FROM FlowActionRule
			   	WHERE ActionId  = '#FORM.ActionId#'
				AND  RuleTriggerClass = 'Submit'
			</cfquery>
      
	  		<!--- If a processing template (such as SubmitIndexNo.cfm or SubmitFinal.cfm is found ... --->
			<cfif #Rule.RecordCount# EQ 1>
   
   				<!--- execute the processing template --->
				<cfmodule template="#Rule.RuleTemplate#"
				   Action   = #Form.DocumentNo#
				   Person   = #Candidate#
				   ActionId = #FORM.ActionId#>
	  
   				<!--- if completion status is ZERO (not successful), 
				      display informational message, refresh Request Details page, and exit this template --->
				<cfif #go# eq "0">			
					<cfoutput>
						<script language="JavaScript">
				    		alert("#message#");
						 	window.close();
        		     		opener.location.reload();
						</script>
					</cfoutput>
					<cfexit method="EXITTEMPLATE">
				</cfif>
				
			</cfif>   	
   
   			<!--- If processing template (if any) was SUCCESSFUL, update appropriate DocumentCandidateAction recs --->
			<cfquery name="Update" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    			UPDATE DocumentCandidateAction
    			SET 
				ActionStatus    	= '#Form.actionStatus#',
				ActionDateActual    = #DateAction#,
				ActionUserId        = '#SESSION.acc#',
				ActionLastName      = '#SESSION.last#',
				ActionFirstName     = '#SESSION.first#',	
				ActionDate          = #now()#,	
				ActionMemo          = '#Form.ActionMemo#',
				ActionReference     = '#Form.ActionReference#'
    			WHERE DocumentNo    = '#FORM.DocumentNo#'
				AND PersonNo 		= '#Candidate#'
				AND ActionId 		= '#FORM.ActionId#'
	    	</cfquery>
 
			<!--- Execute ..Template/DocumentActionNo.cfm (write to user action to log --->
			<cf_DocumentActionNo 
    		   	ActionRemarks="" 
   	   			ActionCode="ACT">  
	   
			<!--- current user session (UserActionNo) is aggregated in Parameter and value is then returned --->
			<cfset ActionNo = #UserActionNo#>

			<!--- Log action for this candidate into DocumentActionAction (for ActionHistory display) --->
	    	<cfquery name="DocumentActionAction" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
				INSERT INTO  DocumentActionAction
	    	  	(DocumentNo,
		  		PersonNo,
    	  		ActionId, 
		      	UserActionNo, 
    		  	ActionDateActual,
	  			ActionStatus)
		    	VALUES 
    		  	('#Form.DocumentNo#',
	  			'#Candidate#',
	    	  	'#Form.ActionId#',
    	  		#ActionNo#,
	      		#DateAction#,
		      	'#Form.actionStatus#')
			</cfquery> 
		
			<!--- 01May04 New code to handle auto0-processing of step(s) following current workflow step being processed --->
			<!--- Check if next step(s) to current workflow step requires auto processing. 
				  Note that the next ActionId is stored in RuleTemplate field (not really for this use but works! --->		
			<cfquery name="ChkNextStep" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		   		SELECT ActionId, RuleTemplate AS NextActionId FROM FlowActionRule
			   	WHERE ActionId  = '#Form.ActionId#'
				AND   RuleTriggerClass = 'Next'
			</cfquery>		

			<cfif #ChkNextStep.RecordCount# GT 0>
   				<!--- If current step indicates need to auto-process following step, set following step to "In-Process" --->
				<cfquery name="Update" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    				UPDATE DocumentCandidateAction
    				SET 
					ActionStatus    	= '7',
					ActionDateActual    = #DateAction#,
					ActionUserId        = '#SESSION.acc#',
					ActionLastName      = '#SESSION.last#',
					ActionFirstName     = '#SESSION.first#',	
					ActionDate          = #now()#,	
					ActionMemo          = '#Form.ActionMemo#',
					ActionReference     = '#Form.ActionReference#'
    				WHERE DocumentNo    = '#FORM.DocumentNo#'
					AND PersonNo 		= '#Candidate#'
					AND ActionId 		= '#ChkNextStep.NextActionId#'
		    	</cfquery>

				<!--- Execute ..Template/DocumentActionNo.cfm --->
				<cf_DocumentActionNo 
    			   	ActionRemarks="" 
	   	   			ActionCode="ACT">  
		   
				<!--- current user session (UserActionNo) is aggregated in Parameter and value is then returned --->
				<cfset ActionNo = #UserActionNo#>
	
				<!--- Log action for this candidate into DocumentActionAction --->
	    		<cfquery name="DocumentActionAction" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
					INSERT INTO  DocumentActionAction
		    	  	(DocumentNo,
			  		PersonNo,
	      			ActionId, 
		    	  	UserActionNo, 
	    	  		ActionDateActual,
			  		ActionStatus)
			    	VALUES 
    			  	('#Form.DocumentNo#',
	  				'#Candidate#',
	    		  	'#ChkNextStep.NextActionId#',
	    		  	#ActionNo#,
    	  			#DateAction#,
			      	'7')
				</cfquery> 

			</cfif>

		</cfif>	
   
	</cfif>  







<!---************************* init FlowClassVal field which is used by record insert query --->
<cfquery name="TravellerType" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT TravellerType FROM Ref_Category
	WHERE  Category = '#Form.Category#'
</cfquery>

<cfset flowClassVal = "">
<cfif #TravellerType.TravellerType# eq 'CIVPOL'>
	<cfif #Form.TravelBy# eq 'T'>
		<cfset flowClassVal = "3">
	<cfelse>
		<cfset flowClassVal = "4">
	</cfif>
<cfelse>
	<cfif #Form.TravelBy# eq 'T'>
		<cfset flowClassVal = "1">
	<cfelse>
		<cfset flowClassVal = "2">
	</cfif>
</cfif>

<!--- Check to see if there is any other request that is open for the same FM, PM, Class, and PlannedDeploymentDate --->
<cfquery name="Verify" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM Document
	WHERE	PermanentMissionId	= #Form.p_mission#
	AND		Mission				= '#Form.mission#'
	AND		ActionClass 		= '#flowClassVal#'
	AND		PlannedDeployment	= #Form.planneddeployment#
</cfquery>

<cfoutput>
<input type="hidden" name="mission" value="#Form.mission#">
</cfoutput>

<!--- Test no of records returned by Verify query --->
<!--- May need to revisit the WHERE clause in the Verify query --->
<CFIF #Verify.recordCount# is 1>  <!---********* START OF IF BLOCK *************************** --->
	<p>
	<p>
	<p>
	<p>
	<p>
	<hr>
	<p align="center">
	<cfoutput query = "Verify">
	<font size="2" color="77C5EA">A request to this permanent mission for the field mission and deployment date already exists!</font></p>
	<hr>
	<input type="button" value="Go to Document" onClick="javascript:showdocument(#DocumentNo#); window.close()">
	</cfoutput>	

<CFELSE>	<!---********* ELSE *************************** --->

	<cfquery name="AggregateDocNo" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE Parameter SET DocumentNo = DocumentNo+1
	</cfquery>

	<cfquery name="GetDocNo" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DocumentNo FROM Parameter
	</cfquery>

<!--- Register EnterRequest action --->
	<CF_RegisterAction 
	SystemFunctionId="1201" 
	ActionClass="Request" 
	ActionType="Enter" 
	ActionReference="#GetDocNo.DocumentNo#" 
	ActionScript="">    

<!--- init ReqDate field which is used by record insert query --->
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.requestdate#">
	<cfset ReqDate = #dateValue#>

<!--- init PlanDeploy field which is used by record insert query --->
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.planneddeployment#">
	<cfset PlanDeploy = #dateValue#>

<!--- Insert record into table DOCUMENT --->
	<cfquery name="InsertRequest" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	INSERT INTO Document
 		(DocumentNo,
		PermanentMissionId,
		Mission,
		RequestDate,
		PersonCategory,
		PersonCount,
		LevelRequired,
		Qualification,
		DutyLength,
		PlannedDeployment,
		Status,
		ActionClass,
		ReferenceNo,
		RequestType,
		Remarks,
		UsualOrigin,
		OfficerUserId,
		OfficerUserLastName,
		OfficerUserFirstName,	
		Created)
  	VALUES (#GetDocNo.DocumentNo#,
   		#Form.p_mission#,
		'#Form.mission#',
		#ReqDate#,
		'#Form.category#',
		#Form.personcount#,
		'#Form.levelrequired#',
		'#Form.qualification#',		
		#Form.dutylength#,
		#PlanDeploy#,
		'0',					<!--- '#Form.actionclass#',  MM. 16/9/03 --->
		'#flowClassVal#',
		'#Form.referenceno#',
		#Form.requesttype#,
		'#Form.remarks#',				
		#Form.usualorigin#,		
		'#SESSION.acc#',
    	'#SESSION.last#',
	  	'#SESSION.first#',
		'#DateFormat(Now(),"mm/dd/yyyy")#')
	</cfquery>
 
 <!--- Insert record into table DOCUMENTFLOW --->
	<cfquery name="InsertFlow" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">  
	INSERT INTO DocumentFlow 
  		(DocumentNo, 
		ActionId, 
		ActionDirectory, 
		ActionClass, 
	 	ActionLevel, 
		ActionType, 
		ActionArea, 
		ActionForm, 
		ActionParent, 
		ActionDescription, 
		ActionCompleted, 
		ActionReferenceShow, 
		ActionReferenceFieldName, 
		ActionOrder, 
	 	ActionOrderSub, 
		ActionLeadTime, 
		ActionResetToOrder, 
		ActionRequired, 
	 	ActionRejectDisabled, 
		ActionByPassDisabled, 
		ActionLevelTrigger, 
		ActionShowAllCandidates,
	 	ActionCandidateRevoke, 
		ActionCandidateBatch, 
		Operational)
	SELECT 
	    #GetDocNo.DocumentNo#,
		A.ActionId, 
		A.ActionDirectory, 
		A.ActionClass, 
		A.ActionLevel, 
	 	A.ActionType, 
		A.ActionArea, 
		A.ActionForm, 
		A.ActionParent, 
		A.ActionDescription, 
		A.ActionCompleted, 
		A.ActionReferenceShow, 
		A.ActionReferenceFieldName, 
		A.ActionOrder, 
	 	A.ActionOrderSub, 
		A.ActionLeadTime, 
		A.ActionResetToOrder, 
	 	A.ActionRequired, 
		A.ActionRejectDisabled, 
		A.ActionByPassDisabled, 
	 	A.ActionLevelTrigger, 
		A.ActionShowAllCandidates, 
		A.ActionCandidateRevoke, 
		A.ActionCandidateBatch, 
		A.Operational 
	FROM FlowAction A
	WHERE Operational  = '1' AND ActionClass = '#flowClassVal#'	
	</cfquery>

<!--- Hanno 02/05/03 Please add later !!!!!!!!!  AND ActionClass = '#Form.ActionClass#' --->
<!--- MM 19/08/03 ActionClass referes to the "processing paths" or "workflows", e.g.,
 1 - MD to Tvl Unit
 2 - MD to MovCon
 3 - CD to Tvl Unit
 4 - CD to MovCon
 ** The values are maintained in table FLOWCLASS **
  Therefore the code block below means: read all workflow steps that are predefined in table
  FLOWACTION which are operational for the selected processing path for this Request record 
--->
	<cfquery name="Action" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT *
	FROM FlowAction
	WHERE Operational = '1' AND ActionClass = '#flowClassVal#'
	</cfquery>
  
<!--- Initialize variables dte, and status which are to be used in the query InsertDocumentAction --->
	<cfset dte = now()>

  	<cfoutput query="action">
  
  	<cfif #ActionLeadTime# neq "">
    	 <cfset dte = DateAdd("d",  #ActionLeadTime#,  #dte#)>
	<cfelse>
    	 <cfset dte = DateAdd("d",  0,  #dte#)>
  	</cfif>
  
  	<cfif #ActionLevel# eq "0">
     	<cfset status = "0">
  	<cfelse>
     	<cfset status = "4">
  	</cfif>

<!--- Insert record into table DOCUMENTACTION --->    
  	<cfquery name="InsertDocumentAction" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
   	INSERT INTO DocumentAction
        (DocumentNo,
		ActionId,
		ActionOrder,
		ActionOrderSub,
		ActionStatus,
		ActionClass,
		ActionDatePlanning)
   VALUES ('#GetDocNo.DocumentNo#',
        '#ActionId#',
	  	'#ActionOrder#',
		'#ActionOrderSub#',
		'#Status#',
 		'#flowClassVal#',
		#dte#)
  	</cfquery>
    
	</cfoutput> 
  
	<script language="JavaScript">
		opener.location.reload();
	</script>

	<cflocation url="DocumentListing.cfm?IDP_Mission=#FORM.p_mission#"> 
	<cfoutput>
	<script language="JavaScript">
	w = 0
	h = 0
	if (screen) {
		w = screen.width - 60
		h = screen.height - 116
	}
    window.close()
    window.open("DocumentEdit.cfm?ID=#GetDocNo.DocumentNo#", "DocumentEdit", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=no");
	</script>
	</cfoutput>

</CFIF>
--->